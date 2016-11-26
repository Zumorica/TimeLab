extends ItemList

onready var map = get_node("/root/Editor/Map")

func _ready():
	for key in map.OBJS.keys():
		var obj = map.OBJS[key].instance()
		add_item(obj.get_name(), obj.get_node("Sprite").get_texture())
	set_process(true)