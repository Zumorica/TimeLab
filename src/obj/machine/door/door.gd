extends 'res://src/obj/machine/machine.gd'

const OPEN = 0
const CLOSED = 1
const OPENING = 2
const CLOSING = 3

var door_state = CLOSED
export(float) var close_delay = 5
	
func _ready():
	set_pickable(true)
	set_process_input(true)
	var close_timer = Timer.new()
	close_timer.set_name("CloseTimer")
	close_timer.set_wait_time(close_delay)
	close_timer.set_one_shot(true)
	close_timer.connect("timeout", self, "close")
	add_child(close_timer)
	if not is_connected("on_collided", self, "_on_collided"):
		connect("on_collided", self, "_on_collided")
	if not is_connected("on_interacted", self, "_on_interacted"):
		connect("on_interacted", self, "_on_interacted")
		
	
sync func open():
	get_node("AnimationPlayer").play("open_animation")
	get_node("CloseTimer").start()
	set_opacity(false)
	
sync func close():
	get_node("AnimationPlayer").play("close_animation")
	set_opacity(true)
	
func _on_collided(other):
	if door_state == CLOSED:
		rpc("open")

func _on_interacted(other, item):
	other = get_node(other)
	if other.get_pos().distance_to(get_pos()) < 100 and other.get_intent() == timelab.intent.INTERACT and is_powered():
		if door_state != OPENING or door_state != CLOSING:
			if door_state == OPEN:
				rpc("close")
			elif door_state == CLOSED:
				rpc("open")