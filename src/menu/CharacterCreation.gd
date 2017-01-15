extends Control

func _ready():
	get_node("Name").connect("text_changed", timeline.get_current_client(), "change_character_name")
	get_node("ButtonGroup").connect("button_selected", timeline.get_current_client(), "change_character_gender")