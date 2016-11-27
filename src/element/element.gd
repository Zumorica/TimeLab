extends KinematicBody2D

export(int) var ID = 0

func get_ID():
	return ID
	
func _ready():
	set_pickable(true)