/mob/living/carbon/human/species/tieberian/base
	ai_controller = /datum/ai_controller/species_hostile
	faction = list(FACTION_HOSTILE)
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	canparry = TRUE
	candodge = TRUE
	wander = FALSE
	d_intent = INTENT_PARRY

/mob/living/carbon/human/species/tieberian/base/Initialize()
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	set_species(/datum/species/tieberian)
	AddComponent(/datum/component/ai_aggro_system)
	set_patron(/datum/patron/inhumen/graggar, TRUE)
	job = "Graggarite Tiefling"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 0
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

// --- Base Variants ---

/mob/living/carbon/human/species/tieberian/base/very_skilled
	dodgetime = 30
	flee_in_pain = FALSE

/mob/living/carbon/human/species/tieberian/base/very_skilled/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)

/mob/living/carbon/human/species/tieberian/base/skilled
	dodgetime = 40
	flee_in_pain = FALSE

/mob/living/carbon/human/species/tieberian/base/unskilled
	dodgetime = 60

/mob/living/carbon/human/species/tieberian/base/unskilled/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

// --- Naked ---

/mob/living/carbon/human/species/tieberian/base/unskilled/naked/after_creation()
	..()
	configure_npc_mind(list(
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/misc/athletics = 1,
		/datum/skill/combat/knives = 1,
		/datum/skill/combat/swords = 1,
		/datum/skill/combat/axesmaces = 1,
		/datum/skill/combat/swords = 1,
		/datum/skill/combat/whipsflails = 1,
		/datum/skill/combat/polearms = 1,
		/datum/skill/combat/knives = 1,
		/datum/skill/combat/shields = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/misc/athletics = 1
	))
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

/mob/living/carbon/human/species/tieberian/base/skilled/naked
	base_strength = 10
	base_speed = 14
	base_constitution = 12
	base_endurance = 12
	base_fortune = 9

/mob/living/carbon/human/species/tieberian/base/skilled/naked/after_creation()
	..()
	configure_npc_mind(list(
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/whipsflails = 3,
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/shields = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/athletics = 3
	))
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)


/mob/living/carbon/human/species/tieberian/base/very_skilled/naked
	base_strength = 13
	base_speed = 14
	base_perception = 12
	base_constitution = 10
	base_endurance = 10
	base_fortune = 10

/mob/living/carbon/human/species/tieberian/base/very_skilled/naked/after_creation()
	..()
	configure_npc_mind(list(
		/datum/skill/combat/wrestling = 5,
		/datum/skill/combat/unarmed = 5,
		/datum/skill/misc/athletics = 5,
		/datum/skill/combat/knives = 5,
		/datum/skill/combat/swords = 5,
		/datum/skill/combat/axesmaces = 5,
		/datum/skill/combat/swords = 5,
		/datum/skill/combat/whipsflails = 5,
		/datum/skill/combat/polearms = 5,
		/datum/skill/combat/knives = 5,
		/datum/skill/combat/shields = 5,
		/datum/skill/combat/unarmed = 5,
		/datum/skill/misc/athletics = 5
	))
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)


// --- Light Gear ----

/mob/living/carbon/human/species/tieberian/base/unskilled/light_gear
	base_strength = 10
	base_speed = 12
	base_perception = 12
	base_constitution = 10
	base_endurance = 10
	base_fortune = 9
	dodgetime = 40


/mob/living/carbon/human/species/tieberian/base/unskilled/light_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	configure_npc_mind(list(
		/datum/skill/combat/knives = pick(1,2),
		/datum/skill/combat/swords = pick(1,2),
		/datum/skill/combat/unarmed = 1,
		/datum/skill/misc/athletics = 1
	))
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 1
	equipOutfit(new /datum/outfit/npc/light_gear)

/mob/living/carbon/human/species/tieberian/base/skilled/light_gear
	base_strength = 10
	base_speed = 13
	base_perception = 14
	base_constitution = 10
	base_endurance = 10
	base_fortune = 9
	dodgetime = 20


/mob/living/carbon/human/species/tieberian/base/skilled/light_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
	configure_npc_mind(list(
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/athletics = 2
	))
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 1
	equipOutfit(new /datum/outfit/npc/light_gear)

/mob/living/carbon/human/species/tieberian/base/very_skilled/light_gear
	base_strength = 11
	base_speed = 14
	base_perception = 15
	base_constitution = 10
	base_endurance = 10
	base_fortune = 10
	dodgetime = 10

