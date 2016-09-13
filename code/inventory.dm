var/inventory/inventory = new/inventory

/inventory
  var/layer = 22
  var/active_hand = "right_hand"

  /inventory/proc/addItem(mob/M, obj/storable/I)
    if(active_hand == "right_hand")
      if(M.inventory_items[active_hand])
        return
      else
        M.contents += I
        M.inventory_items[active_hand] = I
        I.layer = layer
        I.screen_loc = "9, 1"
        M.client.screen += I
    if(active_hand == "left_hand")
      if(M.inventory_items[active_hand])
        return
      else
        M.contents += I
        M.inventory_items[active_hand] = I
        I.layer = layer
        I.screen_loc = "8, 1"
        M.client.screen += I

  /inventory/proc/dropItem(mob/M, obj/storable/I)
    M.contents -= I
    for(var/x in M.inventory_items)
      if(M.inventory_items[x] == I)
        M.inventory_items.Remove(x)
    I.layer = 3
    I.loc = M.loc
    M.client.screen -= I
