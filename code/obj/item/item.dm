/obj/item                                                                   // Base object for all objects you can pick up.

  /obj/item/verb/pickup()
    set name = "Pick up"
    set src in oview(1)
    set category = "Object"
    if(usr.life_state == ALIVE)
      inventory.addItem(usr, src)
  /obj/item/verb/drop()
    set name = "Drop"
    set category = "Object"
    if(usr.life_state == ALIVE)
      inventory.dropItem(usr, src)

  /obj/item/Interacted(mob/other)
    if(istype(other, /mob/living/human) && get_dist(src, other) <= 1)
      inventory.addItem(other, src)
