/datum/controller/event/earthquake
	name = "Earthquake"
	codename = "earthquake"
	event_eta = 120
	finish_eta = 5
	var/earthquake_strenght = 1

	/datum/controller/event/earthquake/New()
		spawn(5)
			event_eta *= rand(1, 60)
			finish_eta *= rand(1, 12)
			earthquake_strenght *= rand()
		..()

	/datum/controller/event/earthquake/Start()
		for (var/mob/living/l in world)
			if (earthquake_strenght >= 0.75)
				l << "The ground shakes violently!"
			else if (earthquake_strenght >= 0.5)
				l << "The ground shakes!"
			else if (earthquake_strenght >= 0.25)
				l << "You feel the ground shaking."
			else if (earthquake_strenght < 0.25 && earthquake_strenght)
				l << "You feel the ground shaking mildly..."
			else if (!earthquake_strenght)
				l << "Huh? You think you felt something, but you can't really tell what..."
		..()

	/datum/controller/event/earthquake/Update_event()
		for (var/client/c in game.clients)
			c.eye = locate(c.mob)
			c.eye = locate(c.mob.x + (rand(-1, 1) * earthquake_strenght), c.mob.y + (rand(-1, 1) * earthquake_strenght), c.mob.z)

		for (var/obj/electricity/lightbulb/l in world)
			if (prob(0.10 * earthquake_strenght))
				l.damage(5)

		..()

	/datum/controller/event/earthquake/Finished()
		for (var/client/c in game.clients)
			c.eye = c.mob

		for (var/mob/living/l in world)
			l << "The ground stops shaking..."

		..()
