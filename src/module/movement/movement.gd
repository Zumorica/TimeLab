extends Node2D

export remote var speed_per_tick = 2

remote var is_sliding = false
remote var goal_destination = Vector2(0, 0)
remote var old_pos = Vector2(0, 0)
remote var old_transform = Matrix32()

func _ready():
	get_parent().rpc_config("move", RPC_MODE_SYNC)
	get_parent().rpc_config("move_to", RPC_MODE_SYNC)
	set_fixed_process(true)

func move(destination, is_relative=false):
	if not is_sliding:
		if is_relative:
			goal_destination = destination + get_parent().get_pos()
		else:
			goal_destination = destination
		old_pos = get_parent().get_pos()
		old_transform = get_parent().get_transform()
		is_sliding = true
		rset("is_sliding", is_sliding)
		rset("goal_destination", goal_destination)
		rset("old_pos", old_pos)
		rset("old_transform", old_transform)
		
func move_tiles(destination, is_relative=false):
	if has_node("/root/Map") and not is_sliding:
		var map = get_node("/root/Map")
		destination = map.map_to_world(destination)
		move(destination, is_relative)

func _fixed_process(delta):
	if is_network_master():
		if is_sliding:
			if get_parent().test_move(old_transform, goal_destination - old_pos):
				is_sliding = false
				rset("is_sliding", is_sliding)
				get_parent().rpc("move_to", goal_destination)
				if get_parent().is_colliding():
					var collider = get_parent().get_collider()
					get_parent().rpc("emit_signal", "on_collide", str(collider.get_path()))
					if collider extends s_base.element:
						collider.rpc("emit_signal", "on_collided", str(get_parent().get_path()))
				get_parent().rpc("move_to", old_pos)
			else:
				var delta_movement = goal_destination - get_parent().get_pos()
				var goal_distance = sqrt(pow(delta_movement.x, 2) + pow(delta_movement.y, 2))
				if goal_distance > speed_per_tick:
					var ratio = speed_per_tick / goal_distance
					var movement = ratio * delta_movement
					get_parent().rpc("move", movement)
				else:
					is_sliding = false
					rset("is_sliding", is_sliding)
					get_parent().rpc("move_to", goal_destination)
		elif not (int(get_parent().get_pos().x) % 32) or not (int(get_parent().get_pos().y) % 32):
			get_parent().rpc("move_to", old_pos)