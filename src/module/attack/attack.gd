extends Node2D

signal on_attack(other)

remote var can_attack = true
export var attack_delay = 1

var attack setget get_attack
remote var weapon
export(float) var attack_modifier = 5.0

func _ready():
	var timer = get_node("AttackTimer")
	timer.set_wait_time(attack_delay)
	if not timer.is_connected("timeout", self, "on_timeout"):
		timer.connect("timeout", self, "on_timeout")
		
func on_timeout():
	if not can_attack:
		can_attack = true

func attack(other):
	var state = get_parent().state
	if not (state & timelab.flag.DEAD) and not (state & timelab.flag.CANT_ATTACK) and can_attack:
		if other extends timelab.base.element:
			if other.has_node("Health"):
				var effectiveness = rand_range(0.1, 1.0)
				var atk = get_attack()
				var dmg = round(atk * effectiveness)
				if get_parent().has_node("Chat"):
					var verb = "punches"
					var chat = get_parent().get_node("Chat")
					if weapon:
						verb = weapon.verb
					if other != get_parent():
						if effectiveness < 0.4:
							chat.emote("%s %s without any strength..."% [verb, other.show_name])
						elif effectiveness < 0.8:
							chat.emote("%s %s" % other.show_name)
						else:
							chat.emote("%s %s with all %s strength!" % [verb, other.show_name, timelab.gender.possesive[get_parent().gender]])
					else:
						if effectiveness < 0.4:
							chat.emote("%s %s without any strength..." % [verb, timelab.gender.reflexive[get_parent().gender]])
						elif effectiveness < 0.8:
							chat.emote("%s %s" % [verb, timelab.gender.reflexive[get_parent().gender]])
						else:
							chat.emote("%s %s with all %s strength!" % [verb, timelab.gender.reflexive[get_parent().gender], timelab.gender.possesive[get_parent().gender]])
				other.get_node("Health").damage(dmg, get_parent())
				can_attack = false
				rset("can_attack", can_attack)
				rpc("emit_signal", "on_attack", other)
				get_node("AttackTimer").start()

func get_attack():
	if weapon:
		return (weapon.attack + attack_modifier)
	else:
		return attack_modifier
	
func process_weapon(wpn):
	assert wpn extends timelab.base.weapon
	weapon = wpn
	
func remove_weapon():
	weapon = null