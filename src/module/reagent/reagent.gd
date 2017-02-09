extends Node2D

signal on_reagent_added(reagent, units)

export(int) var max_units = 100
remote var reagents = {}

func _ready():
	rpc_config("emit_signal", RPC_MODE_SYNC)
	
func add_reagent(reagent, units):
	var current_units = get_current_units()
	var delta = (current_units + units) - max_units
	if delta > 0:
		var added_units = units - delta
		var discarded = delta
		add_reagent(reagent, added_units)
		return discarded
	if reagents.has(reagent):
		reagents[reagent] += units
	else:
		reagents[reagent] = units
	rset("reagents", reagents)
	rpc("emit_signal", "on_reagent_added", reagent, units)
	
func remove_all_reagents():
	reagents.clear()
	
func get_current_units():
	var units = 0
	for reagent in reagents:
		units += reagents[reagent]
	return units