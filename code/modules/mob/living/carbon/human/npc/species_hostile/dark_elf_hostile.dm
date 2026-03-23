/mob/living/carbon/human/species/elf/dark/base
	ai_controller = /datum/ai_controller/species_hostile
	faction = list(FACTION_HOSTILE)
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	canparry = TRUE
	candodge = TRUE
	wander = FALSE
	d_intent = INTENT_PARRY

/mob/living/carbon/human/species/elf/dark/base/Initialize()
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	set_species(/datum/species/elf/dark)
	AddComponent(/datum/component/ai_aggro_system)
	set_patron(/datum/patron/inhumen/graggar, TRUE)
	job = "Graggarite Dark Elf"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 0
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

// --- Base Variants ---

/mob/living/carbon/human/species/elf/dark/base/very_skilled
	dodgetime = 30
	flee_in_pain = FALSE

/mob/living/carbon/human/species/elf/dark/base/very_skilled/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)

/mob/living/carbon/human/species/elf/dark/base/skilled
	dodgetime = 40
	flee_in_pain = FALSE

/mob/living/carbon/human/species/elf/dark/base/unskilled
	dodgetime = 60

/mob/living/carbon/human/species/elf/dark/base/unskilled/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

// --- Naked ---

/mob/living/carbon/human/species/elf/dark/base/unskilled/naked
	base_strength = 8
	base_speed = 14
	base_constitution = 12
	base_endurance = 12
	base_fortune = 9

/mob/living/carbon/human/species/elf/dark/base/unskilled/naked/after_creation()
	..()
	attributes.add_sheet(/datum/attribute_holder/sheet/job/generic_npc/unskilled/naked)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

/mob/living/carbon/human/species/elf/dark/base/skilled/naked
	base_strength = 10
	base_speed = 14
	base_constitution = 12
	base_endurance = 12
	base_fortune = 9


/mob/living/carbon/human/species/elf/dark/base/skilled/naked/after_creation()
	..()
	attributes.add_sheet(/datum/attribute_holder/sheet/job/generic_npc/skilled/naked)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

/mob/living/carbon/human/species/elf/dark/base/very_skilled/naked
	base_strength = 13
	base_speed = 14
	base_perception = 12
	base_constitution = 10
	base_endurance = 10
	base_fortune = 10


/mob/living/carbon/human/species/elf/dark/base/very_skilled/naked/after_creation()
	..()
	attributes.add_sheet(/datum/attribute_holder/sheet/job/generic_npc/very_skilled/naked)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

// --- Light Gear ---

/mob/living/carbon/human/species/elf/dark/base/unskilled/light_gear
	base_strength = 10
	base_speed = 12
	base_perception = 12
	base_constitution = 10
	base_endurance = 10
	base_fortune = 9
	dodgetime = 40

/mob/living/carbon/human/species/elf/dark/base/unskilled/light_gear/after_creation()
	..()
	attributes.add_sheet(/datum/attribute_holder/sheet/job/generic_npc/unskilled/light_gear)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 1
	equipOutfit(new /datum/outfit/npc/light_gear)

/mob/living/carbon/human/species/elf/dark/base/skilled/light_gear
	base_strength = 10
	base_speed = 13
	base_perception = 14
	base_constitution = 10
	base_endurance = 10
	base_fortune = 9
	dodgetime = 20

/mob/living/carbon/human/species/elf/dark/base/skilled/light_gear/after_creation()
	..()
	attributes.add_sheet(/datum/attribute_holder/sheet/job/generic_npc/skilled/light_gear)
	ADD_TRAIT(src, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 1
	equipOutfit(new /datum/outfit/npc/light_gear)

/mob/living/carbon/human/species/elf/dark/base/very_skilled/light_gear
	base_strength = 11
	base_speed = 14
	base_perception = 15
	base_constitution = 10
	base_endurance = 10
	base_fortune = 10
	dodgetime = 10

/mob/living/carbon/human/species/elf/dark/base/very_skilled/light_gear/after_creation()
	..()
	attributes.add_sheet(/datum/attribute_holder/sheet/job/generic_npc/very_skilled/light_gear)
	ADD_TRAIT(src, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 1
	equipOutfit(new /datum/outfit/npc/light_gear)

// --- Medium Gear ---

/mob/living/carbon/human/species/elf/dark/base/unskilled/medium_gear
	base_strength = 11
	base_speed = 10
	base_perception = 9
	base_constitution = 12
	base_endurance = 12
	base_fortune = 9

/mob/living/carbon/human/species/elf/dark/base/unskilled/medium_gear/after_creation()
	..()
	attributes.add_sheet(/datum/attribute_holder/sheet/job/generic_npc/unskilled/medium_gear)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 2
	equipOutfit(new /datum/outfit/npc/medium_gear)

/mob/living/carbon/human/species/elf/dark/base/skilled/medium_gear
	base_strength = 13
	base_speed = 11
	base_perception = 10
	base_constitution = 13
	base_endurance = 13
	base_fortune = 9

/mob/living/carbon/human/species/elf/dark/base/skilled/medium_gear/after_creation()
	..()
	attributes.add_sheet(/datum/attribute_holder/sheet/job/generic_npc/skilled/medium_gear)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 2
	equipOutfit(new /datum/outfit/npc/medium_gear)

/mob/living/carbon/human/species/elf/dark/base/very_skilled/medium_gear
	base_strength = 15
	base_speed = 12
	base_perception = 11
	base_constitution = 14
	base_endurance = 14
	base_fortune = 10

/mob/living/carbon/human/species/elf/dark/base/very_skilled/medium_gear/after_creation()
	..()
	attributes.add_sheet(/datum/attribute_holder/sheet/job/generic_npc/very_skilled/medium_gear)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 2
	equipOutfit(new /datum/outfit/npc/medium_gear)

// --- Heavy Gear ---

/mob/living/carbon/human/species/elf/dark/base/unskilled/heavy_gear
	base_strength = 11
	base_speed = 8
	base_perception = 8
	base_constitution = 12
	base_endurance = 12
	base_fortune = 9

/mob/living/carbon/human/species/elf/dark/base/unskilled/heavy_gear/after_creation()
	..()
	attributes.add_sheet(/datum/attribute_holder/sheet/job/generic_npc/unskilled/heavy_gear)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 3
	equipOutfit(new /datum/outfit/npc/heavy_gear)

/mob/living/carbon/human/species/elf/dark/base/skilled/heavy_gear
	base_strength = 13
	base_speed = 9
	base_perception = 9
	base_constitution = 14
	base_endurance = 14
	base_fortune = 9

/mob/living/carbon/human/species/elf/dark/base/skilled/heavy_gear/after_creation()
	..()
	attributes.add_sheet(/datum/attribute_holder/sheet/job/generic_npc/skilled/heavy_gear)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 3
	equipOutfit(new /datum/outfit/npc/heavy_gear)

/mob/living/carbon/human/species/elf/dark/base/very_skilled/heavy_gear
	base_strength = 15
	base_speed = 8
	base_perception = 11
	base_constitution = 16
	base_endurance = 16
	base_fortune = 10

/mob/living/carbon/human/species/elf/dark/base/very_skilled/heavy_gear/after_creation()
	..()
	attributes.add_sheet(/datum/attribute_holder/sheet/job/generic_npc/very_skilled/heavy_gear)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 3
	equipOutfit(new /datum/outfit/npc/heavy_gear)
