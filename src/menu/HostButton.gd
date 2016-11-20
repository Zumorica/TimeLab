extends Button

func _on_Button_pressed():
	var list = get_node("../ItemList")
	var selected_items = list.get_selected_items()
	var port = get_node("../Port").get_text()
	var max_players = get_node("../Max").get_text()
	if selected_items.size() != 1:
		print("No map selected. You nutshack!")
		return
	var text = list.get_item_text(selected_items[0])
	var map = "res://res/map/" + text
	if port == "" or not port.is_valid_integer():
		print("Invalid port.")
		return
	if max_players == "" or not max_players.is_valid_integer():
		print("Invalid max players.")
		return
		
	get_node("/root/timeline").chosen_map = map
	get_node("/root/timeline").host_server(int(port), int(max_players))
