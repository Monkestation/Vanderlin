/datum/enchantment/leaping
	enchantment_name = "Leaping"
	examine_text = "It vibrates faintly with bound movement."
	essence_recipe = list(
		/datum/thaumaturgical_essence/motion = 30,
		/datum/thaumaturgical_essence/air = 20
	)
	var/active_item

/datum/enchantment/leaping/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	registered_signals += COMSIG_ITEM_DROPPED
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/enchantment/leaping/proc/on_equip(obj/item/i, mob/living/user, slot)
	if((slot & ITEM_SLOT_HANDS) && !ismobholder(i))
		return
	if(active_item)
		return
	else
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_ZJUMP, TRAIT_GENERIC)
		to_chat(user, span_notice("My legs feel much stronger."))

/datum/enchantment/leaping/proc/on_drop(obj/item/i, mob/living/user)
	if(active_item)
		active_item = FALSE
		REMOVE_TRAIT(user, TRAIT_ZJUMP, TRAIT_GENERIC)
		to_chat(user, span_notice("I feel mundane once more."))
