extends Control

func _ready():
	for child in get_children():
		child.hide()
