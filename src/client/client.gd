extends Node2D

signal _on_mob_change(mob)
signal _on_client_input(event)

var network_id = 1

func _ready():
	set_mob("res://src/mob/living/human/human.tscn")
	add_to_group("clients")
	if is_client():
		set_process_input(true)

func _input(event):
	if is_network_master() and get_mob():
		emit_signal("_on_client_input", event)

func configure_network_mode(mode):
	if mode == NETWORK_MODE_MASTER:
		set_network_mode(NETWORK_MODE_MASTER)
		get_mob().set_network_mode(NETWORK_MODE_MASTER)
	else:
		set_network_mode(NETWORK_MODE_SLAVE)
		get_mob().set_network_mode(NETWORK_MODE_SLAVE)

func get_ID():
	return network_id

func set_ID(id):
	network_id = id

func is_client():
	"""This function returns true if currently the code is being
	   executed by this client's owner."""
	return (str(get_ID()) == str(get_tree().get_network_unique_id()))
	
func get_mob():
	#This function returns client's current mob.
	if has_node("Mob"):
		return get_node("Mob")
	else:
		return false

sync func set_mob(mob):
	"""This function changes client's mob.
	   It can take one argument, and it can
	   be either the path to a scene, a nodepath,
	   a node, or a class."""
	if get_mob():
		disconnect("_on_client_input", get_mob(), "_on_client_input")
	var type = typeof(mob)
	if type == TYPE_STRING:
		_set_mob_scene(mob)
	elif type == TYPE_NODE_PATH:
		_set_mob_nodepath(mob)
	elif type == TYPE_OBJECT and mob.has_method("instance"):
		_set_mob_class(mob)
	elif type == TYPE_OBJECT and not mob.has_method("instance"):
		_set_mob_node(mob)
	else:
		return
	connect("_on_client_input", get_mob(), "_on_client_input")
	
func _set_mob_scene(scene_path):
	# Do not call this function directly.
	assert typeof(scene_path) == TYPE_STRING
	var mob_class = load(scene_path)
	_set_mob_class(mob_class)
	
func _set_mob_class(mob_class):
	# Do not call this function directly.
	assert (typeof(mob_class) == TYPE_OBJECT) and (mob_class.has_method("instance"))
	var mob = mob_class.instance()
	_set_mob_node(mob)
	
func _set_mob_nodepath(mob_nodepath):
	# Do not call this function directly.
	assert typeof(mob_nodepath) == TYPE_NODE_PATH
	var mob = get_node(mob_nodepath)
	_set_mob_node(mob)
	
func _set_mob_node(mob_node):
	# Do not call this function directly.
	assert (typeof(mob_node) == TYPE_OBJECT) and not (mob_node.has_method("instance"))
	if mob_node.get_parent():
		mob_node.get_parent().remove_child(mob_node)
	mob_node.set_name("Mob")
	add_child(mob_node)
	emit_signal("_on_mob_change", mob_node)
	