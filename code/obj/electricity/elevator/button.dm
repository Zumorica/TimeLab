/obj/electricity/elevator/button
	name = "Elevator button"
	desc = "Calls the elevator."
	icon = 'images/lightswitch.dmi'
	layer = ABOVE_TURFS
	required_watts = 0
	luminosity = 1
	powered = 1
	var/on_state = ""
	var/off_state = "OFF"

	/obj/electricity/elevator/button/Interacted(mob/other)
		if (!elevator.GoToFloor(other.z))
			if (other.z == elevator.elevator_z)
				other << "The elevator is already here!"
			else if (elevator.state == ELEVATOR_UP || elevator.state == ELEVATOR_DOWN)
				other << "The elevator is currently busy! It is currently on floor [elevator.elevator_z]..."
		else
			other << "Elevator called. It will be here soon..."

/obj/electricity/elevator/button/north
	on_state = "ON_NORTH"
	off_state = "OFF_NORTH"
	icon_state = "ON_NORTH"
	pixel_y = 32

/obj/electricity/elevator/button/south
	on_state = "ON_SOUTH"
	off_state = "OFF_SOUTH"
	icon_state = "ON_SOUTH"
	pixel_y = -32

/obj/electricity/elevator/button/west
	on_state = "ON_WEST"
	off_state = "OFF_WEST"
	icon_state = "ON_WEST"
	pixel_x = -32

/obj/electricity/elevator/button/east
	on_state = "ON_EAST"
	off_state = "OFF_EAST"
	icon_state = "ON_EAST"
	pixel_x = 32
