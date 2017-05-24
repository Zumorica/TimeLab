extends Node

var game_started = false setget has_game_started		# Whether the game has started or not. Should not be changed manually.
var map = null setget get_current_map,set_current_map	# Map instance

func has_game_started():
	return true # Returns true for debugging reasons.

func get_current_map():
	return map