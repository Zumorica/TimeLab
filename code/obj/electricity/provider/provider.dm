/obj/electricity/provider
	required_watts = 0
	provider = 1
	var/providing_range = 16													// Objects within this range will receive energy.
	var/z_providing_range = 0													// For wireless extenders.
	var/stored_joules = 0
	var/stored_joules_max = 1000000000											// Maximum value for storing joules.
	var/list/providing_list = list()

	/obj/electricity/provider/Update()
		..()
		var/new_watts = 0
		if (game.game_state != PRE_ROUND)
			if (stored_joules < 0)
				stored_joules = 0
			if (stored_joules > stored_joules_max)
				stored_joules = stored_joules_max
			if (stored_joules)
				powered = 1
			else
				powered = 0
			for (var/obj/electricity/o in orange(providing_range, src))
				if (!(o in providing_list) && o != src && !o.provider && provider)
					providing_list.Add(o)
					o.provider = src

			for (var/obj/electricity/o in range(z_providing_range, locate(x, y, z + 1)))
				if (!(o in providing_list) && o != src && !o.provider && provider)
					providing_list.Add(o)
					o.provider = src

			for (var/obj/electricity/o in providing_list)
				var/d = get_dist(src, o)
				if (o.z == z)
					if (d > providing_range && o.provider == src)
						providing_list.Remove(o)
						o.provider = 0
						continue
					else if (o.provider == src)
						o.provider = src
						if (stored_joules > required_watts + extra_required_watts)
							o.Consume_power()
						new_watts += o.required_watts + o.extra_required_watts
						continue
				else
					if (d > z_providing_range && o.provider == src)
						providing_list.Remove(o)
						o.provider = 0
						continue
					else if (o.provider == src)
						o.provider = src
						if (stored_joules > required_watts + extra_required_watts)
							o.Consume_power()
						new_watts += o.required_watts + o.extra_required_watts
						continue
			extra_required_watts = new_watts
