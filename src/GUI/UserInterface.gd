extends Control

var is_chat_visible = false

func _ready():
	var container = get_node("Layer/Container")
	container.set_size(get_tree().get_root().get_rect().size)
	get_node("Layer/Container/FPSCount").set_pos(Vector2(0, 0))
	set_process(true)
	set_process_input(true)

func _process(dt):
	get_node("Layer/Container/FPSCount").set_text(str(OS.get_frames_per_second()))

func _input(ev):
	if ev.is_action_pressed("chat_toggle"):
		if !is_chat_visible:
			get_node("Layer/Container/Chat/TextInput").show()
			get_node("Layer/Container/Chat/ChatWindow").show()
			is_chat_visible = true
		else:
			get_node("Layer/Container/Chat/TextInput").hide()
			get_node("Layer/Container/Chat/ChatWindow").hide()
			is_chat_visible = false