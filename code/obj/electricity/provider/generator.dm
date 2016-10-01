/obj/electricity/provider/generator
	name = "Thermal generator"
	providing_range = 2
	dir = NORTH
	opacity = 1
	density = 1
	icon = 'images/thermal_generator.dmi'
	icon_state = "off"
	var/stored_lava = 0
	var/stored_lava_max = 8
	var/can_store_lava = 1
	var/store_lava_timer = 30

	/obj/electricity/provider/generator/New()
		var/turf/t = locate(x + 1, y, z)
		if (!t.density)
			t.density = 1
			t.opacity = 1
		..()

	/obj/electricity/provider/generator/Update()
		var/turf/t
		switch(dir)
			if (NORTH)
				t = locate(x, y + 1, z)
			if (SOUTH)
				t = locate(x, y - 1, z)
			if (EAST)
				t = locate(x + 2, y, z)
			if (WEST)
				t = locate(x - 1, y, z)
		if (istype(t) && t && stored_lava != stored_lava_max && can_store_lava)
			for (var/liquid/lava/l in t.contents)
				if (istype(l) && l)
					l.flood_level -= 1
					stored_lava += 1
					can_store_lava = 0
					spawn(store_lava_timer)
						can_store_lava = 1
		if (stored_lava)
			stored_lava -= 1
			stored_joules += 4500000
			icon_state = ""
		else if (!stored_lava && stored_joules)
			icon_state = ""
		else
			icon_state = "off"
		..()
