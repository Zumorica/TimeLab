extends TileMap

var map = {}

func _ready():
	var size = get_used_rect().size
	for x in range(0, size.x + 1):
		for y in range(0, size.y + 1):
			map[Vector2(x, y)] = []
			
func track_element_on_map(element):
	assert typeof(element) == TYPE_OBJECT
	assert element extends Node
	if element.has_user_signal("move"):
		element.connect("move", self, "_on_tracked_element_move")
		
func _on_tracked_element_move(element, new_position, old_position):
	assert map.has_all([new_position, old_position])
	map[old_position].erase(element)
	map[new_position].append(element)