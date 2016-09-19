var/game/game = new/game

/game
	var/finished_loading = 0
	var/round_eta = 60
	var/can_substract = 1
	var/ranks_set = 0
	var/game_state = PRE_ROUND
	var/midround_join = 1
	var/list/clients = list()
	var/list/events = list()

	/game/New()
		spawn(10)
			looper.schedule(src)
		..()

	/game/Update()
		switch (game_state)
			if (PRE_ROUND)
				if (!ranks_set && clients.len)
					spawn() set_ranks()

				if (ranks_set)
					finished_loading = 1

				if (finished_loading)
					if (round_eta && can_substract)
						round_eta -= 1
						can_substract = 0
						if (round_eta <= 0)
							round_eta = 0
						spawn(10) can_substract = 1

					if (round_eta == 0)
						start_round()

	/game/proc/set_ranks()
		if (clients.len)
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

	/game/proc/handle_new_human(var/client/c)
		var/mob/living/human/h = new/mob/living/human
		h.name = "[c]"
		h.client = c
		c.screen -= title

	/game/proc/start_round()
		if (finished_loading)
			game_state = PLAYING
			for (var/client/c in clients)
				if (c.will_join)
					handle_new_human(c)
