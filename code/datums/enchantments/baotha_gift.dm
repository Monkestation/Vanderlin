/datum/enchantment/baothagift
	enchantment_name = "Rapture"
	examine_text = "A euphoric haze coils around the weapon."
	enchantment_color = "#fe019a"
	enchantment_end_message = "The intoxicating glamour fades away." //No, it won't
	essence_recipe = list(
		/datum/thaumaturgical_essence/poison = 20
	)

/datum/enchantment/baothagift/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_AFTERATTACK
	RegisterSignal(item, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_hit))

/datum/enchantment/baothagift/proc/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(isliving(target) && isliving(user))
		var/mob/living/victim = target

		victim.reagents.add_reagent(pick(/datum/reagent/ozium, /datum/reagent/druqks, /datum/reagent/berrypoison, /datum/reagent/stampoison, /datum/reagent/toxin/fyritiusnectar), 0.5)

		to_chat(victim, span_warning("You feel something entering your system!"))
