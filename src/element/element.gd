extends KinematicBody2D

signal on_game_start()
signal on_direction_change(direction)
signal on_collided(collider)	# When something collides with the element.
signal on_collide(collider)		# When the element collides with something.
signal on_clicked()
signal on_health_change(health)	    # When the health changes.
signal on_interacted(other, item)	# When this node is interacted by another one.
signal on_damaged(damage, other)	# When this node is attacked/damaged.
signal on_healed(hp, other)
signal on_attack(other)		# When this node attacks another node.
signal on_death()	# When this node's health reaches zero.
signal on_client_change(client) # Called when this element's client is changed.

export var show_name = "Unknown"
export var description = "[REDACTED]"
export(int, "NORTH", "SOUTH", "WEST", "EAST") remote var direction = 0
export(bool) var is_movable = true
export(int, "No intent", "Interact intent", "Attack intent") remote var intent = 1 setget set_intent, get_intent
export(int) var max_health = 100
export(bool) var invincible = false
export(float) var damage_factor = 1.0
export(float) var burn_damage_factor = 1.0
export(float) var attack_factor = 1.0
export(float) var attack_delay = 0.5
export(int, FLAGS) remote var state = 0
export(int) var speed = 80
export(int) var interact_range = 100
export(int) var speaking_radius = 1000
export(int, "Neutral", "Male", "Female") var gender = s_gender.NEUTRAL
var verbs = {"Examine" : "examine_element"}

onready var orig_name = get_name()
#var z_floor = 0 setget set_floor,get_floor # Might get removed in the future.
var client = null setget get_client,_set_client # Do not change from this node. Call set_mob from client instead.
remote var health = max_health

func _init():
	add_speak_area()
	rset_config("show_name", RPC_MODE_REMOTE)
	if not has_node("AttackTimer"):
		var attack_timer = Timer.new()
		attack_timer.set_wait_time(attack_delay)
		attack_timer.connect("timeout", self, "reset_attack_timer")
		attack_timer.set_name("AttackTimer")
		attack_timer.set_one_shot(true)
		add_child(attack_timer)

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

#func set_floor(z):
#		z_floor = z
#
#func get_floor():
#	return z_floor
#
#sync func set_pos3(vector):
#	assert (typeof(vector) == TYPE_VECTOR3)
#	set_floor(vector.z)
#	if get_floor() == vector.z:
#		set_pos(vector.x, vector.y)
#
#func get_pos3():
#	var pos = get_pos()
#	return Vector3(pos.x, pos.y, get_floor())

func add_speak_area():
	if not has_node("SpeakArea2D"):
		var speak_area = Area2D.new()
		var speak_shape = CircleShape2D.new()
		add_child(speak_area)
		speak_shape.set_radius(speaking_radius)
		speak_area.add_shape(speak_shape)
		speak_area.set_name("SpeakArea2D")
		speak_area.set_enable_monitoring(true)
		speak_area.set_pickable(false)
		
		
func remove_speak_area():
	if has_node("SpeakArea2D"):
		get_node("SpeakArea2D").free()
	
func examine_element():
	timeline.get_current_client().update_chat(description)

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

func get_intent():
	return intent

func set_intent(new_intent):
	if is_inside_tree():
		if not (intent > 0 or intent <= 3):
			return
		else:
			rset("intent", new_intent)
			intent = new_intent

func reset_attack_timer():
	if ((state & s_flag.CANT_ATTACK) == s_flag.CANT_ATTACK):
		rset("state", state ^ s_flag.CANT_ATTACK)
		state ^= s_flag.CANT_ATTACK

sync func heal(hp, other):
	if typeof(other) == TYPE_STRING:
		other = get_node(other)
	if hp > 0 and not ((state & s_flag.DEAD) or (state & s_flag.CANT_BE_HEALED)):
		health += hp
		if health > max_health:
			health = max_health
		emit_signal("on_healed", hp, other)
		emit_signal("on_health_change", health)
	

sync func damage(damage, other):
	if typeof(other) == TYPE_STRING:
		other = get_node(other)
	if not invincible and damage > 0:
		health -= round(damage * damage_factor)
		emit_signal("on_damaged", damage, str(other.get_path()))
		emit_signal("on_health_change", health)
		if (health <= 0):
			health = 0
			state |= s_flag.DEAD
			emit_signal("on_death", str(other.get_path()))

func attack(other, bonus = 0):
	if (not (state & s_flag.DEAD) and not (state & s_flag.CANT_ATTACK)) and other extends s_base.element:
		var damage = (randi()%11) * (attack_factor + bonus)
		other.rpc("damage", damage, str(get_path()))
		rpc("emit_signal", "on_attack", str(other.get_path()))
		rset("state", state | s_flag.CANT_ATTACK)
		state |= s_flag.CANT_ATTACK
		get_node("AttackTimer").start()

func _on_clicked():
	var cmob = timeline.get_current_client().get_mob()
	var item = cmob.get_node("Layer/Inventory").get_item("RHandSlot")
	if cmob:
		var intention = cmob.get_intent()
		if intention  == s_intent.INTERACT:
			if item:
				rpc("emit_signal", "on_interacted", str(cmob.get_path()), item.get_path())
			else:
				rpc("emit_signal", "on_interacted", str(cmob.get_path()), false)
		elif intention == s_intent.ATTACK:
			if item:
				if item extends s_base.element:
					cmob.attack(self, item.attack_factor)
				else:
					raise()
			else:
				cmob.attack(self, 0)
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

sync func receive_message(msg):
	if get_client():
		var client = get_client()
		client.update_chat(msg)

func send_message(msg):
	if get_client():
		get_client().send_message(msg)

func hear(msg):
	if not state & s_flag.DEAF:
		rpc("receive_message", msg)

func speak(msg):
	if not state & s_flag.MUTE:
		for child in get_node("SpeakArea2D").get_overlapping_bodies():
			if child extends s_base.element:
				child.hear("%s: %s" % [show_name, msg])

func emote(emotion):
	for child in get_node("SpeakArea2D").get_overlapping_bodies():
		if child extends s_base.element and child.get_client():
			child.rpc("receive_message", "%s %s" %[show_name, emotion])

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