extends Button

func _on_Button_pressed():
	var port = get_node("../Port").get_text()
	var ip = get_node("../Ip").get_text()
	if port == "" or not port.is_valid_integer():
		print("Invalid port.")
		return
	if ip == "" or not ip.is_valid_ip_address():
		print("Invalid ip address.")
		return

	timeline.connect_to_server(ip, int(port))
