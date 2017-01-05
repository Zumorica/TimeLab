extends TextureButton

func has_item():
	return get_child_count() == 1

func _on_Slot_pressed():
	print("Hey does this work")
