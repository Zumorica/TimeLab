extends Control

signal on_item_stored(container, item)

export(int) var storage_size = 10
export(NodePath) var display_node

var storage = {}
# Contains the slot nodes
var slot_list = []
var bound_item

func _ready():
	display_node = get_node(display_node)
	display_node.hide()
	for c in display_node.get_node("Background").get_children():
		slot_list.append(c)

func is_full():
	return storage.size() == storage_size

func get_item(slot):
	if storage.has(slot):
		return storage[slot]

func add_item(item, slot=null):
	if is_full():
		return
	if !slot:
		# If no slot is provided, by default the item will be stored in the first empty slot
		for s in display_node.get_child(0).get_children():
			if not s.has_item():
				slot = s
				break
	rpc("_add_item", item.get_path(), slot.get_path())
	

sync func _add_item(item_path, slot_path):
	var item = get_node(item_path)
	var slot = get_node(slot_path)
	storage[slot] = item
	item.remove_speak_area()
	item.get_parent().remove_child(item)
	slot.add_child(item)
	item.add_speak_area()
	item.set_pos(Vector2(2, 2))
	emit_signal("on_item_stored", self, item)

func remove_item(slot):
		slot.remove_child(slot.get_child(0))
		storage.erase(slot)

func display():
	display_node.show()
	display_node.update()

func hide_display():
	display_node.hide()

func bind_to_cursor(slot):
	if !storage.has(slot):
		return
	var item = storage[slot]
	item.set_process(true)
	bound_item = item
	# Fix item appearing behind slots
	slot.raise()

func bind_to_slot(slot):
	if bound_item:
		bound_item.set_process(false)
		storage.erase(bound_item.get_parent())
		add_item(bound_item, slot)
		bound_item = null