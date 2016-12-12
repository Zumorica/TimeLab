/obj/electricity/machine/door
	icon = 'images/door.dmi'
	icon_state = "CLOSED"
	layer = ABOVE_MOBS
	density = 1
	opacity = 1
	var/state = DOOR_CLOSED
	var/open_state = "OPEN"
	var/opening_state = "OPENING"
	var/closed_state = "CLOSED"
	var/closing_state = "CLOSING"
	var/close_delay = 30

	/obj/electricity/machine/door/Interacted(mob/other)
		if (istype(other, /mob/living/human) && get_dist(src, other) <= 1 && !other.inventory_items[other.active_hand])
			if (state == DOOR_CLOSED)
				open()
		..(other)

	/obj/electricity/machine/door/Bumped(atom/other)
		if (other.type == /mob/living/human)
			if (state == DOOR_CLOSED)
				open()
		..(other)

	/obj/electricity/machine/door/proc/open()
		if (state == DOOR_CLOSED && health)
			state = DOOR_OPENING
			flick(opening_state, src)
			icon_state = open_state
			spawn(7)
				state = DOOR_OPEN
				opacity = 0
				density = 0
				if (close_delay)
					spawn(close_delay)
						close()

	/obj/electricity/machine/door/proc/close()
		if (state == DOOR_OPEN && health)
			state = DOOR_CLOSING
			flick(closing_state, src)
			icon_state = closed_state
			spawn(7)
				state = DOOR_CLOSED
				density = 1
				opacity = 1
