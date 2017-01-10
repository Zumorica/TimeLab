extends "res://src/container/container.gd"

func drop(slot):
	if !storage.has(slot):
		return
	var item = storage[slot]
	remove_item(slot)
	var client = timeline.get_current_client()
	var mob = client.get_mob()
	var item_path = item.get_path()
	timeline.rpc("_sync_drop", item_path, mob)

func _draw():
	var cur_size = get_size()
	draw_rect(Rect2(Vector2(0, 0), cur_size), Color(0.2, 0.1, 0))
