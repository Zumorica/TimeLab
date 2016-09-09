/area/elevator
	luminosity = 5

	/area/elevator/New()
		name = "Elevator on floor [z]"
		elevator.elevators.Add(src)
		return ..()

	/area/elevator/proc/CheckNextZ()
		if (z == world.maxz)
			elevator.maxz = world.maxz
		else
			var/atom/other = src[1]
			var/atom/otherup = locate(other.x, other.y, other.z + 1)
			var/area/a = otherup.GetArea()
			if (a.type == /area/elevator)
				return
			else
				elevator.maxz = other.z

	/area/elevator/proc/floor_up()
		for (var/atom/movable/other in src)
			var/atom/oloc = locate(other.x, other.y, other.z + 1)
			var/area/elevator/a = oloc.GetArea()
			if (other.type == /obj/electricity/machine/door/elevator_door)
				elevator.elevator_z = oloc.z
				continue
			if (istype(a))
				a.opacity = 0
				other.loc = oloc
				elevator.elevator_z = oloc.z
				other << "<b> Floor:</b><big> [elevator.elevator_z] </big>"
			else
				world << "<red>Error!</red> [a] is not elevator..."
		opacity = 1

	/area/elevator/proc/floor_down()
		if (elevator.elevator_z >= 1)
			for (var/atom/movable/other in src)
				var/atom/oloc = locate(other.x, other.y, other.z - 1)
				var/area/elevator/a = oloc.GetArea()
				if (other.type == /obj/electricity/machine/door/elevator_door)
					elevator.elevator_z = oloc.z
					continue
				if (istype(a))
					a.opacity = 0
					other.Move(oloc)
					elevator.elevator_z = oloc.z
					other << "<b> Floor:</b><big> [elevator.elevator_z] </big>"
				else
					world << "<red>Error!</red> [a] is not elevator..."
			opacity = 1
