// All defines go here.

#define DEBUG 1

#define ABOVE_MOBS MOB_LAYER+1
#define ABOVE_TURFS TURF_LAYER+1

#define NO_INTENTION 	   0
#define INTERACT_INTENTION 1
#define HARM_INTENTION 	   2

#define False 0
#define True  1

#define DOOR_CLOSED 	1
#define DOOR_OPEN 		2
#define DOOR_CLOSING 	3
#define DOOR_OPENING 	4

#define ELEVATOR_STOP	0
#define ELEVATOR_UP		1
#define ELEVATOR_DOWN	2
#define ELEVATOR_BROKEN 3

#define CANT_SPEAK 0
#define CAN_SPEAK  1
#define MUTE	   2
#define GAGGED	   3

#define font_width 10

// Not a define, but close enough.
var/list/world_hud = new/list()
