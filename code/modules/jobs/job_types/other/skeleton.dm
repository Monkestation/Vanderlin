/datum/job/skeleton
	title = "Skeleton"
	tutorial = null
	department_flag = UNDEAD
	job_flags = (JOB_EQUIP_RANK)
	faction = FACTION_UNDEAD
	total_positions = 0
	spawn_positions = 0
	antag_job = TRUE
	allowed_races = RACES_PLAYER_ALL
	cmode_music = 'sound/music/cmode/antag/combatskeleton.ogg'
	outfit = /datum/outfit/skeleton
	give_bank_account = FALSE
	languages = list(/datum/language/undead)

	traits = list(
		TRAIT_NOMOOD,
		TRAIT_NOSTAMINA,
		TRAIT_NOLIMBDISABLE,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_NOSLEEP,
		TRAIT_SHOCKIMMUNE
	)


/datum/job/skeleton/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	spawned.mind.special_role = "Skeleton"
	spawned.mind?.current.job = null

	// Randomize stats here
	spawned.base_strength = rand(8,10)
	spawned.base_speed = rand(7,10)
	spawned.base_intelligence = 1
	spawned.base_constitution = 3
	spawned.recalculate_stats(FALSE)

	if(spawned.dna && spawned.dna.species)
		spawned.dna.species.species_traits |= NOBLOOD
		spawned.dna.species.soundpack_m = new /datum/voicepack/skeleton()
		spawned.dna.species.soundpack_f = new /datum/voicepack/skeleton()

	spawned.regenerate_limb(BODY_ZONE_R_ARM)
	spawned.regenerate_limb(BODY_ZONE_L_ARM)
	spawned.skeletonize()
	spawned.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/simple/claw)
	spawned.update_a_intents()
	spawned.grant_undead_eyes()
	spawned.ambushable = FALSE
	spawned.underwear = "Nude"
	if(length(spawned.quirks))
		spawned.clear_quirks()
	spawned.update_body()
	spawned.mob_biotypes = MOB_UNDEAD
	spawned.faction = list(FACTION_UNDEAD)



/* RAIDER SKELETONS */

/datum/job/skeleton/raider
	title = "Skeleton Raider"
	outfit = /datum/outfit/skeleton/raider
	cmode_music = 'sound/music/cmode/antag/combatskeleton.ogg'
	antag_role = /datum/antagonist/skeleton

	traits = list(
		TRAIT_CRITICAL_WEAKNESS,
		TRAIT_EASYDISMEMBER
	)


/datum/job/skeleton/raider/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.name = "skeleton"
	spawned.real_name = "skeleton"
	spawned.remove_all_languages()
	spawned.grant_language(/datum/language/hellspeak)

	// Randomized stats
	spawned.base_strength = rand(8,12)
	spawned.base_speed = rand(7,11)
	spawned.base_intelligence = 1
	spawned.base_constitution = 3
	spawned.recalculate_stats(FALSE)



/* CULT SUMMONS */

/datum/job/skeleton/zizoid
	title = "Cult Summon"
	outfit = /datum/outfit/skeleton/zizoid
	cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'

/datum/job/skeleton/zizoid/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.mind?.special_role = "Cult Summon"
	spawned.mind?.current.job = null
	spawned.set_patron(/datum/patron/inhumen/zizo)

	// Randomized stats
	spawned.base_strength = rand(8,17)
	spawned.base_speed = rand(7,10)
	spawned.base_intelligence = 1
	spawned.base_constitution = 3
	spawned.recalculate_stats(FALSE)

	if(spawned.dna?.species)
		spawned.dna.species.native_language = "Zizo Chant"
		spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)

	add_verb(spawned, /mob/living/carbon/human/proc/praise)
	add_verb(spawned, /mob/living/carbon/human/proc/communicate)


/* BASIC SKELETON OUTFIT */
/datum/outfit/skeleton
	name = "Skeleton"

/datum/outfit/skeleton/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	equipped_human.underwear = "Nude"

/* RAIDER SKELETON OUTFIT */
/datum/outfit/skeleton/raider
	name = "Skeleton Raider"

/datum/outfit/skeleton/raider/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	// Randomized armor
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

	// Randomized headgear
	switch(rand(1,9))
		if (1) head = /obj/item/clothing/head/helmet/kettle
		if (2) head = /obj/item/clothing/head/helmet/winged
		if (3) head = /obj/item/clothing/head/helmet/leather/conical
		if (4) head = /obj/item/clothing/head/helmet/coppercap
		if (5) neck = /obj/item/clothing/neck/coif/cloth
		if (6) neck = /obj/item/clothing/neck/coif
		if (7) head = /obj/item/clothing/head/helmet/horned
		if (8) head = /obj/item/clothing/head/helmet/skullcap
		if (9) head = /obj/item/clothing/head/helmet

	// Shield
	if(prob(20))
		backr = /obj/item/weapon/shield/wood

	// Randomized weapons
	switch(rand(1,6))
		if (1)
			var/obj/item/weapon/sword/short/iron/P = new()
			equipped_human.put_in_hands(P, forced = TRUE)
		if (2)
			var/obj/item/weapon/axe/copper/P = new()
			equipped_human.put_in_hands(P, forced = TRUE)
		if (3)
			var/obj/item/weapon/mace/P = new()
			equipped_human.put_in_hands(P, forced = TRUE)
		if (4)
			var/obj/item/weapon/polearm/spear/P = new()
			equipped_human.put_in_hands(P, forced = TRUE)
		if (5)
			var/obj/item/weapon/sword/long/rider/copper/P = new()
			equipped_human.put_in_hands(P, forced = TRUE)
		if (6)
			var/obj/item/weapon/flail/militia/P = new()
			equipped_human.put_in_hands(P, forced = TRUE)

/* ZIZOID CULT SUMMON OUTFIT */
/datum/outfit/skeleton/zizoid
	name = "Cult Summon"

