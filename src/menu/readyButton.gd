extends Button

func _on_Button_pressed():
	get_node("/root/timeline").set_client_ready()
