extends Control

func _ready():
	set_process(true)

func _process(dt):
	var ssize = OS.get_window_size()
	set_size(ssize)