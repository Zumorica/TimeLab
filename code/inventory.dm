var/inventory/inventory = new/inventory

/inventory
  var/layer = 22
  var/list/inventory_slots
  inventory_slots = list("right_hand", "left_hand", "right_pocket", "left_pocket")

  /inventory/proc/addItem(mob/M, obj/item/I)
    if(!M.inventory_items[M.active_hand])
      for(var/x in M.inventory_items)
        if(M.inventory_items[x] == I)
          M.inventory_items[x] = null
      M.contents += I
      M.inventory_items[M.active_hand] = I
      I.layer = layer
      if(M.active_hand == "right_hand")
        I.screen_loc = "9, 1"
      else
        I.screen_loc = "8, 1"
      M.client.screen += I
    else
      return

  /inventory/proc/dropItem(mob/M, obj/item/I)
    M.contents -= I
    for(var/x in M.inventory_items)
      if(M.inventory_items[x] == I)
        M.inventory_items[x] = null
    I.layer = 3
    I.loc = M.loc
    M.client.screen -= I

  /inventory/proc/change(mob/M, i_slot)
    var/obj/item/I = M.inventory_items[M.active_hand]
    if(!M.inventory_items[i_slot] && M.inventory_items[M.active_hand])
      M.inventory_items[i_slot] = I
      M.inventory_items[M.active_hand] = null
      switch(i_slot)
        if("left_pocket")
          I.screen_loc = "10, 1"
        if("right_pocket")
          I.screen_loc = "11, 1"
        else
          return
    else
      return
