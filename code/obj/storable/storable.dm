/obj/storable                                                                   // Base object for all objects you can pick up.

  /obj/storable/verb/pickup()
    set name = "Pick up"
    set src in oview(1)
    inventory.addItem(usr, src)
  /obj/storable/verb/drop()
    set name = "Drop"
    inventory.dropItem(usr, src)
