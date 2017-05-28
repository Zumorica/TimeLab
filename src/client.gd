extends Node

signal mind_enter(mind)
signal mind_exit(mind)

sync var ID
sync var is_alive = true
sync var _mind = null setget get_mind, set_mind
sync var preround_ready = false

func _ready():
	assert typeof(ID) == TYPE_INT
	if get_tree().get_network_unique_id() == ID:
		set_network_mode(NETWORK_MODE_MASTER)
	else:
		set_network_mode(NETWORK_MODE_SLAVE)
	add_to_group("clients")
	
func has_mind():
	return (typeof(_mind) == TYPE_OBJECT)
	
func get_mind():
	return _mind
	
func set_mind(mind):
	if get_tree().is_network_server() or get_tree().get_network_unique_id() == ID:
		assert typeof(mind) == TYPE_OBJECT
		assert mind extends load(timelab.base.mind)
		rset("_mind", mind)
		_mind = mind
		print(_mind)
		if mind.has_client():
			if mind.get_client() != self:
				mind.set_client(self)
		else:
			mind.set_client(self)
		emit_signal("mind_enter", mind)
			
func remove_mind():
	if has_mind():
		if get_tree().is_network_server() or get_tree().get_network_unique_id() == ID:
			var mind = get_mind()
			rset("_mind", null)
			if mind.get_client() == self:
				mind.remove_mind()
			emit_signal("mind_exit", mind)