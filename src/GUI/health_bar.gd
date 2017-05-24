extends Control
var health = 100
var max_health = 100

func _draw():
	var hb_pos = get_position()
	var hb_size = get_size()
	var hb_porc = (100 * health) / max_health
	draw_rect(Rect2(hb_pos + Vector2(0, 0), hb_size), Color(0,0,0,255))
	draw_rect(Rect2(hb_pos + Vector2(1, 1), Vector2(hb_size.x - 2, hb_size.y - 2)), Color(255,0,0,255))
	if health > 0:
		draw_rect(Rect2(hb_pos + Vector2(1, 1), Vector2((hb_size.x - 2) * (hb_porc / 100.0), hb_size.y - 2)), Color(0,255,0,255))

func update_health(h):
	health = h
	update()