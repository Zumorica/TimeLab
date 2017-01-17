extends Node2D

export var disease_name = "Generic disease"
export var disease_description = "Does nothing."
export(bool) var is_curable = true
var affected

signal on_disease_contract()
signal on_disease_cure()

func _init():
	rpc_config("queue_free", RPC_MODE_SYNC)

func _ready():
	if get_parent().get_parent():
		if get_parent().get_parent() extends s_base.mob:
			emit_signal("on_disease_contract")
			affected = get_parent().get_parent()
		
func cure():
	if is_curable:
		emit_signal("on_disease_cure")
		rpc("queue_free")
		return true
	else:
		return false