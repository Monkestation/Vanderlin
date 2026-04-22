/datum/artificer_recipe/augment_kit
	name = "Basic Augment Kit"
	category = "Automaton Augments"
	i_type = "Automaton Augments"
	created_item = /obj/item/augment_kit
	required_item = /obj/item/ingot/steel
	hammers_per_item = 10
	craftdiff = 1

/datum/artificer_recipe/augments
	abstract_type = /datum/artificer_recipe/augments
	category = "Automaton Augments"
	i_type = "Automaton Augments"
	created_item = /obj/item/augment_kit
	required_item = /obj/item/augment_kit
	hammers_per_item = 25
	var/datum/augment/created_augment

/datum/artificer_recipe/augments/New()
	. = ..()
	if(ispath(created_augment, /datum/augment))
		craftdiff = created_augment::engineering_difficulty

/datum/artificer_recipe/augments/item_created(obj/item/augment_kit/kit)
	if(!ispath(created_augment, /datum/augment))
		return
	kit.contained_augment = new created_augment()
	kit.update_augment()


/* 	.....STATS..... */
/datum/artificer_recipe/augments/strength_servo
	name = "Hydraulic Strength Servo"
	created_augment = /datum/augment/stats/strength_servo
	additional_items = list(/obj/item/gear/metal/steel)

/datum/artificer_recipe/augments/perception_lens
	name = "Enhanced Optical Array"
	created_augment = /datum/augment/stats/perception_lens
	additional_items = list(/obj/item/natural/glass)

/datum/artificer_recipe/augments/processing_core
	name = "Overclocked Logic Engine"
	created_augment = /datum/augment/stats/processing_core
	additional_items = list(/obj/item/mana_battery/mana_crystal/standard)

/datum/artificer_recipe/augments/processing_core
	name = "Suspension Rig"
	created_augment = /datum/augment/stats/suspension_rig
	additional_items = list(/obj/item/ingot/steel)

/datum/artificer_recipe/augments/pressure_tank
	name = "Extended Capacity Pressure Tank"
	created_augment = /datum/augment/stats/pressure_tank
	additional_items = list(/obj/item/ingot/bronze)

/datum/artificer_recipe/augments/mobility_actuator
	name = "High-Efficiency Actuators"
	created_augment = /datum/augment/stats/mobility_actuator
	additional_items = list(/obj/item/gear/metal/bronze)

/datum/artificer_recipe/augments/sensor_dampener
	name = "Sensor Dampener"
	created_augment = /datum/augment/stats/sensor_dampener
	additional_items = list(/obj/item/ingot/copper)

/datum/artificer_recipe/augments/power_limiter
	name = "Power Limiter"
	created_augment = /datum/augment/stats/power_limiter
	additional_items = list(/obj/item/ingot/copper)

/datum/artificer_recipe/augments/lightweight_frame
	name = "Lightweight Chassis"
	created_augment = /datum/augment/stats/lightweight_frame
	additional_items = list(/obj/item/ingot/tin)

/datum/artificer_recipe/augments/efficiency_mode
	name = "Power Conservation Mode"
	created_augment = /datum/augment/stats/efficiency_mode
	additional_items = list(/obj/item/ingot/iron)

/datum/artificer_recipe/augments/servo_governor
	name = "Movement Limiter"
	created_augment = /datum/augment/stats/servo_governor
	additional_items = list(/obj/item/gear/wood)

/datum/artificer_recipe/augments/balanced_matrix
	name = "Stabilizing Matrix"
	created_augment = /datum/augment/stats/balanced_matrix
	additional_items = list(/obj/item/ingot/silver)

/datum/artificer_recipe/augments/balanced_matrix
	name = "Core Stabilizer"
	created_augment = /datum/augment/stats/core_stabilizer
	additional_items = list(/obj/item/ingot/thaumic)

/* 	.....SKILLS..... */

