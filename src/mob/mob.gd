extends "res://src/element/element.gd"


export(String, "generic", "human") var race

func _ready():
	if not is_connected("on_direction_change", self, "_on_direction_change"):
		connect("on_direction_change", self, "_on_direction_change")
		
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