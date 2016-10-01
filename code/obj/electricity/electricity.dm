/obj/electricity																// Base object for all electricity-powered objects.
	var/powered = 0 															// Just for debugging.
	var/required_watts = 0
	var/obj/electricity/provider/provider = 0									// Links to the object's energy provider. Should be set to "1" if
																				// this object's provider is itself.
	/obj/electricity/proc/Consume_power()
		powered = 0
		if (!provider || provider == 1)
			return
		else
			if (provider.stored_joules > 0 && (provider.stored_joules -= required_watts) >= 0)
				provider.stored_joules -= required_watts
				powered = 1

	/obj/electricity/verb/Get_provider()
		set src in view()
		usr << "Provider: [provider]"
