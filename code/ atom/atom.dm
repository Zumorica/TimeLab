/atom
	var/max_health = 100														// Max health the atom can have.
	var/health = 100	  	 													// Health of the atom.
	var/invincible = False 														// Is the atom invincible or not?
	var/base_damage_factor = 1.0  												// Base damage factor.
	var/damage_factor = 1.0														// How much damage affects the atom.
	var/base_attack_factor = 1.0												// Base attack factor
	var/attack_factor = 1.0														// How much your damage affects atoms.

	/atom/proc/damage(damage as num)											// Damage the atom.
		if (!invincible && health > 0)
			health -= damage * damage_factor
			if (health <= 0)
				health = 0
				Died()

	/atom/proc/attack(atom/other)
		other.damage(rand(0, 10) * attack_factor)

	/atom/proc/Died()															// Called when an atom dies. (His health reaches 0)
		return

	/atom/proc/Clicked(other, location, control, params)						// Called when client object clicks other objects.
		return

	/atom/proc/Interacted(mob/other)											// Called when a mob interacts with another atom.
		return

	/atom/proc/Bumped(atom/other)												// Called when you bump into other objects / other objects bump into you.
		return

	/atom/movable/Bump(atom/a)													// Overrides Bump proc so /atom/proc/Bumped(atom/other) can be possible
		a.Bumped(src)
		return ..(a)
