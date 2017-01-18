extends "res://src/disease/disease.gd"

var heal_messages = ["You feel much better.", "You know everything will be fine...", "The pain is slowly fading away."]

func _on_HealTimer_timeout():
	if is_network_master() and affected:
		if affected.health != affected.max_health:
			affected.rpc("heal", rand_range(0, 5), str(get_path()))
			if rand_range(0, 1) > 0.9:
				affected.send_message(heal_messages[randi() % heal_messages.size()])