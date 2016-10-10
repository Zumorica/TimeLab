extends LineEdit

func _ready():
	set_process(true)
	
	
func _process(dt):
	pass

func _on_CommandInput_text_entered( text ):
	var chat = get_node("../Panel/ScrollContainer/Chat")
	var scroll = get_node("../Panel/ScrollContainer")
	chat.set_text(chat.get_text() + text + "\n")
	scroll.set_v_scroll(chat.get_size().y)
	clear()

func _on_CommandInput_input_event(ev):
	var menu = get_menu()
	if ev.type == InputEvent.MOUSE_BUTTON:
		if ev.button_index == 2 and ev.pressed:
			for camera in get_tree().get_nodes_in_group("camera"):
				if camera.is_current():
					menu.set_global_pos(Vector2(get_global_mouse_pos().x, get_global_mouse_pos().y - get_rect().size.y * 5))