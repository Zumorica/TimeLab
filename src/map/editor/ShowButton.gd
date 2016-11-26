extends Button

func _ready():
	pass

func _on_ShowButton_pressed():
	var selection = get_node("../Selection")
	if selection.is_visible():
		selection.hide()
		set_margin(MARGIN_LEFT, 0)
		set_text(">")
	else:
		selection.show()
		set_margin(MARGIN_LEFT, selection.get_margin(MARGIN_RIGHT))
		set_text("<")