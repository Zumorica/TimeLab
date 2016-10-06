/area/lab/elevator
	luminosity = 5

	/area/lab/elevator/New()
		name = "Elevator on basement [z]"
		elevator.elevators.Add(src)
		return ..()

	/area/lab/elevator/proc/CheckNextZ()
		if (z == world.maxz)
			elevator.maxz = world.maxz
		else
			var/atom/other = src[1]
			var/atom/otherup = locate(other.x, other.y, other.z + 1)
			var/area/a = otherup.GetArea()
			if (a.type == /area/lab/elevator)
				var/area/lab/elevator/b = a
				return b.CheckNextZ()
			else
				elevator.maxz = other.z
				return

	/area/lab/elevator/proc/floor_up()
		for (var/atom/movable/other in src)
			var/atom/oloc = locate(other.x, other.y, other.z + 1)
			var/area/lab/elevator/a = oloc.GetArea()
			if (other.type == /obj/electricity/machine/door/elevator_door)
				elevator.elevator_z = oloc.z
				continue
			if (istype(a))
				a.opacity = 0
				other.loc = oloc
				elevator.elevator_z = oloc.z
				other << "<b> Basement:</b><big> [elevator.elevator_z] </big>"
			else
				world.log << "<red>Error!</red> [a] is not elevator..."
		opacity = 1

	/area/lab/elevator/proc/floor_down()
		if (elevator.elevator_z >= 1)
			for (var/atom/movable/other in src)
				var/atom/oloc = locate(other.x, other.y, other.z - 1)
				var/area/lab/elevator/a = oloc.GetArea()
				if (other.type == /obj/electricity/machine/door/elevator_door)
					elevator.elevator_z = oloc.z
					continue
				if (istype(a))
					a.opacity = 0
					other.loc = oloc
					elevator.elevator_z = oloc.z
					other << "<b> Basement:</b><big> [elevator.elevator_z] </big>"
				else
					world.log << "<red>Error!</red> [a] is not elevator..."
			opacity = 1
