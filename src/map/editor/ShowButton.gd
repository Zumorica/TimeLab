extends Button

func _ready():
	pass

func _on_ShowButton_pressed():
	var selection = get_node("../Selection")
	selection.set_margin(MARGIN_RIGHT, -selection.get_margin(MARGIN_RIGHT))
	if selection.get_margin(MARGIN_RIGHT) < 0:
		set_margin(MARGIN_LEFT, 0)
		set_text(">")
	else:
		set_margin(MARGIN_LEFT, selection.get_margin(MARGIN_RIGHT))
		set_text("<")