extends TextureButton

func has_item():
	return get_child_count() == 1

func _on_Slot_pressed():
	var container = get_parent().get_parent()# Since buttons need to be children of the background texture
	if !has_item():
		container.bind_to_slot(self)
	else:
		container.bind_to_cursor(self)
