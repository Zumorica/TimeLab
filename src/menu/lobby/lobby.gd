extends CenterContainer

export(NodePath) var player_list
export(NodePath) var chat_label
export(NodePath) var chat_lineedit
export(NodePath) var nickname_lineedit
export(NodePath) var ready_button
export(NodePath) var start_button

var refresh_timer = Timer.new()

func _ready():
	assert get_node(player_list) is ItemList
	assert get_node(chat_label) is RichTextLabel
	assert get_node(chat_lineedit) is LineEdit
	assert get_node(nickname_lineedit) is LineEdit
	assert get_node(ready_button) is Button
	assert get_node(start_button) is Button
	get_node(chat_lineedit).connect("text_entered", self, "_on_chat_text_entered")
	get_node(nickname_lineedit).connect("text_entered", self, "_on_nickname_submit")
	get_node(ready_button).connect("toggled", self, "_on_ready_button_toggle")
	get_node(start_button).connect("pressed", self, "_on_start_button_pressed")
	
	rpc_config("show", RPC_MODE_SYNC)
	rpc_config("hide", RPC_MODE_SYNC)
	
	refresh_timer.set_wait_time(0.25)
	refresh_timer.set_autostart(true)
	add_child(refresh_timer)
	refresh_timer.connect("timeout", self, "_player_list_refresh")
	
	if timelab.has_game_started():
		get_node(ready_button).set_text("Join game")
		get_node(ready_button).set_toggle_mode(false)
		get_node(start_button).set_disabled(true)

func _player_list_refresh():
	var list = get_node(player_list)
	list.clear()
	for node in get_tree().get_nodes_in_group("clients"):
		assert node is load(timelab.base.client)
		if node == timelab.get_current_client():
			list.add_item("%s >>%s (You)"%[node.get_name(), node.ID], null, false)
		else:
			list.add_item("%s >>%s"%[node.get_name(), node.ID], null, false)

func _on_nickname_submit(text):
	var old_nick = timelab.get_current_client().get_name()
	if text.strip_edges().length():
		timelab.rpc("rename", timelab.get_current_client().get_path(), text)
		rpc("add_chat_message", "[i]%s changed their nickname to %s[/i]" %[old_nick, text])

func _on_ready_button_toggle(toggle):
	if toggle:
		get_node(ready_button).set_text("Unready")
	else:
		get_node(ready_button).set_text("Ready")
	timelab.get_current_client().rset("preround_ready", toggle)

func _on_chat_text_entered(text):
	if text.strip_edges().length():
		get_node(chat_lineedit).clear()
		var final_text = "[b]%s[/b]: %s" %[timelab.get_current_client().get_name(), text]
		rpc("add_chat_message", final_text)

sync func add_chat_message(text):
	get_node(chat_label).append_bbcode(text)
	get_node(chat_label).newline()
	
func _on_start_button_pressed():
	if get_tree().is_network_server():
		get_node(start_button).set_disabled(true)
		timelab.rpc("set_current_map", "/root/Game/Map")
		timelab.rpc("set_game_started", true)
		rpc("hide")
		var count = 3
		for client in get_tree().get_nodes_in_group("clients"):
			if client.preround_ready:
				timelab.rpc("instance", timelab.base.human, get_node("/root/Game/Map").get_path(), {"position" : Vector2(32 * count, 32 * count)}, [], client.get_name())
				get_node("/root/Game/Map/%s/Mind"%client.get_name()).set_client(client)
				count += 1
	
func _process(dt):
	if get_tree().is_network_server() and not timelab.has_game_started():
		for client in get_tree().get_nodes_in_group("clients"):
			if not client.preround_ready:
				break
		get_node(start_button).set_disabled(false)