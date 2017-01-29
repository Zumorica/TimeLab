extends KinematicBody2D

signal on_game_start()
signal on_direction_change(direction)
signal on_collided(collider)	# When something collides with the element.
signal on_collide(collider)		# When the element collides with something.
signal on_clicked()
signal on_interacted(other, item)	# When this node is interacted by another one.
signal on_attack(other)		# When this node attacks another node.
signal on_client_change(client) # Called when this element's client is changed.

export var show_name = "Unknown"
export var description = "[REDACTED]"
export(int, "NORTH", "SOUTH", "WEST", "EAST") remote var direction = 0
export(bool) var is_movable = true
export(int, FLAGS) remote var state = 0
export(int) var interact_range = 100
export(int, "Neutral", "Male", "Female") var gender = s_gender.NEUTRAL
export(bool) var opaque = false
var verbs = {"Examine" : "examine_element"}

onready var orig_name = get_name()
var client = null setget get_client,_set_client # Do not change from this node. Call set_mob from client instead.

func _init():
	rset_config("show_name", RPC_MODE_REMOTE)
	rset_config("opaque", RPC_MODE_REMOTE)

func _ready():
	if not is_in_group("elements"):
		add_to_group("elements")
	if get_pause_mode() != PAUSE_MODE_STOP:
		set_pause_mode(PAUSE_MODE_STOP)
	if not is_pickable():
		set_pickable(true)
	if not is_fixed_processing():
		set_fixed_process(true)
	if not is_processing_input():
		set_process_input(true)
	set_collision_margin(0.0)
	rpc_config("emit_signal", RPC_MODE_SYNC)
	if not timeline.right_click_menu.is_connected("item_pressed", self, "verb_pressed"):
		timeline.right_click_menu.connect("item_pressed", self, "verb_pressed")
	if not is_connected("on_clicked", self, "_on_clicked"):
		connect("on_clicked", self, "_on_clicked")
	if not is_connected("input_event", self, "_input_event"):
			connect("input_event", self, "_input_event")
	update_opacity()

sync func update_opacity(old_pos=null):
	if has_node("/root/Map/Sight/Bitmap"):
		var bitmap = get_node("/root/Map/Sight/Bitmap")
		var mappos = bitmap.world_to_map(get_pos())
		if opaque:
			bitmap.set_cell(mappos.x, mappos.y, 0)
		else:
			bitmap.set_cell(mappos.x, mappos.y, -1)
		if typeof(old_pos) == TYPE_VECTOR2:
			bitmap.set_cell(old_pos.x, old_pos.y, -1)
	
func examine_element():
	timeline.get_current_client().update_chat(description)

func is_opaque():
	return opaque
	
func set_opacity(is_opaque):
	opaque = is_opaque
	rset("opaque", is_opaque)
	rpc("update_opacity")

func get_client():
	return client

sync func _set_client(new_client):
	emit_signal("on_client_change", new_client)
	if client and new_client != null:
		client.set_mob(null)
	client = new_client
	if client != null:
		set_name(str(client.get_ID()))
	else:
		set_name(orig_name)

func reset_attack_timer():
	if ((state & s_flag.CANT_ATTACK) == s_flag.CANT_ATTACK):
		rset("state", state ^ s_flag.CANT_ATTACK)
		state ^= s_flag.CANT_ATTACK

func _on_clicked():
	var cmob = timeline.get_current_client().get_mob()
	var item = cmob.get_node("Layer/Inventory").get_item("RHandSlot")
	if cmob:
		if cmob extends s_base.mob:
			var intention = cmob.get_intent()
			if intention  == s_intent.INTERACT:
				if item:
					rpc("emit_signal", "on_interacted", str(cmob.get_path()), item.get_path())
				else:
					rpc("emit_signal", "on_interacted", str(cmob.get_path()), false)
			elif intention == s_intent.ATTACK:
				if cmob.has_node("Attack"):
					cmob.get_node("Attack").attack(self)
			elif intention == s_intent.USE_ITEM:
				if item:
					item.rpc("emit_signal", "on_used", self, cmob)

func _fixed_process(dt):
	if timeline.is_online:
		if self extends KinematicBody2D:
			if is_network_master() and timeline.get_current_client().get_mob() == self and !timeline.get_current_client().get_node("UserInterface").is_chat_visible:
				var old_direction = direction
				if not (state & s_flag.CANT_WALK) and not (state & s_flag.DEAD):
					if Input.is_action_pressed("ui_up"):
						get_node("Movement").move_tiles(s_direction.index[s_direction.NORTH], true)
						direction = s_direction.NORTH
					if Input.is_action_pressed("ui_down"):
						get_node("Movement").move_tiles(s_direction.index[s_direction.SOUTH], true)
						direction = s_direction.SOUTH
					if Input.is_action_pressed("ui_left"):
						get_node("Movement").move_tiles(s_direction.index[s_direction.WEST], true)
						direction = s_direction.WEST
					if Input.is_action_pressed("ui_right"):
						get_node("Movement").move_tiles(s_direction.index[s_direction.EAST], true)
						direction = s_direction.EAST
					if Input.is_action_pressed("debug_interact_intent"):
						set_intent(s_intent.INTERACT)
						print("Interact intent set.")
					if Input.is_action_pressed("debug_attack_intent"):
						set_intent(s_intent.ATTACK)
						print("Attack intent set.")
					if Input.is_action_pressed("debug_useitem_intent"):
						set_intent(s_intent.USE_ITEM)
						print("Use item intent set.")
					if old_direction != direction:
						rset("direction", direction)
						rpc("emit_signal", "on_direction_change", direction)

func verb_pressed(id):
	var menu = timeline.right_click_menu
	if timeline.right_click_menu_pointer == self and id > 0:
		timeline.right_click_menu_pointer = null
		call(verbs.values()[id - 1])
		menu.hide()

func _input_event(viewport, event, shape):
	if event.is_action_pressed("left_click") and not event.is_echo():
		get_tree().set_input_as_handled()
		emit_signal("on_clicked")
	if event.is_action_pressed("right_click") and not event.is_echo() and not verbs.empty():
		get_tree().set_input_as_handled()
		var menu = timeline.right_click_menu
		timeline.right_click_menu_pointer = self
		menu.clear()
		menu.add_item(show_name)
		for key in verbs:
			menu.add_item(key)
		menu.set_pos(get_pos())
		menu.show()