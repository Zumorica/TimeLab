extends "res://src/obj/machine/machine.gd"

export(float) var conveyor_velocity = 30
var conveyor_direction = Vector2(0, 0)
var bodies = []

func _ready():
	get_node("CollisionShape2D").set_trigger(true)
	set_fixed_process(true)
	get_node("AnimationPlayer").play("move_conveyor", -1, conveyor_velocity/2.5)
	if direction == NORTH:
		set_rotd(0)
		conveyor_direction = Vector2(0, -1)
	elif direction == SOUTH:
		set_rotd(180)
		conveyor_direction = Vector2(0, 1)
	elif direction == WEST:
		set_rotd(90)
		conveyor_direction = Vector2(-1, 0)
	elif direction == EAST:
		set_rotd(270)
		conveyor_direction = Vector2(1, 0)
		
func _fixed_process(dt):
	for body in bodies:
		if body extends get_node("/root/timeline").element_base and not body extends self.get_script():
			if body.is_movable:
				body.move(conveyor_direction * conveyor_velocity * dt)
				body.rpc_unreliable("_update_pos", body.get_pos())

func _on_Area2D_body_enter( body ):
	if body == self:
		return
	bodies.append(body)

func _on_Area2D_body_exit( body ):
	if not bodies.has(body):
		return
	bodies.remove(bodies.find(body))