extends ItemList

func _ready():
	var dir = Directory.new()
	dir.open("res://res/map/")
	dir.list_dir_begin()
	set_select_mode(SELECT_SINGLE)
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".gd"):
			add_item(file)
	
	dir.list_dir_end()
