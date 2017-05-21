extends OptionButton

func _ready():
	hide()
	for key intimelab.timeline.gamemode_list.keys():
		add_item(key,timelab.timeline.gamemode_list.keys().find(key))