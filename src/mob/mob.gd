extends KinematicBody2D

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

func _on_client_input(event):
	if event.is_action_pressed("mob_move_up"):
		move_local_y(-32, true)
		direction = NORTH
		update()
	if event.is_action_pressed("mob_move_down"):
		move_local_y(32, true)
		direction = SOUTH
		update()
	if event.is_action_pressed("mob_move_left"):
		move_local_x(-32, true)
		direction = WEST
		update()
	if event.is_action_pressed("mob_move_right"):
		move_local_x(32, true)
		direction = EAST
		update()

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
	get_node("Sprite").set_texture(texture)