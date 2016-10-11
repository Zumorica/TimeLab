extends Control

func _ready():
	set_process(true)
	add_to_group("GUI")

func _process(dt):
	var ssize = OS.get_window_size()
	set_size(ssize)