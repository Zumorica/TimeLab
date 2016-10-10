extends Node2D

var mob

func _ready():
	mob = get_node("Mob")
	set_process(true)
	set_process_input(true)
	
func _process(dt):
	pass

func _input(event):
	if (event.is_action("ui_up")):
		mob.move_local_y(-32, true)
		
	if (event.is_action("ui_down")):
		mob.move_local_y(32, true)
		
	if (event.is_action("ui_left")):
		mob.move_local_x(-32, true)
		
	if (event.is_action("ui_right")):
		mob.move_local_x(32, true)

func change_mob(mob):
	pass