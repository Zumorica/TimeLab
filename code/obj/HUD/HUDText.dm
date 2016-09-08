/image/var/menu_id

/mob/living/human/proc/DRAW_TEXT(var/text_string,var/screen_x,var/screen_y,var/pixel_x_offset,var/pixel_y_offset,var/m_id,var/image_name)	// Draws text on the given menu id, with optional offsets

	var/obj/HUD/H = src.TEXT_MENU_ID(m_id,screen_x,screen_y)
	if(!H)
		return

	var/tmp/pixel_x_plus																													// Moves each character further to the right.

	if(pixel_x_offset)
		pixel_x_plus += pixel_x_offset

	var/char_pos = 1
	var/char_len = length(text_string)

	while(char_pos < char_len+1)
		var/T = copytext(text_string,char_pos,char_pos+1)

		if(T != " ")
			var/image/I = image('images/HUDFont.dmi',H,"[T]",22)																			// H is the tile we're drawing on, T is the icon state and 22 is the layer.

			I.pixel_x += pixel_x_plus
			I.pixel_y = pixel_y_offset
			I.mouse_opacity = 0
			I.menu_id = m_id
			I.name = image_name

			src << I

		pixel_x_plus += font_width
		char_pos += 1



/mob/living/human/proc/TEXT_MENU_ID(var/m_id,var/screen_x,var/screen_y)																		// Finds the specific menu the text will be drawn on.
	var/obj/HUD/H = locate("[m_id] [screen_x],[screen_y]")
	return H



/mob/living/human/proc/CLEAR_TEXT(var/m_id,var/image_name)																					// Deletes text.

	if(image_name)
		for(var/image/I in src.client.images)
			if(I.name == image_name)
				del(I)

	else
		if(m_id == "All")
			for(var/image/I in src.client.images)
				if(I.menu_id != "Main HUD")
					del(I)

		else
			for(var/image/I in src.client.images)
				if(I.menu_id == m_id)
					del(I)
