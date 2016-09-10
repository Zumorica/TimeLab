// Not to be confused with in-game time loops. Based on a snippet by Rushnut.

var/looper/looper = new/looper													// Creates a global scheduler/looper.

/looper

	var/ticks = 1																// Ticks before updating everything.
	var/list/scheduled															// Lists of objects to be scheduled.

	/looper/New()
		src.scheduled = new/list
		spawn loop()															// Spawns the looper.
		return ..()

	/looper/proc/loop()															// Main loop.
		for()
			iterate()
			sleep(world.tick_lag * ticks)										// Wait a certain amount of ticks before looping again.

	/looper/proc/iterate()														// Iterate through all objects.
		for(var/datum/d in scheduled)
			d.Update()

	/looper/proc/schedule(datum/other)											// Schedules datums.
		if (!other.is_updated && !scheduled.Find(other))
			other.is_updated = 1
			scheduled.Add(other)
			return 1
		return 0

	/looper/proc/unschedule(datum/other)										// Unschedules datums.
		if (other.is_updated)
			return scheduled.Remove(other)
		return 0
