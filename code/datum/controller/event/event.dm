/datum/controller/event
	var/name = "Generic event"													// Human-readable name.
	var/codename = "genevent"													// Codename for the event.
	var/event_eta = 0															// Time until event starts.
	var/can_substract = 1
	var/event_started = 0
	var/event_finished = 0

	/datum/controller/event/New()
		spawn (5)
			looper.schedule(src)
		spawn(5)
			game.events.Add(src)
		..()

	/datum/controller/event/Del()
		game.events.Remove(src)
		..()

	/datum/controller/event/Update()
		if (game.game_state == PLAYING && !event_finished && !event_started)
			if (event_eta > 0 && can_substract)
				event_eta -= 1
				can_substract = 0
				spawn(10) can_substract = 1

			else if (event_eta == 0)
				event_started = 1
				Start()

	/datum/controller/event/proc/Start()										// To be overriden by events.
		return

	/datum/controller/event/proc/Finished()										// For when events are finished.
		return
