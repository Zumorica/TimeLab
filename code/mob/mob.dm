/mob
	step_size = 32																// Makes mobs move an entire tile per step.

/mob/living
	var/intention = NO_INTENTION

	/mob/living/Clicked(atom/other)
		if (intention == INTERACT_INTENTION)
			return																// To be implemented
		else if (intention == HARM_INTENTION)
			attack(other)
