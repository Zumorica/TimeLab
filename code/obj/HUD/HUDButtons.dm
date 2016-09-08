/world/proc/CREATE_BUTTON(s_loc, b_name, m_id)
	world_hud[m_id] += new/obj/HUD/Button(s_loc, b_name, b_name, m_id)

/obj/HUD/Button
	mouse_opacity = 1
	layer = 21

	/obj/HUD/Button/Click()
		var/mob/living/human/M = usr
		if(src.name == "Close Window")
			M.CLOSE_WINDOW(src.menu_id)
		else
			M.BUTTON_CLICK(src)

