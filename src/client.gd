extends Node

sync var ID
sync var is_alive = true

func _ready():
	assert typeof(ID) == TYPE_INT
	if get_tree().get_network_unique_id() == ID:
		set_network_mode(NETWORK_MODE_MASTER)
	else:
		set_network_mode(NETWORK_MODE_SLAVE)
	rpc_config("set_name", RPC_MODE_SYNC)
	add_to_group("clients")