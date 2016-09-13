// Used as storage for admin verbs.

/mob/admin
	/mob/admin/verb/Start_round()
		set category = "Admin"
		if (!game.finished_loading)
			usr << "<font color=red>The game hasn't finished loading yet!</font>"
		else if (game.game_state == PRE_ROUND)
			game.start_round()
		else
			usr << "<font color=red>Can't start a new round now!</font>"
