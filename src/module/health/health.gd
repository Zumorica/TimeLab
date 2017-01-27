extends Node2D

signal on_health_change(new_hp)
signal on_healed(hp_gained, other)
signal on_damaged(hp_lost, other)
signal on_death

export(bool) var is_invincible = false
export(int) var max_health = 100
remote var health = max_health setget get_health,set_health

var defense setget get_defense
remote var armor_defense = 0.0 setget ,set_armor_defense
export(float) var defense_modifier = 1.0

func _init():
	rset_config("is_invincible", RPC_MODE_REMOTE)
	rpc_config("emit_signal", RPC_MODE_SYNC)

func _ready():
	pass
	
func get_health():
	return health
	
func set_health(hp):
	health = int(hp)
	if health <= 0:
		health = 0
		get_parent().state |= s_flag.DEAD
		rpc("emit_signal", "on_death")
	elif health > max_health:
		health = max_health
	rset("health", health)
	rpc("emit_signal", "on_health_change", health)

func heal(hp, other=null):
	if hp > 0 and not ((get_parent().state & s_flag.DEAD) or (get_parent().state & s_flag.CANT_BE_HEALED)):
		set_health(get_health() + hp)
		if typeof(other) == TYPE_OBJECT:
			other = str(other.get_path())
		rpc("emit_signal", "on_healed", hp, other)

func damage(dmg, other=null):
	if not is_invincible and dmg > 0 and not (get_parent().state & s_flag.DEAD):
		dmg = dmg - get_defense()
		if dmg <= 0:
			if get_parent().has_node("Chat"):
				var chat = get_parent().get_node("Chat")
				chat.emote("'s armor protects its wearer from the blow.", false)
		else:
			set_health(get_health() - dmg)
			if typeof(other) == TYPE_OBJECT:
				other = str(other.get_path())
			rpc("emit_signal", "on_damaged", dmg, other)

func get_defense():
	return armor_defense + defense_modifier
	
func set_armor_defense(def):
	armor_defense = def
	rset("armor_defense", armor_defense)