extends Timer

signal on_event_restart
signal on_event_start
signal on_event_end

const STARTING = 0
const IN_PROGRESS = 1
const EVENT_ENDED = 2

var event_state = 0 setget get_event_state
onready var original_wait_time = get_wait_time()
export(float) var end_wait_time = 0 # 0 or less for disabled.
export(bool) var rand_end_wait_time = false
export(bool) var rand_wait_time = false
export(bool) var auto_repeat_event = false
export var event_codename = "generic"

func _ready():
	connect("timeout", self, "start_event")
	if rand_wait_time:
		randomize()
		set_wait_time(int(rand_range(0, get_wait_time())))
	if rand_end_wait_time:
		randomize()
		end_wait_time = rand_range(0, end_wait_time)

func get_event_state():
	return event_state

func restart_event():
	stop()
	if is_connected("timeout", self, "end_event"):
		disconnect("timeout", self, "end_event")
	if not is_connected("timeout", self, "start_event"):
		connect("timeout", self, "start_event")
	set_wait_time(original_wait_time)
	event_state = 0
	emit_event("on_event_restart")
	start()

func start_event():
	stop()
	event_state = 1
	emit_event("on_event_start")
	if end_wait_time > 0:
		disconnect("timeout", self, "start_event")
		connect("timeout", self, "end_event")
		set_wait_time(end_wait_time)
		start()
	
func end_event():
	stop()
	event_state = 2
	emit_event("on_event_end")
	if auto_repeat_event:
		restart_event()