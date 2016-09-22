/liquid
	parent_type = /obj
	icon = 'images/liquid.dmi'
	opacity = 0
	var/flood_level = 8															// 8 should be maximum level.
	var/can_flood = 1
	var/flood_timer = 5

	/liquid/New()
		spawn(5)
			looper.schedule(src)
		..()

	/liquid/Update_icon()
		if (game.game_state != PRE_ROUND)
			switch (flood_level)
				if (8)
					opacity = 1
					layer = ABOVE_MOBS
				if (7)
					layer = ABOVE_MOBS
					opacity = 1
				if (6)
					opacity = 0
					layer = ABOVE_MOBS
				if (5)
					opacity = 0
					layer = ABOVE_MOBS
				if (4)
					opacity = 0
					layer = BELOW_MOBS
				if (3)
					opacity = 0
					layer = BELOW_MOBS
				if (2)
					opacity = 0
					layer = BELOW_MOBS
				if (1)
					opacity = 0
					layer = BELOW_MOBS
				if (0)
					Del()

	/liquid/Update()
		name = "[flood_level]"

		var/turf/actual = locate(x, y, z)
		for (var/atom/a in actual.contents)
			if (a.loc == loc && a != src)
				spawn () On_atom_collision(a)

		if (game.game_state != PRE_ROUND)
			if (flood_level > 8)
				flood_level = 8

			if (can_flood)
				for (var/liquid/l in world)
					if ((l.loc == locate(x, y + 1, z)) || (l.loc == locate(x, y - 1, z)) || (l.loc == locate(x + 1, y, z)) || (l.loc == locate(x - 1, y, z)))
						Handle_other_liquids(l)
					if (l.loc == loc && l != src)
						flood_level += l.flood_level
						l.Del()
				if (flood_level > 1)
					var/turf/floor/f_north = locate(x, y + 1, z)
					var/turf/floor/f_south = locate(x, y - 1, z)
					var/turf/floor/f_west = locate(x - 1, y, z)
					var/turf/floor/f_east = locate(x + 1, y, z)

					if (istype(f_north))
						spawn (flood_timer)
							if (flood_level > 1)
								var/turf/l_loc = locate(x, y + 1, z)
								var/can_move = 1
								for (var/atom/o in l_loc.contents)
									if (o.opacity == 1)
										can_move = 0
								if (can_move)
									var/liquid/l = new type
									l.loc = locate(x, y + 1, z)
									l.flood_level = 1
									flood_level -= 1
									can_flood = 0
								spawn(flood_timer)
									can_flood = 1
					if (istype(f_south))
						spawn (flood_timer)
							if (flood_level > 1)
								var/turf/l_loc = locate(x, y - 1, z)
								var/can_move = 1
								for (var/atom/o in l_loc.contents)
									if (o.opacity == 1)
										can_move = 0
								if (can_move)
									var/liquid/l = new type
									l.loc = locate(x, y - 1, z)
									l.flood_level = 1
									flood_level -= 1
									can_flood = 0
								spawn(flood_timer)
									can_flood = 1
					if (istype(f_west))
						spawn (flood_timer)
							if (flood_level > 1)
								var/turf/l_loc = locate(x - 1, y, z)
								var/can_move = 1
								for (var/atom/o in l_loc.contents)
									if (o.opacity == 1)
										can_move = 0
								if (can_move)
									var/liquid/l = new type
									l.loc = locate(x - 1, y, z)
									l.flood_level = 1
									flood_level -= 1
									can_flood = 0
								spawn(flood_timer)
									can_flood = 1
					if (istype(f_east))
						spawn (flood_timer)
							if (flood_level > 1)
								var/turf/l_loc = locate(x + 1, y, z)
								var/can_move = 1
								for (var/atom/o in l_loc.contents)
									if (o.opacity == 1)
										can_move = 0
								if (can_move)
									var/liquid/l = new type
									l.loc = locate(x + 1, y, z)
									l.flood_level = 1
									flood_level -= 1
									can_flood = 0
								spawn(flood_timer)
									can_flood = 1

		..()

	/liquid/proc/Handle_other_liquids(var/liquid/l)
		if (l.type == type)
			if (l.flood_level < flood_level && flood_level > 1 && prob(20))
				l.flood_level += 1
				flood_level -= 1
				can_flood = 0
				spawn(flood_timer)
					can_flood = 1

	/liquid/proc/On_atom_collision(var/atom/o)									// Called each tick an atom is colliding with the liquid.
		if(o)
			o.On_liquid_collision(src)
		return
