extends KinematicBody2D

signal _on_client_input(event)

const NORTH = 0
const SOUTH = 1
const WEST = 2
const EAST = 3

export(String, "generic", "human") var race
export(int, "NORTH", "SOUTH", "WEST", "EAST") var direction = 0
export(Texture) var sprite_north
export(Texture) var sprite_south
export(Texture) var sprite_west
export(Texture) var sprite_east

func _ready():
	pass

func _on_client_input(event):
	pass

func _on_Mob_draw():
	if direction == NORTH:
		rpc("_change_Sprite", sprite_north)
	elif direction == SOUTH:
		rpc("_change_Sprite", sprite_south)
	elif direction == WEST:
		rpc("_change_Sprite", sprite_west)
	elif direction == EAST:
		rpc("_change_Sprite", sprite_east)

sync func _change_Sprite(texture):
	if typeof(texture) == TYPE_IMAGE:
		get_node("Sprite").set_texture(texture)