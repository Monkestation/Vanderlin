/datum/attribute_holder/sheet/job/lancer
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/job/advclass/combat/lancer
	title = "Lancer"
	tutorial = "Working for many years as a famous mercenary in Zaladin, you have left your country to avoid the skeletons of your past. With your polearm by your side, you can face down any foe."
	allowed_sexes = list(MALE)
	allowed_races = list(SPEC_ID_HUMEN)
	outfit = /datum/outfit/adventurer/lancer
	total_positions = 1
	roll_chance = 15
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'
	is_recognized = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/lancer

	traits = list(
		TRAIT_HEAVYARMOR,
	)

	languages = list(/datum/language/zalad)

/datum/job/advclass/combat/lancer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/datum/species/species = spawned.dna?.species
	if(species && species.id == SPEC_ID_HUMEN)
		species.native_language = "Zalad"
		species.accent_language = species.get_accent(species.native_language)

/datum/outfit/adventurer/lancer
	name = "Lancer (Adventurer)"

	pants = /obj/item/clothing/pants/tights/colored/black
	beltl = /obj/item/storage/belt/pouch/coins/mid
	shoes = /obj/item/clothing/shoes/boots/rare/zaladplate
	gloves = /obj/item/clothing/gloves/rare/zaladplate
	belt = /obj/item/storage/belt/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	armor = /obj/item/clothing/armor/rare/zaladplate
	backl = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/head/rare/zaladplate
	wrists = /obj/item/clothing/wrists/bracers
	neck = /obj/item/clothing/neck/chaincoif

/datum/outfit/adventurer/lancer/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	var/randy = rand(1,5)
	switch(randy)
		if(1 to 2)
			backr = /obj/item/weapon/polearm/halberd/bardiche
		if(3 to 4)
			backr = /obj/item/weapon/polearm/eaglebeak
		if(5)
			backr = /obj/item/weapon/polearm/spear/billhook
