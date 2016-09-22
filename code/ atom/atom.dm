/atom
	var/max_health = 100														// Max health the atom can have.
	var/health = 100	  	 													// Health of the atom.
	var/invincible = False 														// Is the atom invincible or not?
	var/base_damage_factor = 1.0  												// Base damage factor.
	var/damage_factor = 1.0														// How much damage affects the atom.
	var/base_attack_factor = 1.0												// Base attack factor
	var/attack_factor = 1.0														// How much your damage affects atoms.
	var/attack_delay = 7														// Delays attacks.
	var/is_burning = 0															// Whether atom is burning or not.
	var/burn_time_base = 10														// Burn time. In seconds.
	var/burn_time_final															// Modify burn_time_base instead.
	var/attack_state = CAN_ATTACK
	var/speak_state = CAN_SPEAK
	var/life_state = ALIVE

	/atom/proc/GetArea()														// Returns the atom's area.
		return

	/atom/proc/damage(damage as num)											// Damage the atom.
		if (!invincible && health > 0)
			health -= damage * damage_factor
			if (health <= 0)
				health = 0
				life_state = DEAD
				Died()

	/atom/proc/attack(atom/other)
		if (attack_state == CAN_ATTACK && life_state == ALIVE)
			other.damage(rand(0, 10) * attack_factor)
			if(src == other)
				view() << "[src] attacks \himself."
			else
				view() << "[src] attacks [other]."
			attack_state = CANT_ATTACK
			spawn(attack_delay)
				attack_state = CAN_ATTACK

	/atom/proc/Died()															// Called when an atom dies. (His health reaches 0)
		return

	/atom/proc/Clicked(other, location, control, params)						// Called when client object clicks other objects.
		return

	/atom/proc/Interacted(mob/other)											// Called when a mob interacts with another atom.
		if (istype(other, /mob/living/human) && get_dist(src, other) <= 1 && other.inventory_items[other.active_hand])
			src.Interacted_Item(other)

	/atom/proc/Bumped(atom/other)												// Called when you bump into other objects / other objects bump into you.
		return

	/atom/proc/Interacted_Item(mob/other)										// Called when a mob interacts with an object while holding an item.
		return

	/atom/proc/burn(var/burn_factor)											// Should be called for burning atoms.
		if (!(prob(10) / burn_factor) && !is_burning)
			is_burning = 1
			burn_time_final = burn_time_base * burn_factor
			overlays |= /obj/overlay/fire
			spawn(burn_time_final)
				On_burn(burn_factor)

	/atom/proc/extinguish()														// Should be called for extinguishing atoms.
		if (is_burning)
			is_burning = 0
			overlays -= /obj/overlay/fire
			src << "The fire extinguishes..."

	/atom/proc/On_burn(var/burn_factor)
		if (prob(2) / burn_factor)
			extinguish()

		if (is_burning)
			damage(1.25 * burn_factor)
			spawn (burn_time_final)
				On_burn(burn_factor)

	/atom/proc/On_liquid_collision(var/liquid/l)
		if (istype(l, /liquid/water))
			extinguish()
