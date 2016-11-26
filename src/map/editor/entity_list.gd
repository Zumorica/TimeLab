extends ItemList

onready var map = get_node("/root/Editor/Map")

func _ready():
	for key in map.ENTITIES.keys():
		var entity = map.ENTITIES[key].instance()
		add_item(entity.get_name(), entity.get_node("Sprite").get_texture())
	set_process(true)