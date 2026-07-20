/datum/enchantment/shrinking
	enchantment_name = "Shrinking"
	examine_text = "I can feel myself getting smaller from here."

	essence_recipe = list(
		/datum/thaumaturgical_essence/motion = 30,
		/datum/thaumaturgical_essence/magic = 10,
	)
	required_type = list(/obj/item/clothing)
	var/active_item

/datum/enchantment/shrinking/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	registered_signals += COMSIG_ITEM_DROPPED
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/enchantment/shrinking/proc/on_equip(obj/item/i, mob/living/user, slot)
	if((slot & ITEM_SLOT_HANDS) && !ismobholder(i))
		return
	if(active_item)
		return
	else
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_TINY, "[REF(i)]")
		to_chat(user, span_notice("So this is how Kobolds feel."))

/datum/enchantment/shrinking/proc/on_drop(obj/item/i, mob/living/user)
	if(active_item)
		active_item = FALSE
		REMOVE_TRAIT(user, TRAIT_TINY, "[REF(i)]")
		to_chat(user, span_notice("I feel mundane once more."))
