var/datum/controller/elevator/elevator = new/datum/controller/elevator

/datum/controller/elevator
	var/elevator_z = 3
	var/elevator_sleep = 30														// Number of milliseconds to sleep before the elevator goes up or down.
	var/spawned = 0
	var/destination = 1
	var/state = ELEVATOR_STOP
	var/list/elevators

	/datum/controller/elevator/New()
		src.elevators = new/list
		..()

	/datum/controller/elevator/Update()
		var/area/elevator/a = GetCurrentArea()
		if (elevator_z == destination)
			state = ELEVATOR_STOP
		if (istype(a))
			switch (state)
				if (ELEVATOR_STOP)
					return
				if (ELEVATOR_UP)
					if (!spawned)
						spawned = 1
						spawn(elevator_sleep)
							a.floor_up()
							spawned = 0
				if (ELEVATOR_DOWN)
					if (!spawned)
						spawned = 1
						spawn(elevator_sleep)
							a.floor_down()
							spawned = 0
		..()

	/datum/controller/elevator/proc/GoToFloor(var/floor as num)
		if (floor > 0 && floor <= world.maxz && floor != elevator_z && state == ELEVATOR_STOP)
			destination = floor
			if (floor > elevator_z)
				state = ELEVATOR_UP
			else if (floor < elevator_z)
				state = ELEVATOR_DOWN
			return 1
		return 0

	/datum/controller/elevator/proc/GetCurrentArea()
		for (var/area/elevator/e in world)
			if (e.z == elevator_z)
				return e
		return
