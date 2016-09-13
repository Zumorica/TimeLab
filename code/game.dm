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
				if (ranks_set)
					finished_loading = 1

	/game/proc/set_ranks()
		var/tmp/raw = file2text("config/admins.txt")
		var/list/ranks = TextSplit(raw, "\n")
		for (var/rank in ranks)
			var/list/split = TextSplit(rank, "=")
			if (split)
				var/client/c = find_user(split[1])
				if (c)
					c.rank = split[2]
					if (split[2] == "admin")
						c.verbs += typesof(/mob/admin/verb)
		ranks_set = 1

	/game/proc/find_user(var/name)
		for (var/client/c in clients)
			if ("[c]" == name)
				return c
		return 0

	/game/proc/start_round()
		if (finished_loading)
			game_state = PLAYING
			for (var/client/c in clients)
				var/mob/living/human/h = new/mob/living/human
				h.name = "[c]"
				h.client = c
				c.screen -= title
