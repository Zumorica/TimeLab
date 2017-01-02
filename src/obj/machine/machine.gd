extends 'res://src/obj/obj.gd'

signal on_new_provider(provider)
signal on_power_off()
signal on_power_on()

export(int) var required_watts = 0
export(int) var max_store_capacity = 1000
remote var stored_joules = 0 setget get_stored_joules,set_stored_joules
remote var provider = null setget get_provider,set_provider
remote var powered = false setget is_powered,_set_powered

func _ready():
	verbs["Print info"] = "print_info"
	if has_node("Timer"):
		var timer = get_node("Timer")
		if not timer.is_connected("timeout", self, "consume_electricity"):
			timer.connect("timeout", self, "consume_electricity")

func get_provider():
	return provider

func print_info():
	print("Provider: ", get_provider())
	print("Is powered: ", is_powered())
	print("Stored joules: ", stored_joules, "J/", max_store_capacity, "J")

func set_provider(new_provider):
	if is_network_master():
		if new_provider != null:
			if new_provider extends load("res://src/obj/machine/provider/provider.gd"):
				rset("provider", new_provider)
				provider = new_provider
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
		powered = value
		if value:
			rpc("emit_signal", "on_power_on")
		else:
			rpc("emit_signal", "on_power_off")

func get_stored_joules():
	return stored_joules

func set_stored_joules(value):
	if is_network_master():
		if value > max_store_capacity:
			stored_joules = max_store_capacity
		elif value < 0:
			stored_joules = 0
		else:
			stored_joules = value
		rset("stored_joules", stored_joules)

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
					_set_powered(true)
				else:
					if stored_joules >= required_watts:
						stored_joules -= required_watts
						_set_powered(true)
					else:
						_set_powered(false)
		else:
			_set_powered(false)
		rset("stored_joules", stored_joules)
