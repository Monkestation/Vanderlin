/datum/augment/skill
	var/list/skill_changes = list() // List of skill changes: list(/datum/skill/combat/swords = 1)
	stability_cost = 0 // Skills are zero-cost by default

/datum/augment/skill/on_install(mob/living/carbon/human/H)
	for(var/skill_type in skill_changes)
		var/change = skill_changes[skill_type]
		H.adjust_skillrank(skill_type, change, TRUE)

/datum/augment/skill/on_remove(mob/living/carbon/human/H)
	for(var/skill_type in skill_changes)
		var/change = skill_changes[skill_type]
		H.adjust_skillrank(skill_type, -change, TRUE)

/datum/augment/skill/get_examine_info()
	var/list/info = list()
	info += span_info("Skill changes:")
	for(var/skill_type in skill_changes)
		var/datum/skill/S = skill_type
		var/change = skill_changes[skill_type]
		info += span_info("  [initial(S.name)]: [change > 0 ? "+" : ""][change]")
	return info

/datum/augment/skill/combat_matrix
	name = "combat analysis matrix"
	desc = "Advanced combat prediction algorithms enhance melee capabilities."
	skill_changes = list(/datum/skill/combat/wrestling = 1, /datum/skill/combat/unarmed = 1)
	engineering_difficulty = SKILL_LEVEL_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/skill/blade_processor
	name = "blade trajectory processor"
	desc = "Calculates optimal cutting angles and improves sword technique."
	skill_changes = list(/datum/skill/combat/swords = 2)
	engineering_difficulty = SKILL_LEVEL_EXPERT
	installation_time = 18 SECONDS

/datum/augment/skill/whip_servo
	name = "whip articulation servo"
	desc = "Precise joint control improves whip and flail technique."
	skill_changes = list(/datum/skill/combat/whipsflails = 2)
	engineering_difficulty = SKILL_LEVEL_EXPERT
	installation_time = 18 SECONDS

/datum/augment/skill/polearm_stabilizer
	name = "polearm stability enhancer"
	desc = "Balance optimization for polearm combat."
	skill_changes = list(/datum/skill/combat/polearms = 2)
	engineering_difficulty = SKILL_LEVEL_EXPERT
	installation_time = 18 SECONDS

/datum/augment/skill/shield_actuator
	name = "shield response actuator"
	desc = "Rapid reaction systems for improved shield defense."
	skill_changes = list(/datum/skill/combat/shields = 2)
	engineering_difficulty = SKILL_LEVEL_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/skill/crossbow_targeting
	name = "crossbow targeting system"
	desc = "Integrated rangefinding and trajectory calculation."
	skill_changes = list(/datum/skill/combat/crossbows = 2)
	engineering_difficulty = SKILL_LEVEL_EXPERT
	installation_time = 20 SECONDS

/datum/augment/skill/bow_stabilizer
	name = "bow draw stabilizer"
	desc = "Stabilizes draw and release for improved archery."
	skill_changes = list(/datum/skill/combat/bows = 2)
	engineering_difficulty = SKILL_LEVEL_EXPERT
	installation_time = 20 SECONDS

/datum/augment/skill/smithing_optimizer
	name = "smithing precision optimizer"
	desc = "Enhances hammer control and metal working precision."
	skill_changes = list(/datum/skill/craft/blacksmithing = 1, /datum/skill/craft/smelting = 1)
	engineering_difficulty = SKILL_LEVEL_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/skill/weaponcraft_matrix
	name = "weapon fabrication matrix"
	desc = "Advanced weapon construction knowledge database."
	skill_changes = list(/datum/skill/craft/weaponsmithing = 2)
	engineering_difficulty = SKILL_LEVEL_EXPERT
	installation_time = 18 SECONDS

/datum/augment/skill/armorcraft_matrix
	name = "armor fabrication matrix"
	desc = "Armor construction optimization routines."
	skill_changes = list(/datum/skill/craft/armorsmithing = 2)
	engineering_difficulty = SKILL_LEVEL_EXPERT
	installation_time = 18 SECONDS

/datum/augment/skill/carpentry_guide
	name = "carpentry guidance system"
	desc = "Woodworking pattern recognition and optimization."
	skill_changes = list(/datum/skill/craft/carpentry = 2)
	engineering_difficulty = SKILL_LEVEL_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/skill/masonry_analyzer
	name = "masonry structural analyzer"
	desc = "Stone cutting and placement optimization."
	skill_changes = list(/datum/skill/craft/masonry = 2)
	engineering_difficulty = SKILL_LEVEL_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/skill/engineering_core
	name = "advanced engineering core"
	desc = "Complex mechanical systems comprehension module."
	skill_changes = list(/datum/skill/craft/engineering = 2)
	engineering_difficulty = SKILL_LEVEL_MASTER
	installation_time = 25 SECONDS

/datum/augment/skill/alchemy_database
	name = "alchemical database"
	desc = "Stored formulas and reagent interaction data."
	skill_changes = list(/datum/skill/craft/alchemy = 2)
	engineering_difficulty = SKILL_LEVEL_EXPERT
	installation_time = 20 SECONDS

// Skill augments - Labor skills
/datum/augment/skill/mining_efficiency
	name = "mining efficiency module"
	desc = "Ore vein detection and optimal extraction patterns."
	skill_changes = list(/datum/skill/labor/mining = 2)
	engineering_difficulty = SKILL_LEVEL_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/skill/farming_analyzer
	name = "agricultural analysis system"
	desc = "Soil composition and crop health monitoring."
	skill_changes = list(/datum/skill/labor/farming = 2)
	engineering_difficulty = SKILL_LEVEL_APPRENTICE
	installation_time = 12 SECONDS

/datum/augment/skill/butchering_guide
	name = "butchering precision guide"
	desc = "Anatomical mapping for optimal material extraction."
	skill_changes = list(/datum/skill/labor/butchering = 2)
	engineering_difficulty = SKILL_LEVEL_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/skill/lumberjack_optimizer
	name = "lumber harvesting optimizer"
	desc = "Tree structural analysis and efficient cutting patterns."
	skill_changes = list(/datum/skill/labor/lumberjacking = 2)
	engineering_difficulty = SKILL_LEVEL_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/skill/medicine_database
	name = "medical knowledge database"
	desc = "Extensive anatomical and medical procedure library."
	skill_changes = list(/datum/skill/misc/medicine = 2)
	engineering_difficulty = SKILL_LEVEL_EXPERT
	installation_time = 20 SECONDS

/datum/augment/skill/lockpick_analyzer
	name = "lock mechanism analyzer"
	desc = "Advanced tumbler pattern recognition."
	skill_changes = list(/datum/skill/misc/lockpicking = 2)
	engineering_difficulty = SKILL_LEVEL_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/skill/climbing_optimizer
	name = "climbing optimization module"
	desc = "Grip strength distribution and path finding."
	skill_changes = list(/datum/skill/misc/climbing = 2)
	engineering_difficulty = SKILL_LEVEL_APPRENTICE
	installation_time = 12 SECONDS

/datum/augment/skill/stealth_dampener
	name = "acoustic dampening system"
	desc = "Noise reduction and movement pattern optimization."
	skill_changes = list(/datum/skill/misc/sneaking = 2)
	engineering_difficulty = SKILL_LEVEL_EXPERT
	installation_time = 18 SECONDS
