extends 'res://src/obj/machine/provider/provider.gd'

func _on_Wireless_Extender_on_power_off():
	get_node("AnimationPlayer").play("off")

func _on_Wireless_Extender_on_power_on():
	get_node("AnimationPlayer").play("on")
