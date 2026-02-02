
/datum/mob_affix_system
	var/list/available_affixes = list()

/datum/mob_affix_system/New()
	. = ..()
	available_affixes = subtypesof(/datum/mob_affix)

/datum/mob_affix_system/proc/get_stat_multipliers(delve_level, mob_tier = 0)
	var/list/multipliers = list()
	var/level_factor = delve_level * 0.08 + (mob_tier * 0.1)

	multipliers["health"] = 1.15 + level_factor
	multipliers["damage"] = 1.1 + (level_factor * 0.8)
	multipliers["vision"] = 1 + (level_factor * 0.3)
	multipliers["speed"] = max(0.7, 1 - (level_factor * 0.2)) // Lower is faster

	return multipliers

/datum/mob_affix_system/proc/get_max_affixes(delve_level, mob_tier = 0)
	return delve_level + mob_tier

/datum/mob_affix_system/proc/enhance_mob(mob/living/simple_animal/hostile/retaliate/target, delve_level, bonus_affixes = 0)
	if(!target || !istype(target))
		return null

	// Apply base stat scaling
	var/list/multipliers = get_stat_multipliers(delve_level, target.tier)

	target.maxHealth = round(target.maxHealth * multipliers["health"])
	target.health = target.maxHealth
	target.harm_intent_damage = round(target.harm_intent_damage * multipliers["damage"])
	target.move_to_delay = round(target.move_to_delay * multipliers["speed"])
	target.vision_range = round(target.vision_range * multipliers["vision"])
	target.aggro_vision_range = round(target.aggro_vision_range * multipliers["vision"])

	// Generate affixes
	var/max_affixes = get_max_affixes(delve_level, target.tier) + bonus_affixes
	var/actual_affixes = 0

	// Determine actual number of affixes
	for(var/i = 1; i <= max_affixes; i++)
		if(prob(40 + (delve_level * 4))) // Better chance at higher levels
			actual_affixes++

	actual_affixes = max(1, actual_affixes) // Always at least 1 at higher delve levels

	// Apply affixes
	var/list/chosen_affixes = list()
	var/list/available = available_affixes.Copy()

	for(var/i = 1; i <= actual_affixes && available.len; i++)
		var/chosen_type = pick(available)
		available -= chosen_type

		var/datum/mob_affix/new_affix = new chosen_type()
		new_affix.intensity = 1 + (delve_level * 0.08) + (target.tier * 0.1)
		new_affix.delve_level = delve_level
		new_affix.apply_affix(target)

		chosen_affixes += new_affix

	target.affixes = chosen_affixes
	target.delve_level = delve_level

	// Update mob name
	if(chosen_affixes.len)
		var/affix_names = ""
		for(var/datum/mob_affix/affix in chosen_affixes)
			if(affix_names != "")
				affix_names += ", "
			affix_names += affix.name

		target.name = "[affix_names] [target.name]"

	return target

/datum/mob_affix_system/proc/remove_affixes(mob/living/simple_animal/hostile/retaliate/target)
	if(!target || !target.affixes)
		return

	for(var/datum/mob_affix/affix in target.affixes)
		affix.cleanup_affix(target)
		qdel(affix)

	target.affixes = list()
	target.delve_level = 0
