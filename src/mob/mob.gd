extends "res://src/element/element.gd"

export(int, "No intent", "Interact intent", "Attack intent", "Use item intent") remote var intent = 1 setget set_intent, get_intent
remote var role = s_role.none
var draw_show_name = false
export(String, "generic", "human") var race

func _ready():
	set_process(true)
	if not is_connected("on_game_start", self, "_start_role_check"):
		connect("on_game_start", self, "_start_role_check")
	if not is_connected("on_direction_change", self, "_on_direction_change"):
		connect("on_direction_change", self, "_on_direction_change")
	if has_node("Health"):
		if not get_node("Health").is_connected("on_damaged", self, "_on_damaged"):
			get_node("Health").connect("on_damaged", self, "_on_damaged")
		if not get_node("Health").is_connected("on_death", self, "_on_death"):
			get_node("Health").connect("on_death", self, "_on_death")
	if has_node("Attack"):
		if not get_node("Attack").is_connected("on_attack", self, "_on_attack"):
			get_node("Attack").connect("on_attack", self, "_on_attack")

func _draw():
	if draw_show_name:
		set_draw_behind_parent(false)
		var label = Label.new()
		var font = label.get_font("")
		var size = font.get_string_size(show_name)
		draw_string(font, Vector2(-size.x / 2, -16 -size.y/2), show_name)
		label.free()
	
func _process(dt):
	if draw_show_name:
		update()

func _start_role_check():
	if role != s_role.none and get_client() != null:
		if get_tree().is_network_server():
			if get_client().get_ID() != timeline.get_current_client().get_ID():
				get_client().rpc_id(get_client().get_ID(), "update_chat", s_role.description[role])
			else:
				get_client().update_chat(s_role.description[role])

func get_intent():
	return intent

func set_intent(new_intent):
	if is_inside_tree():
		if not (intent > 0 or intent <= 3):
			return
		else:
			rset("intent", new_intent)
			intent = new_intent

func _on_attack(other):
	if typeof(other) == TYPE_STRING:
		other = get_node(other)
	if not (state & s_flag.DEAD):
		if has_node("AnimationPlayer"):
			var player = get_node("AnimationPlayer")
			if player.has_animation("attack"):
				player.queue("attack")
			else:
				player.add_animation("attack", "res://res/anim/mob/attack_animation.tres")
				player.queue("attack")

func _on_death(cause):
	set_rotd(90)
	if is_network_master():
		rset("state", state | s_flag.DEAD)
		state = state | s_flag.DEAD

func _on_damaged(damage, other):
	randomize()
	if typeof(other) == TYPE_STRING:
		other = get_node(other)
	if rand_range(0, 1) < 0.25 and is_network_master() and not (other extends s_base.disease):
		timeline.rpc("synced_instance", "res://src/decal/blood.tscn", NodePath("/root/Map"), {"transform/pos" : get_pos() + Vector2(0, 18), "decay_child" : randi()%4})

func contract_disease(disease):
	if typeof(disease) == TYPE_STRING:
		var disease = load(disease)
		if disease.has_method("instance"):
			disease = disease.instance()
		else:
			raise()
	elif typeof(disease) == TYPE_OBJECT:
		if disease.has_method("instance"):
			disease = disease.instance()
	assert typeof(disease) == TYPE_OBJECT
	if has_node("Diseases"):
		get_node("Diseases").add_child(disease)
	else:
		var diseases = Node2D.new()
		diseases.set_name("Diseases")
		add_child(diseases)
		diseases.add_child(disease)
	
func _on_direction_change(direction):
	get_node("Sprites/North").hide()
	get_node("Sprites/South").hide()
	get_node("Sprites/West").hide()
	get_node("Sprites/East").hide()
	if direction == s_direction.NORTH:
		get_node("Sprites/North").show()
	elif direction == s_direction.SOUTH:
		get_node("Sprites/South").show()
	elif direction == s_direction.WEST:
		get_node("Sprites/West").show()
	elif direction == s_direction.EAST:
		get_node("Sprites/East").show()

func _on_Area2D_input_event( viewport, event, shape_idx ):
	_input_event(viewport, event, shape_idx)
