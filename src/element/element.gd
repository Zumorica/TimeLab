extends Area2D

signal collision(other)
signal collided(other)

const NORTH = 0
const SOUTH = 1
const WEST = 2
const EAST = 3
const direction_index = {0 : Vector2(0, -32),
						 1 : Vector2(0, 32),
						 2 : Vector2(-32, 0),
						 3 : Vector2(32, 0)}
						
export(int, "NORTH", "SOUTH", "WEST", "EAST") var direction = 0
export(bool) var dense = false
var z_floor = 0 setget set_floor,get_floor
var last_pos = Vector2(0, 0)
var last_move = Vector2(0, 0)
var noclip = false

func set_floor(z):
		z_floor = z
	
func set_dense(boolean):
	dense = boolean
	
func is_dense():
	return dense
	
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
	
func move_to(direction):
	# for moving in directions
	assert typeof(direction) == TYPE_INT and direction in range(0, 4)
	
func move_by(vector):
	# for moving by vectors
	assert typeof(vector) == TYPE_VECTOR2
	
func can_move(where):
	if typeof(where) == TYPE_VECTOR2:
		pass
	elif typeof(where) == TYPE_INT and where in range(0, 4):
		pass
	return false

func _ready():
	set_pickable(true)