/obj/electricity/elevator/controls
	name = "Elevator controls"
	desc = "Where do you want to go? Choose it with these!"
	icon = 'images/lightswitch.dmi'
	layer = ABOVE_TURFS
	required_watts = 0
	luminosity = 1
	powered = 1
	var/on_state = ""
	var/off_state = "OFF"

	/obj/electricity/elevator/controls/Interacted(mob/other)
		if (elevator.state == ELEVATOR_UP || elevator.state == ELEVATOR_DOWN)
			other << "The elevator is currently busy! It is currently on floor [elevator.elevator_z]..."
			return

		var/direction = Input(User=other, Message="Input floor number. Current floor: [elevator.elevator_z]. Last floor: [world.maxz]", Title="Elevator controls") as num
		if (direction == elevator.elevator_z)
			other << "The elevator is already there!"

		else if (direction > world.maxz || direction <= 0)
			other << "Invalid floor."

		else
			elevator.GoToFloor(direction)

	/obj/electricity/elevator/controls/verb/Input(direction as num)
		set src in oview(1)
		if (elevator.state == ELEVATOR_UP || elevator.state == ELEVATOR_DOWN)
			oview(1) << "The elevator is currently busy! It is currently on floor [elevator.elevator_z]..."

		else if (direction == elevator.elevator_z)
			oview(1) << "The elevator is already there!"

		else if (direction > world.maxz || direction <= 0)
			oview(1) << "Invalid floor."

		else
			elevator.GoToFloor(direction)

	/obj/electricity/elevator/controls/Interacted(mob/other)
		// set src in oview(1)
		// var/direction = Input() as num
		// if (elevator.state == ELEVATOR_UP || elevator.state == ELEVATOR_DOWN)
		// 	other << "The elevator is currently busy! It is currently on floor [elevator.elevator_z]..."
		//
		// else if (direction == elevator.elevator_z)
		// 	other << "The elevator is already there!"
		//
		// else if (direction > world.maxz || direction <= 0)
		// 	other << "Invalid floor."
		//
		// else
		// 	elevator.GoToFloor(direction)
		oview(1) << "Not implemented yet. Please use the verb instead."


/obj/electricity/elevator/controls/north
	on_state = "ON_NORTH"
	off_state = "OFF_NORTH"
	icon_state = "ON_NORTH"
	pixel_y = 32

/obj/electricity/elevator/controls/south
	on_state = "ON_SOUTH"
	off_state = "OFF_SOUTH"
	icon_state = "ON_SOUTH"
	pixel_y = -32

/obj/electricity/elevator/controls/west
	on_state = "ON_WEST"
	off_state = "OFF_WEST"
	icon_state = "ON_WEST"
	pixel_x = -32

/obj/electricity/elevator/controls/east
	on_state = "ON_EAST"
	off_state = "OFF_EAST"
	icon_state = "ON_EAST"
	pixel_x = 32
