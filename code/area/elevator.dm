/area/elevator
	luminosity = 5

	/area/elevator/New()
		spawn ..()
		name = "Elevator on floor [z]"
		elevator.elevators.Add(src)
		looper.schedule(elevator)

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
