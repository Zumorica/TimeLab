/turf/wall/rock
	icon = 'images/rock.dmi'
	invincible = 0
	opacity = 1
	density = 1

	/turf/wall/rock/Died()
		new /turf/floor/rock(src)

	/turf/wall/rock/verb/HP()
		set src in view()
		usr << health
