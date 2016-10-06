/obj/item/weapon/pickaxe
	icon = 'images/pickaxe.dmi'
	attack_factor = 2
	size = 3

	/obj/item/weapon/pickaxe/On_interact(atom/other)
		switch(carrier.intention)
			if (NO_INTENTION)
				return
			if (INTERACT_INTENTION)
				return
			if (HARM_INTENTION)
				if (attack_state == CAN_ATTACK && !other.invincible)
					view(6) << "[carrier] attacks [other] with [src]!"
				if (istype(other, /turf/wall/rock))
					attack(other, 2)
				else
					attack(other)
		..()
