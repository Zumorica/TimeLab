/datum
	var/is_updated = 0															// If an object's update is scheduled,
																				// this will be 1, otherwise it will be 0
	/datum/Del()																// Unschedule before deleting objects.
		if (is_updated)
			looper.unschedule(src)
			return ..()
		..()

	/datum/proc/Update_icon()
		return

	/datum/proc/Update()														// Proc that will be called if an object is scheduled.
		Update_icon()
		return
