extends Button

func _pressed():
	var ip = get_node("../IP").get_text()
	var port = get_node("../Port").get_text()
	if not ip.is_valid_ip_address():
		print("Invalid IP address.")
		return
	if not port.is_valid_integer():
		print("Invalid port.")
		return
	port = port.to_int()
	var lobby = get_node("/root/lobby")
	lobby.join(ip, port)