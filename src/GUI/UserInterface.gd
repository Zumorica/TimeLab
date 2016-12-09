extends Control

var is_chat_visible = false
var timer
onready var chat_window = get_node("Layer/Container/Chat/ChatWindow")
onready var text_input = get_node("Layer/Container/Chat/TextInput")

func _ready():
	var container = get_node("Layer/Container")
	container.set_size(get_tree().get_root().get_rect().size)
	get_node("Layer/Container/FPSCount").set_pos(Vector2(0, 0))
	set_process(true)
	set_process_input(true)
	timer = get_node("Layer/Container/Chat/Timer")
	timer.connect("timeout", self, "close_chat")
	timer.set_one_shot(true)
	text_input.set_editable(false)

func _process(dt):
	get_node("Layer/Container/FPSCount").set_text(str(OS.get_frames_per_second()))

func _input(ev):
	if ev.is_action_pressed("chat_open") and !is_chat_visible:
		accept_event()
		text_input.clear()
		text_input.show()
		chat_window.show()
		is_chat_visible = true
		text_input.set_editable(true)
		text_input.grab_focus()
	if ev.is_action_pressed("chat_close"):
		text_input.set_editable(false)
		text_input.clear()
		text_input.hide()
		chat_window.hide()
		is_chat_visible = false
	if ev.is_action_pressed("chat_send") and is_chat_visible:
		send_message()

func send_message():
	var msg = text_input.get_text()
	msg += "\n"
	text_input.clear()
	text_input.hide()
	chat_window.hide()
	is_chat_visible = false
	rpc("_update_chat", msg)

sync func _update_chat(msg):
	var messages = get_node("Layer/Container/Chat/ChatWindow/Messages")
	messages.get_parent().show()
	messages.add_text(msg)
	timer.set_wait_time(5)
	timer.start()

func close_chat():
	chat_window.hide()
	is_chat_visible = false