extends 'res://src/event/event.gd'

export(float) var earthquake_force = 10.0

func _process(dt):
	if get_event_state() == IN_PROGRESS:
		randomize()
		var offset = Vector2(rand_range(-2.0, 2.0) * earthquake_force, rand_range(-2.0, 2.0) * earthquake_force)
		for camera in get_tree().get_nodes_in_group("cameras"):
			camera.set_offset(offset)

func _on_Earthquake_on_event_start():
	set_process(true)


func _on_Earthquake_on_event_end():
	set_process(false)
	for camera in get_tree().get_nodes_in_group("cameras"):
		camera.set_offset(Vector2(0, 0))