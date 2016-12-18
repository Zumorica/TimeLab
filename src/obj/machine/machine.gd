extends 'res://src/obj/obj.gd'

signal on_new_provider(provider)
signal on_power_off()
signal on_power_on()

export(int) var required_watts = 0
export(int) var max_store_capacity = 1000
var stored_joules = 0 setget get_stored_joules,set_stored_joules
var provider = null setget get_provider,set_provider
var powered = false setget is_powered,_set_powered
	
func get_provider():
	return provider
	
func set_provider(new_provider):
	if new_provider extends load("res://src/obj/machine/provider/provider.gd") or new_provider == null:
		provider = new_provider
		emit_signal("on_new_provider", provider)
	
func is_powered():
	return powered
	
sync func _set_powered(value):
	assert typeof(value) == TYPE_BOOL
	powered = value
	if value:
		emit_signal("on_power_off")
	else:
		emit_signal("on_power_on")
	
func get_stored_joules():
	return stored_joules
	
sync func set_stored_joules(value):
	if value > max_store_capacity:
		stored_joules = max_store_capacity
	elif value < 0:
		stored_joules = 0
	else:
		stored_joules = value
	
func consume_electricity():
	if is_network_master():
		if provider or stored_joules:
			pass
		else:
			rpc("_set_powered", false)