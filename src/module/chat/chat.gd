extends Node2D

export var speak_radius = 80

func _ready():
	create_speak_area()
		
func _exit_tree():
	destroy_speak_area()

func create_speak_area():
	var area = get_node("SpeakArea2D")
	if not area.has_node("CollisionShape2D"):
		var collision = CollisionShape2D.new()
		var shape = CircleShape2D.new()
		shape.set_radius(speak_radius)
		collision.set_shape(shape)
		collision.set_name("CollisionShape2D")
		area.add_child(collision)

func destroy_speak_area():
	var area = get_node("SpeakArea2D")
	if area.has_node("CollisionShape2D"):
		area.get_node("CollisionShape2D").free()
		
func get_listeners():
	if has_node("SpeakArea2D"):
		var listeners = get_node("SpeakArea2D").get_overlapping_bodies()
		listeners.append(get_parent())
		return listeners
		
func new_message(msg):
	if get_parent().get_client():
		var client = get_parent().get_client()
		client.rpc("update_chat", msg)
		
func hear(msg):
	if not (get_parent().state & s_flag.DEAF):
		new_message(msg)

func speak(msg):
	if not (get_parent().state & s_flag.MUTE):
		for child in get_listeners():
			if child extends s_base.element:
				if child.has_node("Chat"):
					var ochat = child.get_node("Chat")
					if ochat.has_method("hear"):
						ochat.hear('%s says "%s"' % [get_parent().show_name, msg])

func emote(emotion, leave_space=true):
	for child in get_listeners():
		if child extends s_base.element:
			if child.has_node("Chat"):
				var ochat = child.get_node("Chat")
				if ochat.has_method("hear"):
					if leave_space:
						ochat.hear("%s %s" %[get_parent().show_name, emotion])
					else:
						ochat.hear("%s%s" %[get_parent().show_name, emotion])