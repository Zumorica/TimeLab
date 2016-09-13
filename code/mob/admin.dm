// Used as storage for admin verbs.

/mob/admin
	/mob/admin/verb/Start_round()
		set category = "Admin"
		if (!game.finished_loading)
			usr << "<color=#FF0000>The game hasn't finished loading yet!</color>"
		else if (game.game_state == PRE_ROUND)
			game.start_round()
