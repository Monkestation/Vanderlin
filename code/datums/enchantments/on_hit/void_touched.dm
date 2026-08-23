/datum/enchantment/on_hit/void_touched
	enchantment_name = "Void Touched"
	examine_text = "This item seems to absorb light around it, existing partially outside reality."
	enchantment_color = "#2F2F2F"
	enchantment_end_message = "The item returns to normal reality."
	essence_recipe = list(
		/datum/thaumaturgical_essence/void = 60,
		/datum/thaumaturgical_essence/magic = 40,
		/datum/thaumaturgical_essence/chaos = 35,
		/datum/thaumaturgical_essence/energia = 25
	)
	cooldown_time = 100 SECONDS

/datum/enchantment/on_hit/void_touched/apply_attack_effects(obj/item/source, mob/living/carbon/human/attacked, mob/living/carbon/attacker, actual_damage)
	if(!prob(15))
		return
	to_chat(attacked, span_warning("You feel reality warp around you!"))
	var/list/possible_turfs = list()
	for(var/turf/T in range(3, attacked))
		if(T.density)
			continue
		possible_turfs += T
	if(possible_turfs.len)
		attacked.forceMove(pick(possible_turfs))
