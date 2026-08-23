/datum/enchantment/mana_capacity
	enchantment_name = "Mana Capacity"
	examine_text = "I can feel this objects mana and use it freely."

	essence_recipe = list(
		/datum/thaumaturgical_essence/energia = 30,
		/datum/thaumaturgical_essence/crystal = 30
	)
	var/hardcap_increase = 1000
	var/active_item = FALSE

/datum/enchantment/mana_capacity/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	registered_signals += COMSIG_ITEM_DROPPED
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/enchantment/mana_capacity/proc/on_equip(obj/item/source, mob/living/carbon/equipper, slot)
	if(active_item)
		return
	else
		active_item = TRUE
		equipper.mana_pool?.set_max_mana(equipper.mana_pool.maximum_mana_capacity + hardcap_increase, change_softcap = TRUE)

/datum/enchantment/mana_capacity/proc/on_drop(datum/source, mob/living/carbon/user)
	if(enchanted_item.loc == user)
		return
	if(active_item)
		active_item = FALSE

	var/new_max = user.mana_pool.maximum_mana_capacity - hardcap_increase
	user.mana_pool?.set_max_mana(new_max)
	if(user.mana_pool?.amount > new_max)
		user.mana_pool.amount = new_max * 0.9
