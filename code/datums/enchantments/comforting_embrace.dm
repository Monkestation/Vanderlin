/datum/enchantment/comforting_embrace
	enchantment_name = "Comforting Embrace"
	examine_text = "It feels so comforting."

	should_process = TRUE
	essence_recipe = list(
		/datum/thaumaturgical_essence/life = 35,
		/datum/thaumaturgical_essence/cycle = 25
	)
	required_type = list(/obj/item/clothing)

/datum/enchantment/comforting_embrace/can_enchant(obj/item/clothing/item)
	if(!istype(item))
		return FALSE
	if(!(item.clothing_flags & CANT_SLEEP_IN))
		return FALSE
	return TRUE

/datum/enchantment/comforting_embrace/register_triggers(obj/item/clothing/item)
	. = ..()
	item.clothing_flags &= ~CANT_SLEEP_IN

/datum/enchantment/comforting_embrace/unregister_triggers()
	. = ..()
	var/obj/item/clothing/clothing = enchanted_item
	clothing.clothing_flags |= CANT_SLEEP_IN
