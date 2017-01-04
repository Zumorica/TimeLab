extends "res://src/obj/machine/machine.gd"

export(float) var conveyor_velocity = 30
var conveyor_direction = Vector2(0, 0)
var bodies = []

func _ready():
	get_node("CollisionShape2D").set_trigger(true)
	set_fixed_process(true)
	if direction == s_direction.NORTH:
		set_rotd(0)
		conveyor_direction = Vector2(0, -1)
	elif direction == s_direction.SOUTH:
		set_rotd(180)
		conveyor_direction = Vector2(0, 1)
	elif direction == s_direction.WEST:
		set_rotd(90)
		conveyor_direction = Vector2(-1, 0)
	elif direction == s_direction.EAST:
		set_rotd(270)
		conveyor_direction = Vector2(1, 0)
		
func _fixed_process(dt):
	if is_powered():
		for body in bodies:
			if body extends timeline.element_base and not body extends self.get_script():
				if body.is_movable != false:
					body.move(conveyor_direction * conveyor_velocity * dt)
					body.rpc_unreliable("set_pos", body.get_pos())

func _on_Area2D_body_enter( body ):
	if body == self:
		return
	bodies.append(body)

func _on_Area2D_body_exit( body ):
	if not bodies.has(body):
		return
	bodies.remove(bodies.find(body))

func _on_Conveyor_on_power_off():
	get_node("AnimationPlayer").set_active(false)


func _on_Conveyor_on_power_on():
	get_node("AnimationPlayer").set_active(true)
	get_node("AnimationPlayer").play("move_conveyor", -1, conveyor_velocity/2.5)
