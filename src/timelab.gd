extends Node2D

onready var timeline = $"/root/timeline"
var base = load("res://src/globals/base.gd").new()
var direction = load("res://src/globals/direction.gd").new()
var flag = load("res://src/globals/flag.gd").new()
var gender = load("res://src/globals/gender.gd").new()
var intent = load("res://src/globals/intent.gd").new()
var role = load("res://src/globals/role.gd").new()

func probability(percent):
	randomize()
	var rand = rand_range(0, 100)
	return rand <= percent

func bresenham(initial, final):
    var coordinates = []
    var x0 = initial.x
    var y0 = initial.y
    var x1 = final.x
    var y1 = final.y
    var dx = abs(x1 - x0)
    var dy = abs(y1 - y0)
    var x = x0
    var y = y0
    var sx = -1 if x0 > x1 else 1
    var sy = -1 if y0 > y1 else 1
    if dx > dy:
        var err = dx / 2.0
        while x != x1:
            coordinates.append(Vector2(x, y))
            err -= dy
            if err < 0:
                y += sy
                err += dx
            x += sx
    else:
        var err = dy / 2.0
        while y != y1:
            coordinates.append(Vector2(x, y))
            err -= dx
            if err < 0:
                x += sx
                err += dy
            y += sy        
    coordinates.append(Vector2(x, y))
    return coordinates