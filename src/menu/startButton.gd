extends Button

func _ready():
	hide()

func _on_Button_pressed():
	timeline.begin_game()