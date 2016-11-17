class Map:
	extends Node2D
	
	const TILE = "tile"
	const OBJ = "obj"
	const ITEM = "item"
	const MOB = "mob"
	
	const TILE_BASE = preload("res://src/tile/tile.gd")
	const OBJ_BASE = preload("res://src/obj/obj.gd")
	const ITEM_BASE = preload("res://src/item/item.gd")
	const MOB_BASE = preload("res://src/mob/mob.gd")
	
	const BLUE_FLOOR = 1
	const GREY_WALL = 2
	
	const HUMAN_MOB = 1
	
	const TILES = {1 : preload("res://src/tile/floor/blue.tscn"),
				   2 : preload("res://src/tile/wall/grey.tscn")}
	
	const MOBS = {1 : preload("res://src/mob/living/human/human.tscn")}
	
	const OBJS = {}
	
	const ITEMS = {}
	
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
		
	func _save_instance_variables(instance):
		assert (typeof(instance) == TYPE_OBJECT)
		var variables = {}
		for i in instance.get_property_list():
			variables[i["name"]] = instance.get(i["name"])
		return variables
		
	func _load_instance_variables(variables, instance):
		assert (typeof(variables) == TYPE_DICTIONARY)
		assert (typeof(instance) == TYPE_OBJECT)
		for variable in variables.keys():
			instance.set(variable, variables[variable])
		return
		
	func _create_tile(tile):
		# Do not call this function directly.
		assert (typeof(tile) == TYPE_DICTIONARY)
		assert (tile["type"] == TILE)
		var instanced_tile = TILES[tile["ID"]].instance()
		instanced_tile.set_pos(map_pos_to_px(Vector2(tile["x"], tile["y"]), true))
		_load_instance_variables(tile["variables"], instanced_tile)
		return instanced_tile
		
	func _create_object(obj):
		# Do not call this function directly.
		assert (typeof(obj) == TYPE_DICTIONARY)
		assert (obj["type"] == OBJ)
		var instanced_obj = OBJS[obj["ID"]].instance()
		instanced_obj.set_pos(map_pos_to_px(Vector2(obj["x"], obj["y"]), true))
		_load_instance_variables(obj["variables"], instanced_obj)
		return instanced_obj
		
	func _create_item(item):
		# Do not call this function directly.
		assert (typeof(item) == TYPE_DICTIONARY)
		assert (item["type"] == ITEM)
		var instanced_item = ITEMS[item["ID"]].instance()
		instanced_item.set_pos(map_pos_to_px(Vector2(item["x"], item["y"]), true))
		_load_instance_variables(item["variables"], instanced_item)
		return instanced_item
		
	func _create_mob(mob):
		# Do not call this function directly.
		assert (typeof(mob) == TYPE_DICTIONARY)
		assert (mob["type"] == MOB)
		var instanced_mob = MOBS[mob["ID"]].instance()
		instanced_mob.set_pos(map_pos_to_px(Vector2(mob["x"], mob["y"]), true))
		_load_instance_variables(mob["variables"], instanced_mob)
		return instanced_mob
		
	func create_instance_from_data_entry(data):
		if data["type"] == TILE:
			return _create_tile(data)
		elif data["type"] == OBJ:
			return _create_object(data)
		elif data["type"] == ITEM:
			return _create_item(data)
		elif data["type"] == MOB:
			return _create_mob(data)
		else:
			return
		
	func _process_tile(instanced_tile):
		# Do not call this function directly.
		assert (typeof(instanced_tile) == TYPE_OBJECT)
		assert (instanced_tile extends TILE_BASE)
		var tile_data = {"type" : TILE}
		var map_pos = px_pos_to_map(instanced_tile.get_pos())
		tile_data["ID"] = instanced_tile.get_ID()
		tile_data["x"] = map_pos.x
		tile_data["y"] = map_pos.y
		tile_data["variables"] = _save_instance_variables(instanced_tile)
		return tile_data
		
	func _process_obj(instanced_obj):
		# Do not call this function directly.
		assert (typeof(instanced_obj) == TYPE_OBJECT)
		assert (instanced_obj extends OBJ_BASE)
		var obj_data = {"type" : OBJ}
		var map_pos = px_pos_to_map(instanced_obj.get_pos())
		obj_data["ID"] = instanced_obj.get_ID()
		obj_data["x"] = map_pos.x
		obj_data["y"] = map_pos.y
		obj_data["variables"] = _save_instance_variables(instanced_obj)
		return obj_data
		
		
	func _process_item(instanced_item):
		# Do not call this function directly.
		assert (typeof(instanced_item) == TYPE_OBJECT)
		assert (instanced_item extends ITEM_BASE)
		var item_data = {"type" : ITEM}
		var map_pos = px_pos_to_map(instanced_item.get_pos())
		item_data["ID"] = instanced_item.get_ID()
		item_data["x"] = map_pos.x
		item_data["y"] = map_pos.y
		item_data["variables"] = _save_instance_variables(instanced_item)
		return item_data
		
		
	func _process_mob(instanced_mob):
		# Do not call this function directly.
		assert (typeof(instanced_mob) == TYPE_OBJECT)
		assert (instanced_mob extends MOB_BASE)
		var mob_data = {"type" : MOB}
		var map_pos = px_pos_to_map(instanced_mob.get_pos())
		mob_data["ID"] = instanced_mob.get_ID()
		mob_data["x"] = map_pos.x
		mob_data["y"] = map_pos.y
		mob_data["variables"] = _save_instance_variables(instanced_mob)
		return mob_data
		
	func create_data_from_instance(instance):
		if instance extends TILE_BASE:
			pass
		elif instance extends OBJ_BASE:
			pass
		elif instance extends ITEM_BASE:
			pass
		elif instance extends MOB_BASE:
			pass
		
	func create_map(original = true):
		for child in get_children():
			child.queue_free()
		if original:
			for tile in data:
				add_child(create_instance_from_data_entry(tile))
		else:
			for tile in _updated_data:
				add_child(create_instance_from_data_entry(tile))

	func update_data():
		_updated_data = []
		for child in get_children():
			_updated_data.append(_process_children(child))
		return _updated_data
		
	func get_data(original = false):
		if original:
			return data
		else:
			return update_data()
		
class MapHandler:
	extends Object
	
	func get_map(map):
		if typeof(map) == TYPE_STRING:
			return _get_map_from_string(map)
		elif (typeof(map) == TYPE_OBJECT):
			return _get_map_from_class(map)
		elif (typeof(map) == TYPE_ARRAY):
			return _get_map_from_list(map)
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
		
	func _get_map_from_list(map_data):
		# Do not call this function directly.
		assert (typeof(map_data) == TYPE_ARRAY)
		var map = load("res://src/map/map.gd").Map.new()
		map.data = map_data
		return map