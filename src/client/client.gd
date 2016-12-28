extends Node2D

signal on_mob_change(new_mob, old_mob)

remote var info = {}
var mob = null setget get_mob,set_mob
var active_camera = null setget get_active_camera,set_active_camera
var network_id setget get_ID,set_ID

func _ready():
	add_to_group("clients")
	if is_client():
		set_process_input(true)

remote func send_info(id):
	rset_id(id, "info", info)

func request_info():
	rpc("send_info", get_node("/root/timeline").get_current_client().get_ID())

func configure_network_mode(mode):
	if mode == NETWORK_MODE_MASTER:
		set_network_mode(NETWORK_MODE_MASTER)
		if get_mob():
			get_mob().set_network_mode(NETWORK_MODE_MASTER)
	else:
		set_network_mode(NETWORK_MODE_SLAVE)
		if get_mob():
			get_mob().set_network_mode(NETWORK_MODE_SLAVE)

func get_ID():
	if is_network_master():
		return get_tree().get_network_unique_id()
	else:
		return network_id

func set_ID(id):
	network_id = id
	set_name(str(id))

func get_active_camera():
	return active_camera
	
func set_active_camera(camera):
	if camera != null:
		assert typeof(camera) == TYPE_OBJECT and camera extends Camera2D
		if is_client():
			camera.make_current()
		active_camera = camera
	else:
		if active_camera and is_client():
			active_camera.clear_current()
		active_camera = null

func is_client():
	"""This function returns true if currently the code is being
	   executed by this client's owner."""
	if get_node("/root/timeline").is_online:
		return (str(get_ID()) == str(get_tree().get_network_unique_id()))
	else:
		return true
	
func get_mob():
	return mob

sync func set_mob(mob):
	"""This function changes client's mob.
	   It can take one argument, and it can
	   be either a nodepath or a node."""
	var type = typeof(mob)
	if type == TYPE_NODE_PATH:
		return _set_mob_nodepath(mob)
	elif type == TYPE_OBJECT and mob extends get_node("/root/timeline").element_base:
		return _set_mob_node(mob)
	elif type == TYPE_NIL:
		emit_signal("on_mob_change", null, mob)
		mob = null
		var camera = get_active_camera()
		if camera:
			if is_client():
				get_active_camera().clear_current()
			set_active_camera(null)
	else:
		return false
	
func _set_mob_nodepath(mob_nodepath):
	# Do not call this function directly.
	assert typeof(mob_nodepath) == TYPE_NODE_PATH
	var mob = get_node(mob_nodepath)
	if mob extends get_node("/root/timeline").element_base:
		return _set_mob_node(mob)
	else:
		return false
	
func _set_mob_node(mob_node):
	# Do not call this function directly.
	assert (typeof(mob_node) == TYPE_OBJECT) and not (mob_node.has_method("instance"))
	emit_signal("on_mob_change", mob_node, mob)
	mob = mob_node
	mob._set_client(self)
	if is_client():
		mob.set_network_mode(NETWORK_MODE_MASTER)
	else:
		mob.set_network_mode(NETWORK_MODE_SLAVE)
	if mob.has_node("Camera2D"):
		set_active_camera(mob.get_node("Camera2D"))
	else:
		var camera = Camera2D.new()
		camera.set_name("Camera2D")
		camera.add_to_group("cameras")
		mob.add_child(camera)
		set_active_camera(mob.get_node("Camera2D"))
	return true