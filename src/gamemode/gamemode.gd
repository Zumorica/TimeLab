extends Node

var name
var notify_mode = true

signal on_game_start()
signal gamemode_prepare()
signal gamemode_check_win()

func _init():
	connect("on_game_start", self, "notify_gamemode")
	
func notify_gamemode():
	if timeline.get_tree().is_network_server() and notify_mode:
		timeline.send_global_message("Playing %s" % name)