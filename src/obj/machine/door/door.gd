extends 'res://src/obj/machine/machine.gd'

const OPEN = 0
const CLOSED = 1
const OPENING = 2
const CLOSING = 3

var door_state = CLOSED
	
func _ready():
	set_pickable(true)
	set_process_input(true)
	if not is_connected("on_collided", self, "_on_collided"):
		connect("on_collided", self, "_on_collided")
	if not is_connected("on_clicked", self, "_on_clicked"):
		connect("on_clicked", self, "_on_clicked")
	
sync func open():
	get_node("AnimationPlayer").play("open_animation")
	
sync func close():
	get_node("AnimationPlayer").play("close_animation")
	
func _on_collided(other):
	if door_state == CLOSED:
		rpc("open")

func _on_clicked():
	if get_node("/root/timeline").own_client.get_mob().get_pos().distance_to(get_pos()) < 100:
		var mpos = get_local_mouse_pos()
		if (mpos.x >= -16 and mpos.x <= 16) and (mpos.y >= -16 and mpos.y <= 16):
			if door_state != OPENING or door_state != CLOSING:
				if door_state == OPEN:
					rpc("close")
				elif door_state == CLOSED:
					rpc("open")