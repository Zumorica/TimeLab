/obj/item/container
  icon = 'images/items.dmi'
  var/inventory/storage/inv = new/inventory/storage

  /obj/item/container/Interacted(mob/other)
    if(src in other.contents)
      if(other.inventory_items[other.active_hand])
        inv.addTo(other.inventory_items[other.active_hand], other)
      else
        inv.open(other)
    else
      ..()

/obj/item/container/suitcase
  icon_state = "suitcase"
