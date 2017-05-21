extends TileMap

func _ready():
	update_sight_bitmap()
			
func update_sight_bitmap():
	for tile in get_used_cells():
		if get_cell(tile.x, tile.y) in [0, 3]:
			get_node("Sight/Bitmap").set_cell(tile.x, tile.y, 0)