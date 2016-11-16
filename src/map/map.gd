class Map:
	extends Node2D
	
	const BLUE_FLOOR = 1
	const GREY_WALL = 2
	
	const TILES = {1 : preload("res://src/tile/floor/blue.tscn"),
				   2 : preload("res://src/tile/wall/grey.tscn")}
			
	var data = []
	var _updated_data = []
	
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
		
	func _process_tile(tile):
		var ins_tile = TILES[tile["tile"]].instance()
		var px_pos = map_pos_to_px(Vector2(tile["x"], tile["y"]), true)
		ins_tile.set_pos(px_pos)
		for variable in tile["variables"].keys():
			ins_tile.set(variable, tile["variables"][variable])
		return ins_tile
		
	func _process_children(child):
		var tile = {"tile" : 0, "x" : 0, "y" : 0, "variables" : {}}
		for key in TILES.keys():
			if child extends TILES[key]:
				tile["tile"] = key
		var tpos = px_pos_to_map(child.get_pos())
		tile["x"] = tpos.x
		tile["y"] = tpos.y
		for i in get_property_list():
			tile["variables"][i["name"]] = get(i["name"])
		return tile
		
	func create_map(original = true):
		for child in get_children():
			child.queue_free()
		if original:
			for tile in data:
				add_child(_process_tile(tile))
		else:
			for tile in _updated_data:
				add_child(_process_tile(tile))

	func update_data():
		_updated_data = []
		for child in get_children():
			_updated_data.append(_process_children(child))
		
class MapHandler:
	extends Object
	
	const BLUE_FLOOR = 1
	const GREY_WALL = 2
	
	const TILES = {1 : preload("res://src/tile/floor/blue.tscn"),
				   2 : preload("res://src/tile/wall/grey.tscn")}
	
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
		if map.has_method("create_map"):
			return map
		return false
		
	func _get_map_from_class(map_class):
		# Do not call this function directly.
		assert (typeof(map_class) == TYPE_OBJECT and map_class.has_method("instance"))
		var map = map_class.instance()
		if map extends Map:
			return map
		return false