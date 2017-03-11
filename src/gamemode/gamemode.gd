extends Node

var name
var notify_mode = true

signal on_game_start()
signal gamemode_prepare()

func _init():
	connect("on_game_start", self, "notify_gamemode")
	
func notify_gamemode():
	if timelab.timeline.get_tree().is_network_server() and notify_mode:
		timelab.timeline.send_global_message("Playing %s" % name)