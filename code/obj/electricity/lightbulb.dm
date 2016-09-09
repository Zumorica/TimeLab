/obj/electricity/lightbulb
	name = "Lightbulb"
	icon = 'images/lightbulb.dmi'
	layer = ABOVE_MOBS
	health = 10
	required_watts = 50
	luminosity = 5
	var/isBroken = 0
	var/on_state = ""
	var/off_state = "OFF"
	var/broken_state = "BROKEN"

	/obj/electricity/lightbulb/Died()
		if (!isBroken)
			view(3) << "*<b>CRASH!</b>*"
			view(3) << "The lightbulb breaks!"
			isBroken = 1
			off()

	/obj/electricity/lightbulb/proc/off()
		if (isBroken == 0)
			icon_state = off_state
		else
			icon_state = broken_state
		luminosity = 0
		powered = 0

	/obj/electricity/lightbulb/proc/on()
		if (isBroken == 0)
			icon_state = on_state
			luminosity = 4
			powered = 1

	/obj/electricity/lightbulb/verb/Break_lightbulb()
		set src in view(1)
		set name = "Break"
		name = "Broken lightbulb"
		if (isBroken == 1)
			usr << "The lightbulb is already broken, silly!"
			view(3) << "[usr.name] attempts to break a broken lightbulb..."
		else
			usr << "You break the lightbulb!"
			view(3) << "[usr.name] breaks the lightbulb"
		isBroken = 1
		off()

/obj/electricity/lightbulb/north
	on_state = "ON_NORTH"
	off_state = "OFF_NORTH"
	broken_state = "BROKEN_NORTH"
	icon_state = "ON_NORTH"

/obj/electricity/lightbulb/south
	on_state = "ON_SOUTH"
	off_state = "OFF_SOUTH"
	broken_state = "BROKEN_SOUTH"
	icon_state = "ON_SOUTH"

/obj/electricity/lightbulb/west
	on_state = "ON_WEST"
	off_state = "OFF_WEST"
	broken_state = "BROKEN_WEST"
	icon_state = "ON_WEST"

/obj/electricity/lightbulb/east
	on_state = "ON_EAST"
	off_state = "OFF_EAST"
	broken_state = "BROKEN_EAST"
	icon_state = "ON_EAST"
