/datum/enchantment/hydrophobic
	enchantment_name = "Hydrophobic"
	examine_text = "This item seems to be constantly trying to push water away from it."

	essence_recipe = list(
		/datum/thaumaturgical_essence/water = 35,
		/datum/thaumaturgical_essence/cycle = 10,
		/datum/thaumaturgical_essence/chaos = 10
	)
	required_type = list(/obj/item/clothing)
	var/active_item

/datum/enchantment/hydrophobic/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	registered_signals += COMSIG_ITEM_DROPPED
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/enchantment/hydrophobic/proc/on_equip(obj/item/i, mob/living/user, slot)
	if((slot & ITEM_SLOT_HANDS) && !ismobholder(i))
		return
	if(active_item)
		return
	else
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_SWIMMER, "[REF(i)]")
		to_chat(user, span_notice("I feel like I can fly through water."))

/datum/enchantment/hydrophobic/proc/on_drop(obj/item/i, mob/living/user)
	if(active_item)
		active_item = FALSE
		REMOVE_TRAIT(user, TRAIT_SWIMMER, "[REF(i)]")
		to_chat(user, span_notice("I feel mundane once more."))
