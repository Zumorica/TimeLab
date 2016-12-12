/mob
	step_size = 32																// Makes mobs move an entire tile per step.
	var/list/inventory_items = list("right_hand" = null, "left_hand" = null, "right_pocket" = null, "left_pocket" = null, "back" = null, "keychain" = null)
	var/active_hand = "right_hand"

	/mob/proc/MakeMacro(var/key, var/command)
		winset(src, url_encode(command), "parent=macro;name=[key];command=[url_encode(command)]")
