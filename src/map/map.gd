class Map:
	extends Area2D
	
	const TILE = "tile"
	const OBJ = "obj"
	const ITEM = "item"
	const MOB = "mob"
	const ENTITY = "entity"
	
	const TILE_BASE = preload("res://src/tile/tile.gd")
	const OBJ_BASE = preload("res://src/obj/obj.gd")
	const ITEM_BASE = preload("res://src/item/item.gd")
	const MOB_BASE = preload("res://src/mob/mob.gd")
	const ENTITY_BASE = preload("res://src/entity/entity.gd")
	
	const BLUE_FLOOR = 1
	const GREY_WALL = 2
	
	const HUMAN_MOB = 1
	
	const SPAWN_POINT = 1
	
	const TILES = {1 : preload("res://src/tile/floor/blue.tscn"),
				   2 : preload("res://src/tile/wall/grey.tscn")}
	
	const MOBS = {1 : preload("res://src/mob/living/human/human.tscn")}
	
	const OBJS = {}
	
	const ITEMS = {}
	
	const ENTITIES = {1 : preload("res://src/entity/spawn/spawn.tscn")}
	
	var map_size = Vector2(32, 32)
	var data = []
	var _updated_data = []
	
	
	func _ready():
		set_name("Map")
		set_pickable(true)
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.set_extents(map_pos_to_px(map_size + Vector2(1,1)))
		collision.set_shape(shape)
		collision.set_name("CollisionShape2D")
		add_child(collision)
		
	func map_pos_to_px(vector, central = false):
		if central:
			return Vector2(vector.x * 32 + 16, vector.y * 32 + 16)
		else:
			return Vector2(vector.x * 32, vector.y * 32)
		
	func px_pos_to_map(vector):
		return Vector2(int(vector.x / 32), int(vector.y / 32))
		
	func check_entry_in_data(position = false, ID = false, type = false, original = false, update = false):
		var list = []
		var _data
		if update:
			update_data()
		if original:
			_data = data
		else:
			_data = _updated_data
		for entry in _data:
			if typeof(position) == TYPE_VECTOR2:
				if position == Vector2(entry["x"], entry["y"]):
					pass
				else:
					continue
			if ID:
				if ID == entry["ID"]:
					pass
				else:
					continue
			if type:
				if type == entry["type"]:
					pass
				else:
					continue
			list.append(entry)
		return list
		
	func add_child_from_data(data):
		assert (typeof(data) == TYPE_DICTIONARY)
		var instance = create_instance_from_data_entry(data)
		if typeof(instance) == TYPE_OBJECT:
			add_child(instance)
			update_data()
		
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
		
	func create_instance_from_data_entry(data):
		assert (typeof(data) == TYPE_DICTIONARY)
		var dict
		if data["type"] == TILE:
			dict = TILES
		elif data["type"] == OBJ:
			dict = OBJS
		elif data["type"] == ITEM:
			dict = ITEMS
		elif data["type"] == MOB:
			dict = MOBS
		elif data["type"] == ENTITY:
			dict = ENTITIES
		else:
			return
		var instanced = dict[data["ID"]].instance()
		instanced.set_pos(map_pos_to_px(Vector2(data["x"], data["y"]), true))
		_load_instance_variables(data["variables"], instanced)
		return instanced
		
	func create_data_from_instance(instanced):
		assert (typeof(instanced) == TYPE_OBJECT)
		var type
		if instanced extends TILE_BASE:
			type = TILE
		elif instanced extends OBJ_BASE:
			type = OBJ
		elif instanced extends ITEM_BASE:
			type = ITEM
		elif instanced extends MOB_BASE:
			type = MOB
		elif instanced extends ENTITY_BASE:
			type = ENTITY
		elif instanced extends Camera2D:
			return
		elif instanced extends CollisionShape2D:
			return
		var map_pos = px_pos_to_map(instanced.get_pos())
		var data = {"type" : type, "ID" : instanced.get_ID(), "x" : map_pos.x, "y" : map_pos.y, "variables" : _save_instance_variables(instanced)}
		return data
		
	func create_map(original = true, keep_special_nodes = true):
		for child in get_children():
			if not keep_special_nodes:
				child.queue_free()
			else:
				if child extends Camera2D:
					continue
				elif child extends CollisionShape2D:
					continue
				child.queue_free()
		if original:
			for tile in data:
				add_child(create_instance_from_data_entry(tile))
		else:
			update_data()
			for tile in _updated_data:
				add_child(create_instance_from_data_entry(tile))

	func update_data():
		_updated_data = []
		for child in get_children():
			var d = create_data_from_instance(child)
			if typeof(d) == TYPE_DICTIONARY:
				_updated_data.append(d)
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