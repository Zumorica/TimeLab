extends Node
tool

func _ready():
	Globals.set("node/timeline", timeline)
	Globals.add_property_info({
		"name" : "node/timeline",
		"type" : TYPE_OBJECT,
		"hint" : PROPERTY_HINT_ALL_FLAGS,
		"hint_string" : "The timeline."})

# Base scripts.
const element_base = preload("res://src/element/element.gd")
const mob_base = preload("res://src/mob/mob.gd")
const client_base = preload("res://src/client/client.gd")

# Direction constants
const NORTH = 0
const SOUTH = 1
const WEST = 2
const EAST = 3
const direction_index = {0 : Vector2(0, -1),
						 1 : Vector2(0, 1),
						 2 : Vector2(-1, 0),
						 3 : Vector2(1, 0)}

# State bit flags
const DEAD = int(pow(2,0)) # When this element is dead/destroyed.
const BURNING = int(pow(2,1)) # When this element is on fire.
const MUTE = int(pow(2,2)) # When this element can't talk.
const BLIND = int(pow(2,3)) # When this element can't see.
const DEAF = int(pow(2,4)) # When this element can't hear.
const CANT_WALK = int(pow(2,5)) # When this element can't walk.
const CANT_ATTACK = int(pow(2,6)) # When this element can't attack.
const CANT_USE_ITEMS = int(pow(2, 7)) # When this element can't use items.
const CANT_INTERACT = int(pow(2, 8)) # When this element can't interact with others.
const CANT_BE_INTERACTED = int(pow(2, 9)) # When others can't interact with this element.

# Intents.
const INTENT_NONE = 0
const INTENT_INTERACT = 1
const INTENT_ATTACK = 2