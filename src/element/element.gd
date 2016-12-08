extends PhysicsBody2D

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
var z_floor = 0 setget set_floor,get_floor
var last_pos = Vector2(0, 0)
var last_move = Vector2(0, 0)

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

func _ready():
	set_pickable(true)