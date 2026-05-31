/datum/enchantment/pylon_rider
    enchantment_name = "Pylon Rider"
    examine_text = "It pulses with leyline energy, as if eager to carry you along the flow of mana."
    enchantment_end_message = "The leyline attunement fades from the item."
    enchantment_color = COLOR_CYAN
    essence_recipe = list(
        /datum/thaumaturgical_essence/magic = 35,
        /datum/thaumaturgical_essence/air = 15,
    )
    required_type = list(/obj/item/clothing)
    var/active_item

/datum/enchantment/pylon_rider/register_triggers(atom/item)
    . = ..()
    registered_signals += COMSIG_ITEM_EQUIPPED
    RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
    registered_signals += COMSIG_ITEM_DROPPED
    RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/enchantment/pylon_rider/proc/on_equip(obj/item/i, mob/living/user, slot)
    if((slot & ITEM_SLOT_HANDS) && !ismobholder(i))
        return
    if(active_item)
        return
    active_item = TRUE
    ADD_TRAIT(user, TRAIT_PYLON_RIDER, "[REF(i)]")
    to_chat(user, span_notice("You feel attuned to the leylines."))

/datum/enchantment/pylon_rider/proc/on_drop(obj/item/i, mob/living/user)
    if(active_item)
        active_item = FALSE
        REMOVE_TRAIT(user, TRAIT_PYLON_RIDER, "[REF(i)]")
        to_chat(user, span_notice("You feel disconnected from the leylines."))
