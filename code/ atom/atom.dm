/atom
	var/max_health = 100														// Max health the atom can have.
	var/health = 100	  	 													// Health of the atom.
	var/invincible = False 														// Is the atom invincible or not?
	var/damage_factor = 1.0														// How much damage affects the atom.
	var/burn_damage_factor = 1.0												// How much burns affect the atom.
	var/attack_factor = 1.0														// How much your damage affects atoms.
	var/attack_delay = 7														// Delays attacks.
	var/is_burning = 0															// Whether atom is burning or not.
	var/burn_time = 10															// Burn time. In seconds.
	var/attack_state = CAN_ATTACK
	var/speak_state = CAN_SPEAK
	var/life_state = ALIVE

	/atom/New()
		var/icon/i = new(icon)
		icon = i
		..()

	/atom/proc/GetArea()														// Returns the atom's area.
		return

	/atom/proc/damage(damage as num)											// Damage the atom.
		if (!invincible && health > 0)
			health -= round(damage * damage_factor)
			if (health <= 0)
				health = 0
				life_state = DEAD
				Died()

	/atom/proc/attack(atom/other)
		if (attack_state == CAN_ATTACK && life_state == ALIVE)
			other.damage(rand(1, 10) * attack_factor)
			attack_state = CANT_ATTACK
			spawn(attack_delay)
				attack_state = CAN_ATTACK

	/atom/proc/Died()															// Called when an atom dies. (His health reaches 0)
		return

	/atom/proc/Clicked(other, location, control, params)						// Called when client object clicks other objects.
		return

	/atom/proc/Interacted(mob/other)											// Called when a mob interacts with another atom.
		if (istype(other, /mob/living/human) && get_dist(src, other) <= 1 && other.inventory_items[other.active_hand])
			src.Interacted_Item(other, other.inventory_items[other.active_hand])
			return

	/atom/proc/Bumped(atom/other)												// Called when you bump into other objects / other objects bump into you.
		return

	/atom/proc/Interacted_Item(mob/other, obj/item/oitem)						// Called when a mob interacts with an object while holding an item.
		oitem.On_interact(src)
		return

	/atom/proc/burn(var/burn_factor)											// Should be called for burning atoms.
		if (!(prob(10) / burn_factor) && !is_burning)
			is_burning = 1
			burn_time = initial(burn_time) * burn_factor
			overlays |= /obj/overlay/fire
			spawn(burn_time)
				On_burn(burn_factor)

	/atom/proc/extinguish()														// Should be called for extinguishing atoms.
		if (is_burning)
			is_burning = 0
			overlays -= /obj/overlay/fire

	/atom/proc/On_burn(var/burn_factor)
		if (prob(2) / burn_factor)
			extinguish()

		if (is_burning)
			damage(1.25 * burn_factor * burn_damage_factor)
			spawn (burn_time)
				On_burn(burn_factor)
