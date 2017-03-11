extends Control

func _ready():
	get_node("Name").connect("text_changed",timelab.timeline.get_current_client(), "change_character_name")
	get_node("ButtonGroup").connect("button_selected",timelab.timeline.get_current_client(), "change_character_gender")