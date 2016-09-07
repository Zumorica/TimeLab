/obj/electricity/lightswitch
	name = "Light switch"
	icon = 'images/lightswitch.dmi'
	layer = ABOVE_TURFS
	required_watts = 0
	luminosity = 1
	powered = 1
	var/switch_state = 1														// Wether the switch is on or off.
	var/on_state = ""
	var/off_state = "OFF"

	/obj/electricity/lightswitch/Interacted(mob/other)
		if (istype(other, /mob/living/human) && get_dist(src, other) <= 1)
			if (switch_state)
				Power_off_lights()
			else
				Power_on_lights()
			view(4) << "*click*"

	/obj/electricity/lightswitch/verb/Press_lightswitch()
		set src in view(1)
		if (switch_state)
			Power_off_lights()
		else
			Power_on_lights()
		view(4) << "*click*"

	/obj/electricity/lightswitch/proc/Power_on_lights()
		for (var/obj/electricity/lightbulb/O in src.loc.loc.contents)
			if ((O.type == /obj/electricity/lightbulb) || (O.type == /obj/electricity/lightbulb/north) || (O.type == /obj/electricity/lightbulb/south) || (O.type == /obj/electricity/lightbulb/west) || (O.type == /obj/electricity/lightbulb/east))
				O.on()

		for (var/obj/electricity/lightswitch/L in src.loc.loc.contents)
			L.icon_state = L.on_state
			L.switch_state = 1

	/obj/electricity/lightswitch/proc/Power_off_lights()
		for (var/obj/electricity/lightbulb/O in src.loc.loc.contents)
			if ((O.type == /obj/electricity/lightbulb) || (O.type == /obj/electricity/lightbulb/north) || (O.type == /obj/electricity/lightbulb/south) || (O.type == /obj/electricity/lightbulb/west) || (O.type == /obj/electricity/lightbulb/east))
				O.off()

		for (var/obj/electricity/lightswitch/L in src.loc.loc.contents)
			L.icon_state = L.off_state
			L.switch_state = 0

/obj/electricity/lightswitch/north
	on_state = "ON_NORTH"
	off_state = "OFF_NORTH"
	icon_state = "ON_NORTH"
	pixel_y = 32

/obj/electricity/lightswitch/south
	on_state = "ON_SOUTH"
	off_state = "OFF_SOUTH"
	icon_state = "ON_SOUTH"
	pixel_y = -32

/obj/electricity/lightswitch/west
	on_state = "ON_WEST"
	off_state = "OFF_WEST"
	icon_state = "ON_WEST"
	pixel_x = -32

/obj/electricity/lightswitch/east
	on_state = "ON_EAST"
	off_state = "OFF_EAST"
	icon_state = "ON_EAST"
	pixel_x = 32
