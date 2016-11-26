extends ItemList

onready var map = get_node("/root/Editor/Map")

func _ready():
	for key in map.ITEMS.keys():
		var item = map.ITEMS[key].instance()
		add_item(item.get_name(), item.get_node("Sprite").get_texture())
	set_process(true)