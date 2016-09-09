/obj/electricity/machine/door/elevator_door
	name = "Elevator door"
	close_delay = 0
	var/send_message = 1

	/obj/electricity/machine/door/elevator_door/open()
		if (elevator.elevator_z == z && elevator.state == ELEVATOR_STOP)
			..()
		else
			if (send_message)
				view(4) << "The elevator door won't budge!"
				send_message = 0
				spawn(5)
					send_message = 1
