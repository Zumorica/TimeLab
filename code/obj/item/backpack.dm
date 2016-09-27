/obj/item/backpack
  icon = 'images/items.dmi'
  icon_state = "backpack"
  var/inventory/storage/inv = new/inventory/storage

  /obj/item/backpack/Interacted(mob/other)
    if(src in other.contents)
      if(other.inventory_items[other.active_hand])
        inv.addTo(other.inventory_items[other.active_hand], other)
      else
        inv.open()
    else
      ..()
