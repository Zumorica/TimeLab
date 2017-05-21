extends Node

const DEAD = int(pow(2,0)) # When the element is dead/destroyed.
const BURNING = int(pow(2,1)) # When the element is on fire.
const MUTE = int(pow(2,2)) # When the element can't talk.
const BLIND = int(pow(2,3)) # When the element can't see.
const DEAF = int(pow(2,4)) # When the element can't hear.
const CANT_WALK = int(pow(2,5)) # When the element can't walk.
const CANT_ATTACK = int(pow(2,6)) # When the element can't attack.
const CANT_USE_ITEMS = int(pow(2, 7)) # When the element can't use items.
const CANT_INTERACT = int(pow(2, 8)) # When the element can't interact with others.
const CANT_BE_INTERACTED = int(pow(2, 9)) # When others can't interact with the element.
const CANT_BE_HEALED = int(pow(2, 10)) # When an element can't be healed.