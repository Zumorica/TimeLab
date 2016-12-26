extends 'res://src/obj/obj.gd'

signal on_new_provider(provider)
signal on_power_off()
signal on_power_on()

export(int) var required_watts = 0
export(int) var max_store_capacity = 1000
sync var stored_joules = 0 setget get_stored_joules,set_stored_joules
sync var provider = null setget get_provider,set_provider
sync var powered = false setget is_powered,_set_powered
	
func get_provider():
	return provider
	
func set_provider(new_provider):
	if is_network_master():
		if new_provider != null:
			if new_provider extends load("res://src/obj/machine/provider/provider.gd"):
				rset("provider", new_provider)
				rpc("emit_signal", "on_new_provider", provider)
		else:
			provider = new_provider
			rpc("emit_signal", "on_new_provider", provider)
	
func is_powered():
	return powered
	
func _set_powered(value):
	if is_network_master():
		assert typeof(value) == TYPE_BOOL
		rset("powered", value)
		if value:
			rpc("emit_signal", "on_power_on")
		else:
			rpc("emit_signal", "on_power_off")
	
func get_stored_joules():
	return stored_joules
	
func set_stored_joules(value):
	if is_network_master():
		if value > max_store_capacity:
			rset("stored_joules", max_store_capacity)
		elif value < 0:
			rset("stored_joules", 0)
		else:
			rset("stored_joules", value)
	
func consume_electricity():
	if is_network_master():
		if provider or stored_joules:
			if provider != self:
				var joules = provider.request_electricity(required_watts * 1.25)
				if not joules:
					joules = provider.request_electricity(required_watts)
				if joules:
					rset("stored_joules", stored_joules + joules)
					rset("stored_joules", stored_joules - required_watts)
					rpc("_set_powered", true)
				else:
					if stored_joules >= required_watts:
						rset("stored_joules", stored_joules - required_watts)
						_set_powered(true)
					else:
						_set_powered(false)
		else:
			_set_powered(false)