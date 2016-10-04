/mob/living/human
	icon = 'images/scientist.dmi'
	luminosity=0
	attack_factor = 0.5
	damage_factor = 0.75
	intention = INTERACT_INTENTION

	/mob/living/human/Clicked(other, location, control, params)
		..()

	/mob/living/human/Update()
		UPDATE_HUD()
		..()

	/mob/living/human/Login()
		if(!loc)
			looper.schedule(usr)
			loc = locate(3, 3, 1)
		else
			world << "[usr] has reconnected."

		client.screen += world_hud["HLeft"]														// Displays HUDS.
		client.screen += world_hud["AHRight"]
		client.screen += world_hud["Pocket"]
		client.screen += world_hud["Pocket1"]
		client.screen += world_hud["HealthDisplay"]
		client.screen += world_hud["Intent"]
		client.screen += world_hud["DropButton"]
		client.screen += world_hud["ThrowButton"]
		client.screen += world_hud["Back"]
		client.screen += world_hud["Keychain"]
		..()

	/mob/living/human/Logout()
		client.screen -= world_hud["HLeft"]
		client.screen -= world_hud["AHRight"]
		client.screen -= world_hud["Pocket"]
		client.screen -= world_hud["Pocket1"]
		client.screen -= world_hud["HealthDisplay"]
		client.screen -= world_hud["Intent"]
		..()

	/mob/living/human/Died()
		src.transform = turn(src.transform, 90)
		density = 0
		speak_state = CANT_SPEAK
		attack_state = CANT_ATTACK
		move_state = CANT_MOVE
		life_state = DEAD

	/mob/living/human/verb/Say(msg as text)
		var/spaceless = ReplaceText(msg, " ", "")
		var/tabless = ReplaceText(spaceless, "	", "")
		if (length(tabless))
			switch(speak_state)
				if (CAN_SPEAK)
					view(8) << "[usr] says, \"[msg]\""
					speak_state = CANT_SPEAK
					spawn(5)
						speak_state = CAN_SPEAK
				if (MUTE)
					view(4) << "[usr] looks like \he's trying to speak, but no sounds come out of \his mouth."
					speak_state = CANT_SPEAK
					spawn(5)
						speak_state = MUTE
				if (GAGGED)
					view(5) << pick("[usr] mumbles, \"HMPF! Hmpf\"", "[usr] mumbles, \"Hmph!\"", "[usr] mumbles, \"Hmph...\"", "[usr] mumbles, \"HMHMHMHMPH! HMPH.\"", "[usr] mumbles, \"Hm. Hmpf hmpf.\"")
					spawn(5)
						speak_state = GAGGED
				else
					return

	/mob/living/human/verb/Whisper(M as mob in oview(1), msg as text)
		var/spaceless = ReplaceText(msg, " ", "")
		var/tabless = ReplaceText(spaceless, "	", "")
		if (length(tabless))
			switch(speak_state)
				if (CAN_SPEAK)
					M << "[usr] whispers, \"<i>[msg]</i>\""
					speak_state = CANT_SPEAK
					spawn(5)
						speak_state = CAN_SPEAK
				if (MUTE)
					M << "[usr] looks like \he's trying to whisper to you, but no sounds come out of \his mouth."
					speak_state = CANT_SPEAK
					spawn(5)
						speak_state = MUTE
				if (GAGGED)
					M << pick("[usr] mumbles quietly, \"HMPF! Hmpf\"", "[usr] mumbles quietly, \"Hmph!\"", "[usr] mumbles quietly, \"Hmph...\"", "[usr] mumbles quietly, \"HMHMHMHMPH! HMPH.\"", "[usr] mumbles quietly, \"Hm. Hmpf hmpf.\"")
					spawn(5)
						speak_state = GAGGED
				else
					return

	/mob/living/human/verb/Shout(msg as text)
		var/spaceless = ReplaceText(msg, " ", "")
		var/tabless = ReplaceText(spaceless, "	", "")
		if (length(tabless))
			switch(speak_state)
				if (CAN_SPEAK)
					view(16) << "[usr] shouts, \"<b><big>[uppertext(msg)]!!</b></big>\""
					speak_state = CANT_SPEAK
					spawn(5)
						speak_state = CAN_SPEAK
				if (MUTE)
					view(8) << "[usr] looks like \he's trying to shout, but no sounds come out of \his mouth."
					speak_state = CANT_SPEAK
					spawn(5)
						speak_state = MUTE
				if (GAGGED)
					view(10) << pick("[usr] mumbles loudly, \"HMPF! Hmpf\"", "[usr] mumbles loudly, \"Hmph!\"", "[usr] mumbles loudly, \"Hmph...\"", "[usr] mumbles loudly, \"HMHMHMHMPH! HMPH.\"", "[usr] mumbles loudly, \"Hm. Hmpf hmpf.\"")
					spawn(5)
						speak_state = GAGGED
				else
					return

	/mob/living/human/verb/Die()
		damage(max_health)

	/mob/living/human/Stat()
		var/intentName = ""
		if(intention == HARM_INTENTION)
			intentName = "Harm"
		else
			intentName = "Interact"																// Displays stats, like health and intent.
		statpanel("General")
		stat("Health: ", health)
		stat("Intent: ", intentName)

	/mob/living/human/proc/SwitchIntention()													// Switches intents.
		set name = "Switch Intention"
		if(intention == HARM_INTENTION)
			intention = INTERACT_INTENTION
			client.screen -= world_hud["Intent1"]
			client.screen += world_hud["Intent"]
		else
			intention = HARM_INTENTION
			client.screen -= world_hud["Intent"]
			client.screen += world_hud["Intent1"]

	/mob/living/human/proc/CLOSE_WINDOW(var/m_id)												// Closes a HUD window.
		if(m_id == "All")
			for(var/V in world_hud)
				if(V != "Main HUD")
					src.client.screen -= world_hud[V]
		else
			src.client.screen -= world_hud[m_id]


		src.CLEAR_TEXT(m_id)

	/mob/living/human/proc/BUTTON_CLICK(var/obj/HUD/Button/B)									// Handles HUD button clicks.
		switch(B.name)
			if("IntentButton")
				SwitchIntention()
			if("IntentButton1")
				SwitchIntention()
			if("RightHand")
				client.screen -= world_hud["HRight"]
				client.screen += world_hud["AHRight"]
				client.screen -= world_hud["AHLeft"]
				client.screen += world_hud["HLeft"]
				active_hand = "right_hand"
			if("LeftHand")
				client.screen -= world_hud["HLeft"]
				client.screen += world_hud["AHLeft"]
				client.screen -= world_hud["AHRight"]
				client.screen += world_hud["HRight"]
				active_hand = "left_hand"
			if("Pocket")
				if(usr.life_state == ALIVE)
					inventory.change(usr, "left_pocket")
			if("Pocket1")
				if(usr.life_state == ALIVE)
					inventory.change(usr, "right_pocket")
			if("Back")
				if(usr.life_state == ALIVE)
					inventory.change(usr, "back")
			if("Keychain")
				if(usr.life_state == ALIVE)
					inventory.change(usr, "keychain")
			if("Drop")
				if(usr.life_state == ALIVE && usr.inventory_items[active_hand])
					inventory.dropItem(usr)
			if("StorageClose")
				if(usr.life_state == ALIVE)
					for(var/obj/item/container/c in usr.contents)
						c.close(usr)
			else
				return


	/mob/living/human/proc/UPDATE_HUD()															// Updates Health for now.
		switch(health)
			if(50 to 99)
				client.screen -= world_hud["HealthDisplay"]
				client.screen += world_hud["HealthDisplay1"]
			if(1 to 49)
				client.screen -= world_hud["HealthDisplay1"]
				client.screen += world_hud["HealthDisplay2"]
			if(0)
				client.screen -= world_hud["HealthDisplay2"]
				client.screen += world_hud["HealthDisplay3"]
