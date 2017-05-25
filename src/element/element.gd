extends KinematicBody2D

signal move(element, new_cell_position, old_cell_position)

sync var state = 0
export sync var speed_per_tick = 2
export sync var is_solid = false setget ,set_solid  # Whether you can walk through this element or not.
export sync var is_opaque = false setget ,set_opaque # Whether you can see through this element or not.
sync var is_sliding = false
sync var cell_position = Vector2(0, 0)
sync var last_cell_position = Vector2(0, 0)
sync var old_cell_position = Vector2(0, 0)
sync var goal_destination = Vector2(0, 0) # The cell destination.
sync var delta_move = Vector2(0, 0) # The movement from the old position to the goal destination in pixels.
sync var old_transform = Transform2D()

func _ready():
	rpc_config("emit_signal", RPC_MODE_SYNC)
	rpc_config("move_to", RPC_MODE_SYNC)
	rpc_config("move", RPC_MODE_SYNC)
	rset_config("position", RPC_MODE_SYNC)
	add_to_group("element")
	timelab.connect("game_start", self, "_game_start")
	cell_slide(Vector2(32, 32))

func _game_start():
	if timelab.has_game_started():
		cell_position = timelab.map.world_to_map(position)
		old_cell_position = cell_position
		timelab.map.track_element_on_map(self)
		
func set_solid(value):
	# Do not call with RPC.
	assert typeof(value) == TYPE_BOOL
	rset("is_solid", value)
	
func set_opaque(value):
	# Do not call with RPC.
	assert typeof(value) == TYPE_BOOL
	rset("is_opaque", value)
	
func queue_free():
	# Do not call with RPC.
	if timelab.has_game_started():
		timelab.map.rpc("tracked_element_remove", self)
	.queue_free()

func cell_slide(destination, relative=false):
	# Do not call with RPC.
	if not is_sliding:
		if relative:
			var final = destination + cell_position
			if timelab.map.grid.has(final.x):
				if timelab.map.grid[final.x].has(final.y):
					pass
				else:
					return
			else:
				return
			rset("goal_destination", destination + cell_position)
		else:
			if timelab.map:
				if timelab.map.grid.has(destination.x):
					if timelab.map.grid[destination.x].has(destination.y):
						pass
					else:
						return
				else:
					return
			rset("goal_destination", destination)
		rset("last_cell_position",  cell_position)
		rset("old_cell_position", cell_position)
		rset("old_transform", get_transform())
		rset("is_sliding", true)
	
func _fixed_process(dt):
	cell_position = timelab.map.world_to_map(position) # This should already be synced, so no rset here.
	if is_sliding:
		var delta_movement = timelab.map.map_to_world(goal_destination - last_cell_position)
		var goal_distance = delta_movement.length()
		if test_move(old_transform, delta_movement):
			is_sliding = false
			if is_colliding():
				prints("Colliding with", get_collider(), get_collision_pos())
		else:
			if goal_distance > speed_per_tick:
				var ratio = speed_per_tick / goal_distance
				var movement = ratio * delta_movement
				move(movement)
				if last_cell_position != cell_position:
					emit_signal("move", self, cell_position, last_cell_position)
					last_cell_position = cell_position
			else:
				is_sliding = false
				move_to(timelab.map.map_to_world(goal_destination))
				if cell_position != last_cell_position:
					emit_signal("move", self, cell_position, last_cell_position)