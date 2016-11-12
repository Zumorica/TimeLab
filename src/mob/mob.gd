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
	if event.is_action("mob_move_up"):
		move_local_y(-32, true)
	if event.is_action("mob_move_down"):
		move_local_y(32, true)
	if event.is_action("mob_move_left"):
		move_local_x(-32, true)
	if event.is_action("mob_move_right"):
		move_local_x(32, true)

func _ready():
	if get_parent().get_name() == "Client":
		get_parent().connect("_on_client_input", self, "_on_client_input")

func _on_Mob_draw():
	if direction == NORTH:
		pass
		#rpc("_change_Sprite", sprite_north)
	elif direction == SOUTH:
		pass
		#rpc("_change_Sprite", sprite_south)
	elif direction == WEST:
		pass
		#rpc("_change_Sprite", sprite_west)
	elif direction == EAST:
		pass
		#rpc("_change_Sprite", sprite_east)

sync func _change_Sprite(texture):
	if typeof(texture) == TYPE_IMAGE:
		get_node("Sprite").set_texture(texture)