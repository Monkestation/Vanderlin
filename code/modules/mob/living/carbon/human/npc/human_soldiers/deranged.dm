/* *
 * Deranged Knight
 * A miniboss for quest system, designed to be a high-level challenge for multiple players.
 * Uses fuckoff gear that should not be looted - hence snowflake dismemberment code.
 */

GLOBAL_LIST_INIT(matthios_aggro, file2list("strings/rt/matthiosaggrolines.txt"))
GLOBAL_LIST_INIT(zizo_aggro, file2list("strings/rt/zizoaggrolines.txt"))
GLOBAL_LIST_INIT(graggar_aggro, file2list("strings/rt/graggaraggrolines.txt"))
GLOBAL_LIST_INIT(hedgeknight_aggro, file2list("strings/rt/hedgeknightaggrolines.txt"))

/mob/living/carbon/human/species/human/northern/deranged_knight
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_UNDEAD)
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	var/is_silent = FALSE /// Determines whether or not we will scream our funny lines at people.
	var/preset = "matthios"
	var/forced_preset = "" // If set, force a specific preset instead of randomizing.
	headprice = 36

/mob/living/carbon/human/species/human/northern/deranged_knight/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	AddComponent(/datum/component/ai_aggro_system)
	is_silent = TRUE
	var/head = get_bodypart(BODY_ZONE_HEAD)
	RegisterSignal(head, COMSIG_MOB_DISMEMBER, PROC_REF(handle_drop_limb))


/mob/living/carbon/human/species/human/northern/deranged_knight/Destroy()
	var/head = get_bodypart(BODY_ZONE_HEAD)
	if(head)
		UnregisterSignal(head, COMSIG_MOB_DISMEMBER)
	return ..()

/// Snowflake DK behavior for decaps. Yes, they turn to dust prior to decaps.
/mob/living/carbon/human/species/human/northern/deranged_knight/proc/handle_drop_limb(obj/item/bodypart/bodypart, special)
	if(!istype(bodypart, /obj/item/bodypart/head))
		return

	death(FALSE, TRUE) // No, you won't loot that tasty helmet.
	return COMPONENT_CANCEL_DISMEMBER

/mob/living/carbon/human/species/human/northern/deranged_knight/after_creation()
	..()
	job = "Ascendant Knight"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STUCKITEMS, TRAIT_GENERIC)
	if(forced_preset)
		preset = forced_preset
	else
		switch(rand(1, 4))
			if(1)
				preset = "graggar"
			if(2)
				preset = "matthios"
			if(3)
				preset = "zizo"
			if(4)
				preset = "hedgeknight"

	switch(preset)
		if("graggar")
			equipOutfit(new /datum/outfit/job/quest_miniboss/graggar)
			SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.graggar_aggro, TRUE)
			SEND_SIGNAL(src, COMSIG_MOB_MODIFY_DEATH_LINES, list("No more... Blood!"), TRUE)
		if ("matthios")
			equipOutfit(new /datum/outfit/job/quest_miniboss/matthios)
			SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.matthios_aggro, TRUE)
			SEND_SIGNAL(src, COMSIG_MOB_MODIFY_DEATH_LINES, list("Matthios, I have failed you...", "Matthios, is this true?!"), TRUE)
		if ("zizo")
			ADD_TRAIT(src, TRAIT_CABAL, TRAIT_GENERIC)
			equipOutfit(new /datum/outfit/job/quest_miniboss/zizo)
			SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.zizo_aggro, TRUE)
			SEND_SIGNAL(src, COMSIG_MOB_MODIFY_DEATH_LINES, list("Zizo, forgive me!"), TRUE)
		if ("hedgeknight")
			if(prob(50))
				equipOutfit(new /datum/outfit/job/quest_miniboss/hedge_knight)
			else
				equipOutfit(new /datum/outfit/job/quest_miniboss/blacksteel)
			// No special trait for hedgeknight, he's just a generic tough guy.
			SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.hedgeknight_aggro, TRUE)

	gender = pick(MALE,FEMALE)
	regenerate_icons()

	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/organ/ears/organ_ears = getorgan(/obj/item/organ/ears)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(
						/datum/sprite_accessory/hair/head/countryponytailalt,
						/datum/sprite_accessory/hair/head/stacy,
						/datum/sprite_accessory/hair/head/kusanagi_alt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher,
						/datum/sprite_accessory/hair/head/dave,
						/datum/sprite_accessory/hair/head/sabitsuki))

	var/datum/bodypart_feature/hair/head/new_hair = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)

	new_hair.accessory_colors = "#DDDDDD"
	new_hair.hair_color = "#DDDDDD"
	set_hair_color("#DDDDDD")

	head.add_bodypart_feature(new_hair)

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)

	if(organ_eyes)
		organ_eyes.eye_color = "#FFBF00"
		organ_eyes.accessory_colors = "#FFBF00#FFBF00"

	if(organ_ears)
		organ_ears.accessory_colors = "#5f5f70"

	skin_tone = "5f5f70"

	if(prob(1))
		real_name = "Taras Mura"
	update_body()

	def_intent_change(INTENT_PARRY)

