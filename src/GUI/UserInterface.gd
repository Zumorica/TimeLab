extends Control

var is_chat_visible = false
var timer
onready var chat_window = get_node("Layer/Chat/ChatWindow")
onready var text_input = get_node("Layer/Chat/TextInput")

func _ready():
	get_node("Layer/FPSCount").set_pos(Vector2(0, 0))
	set_process(true)
	set_process_input(true)
	timer = get_node("Layer/Chat/Timer")
	timer.connect("timeout", self, "close_chat")
	timer.set_one_shot(true)

func _process(dt):
	get_node("Layer/FPSCount").set_text(str(OS.get_frames_per_second()))

func _input(ev):
	if ev.type == InputEvent.MOUSE_MOTION:
		return
	elif ev.type == InputEvent.MOUSE_BUTTON:
		return
	if ev.is_action_released("chat_open") and !is_chat_visible:
		text_input.show()
		chat_window.show()
		is_chat_visible = true
		text_input.clear()
		text_input.grab_focus()
		accept_event()
	if ev.is_action_pressed("chat_close"):
		text_input.clear()
		text_input.hide()
		chat_window.hide()
		is_chat_visible = false
		accept_event()
	if ev.is_action_pressed("chat_send") and is_chat_visible:
		send_message()
		accept_event()

func send_message():
	var msg = text_input.get_text()
	if msg == "":
		return
	text_input.clear()
	text_input.hide()
	chat_window.hide()
	is_chat_visible = false
	rpc("_update_chat", msg)

sync func _update_chat(msg):
	var messages = get_node("Layer/Chat/ChatWindow/Messages")
	messages.get_parent().show()
	messages.append_bbcode(msg)
	messages.newline()
	timer.set_wait_time(5)
	timer.start()

func close_chat():
	if get_focus_owner() == text_input:
		return
	chat_window.hide()
	is_chat_visible = false