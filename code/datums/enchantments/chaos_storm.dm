
/datum/enchantment/chaos_storm
	enchantment_name = "Chaos Storm"
	examine_text = "This weapon crackles with unpredictable chaotic energy."
	enchantment_color = "#8A2BE2"
	enchantment_end_message = "The chaotic energies settle."
	should_process = TRUE
	essence_recipe = list(
		/datum/thaumaturgical_essence/chaos = 70,
		/datum/thaumaturgical_essence/energia = 45,
		/datum/thaumaturgical_essence/magic = 30,
		/datum/thaumaturgical_essence/fire = 25
	)

	var/last_used

/datum/enchantment/chaos_storm/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_AFTERATTACK
	RegisterSignal(item, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_hit))

/datum/enchantment/chaos_storm/proc/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < src.last_used + 10 SECONDS)
		return

	if(isliving(target))
		var/mob/living/L = target
		switch(rand(1,5))
			if(1)
				L.apply_damage(15, BURN)
				to_chat(L, span_warning("Chaotic flames engulf you!"))
			if(2)
				L.apply_damage(10, BRUTE)
				L.Knockdown(20)
				to_chat(L, span_warning("Chaotic force slams into you!"))
			if(3)
				L.electrocute_act(12, source, 1)
				to_chat(L, span_warning("Chaotic lightning courses through you!"))
			if(4)
				L.OffBalance(2.5 SECONDS)
				to_chat(L, span_warning("Chaotic energy disrupts your coordination!"))
			if(5)
				L.confused += 2 SECONDS
				to_chat(L, span_warning("Chaotic energy scrambles your thoughts!"))
	last_used = world.time
