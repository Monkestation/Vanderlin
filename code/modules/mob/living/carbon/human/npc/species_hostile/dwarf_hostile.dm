/mob/living/carbon/human/species/dwarf/mountain/base
	ai_controller = /datum/ai_controller/species_hostile
	faction = list(FACTION_HOSTILE)
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	canparry = TRUE
	candodge = TRUE
	wander = FALSE
	d_intent = INTENT_PARRY

/mob/living/carbon/human/species/dwarf/mountain/base/Initialize()
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	set_species(/datum/species/dwarf/mountain)
	AddComponent(/datum/component/ai_aggro_system)
	set_patron(/datum/patron/inhumen/graggar, TRUE)
	job = "Graggarite Dwarf"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 0
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

// --- Base Variants ---

/mob/living/carbon/human/species/dwarf/mountain/base/very_skilled
	dodgetime = 30
	flee_in_pain = FALSE

/mob/living/carbon/human/species/dwarf/mountain/base/very_skilled/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)

/mob/living/carbon/human/species/dwarf/mountain/base/skilled
	dodgetime = 40
	flee_in_pain = FALSE

/mob/living/carbon/human/species/dwarf/mountain/base/unskilled
	dodgetime = 60

/mob/living/carbon/human/species/dwarf/mountain/base/unskilled/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

// --- Naked ---

/datum/attribute_holder/sheet/job/dwarf_naked/unskilled
	raw_attribute_list = list(
		STAT_STRENGTH = -2,
		STAT_SPEED = 4,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_FORTUNE = -1,
		/datum/attribute/skill/combat/polearms = 10,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/combat/axesmaces = 10,
		/datum/attribute/skill/combat/whipsflails = 10,
		/datum/attribute/skill/combat/shields = 10,
	)

/mob/living/carbon/human/species/dwarf/mountain/base/unskilled/naked
	attribute_sheet = /datum/attribute_holder/sheet/job/dwarf_naked/unskilled

/mob/living/carbon/human/species/dwarf/mountain/base/unskilled/naked/after_creation()
	..()

	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

/datum/attribute_holder/sheet/job/dwarf_naked/skilled
	raw_attribute_list = list(
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/shields = 30,
	)

/mob/living/carbon/human/species/dwarf/mountain/base/skilled/naked
	base_strength = 10
	base_speed = 14
	base_constitution = 12
	base_endurance = 12
	base_fortune = 9
	attribute_sheet = /datum/attribute_holder/sheet/job/dwarf_naked/skilled

/mob/living/carbon/human/species/dwarf/mountain/base/skilled/naked/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

/datum/attribute_holder/sheet/job/dwarf_naked/very_skilled
	raw_attribute_list = list(
		/datum/attribute/skill/combat/polearms = 50,
		/datum/attribute/skill/combat/swords = 50,
		/datum/attribute/skill/combat/wrestling = 50,
		/datum/attribute/skill/combat/unarmed = 50,
		/datum/attribute/skill/combat/knives = 50,
		/datum/attribute/skill/misc/athletics = 50,
		/datum/attribute/skill/combat/axesmaces = 50,
		/datum/attribute/skill/combat/whipsflails = 50,
		/datum/attribute/skill/combat/shields = 50,
	)

/mob/living/carbon/human/species/dwarf/mountain/base/very_skilled/naked
	base_strength = 13
	base_speed = 14
	base_perception = 12
	base_constitution = 10
	base_endurance = 10
	base_fortune = 10
	attribute_sheet = /datum/attribute_holder/sheet/job/dwarf_naked/very_skilled

/mob/living/carbon/human/species/dwarf/mountain/base/very_skilled/naked/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

// --- Light Gear ----

/datum/attribute_holder/sheet/job/dwarf_light_gear/unskilled
	raw_attribute_list = list(
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/combat/wrestling = 10,
	)
	attribute_variance = list(
		/datum/attribute/skill/combat/swords = list(10, 20),
		/datum/attribute/skill/combat/knives = list(10, 20)
	)

/mob/living/carbon/human/species/dwarf/mountain/base/unskilled/light_gear
	base_strength = 10
	base_speed = 12
	base_perception = 12
	base_constitution = 10
	base_endurance = 10
	base_fortune = 9
	dodgetime = 40
	attribute_sheet = /datum/attribute_holder/sheet/job/dwarf_light_gear/unskilled

/mob/living/carbon/human/species/dwarf/mountain/base/unskilled/light_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 1
	equipOutfit(new /datum/outfit/npc/light_gear)

/datum/attribute_holder/sheet/job/dwarf_light_gear/skilled
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/combat/wrestling = 20,
	)

/mob/living/carbon/human/species/dwarf/mountain/base/skilled/light_gear
	base_strength = 10
	base_speed = 13
	base_perception = 14
	base_constitution = 10
	base_endurance = 10
	base_fortune = 9
	dodgetime = 20
	attribute_sheet = /datum/attribute_holder/sheet/job/dwarf_light_gear/skilled

/mob/living/carbon/human/species/dwarf/mountain/base/skilled/light_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIGHT_STEP, TRAIT_GENERIC)

	ai_controller?.blackboard[BB_ARMOR_CLASS] = 1
	equipOutfit(new /datum/outfit/npc/light_gear)

/datum/attribute_holder/sheet/job/dwarf_light_gear/very_skilled
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 50,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/knives = 50,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/wrestling = 40,
	)

/mob/living/carbon/human/species/dwarf/mountain/base/very_skilled/light_gear
	base_strength = 11
	base_speed = 14
	base_perception = 15
	base_constitution = 10
	base_endurance = 10
	base_fortune = 10
	dodgetime = 10
	attribute_sheet = /datum/attribute_holder/sheet/job/dwarf_light_gear/very_skilled

