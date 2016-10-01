/obj/electricity/provider/extender
	name = "Wireless energy extender"
	icon = 'images/extender.dmi'
	icon_state = "off"
	density = 1
	var/extends_extender = 0
	var/extra_required_watts = 0
	required_watts = 2500
	providing_range = 32
	provider = 0
	stored_joules_max = 1000000000

	/obj/electricity/provider/extender/Consume_power()
		powered = 0
		icon_state = "off"
		if (!provider || provider == 1)
			return
		else
			if (istype(provider, /obj/electricity/provider/extender) && !extends_extender)
				extends_extender = 1
				required_watts = round(required_watts / 2)

			if (provider.stored_joules > 0 && (provider.stored_joules -= required_watts) >= 0)
				provider.stored_joules -= required_watts + extra_required_watts
				stored_joules += required_watts + extra_required_watts
				icon_state = ""
				powered = 1


	/obj/electricity/provider/extender/Update()
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
				if (powered)
					if (!o.provider && o.provider != 1)
						o.provider = src
						extra_required_watts += o.required_watts
					else if (o.provider == src)
						o.Consume_power()

		..()

	/obj/electricity/provider/extender/verb/Info()
		set src in view()
		usr << "Provider: [provider]"
		usr << "Stored joules: [stored_joules] / [stored_joules_max]"
		usr << "Powered: [powered]"
		usr << "Required Watts: [required_watts]"
