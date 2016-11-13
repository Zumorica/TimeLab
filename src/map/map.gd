const BLUE_FLOOR = 1
const GREY_WALL = 2

const TILES = {1 : preload("res://src/tile/floor/blue.tscn"),
			   2 : preload("res://src/tile/wall/grey.tscn")}

class Map:
	extends Node2D
	
	var data = []
	
	func _ready():
		set_name("Map")
		create_map()
		
	func map_pos_to_px(vector, central = false):
		if central:
			return Vector2(vector.x * 32 + 16, vector.y * 32 + 16)
		else:
			return Vector2(vector.x * 32, vector.y * 32)
		
	func px_pos_to_map(vector):
		return Vector2(int(vector.x / 32), int(vector.y / 32))
		
	func create_map():
		for tile in data:
			var ins_tile = TILES[tile["tile"]].instance()
			var px_pos = map_pos_to_px(tile["x"], tile["y"])
			ins_tile.set_pos(px_pos)
			for variable in tile["variables"].keys():
				ins_tile._set("variable", tile["variables"][variable])

class MapHandler:
	extends Object
	
	func get_map(map):
		if typeof(map) == TYPE_STRING:
			return _get_map_from_string(map)
		elif (typeof(map) == TYPE_OBJECT):
			return _get_map_from_class(map)
		return false
		
	func _get_map_from_string(map_string):
		# Do not call this function directly.
		assert (typeof(map_string) == TYPE_STRING)
		var map = load(map_string).new()
		if map extends Map:
			return map
		return false
		
	func _get_map_from_class(map_class):
		# Do not call this function directly.
		assert (typeof(map_class) == TYPE_OBJECT and map_class.has_method("instance"))
		var map = map_class.instance()
		if map extends Map:
			return map
		return false