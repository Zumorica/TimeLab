extends "res://src/map/map.gd".Map

func _init():
	data = [{"tile" : BLUE_FLOOR, "x" : 0, "y" : 0, "variables" : {}}, {"tile" : BLUE_FLOOR, "x" : 1, "y" : 0, "variables" : {"transform/rot" : 60}}, {"tile" : BLUE_FLOOR, "x" : 0, "y" : 1, "variables" : {}}]