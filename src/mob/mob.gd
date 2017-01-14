extends "res://src/element/element.gd"


remote var role = s_role.none
export(String, "generic", "human") var race

func _ready():
	if not is_connected("on_game_start", self, "_start_role_check"):
		connect("on_game_start", self, "_start_role_check")
	if not is_connected("on_direction_change", self, "_on_direction_change"):
		connect("on_direction_change", self, "_on_direction_change")
	if not is_connected("on_damaged", self, "_on_damaged"):
		connect("on_damaged", self, "_on_damaged")
	if not is_connected("on_death", self, "_on_death"):
		connect("on_death", self, "_on_death")

func _start_role_check():
	if role != s_role.none and get_client() != null:
		if get_tree().is_network_server():
			if get_client().get_ID() != timeline.get_current_client().get_ID():
				get_client().rpc_id(get_client().get_ID(), "update_chat", s_role.description[role])
			else:
				get_client().update_chat(s_role.description[role])

func _on_death(cause):
	set_rotd(90)
	if is_network_master():
		rset("state", state | s_flag.DEAD)
		state = state | s_flag.DEAD

func _on_damaged(damage, other):
	randomize()
	if rand_range(0, 1) < 0.25 and is_network_master() and not other extends s_base.disease:
		timeline.rpc("synced_instance", "res://src/decal/blood.tscn", NodePath("/root/Map"), {"transform/pos" : get_pos(), "decay_child" : randi()%4})

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
	get_node("North").hide()
	get_node("South").hide()
	get_node("West").hide()
	get_node("East").hide()
	if direction == s_direction.NORTH:
		get_node("North").show()
	elif direction == s_direction.SOUTH:
		get_node("South").show()
	elif direction == s_direction.WEST:
		get_node("West").show()
	elif direction == s_direction.EAST:
		get_node("East").show()

func _on_Area2D_input_event( viewport, event, shape_idx ):
	_input_event(viewport, event, shape_idx)
