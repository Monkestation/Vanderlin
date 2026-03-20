#define QUALITY_LEVEL_SPOILED "-10"
#define QUALITY_LEVEL_AWFUL "-5"
#define QUALITY_LEVEL_CRUDE "-2"
#define QUALITY_LEVEL_ROUGH "-1"
#define QUALITY_LEVEL_COMPETENT "0"
#define QUALITY_LEVEL_FINE "2"
#define QUALITY_LEVEL_FLAWLESS "5"
#define QUALITY_LEVEL_LEGENDARY "8"

/proc/create_quality_item(obj/item/base_item, datum/quality_calculator/calculator)
	if(!calculator || !base_item)
		return base_item

	calculator.apply_quality_to_item(base_item)
	return base_item

/datum/quality_calculator
	var/name = "Generic Quality"
	var/base_quality = 0
	var/material_quality = 0
	var/reagent_quality = 0
	var/skill_quality = 0
	var/performance_quality = 0
	var/difficulty_modifier = 0
	var/num_components = 1

	// Quality descriptors - generalized now so we can give them better modifiers
	var/list/quality_descriptors = list(
		QUALITY_LEVEL_SPOILED = list("name_prefix" = "ruined", "modifier" = 0.3),
		QUALITY_LEVEL_AWFUL = list("name_prefix" = "awful", "modifier" = 0.5),
		QUALITY_LEVEL_CRUDE = list("name_prefix" = "crude", "modifier" = 0.8),
		QUALITY_LEVEL_ROUGH = list("name_prefix" = "rough", "modifier" = 0.9),
		QUALITY_LEVEL_COMPETENT = list("name_prefix" = "", "modifier" = 1.0),
		QUALITY_LEVEL_FINE = list("name_prefix" = "fine", "modifier" = 1.1),
		QUALITY_LEVEL_FLAWLESS = list("name_prefix" = "flawless", "modifier" = 1.2),
		QUALITY_LEVEL_LEGENDARY = list("name_prefix" = "masterwork", "modifier" = 1.3)
	)

/datum/quality_calculator/New(base_qual = 0, mat_qual = 0, skill_qual = 0, perf_qual = 0, diff_mod = 0, components = 1, reagent_qual = 0)
	base_quality = base_qual
	material_quality = mat_qual
	skill_quality = skill_qual
	performance_quality = perf_qual
	difficulty_modifier = diff_mod
	num_components = max(1, components)
	reagent_quality = reagent_qual

/datum/quality_calculator/proc/calculate_final_quality()
	// Average out component-based qualities
	var/avg_material = floor(material_quality / num_components)
	var/avg_skill = floor(skill_quality / num_components)
	var/avg_performance = floor(performance_quality / num_components)

	var/final_quality = base_quality + avg_material + avg_skill + avg_performance - difficulty_modifier

	return final_quality

/datum/quality_calculator/proc/get_quality_tier(quality_value)
	var/best_tier = text2num(QUALITY_LEVEL_SPOILED)
	for(var/tier in quality_descriptors)
		if(quality_value >= text2num(tier) && text2num(tier) > best_tier)
			best_tier = text2num(tier)
	return best_tier

/datum/quality_calculator/proc/get_quality_data(quality_value = null)
	if(isnull(quality_value))
		quality_value = calculate_final_quality()

	var/tier = get_quality_tier(quality_value)
	return quality_descriptors[num2text(tier)]

/datum/quality_calculator/proc/apply_quality_to_item(obj/item/target, track_masterworks = FALSE)
	var/final_quality = calculate_final_quality()
	var/list/quality_data = get_quality_data(final_quality)

	if(!quality_data || !quality_data["modifier"])
		return FALSE

	var/modifier = quality_data["modifier"]
	var/name_prefix = quality_data["name_prefix"]

	// Apply name prefix
	if(name_prefix && name_prefix != "")
		target.name = "[name_prefix] [target.name]"

	// Apply basic modifiers
	target.modify_max_integrity(target.max_integrity * modifier, can_break = FALSE)
	if(target.sellprice)
		target.sellprice *= modifier

	// Track masterworks if enabled
	if(track_masterworks && final_quality >= text2num(QUALITY_LEVEL_LEGENDARY))
		record_round_statistic(STATS_MASTERWORKS_FORGED, 1)

	apply_specialized_modifiers(target, modifier)

	return TRUE


/datum/quality_calculator/proc/apply_specialized_modifiers(obj/item/target, modifier)
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
		// if(W.armor_penetration)
		// 	W.armor_penetration *= modifier
		// if(W.wdefense)
		// 	W.wdefense *= modifier

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

	// Clothing/Armor
	else if(istype(target, /obj/item/clothing))
		var/obj/item/clothing/C = target
		// if(C.damage_deflection)
		// 	C.damage_deflection *= modifier
		if(C.integrity_failure)
			C.integrity_failure /= modifier
		// if(C.armor)
		// 	C.armor = C.armor.multiplymodifyAllRatings(modifier)
		// if(C.equip_delay_self)
		// 	C.equip_delay_self *= modifier
