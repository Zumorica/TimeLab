/mob/new_player
	/mob/new_player/Stat()
		switch (game.game_state)
			if (PRE_ROUND)
				stat("Round state:", "Pre-round.")
			if (PLAYING)
				stat("Round state:", "Playing.")
			if (ROUND_FAIL)
				stat("Round state:", "Time loop incoming.")
			if (ROUND_SUCCESS)
				stat("Round state:", "The end! Thanks for playing.")

		if (game.game_state == PRE_ROUND)
			if (game.round_eta >= 0)
				stat("Round start ETA:", game.round_eta)
			else
				stat("Round start ETA:", "DELAYED.")
