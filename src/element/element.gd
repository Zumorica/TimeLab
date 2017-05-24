extends KinematicBody2D

signal move(element, new_cell_position, old_cell_position)

sync var state = 0
export sync var is_solid = false setget ,set_solid  # Whether you can walk through this element or not.
export sync var is_opaque = false setget ,set_opaque # Whether you can see through this element or not.
sync var cell_position = Vector2(0, 0)
sync var old_cell_position = Vector2(0, 0)
func _ready():
	rset_config("position", RPC_MODE_SYNC)
	add_to_group("element")
	timelab.connect("game_start", self, "_game_start")

func _game_start():
	if timelab.has_game_started():
		cell_position = timelab.map.world_to_map(position)
		old_cell_position = cell_position
		timelab.map.track_element_on_map(self)
		
func set_solid(value):
	assert typeof(value) == TYPE_BOOL
	rset("is_solid", value)
	
func set_opaque(value):
	assert typeof(value) == TYPE_BOOL
	rset("is_opaque", value)
	
func queue_free():
	if timelab.has_game_started():
		timelab.map.rpc("tracked_element_remove", self)
	.queue_free()