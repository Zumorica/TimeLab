extends "res://src/element/element.gd"

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
		_mob_move(NORTH)
	if event.is_action("mob_move_down") and not event.is_action_released("mob_move_down"):
		_mob_move(SOUTH)
	if event.is_action("mob_move_left") and not event.is_action_released("mob_move_left"):
		_mob_move(WEST)
	if event.is_action("mob_move_right") and not event.is_action_released("mob_move_right"):
		_mob_move(EAST)

func _mob_move(where):
	var timeline = get_node("/root/timeline")
	if true:
		if where == NORTH:
			move(timeline.map.map_pos_to_px(Vector2(0, -1)))
		elif where == SOUTH:
			move(timeline.map.map_pos_to_px(Vector2(0, 1)))
		elif where == WEST:
			move(timeline.map.map_pos_to_px(Vector2(-1, 0)))
		elif where == EAST:
			move(timeline.map.map_pos_to_px(Vector2(1, 0)))
		else:
			return
		var pos_x = get_pos().x
		var pos_y = get_pos().y
		#if typeof(pos_x) != TYPE_INT:
		#	set_pos(Vector2((pos_x + 0.125), pos_y))
		#if typeof(pos_y) != TYPE_INT:
		#	set_pos(Vector2(pos_x, (pos_y + 0.125)))
		direction = where
		if get_network_mode() == NETWORK_MODE_MASTER:
			rpc("_update_pos", direction)
		update()
		print(get_pos())

slave func _update_pos(direction):
	_mob_move(direction)

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
	#get_node("Sprite").set_texture(texture)
	pass
