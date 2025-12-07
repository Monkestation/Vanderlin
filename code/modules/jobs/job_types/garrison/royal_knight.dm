/datum/job/royalknight
	title = "Royal Knight"
	tutorial = "You are a knight of the royal garrison, elevated by your skill and steadfast devotion. \
	Sworn to protect the royal family, you stand as their shield, upholding their rule with steel and sacrifice. \
	Yet service is not without its trials, and your loyalty will be tested in ways both seen and unseen. \
	In the end, duty is a path you must walk carefully."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_ROYALKNIGHT
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2
	bypass_lastclass = TRUE
	selection_color = "#920909"

	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)

	advclass_cat_rolls = list(CTAG_ROYALKNIGHT = 20)
	give_bank_account = 60
	cmode_music = 'sound/music/cmode/nobility/CombatKnight.ogg'
	job_bitflag = BITFLAG_GARRISON

	exp_type = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_types_granted  = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_GARRISON = 900,
		EXP_TYPE_COMBAT = 1200
	)


/datum/job/advclass/royalknight
	inherit_parent_title = TRUE
	exp_types_granted  = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)

/datum/job/advclass/royalknight/knight
	title = "Royal Knight"
	tutorial = "The classic Knight in shining armor. Slightly more skilled then their Steam counterpart but has worse armor."

	outfit = /datum/outfit/royalknight/knight

	category_tags = list(CTAG_ROYALKNIGHT)

/datum/outfit/royalknight
	var/reduced_skill = FALSE

/datum/outfit/royalknight/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/chaincoif
	pants = /obj/item/clothing/pants/platelegs
	cloak = /obj/item/clothing/cloak/tabard/knight/guard  // Wear the King's colors
	shirt = /obj/item/clothing/armor/gambeson/arming
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/sword/arming
	backl = /obj/item/storage/backpack/satchel
	scabbards = list(/obj/item/weapon/scabbard/sword/noble)
	backpack_contents = list(/obj/item/storage/keyring/manorguard = 1)

	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)

	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)

	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)

	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_INT, 1)

	H.verbs |= /mob/proc/haltyell
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	if(H.dna?.species?.id == SPEC_ID_HUMEN)
		H.dna.species.soundpack_m = new /datum/voicepack/male/knight()

/datum/outfit/royalknight/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	if(H.cloak)
		if(!findtext(H.cloak.name,"([H.real_name])"))
			H.cloak.name = "[H.cloak.name]"+" "+"([H.real_name])"

	var/prev_real_name = H.real_name
	var/prev_name = H.name
	var/honorary = "Sir"
	if(H.pronouns == SHE_HER)
		honorary = "Dame"
	H.real_name = "[honorary] [prev_real_name]"
	H.name = "[honorary] [prev_name]"

	var/static/list/selectable = list( \
		"Flail" = /obj/item/weapon/flail/sflail, \
		"Halberd" = /obj/item/weapon/polearm/halberd, \
		"Longsword" = /obj/item/weapon/sword/long, \
		"Sabre" = /obj/item/weapon/sword/sabre/dec, \
		"Unarmed" = /obj/item/weapon/knife/dagger/steel, \
		"Knuckles" = /obj/item/weapon/knuckles, \
		"Katar" = /obj/item/weapon/katar \
		)
	var/choice = H.select_equippable(H, selectable, message = "Choose Your Specialisation", title = "KNIGHT")
	if(!choice)
		return
	var/grant_shield = TRUE
	switch(choice)
		if("Flail")
			H.clamped_adjust_skillrank(/datum/skill/combat/whipsflails, 2, 4, TRUE)
		if("Halberd")
			H.clamped_adjust_skillrank(/datum/skill/combat/polearms, 2, 4, TRUE)
			grant_shield = FALSE
		if("Longsword")
			grant_shield = FALSE
			H.clamped_adjust_skillrank(/datum/skill/combat/swords, 2, 4, TRUE)
		if("Sabre")
			H.clamped_adjust_skillrank(/datum/skill/combat/swords, 2, 4, TRUE)
		if("Unarmed")
			H.clamped_adjust_skillrank(/datum/skill/combat/unarmed, 3, 5, TRUE)
			H.clamped_adjust_skillrank(/datum/skill/combat/knives, 2, 4, TRUE)
			grant_shield = FALSE
		if("Knuckles")
			H.clamped_adjust_skillrank(/datum/skill/combat/unarmed, 1, 4, TRUE)
			grant_shield = FALSE
		if("Katar")
			H.clamped_adjust_skillrank(/datum/skill/combat/unarmed, 1, 4, TRUE)
			grant_shield = FALSE
	if(grant_shield)
		H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
		var/shield = new /obj/item/weapon/shield/tower/metal()
		if(!H.equip_to_appropriate_slot(shield))
			qdel(shield)

/datum/outfit/royalknight/knight/pre_equip(mob/living/carbon/human/H)
	. = ..()
	armor = /obj/item/clothing/armor/plate/full
	head = /obj/item/clothing/head/helmet/visored/royalknight
	gloves = /obj/item/clothing/gloves/plate
	shoes = /obj/item/clothing/shoes/boots/armor

/datum/job/advclass/royalknight/steam
	title = "Steam Knight"
	tutorial = "The pinnacle of Vanderlin's steam technology. \
	Start with a set of Steam Armor that requires steam to function. \
	The suit is powerful when powered but will slow you down when not \
	learning how to use it has cost you precious time \
	you could have spent learning to use other weapons."

	outfit = /datum/outfit/royalknight/steam

	category_tags = list(CTAG_ROYALKNIGHT)

/datum/outfit/royalknight/steam

/datum/outfit/royalknight/steam/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backr = /obj/item/clothing/cloak/boiler
	armor = /obj/item/clothing/armor/steam
	shoes = /obj/item/clothing/shoes/boots/armor/steam
	gloves = /obj/item/clothing/gloves/plate/steam
	head = /obj/item/clothing/head/helmet/heavy/steam

	H.adjust_skillrank(/datum/skill/combat/swords, -1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, -1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, -1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, -1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, -1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, -1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, -1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, -1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, -1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, 3, TRUE)//replaces the int buff

/datum/outfit/royalknight/steam/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	if(H.backr && istype(H.backr, /obj/item/clothing/cloak/boiler))
		var/obj/item/clothing/cloak/boiler/B = H.backr
		SEND_SIGNAL(B, COMSIG_ATOM_STEAM_INCREASE, 1000)
