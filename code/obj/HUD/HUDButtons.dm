/world/proc/CREATE_BUTTON(s_loc, b_name, m_id, icon_file)														// Creates a button with given screen location, name, and menu id.
	world_hud[m_id] += new/obj/HUD/Button(s_loc, b_name, b_name, m_id, icon_file)								// The button's name serves both as the icon state and the function.

/obj/HUD/Button
	mouse_opacity = 1
	layer = 21

	/obj/HUD/Button/New(s_loc, b_name, i_state, m_id, icon_file)
		if(icon_file)
			icon = icon_file
		..(s_loc, b_name, i_state, m_id)

	/obj/HUD/Button/Click()																			// Handles button clicks.
		var/mob/living/human/M = usr
		if(src.name == "Close Window")
			M.CLOSE_WINDOW(src.menu_id)
		else
			M.BUTTON_CLICK(src)
