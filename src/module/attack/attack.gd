extends Node2D

signal on_attack(other)

remote var can_attack = true
export var attack_delay = 1

var attack setget get_attack
remote var weapon_attack = 1.0 setget ,set_weapon_attack
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
	if not (state & s_flag.DEAD) and not (state & s_flag.CANT_ATTACK) and can_attack:
		if other extends s_base.element:
			if other.has_node("Health"):
				var effectiveness = rand_range(0.1, 1.0)
				var atk = get_attack()
				var dmg = round(atk * effectiveness)
				if get_parent().has_node("Chat"):
					var chat = get_parent().get_node("Chat")
					if other != get_parent():
						if effectiveness < 0.4:
							chat.emote("punches %s without any strength..."% other.show_name)
						elif effectiveness < 0.8:
							chat.emote("punches %s" % other.show_name)
						else:
							chat.emote("punches %s with all %s strength!" % [other.show_name, s_gender.possesive[get_parent().gender]])
					else:
						if effectiveness < 0.4:
							chat.emote("punches %s without any strength..." % s_gender.reflexive[get_parent().gender])
						elif effectiveness < 0.8:
							chat.emote("punches %s" % s_gender.reflexive[get_parent().gender])
						else:
							chat.emote("punches %s with all %s strength!" % [s_gender.reflexive[get_parent().gender], s_gender.possesive[get_parent().gender]])
				other.get_node("Health").damage(dmg, get_parent())
				can_attack = false
				rset("can_attack", can_attack)
				rpc("emit_signal", "on_attack", other)
				get_node("AttackTimer").start()

#func attack(other, bonus = 0):
#	if (not (state & s_flag.DEAD) and not (state & s_flag.CANT_ATTACK)) and other extends s_base.element:
#		var damage = (randi()%11) * (attack_factor + bonus)
#		other.rpc("damage", damage, str(get_path()))
#		rpc("emit_signal", "on_attack", str(other.get_path()))
#		rset("state", state | s_flag.CANT_ATTACK)
#		state |= s_flag.CANT_ATTACK
#		get_node("AttackTimer").start()

func get_attack():
	return (weapon_attack + attack_modifier)

func set_weapon_attack(atk):
	weapon_attack = atk
	rset("weapon_attack", weapon_attack)