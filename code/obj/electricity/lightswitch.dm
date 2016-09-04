/obj/electricity/lightswitch
	name = "Light switch"
	icon = 'images/lightswitch.dmi'
	required_watts = 0
	luminosity = 1
	powered = 1
	var/on_state = ""
	var/off_state = "OFF"

	/obj/electricity/lightswitch/verb/Power_on_lights()
		set src in view(1)
		powered = 1
		for (var/obj/electricity/lightbulb/O in src.loc.loc.contents)
			if ((O.type == /obj/electricity/lightbulb) || (O.type == /obj/electricity/lightbulb/north) || (O.type == /obj/electricity/lightbulb/south) || (O.type == /obj/electricity/lightbulb/west) || (O.type == /obj/electricity/lightbulb/east))
				O.on()

		icon_state = on_state

	/obj/electricity/lightswitch/verb/Power_off_lights()
		set src in view(1)
		powered = 0
		icon_state = off_state
		for (var/obj/electricity/lightbulb/O in src.loc.loc.contents)
			if ((O.type == /obj/electricity/lightbulb) || (O.type == /obj/electricity/lightbulb/north) || (O.type == /obj/electricity/lightbulb/south) || (O.type == /obj/electricity/lightbulb/west) || (O.type == /obj/electricity/lightbulb/east))
				O.off()

/obj/electricity/lightswitch/north
	on_state = "ON_NORTH"
	off_state = "OFF_NORTH"
	Power_on_lights()

/obj/electricity/lightswitch/south
	on_state = "ON_SOUTH"
	off_state = "OFF_SOUTH"
	Power_on_lights()

/obj/electricity/lightswitch/west
	on_state = "ON_WEST"
	off_state = "OFF_WEST"
	Power_on_lights()

/obj/electricity/lightswitch/east
	on_state = "ON_EAST"
	off_state = "OFF_EAST"
	Power_on_lights()
