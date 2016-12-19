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
	
sync func set_provider(new_provider):
	if new_provider != null:
		if new_provider extends load("res://src/obj/machine/provider/provider.gd"):
			provider = new_provider
			emit_signal("on_new_provider", provider)
	else:
		provider = new_provider
		emit_signal("on_new_provider", provider)
	
func is_powered():
	return powered
	
sync func _set_powered(value):
	assert typeof(value) == TYPE_BOOL
	powered = value
	if value:
		emit_signal("on_power_on")
	else:
		emit_signal("on_power_off")
	
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
			if provider != self:
				var joules = provider.request_electricity(required_watts * 1.25)
				if not joules:
					joules = provider.request_electricity(required_watts)
				if joules:
					stored_joules += joules
					stored_joules -= required_watts
					rpc("_set_powered", true)
				else:
					if stored_joules >= required_watts:
						stored_joules -= required_watts
						rpc("_set_powered", true)
					else:
						rpc("_set_powered", false)
		else:
			rpc("_set_powered", false)