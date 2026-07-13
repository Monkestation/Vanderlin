/datum/enchantment/on_hit/frostbite
	enchantment_name = "Frostbite"
	examine_text = "This weapon is covered in a thin layer of frost."
	enchantment_color = "#87CEEB"
	enchantment_end_message = "The frost melts away."
	essence_recipe = list(
		/datum/thaumaturgical_essence/frost = 30,
		/datum/thaumaturgical_essence/poison = 15,
		/datum/thaumaturgical_essence/water = 10
	)
	cooldown_time = 7 SECONDS

/datum/enchantment/on_hit/frostbite/apply_attack_effects(obj/item/source, mob/living/carbon/human/attacked, mob/living/carbon/attacker, actual_damage)
	apply_frost_stack(attacked, 1)
