// Not to be confused with in-game time loops. Based on a snippet by Rushnut.

var/Looper/looper = new/Looper													// Creates a global scheduler/looper.

/Looper

	var/ticks = 1																// Ticks before updating everything.
	var/list/scheduled															// Lists of objects to be scheduled.

	/Looper/New()
		spawn loop()															// Spawns the looper.
		return ..()

	/Looper/proc/loop()															// Main loop.
		for()
			iterate()
			sleep(world.tick_lag * ticks)										// Wait a certain amount of ticks before looping again.

	/Looper/proc/iterate()														// Iterate through all objects.
		for(var/datum/d in scheduled)
			d.Update()

	/Looper/proc/schedule(datum/other)											// Schedules datums.
		if (!other.is_updated && !scheduled.Find(other))
			other.is_updated = 1
			scheduled.Add(other)
			return 1
		return 0

	/Looper/proc/unschedule(datum/other)										// Unschedules datums.
		if (other.is_updated)
			return scheduled.Remove(other)
		return 0
