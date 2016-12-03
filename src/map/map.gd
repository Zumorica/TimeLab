class Map:
	extends Area2D
	
	const TILE = "tile"
	const OBJ = "obj"
	const ITEM = "item"
	const MOB = "mob"
	const ENTITY = "entity"
	const ELEMENT = "element"
	
	const TILE_BASE = preload("res://src/tile/tile.gd")
	const OBJ_BASE = preload("res://src/obj/obj.gd")
	const ITEM_BASE = preload("res://src/item/item.gd")
	const MOB_BASE = preload("res://src/mob/mob.gd")
	const ENTITY_BASE = preload("res://src/entity/entity.gd")
	const ELEMENT_BASE = preload("res://src/element/element.gd")
	
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
	
	var viewable_z = 0 setget set_current_floor,get_current_floor
	var _map_size = Vector3(32, 32, 2) setget change_map_size,get_map_size
	onready var _map_size_2 = Vector2(_map_size.x, _map_size.y) setget ,get_map_size2
	var _orig_data = [] setget ,get_original_mapdata
	var _updated_data = [] setget update_mapdata,get_updated_mapdata
	var _grid = [] setget update_grid,get_grid
	var is_map_initiated = false
	
	func update_mapdata():
		_updated_data = populate_multidimensional_list(get_map_size())
		for z in get_children():
			for child in z.get_children():
				var entry = create_data_from_instance(child)
				var cpos = child.get_pos3()
				var mpos = px_pos_to_map(cpos)
				var msize = get_map_size()
				if (mpos.x <= msize.x - 1 and mpos.x >= 0) and (mpos.y <= msize.y - 1 and mpos.y >= 0) and (cpos.z <= msize.z and cpos.z >= 0):
					if typeof(entry) == TYPE_DICTIONARY:
						_updated_data[entry["position"].x][entry["position"].y][entry["position"].z] = entry
				else:
					child.queue_free()
					
	func update_grid():
		_grid = populate_multidimensional_list(get_map_size())
		for z in get_children():
			for child in z.get_children():
				var cpos = child.get_pos3()
				var mpos = px_pos_to_map(cpos)
				var msize = get_map_size()
				if (mpos.x <= msize.x and mpos.x >= 0) and (mpos.y <= msize.y and mpos.y >= 0) and (cpos.z <= msize.z and cpos.z >= 0):
					_grid[mpos.x][mpos.y][cpos.z] = child
				else:
					child.queue_free()
				
	func populate_multidimensional_list(vector):
		var list = []
		for x in range(0, vector.x + 1):
			list.append([])
			for y in range(0, vector.y + 1):
				list[x].append([])
				for z in range(0, vector.z + 1):
					list[x][y].append([])
		return list
		
	func populate_lists():
		var size = get_map_size()
		var list = populate_multidimensional_list(size)
		_orig_data = list
		_updated_data = list
		_grid = list
	
	func get_original_mapdata():
		return _orig_data
	
	func get_updated_mapdata():
		return _updated_data
	
	func set_current_floor(z):
		if z <= get_map_size().z:
			viewable_z = z
			for child in get_children():
				child.hide()
			get_node("%s" %(z)).show()
		
	func get_current_floor():
		return viewable_z
	
	func get_map_size():
		return _map_size
		
	func change_map_size(new_size):
		var old_size = get_map_size()
		if new_size != old_size:
			_map_size = new_size
			populate_lists()
			update_grid()
			update_mapdata()
			_orig_data = get_updated_mapdata()
		
	func get_map_size2():
		return Vector2(_map_size.x, _map_size.y)
		
	func get_grid():
		return _grid
	
	func _ready():
		assert typeof(_map_size) == TYPE_VECTOR3
		set_name("Map")
		set_pickable(true)
		set_process(true)
		set_process_input(true)
		
	func _process(dt):
		update_grid()
		
	func map_pos_to_px(vector, central = false):
		if central:
			return Vector2(vector.x * 32 + 16, vector.y * 32 + 16)
		else:
			return Vector2(vector.x * 32, vector.y * 32)
		
	func px_pos_to_map(vector):
		return Vector2(int(vector.x / 32), int(vector.y / 32))
		
	func find(position = false, ID = false, type = false):
		var list = []
		for z in get_children():
			for child in z.get_children():
				if child extends ELEMENT_BASE:
					if typeof(position) == TYPE_VECTOR3:
						if position == child.get_pos3():
							pass
						else:
							continue
					elif typeof(position) == TYPE_VECTOR2:
						if position == child.get_pos():
							pass
						else:
							continue
					if typeof(ID) == TYPE_INT:
						if ID == child.get_ID():
							pass
						else:
							continue
					if typeof(type) == TYPE_STRING:
						var lower = type.lower()
						if lower == TILE and child extends TILE_BASE:
							pass
						elif lower == ITEM and child extends ITEM_BASE:
							pass
						elif lower == MOB and child extends MOB_BASE:
							pass
						elif lower == OBJ and child extends OBJ_BASE:
							pass
						elif lower == ENTITY and child extends ENTITY_BASE:
							pass
						else:
							continue
					list.append(child)
		return list
		
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
		
	func add_child_from_data(data, loadvars=true):
		if (typeof(data) == TYPE_DICTIONARY):
			var instance = create_instance_from_data_entry(data, loadvars)
			if typeof(instance) == TYPE_OBJECT and instance extends ELEMENT_BASE:
				get_node(str(instance.get_floor())).add_child(instance)
		
	func create_instance_from_data_entry(data, loadvars=true):
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
		instanced.set_pos(map_pos_to_px(Vector2(data["position"].x, data["position"].y), true))
		instanced.z_floor = data["position"].z
		if loadvars:
			_load_instance_variables(data["variables"], instanced)
		return instanced
		
	func create_data_from_instance(instanced):
		assert (typeof(instanced) == TYPE_OBJECT)
		var type
		if not instanced extends ELEMENT_BASE:
			return false
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
		var map_pos = px_pos_to_map(instanced.get_pos())
		var data = {"type" : type, "ID" : instanced.get_ID(), "position" : Vector3(map_pos.x, map_pos.y, instanced.get_floor()), "variables" : _save_instance_variables(instanced)}
		return data
		
	func initial_map_preparation():
		for child in get_children():
			if child extends ELEMENT_BASE:
				child.queue_free()
		for z in range(0, get_map_size().z + 1):
			var node = Node2D.new()
			node.set_name(str(z))
			node.hide()
			add_child(node)
		get_node("0").show()
		for z in get_original_mapdata():
			for x in z:
				for y in z:
					for entry in y:
						add_child_from_data(entry, false)
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.set_extents(map_pos_to_px(get_map_size2() + Vector2(1,1)))
		collision.set_shape(shape)
		collision.set_name("CollisionShape2D")
		add_child(collision)
		is_map_initiated = true
			
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
		var map = load("res://src/map/map.gd").Map.new()
		var fmap = File.new()
		fmap.open(map_string, File.READ)
		var vari = fmap.get_var()
		map._orig_data = vari
		return map
		
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
		map._orig_data = map_data
		return map