/datum/artificer_recipe/augments/combat_matrix
	name = "Combat Analysis Matrix"
	created_augment = /datum/augment/skill/combat_matrix
	additional_items = list(/obj/item/ingot/silver)

/datum/artificer_recipe/augments/blade_processor
	name = "Blade Trajectory Processor"
	created_augment = /datum/augment/skill/blade_processor
	additional_items = list(/obj/item/ingot/silver)

/datum/artificer_recipe/augments/whip_servo
	name = "Whip Articulation Servo"
	created_augment = /datum/augment/skill/whip_servo
	additional_items = list(/obj/item/ingot/silver)

/datum/artificer_recipe/augments/polearm_stabilizer
	name = "Polearm Stability Enhancer"
	created_augment = /datum/augment/skill/polearm_stabilizer
	additional_items = list(/obj/item/ingot/silver)

/datum/artificer_recipe/augments/shield_actuator
	name = "Shield Response Actuator"
	created_augment = /datum/augment/skill/shield_actuator
	additional_items = list(/obj/item/ingot/silver)

/datum/artificer_recipe/augments/crossbow_targeting
	name = "Crossbow Targeting System"
	created_augment = /datum/augment/skill/crossbow_targeting
	additional_items = list(/obj/item/ingot/silver)

/datum/artificer_recipe/augments/bow_stabilizer
	name = "Bow Draw Stabilizer"
	created_augment = /datum/augment/skill/bow_stabilizer
	additional_items = list(/obj/item/ingot/silver)

/datum/artificer_recipe/augments/cooking_guide
	name = "Culinary Guide"
	created_augment = /datum/augment/skill/cooking_guide
	additional_items = list(/obj/item/ingot/bronze)

/datum/artificer_recipe/augments/smithing_optimizer
	name = "Smithing Precision Optimizer"
	created_augment = /datum/augment/skill/smithing_optimizer
	additional_items = list(/obj/item/ingot/iron)

/datum/artificer_recipe/augments/weaponcraft_matrix
	name = "Weapon Fabrication Matrix"
	created_augment = /datum/augment/skill/weaponcraft_matrix
	additional_items = list(/obj/item/ingot/iron)

/datum/artificer_recipe/augments/armorcraft_matrix
	name = "Armor Fabrication Matrix"
	created_augment = /datum/augment/skill/armorcraft_matrix
	additional_items = list(/obj/item/ingot/iron)

/datum/artificer_recipe/augments/carpentry_guide
	name = "Carpentry Guidance System"
	created_augment = /datum/augment/skill/carpentry_guide
	additional_items = list(/obj/item/ingot/iron)

/datum/artificer_recipe/augments/masonry_analyzer
	name = "Masonry Structural Analyzer"
	created_augment = /datum/augment/skill/masonry_analyzer
	additional_items = list(/obj/item/ingot/iron)

/datum/artificer_recipe/augments/engineering_core
	name = "Advanced Engineering Core"
	created_augment = /datum/augment/skill/engineering_core
	additional_items = list(/obj/item/ingot/gold)

/datum/artificer_recipe/augments/alchemy_database
	name = "Alchemical Database"
	created_augment = /datum/augment/skill/alchemy_database
	additional_items = list(/obj/item/ingot/bronze)

// Skill augments - Labor skills
/datum/artificer_recipe/augments/mining_efficiency
	name = "Mining Efficiency Module"
	created_augment = /datum/augment/skill/mining_efficiency
	additional_items = list(/obj/item/ingot/bronze)

/datum/artificer_recipe/augments/farming_analyzer
	name = "Agricultural Analysis System"
	created_augment = /datum/augment/skill/farming_analyzer
	additional_items = list(/obj/item/ingot/bronze)

/datum/artificer_recipe/augments/butchering_guide
	name = "Butchering Precision Guide"
	created_augment = /datum/augment/skill/butchering_guide
	additional_items = list(/obj/item/ingot/bronze)

