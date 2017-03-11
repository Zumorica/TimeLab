extends Node2D

func _ready():
	if not get_parent() extends timelab.base.element:
		print("Module's parent does not extend an element!")
		print("%s@%s" %[self,get_path()])
		raise()