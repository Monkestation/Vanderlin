
/datum/enchantment/briarcurse
	enchantment_name = "Briar's curse"
	examine_text = "Its grip seems thorny. Must hurt to use."
	essence_recipe = list(
		/datum/thaumaturgical_essence/poison = 40,
		/datum/thaumaturgical_essence/chaos = 30,
		/datum/thaumaturgical_essence/life = 10 // Corrupted life essence
	)
	var/last_used

/datum/enchantment/briarcurse/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_AFTERATTACK
	RegisterSignal(item, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_hit))

/datum/enchantment/briarcurse/add_item(obj/item/enchanter)
	.=..()
	enchanter.force += 10

/datum/enchantment/briarcurse/proc/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(isliving(target))
		var/mob/living/carbon/targeted = target
		targeted.adjustBruteLoss(10)
		to_chat(user, span_notice("[source] gouges you with it's sharp edges!"))