/mob/living/carbon/human/species/tieberian/base/very_skilled/light_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
	configure_npc_mind(list(
		/datum/skill/combat/knives = 5,
		/datum/skill/combat/swords = 5,
		/datum/skill/combat/unarmed = 4,
		/datum/skill/misc/athletics = 4
	))
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 1
	equipOutfit(new /datum/outfit/npc/light_gear)

// --- Medium Gear ----


/mob/living/carbon/human/species/tieberian/base/unskilled/medium_gear
	base_strength = 11
	base_speed = 10
	base_perception = 9
	base_constitution = 12
	base_endurance = 12
	base_fortune = 9


/mob/living/carbon/human/species/tieberian/base/unskilled/medium_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	configure_npc_mind(list(
		/datum/skill/combat/axesmaces = pick(1,2),
		/datum/skill/combat/swords = pick(1,2),
		/datum/skill/combat/whipsflails = pick(1,2),
		/datum/skill/combat/polearms = pick(1,2),
		/datum/skill/combat/shields = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/misc/athletics = 1

	))
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 2
	equipOutfit(new /datum/outfit/npc/medium_gear)

/mob/living/carbon/human/species/tieberian/base/skilled/medium_gear
	base_strength = 13
	base_speed = 11
	base_perception = 10
	base_constitution = 13
	base_endurance = 13
	base_fortune = 9

/mob/living/carbon/human/species/tieberian/base/skilled/medium_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	configure_npc_mind(list(
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/whipsflails = 3,
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/shields = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/athletics = 2
	))
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 2
	equipOutfit(new /datum/outfit/npc/medium_gear)

/mob/living/carbon/human/species/tieberian/base/very_skilled/medium_gear
	base_strength = 15
	base_speed = 12
	base_perception = 11
	base_constitution = 14
	base_endurance = 14
	base_fortune = 10

/mob/living/carbon/human/species/tieberian/base/very_skilled/medium_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	configure_npc_mind(list(
		/datum/skill/combat/axesmaces = 5,
		/datum/skill/combat/swords = 5,
		/datum/skill/combat/whipsflails = 5,
		/datum/skill/combat/polearms = 5,
		/datum/skill/combat/shields = 4,
		/datum/skill/combat/unarmed = 4,
		/datum/skill/misc/athletics = 4
	))
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 2
	equipOutfit(new /datum/outfit/npc/medium_gear)


// --- Heavy Gear ----

/mob/living/carbon/human/species/tieberian/base/unskilled/heavy_gear
	base_strength = 11
	base_speed = 8
	base_perception = 8
	base_constitution = 12
	base_endurance = 12
	base_fortune = 9


/mob/living/carbon/human/species/tieberian/base/unskilled/heavy_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	configure_npc_mind(list(
		/datum/skill/combat/axesmaces = pick(1,2),
		/datum/skill/combat/swords = pick(1,2),
		/datum/skill/combat/whipsflails = pick(1,2),
		/datum/skill/combat/shields = pick(1,2),
		/datum/skill/combat/polearms = pick(1,2),
		/datum/skill/combat/unarmed = 1,
		/datum/skill/misc/athletics = 1
	))
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 3
	equipOutfit(new /datum/outfit/npc/heavy_gear)

/mob/living/carbon/human/species/tieberian/base/skilled/heavy_gear
	base_strength = 13
	base_speed = 9
	base_perception = 9
	base_constitution = 14
	base_endurance = 14
	base_fortune = 9


/mob/living/carbon/human/species/tieberian/base/skilled/heavy_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	configure_npc_mind(list(
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/whipsflails = 3,
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/shields = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/athletics = 2
	))
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 3
	equipOutfit(new /datum/outfit/npc/heavy_gear)

/mob/living/carbon/human/species/tieberian/base/very_skilled/heavy_gear
	base_strength = 15
	base_speed = 8
	base_perception = 11
	base_constitution = 16
	base_endurance = 16
	base_fortune = 10


/mob/living/carbon/human/species/tieberian/base/very_skilled/heavy_gear/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	configure_npc_mind(list(
		/datum/skill/combat/axesmaces = 5,
		/datum/skill/combat/swords = 5,
		/datum/skill/combat/whipsflails = 5,
		/datum/skill/combat/polearms = 5,
		/datum/skill/combat/shields = 5,
		/datum/skill/combat/unarmed = 4,
		/datum/skill/misc/athletics = 4
	))
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 3
	equipOutfit(new /datum/outfit/npc/heavy_gear)