extends KinematicBody2D

signal move(element, new_cell_position, old_cell_position)

var state = 0
export var is_solid = false  # Whether you can walk through this element or not.
export var is_opaque = false # Whether you can see through this element or not.

func _ready():
	add_to_group("element")
	if timelab.has_game_started():
		timelab.get_current_map()