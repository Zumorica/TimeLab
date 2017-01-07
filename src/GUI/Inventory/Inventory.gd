extends "res://src/container/container.gd"

func drop(slot):
	if !storage.has(slot):
		return
	var item = storage[slot]
	remove_item(slot)
	var client = get_parent().get_parent().get_parent()#This has to be changed eventually, pfft.
	var mob = client.get_mob()
	get_node("/root/Map").add_child(item)
	item.set_pos(mob.get_pos())

func _draw():
	var cur_size = get_size()
	draw_rect(Rect2(Vector2(0, 0), cur_size), Color(0.2, 0.1, 0))
