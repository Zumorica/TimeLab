// Not to be confused with in-game time loops. Based on a snippet by Rushnut.

var/Looper/looper = new/Looper

/Looper

	var/ticks = 1																// Ticks before updating everything.
	var/list/scheduled

	/Looper/New()
		spawn loop()
		return ..()

	/Looper/proc/loop()
		for()
			iterate()
			sleep(world.tick_lag * ticks)

	/Looper/proc/iterate()
		for(var/datum/d in scheduled)
			d.Update()

	/Looper/proc/schedule(datum/other)											// Schedules datums.
		if (!other.is_updated && !scheduled.Find(other))
			other.is_updated = 1
			scheduled.Add(other)
			return 1
		return 0

	/Looper/proc/unschedule(datum/other)
		if (other.is_updated)
			return scheduled.Remove(other)
		return 0
