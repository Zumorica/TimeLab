extends Node

func sight(initial, final):
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
    var new_coords = []
    for pos in coordinates:
        new_coords.append(pos)
        if pos in get_node("/root/Map").blocking_sight:
            break
    coordinates = new_coords
    return coordinates