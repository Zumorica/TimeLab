extends "res://src/obj/obj.gd"

var is_closed = true
var click_delay = false

func _ready():
	var timer = Timer.new()
	timer.set_wait_time(0.5)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "delay_over")
	timer.set_name("Timer")
	add_child(timer)
	if not is_connected("on_interacted", self, "on_interacted"):
		connect("on_interacted", self, "on_interacted")
		
sync func close():
	var area = get_node("Area2D")
	for body in area.get_overlapping_bodies():
		if body.get_parent() == get_parent() and (body extends s_base.item or body extends s_base.mob):
			body.remove_speak_area()
			body.get_parent().remove_child(body)
			get_node("Contents").add_child(body)
			body.add_speak_area()
			body.state |= s_flag.CANT_ATTACK
			body.state |= s_flag.CANT_WALK
			body.state |= s_flag.CANT_USE_ITEMS
			body.state |= s_flag.CANT_INTERACT
			body.state |= s_flag.CANT_BE_INTERACTED
	get_node("CollisionShape2D").set_trigger(false)
	get_node("Open").hide()
	get_node("Sprite").show()
	emote("closes.")
	is_closed = true

sync func open():
	for child in get_node("Contents").get_children():
		child.remove_speak_area()
		get_node("Contents").remove_child(child)
		get_parent().add_child(child)
		child.add_speak_area()
		child.state ^= s_flag.CANT_ATTACK
		child.state ^= s_flag.CANT_WALK
		child.state ^= s_flag.CANT_USE_ITEMS
		child.state ^= s_flag.CANT_INTERACT
		child.state ^= s_flag.CANT_BE_INTERACTED
	get_node("CollisionShape2D").set_trigger(true)
	get_node("Open").show()
	get_node("Sprite").hide()
	emote("opens.")
	is_closed = false

func delay_over():
	click_delay = false

func on_interacted(other, item):
	if not click_delay:
		if is_closed == true:
			rpc("open")
		else:
			rpc("close")
		get_node("Timer").start()
		click_delay = true