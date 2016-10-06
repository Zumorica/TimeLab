/obj/electricity/provider/extender
	name = "Wireless energy extender"
	icon = 'images/extender.dmi'
	icon_state = "off"
	density = 1
	var/extends_extender = 0
	extra_required_watts = 0
	required_watts = 2500
	providing_range = 32
	z_providing_range = 2
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

			if (provider.stored_joules > 0 && (provider.stored_joules -= (required_watts + extra_required_watts)) >= 0)
				provider.stored_joules -= (required_watts + extra_required_watts)
				stored_joules += (required_watts + extra_required_watts)
				icon_state = ""
				powered = 1

	/obj/electricity/provider/extender/verb/Info()
		set src in view()
		usr << "Provider: [provider]"
		usr << "Stored joules: [stored_joules] / [stored_joules_max]"
		usr << "Powered: [powered]"
		usr << "Extends extender: [extends_extender]"
		usr << "Required Watts: [required_watts]"
		usr << "Extra Required Watts: [extra_required_watts]"
