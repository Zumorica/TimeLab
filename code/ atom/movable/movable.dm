/atom/movable
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
