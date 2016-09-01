/mob/living/human
	icon = 'images/player.dmi'

	/mob/living/human/Login()
		loc = locate(/turf/start)
		..()

	/mob/living/human/verb/Say(msg as text)
		view(2) << "[usr] says \"[msg]\""
