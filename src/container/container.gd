extends Node2D

signal on_item_stored(container, item)

export(int) var storage_size = 10
export(NodePath) var display_node

var storage = {}
# Containers will override the slot_list with their own slot (names or nodes though?)
var slot_list = []

func store_item(item, slot=null):
	if !slot:
		# If no slot is provided, by default the item will be stored in the first empty slot
		for s in slot_list:
			if not storage.has(s):
				slot = s
				break
	
	storage[slot] = item

func remove_item(item):
	pass

func display():
	pass
