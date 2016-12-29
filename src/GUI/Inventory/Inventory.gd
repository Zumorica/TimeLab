extends Control

func _ready():
	hide()

func _draw():
	var cur_size = get_size()
	draw_rect(Rect2(Vector2(0, 0), cur_size), Color(0.2, 0.1, 0))
