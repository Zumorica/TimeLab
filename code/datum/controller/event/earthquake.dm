/datum/controller/event/earthquake
	name = "Earthquake"
	codename = "earthquake"
	event_eta = 3
	finish_eta = 5

	/datum/controller/event/earthquake/Start()
		for (var/mob/living/l in world)
			l << "The ground shakes violently!"

	/datum/controller/event/earthquake/Update_event()
		for (var/client/c in game.clients)
			c.eye = locate(c.mob)
			c.eye = locate(c.mob.x + rand(-1, 1), c.mob.y + rand(-1, 1), c.mob.z)

	/datum/controller/event/earthquake/Finished()
		for (var/client/c in game.clients)
			c.eye = c.mob

		for (var/mob/living/l in world)
			l << "The ground stops shaking..."
