extends Control

var is_chat_visible = false
var timer
onready var chat_window = get_node("Layer/Chat/ChatWindow")
onready var text_input = get_node("Layer/Chat/TextInput")
onready var inventory = timelab.timeline.get_current_client().get_mob().get_node("Layer/Inventory")

func _ready():
	set_process(true)
	set_process_unhandled_input(true)
	timer = get_node("Layer/Chat/Timer")
	timer.connect("timeout", self, "close_chat")
	timer.set_one_shot(true)
	var client =timelab.timeline.get_current_client()
	if client:
		client.connect("on_mob_change", self, "_on_mob_change")
		if client.get_mob():
			_on_mob_change(client.get_mob(), null)

func _on_mob_change(new_mob, old_mob):
	if old_mob != null:
		if old_mob.has_node("Health"):
			var health = old_mob.get_node("Health")
			if health.is_connected("on_health_change", get_node("Layer/HealthBar"), "update_health"):
				health.disconnect("on_health_change", get_node("Layer/HealthBar"), "update_health")
	if new_mob != null:
		if new_mob.has_node("Health"):
			var health = new_mob.get_node("Health")
			if not health.is_connected("on_health_change", get_node("Layer/HealthBar"), "update_health"):
				health.connect("on_health_change", get_node("Layer/HealthBar"), "update_health")

func _process(dt):
	get_node("Layer/FPSCount").set_text(str(OS.get_frames_per_second()))

func _unhandled_input(ev):
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
	if ev.is_action_pressed("inventory_toggle"):
		inventory.popup()
		accept_event()
	if ev.is_action_pressed("drop"):
		inventory.drop(inventory.get_node("Background/RHandSlot"))

func send_message():
	var msg = text_input.get_text()
	var re = RegEx.new()
	re.compile("^\\s+$")
	if msg == "" or re.search(msg):
		text_input.clear()
		text_input.hide()
		chat_window.hide()
		is_chat_visible = false
		return
	text_input.clear()
	text_input.hide()
	chat_window.hide()
	is_chat_visible = false
	var is_command = msg.begins_with("/")
	var client =timelab.timeline.get_current_client()
	if not is_command:
		if client.get_mob():
			var mob = client.get_mob()
			if mob.has_node("Chat"):
				var chat = mob.get_node("Chat")
				if chat.has_method("speak"):
					chat.speak(msg)
		else:
			timelab.timeline.update_global_chat("%s: %s" % [client.get_ID(),msg])
	else:
		if msg.begins_with("/me"):
			if client.get_mob():
				var mob = client.get_mob()
				if mob.has_node("Chat"):
					var chat = mob.get_node("Chat")
					if chat.has_method("emote"):
						chat.emote(msg.replace("/me ", ""))

func _update_chat(msg):
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