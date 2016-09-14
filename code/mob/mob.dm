/mob
	step_size = 32																// Makes mobs move an entire tile per step.
	var/list/inventory_items = list("right_hand" = null, "left_hand" = null, "right_pocket" = null, "left_pocket" = null)

/mob/living
	var/intention = NO_INTENTION

	/mob/living/Clicked(atom/other)
		if (life_state == ALIVE)
			if (intention == INTERACT_INTENTION)
				other.Interacted(usr)
			else if (intention == HARM_INTENTION && get_dist(src, other) <= 1)		//You can only attack things next to you.
				attack(other)
