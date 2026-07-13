/datum/enchantment/divine_link
	enchantment_name = "Divine Link"
	examine_text = "You can feel the Ten closer then ever before."
	enchantment_color = "#b6b6b6"
	essence_recipe = list(
		/datum/thaumaturgical_essence/life = 50,
		/datum/thaumaturgical_essence/magic = 10,
	)
	should_process = TRUE

/datum/enchantment/divine_link/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_DROPPED
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/enchantment/divine_link/proc/on_drop(obj/item/i, mob/living/user)
	if(ishuman(enchanted_item?.loc))
		return
	var/mob/living/carbon/human/carbon = user
	if(!carbon.cleric)
		return
	to_chat(carbon, span_boldwarning("MY DIVINE LINK HAS BEEN SEVERED!"))
	carbon.adjustBruteLoss(10, damage_type = WOUND_DIVINE)
	carbon.cleric.update_devotion(-50)


/datum/enchantment/divine_link/process(delta_time)
	if(!enchanted_item)
		STOP_PROCESSING(SSenchantment, src)
		return
	if(!ishuman(enchanted_item.loc))
		return
	var/obj/item/item = enchanted_item
	if(item.obj_broken)
		return
	var/mob/living/carbon/human/carbon = enchanted_item.loc
	if(!carbon.cleric)
		return
	carbon.cleric.update_devotion(2)
