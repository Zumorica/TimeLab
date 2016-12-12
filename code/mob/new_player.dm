/mob/new_player
	/mob/new_player/Stat()
		if (client.will_join)
			stat("Joined game:", "Yes!")
		else
			stat("Joined game:", "No...")

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

	/mob/new_player/verb/Join_game()
		if (game.game_state == PRE_ROUND)
			client.will_join = 1
		else if (game.game_state == PLAYING)
			client.will_join = 1
			game.handle_new_human(client)

	/mob/new_player/verb/Say()
		set hidden = 1
