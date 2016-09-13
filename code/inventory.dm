var/inventory/inventory = new/inventory

/inventory
  var/layer = 22
  var/active_hand = "right"

  /inventory/proc/addItem(mob/M, obj/storable/I)
    M.contents += I
    I.layer = layer

    if(active_hand == "right")
      I.screen_loc = "9, 1"
      M.client.screen += I
    else
      I.screen_loc = "8, 1"
      M.client.screen += I

  /inventory/proc/dropItem(mob/M, obj/storable/I)
    M.contents -= I
    I.layer = 3
    I.loc = M.loc
    M.client.screen -= I
