/atom
	var/max_health = 100														// Max health the atom can have.
	var/health = 100	  	 													// Health of the atom.
	var/invincible = False 														// Is the atom invincible or not?
	var/base_damage_factor = 1.0  												// Base damage factor.
	var/damage_factor = 1.0														// How much damage affects the atom.
	var/base_attack_factor = 1.0												// Base attack factor
	var/attack_factor = 1.0														// How much your damage affects atoms.
	var/attack_delay = 7														// Delays attacks.
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
		return

	/atom/proc/Bumped(atom/other)												// Called when you bump into other objects / other objects bump into you.
		return
