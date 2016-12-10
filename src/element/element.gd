extends CollisionObject2D

signal on_direction_change(direction)
signal on_collided(collider)	# When something collides with the element.
signal on_collide(collider)		# When the element collides with something.

const NORTH = 0
const SOUTH = 1
const WEST = 2
const EAST = 3
const direction_index = {0 : Vector2(0, -1),
						 1 : Vector2(0, 1),
						 2 : Vector2(-1, 0),
						 3 : Vector2(1, 0)}
						
export(int, "NORTH", "SOUTH", "WEST", "EAST") var direction = 0
var z_floor = 0 setget set_floor,get_floor
var last_pos = Vector2(0, 0)
var last_move = Vector2(0, 0)
var last_collider = null
var speed = 128

func set_floor(z):
		z_floor = z

func get_floor():
	return z_floor
	
func set_pos3(vector):
	assert (typeof(vector) == TYPE_VECTOR3)
	set_floor(vector.z)
	if get_floor() == vector.z:
		set_pos(vector.x, vector.y)

func get_pos3():
	var pos = get_pos()
	return Vector3(pos.x, pos.y, get_floor())

slave func _update_pos(pos):
	set_pos(pos)

slave func _update_direction(direction):
	direction = direction
	emit_signal("on_direction_change", direction)

func _ready():
	set_pickable(true)
	set_fixed_process(true)
	
func _fixed_process(dt):
	if get_node("/root/timeline").is_online:
		if self extends KinematicBody2D:
			if is_network_master() and get_parent() extends get_node("/root/timeline").client_code_base and !get_node("/root/UserInterface").is_chat_visible:
				var move_direction = Vector2(0, 0)
				var old_direction = direction
				if Input.is_action_pressed("ui_up"):
					move_direction += direction_index[NORTH]
					direction = NORTH
					last_collider = null
				if Input.is_action_pressed("ui_down"):
					move_direction += direction_index[SOUTH]
					direction = SOUTH
					last_collider = null
				if Input.is_action_pressed("ui_left"):
					move_direction += direction_index[WEST]
					direction = WEST
					last_collider = null
				if Input.is_action_pressed("ui_right"):
					move_direction += direction_index[EAST]
					direction = EAST
					last_collider = null
					
				if move_direction != Vector2(0, 0):
					last_pos = get_pos()
					last_move = move_direction
					move(move_direction * speed * dt)
					if is_colliding():
						var normal = get_collision_normal()
						move_direction = normal.slide(move_direction)
						last_collider = get_collider()
						emit_signal("on_collide", get_collider())
						if get_collider() extends get_node("/root/timeline").element_base:
							get_collider().emit_signal("on_collided", self)
						move(move_direction * speed * dt)
					rpc_unreliable("_update_pos", get_pos())
				if old_direction != direction:
					rpc_unreliable("_update_direction", direction)
					emit_signal("on_direction_change", direction)
			