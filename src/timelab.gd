extends Node

signal game_start()
signal game_end()

sync var game_started = false setget has_game_started, set_game_started	# Whether the game has started or not. Should not be changed manually.
sync var map = null setget ,set_current_map	# Map instance

func _ready():
	rpc_config("emit_signal", RPC_MODE_SYNC)

func has_game_started():
	return game_started

func set_current_map(new_map):
	rset("map", new_map)
	
func set_game_started(value):
	rset("game_started", value)
	if value:
		rpc("emit_signal", "game_start")
	else:
		rpc("emit_signal", "game_end")