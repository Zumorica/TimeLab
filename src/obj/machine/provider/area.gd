extends Area2D

func _ready():
	for node in get_overlapping_bodies():
		emit_signal("body_enter", node)
