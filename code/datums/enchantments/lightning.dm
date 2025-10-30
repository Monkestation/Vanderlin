
/datum/enchantment/lightning
	enchantment_name = "Lightning"
	examine_text = "Small arcs of electricity dance across this weapon."
	enchantment_color = "#FFFF00"
	enchantment_end_message = "The electrical energy dissipates."
	essence_recipe = list(
		/datum/thaumaturgical_essence/energia = 45,
		/datum/thaumaturgical_essence/air = 25,
		/datum/thaumaturgical_essence/chaos = 15
	)

	var/last_used

/datum/enchantment/lightning/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_AFTERATTACK
	RegisterSignal(item, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_hit))

/datum/enchantment/lightning/proc/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < (last_used + 100 SECONDS))
		return

	if(isliving(target))
		var/mob/living/L = target
		L.electrocute_act(10, source, 1)

		for(var/mob/living/nearby in range(2, target))
			if(nearby == target || nearby == user)
				continue
			if(prob(30))
				nearby.electrocute_act(5, source, 1)
				new /obj/effect/temp_visual/lightning(get_turf(target), get_turf(nearby))
	last_used = world.time
