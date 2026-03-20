/obj/item/augment_kit
	name = "augmentation kit"
	desc = "A kit containing components for automaton augmentation. Examine to see details."
	icon = 'icons/roguetown/items/new_gears.dmi'
	icon_state = "steel_gear"
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32
	var/datum/augment/contained_augment

/obj/item/augment_kit/Initialize()
	. = ..()
	if(contained_augment)
		contained_augment = new contained_augment()
		name = "[contained_augment.name] kit"
		desc = "[contained_augment.desc]\n\nStability Cost: [contained_augment.stability_cost]\nRequired Skill: Engineering [contained_augment.engineering_difficulty]"

/obj/item/augment_kit/examine(mob/user)
	. = ..()
	if(contained_augment)
		. += span_info("This kit contains: [contained_augment.name]")
		. += span_info("Installation requires Engineering skill level [contained_augment.engineering_difficulty]")
		. += contained_augment.get_examine_info()

/obj/item/augment_kit/strength_servo
	contained_augment = /datum/augment/stats/strength_servo

/obj/item/augment_kit/perception_lens
	contained_augment = /datum/augment/stats/perception_lens

/obj/item/augment_kit/processing_core
	contained_augment = /datum/augment/stats/processing_core

/obj/item/augment_kit/reinforced_frame
	contained_augment = /datum/augment/stats/reinforced_frame

/obj/item/augment_kit/power_limiter
	contained_augment = /datum/augment/stats/power_limiter

/obj/item/augment_kit/core_stabilizer
	contained_augment = /datum/augment/stats/core_stabilizer

/obj/item/augment_kit/combat_matrix
	contained_augment = /datum/augment/skill/combat_matrix

/obj/item/augment_kit/smithing_optimizer
	contained_augment = /datum/augment/skill/smithing_optimizer

/obj/item/augment_kit/weaponcraft_matrix
	contained_augment = /datum/augment/skill/weaponcraft_matrix

/obj/item/augment_kit/engineering_core
	contained_augment = /datum/augment/skill/engineering_core

/obj/item/augment_kit/mining_efficiency
	contained_augment = /datum/augment/skill/mining_efficiency

/obj/item/augment_kit/farming_analyzer
	contained_augment = /datum/augment/skill/farming_analyzer

/obj/item/augment_kit/medicine_database
	contained_augment = /datum/augment/skill/medicine_database

/obj/item/augment_kit/lockpick_analyzer
	contained_augment = /datum/augment/skill/lockpick_analyzer

/obj/item/augment_kit/stealth_dampener
	contained_augment = /datum/augment/skill/stealth_dampener

/obj/item/augment_kit/dualwield
	contained_augment = /datum/augment/special/dualwield

/obj/item/augment_kit/dualwield_refurbished
	contained_augment = /datum/augment/special/dualwield/refurbished

/obj/item/augment_kit/sandevistan
	contained_augment = /datum/augment/special/sandevistan

/obj/item/augment_kit/sandevistan_refurbished
	contained_augment = /datum/augment/special/sandevistan/refurbished
