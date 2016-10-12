extends Node2D

var mob

func _ready():
	mob = get_node("Mob")
	print("I LIVE. AGAIN.", get_name(), get_node("..").get_name())
	set_process(true)
	set_process_input(true)
	
func _process(dt):
	pass

sync func change_name(name):
	set_name(name)

sync func move_local_y(quantity, boolean):
	mob.move_local_y(quantity, boolean)
	rpc("update_global_pos", get_global_pos())
	
sync func move_local_x(quantity, boolean):
	mob.move_local_x(quantity, boolean)
	rpc("update_global_pos", get_global_pos())

remote func update_global_pos(pos):
	set_global_pos(pos)

func _input(event):
	if get_name() == str(get_tree().get_network_unique_id()):
		if (event.is_action("ui_up")):
			rpc("move_local_y", -32, true)
			
		if (event.is_action("ui_down")):
			rpc("move_local_y", 32, true)
		
		if (event.is_action("ui_left")):
			rpc("move_local_x", -32, true)
			
		if (event.is_action("ui_right")):
			rpc("move_local_x", 32, true)

func change_mob(mob):
	pass