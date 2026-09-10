/datum/enchantment/curse_guard
	enchantment_name = "Curse Guard"
	examine_text = "These gloves help resist the magical effects of held objects."

	essence_recipe = list(
		/datum/thaumaturgical_essence/cycle = 25,
		/datum/thaumaturgical_essence/magic = 15
	)
	required_type = list(/obj/item/clothing/gloves)


/datum/enchantment/proc/check_curse_guard(obj/item/source, mob/living/carbon/human/target)
	var/obj/item/main_hand = target.get_active_held_item()
	var/obj/item/off_hand = target.get_inactive_held_item()
	if(source == main_hand || source == off_hand)
		var/obj/item/clothing/gloves/glove = target.get_item_by_slot(ITEM_SLOT_GLOVES)
		if(glove?.get_enchantment(/datum/enchantment/curse_guard))
			return TRUE
	return FALSE