/mob/living/carbon/human/species/human/northern/deranged_knight/death(gibbed, nocutscene)
	. = ..()
	if(!gibbed)
		dust(FALSE, FALSE, TRUE)

/datum/attribute_holder/sheet/job/npc/quest_miniboss
	raw_attribute_list = list(
		STAT_STRENGTH = 5,
		STAT_SPEED = 4,
		STAT_CONSTITUTION = 5,
		STAT_ENDURANCE = 4,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 2,
		/datum/attribute/skill/combat/whipsflails = 40,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
	)
/datum/outfit/job/quest_miniboss/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.attributes?.add_sheet(/datum/attribute_holder/sheet/job/npc/quest_miniboss)

/datum/outfit/job/quest_miniboss/matthios/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/armor/plate/full/matthios
	pants = /obj/item/clothing/pants/platelegs/matthios
	shoes = /obj/item/clothing/shoes/boots/armor/matthios
	wrists = /obj/item/clothing/wrists/bracers
	gloves = /obj/item/clothing/gloves/plate/matthios
	head = /obj/item/clothing/head/helmet/heavy/matthios
	neck = /obj/item/clothing/neck/gorget
	r_hand = /obj/item/weapon/flail/peasantwarflail/matthios
	mask = /obj/item/clothing/face/facemask/steel

/datum/outfit/job/quest_miniboss/zizo/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/armor/plate/full/zizo
	pants = /obj/item/clothing/pants/platelegs/zizo
	shoes = /obj/item/clothing/shoes/boots/armor/zizo
	wrists = /obj/item/clothing/wrists/bracers
	gloves = /obj/item/clothing/gloves/plate/zizo
	head = /obj/item/clothing/head/helmet/heavy/zizo
	neck = /obj/item/clothing/neck/gorget
	r_hand = /obj/item/weapon/sword/long
	mask = /obj/item/clothing/face/facemask/steel

/datum/outfit/job/quest_miniboss/graggar/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/armor/plate/fluted/ornate
	pants = /obj/item/clothing/pants/platelegs/graggar
	shoes = /obj/item/clothing/shoes/boots/armor/graggar
	gloves = /obj/item/clothing/gloves/plate/graggar
	wrists = /obj/item/clothing/wrists/bracers
	head = /obj/item/clothing/head/helmet/heavy/graggar
	neck = /obj/item/clothing/neck/gorget
	r_hand = /obj/item/weapon/greataxe/steel/doublehead/graggar
	mask = /obj/item/clothing/face/facemask/steel
	wrists = /obj/item/clothing/wrists/bracers
	cloak = /obj/item/clothing/cloak/graggar

/datum/outfit/job/quest_miniboss/blacksteel/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/armor/plate/blkknight
	pants = /obj/item/clothing/pants/platelegs/blk
	shoes = /obj/item/clothing/shoes/boots/armor/blkknight
	gloves = /obj/item/clothing/gloves/plate/blk
	wrists = /obj/item/clothing/wrists/bracers
	head = /obj/item/clothing/head/helmet/blacksteel
	neck = /obj/item/clothing/neck/gorget
	r_hand = /obj/item/weapon/sword/long/greatsword
	mask = /obj/item/clothing/face/facemask/steel
	wrists = /obj/item/clothing/wrists/bracers

/datum/outfit/job/quest_miniboss/hedge_knight/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/armor/plate/fluted
	pants = /obj/item/clothing/pants/platelegs
	shoes = /obj/item/clothing/shoes/boots/armor
	gloves = /obj/item/clothing/gloves/plate
	head = /obj/item/clothing/head/helmet/heavy/frog
	neck = /obj/item/clothing/neck/gorget
	r_hand = /obj/item/weapon/sword/long/greatsword/gutsclaymore
	mask = /obj/item/clothing/face/facemask/steel
	belt = /obj/item/storage/belt/leather/steel
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/weapon/sword/long
	wrists = /obj/item/clothing/wrists/bracers
	cloak = /obj/item/clothing/cloak/stabard/colored/dungeon

/*
 * Goon preset
 * Intended to support knight, but should not have any special/overly expensive gear.
*/

/mob/living/carbon/human/species/human/northern/highwayman/dk_goon
	faction = list(FACTION_UNDEAD)

/mob/living/carbon/human/species/human/northern/deranged_knight/matthios
	forced_preset = "matthios"

/mob/living/carbon/human/species/human/northern/deranged_knight/zizo
	forced_preset = "zizo"

/mob/living/carbon/human/species/human/northern/deranged_knight/graggar
	forced_preset = "graggar"

/mob/living/carbon/human/species/human/northern/deranged_knight/hedgeknight
	forced_preset = "hedgeknight"
