extends Control

func _ready():
	for child in get_children():
		if child.get_name() != "Timer":
			child.hide()
