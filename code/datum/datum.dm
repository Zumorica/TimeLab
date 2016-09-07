/datum
	var/is_updated = 0

	/datum/Del()
		if (is_updated)
			looper.unschedule(usr)
			return ..()
		..()

	/datum/proc/Update()
		return
