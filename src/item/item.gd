extends "res://src/element/element.gd"

signal on_pickup(mob)
signal on_stored(container)
signal on_inventory_texture_change(new_texture)

export(Texture) var inventory_image setget get_inventory_texture, set_inventory_texture

func _ready():
	if not is_connected("on_interacted", self, "_on_interacted"):
		connect("on_interacted", self, "_on_interacted")

func _on_interacted(other, item):
	var client = other.get_client()
	var inv = client.get_node("UserInterface/Layer/Inventory")
	inv.add_item(self, inv.get_node("Background/RHandSlot"))

func get_inventory_texture():
	return inventory_image
	
sync func set_inventory_texture(texture):
	inventory_image = texture
	emit_signal("on_inventory_texture_change", inventory_image)

func _on_Area2D_input_event(viewport, event, shape_idx):
	_input_event(viewport, event, shape_idx)

func _process(dt):
	var mouse_pos = get_parent().get_local_mouse_pos()
	set_pos(mouse_pos)