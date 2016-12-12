/datum/controller/event
	var/name = "Generic event"													// Human-readable name.
	var/codename = "genevent"													// Codename for the event.
	var/event_eta = -1															// Time until event starts. -1 to disable
	var/finish_eta = -1															// Time until event finishes -1 to disable
	var/can_substract = 1
	var/can_substract_finish = 1
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
				if (event_eta < 0)
					event_eta = 0
				spawn(10) can_substract = 1

			else if (event_eta == 0)
				event_started = 1
				Start()

		if (game.game_state == PLAYING && event_started && !event_finished)
			Update_event()
			if (finish_eta > 0 && can_substract_finish)
				finish_eta -= 1
				can_substract_finish = 0
				if (finish_eta < 0)
					finish_eta = 0
				spawn(10) can_substract_finish = 1

			else if (finish_eta == 0)
				event_finished = 1
				Finished()

	/datum/controller/event/proc/Start()										// For when events start.
		return

	/datum/controller/event/proc/Update_event()									// This proc is called as long as the event is active.
		return

	/datum/controller/event/proc/Finished()										// For when events are finished.
		return
