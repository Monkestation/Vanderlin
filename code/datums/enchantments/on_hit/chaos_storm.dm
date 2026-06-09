/datum/enchantment/on_hit/chaos_storm
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
	cooldown_time = 10 SECONDS

/datum/enchantment/on_hit/chaos_storm/apply_attack_effects(obj/item/source, mob/living/carbon/human/attacked, mob/living/carbon/attacker, actual_damage)
	switch(rand(1,5))
		if(1)
			attacked.apply_damage(15, BURN)
			to_chat(attacked, span_warning("Chaotic flames engulf you!"))
		if(2)
			attacked.apply_damage(10, BRUTE)
			attacked.Knockdown(20)
			to_chat(attacked, span_warning("Chaotic force slams into you!"))
		if(3)
			attacked.electrocute_act(12, source, 1)
			to_chat(attacked, span_warning("Chaotic lightning courses through you!"))
		if(4)
			attacked.OffBalance(2.5 SECONDS)
			to_chat(attacked, span_warning("Chaotic energy disrupts your coordination!"))
		if(5)
			attacked.adjust_confusion(2 SECONDS)
			to_chat(attacked, span_warning("Chaotic energy scrambles your thoughts!"))

