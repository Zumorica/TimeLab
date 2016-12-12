extends Button

func _ready():
	hide()

func _on_Button_pressed():
	get_node("/root/timeline").begin_game()