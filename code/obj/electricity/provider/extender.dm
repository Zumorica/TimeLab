/obj/electricity/provider/extender
	name = "Wireless energy extender"
	icon = 'images/extender.dmi'
	icon_state = "off"
	density = 1
	required_watts = 10000
	providing_range = 32
	provider = 0
	stored_joules_max = 1000000000

	/obj/electricity/provider/extender/Consume_power()
		powered = 0
		icon_state = "off"
		if (!provider || provider == 1)
			return
		else
			if (provider.stored_joules > 0 && (provider.stored_joules -= required_watts) >= 0)
				provider.stored_joules -= required_watts
				stored_joules += required_watts
				icon_state = ""
				powered = 1


	/obj/electricity/provider/extender/Update()
		if (game.game_state != PRE_ROUND)
			if (stored_joules < 0)
				stored_joules = 0
			if (stored_joules > stored_joules_max)
				stored_joules = stored_joules_max
			for (var/obj/electricity/o in orange(providing_range, src))
				if (!o.provider && o.provider != 1 && o != src)
					o.provider = src
				else if (o.provider == src)
					o.Consume_power()

		..()
