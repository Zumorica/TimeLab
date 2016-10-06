/mob/living
	var/intention = INTERACT_INTENTION
	var/interact_range = 1

	/mob/living/Clicked(atom/other)
		if (life_state == ALIVE && get_dist(src, other) <= interact_range)
			if (inventory_items[active_hand])
				other.Interacted(usr)
			else
				if (intention == INTERACT_INTENTION)
					other.Interacted(usr)
				else if (intention == HARM_INTENTION)
					if (other == src)
						view(6) << "[src] punches \himself."
					else
						view(6) << "[src] punches [other]!"
					attack(other)
