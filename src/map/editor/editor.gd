extends Node

const MOUSE_NOTHING = 0
const MOUSE_MOVEMAP = 1
const MOUSE_PLACE = 2

const DATA_BASE = {"type" : null, "ID" : null, "position" : null, "variables" : {}}

var current_data = DATA_BASE
var selection = false
var cursor_mode = 0
var current_tab = 0
var tile_list
var obj_list
var mob_list
var item_list
var entity_list

func _ready():
	tile_list = get_node("GUI/Selection/TabContainer/Tiles/ItemList")
	obj_list = get_node("GUI/Selection/TabContainer/Objects/ItemList")
	mob_list = get_node("GUI/Selection/TabContainer/Mobs/ItemList")
	item_list = get_node("GUI/Selection/TabContainer/Items/ItemList")
	entity_list = get_node("GUI/Selection/TabContainer/Entities/ItemList")
	set_process(true)
	
func _process(dt):
	current_tab = get_node("GUI/Selection/TabContainer").get_current_tab()
	cursor_mode = get_node("GUI/Selected/OptionButton").get_selected_ID()

func _on_TileList_item_selected( index ):
	if current_tab == 0:
		get_node("GUI/Selected/Sprite").set_texture(tile_list.get_item_icon(index))
		get_node("GUI/Selected/Label").set_text(tile_list.get_item_text(index))
		selection = index
		current_data["type"] = "tile"
		current_data["ID"] = index + 1

func _on_ObjList_item_selected( index ):
	if current_tab == 1:
		get_node("GUI/Selected/Sprite").set_texture(obj_list.get_item_icon(index))
		get_node("GUI/Selected/Label").set_text(obj_list.get_item_text(index))
		selection = index
		current_data["type"] = "obj"
		current_data["ID"] = index + 1
		
func _on_MobList_item_selected( index ):
	if current_tab == 2:
		get_node("GUI/Selected/Sprite").set_texture(mob_list.get_item_icon(index))
		get_node("GUI/Selected/Label").set_text(mob_list.get_item_text(index))
		selection = index
		current_data["type"] = "mob"
		current_data["ID"] = index + 1
		
func _on_ItemList_item_selected( index ):
	if current_tab == 3:
		get_node("GUI/Selected/Sprite").set_texture(item_list.get_item_icon(index))
		get_node("GUI/Selected/Label").set_text(item_list.get_item_text(index))
		selection = index
		current_data["type"] = "item"
		current_data["ID"] = index + 1
		
func _on_EntityList_item_selected( index ):
	if current_tab == 4:
		get_node("GUI/Selected/Sprite").set_texture(entity_list.get_item_icon(index))
		get_node("GUI/Selected/Label").set_text(entity_list.get_item_text(index))
		selection = index
		current_data["type"] = "entity"
		current_data["ID"] = index + 1

func _on_TabContainer_tab_changed( tab ):
	for list in [tile_list, obj_list, mob_list, item_list, entity_list]:
		if list.get_selected_items().size() > 0:
			list.unselect(list.get_selected_items()[0])
			get_node("GUI/Selected/Sprite").set_texture(null)
			get_node("GUI/Selected/Label").set_text("")
			selection = false
			current_data = DATA_BASE