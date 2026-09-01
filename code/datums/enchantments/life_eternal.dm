
/datum/enchantment/life_eternal
	enchantment_name = "Life Eternal"
	examine_text = "This item radiates with the pure essence of life itself."
	enchantment_color = "#FF69B4"
	enchantment_end_message = "The life essence fades away."
	essence_recipe = list(
		/datum/thaumaturgical_essence/life = 60,
		/datum/thaumaturgical_essence/cycle = 30,
		/datum/thaumaturgical_essence/magic = 20,
		/datum/thaumaturgical_essence/light = 15
	)
	required_type = list(/obj/item/clothing)
	var/healing_power = 1

/datum/enchantment/life_eternal/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	registered_signals += COMSIG_ITEM_DROPPED
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/enchantment/life_eternal/proc/on_equip(obj/item/i, mob/living/user, slot)
	var/datum/enchantment/life_eternal/enchantment
	if(slot != ITEM_SLOT_HANDS)		//preventing it from triggering if held
		//I might have not have a brain, gentlemen, but i have an idea...
		//We cycle through all gear with life_eternal enchantment, increasing healing_power counter,
		//disabling previous enchantments processing, till we reach the final item, that will be processed.
		//More enchanted items = higher healing power
		for(var/obj/item/clothing/gear in user.get_all_gear())
			if(gear != i && gear.has_enchantment(/datum/enchantment/life_eternal))
				enchantment = gear.get_enchantment(/datum/enchantment/life_eternal)
				STOP_PROCESSING(SSobj, enchantment)
				healing_power += 1
			else if(gear == i)
				START_PROCESSING(SSobj, src)
				continue
	else
		return

/datum/enchantment/life_eternal/proc/on_drop(obj/item/i, mob/living/user)
	var/enchanted_items = 0
	var/datum/enchantment/life_eternal/enchantment = null
	STOP_PROCESSING(SSobj, src)
	src.healing_power = 1
	for(var/obj/item/clothing/gear in user.get_all_gear())
		if(gear.has_enchantment(/datum/enchantment/life_eternal))
			enchanted_items += 1
			enchantment = gear.get_enchantment(/datum/enchantment/life_eternal)
	if(enchanted_items != 0)
		enchantment.healing_power = enchanted_items
		START_PROCESSING(SSobj, enchantment)
	else
		return


/datum/enchantment/life_eternal/process()
	if(enchanted_item.loc && isliving(enchanted_item.loc))
		var/mob/living/carbon/human/L = enchanted_item.loc
		if(L.stat != DEAD)
			L.heal_wounds(0.1 * healing_power, TRUE)
			L.heal_bodypart_damage(0.1 * healing_power, 0.1 * healing_power, TRUE, required_status = BODYPART_ORGANIC)
			L.adjustOrganLoss(-0.05 * healing_power)

