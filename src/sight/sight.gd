extends TileMap

func _ready():
	hide()
	set_cell_size(Vector2(32, 32))
	set_tileset(preload("res://res/tilesets/sight.tres"))
	timeline.connect("on_game_start", self, "show")

func set_sight(position):
	# Expect position and offset to be mappos.
	set_z(1000)
	var size = world_to_map(get_viewport_rect().size)
	var minpos = position - (size / 2)
	var maxpos = position + (size / 2) + Vector2(5, 5)
	fill_non_visible(minpos, maxpos, false)
	var visible_positions = []
	for x in range(minpos.x, maxpos.y):
		var array_one = s_function.sight(position, Vector2(x, minpos.y))
		var array_two = s_function.sight(position, Vector2(x, maxpos.y))
		visible_positions += array_one + array_two
	for y in range(minpos.y, maxpos.y):
		var array_one = s_function.sight(position, Vector2(minpos.x, y))
		var array_two = s_function.sight(position, Vector2(maxpos.x, y))
		visible_positions += array_one + array_two
	set_visible(visible_positions, false)

func fill_visible(min_pos, max_pos, is_screen_pos=true):
	for x in range(min_pos.x, max_pos.x):
		for y in range(min_pos.y, max_pos.y):
			if is_screen_pos:
				var mappos = world_to_map(Vector2(x, y))
				set_cell(mappos.x, mappos.y, -1)
			else:
				set_cell(x, y, -1)

func fill_non_visible(min_pos, max_pos, is_screen_pos=true):
	for x in range(min_pos.x, max_pos.x):
		for y in range(min_pos.y, max_pos.y):
			if is_screen_pos:
				var mappos = world_to_map(Vector2(x, y))
				set_cell(mappos.x, mappos.y, 0)
			else:
				set_cell(x, y, 0)

func set_visible(positions, is_screen_pos=true):
	assert typeof(positions) == TYPE_ARRAY
	for position in positions:
		if is_screen_pos:
			var mappos = world_to_map(position)
			set_cell(mappos.x, mappos.y, -1)
		else:
			set_cell(position.x, position.y, -1)

func set_non_visible(positions, is_screen_pos=true):
	assert typeof(positions) == TYPE_ARRAY
	for position in positions:
		if is_screen_pos:
			var mappos = world_to_map(position)
			set_cell(mappos.x, mappos.y, 0)
		else:
			set_cell(position.x, position.y, 0)