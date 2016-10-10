extends Sprite

# Bit flags #
const DEAD = 1    		# 0000 0001
const BURNING = 2 		# 0000 0010
const MUTE = 4	  		# 0000 0100
const BLIND = 8	  		# 0000 1000
const DEAF = 16	  		# 0001 0000
const CANT_WALK = 32	# 0010 0000
const CANT_ATTACK = 64  # 0100 0000

var attack_timer

export(int) var health = 100
export(bool) var invincible = false
export(float) var damage_factor = 1.0
export(float) var burn_damage_factor = 1.0
export(float) var attack_factor = 1.0
export(int) var attack_delay = 10
export(int, FLAGS) var state = 0


func _ready():
	set_process(true)
	attack_timer = Timer.new()
	attack_timer.set_wait_time(attack_delay)
	attack_timer.connect("timeout", self, "reset_attack_timer")

func _process(dt):
	pass

func on_death(cause = "magic"):
	pass

func on_damage(damage, other):
	pass

func on_attack(damage, other):
	pass

func on_interacted(other):
	pass

func on_interacted_item(other, item):
	pass

func on_burn(burn_factor):
	pass

func reset_attack_timer():
	if ((state & CANT_ATTACK) == state):
		state = state ^ CANT_ATTACK

func damage(damage, other):
	if (not invincible):
		health -= round(damage * damage_factor)
		on_damage(damage, other)
		if (health <= 0):
			health = 0
			state |= DEAD

func attack(other, bonus = 0):
	if (not ((state & (DEAD | CANT_ATTACK)) == state) and other.has_method("damage")):
		var damage = (randi()%11) * (attack_factor + bonus)
		other.damage(damage, self)
		on_attack(damage, other)
		state |= CANT_ATTACK
		attack_timer.start()