/mob/living/carbon/human/species/dwarf/mountain/base/very_skilled/light_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIGHT_STEP, TRAIT_GENERIC)

	ai_controller?.blackboard[BB_ARMOR_CLASS] = 1
	equipOutfit(new /datum/outfit/npc/light_gear)

// --- Medium Gear ----

/datum/attribute_holder/sheet/job/dwarf_medium_gear/unskilled
	raw_attribute_list = list(
		/datum/attribute/skill/combat/shields = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/combat/wrestling = 10,
	)
	attribute_variance = list(
		/datum/attribute/skill/combat/swords = list(10, 20),
		/datum/attribute/skill/combat/axesmaces = list(10, 20),
		/datum/attribute/skill/combat/whipsflails = list(10, 20),
		/datum/attribute/skill/combat/polearms = list(10, 20),
	)

/mob/living/carbon/human/species/dwarf/mountain/base/unskilled/medium_gear
	base_strength = 11
	base_speed = 10
	base_perception = 9
	base_constitution = 12
	base_endurance = 12
	base_fortune = 9
	attribute_sheet = /datum/attribute_holder/sheet/job/dwarf_medium_gear/unskilled


/mob/living/carbon/human/species/dwarf/mountain/base/unskilled/medium_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	ai_controller?.blackboard[BB_ARMOR_CLASS] = 2
	equipOutfit(new /datum/outfit/npc/medium_gear)

/datum/attribute_holder/sheet/job/dwarf_medium_gear/skilled
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/combat/wrestling = 20,
	)

/mob/living/carbon/human/species/dwarf/mountain/base/skilled/medium_gear
	base_strength = 13
	base_speed = 11
	base_perception = 10
	base_constitution = 13
	base_endurance = 13
	base_fortune = 9
	attribute_sheet = /datum/attribute_holder/sheet/job/dwarf_medium_gear/skilled

/mob/living/carbon/human/species/dwarf/mountain/base/skilled/medium_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 2
	equipOutfit(new /datum/outfit/npc/medium_gear)

/datum/attribute_holder/sheet/job/dwarf_medium_gear/very_skilled
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 50,
		/datum/attribute/skill/combat/axesmaces = 50,
		/datum/attribute/skill/combat/whipsflails = 50,
		/datum/attribute/skill/combat/polearms = 50,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/wrestling = 40,
	)

/mob/living/carbon/human/species/dwarf/mountain/base/very_skilled/medium_gear
	base_strength = 15
	base_speed = 12
	base_perception = 11
	base_constitution = 14
	base_endurance = 14
	base_fortune = 10
	attribute_sheet = /datum/attribute_holder/sheet/job/dwarf_medium_gear/very_skilled

/mob/living/carbon/human/species/dwarf/mountain/base/very_skilled/medium_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 2
	equipOutfit(new /datum/outfit/npc/medium_gear)


// --- Heavy Gear ----

/datum/attribute_holder/sheet/job/dwarf_heavy_gear/unskilled
	raw_attribute_list = list(
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/combat/wrestling = 10,
	)
	attribute_variance = list(
		/datum/attribute/skill/combat/swords = list(10, 20),
		/datum/attribute/skill/combat/axesmaces = list(10, 20),
		/datum/attribute/skill/combat/whipsflails = list(10, 20),
		/datum/attribute/skill/combat/polearms = list(10, 20),
		/datum/attribute/skill/combat/shields = list(10, 20),
	)


/mob/living/carbon/human/species/dwarf/mountain/base/unskilled/heavy_gear
	base_strength = 11
	base_speed = 8
	base_perception = 8
	base_constitution = 12
	base_endurance = 12
	base_fortune = 9
	attribute_sheet = /datum/attribute_holder/sheet/job/dwarf_heavy_gear/unskilled

/mob/living/carbon/human/species/dwarf/mountain/base/unskilled/heavy_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 3
	equipOutfit(new /datum/outfit/npc/heavy_gear)

/datum/attribute_holder/sheet/job/dwarf_heavy_gear/skilled
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/combat/wrestling = 20,
	)

/mob/living/carbon/human/species/dwarf/mountain/base/skilled/heavy_gear
	base_strength = 13
	base_speed = 9
	base_perception = 9
	base_constitution = 14
	base_endurance = 14
	base_fortune = 9
	attribute_sheet = /datum/attribute_holder/sheet/job/dwarf_heavy_gear/skilled

/mob/living/carbon/human/species/dwarf/mountain/base/skilled/heavy_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 3
	equipOutfit(new /datum/outfit/npc/heavy_gear)

/datum/attribute_holder/sheet/job/dwarf_heavy_gear/very_skilled
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 50,
		/datum/attribute/skill/combat/axesmaces = 50,
		/datum/attribute/skill/combat/whipsflails = 50,
		/datum/attribute/skill/combat/polearms = 50,
		/datum/attribute/skill/combat/shields = 50,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/wrestling = 40,
	)

/mob/living/carbon/human/species/dwarf/mountain/base/very_skilled/heavy_gear
	base_strength = 15
	base_speed = 8
	base_perception = 11
	base_constitution = 16
	base_endurance = 16
	base_fortune = 10
	attribute_sheet = /datum/attribute_holder/sheet/job/dwarf_heavy_gear/very_skilled

/mob/living/carbon/human/species/dwarf/mountain/base/very_skilled/heavy_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 3
	equipOutfit(new /datum/outfit/npc/heavy_gear)
