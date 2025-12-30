/datum/job/advclass/pilgrim/rare/zaladin
	title = "Zaladin Emir"
	tutorial = "An Emir hailing from Deshret, here on business for the Mercator's Guild."
	allowed_races = RACES_PLAYER_ZALADIN
	outfit = /datum/outfit/pilgrim/zalad
	category_tags = list(CTAG_PILGRIM)
	total_positions = 1
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'
	is_recognized = TRUE

	jobstats = list(
		STATKEY_INT = 1,
		STATKEY_END = 2
	)

	skills = list(
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/riding = 4,
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/music = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/craft/cooking = 2,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/labor/mathematics = 3
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_NOBLE,
		TRAIT_FOREIGNER
	)

	languages = list(/datum/language/zalad)

/datum/job/advclass/pilgrim/rare/zaladin/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	var/honorary = "Emir"
	if(spawned.pronouns == SHE_HER)
		honorary = "Amirah"
	spawned.real_name = "[honorary] [prev_real_name]"
	spawned.name = "[honorary] [prev_name]"

	if(spawned.dna?.species)
		if(spawned.dna.species.id == SPEC_ID_HUMEN)
			spawned.dna.species.native_language = "Zalad"
			spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)
		if(spawned.dna.species.id == SPEC_ID_HALF_ELF)
			if(spawned.dna.species.native_language == "Imperial")
				spawned.dna.species.native_language = "Zalad"
				spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)

/datum/outfit/pilgrim/zalad
	name = "Zaladin Emir (Pilgrim)"
	shoes = /obj/item/clothing/shoes/shalal
	gloves = /obj/item/clothing/gloves/leather
	head = /obj/item/clothing/head/crown/circlet
	cloak = /obj/item/clothing/cloak/raincloak/colored/purple
	armor = /obj/item/clothing/armor/gambeson/arming
	belt = /obj/item/storage/belt/leather/shalal
	beltl = /obj/item/weapon/sword/sabre/shalal
	beltr = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/storage/backpack/satchel
	ring = /obj/item/clothing/ring/gold/guild_mercator
	shirt = /obj/item/clothing/shirt/tunic/colored/purple
	pants = /obj/item/clothing/pants/trou/leather
	neck = /obj/item/clothing/neck/shalal/emir
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/veryrich = 1)

/datum/outfit/pilgrim/zalad/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == FEMALE)
		shirt = /obj/item/clothing/shirt/dress/silkdress/colored/black
