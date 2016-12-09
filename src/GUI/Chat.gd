extends Control

onready var messages = get_node("ChatWindow/Messages")

func _ready():
	for child in get_children():
		if child.get_name() != "Timer":
			child.hide()
	messages.set_scroll_follow(true)
	messages.set_use_bbcode(true)
