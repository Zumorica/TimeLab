var/game/game = new/game

/game
	var/finished_loading = 0
	var/ranks_set = 0
	var/game_state = PRE_ROUND
	var/list/clients = list()

	/game/New()
		spawn(10)
			looper.schedule(src)
		..()

	/game/Update()
		switch (game_state)
			if (PRE_ROUND)
				if (!ranks_set && clients[1])
					spawn() set_ranks()

	/game/proc/set_ranks()
		var/tmp/raw = file2text("config/admins.txt")
		var/list/ranks = TextSplit(raw, "\n")
		for (var/rank in ranks)
			var/list/split = TextSplit(rank, "=")
			if (split)
				var/client/c = find_user(split[1])
				if (c)
					c.rank = split[2]
		ranks_set = 1

	/game/proc/find_user(var/name)
		for (var/client/c in clients)
			if ("[c]" == name)
				return c
		return 0
