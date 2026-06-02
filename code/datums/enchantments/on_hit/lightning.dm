/datum/enchantment/on_hit/lightning
	enchantment_name = "Lightning"
	examine_text = "Small arcs of electricity dance across this weapon."
	enchantment_color = "#FFFF00"
	enchantment_end_message = "The electrical energy dissipates."
	essence_recipe = list(
		/datum/thaumaturgical_essence/energia = 45,
		/datum/thaumaturgical_essence/air = 25,
		/datum/thaumaturgical_essence/chaos = 15
	)
	cooldown_time = 100 SECONDS

/datum/enchantment/on_hit/lightning/apply_attack_effects(obj/item/source, mob/living/carbon/human/attacked, mob/living/carbon/attacker, actual_damage)
	new /obj/effect/temp_visual/lightning(get_turf(attacked))
	attacked.electrocute_act(10, source, 1)

	for(var/mob/living/nearby in range(2, attacked))
		if(nearby == attacked || nearby == attacker)
			continue
		if(prob(30))
			nearby.electrocute_act(5, source, 1)
			new /obj/effect/temp_visual/lightning(get_turf(nearby))
