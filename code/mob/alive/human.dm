/mob/living/human
	icon = 'images/human.dmi'
	luminosity=0
	intention = HARM_INTENTION

	/mob/living/human/Clicked(other, location, control, params)
		world << other
		..()

	/mob/living/human/Login()
		loc = locate(/turf/floor/generic/start)
		..()

	/mob/living/human/verb/Say(msg as text)
		view(2) << "[usr] says \"[msg]\""
