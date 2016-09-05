/mob
	step_size = 32

/mob/living
	var/intention = NO_INTENTION

	/mob/living/Clicked(atom/other)
		if (intention == INTERACT_INTENTION)
			return																// To be implemented
		else if (intention == HARM_INTENTION)
			attack(other)
