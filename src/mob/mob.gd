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
	if event.is_action("mob_move_up") and not event.is_action_released("mob_move_up"):
		_mob_move("up")
	if event.is_action("mob_move_down") and not event.is_action_released("mob_move_down"):
		_mob_move("down")
	if event.is_action("mob_move_left") and not event.is_action_released("mob_move_left"):
		_mob_move("left")
	if event.is_action("mob_move_right") and not event.is_action_released("mob_move_right"):
		_mob_move("right")

func _mob_move(direct):
	if direct == "up":
		move(Vector2(0, -32))
		direction = NORTH
		rpc_unreliable("_update_move", Vector2(0, -32))
	elif direct == "down":
		move(Vector2(0, 32))
		direction = SOUTH
		rpc_unreliable("_update_move", Vector2(0, 32))
	elif direct == "left":
		move(Vector2(-32, 0))
		direction = WEST
		rpc_unreliable("_update_move", Vector2(-32, 0))
	else:
		move(Vector2(32, 0))
		direction = EAST
		rpc_unreliable("_update_move", Vector2(32, 0))
	update()

slave func _update_move(move):
	move(move)

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