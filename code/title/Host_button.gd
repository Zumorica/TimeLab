extends Button

func _pressed():
	var max_players = get_node("../Max players").get_text()
	var port = get_node("../Port").get_text()
	if not max_players.is_valid_integer():
		print("Invalid max numer of players.")
		return
	if not port.is_valid_integer():
		print("Invalid port.")
		return
	max_players = max_players.to_int()
	port = port.to_int()
	var lobby = get_node("/root/lobby")
	lobby.host(port, max_players)