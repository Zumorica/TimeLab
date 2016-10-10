extends Camera2D

onready var ORIG_SIZE = OS.get_window_size()

func _ready():
	add_to_group("camera")
	set_process(true)
	
func _process(dt):
	var ssize = OS.get_window_size()
	set_offset(Vector2((-256 * ssize.x) / ORIG_SIZE.x, (-308 * ssize.y) / ORIG_SIZE.y))
	for object in get_tree().get_nodes_in_group("GUI"):
		object.set_global_pos(get_global_transform() * get_offset() * get_zoom())