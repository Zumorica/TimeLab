extends "res://src/disease/disease.gd"

func _on_Timer_timeout():
	if affected.health > 75 and is_network_master():
		affected.rpc("damage", randi()%5, self)
		if rand_range(0, 1) < 0.25:
			affected.send_message("You feel a sharp pain...")

func _on_SneezeTimer_timeout():
	if is_network_master():
		randomize()
		var next_sneeze = randi()%60
		get_node("SneezeTimer").set_wait_time(next_sneeze)
		get_node("SneezeTimer").start()
		affected.emote("sneezes!")