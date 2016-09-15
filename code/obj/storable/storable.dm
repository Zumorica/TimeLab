/obj/storable                                                                   // Base object for all objects you can pick up.

  /obj/storable/verb/pickup()
    set name = "Pick up"
    set src in oview(1)
    set category = "Object"
    if(usr.life_state == ALIVE)
      inventory.addItem(usr, src)
  /obj/storable/verb/drop()
    set name = "Drop"
    set category = "Object"
    if(usr.life_state == ALIVE)
      inventory.dropItem(usr, src)

  /obj/storable/Interacted(mob/other)
    if(istype(other, /mob/living/human) && get_dist(src, other) <= 1)
      inventory.addItem(other, src)
