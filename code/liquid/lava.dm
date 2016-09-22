/liquid/lava
	name = "Lava"
	icon = 'images/lava.dmi'
	luminosity = 6
	flood_timer = 15

	/liquid/lava/On_atom_collision(var/atom/o)
		if (!istype(o, /liquid))
			if (istype(o, /atom))
				o.burn(1.25)
