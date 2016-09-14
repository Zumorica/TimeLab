var/inventory/inventory = new/inventory

/inventory
  var/layer = 22
  var/active_hand = "right_hand"
  var/list/inventory_slots
  inventory_slots = list("right_hand", "left_hand")

  /inventory/proc/addItem(mob/M, obj/storable/I)
    if(!M.inventory_items[active_hand])
      for(var/x in M.inventory_items)
        if(M.inventory_items[x] == I)
          M.inventory_items[x] = null
      M.contents += I
      M.inventory_items[active_hand] = I
      I.layer = layer
      if(active_hand == "right_hand")
        I.screen_loc = "9, 1"
      else
        I.screen_loc = "8, 1"
      M.client.screen += I
    else
      return

  /inventory/proc/dropItem(mob/M, obj/storable/I)
    M.contents -= I
    for(var/x in M.inventory_items)
      if(M.inventory_items[x] == I)
        M.inventory_items[x] = null
    I.layer = 3
    I.loc = M.loc
    M.client.screen -= I
