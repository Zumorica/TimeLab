extends Camera2D

signal client_enter(client)
signal client_exit(client)

sync var _client = null setget get_client, set_client

func _ready():
	assert get_parent() extends load(timelab.base.element)
	set_name("Mind")
	set_network_mode(NETWORK_MODE_INHERIT)
	
func has_client():
	return (typeof(_client) == TYPE_OBJECT)
	
func get_client():
	return _client
	
func set_client(client):
	if get_tree().is_network_server() or get_tree().get_network_unique_id() == client.ID:
		assert typeof(client) == TYPE_OBJECT
		assert client extends load(timelab.base.client)
		rpc("_set_client", client.get_path())
		if client.has_mind():
			if client.get_mind() != self:
				client.set_mind(self)
		else:
			client.set_mind(self)
		if get_tree().get_network_unique_id():
			get_parent().set_network_mode(NETWORK_MODE_MASTER)
		else:
			get_parent().rpc_id(client.ID, "set_network_mode", NETWORK_MODE_MASTER)
		emit_signal("client_enter", client)

sync func _set_client(path):
	_client = get_node(path)

func remove_client():
	if has_client():
		if get_tree().is_network_server() or get_tree().get_network_unique_id() == get_client().ID:
			var client = get_client()
			rset("_client", null)
			if client.get_mind() == self:
				client.remove_mind()
			emit("client_exit", client)
		
func _fixed_process(dt):
	if has_client():
		if get_tree().get_network_unique_id() == get_client().ID:
			var movement = Vector2(0, 0)
			if Input.is_action_pressed("move_left"):
				movement += timelab.direction.WEST
			if Input.is_action_pressed("move_right"):
				movement += timelab.direction.EAST
			if Input.is_action_pressed("move_up"):
				movement += timelab.direction.NORTH
			if Input.is_action_pressed("move_down"):
				movement += timelab.direction.SOUTH
			print(movement)
			if movement.length() > 0:
				print(get_parent().cell_slide(movement, true))