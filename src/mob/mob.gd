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

func would_collide(dir, map):
	var pos = map.px_pos_to_map(get_pos() + Vector2(16, 16))
	if dir == NORTH:
		var result = map.find(pos)
		if result.size() != 0:
			print("Current position %s - Position of the object checked %s" % [pos, map.px_pos_to_map(result[0].get_pos())])

func _mob_move(where):
	var timeline = get_node("/root/timeline")
	var current_pos = get_pos()
	if would_collide(where, timeline.map):
		return
	if where == NORTH:
		set_pos(current_pos + timeline.map.map_pos_to_px(Vector2(0, -1)))
	elif where == SOUTH:
		set_pos(current_pos + timeline.map.map_pos_to_px(Vector2(0, 1)))
	elif where == WEST:
		set_pos(current_pos + timeline.map.map_pos_to_px(Vector2(-1, 0)))
	elif where == EAST:
		set_pos(current_pos + timeline.map.map_pos_to_px(Vector2(1, 0)))
	else:
		return
	direction = where
	if get_network_mode() == NETWORK_MODE_MASTER:
		rpc("_update_pos", get_pos())
	update()
	print(get_pos())

slave func _update_pos(pos):
	set_pos(pos)

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
