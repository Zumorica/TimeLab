/turf/wall/rock
	icon = 'images/rock.dmi'
	invincible = 0
	damage_factor = 1.5
	opacity = 1
	density = 1

	/turf/wall/rock/Died()
		if (prob(25))															// Less likely probablities go first.
			new /obj/item/mineral/coal(locate(x, y, z))
		new /turf/floor/rock(src)

	/turf/wall/rock/verb/HP()
		set src in view()
		usr << health
