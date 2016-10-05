/client
	var/rank = "User"
	var/will_join = 0

	/client/New()
		spawn ()
			game.clients.Add(src)
		MakeMacro("A+REP", ".West")
		MakeMacro("D+REP", ".East")
		MakeMacro("W+REP", ".North")
		MakeMacro("S+REP", ".South")
		MakeMacro("O", "OOC")
		screen += title
		..()

	/client/Click(other, location, control, params)
		if (mob)
			mob.Clicked(other, location, control, params)
		return ..(other, location, control, params)

	/client/proc/MakeMacro(var/key, var/command)
		winset(src, url_encode(command), "parent=macro;name=[key];command=[url_encode(command)]")

	/client/verb/Rank()
		usr << rank

	/client/verb/OOC(message as text)
		set category = "OOC"
		for (var/client/c in game.clients)
			c << "<b>(OOC) [usr]:</b> [message]"

	/client/verb/Who()												// Lists online players.
		set category = "OOC"
		usr << "Online players:"
		for(var/client/c in game.clients)
			usr << "[c]"

	/client/Del()
		game.clients.Remove(src)
		..()
