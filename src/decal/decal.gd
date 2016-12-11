extends Node2D

export(bool) var auto_delete = false
export(float) var auto_delete_delay = 150

func _ready():
	if auto_delete:
		var auto_delete_timer = Timer.new()
		auto_delete_timer.set_name("AutodelTimer")
		auto_delete_timer.set_one_shot(true)
		auto_delete_timer.connect("timeout", self, "queue_free")
		add_child(auto_delete_timer)
		auto_delete_timer.start()
	var count = -1
	for child in get_children():
		child.hide()
		count += 1
	randomize()
	var show_child = randi()%count
	get_node(str(show_child)).show()