/datum/attribute_modifier/augment
	variable = TRUE

/datum/augment/skill
	var/list/skill_changes = list() // List of skill changes: list(/datum/attribute/skill/combat/swords = 1)
	color = COLOR_ASSEMBLY_LBLUE
	stability_cost = 0 // Skills are zero-cost by default

/datum/augment/skill/on_install(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	var/datum/attribute_modifier/existing_modifier = H.attributes.has_attribute_modifier(/datum/attribute_modifier/augment)
	var/list/new_values
	if(existing_modifier)
		new_values = existing_modifier.attribute_list.Copy()
	else
		new_values = list()
	new_values += skill_changes
	H.attributes.add_or_update_variable_attribute_modifier(/datum/attribute_modifier/augment, TRUE, new_values)

/datum/augment/skill/on_remove(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	var/datum/attribute_modifier/existing_modifier = H.attributes.has_attribute_modifier(/datum/attribute_modifier/augment)
	var/list/new_values
	if(existing_modifier)
		new_values = existing_modifier.attribute_list.Copy()
	else
		new_values = list()
	for(var/value in skill_changes)
		if(value in new_values)
			new_values[value] -= skill_changes[value]
		else
			new_values |= value
			new_values[value] = -skill_changes[value]
	H.attributes.add_or_update_variable_attribute_modifier(/datum/attribute_modifier/augment, TRUE, new_values)

/datum/augment/skill/get_examine_info()
	var/list/info = list()
	info += span_info("Skill changes:")
	for(var/skill_type in skill_changes)
		var/datum/attribute/skill/S = skill_type
		var/change = skill_changes[skill_type]
		info += span_info("  [initial(S.name)]: [change > 0 ? "+" : ""][change]")
	return info

/datum/augment/skill/combat_matrix
	name = "combat analysis matrix"
	desc = "Advanced combat prediction algorithms enhance melee capabilities."
	skill_changes = list(/datum/attribute/skill/combat/wrestling = 20, /datum/attribute/skill/combat/unarmed = 20)
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 15 SECONDS
	stability_cost = -10

/datum/augment/skill/blade_processor
	name = "blade trajectory processor"
	desc = "Calculates optimal cutting angles and improves sword technique."
	skill_changes = list(/datum/attribute/skill/combat/swords = 20)
	engineering_difficulty = SKILL_RANK_EXPERT
	installation_time = 18 SECONDS
	stability_cost = -10

/datum/augment/skill/whip_servo
	name = "whip articulation servo"
	desc = "Precise joint control improves whip and flail technique."
	skill_changes = list(/datum/attribute/skill/combat/whipsflails = 20)
	engineering_difficulty = SKILL_RANK_EXPERT
	installation_time = 18 SECONDS
	stability_cost = -10

/datum/augment/skill/polearm_stabilizer
	name = "polearm stability enhancer"
	desc = "Balance optimization for polearm combat."
	skill_changes = list(/datum/attribute/skill/combat/polearms = 20)
	engineering_difficulty = SKILL_RANK_EXPERT
	installation_time = 18 SECONDS
	stability_cost = -10

/datum/augment/skill/shield_actuator
	name = "shield response actuator"
	desc = "Rapid reaction systems for improved shield defense."
	skill_changes = list(/datum/attribute/skill/combat/shields = 20)
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 15 SECONDS
	stability_cost = -10

/datum/augment/skill/crossbow_targeting
	name = "crossbow targeting system"
	desc = "Integrated rangefinding and trajectory calculation."
	skill_changes = list(/datum/attribute/skill/combat/crossbows = 20)
	engineering_difficulty = SKILL_RANK_EXPERT
	installation_time = 20 SECONDS
	stability_cost = -10

/datum/augment/skill/bow_stabilizer
	name = "bow draw stabilizer"
	desc = "Stabilizes draw and release for improved archery."
	skill_changes = list(/datum/attribute/skill/combat/bows = 20)
	engineering_difficulty = SKILL_RANK_EXPERT
	installation_time = 20 SECONDS
	stability_cost = -10

/datum/augment/skill/cooking_guide
	name = "culinary guide"
	desc = "Adds a culinary reference to allow more advanced cooking capabilities."
	skill_changes = list(/datum/attribute/skill/craft/cooking = 20)
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 15 SECONDS
	stability_cost = -5

/datum/augment/skill/smithing_optimizer
	name = "smithing precision optimizer"
	desc = "Enhances hammer control and metal working precision."
	skill_changes = list(/datum/attribute/skill/craft/blacksmithing = 20, /datum/attribute/skill/craft/smelting = 20)
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 15 SECONDS
	stability_cost = -5

/datum/augment/skill/weaponcraft_matrix
	name = "weapon fabrication matrix"
	desc = "Advanced weapon construction knowledge database."
	skill_changes = list(/datum/attribute/skill/craft/weaponsmithing = 20)
	engineering_difficulty = SKILL_RANK_EXPERT
	installation_time = 18 SECONDS
	stability_cost = -5

/datum/augment/skill/armorcraft_matrix
	name = "armor fabrication matrix"
	desc = "Armor construction optimization routines."
	skill_changes = list(/datum/attribute/skill/craft/armorsmithing = 20)
	engineering_difficulty = SKILL_RANK_EXPERT
	installation_time = 18 SECONDS
	stability_cost = -5

/datum/augment/skill/carpentry_guide
	name = "carpentry guidance system"
	desc = "Woodworking pattern recognition and optimization."
	skill_changes = list(/datum/attribute/skill/craft/carpentry = 20)
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 15 SECONDS
	stability_cost = -5

/datum/augment/skill/masonry_analyzer
	name = "masonry structural analyzer"
	desc = "Stone cutting and placement optimization."
	skill_changes = list(/datum/attribute/skill/craft/masonry = 20)
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 15 SECONDS
	stability_cost = -5

/datum/augment/skill/engineering_core
	name = "advanced engineering core"
	desc = "Complex mechanical systems comprehension module."
	skill_changes = list(/datum/attribute/skill/craft/engineering = 20)
	engineering_difficulty = SKILL_RANK_MASTER
	installation_time = 25 SECONDS
	stability_cost = -5

/datum/augment/skill/alchemy_database
	name = "alchemical database"
	desc = "Stored formulas and reagent interaction data."
	skill_changes = list(/datum/attribute/skill/craft/alchemy = 20)
	engineering_difficulty = SKILL_RANK_EXPERT
	installation_time = 20 SECONDS
	stability_cost = -5

// Skill augments - Labor skills
/datum/augment/skill/mining_efficiency
	name = "mining efficiency module"
	desc = "Ore vein detection and optimal extraction patterns."
	skill_changes = list(/datum/attribute/skill/labor/mining = 20)
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 15 SECONDS
	stability_cost = -5

/datum/augment/skill/farming_analyzer
	name = "agricultural analysis system"
	desc = "Soil composition and crop health monitoring."
	skill_changes = list(/datum/attribute/skill/labor/farming = 20)
	engineering_difficulty = SKILL_RANK_APPRENTICE
	installation_time = 12 SECONDS
	stability_cost = -5

/datum/augment/skill/butchering_guide
	name = "butchering precision guide"
	desc = "Anatomical mapping for optimal material extraction."
	skill_changes = list(/datum/attribute/skill/labor/butchering = 20)
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 15 SECONDS
	stability_cost = -5

/datum/augment/skill/lumberjack_optimizer
	name = "lumber harvesting optimizer"
	desc = "Tree structural analysis and efficient cutting patterns."
	skill_changes = list(/datum/attribute/skill/labor/lumberjacking = 20)
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 15 SECONDS
	stability_cost = -5

/datum/augment/skill/medicine_database
	name = "medical knowledge database"
	desc = "Extensive anatomical and medical procedure library."
	skill_changes = list(/datum/attribute/skill/misc/medicine = 20)
	engineering_difficulty = SKILL_RANK_EXPERT
	installation_time = 20 SECONDS
	stability_cost = -5

/datum/augment/skill/lockpick_analyzer
	name = "lock mechanism analyzer"
	desc = "Advanced tumbler pattern recognition."
	skill_changes = list(/datum/attribute/skill/misc/lockpicking = 20)
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 15 SECONDS
	stability_cost = -5

/datum/augment/skill/climbing_optimizer
	name = "climbing optimization module"
	desc = "Grip strength distribution and path finding."
	skill_changes = list(/datum/attribute/skill/misc/climbing = 20)
	engineering_difficulty = SKILL_RANK_APPRENTICE
	installation_time = 12 SECONDS
	stability_cost = -5

/datum/augment/skill/stealth_dampener
	name = "acoustic dampening system"
	desc = "Noise reduction and movement pattern optimization."
	skill_changes = list(/datum/attribute/skill/misc/sneaking = 20)
	engineering_difficulty = SKILL_RANK_EXPERT
	installation_time = 18 SECONDS
	stability_cost = -5
