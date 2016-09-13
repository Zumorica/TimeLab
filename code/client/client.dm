/client
	var/rank = "User"

	/client/New()
		spawn ()
			game.clients.Add(src)
		screen += title
		..()

	/client/Click(other, location, control, params)
		if (mob)
			mob.Clicked(other, location, control, params)
		return ..(other, location, control, params)

	/client/verb/Rank()
		usr << rank

	/client/verb/OOC(message as text)
		set category = "OOC"
		for (var/client/c in game.clients)
			c << "<b>(OOC) [usr]:</b> [message]"

	/client/Del()
		game.clients.Remove(src)
		..()
