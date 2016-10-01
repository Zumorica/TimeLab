var/inventory/inventory = new/inventory

/inventory
  var/layer = 22
  var/list/inventory_slots
  inventory_slots = list("right_hand", "left_hand", "right_pocket" = list(1), "left_pocket" = list(1), "back" = list(1, 2, 3), "keychain" = list(4))  // Each inventory slot contains a list of sizes it can fit.

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

  /inventory/proc/dropItem(mob/M)
    var/obj/item/I = M.inventory_items[M.active_hand]
    M.contents -= I
    M.inventory_items[M.active_hand] = null
    I.layer = 3
    I.loc = M.loc
    M.client.screen -= I

  /inventory/proc/change(mob/M, i_slot)
    var/obj/item/I = M.inventory_items[M.active_hand]
    if(!M.inventory_items[i_slot] && I)
      if(!(I.size in inventory_slots[i_slot]))
        M << "This item is too big to fit in there!"
        return
      M.inventory_items[i_slot] = I
      M.inventory_items[M.active_hand] = null
      switch(i_slot)
        if("left_pocket")
          I.screen_loc = "10, SOUTH"
        if("right_pocket")
          I.screen_loc = "11, SOUTH"
        if("keychain")
          I.screen_loc = "6, SOUTH"
        if("back")
          I.screen_loc = "7, SOUTH"
        else
          return
    else
      return

/inventory/storage
  var/is_open = False
  var/list/storage_items = list()

  /inventory/storage/proc/addTo(obj/item/I, mob/M)
    if(istype(I, /obj/item/container))
      return
    storage_items += I
    M.contents -= I
    M.inventory_items[M.active_hand] = null
    if(!is_open)
      I.screen_loc = null
    else
      I.screen_loc = "[length(storage_items)+3], SOUTH+1"

  /inventory/storage/proc/open(mob/other)
    for(var/obj/item/container/c in other.contents)
      c.close(other)
    var/x = 4
    while(x<16)
      other.client.screen += world_hud["Storage[x]"]
      x++
    for(var/obj/item/y in storage_items)
      var/z = 4
      y.screen_loc = "[z], SOUTH+1"
      z++
    is_open = True

  /inventory/storage/proc/close(mob/other)
    is_open = False
    var/x = 4
    while(x<16)
      other.client.screen -= world_hud["Storage[x]"]
      x++
    for(var/obj/item/y in storage_items)
      y.screen_loc = null
