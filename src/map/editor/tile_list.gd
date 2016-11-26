extends ItemList

onready var map = get_node("/root/Editor/Map")

func _ready():
	for key in map.TILES.keys():
		var tile = map.TILES[key].instance()
		add_item(tile.get_name(), tile.get_node("Sprite").get_texture())
	set_process(true)