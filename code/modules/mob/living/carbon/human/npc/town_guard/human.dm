/mob/living/carbon/human/species/human/northern/guardsman_npc
	ai_controller = /datum/ai_controller/guardsman
	faction = list(FACTION_TOWN, FACTION_NEUTRAL)
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	canparry = TRUE
	candodge = TRUE
	wander = FALSE
	d_intent = INTENT_PARRY

/mob/living/carbon/human/species/human/northern/guardsman_npc/Initialize()
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	AddComponent(/datum/component/ai_aggro_system)
	set_patron(/datum/patron/divine/ravox, TRUE)
	job = "Humen Guardsman"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 0
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/guardsman_npc/unskilled
	dodgetime = 60
	base_strength = 11
	base_speed = 10
	base_perception = 9
	base_constitution = 12
	base_endurance = 12
	base_fortune = 9
	attribute_sheet = /datum/attribute_holder/sheet/job/town_guard_npc/unskilled

/mob/living/carbon/human/species/human/northern/guardsman_npc/unskilled/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 2
	equipOutfit(new /datum/outfit/npc/town_guard)

/mob/living/carbon/human/species/human/northern/guardsman_npc/skilled
	dodgetime = 40
	flee_in_pain = FALSE
	base_strength = 13
	base_speed = 11
	base_perception = 10
	base_constitution = 13
	base_endurance = 13
	base_fortune = 9
	attribute_sheet = /datum/attribute_holder/sheet/job/town_guard_npc/skilled

/mob/living/carbon/human/species/human/northern/guardsman_npc/skilled/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 2
	equipOutfit(new /datum/outfit/npc/town_guard)

/mob/living/carbon/human/species/human/northern/guardsman_npc/very_skilled
	dodgetime = 30
	flee_in_pain = FALSE
	base_strength = 15
	base_speed = 12
	base_perception = 11
	base_constitution = 14
	base_endurance = 14
	base_fortune = 10
	attribute_sheet = /datum/attribute_holder/sheet/job/town_guard_npc/very_skilled

/mob/living/carbon/human/species/human/northern/guardsman_npc/very_skilled/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ai_controller?.blackboard[BB_ARMOR_CLASS] = 2
	equipOutfit(new /datum/outfit/npc/town_guard)

/datum/outfit/npc/town_guard
	name = "Town Guard (NPC)"
	head = /obj/item/clothing/head/helmet/visored/sallet
	neck = /obj/item/clothing/neck/chaincoif
	shirt = /obj/item/clothing/armor/chainmail
	armor = /obj/item/clothing/armor/cuirass
	wrists = /obj/item/clothing/gloves/chain
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots/armor/light
	r_hand = /obj/item/weapon/polearm/halberd

/datum/attribute_holder/sheet/job/town_guard_npc/very_skilled
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

/datum/attribute_holder/sheet/job/town_guard_npc/skilled/
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

/datum/attribute_holder/sheet/job/town_guard_npc/unskilled
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


