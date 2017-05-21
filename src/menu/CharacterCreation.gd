extends Control

func _ready():
	get_node("Name").connect("text_changed", timelab.timeline.get_current_client(), "change_character_name")
	get_node("Gender").connect("item_selected", timelab.timeline.get_current_client(), "change_character_gender")