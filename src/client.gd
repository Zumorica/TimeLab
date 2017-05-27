extends Node

sync var ID
sync var is_alive = true

sync var preround_ready = false

func _ready():
	assert typeof(ID) == TYPE_INT
	if get_tree().get_network_unique_id() == ID:
		set_network_mode(NETWORK_MODE_MASTER)
	else:
		set_network_mode(NETWORK_MODE_SLAVE)
	add_to_group("clients")