extends "res://src/module/container/container.gd"

func _ready():
	var char_name = timeline.get_current_client().character_name
	set_title("%s's inventory" % char_name)

func set_inactive():
	for s in get_tree().get_nodes_in_group("belt_slots"):
		s.set_disabled(true)

func drop(slot):
	if !storage.has(slot):
		return
	
	rpc("_drop", slot.get_path(), timeline.get_current_client().get_mob().get_path())

sync func _drop(slot_path, mob_path):
	var slot = get_node(slot_path)
	var mob = get_node(mob_path)
	var item = storage[slot]
	remove_item(slot)
	get_node("/root/Map").add_child(item)
	item.set_pos(mob.get_pos())

func _draw():
	var cur_size = get_size()
	draw_rect(Rect2(Vector2(0, 0), cur_size), Color(0.2, 0.1, 0))
