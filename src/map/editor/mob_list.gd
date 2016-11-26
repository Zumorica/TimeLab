extends ItemList

onready var map = get_node("/root/Editor/Map")

func _ready():
	for key in map.MOBS.keys():
		var mob = map.MOBS[key].instance()
		add_item(mob.get_name(), mob.get_node("Sprite").get_texture())
	set_process(true)