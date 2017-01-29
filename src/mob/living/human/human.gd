extends "res://src/mob/living/living.gd"

func _ready():
	get_node("Movement").connect("on_move_new_tile", get_node("/root/Map/Sight"), "set_sight")