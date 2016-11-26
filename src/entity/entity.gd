extends Node2D

export(int) var ID = 0

func _ready():
	get_node("Sprite").hide()
	
func get_ID():
	return ID