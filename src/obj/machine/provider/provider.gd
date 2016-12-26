extends 'res://src/obj/machine/machine.gd'

export(bool) var can_be_provided = false
export(int) var generated_output = 0
sync var can_generate_electricity = true
sync var providing_list = []

func _ready():
	_set_powered(true)
	is_movable = false
	if not can_be_provided:
		provider = self

func _on_providing_range_body_enter(body):
	if body extends preload("res://src/obj/machine/machine.gd"):
		if body.get_provider() == null or not body.is_powered() and not providing_list.has(body):
			body.set_provider(self)
			providing_list.append(body)
			rset("providing_list", providing_list)

func _on_providing_range_body_exit(body):
	if body extends preload("res://src/obj/machine/machine.gd"):
		if body.get_provider() == self and providing_list.has(body):
			body.set_provider(null)
			providing_list.remove(providing_list.find(body))
			rset("providing_list", providing_list)

sync func request_electricity(joules):
	if joules > 0 and joules <= stored_joules:
		rset("stored_joules", stored_joules - joules)
		return joules
	else:
		return false

func generate_electricity():
	if is_network_master():
		_set_powered(true)
		if is_powered() and can_generate_electricity:
			set_stored_joules(get_stored_joules() + generated_output)