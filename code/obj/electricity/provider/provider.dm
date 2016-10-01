/obj/electricity/provider
	required_watts = 0
	provider = 1
	var/providing_range = 32													// Objects within this range will receive energy.
	var/stored_joules = 0
	var/stored_joules_max = 1000000000											// Maximum value for storing joules.

	/obj/electricity/provider/New()
		spawn (10)
			looper.schedule(src)
		..()

	/obj/electricity/provider/Update()
		if (game.game_state != PRE_ROUND)
			if (stored_joules < 0)
				stored_joules = 0
			if (stored_joules > stored_joules_max)
				stored_joules = stored_joules_max
			for (var/obj/electricity/o in orange(providing_range, src))
				if (!o.provider && o != src)
					o.provider = src
				else if (o.provider == src)
					o.Consume_power()

		..()