/datum/artificer_recipe/augments/lumberjack_optimizer
	name = "Lumber Harvesting Optimizer"
	created_augment = /datum/augment/skill/lumberjack_optimizer
	additional_items = list(/obj/item/ingot/bronze)

/datum/artificer_recipe/augments/medicine_database
	name = "Medical Knowledge Database"
	created_augment = /datum/augment/skill/medicine_database
	additional_items = list(/obj/item/ingot/bronze)

/datum/artificer_recipe/augments/lockpick_analyzer
	name = "Lock Mechanism Analyzer"
	created_augment = /datum/augment/skill/lockpick_analyzer
	additional_items = list(/obj/item/ingot/bronze)

/datum/artificer_recipe/augments/climbing_optimizer
	name = "Climbing Optimization Module"
	created_augment = /datum/augment/skill/climbing_optimizer
	additional_items = list(/obj/item/ingot/bronze)

/datum/artificer_recipe/augments/stealth_dampener
	name = "Acoustic Dampening System"
	created_augment = /datum/augment/skill/stealth_dampener
	additional_items = list(/obj/item/ingot/bronze)

/* 	.....SPECIAL..... */

/datum/artificer_recipe/augments/sandevistan
	name = "CHRONOS Unit"
	created_augment = /datum/augment/special/sandevistan
	additional_items = list(/obj/item/hourglass/temporal, /obj/item/organ/eyes)

/datum/artificer_recipe/augments/dualwield
	name = "Marauder Unit"
	created_augment = /datum/augment/special/dualwield
	additional_items = list(/obj/item/organ/heart, /obj/item/reagent_containers/powder/ozium, /obj/item/reagent_containers/powder/moondust_purest)

/* 	.....MISC..... */

/datum/artificer_recipe/augments/loyalty_binder
	name = "Shackle"
	created_augment = /datum/augment/loyalty_binder
	additional_items = list(/obj/item/ingot/tin)

/datum/artificer_recipe/augments/music_box
	name = "Music Box"
	created_augment = /datum/augment/music_player
	additional_items = list(/obj/item/dmusicbox)

/datum/artificer_recipe/augments/darkvision
	name = "Darkvision"
	created_augment = /datum/augment/darkvision
	additional_items = list(/obj/item/gem/yellow)

/datum/artificer_recipe/augments/heatvision
	name = "Heat Vision"
	created_augment = /datum/augment/heatvision
	additional_items = list(/obj/item/gem/red)


/* 	.....ARMOR..... */

/datum/artificer_recipe/augments/armor_tin
	name = "Tin Plating"
	created_augment = /datum/augment/armor/tin
	additional_items = list(/obj/item/ingot/tin = 4)

/datum/artificer_recipe/augments/armor_copper
	name = "Copper Plating"
	created_augment = /datum/augment/armor/copper
	additional_items = list(/obj/item/ingot/copper = 4)

/datum/artificer_recipe/augments/armor_bronze
	name = "Bronze Plating"
	created_augment = /datum/augment/armor/bronze
	additional_items = list(/obj/item/ingot/bronze = 4)

/datum/artificer_recipe/augments/armor_iron
	name = "Iron Plating"
	created_augment = /datum/augment/armor/iron
	additional_items = list(/obj/item/ingot/iron = 4)

/datum/artificer_recipe/augments/armor_steel
	name = "Steel Plating"
	created_augment = /datum/augment/armor/steel
	additional_items = list(/obj/item/ingot/steel = 4)

/datum/artificer_recipe/augments/armor_gold
	name = "Gold Plating"
	created_augment = /datum/augment/armor/gold
	additional_items = list(/obj/item/ingot/gold = 4)

/datum/artificer_recipe/augments/armor_silver
	name = "Silver Plating"
	created_augment = /datum/augment/armor/silver
	additional_items = list(/obj/item/ingot/silver = 4)

/datum/artificer_recipe/augments/armor_blacksteel
	name = "Blacksteel Plating"
	created_augment = /datum/augment/armor/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel = 6)
