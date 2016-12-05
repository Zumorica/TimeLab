extends "res://src/map/map.gd".Map

var draw_grid = true
var mouse_pressed = false

func _ready():
	initial_map_preparation()

func _draw():
	if draw_grid:
		var map_ssize = map_pos_to_px(get_map_size())
		for x in range(0, map_ssize.x + 1):
			if not (x % 32):
				draw_line(Vector2(x, 0), Vector2(x, map_ssize.y), Color(255, 255, 255, 255))
		for y in range(0, map_ssize.y + 1):
			if not (y % 32):
				draw_line(Vector2(0, y), Vector2(map_ssize.x, y), Color(255, 255, 255, 255))

func _input(event):
	var map_size = get_map_size()
	var camera = get_node("Camera2D")
	if event.is_action_pressed("map_editor_zoom_up") and camera.get_zoom().x <= 4:
		camera.set_zoom(camera.get_zoom() + Vector2(0.1, 0.1))
	if event.is_action_pressed("map_editor_zoom_down") and camera.get_zoom().x >= 0.4:
		camera.set_zoom(camera.get_zoom() - Vector2(0.1, 0.1))
	if event.is_action_pressed("map_editor_zoom_reset"):
		camera.set_zoom(Vector2(1, 1))
	if event.is_action_pressed("map_editor_mouse_left"):
		mouse_pressed = true
		var mpos = get_local_mouse_pos()
		var mpos_map = px_pos_to_map(mpos)
		if (mpos.x >= 0 and mpos_map.x <= map_size.x - 1) and (mpos.y >= 0 and mpos_map.y <= map_size.y - 1):
			if get_parent().cursor_mode == 2:
				var data = get_parent().current_data
				if data["type"] != null and data["ID"] != null:
					if not find(mpos_map, false, data["type"]).size():
						data["position"] = Vector3(mpos_map.x, mpos_map.y, get_current_floor())
						add_child_from_data(data)

	if event.is_action_released("map_editor_mouse_left"):
		mouse_pressed = false
	if event.type == 2 and mouse_pressed and get_parent().cursor_mode == 1:
		camera.move_local_x(event.speed_x / 32)
		camera.move_local_y(event.speed_y / 32)

func _on_Grid_CheckBox_toggled( pressed ):
	draw_grid = pressed
	print(pressed)
	print(draw_grid)
	update()

func _on_SpinBox_value_changed( value ):
	set_current_floor(value)
	get_node("../GUI/Selected/SpinBox").set_max(get_map_size().z)


func _on_X_enter_tree():
	get_node("../GUI/Selection/X").set_value(get_map_size().x)

func _on_Y_enter_tree():
	get_node("../GUI/Selection/Y").set_value(get_map_size().y)

func _on_Z_enter_tree():
	get_node("../GUI/Selection/Z").set_value(get_map_size().z)

func _on_X_value_changed( value ):
	var old_size = get_map_size()
	change_map_size(Vector3(value, old_size.y, old_size.z))
	update()

func _on_Y_value_changed( value ):
	var old_size = get_map_size()
	change_map_size(Vector3(old_size.x, value, old_size.z))
	update()

func _on_Z_value_changed( value ):
	var old_size = get_map_size()
	var current_floor = get_current_floor()
	change_map_size(Vector3(old_size.x, old_size.y, value))
	if value < current_floor:
		get_node("../GUI/Selected/SpinBox").set_value(value)
		set_current_floor(value)
	get_node("../GUI/Selected/SpinBox").set_max(value)
	update()


func _on_Save_pressed():
	get_node("../GUI/Selection/FileDialog").popup()

func _on_FileDialog_file_selected( path ):
	var fmap = File.new()
	fmap.open(path, fmap.WRITE_READ)
	update_mapdata()
	fmap.seek_end()
	fmap.store_var(get_updated_mapdata())
	fmap.close()

func _on_Load_pressed():
	get_node("../GUI/Selection/LoadDialog").popup()

func _on_LoadDialog_file_selected( path ):
	var fmap = File.new()
	fmap.open(path, fmap.READ)
	var data = fmap.get_var()
	_orig_data = data
	for z in data:
		for x in z:
			for y in z:
				for entry in y:
					add_child_from_data(entry, false)
	fmap.close()
