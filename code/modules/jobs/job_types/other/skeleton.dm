/*
 * T: Skeletons should honestly just be a species.
 * In fact, they normally are on other codebases.
 * This will need refactoring for sure.
 */

/datum/job/skeleton
	title = "Skeleton"
	tutorial = null
	department_flag = UNDEAD
	job_flags = (JOB_EQUIP_RANK)
	faction = FACTION_TOWN //this seems wrong?
	total_positions = -1 //this also seems wrong?
	spawn_positions = 0
	antag_job = TRUE

	allowed_races = RACES_PLAYER_ALL
	cmode_music = 'sound/music/cmode/antag/combatskeleton.ogg'

	outfit = /datum/outfit/skeleton
	give_bank_account = FALSE

/datum/job/skeleton/after_spawn(mob/living/spawned, client/player_client)
	..()

	var/mob/living/carbon/human/H = spawned
	if(spawned.mind)
		spawned.mind.special_role = "Skeleton"
		spawned.job = null //?
	if(H.dna && H.dna.species)
		H.dna.species.species_traits |= NOBLOOD
		H.dna.species.soundpack_m = new /datum/voicepack/skeleton()
		H.dna.species.soundpack_f = new /datum/voicepack/skeleton()
	var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_R_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	O = H.get_bodypart(BODY_ZONE_L_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	H.regenerate_limb(BODY_ZONE_R_ARM)
	H.regenerate_limb(BODY_ZONE_L_ARM)
	H.skeletonize()
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/simple/claw)
	H.update_a_intents()

	H.grant_undead_eyes()
	H.ambushable = FALSE
	H.underwear = "Nude"
	if(H.charflaw)
		QDEL_NULL(H.charflaw)
	H.update_body()
	H.mob_biotypes = MOB_UNDEAD
	H.faction = list(FACTION_UNDEAD)
	ADD_TRAIT(H, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSTAMINA, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSLEEP, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SHOCKIMMUNE, TRAIT_GENERIC)

/datum/outfit/skeleton/pre_equip(mob/living/carbon/human/H)
	..()

	H.base_strength = rand(8,10)
	H.base_speed = rand(7,10)
	H.base_intelligence = 1
	H.base_constitution = 3
	H.recalculate_stats(FALSE)

/* RAIDER SKELETONS */
/datum/job/skeleton/raider
	title = "Skeleton Raider"
	outfit = /datum/outfit/skeleton/raider

/datum/job/skeleton/raider/after_spawn(mob/living/carbon/spawned, client/player_client)
	..()
	spawned.name = "skeleton"
	spawned.real_name = "skeleton"

	spawned.remove_all_languages()
	spawned.grant_language(/datum/language/hellspeak)
	spawned.silent = TRUE	// makes them unable to audible emote or speak, no more sexy moan zombies

	ADD_TRAIT(spawned, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	ADD_TRAIT(spawned, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)

	var/datum/antagonist/new_antag = new /datum/antagonist/skeleton()
	spawned.mind.add_antag_datum(new_antag)


/datum/outfit/skeleton/raider/pre_equip(mob/living/carbon/human/H)
	..()
	wrists = /obj/item/clothing/wrists/bracers/leather
	if(prob(50))
		wrists = /obj/item/clothing/wrists/bracers
	belt = /obj/item/storage/belt/leather
	if(prob(10))
		armor = /obj/item/clothing/armor/gambeson/light
	if(prob(10))
		armor = /obj/item/clothing/armor/leather/vest
	if(prob(10))
		armor = /obj/item/clothing/armor/chainmail/iron
	if(prob(10))
		armor = /obj/item/clothing/armor/cuirass/copperchest
	if(prob(10))
		armor = /obj/item/clothing/armor/leather/hide
	if(prob(10))
		armor = /obj/item/clothing/armor/cuirass/iron/rust

	switch(pick(1,9))
		if (1)
			head = /obj/item/clothing/head/helmet/kettle
		if (2)
			head = /obj/item/clothing/head/helmet/winged
		if (3)
			head = /obj/item/clothing/head/helmet/leather/conical
		if (4)
			head = /obj/item/clothing/head/helmet/coppercap
		if (5)
			neck = /obj/item/clothing/neck/coif/cloth
		if (6)
			neck = /obj/item/clothing/neck/coif
		if (7)
			head = /obj/item/clothing/head/helmet/horned
		if (8)
			head = /obj/item/clothing/head/helmet/skullcap
		if (9)
			head = /obj/item/clothing/head/helmet

	if(prob(20))
		backr = /obj/item/weapon/shield/wood

	switch(pick(1,6))
		if (1)
			var/obj/item/weapon/sword/short/iron/P = new()
			H.put_in_hands(P, forced = TRUE)
		if (2)
			var/obj/item/weapon/axe/copper/P = new()
			H.put_in_hands(P, forced = TRUE)
		if (3)
			var/obj/item/weapon/mace/P = new()
			H.put_in_hands(P, forced = TRUE)
		if (4)
			var/obj/item/weapon/polearm/spear/P = new()
			H.put_in_hands(P, forced = TRUE)
		if (5)
			var/obj/item/weapon/sword/long/rider/copper/P = new()
			H.put_in_hands(P, forced = TRUE)
		if (6)
			var/obj/item/weapon/flail/militia/P = new()
			H.put_in_hands(P, forced = TRUE)


/* CULT SUMMONS */
/datum/job/skeleton/zizoid
	title = "Cult Summon"
	outfit = /datum/outfit/skeleton/zizoid
	cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'

/datum/job/skeleton/zizoid/after_spawn(mob/living/spawned, client/player_client)
	..()

	var/mob/living/carbon/human/H = spawned
	H.mind?.special_role = "Cult Summon"
	H.mind?.current.job = null
	H.set_patron(/datum/patron/inhumen/zizo)

/datum/outfit/skeleton/zizoid/pre_equip(mob/living/carbon/human/H)
	..()
	H.base_strength = rand(8,17)
	H.base_speed = rand(7,10)
	H.base_intelligence = 1
	H.base_constitution = 3
	H.recalculate_stats(FALSE)
	H.grant_language(/datum/language/undead)
	if(H.dna?.species)
		H.dna.species.native_language = "Zizo Chant"
		H.dna.species.accent_language = H.dna.species.get_accent(H.dna.species.native_language)

	H.verbs |= /mob/living/carbon/human/proc/praise
	H.verbs |= /mob/living/carbon/human/proc/communicate
