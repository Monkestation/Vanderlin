/datum/job/advclass/sacrestant/disciple
	title = "Disciple"
	tutorial = "Some train their steel, others train their wits. You have honed your body itself into a weapon, anointing it with faithful markings to fortify your soul. You serve and train under the Ordo Benetarus, and one day you will be among Psydon’s most dauntless warriors."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/disciple
	category_tags = list(CTAG_INQUISITION)
	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 2,
		STATKEY_CON = 3,
		STATKEY_INT = -2,
		STATKEY_SPD = -1
	)
	skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

	traits = list(
		TRAIT_INQUISITION,
		TRAIT_SILVER_BLESSED,
		TRAIT_STEELHEARTED,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
		TRAIT_FOREIGNER,
	)

	languages = list(/datum/language/oldpsydonic)

/datum/job/advclass/sacrestant/disciple/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_school(spawned, "Benetarus", 0, "Disciple")

	var/datum/species/species = spawned.dna?.species
	if(species)
		species.native_language = "Old Psydonic"
		species.accent_language = species.get_accent(species.native_language)

	if(!spawned.mind)
		return

	// I Hate
	var/static/list/weapons = list(
		"Discipline - Unarmed" = null,
		"Katar" = /obj/item/weapon/katar/psydon,
		"Knuckledusters" = /obj/item/weapon/knuckles/psydon,
		"Quarterstaff" = /obj/item/weapon/polearm/woodstaff/quarterstaff,
	)
	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "TAKE UP PSYDON'S ARMS!")
	var/obj/item/clothing/gloves/gloves_to_wear = /obj/item/clothing/gloves/bandages/weighted
	switch(weapon_choice)
		if("Discipline - Unarmed")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/unarmed, 5, 5)
			spawned.clamped_adjust_skillrank(/datum/skill/misc/athletics, 5, 5)
			gloves_to_wear = /obj/item/clothing/gloves/bandages/pugilist
			ADD_TRAIT(spawned, TRAIT_CRITICAL_RESISTANCE, JOB_TRAIT)
			ADD_TRAIT(spawned, TRAIT_IGNOREDAMAGESLOWDOWN, JOB_TRAIT)
		if("Katar")
			ADD_TRAIT(spawned, TRAIT_CRITICAL_RESISTANCE, JOB_TRAIT)
		if("Knuckledusters")
			ADD_TRAIT(spawned, TRAIT_CRITICAL_RESISTANCE, JOB_TRAIT)
		if("Quarterstaff")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/polearms, 3, 3)
			spawned.adjust_stat_modifier("job_stats", STATKEY_PER, 1)
			spawned.adjust_stat_modifier("job_stats", STATKEY_INT, 1)
	spawned.equip_to_slot_or_del(new gloves_to_wear, ITEM_SLOT_GLOVES, TRUE)

/datum/outfit/disciple
	name = "Disciple"
	shoes = /obj/item/clothing/shoes/psydonboots
	armor = /obj/item/clothing/armor/regenerating/skin/disciple
	backl = /obj/item/storage/backpack/satchel/otavan
	belt = /obj/item/storage/belt/leather/rope/dark
	pants = /obj/item/clothing/pants/tights/colored/black
	beltl = /obj/item/storage/belt/pouch/coins/mid
	cloak = /obj/item/clothing/cloak/psydontabard/alt
	ring = /obj/item/clothing/ring/signet/silver
	neck = /obj/item/clothing/neck/psycross/silver
	wrists = /obj/item/clothing/wrists/bracers/psythorns
	mask = /obj/item/clothing/head/helmet/blacksteel/psythorns
	head = /obj/item/clothing/head/roguehood/psydon
	backpack_contents = list(
		/obj/item/key/inquisition = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1,
		/obj/item/collar_detonator = 1,
	)
