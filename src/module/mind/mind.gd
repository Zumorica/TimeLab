extends Camera2D

signal client_enter(client)
signal client_exit(client)

sync var _client = null setget get_client, set_client # Weak ref.

func _ready():
	assert get_parent() extends load(timelab.base.element)
	set_name("Mind")
	set_network_mode(NETWORK_MODE_INHERIT)
	
func has_client():
	return typeof(_client.get_ref()) == TYPE_OBJECT
	
func get_client():
	return _client.get_ref()
	
func set_client(client):
	if get_tree().is_network_server() or get_tree().get_network_unique_id() == client.ID:
		assert typeof(client) == TYPE_OBJECT
		assert client extends load(timelab.base.client)
		rset("_client", weakref(client))
		if client.get_mind() != self:
			client.set_mind(self)
		emit_signal("client_enter", client)

func remove_client():
	if get_tree().is_network_server() or get_tree().get_network_unique_id() == client.ID:
		var client = get_client()
		rset("_client", null)
		if client.get_mind() == self:
			client.remove_mind()
		emit("client_exit", client)