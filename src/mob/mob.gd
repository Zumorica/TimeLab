extends KinematicBody2D

signal _on_client_input(event)

export(String, "generic", "human") var race

func _ready():
	pass

func _on_client_input(event):
	print(event)
