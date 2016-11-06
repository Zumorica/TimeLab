extends Node2D

signal _on_mob_change(mob)

func _ready():
	pass

func get_mob():
	return get_node("Mob")

func set_mob(mob):
	var type = typeof(mob)
	if type == TYPE_STRING:
		_set_mob_scene(mob)
	elif type == TYPE_NODE_PATH:
		_set_mob_nodepath(mob)
	elif type == TYPE_OBJECT and mob.has_method("instance"):
		_set_mob_class(mob)
	elif type == TYPE_OBJECT and not mob.has_method("instance"):
		_set_mob_node(mob)

func _set_mob_scene(scene_path):
	assert typeof(scene_path) == TYPE_STRING
	var mob_class = load(scene_path)
	_set_mob_class(mob_class)
	
func _set_mob_class(mob_class):
	assert (typeof(mob_class) == TYPE_OBJECT) and (mob_class.has_method("instance"))
	var mob = mob_class.instance()
	_set_mob_node(mob)
	
func _set_mob_nodepath(mob_nodepath):
	assert typeof(mob_nodepath) == TYPE_NODE_PATH
	var mob = get_node(mob_nodepath)
	_set_mob_node(mob)
	
func _set_mob_node(mob_node):
	assert (typeof(mob_node) == TYPE_OBJECT) and not (mob_node.has_method("instance"))
	if mob_node.get_parent():
		mob_node.get_parent().remove_child(mob_node)
	mob_node.set_name("Mob")
	add_child(mob_node)
	