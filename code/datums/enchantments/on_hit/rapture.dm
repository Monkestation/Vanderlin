/datum/enchantment/on_hit/baothagift
	enchantment_name = "Rapture"
	examine_text = "A euphoric haze coils around the weapon."
	enchantment_color = "#fe019a"
	enchantment_end_message = "The intoxicating glamour fades away."
	essence_recipe = list(
		/datum/thaumaturgical_essence/poison = 20
	)
	cooldown_time = 0

/datum/enchantment/on_hit/baothagift/apply_attack_effects(obj/item/source, mob/living/carbon/human/attacked, mob/living/carbon/attacker, actual_damage)
	attacked.reagents.add_reagent(pick(/datum/reagent/ozium, /datum/reagent/druqks, /datum/reagent/berrypoison, /datum/reagent/stampoison, /datum/reagent/toxin/fyritiusnectar), 0.5)
	to_chat(attacked, span_warning("You feel something entering your system!"))
