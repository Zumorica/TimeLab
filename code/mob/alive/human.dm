/mob/living/human
	icon = 'images/human.dmi'
	luminosity=0
	intention = HARM_INTENTION

	/mob/living/human/Clicked(other, location, control, params)
		..()

	/mob/living/human/Login()
		loc = locate(/turf/floor/generic/start)
		..()

	/mob/living/human/verb/Say(msg as text)
		view(8) << "[usr] says, \"[msg]\""

	/mob/living/human/verb/Whisper(M as mob in oview(1), msg as text)							// Sends a message to mobs adjacent to you.
		M << "[usr] whispers, \"<I>[msg]</I>\""
		usr << "[usr]: <I>[msg]</I>"

	/mob/living/human/verb/Shout(msg as text)
		view(16) << "[usr] shouts, \"<B><BIG>[msg]</BIG></B>\""
