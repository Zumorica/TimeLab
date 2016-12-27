extends "res://src/element/element.gd"


export(String, "generic", "human") var race

func _ready():
	if not is_connected("on_direction_change", self, "_on_direction_change"):
		connect("on_direction_change", self, "_on_direction_change")
	if not is_connected("on_damaged", self, "_on_damaged"):
		connect("on_damaged", self, "_on_damaged")
	if not is_connected("on_death", self, "_on_death"):
		connect("on_death", self, "_on_death")

func _on_death(cause):
	set_rotd(90)
	if is_network_master():
		rset("state", state | DEAD)
		state = state | DEAD

func _on_damaged(damage, other):
	randomize()
	if rand_range(0, 1) < 0.25 and is_network_master():
		rpc("create_blood_decal", get_global_pos())
		create_blood_decal(get_global_pos())

remote func create_blood_decal(where):
	var blood_decal
	var blood_decal_scn = load("res://src/decal/blood.tscn")
	blood_decal = blood_decal_scn.instance()
	blood_decal.set_global_pos(where)
	get_node("/root/Map").add_child(blood_decal)


func _on_direction_change(direction):
	get_node("North").hide()
	get_node("South").hide()
	get_node("West").hide()
	get_node("East").hide()
	if direction == NORTH:
		get_node("North").show()
	elif direction == SOUTH:
		get_node("South").show()
	elif direction == WEST:
		get_node("West").show()
	elif direction == EAST:
		get_node("East").show()

func _on_Area2D_input_event( viewport, event, shape_idx ):
	_input_event(viewport, event, shape_idx)
