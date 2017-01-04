extends Button

func _on_Button_pressed():
	var port = get_node("../Port").get_text()
	var max_players = get_node("../Max").get_text()
	if port == "" or not port.is_valid_integer():
		print("Invalid port.")
		return
	if max_players == "" or not max_players.is_valid_integer():
		print("Invalid max players.")
		return
		
	timeline.host_server(int(port), int(max_players))
