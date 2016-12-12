/obj/item/mineral/coal
	icon = 'images/coal.dmi'
	var/joules

	/obj/item/mineral/coal/New()
		..()
		joules = rand(5000, 50000)

	/obj/item/mineral/coal/verb/Examine()
		set src in view()
		usr << "Looks like this piece of coal could generate [joules] joules at once!"
