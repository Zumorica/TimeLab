extends "res://src/map/map.gd".Map
#extends Area2D

var mouse_pressed = false
var drag_camera = true

func _ready():
	set_process_input(true)
	map_size = Vector2(24, 24)

func _draw():
	print("hello")
	var map_ssize = map_pos_to_px(map_size)
	for x in range(0, map_ssize.x + 1):
		if not (x % 32):
			draw_line(Vector2(x, 0), Vector2(x, map_ssize.y), Color(255, 255, 255, 255))
	for y in range(0, map_ssize.y + 1):
		if not (y % 32):
			draw_line(Vector2(0, y), Vector2(map_ssize.x, y), Color(255, 255, 255, 255))

func _input(event):
	var camera = get_node("Camera2D")
	if event.is_action_pressed("map_editor_zoom_up") and camera.get_zoom().x <= 4:
		camera.set_zoom(camera.get_zoom() + Vector2(0.1, 0.1))
	if event.is_action_pressed("map_editor_zoom_down") and camera.get_zoom().x >= 0.4:
		camera.set_zoom(camera.get_zoom() - Vector2(0.1, 0.1))
	if event.is_action_pressed("map_editor_mouse_left"):
		mouse_pressed = true
	if event.is_action_released("map_editor_mouse_left"):
		mouse_pressed = false
	if event.type == 2 and mouse_pressed and drag_camera:
		camera.move_local_x(event.speed_x / 32)
		camera.move_local_y(event.speed_y / 32)