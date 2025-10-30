/datum/enchantment/mana_regeneration
	enchantment_name = "Mana Regeneration"
	examine_text = "Mana flows freely from this object."

	should_process = TRUE
	essence_recipe = list(
		/datum/thaumaturgical_essence/energia = 35,
		/datum/thaumaturgical_essence/cycle = 25
	)
	var/regeneration_rate = 2

/datum/enchantment/mana_regeneration/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	registered_signals += COMSIG_ITEM_DROPPED
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/enchantment/mana_regeneration/proc/on_equip(obj/item/i, mob/living/user)
	// Constant slow healing while equipped
	START_PROCESSING(SSobj, src)

/datum/enchantment/mana_regeneration/proc/on_drop(obj/item/i, mob/living/user)
	STOP_PROCESSING(SSobj, src)

/datum/enchantment/mana_regeneration/process()
	if(!iscarbon(enchanted_item.loc))
		return
	var/mob/living/carbon/mob = enchanted_item.loc
	mob.safe_adjust_personal_mana(regeneration_rate)
