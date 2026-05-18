
/datum/quality_calculator/blacksmithing
	name = "Blacksmithing Quality"

	quality_descriptors = alist(
		BLACKSMITH_QUALITY_SPOILED = list("name_prefix" = "ruined", "modifier" = 0.6, "price_modifier" = 0.6),
		BLACKSMITH_QUALITY_AWFUL = list("name_prefix" = "awful", "modifier" = 0.7, "price_modifier" = 0.7),
		BLACKSMITH_QUALITY_CRUDE = list("name_prefix" = "crude", "modifier" = 0.8, "price_modifier" = 0.8),
		BLACKSMITH_QUALITY_ROUGH = list("name_prefix" = "rough", "modifier" = 0.9, "price_modifier" = 0.9),
		BLACKSMITH_QUALITY_COMPETENT = list("name_prefix" = "", "modifier" = 1.0, "price_modifier" = 1.0),
		BLACKSMITH_QUALITY_FINE = list("name_prefix" = "fine", "modifier" = 1.1, "price_modifier" = 1.1),
		BLACKSMITH_QUALITY_FLAWLESS = list("name_prefix" = "flawless", "modifier" = 1.2, "price_modifier" = 1.2),
		BLACKSMITH_QUALITY_LEGENDARY = list("name_prefix" = "masterwork", "modifier" = 1.3, "price_modifier" = 1.3)
	)

	var/performance_quality = 0
	var/difficulty_modifier = 0
	var/minigame_plays = 0
	var/skill_randomization = 0

/datum/quality_calculator/blacksmithing/New(mat_qual = 0, skill_qual = 0, components = 1, reagent_qual = 0, perf_qual = 0, diff_mod = 0, mini_play = 1)
	..()
	performance_quality = perf_qual
	difficulty_modifier = diff_mod
	minigame_plays = mini_play
	skill_randomization = rand(0, 0.5) // just a healthy amount of randomization

// REMINDERS:
// skill ranges from 0 to 6
// performance ranges from 0 to 100 (100 is perfect)
// material ranges from 1 to 6 (3 is regular)
// smithing scales from -10 to 10 (0 is regular)
// Tier differences are between 2 and 3 (for positive ones)
/datum/quality_calculator/blacksmithing/calculate_final_quality()
	var/avg_skill = skill_quality / minigame_plays
	avg_skill = min(avg_skill + skill_randomization, SKILL_LEVEL_LEGENDARY) // just a healthy amount of randomization
	var/avg_material = floor(material_quality / num_components)
	var/avg_performance = performance_quality / minigame_plays

	/* Explanations for factors and their scaling
	* Skill (MAJOR): Essentially the base quality for each skill level
	* Material (MAJOR): Good materials is just as important as skill
	* Performance (MINOR): Good performance can push items up a tier
	* Difficulty (MINOR) : Makes harder recipes have lower qualities in general
	*/
	var/skill_component = (avg_skill / 6) * (-BLACKSMITH_QUALITY_SPOILED + BLACKSMITH_QUALITY_FLAWLESS)
	var/material_component = ((avg_material - SMELTERY_QUALITY_NORMAL) / SMELTERY_QUALITY_NORMAL) * 6
	var/performance_component
	if(avg_performance > MINIMUM_ANVIL_MINIGAME_SCORE)
		performance_component = (avg_performance / 100) * 3
	else
		performance_component = (avg_performance - MINIMUM_ANVIL_MINIGAME_SCORE) * 3
	var/difficulty_penalty = difficulty_modifier * 0.3

	var/final_quality = skill_component + material_component + performance_component - difficulty_penalty
	final_quality -= 7

	return clamp(final_quality, BLACKSMITH_QUALITY_SPOILED, BLACKSMITH_QUALITY_LEGENDARY)

/datum/quality_calculator/blacksmithing/apply_quality_to_item(obj/item/target, track_creation)
	. = ..()
	if(!.)
		return

	var/list/quality_data = .

	var/modifier = quality_data["modifier"]
	// Apply basic modifiers
	target.modify_max_integrity(target.max_integrity * modifier, can_break = FALSE)

	// Lockpicks - make them better at their job
	if(istype(target, /obj/item/lockpick))
		var/obj/item/lockpick/L = target
		L.picklvl = modifier
	// Weapons
	else if(istype(target, /obj/item/weapon))
		var/obj/item/weapon/W = target
		var/datum/component/two_handed/twohanded = W.GetComponent(/datum/component/two_handed)
		if(twohanded)
			twohanded.modify_base_force(multiplicative_modifier = modifier)
		else
			W.force *= modifier
		if(W.throwforce)
			W.throwforce *= modifier
		if(W.blade_int)
			W.blade_int *= modifier
			W.max_blade_int *= modifier

		// Special handling for axes and pick-axes - better at woodcutting
		if(istype(target, /obj/item/weapon/axe/iron) || istype(target, /obj/item/weapon/pick/paxe))
			var/obj/item/weapon/A = target
			A.axe_cut += (A.force * modifier) * 0.5 // Add half of modified damage as axe_cut

		// Special handling for picks - better at mining
		if(istype(target, /obj/item/weapon/pick))
			var/obj/item/weapon/pick/P = target
			P.pickmult *= modifier

	// Guns - modify damage multiplier
	else if(isgun(target))
		var/obj/item/gun/gun = target
		gun.projectile_damage_multiplier *= modifier

	// Bear traps - modify trap damage
	else if(istype(target, /obj/item/restraints/legcuffs/beartrap))
		var/obj/item/restraints/legcuffs/beartrap/B = target
		B.trap_damage *= modifier

	// In order to preserve material quality information for smelting
	var/avg_material = floor(material_quality / num_components)
	target.set_quality(avg_material)

/datum/quality_calculator/blacksmithing/track_item_creation(obj/item/target, final_quality)
	// Track masterworks if enabled
	if(final_quality >= BLACKSMITH_QUALITY_LEGENDARY)
		record_round_statistic(STATS_MASTERWORKS_FORGED, 1)
