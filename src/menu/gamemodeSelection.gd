extends OptionButton

func _ready():
	hide()
	for key in timeline.gamemode_list.keys():
		add_item(key, timeline.gamemode_list.keys().find(key))