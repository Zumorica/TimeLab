/obj/item                                                                   	// Base object for all objects you can pick up.
	var/size = 2      		                                                    // 1 - small, 2 - medium, 3 - big
	var/mob/living/carrier = 0																// The mob who carries this item.

	/obj/item/verb/pickup()
		set name = "Pick up"
		set src in oview(1)
		set category = "Object"
		if(usr.life_state == ALIVE)
			inventory.addItem(usr, src)

	/obj/item/Interacted(mob/other)
		if(is_in_container(other))
			var/obj/item/container/c = Get_container(other)
			c.inv.removeFrom(src, other)
		else if(istype(other, /mob/living/human) && get_dist(src, other) <= 1)
			inventory.addItem(other, src)

	/obj/item/proc/On_pickup(mob/other)
		carrier = other

	/obj/item/proc/On_store(inventory/storage/other)
		return

	/obj/item/proc/On_drop(mob/other)
		carrier = 0

	/obj/item/proc/On_interact(atom/other)
		return

	/obj/item/proc/is_in_container(mob/other)
		for(var/obj/item/container/c in other.contents)
			if(src in c.inv.storage_items)
				return True
		return False

	/obj/item/proc/Get_container(mob/other)
		for(var/obj/item/container/c in other.contents)
			if(src in c.inv.storage_items)
				return c
