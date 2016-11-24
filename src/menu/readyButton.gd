extends Button

func _on_Button_pressed():
	if get_text() == "Ready":
		get_node("/root/timeline").set_client_ready()
		set_text("Unready")
	else:
		get_node("/root/timeline").set_client_ready(true)
		set_text("Ready")
