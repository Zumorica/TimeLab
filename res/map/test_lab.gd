extends "res://src/map/map.gd".Map

func _init():
	data = [{"type" : TILE, "ID" : BLUE_FLOOR, "x": 0, "y" : 0, "variables" : {}},
			{"type" : MOB, "ID" : 1, "x": 0, "y" : 0, "variables" : {}}]
