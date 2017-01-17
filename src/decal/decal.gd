extends Node2D

export(bool) var auto_delete = false
export(float) var auto_delete_delay = 150
export(int) var decay_child = 0

func _ready():
	if auto_delete:
		var auto_delete_timer = Timer.new()
		auto_delete_timer.set_name("AutodelTimer")
		auto_delete_timer.set_one_shot(true)
		auto_delete_timer.connect("timeout", self, "queue_free")
		add_child(auto_delete_timer)
		auto_delete_timer.start()
	for node in get_children():
		node.hide()
	get_node(str(decay_child)).show()
	