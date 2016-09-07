/mob
	step_size = 32																// Makes mobs move an entire tile per step.

/mob/living
	var/intention = NO_INTENTION

	/mob/living/Clicked(atom/other)
		if (intention == INTERACT_INTENTION)
			other.Interacted(usr)
		else if (intention == HARM_INTENTION && get_dist(src, other) <= 1)		//You can only attack things next to you.
			attack(other)
