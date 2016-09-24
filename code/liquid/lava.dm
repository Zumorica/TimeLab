/liquid/lava
	name = "Lava"
	icon = 'images/lava.dmi'
	var/burn_factor = 1.25
	luminosity = 6
	flood_timer = 15

	/liquid/lava/On_atom_collision(var/atom/o)
		if (!istype(o, /liquid))
			if (istype(o, /atom))
				o.burn(burn_factor)
				if (flood_level >= 8)
					o.damage(rand(1, 2))
				else if (flood_level < 8 && flood_level != 1)
					o.damage(rand(1, 2))
				else if (flood_level == 1)
					o.damage(rand())
