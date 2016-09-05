/client
	/client/Click(other, location, control, params)
		if (mob)
			mob.Clicked(other, location, control, params)
		return ..(other, location, control, params)
