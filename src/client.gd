extends Node

signal mind_enter(mind)
signal mind_exit(mind)

sync var ID
sync var is_alive = true
sync var _mind setget get_mind, set_mind # Weak ref.
sync var preround_ready = false

func _ready():
	assert typeof(ID) == TYPE_INT
	if get_tree().get_network_unique_id() == ID:
		set_network_mode(NETWORK_MODE_MASTER)
	else:
		set_network_mode(NETWORK_MODE_SLAVE)
	add_to_group("clients")
	
func has_client():
	return typeof(_mind.get_ref()) == TYPE_OBJECT
	
func get_client():
	return _mind.get_ref()
	
func set_client(mind):
	if get_tree().is_network_server() or get_tree().get_network_unique_id() == ID:
		assert typeof(mind) == TYPE_OBJECT
		assert mind extends load(timelab.base.mind)
		rset("_mind", weakref(mind))
		if mind.get_client() != self:
			mind.set_client(self)
		emit_signal("mind_enter", mind)
			
func remove_client():
	if get_tree().is_network_server() or get_tree().get_network_unique_id() == client.ID:
		var mind = get_mind()
		rset("_mind", null)
		if mind.get_client() == self:
			mind.remove_mind()
		emit_signal("mind_exit", mind)