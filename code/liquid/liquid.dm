/liquid
	parent_type = /obj
	icon = 'images/liquid.dmi'
	opacity = 0
	glide_size = 32
	var/flood_level = 16														// 16 should be maximum level.
	var/flood_state = LIQUID_MOVEMENT
	var/flood_timer = 5
	var/can_flood = 1

	/liquid/New()
		spawn(5)
			looper.schedule(src)
		..()

	/liquid/Update_icon()
		if (game.game_state != PRE_ROUND)
			switch (flood_level)
				if (15,16)
					alpha = 255
					opacity = 1
					layer = ABOVE_MOBS
				if (13,14)
					alpha = 225
					opacity = 0
					layer = ABOVE_MOBS
				if (11,12)
					alpha = 225
					opacity = 0
					layer = ABOVE_MOBS
				if (9,10)
					alpha = 200
					opacity = 0
					layer = ABOVE_MOBS
				if (7,8)
					alpha = 175
					opacity = 0
					layer = ABOVE_MOBS
				if (5,6)
					alpha = 175
					opacity = 0
					layer = ABOVE_MOBS
				if (3,4)
					alpha = 150
					opacity = 0
					layer = BELOW_MOBS
				if (1,2)
					alpha = 125
					opacity = 0
					layer = BELOW_MOBS
				if (0)
					Del()

	/liquid/Update()
		name = "[flood_level]"

		if (flood_level > 16)
			flood_level = 16

		if (game.game_state != PRE_ROUND)

			var/turf/actual = locate(x, y, z)
			if (actual)
				for (var/atom/a in actual.contents)
					if (a.loc == loc && a != src)
						spawn () On_atom_collision(a)

			if (flood_level == 0)
				Del()

			if (flood_level == 1)
				flood_state = LIQUID_STILL

			if (flood_level > 1)
				flood_state = LIQUID_MOVEMENT

				if (can_flood && flood_state != LIQUID_STILL)
					var/turf/floor/f_n = locate(x + 1, y, z)
					var/turf/floor/f_s = locate(x - 1, y, z)
					var/turf/floor/f_w = locate(x, y - 1, z)
					var/turf/floor/f_e = locate(x, y + 1, z)
					var/list/l = list(f_n, f_s, f_w, f_e)

					var/turf/f = pick(l)
					if (f && istype(f) && !istype(f, /turf/wall))
						var/can_move_there = 1
						for (var/atom/a in f.contents)
							if (a.opacity)
								can_move_there = 0
						if (!(locate(/liquid) in f.contents) && can_move_there && flood_level > 1)
							var/liquid/liq = new type
							liq.loc = locate(f.x, f.y, f.z)
							liq.flood_level = round(flood_level / 2)
							flood_level = round(flood_level / 2)
							can_flood = 0
							spawn(flood_timer)
								can_flood = 1

				var/liquid/l_n = locate(type) in locate(x + 1, y, z)
				var/liquid/l_s = locate(type) in locate(x - 1, y, z)
				var/liquid/l_w = locate(type) in locate(x, y - 1, z)
				var/liquid/l_e = locate(type) in locate(x, y + 1, z)
				var/list/li = list(l_n, l_s, l_w, l_e)

				var/liquid/l = pick(li)
				if (!l)
					li.Remove(l)
					l = pick(li)
					if (!l)
						li.Remove(l)
						l = pick(li)
						if (!l)
							li.Remove(l)
							l = pick(li)
							if (!l)
								li.Remove(l)

				if (l)
					if (l.flood_level < flood_level && can_flood)
						var/old_loc = loc
						var/new_loc = l.loc
						Move(new_loc)
						l.Move(old_loc)
						can_flood = 0
						spawn(flood_timer)
							can_flood = 1

	/liquid/proc/On_atom_collision(var/atom/o)									// Called each tick an atom is colliding with the liquid.
		return
