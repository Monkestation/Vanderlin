
/datum/enchantment/binding_runes
	enchantment_name = "Binding Runes"
	examine_text = "Strange engravings cover this, it would be unwise to put it on."
	essence_recipe = list(
		/datum/thaumaturgical_essence/chaos = 30,
		/datum/thaumaturgical_essence/cycle = 20
	)
	var/datum/weakref/enchanter

/datum/enchantment/binding_runes/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_PRE_UNEQUIP
	RegisterSignal(item, COMSIG_ITEM_PRE_UNEQUIP, PROC_REF(tries_to_unequip))

/datum/enchantment/binding_runes/apply_user_modifications(mob/user)
	enchanter = WEAKREF(user)

/datum/enchantment/binding_runes/proc/tries_to_unequip(datum/source, force, atom/newloc, no_move, invdrop, silent)
	var/mob/living/location = enchanted_item.loc
	if(istype(location))
		if(enchanted_item in location.held_items)
			return
	if(!enchanter)
		return COMPONENT_ITEM_BLOCK_UNEQUIP
	var/atom/real_enchanter = enchanter.resolve()
	if(!real_enchanter)
		return COMPONENT_ITEM_BLOCK_UNEQUIP
	if(source != real_enchanter)
		return COMPONENT_ITEM_BLOCK_UNEQUIP
