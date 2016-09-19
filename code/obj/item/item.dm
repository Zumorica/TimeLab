/obj/item                                                                   // Base object for all objects you can pick up.
  var/size = 2                                                              // 1 - small, 2 - medium, 3 - big

  /obj/item/verb/pickup()
    set name = "Pick up"
    set src in oview(1)
    set category = "Object"
    if(usr.life_state == ALIVE)
      inventory.addItem(usr, src)

  /obj/item/Interacted(mob/other)
    if(istype(other, /mob/living/human) && get_dist(src, other) <= 1)
      inventory.addItem(other, src)
