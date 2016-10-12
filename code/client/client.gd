extends Node2D

var mob

func _ready():
	mob = get_node("Mob")
	if get_node("/root/lobby").started_networking:
		set_name(str(get_tree().get_network_unique_id()))
	set_process(true)
	set_process_input(true)
	
func _process(dt):
	pass

sync func move_local_y(quantity, boolean):
	mob.move_local_y(quantity, boolean)
	
sync func move_local_x(quantity, boolean):
	mob.move_local_x(quantity, boolean)

func _input(event):
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