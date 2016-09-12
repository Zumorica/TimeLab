/client
	var/rank = "User"

	/client/New()
		spawn ()
			game.clients.Add(src)
		..()

	/client/Click(other, location, control, params)
		if (mob)
			mob.Clicked(other, location, control, params)
		return ..(other, location, control, params)

	/client/verb/Rank()
		usr << rank

	/client/Del()
		game.clients.Remove(src)
		..()
