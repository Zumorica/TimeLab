/obj/electricity/provider
	required_watts = -1
	provider = 1
	var/providing_range = 32													// Objects within this range will receive energy.
	var/stored_joules = 0
	var/stored_joules_max = 10000000											// Maximum value for storing joules.

	/obj/electricity/provider/New()
		spawn (10)
			looper.schedule(src)
		..()

	/obj/electricity/provider/Update()
		if (stored_joules < 0)
			stored_joules = 0
		if (powered)
			for (var/obj/electricity/o in oview(providing_range))
				if (!o.provider && o.provider != 1)
					o.provider = src
				else if (o.provider == src)
					o.Consume_power()

		..()
