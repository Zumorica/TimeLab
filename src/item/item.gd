extends "res://src/element/element.gd"

signal on_pickup(mob)
signal on_stored(container)
signal on_inventory_texture_change(new_texture)

export(Texture) var inventory_image setget get_inventory_texture, set_inventory_texture

func get_inventory_texture():
	return inventory_image
	
sync func set_inventory_texture(texture):
	inventory_image = texture
	emit_signal("on_inventory_texture_change", new_texture)