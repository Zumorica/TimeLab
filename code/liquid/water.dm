/liquid/water
	name = "Water"
	icon = 'images/water.dmi'

	/liquid/water/On_atom_collision(var/atom/o)
		if (!istype(o, /liquid))
			if (istype(o, /atom))
				o.extinguish()
