/atom/movable
	var/atom/old_loc
	var/move_state = CAN_MOVE
	var/move_delay = 3

	/atom/movable/GetArea()														// Returns the atom's area.
		if (!loc)
			return
		var/area/a = loc.loc
		while (a && !istype(a))
			a = a.loc
		return a

	/atom/movable/Bump(atom/a)													// Overrides Bump proc so /atom/proc/Bumped(atom/other) can be possible
		a.Bumped(src)
		return ..(a)

	/atom/movable/Move(atom/new_loc)											// Custom movement for movable atoms. To be improved.
		if (!loc || !new_loc || loc == new_loc)
			return 0
		old_loc = loc
		switch(move_state)
			if (CAN_MOVE)
				move_state = CANT_MOVE
				if(life_status != DEAD)
					spawn (move_delay)
						move_state = CAN_MOVE
					return ..()
			if (CANT_MOVE)
				return 0
			if (BUCKLED)
				return 0 // To be implemented
