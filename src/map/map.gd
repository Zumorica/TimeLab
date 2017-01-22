extends TileMap

var blocking_sight = []

func _ready():
	for tile in get_used_cells():
		if get_cell(tile.x, tile.y) in [0, 3]:
			blocking_sight.append(tile)