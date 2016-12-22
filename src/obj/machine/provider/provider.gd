extends 'res://src/obj/machine/machine.gd'

export(bool) var can_be_provided = false
export(int) var generated_output = 0
var can_generate_electricity = true
var providing_list = []

func _ready():
	_set_powered(true)
	is_movable = false
	if not can_be_provided:
		provider = self

func _on_providing_range_body_enter(body):
	if body extends preload("res://src/obj/machine/machine.gd"):
		if body.get_provider() == null or not body.is_powered() and not providing_list.has(body):
			body.rpc("set_provider", self)
			providing_list.append(body)

func _on_providing_range_body_exit(body):
	if body extends preload("res://src/obj/machine/machine.gd"):
		if body.get_provider() == self and providing_list.has(body):
			body.rpc("set_provider", null)
			providing_list.remove(providing_list.find(body))

sync func request_electricity(joules):
	if joules > 0 and joules <= stored_joules:
		stored_joules -= joules
		return joules
	else:
		return false

func generate_electricity():
	if is_network_master():
		if is_powered() and can_generate_electricity:
			rpc_unreliable("set_stored_joules", get_stored_joules() + generated_output)