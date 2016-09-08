/mob/living/human
	icon = 'images/scientist.dmi'
	luminosity=0
	intention = INTERACT_INTENTION
	var/speakState = CAN_SPEAK

	/mob/living/human/Clicked(other, location, control, params)
		..()

	/mob/living/human/Login()
		if(!loc)
			world << "[usr] has joined."
			loc = locate(/turf/floor/generic/start)
		else
			world << "[usr] has reconnected."
		client.screen += world_hud["Main HUD"]													// Displays HUDS.
		client.screen += world_hud["HealthDisplay"]
		..()

	/mob/living/human/verb/Say(msg as text)
		var/spaceless = ReplaceText(msg, " ", "")
		var/tabless = ReplaceText(spaceless, "	", "")
		if (length(tabless))
			switch(speakState)
				if (CAN_SPEAK)
					view(8) << "[usr] says, \"[msg]\""
					speakState = CANT_SPEAK
					spawn(5)
						speakState = CAN_SPEAK
				if (MUTE)
					view(4) << "[usr] looks like \he's trying to speak, but no sounds come out of \his mouth."
					speakState = CANT_SPEAK
					spawn(5)
						speakState = MUTE
				if (GAGGED)
					view(5) << pick("[usr] mumbles, \"HMPF! Hmpf\"", "[usr] mumbles, \"Hmph!\"", "[usr] mumbles, \"Hmph...\"", "[usr] mumbles, \"HMHMHMHMPH! HMPH.\"", "[usr] mumbles, \"Hm. Hmpf hmpf.\"")
					spawn(5)
						speakState = GAGGED
				else
					return

	/mob/living/human/verb/Whisper(M as mob in oview(1), msg as text)
		var/spaceless = ReplaceText(msg, " ", "")
		var/tabless = ReplaceText(spaceless, "	", "")
		if (length(tabless))
			switch(speakState)
				if (CAN_SPEAK)
					M << "[usr] whispers, \"<i>[msg]</i>\""
					speakState = CANT_SPEAK
					spawn(5)
						speakState = CAN_SPEAK
				if (MUTE)
					M << "[usr] looks like \he's trying to whisper to you, but no sounds come out of \his mouth."
					speakState = CANT_SPEAK
					spawn(5)
						speakState = MUTE
				if (GAGGED)
					M << pick("[usr] mumbles quietly, \"HMPF! Hmpf\"", "[usr] mumbles quietly, \"Hmph!\"", "[usr] mumbles quietly, \"Hmph...\"", "[usr] mumbles quietly, \"HMHMHMHMPH! HMPH.\"", "[usr] mumbles quietly, \"Hm. Hmpf hmpf.\"")
					spawn(5)
						speakState = GAGGED
				else
					return

	/mob/living/human/verb/Shout(msg as text)
		var/spaceless = ReplaceText(msg, " ", "")
		var/tabless = ReplaceText(spaceless, "	", "")
		if (length(tabless))
			switch(speakState)
				if (CAN_SPEAK)
					view(16) << "[usr] says, \"[msg]\""
					speakState = CANT_SPEAK
					spawn(5)
						speakState = CAN_SPEAK
				if (MUTE)
					view(8) << "[usr] looks like \he's trying to shout, but no sounds come out of \his mouth."
					speakState = CANT_SPEAK
					spawn(5)
						speakState = MUTE
				if (GAGGED)
					view(10) << pick("[usr] mumbles loudly, \"HMPF! Hmpf\"", "[usr] mumbles loudly, \"Hmph!\"", "[usr] mumbles loudly, \"Hmph...\"", "[usr] mumbles loudly, \"HMHMHMHMPH! HMPH.\"", "[usr] mumbles loudly, \"Hm. Hmpf hmpf.\"")
					spawn(5)
						speakState = GAGGED
				else
					return

	/mob/living/human/verb/Who()																// Lists online players.
		var/mob/M
		usr << "Online players:"
		for(M in world)
			if(!M.key)
				continue
			else
				usr << M.key

	/mob/living/human/Stat()
		var/intentName = ""
		if(intention == HARM_INTENTION)
			intentName = "Harm"
		else
			intentName = "Interact"																// Displays stats, like health and intent.
		statpanel("General")
		stat("Health: ", health)
		stat("Intent: ", intentName)

	/mob/living/human/verb/SwitchIntention()													// Switches intents.
		set name = "Switch Intention"
		if(intention == HARM_INTENTION)
			intention = INTERACT_INTENTION
			usr << "You can now interact with things!"
		else
			intention = HARM_INTENTION
			usr << "You can now harm things!"

	/mob/living/human/attack(atom/other)														// Displays a message if you attack a player.
		if(istype(other, /mob/living/human))
			if(src == other)
				view() << "[src] attacks \himself."
			else
				view() << "[src] attacks [other]."
		..(other)

	/mob/living/human/proc/CLOSE_WINDOW(var/m_id)												// Closes a HUD window.
		if(m_id == "All")
			for(var/V in world_hud)
				if(V != "Main HUD")
					src.client.screen -= world_hud[V]
		else
			src.client.screen -= world_hud[m_id]


		src.CLEAR_TEXT(m_id)

	/mob/living/human/proc/BUTTON_CLICK(var/obj/HUD/Button/B)									// Handles HUD button clicks.
		//to be continued
