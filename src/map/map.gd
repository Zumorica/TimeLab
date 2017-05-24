extends TileMap

var grid = {}

func _ready():
	if get_tree().get_network_unique_id() == 1:
		rpc_config("_on_tracked_element_move", RPC_MODE_MASTER)
	else:
		rpc_config("_on_tracked_element_move", RPC_MODE_SLAVE)
	_grid_populate(get_used_rect().size)

func _grid_populate(grid_size):
	# Clears the whole grid and populates it with
	# entries for all possible positions on the map.
	grid.clear()
	for x in range(0, grid_size.x + 1):
		for y in range(0, grid_size.y + 1):
			grid[Vector2(x, y)] = []

func track_element_on_map(element):
	if get_tree().get_network_unique_id() == 1:
		assert typeof(element) == TYPE_OBJECT
		assert element extends Node
		if element.has_user_signal("move"):
			element.connect("move", self, "_on_tracked_element_move")
		_on_tracked_element_move(element, element.cell_position, Vector2(0, 0))

remote func _on_tracked_element_move(element, new_position, old_position):
	assert grid.has_all([new_position, old_position])
	if grid[old_position].has(element):
		grid[old_position].erase(element)
	if not grid[new_position].has(element):
		grid[new_position].append(element)
	if get_tree().get_network_unique_id() == 1:
		rpc("_on_tracked_element_move", element, new_position, old_position)
		
remote func tracked_element_remove(element):
	if element.is_connected("move", self, "on_tracked_element_move"):
		element.disconnect("move", self, "on_tracked_element_move")
	if grid.has(element.cell_position):
		var cell = grid[element.cell_position]
		if cell.has(element):
			cell.erase(element)