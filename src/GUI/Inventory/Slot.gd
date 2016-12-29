extends Area2D

func has_item():
	return get_node("Texture").get_child_count() == 1
