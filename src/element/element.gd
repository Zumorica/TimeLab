extends KinematicBody2D

signal move(element, new_cell_position, old_cell_position)
signal disability_added(added_disability)
signal disability_removed(removed_disability)
signal state_added(added_state)
signal state_removed(removed_state)

sync var disabilities = 0
sync var state = 0
export sync var speed_per_tick = 3
export sync var is_solid = false setget ,set_solid  # Whether you can walk through this element or not.
export sync var is_opaque = false setget ,set_opaque # Whether you can see through this element or not.
sync var direction = timelab.direction.SOUTH
sync var is_sliding = false
sync var cell_position = Vector2(0, 0)
sync var goal_destination = Vector2(0, 0)
sync var old_position = Vector2(0, 0)
sync var last_transform = Transform2D()
sync var last_cell_position = Vector2(0, 0)
sync var old_cell_position = Vector2(0, 0)
#sync var old_position = Vector2(0, 0)
#sync var goal_destination = Vector2(0, 0) # The destination in pixels.
#sync var delta_move = Vector2(0, 0) # The movement from the old position to the goal destination in pixels.

func _ready():
	rpc_config("set_network_mode", RPC_MODE_REMOTE)
	rpc_config("emit_signal", RPC_MODE_SYNC)
	rpc_config("move_to", RPC_MODE_SYNC)
	rpc_config("move", RPC_MODE_SYNC)
	rset_config("position", RPC_MODE_SYNC)
	add_to_group("element")
	if not timelab.has_game_started():
		timelab.connect("game_start", self, "_track_element", [], CONNECT_ONESHOT)
	else:
		_track_element()

func _track_element():
	if get_tree().is_network_server():
		cell_position = timelab.map.world_to_map(position)
		#old_cell_position = cell_position
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

func cell_move(destination, relative=false):
	# Do not call with RPC. Teleports the element.
	if relative:
		destination += cell_position
	if not timelab.map.grid.has(destination):
		return false
	rset("position", timelab.map.map_to_world(destination))
	return true
	
func cell_slide(destination, relative=false):
	# Do not call with RPC.
	if not is_sliding:
		if relative:
			destination += timelab.map.world_to_map(position)
		if not timelab.map.grid.has(destination):
			return false
		rset("cell_position", timelab.map.world_to_map(position))
		rset("goal_destination", timelab.map.map_to_world(destination))
		rset("last_cell_position",  cell_position)
		rset("old_cell_position", cell_position)
		rset("old_position", position)
		rset("last_transform", get_transform())
		rset("is_sliding", true)
		return true
	return false

func add_disability(disability):
	assert typeof(disability) == TYPE_INT
	rset("disabilities", disabilities | disability)
	rpc("emit_signal", "disability_added", disability)
	
func remove_disability(disability):
	assert typeof(disability) == TYPE_INT
	rset("disabilities", disabilities & ~disability)
	rpc("emit_signal", "disability_removed", disability)

func has_disability(disability):
	if ((disabilities & disability) == disability):
		return true
	return false

func add_state(added_state):
	assert typeof(added_state) == TYPE_INT
	rset("state", state | added_state)
	rpc("emit_signal", "state_added", added_state)
	
func remove_state(removed_state):
	assert typeof(removed_state) == TYPE_INT
	rset("state", state & ~removed_state)
	rpc("emit_signal", "state_removed", removed_state)
	
func has_state(int_state):
	if ((state & int_state) == int_state):
		return true
	return false

func _fixed_process(dt):
	if timelab.has_game_started():
		cell_position = timelab.map.world_to_map(position)
		if is_sliding and get_tree().is_network_server():
			var delta_movement = goal_destination - position
			var goal_distance = delta_movement.length()
			if test_move(last_transform, delta_movement) or test_move(get_transform(), delta_movement):
				rset("is_sliding", false)
				cell_move(last_cell_position)
				return
			else:
				if goal_distance > speed_per_tick:
					var ratio = speed_per_tick / goal_distance
					var movement = delta_movement * ratio
					if test_move(last_transform, movement) or test_move(get_transform(), movement):
						rset("is_sliding", false)
						cell_move(last_cell_position)
						return
					rpc("move", movement)
					if last_cell_position != cell_position:
						rpc("emit_signal", "move", get_path(), cell_position, last_cell_position)
						rset("last_cell_position", cell_position)
						rset("last_transform", get_transform())
				else:
					rset("is_sliding", false)
					rpc("move_to", goal_destination)
					if cell_position != last_cell_position:
						emit_signal("move", self, cell_position, last_cell_position)
		elif get_tree().is_network_server():
			var cell_size = timelab.map.cell_size
			if (fmod(position.x, cell_size.x) != 0) or (fmod(position.y, cell_size.y) != 0):
				position = timelab.map.map_to_world(last_cell_position)