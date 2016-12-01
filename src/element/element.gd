extends KinematicBody2D

export(int) var ID = 0
var z_floor = 0 setget set_floor,get_floor

func set_floor(z, add_to_node=true):
	if has_node("../.."):
		if get_node("../..") extends load("res://src/map/map.gd").Map and add_to_node:
			if z <= get_node("../..").get_map_size().z:
				get_node("../%s" %(z)).add_child(self)
				z_floor = z
		else:
			z_floor = z
	else:
		z_floor = z
	
func get_floor():
	return z_floor

func get_ID():
	return ID
	
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