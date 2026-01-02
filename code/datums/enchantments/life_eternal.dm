
/datum/enchantment/life_eternal
	enchantment_name = "Life Eternal"
	examine_text = "This item radiates with the pure essence of life itself."
	enchantment_color = "#FF69B4"
	enchantment_end_message = "The life essence fades away."
	essence_recipe = list(
		/datum/thaumaturgical_essence/life = 80,
		/datum/thaumaturgical_essence/cycle = 50,
		/datum/thaumaturgical_essence/magic = 35,
		/datum/thaumaturgical_essence/light = 30
	)

/datum/enchantment/life_eternal/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	registered_signals += COMSIG_ITEM_DROPPED
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/enchantment/life_eternal/proc/on_equip(obj/item/i, mob/living/user)
	// Constant slow healing while equipped
	START_PROCESSING(SSobj, src)

/datum/enchantment/life_eternal/proc/on_drop(obj/item/i, mob/living/user)
	STOP_PROCESSING(SSobj, src)

/datum/enchantment/life_eternal/process()
	if(enchanted_item.loc && isliving(enchanted_item.loc))
		var/mob/living/L = enchanted_item.loc
		if(L.health < L.maxHealth)
			L.heal_bodypart_damage(1, 1)
