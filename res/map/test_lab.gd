extends "res://src/map/map.gd".Map

func _init():
	data = [{"type" : TILE, "ID" : BLUE_FLOOR, "x": 0, "y" : 0, "variables" : {}},
			{"type" : TILE, "ID" : GREY_WALL, "x": 1, "y" : 0, "variables" : {}},
			{"type" : ENTITY, "ID" : SPAWN_POINT, "x": 0, "y" : 0, "variables" : {}}]
