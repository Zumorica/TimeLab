/obj/electricity/machine/door/elevator_door
	name = "Elevator door"
	
	/obj/electricity/machine/door/elevator_door/open()
		if (elevator.elevator_z == z && elevator.state == ELEVATOR_STOP)
			..()
		else
			view(4) << "The elevator door won't budge!"
