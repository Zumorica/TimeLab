/mob/living/human
	icon = 'images/human.dmi'
	luminosity=0

	/mob/living/human/Login()
		loc = locate(/turf/start)
		..()

	/mob/living/human/verb/Say(msg as text)
		view(2) << "[usr] says \"[msg]\""
