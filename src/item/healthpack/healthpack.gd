extends "res://src/item/item.gd"

export var heal_value = 15
var uses_left = 2

func _ready():
	if not is_connected("on_used", self, "_on_used"):
		connect("on_used", self, "_on_used")
		
func _on_used(other, holder):
	if other:
		if other extends timelab.base.mob and other.health != other.max_health and uses_left:
			other.rpc("heal", heal_value, str(get_path()))
			if other != holder:
				holder.emote("heals %s using the health pack." % other.show_name)
			else:
				if holder.gender == timelab.gender.NEUTRAL:
					holder.emote("heals itself using the health pack.")
				elif holder.gender == timelab.gender.MALE:
					holder.emote("heals himself using the health pack.")
				elif holder.gender == timelab.gender.FEMALE:
					holder.emote("heals herself using the health pack.")
			uses_left -= 1
		elif not uses_left:
			emote("has no more uses left.")