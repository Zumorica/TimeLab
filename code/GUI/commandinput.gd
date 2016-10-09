extends LineEdit

func _on_CommandInput_text_entered( text ):
	var chat = get_node("../Panel/ScrollContainer/Chat")
	var scroll = get_node("../Panel/ScrollContainer")
	chat.set_text(chat.get_text() + text + "\n")
	scroll.set_v_scroll(chat.get_size().y)
	clear()