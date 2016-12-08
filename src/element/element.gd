extends CollisionObject2D

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
var speed = 64

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

func _ready():
	set_pickable(true)
	set_fixed_process(true)
	
func _fixed_process(dt):
	if is_network_master() and get_parent() extends get_node("/root/timeline").client_code_base:
		var move_direction = Vector2(0, 0)
		if Input.is_action_pressed("ui_up"):
			move_direction += direction_index[NORTH]
		if Input.is_action_pressed("ui_down"):
			move_direction += direction_index[SOUTH]
		if Input.is_action_pressed("ui_left"):
			move_direction += direction_index[WEST]
		if Input.is_action_pressed("ui_right"):
			move_direction += direction_index[EAST]
			
		if move_direction != Vector2(0, 0):
			last_pos = get_pos()
			last_move = move_direction
			move(move_direction * speed * dt)
			if is_colliding():
				var normal = get_collision_normal()
				move_direction = normal.slide(move_direction)
				move(move_direction * speed * dt)
			rpc_unreliable("_update_pos", get_pos())
		