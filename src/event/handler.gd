extends Node

var event_base = preload("res://src/event/event.gd")

func get_next_event():
	var lowest = null
	for child in get_children():
		if child extends event_base:
			if lowest == null and child.get_event_state() == child.STARTING:
				lowest = child
				continue
			else:
				if child.get_time_left() < lowest.get_time_left() and child.get_event_state() == child.STARTING:
					lowest = child
	return lowest

func restart_all_events():
	for child in get_children():
		if child extends event_base:
			child.restart_event()
			
func end_all_events():
	for child in get_children():
		if child extends event_base:
			child.end_event()
			
func start_all_events():
	for child in get_children():
		if child extends event_base:
			child.start_event()