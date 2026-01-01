/datum/job/advclass/adventurer/qatil
	title = "Qatil"
	tutorial = "Hailing from Zalad lands, you are a killer for hire that is trained both in murdering unseen and seen with your trusty knife."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_ELF,\
		SPEC_ID_RAKSHARI,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_TIEFLING,\
		SPEC_ID_DROW,\
		SPEC_ID_HALF_DROW,\
	)
	outfit = /datum/outfit/adventurer/qatil
	total_positions = 1
	roll_chance = 25
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'

	skills = list(
		/datum/skill/combat/knives = 4,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/bows = 2,
		/datum/skill/misc/athletics = 4,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/sneaking = 4,
		/datum/skill/misc/stealing = 2,
		/datum/skill/misc/lockpicking = 3,
		/datum/skill/craft/traps = 1,
	)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 2,
		STATKEY_END = 1,
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
	)

	languages = list(/datum/language/zalad)

/datum/job/advclass/adventurer/qatil/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/datum/species/species = spawned.dna?.species
	if(!species)
		return

	if(species.id == SPEC_ID_HUMEN)
		species.native_language = "Zalad"
		species.accent_language = species.get_accent(species.native_language)

	else if((species.id == SPEC_ID_HALF_ELF) || (species.id == SPEC_ID_HALF_DROW))
		if(species.native_language == "Imperial")
			species.native_language = "Zalad"
			species.accent_language = species.get_accent(species.native_language)

/datum/outfit/adventurer/qatil
	name = "Qatil (Adventurer)"
	pants = /obj/item/clothing/pants/trou/leather
	beltr = /obj/item/weapon/knife/dagger/steel/special
	shoes = /obj/item/clothing/shoes/shalal
	gloves = /obj/item/clothing/gloves/angle
	belt = /obj/item/storage/belt/leather/shalal
	shirt = /obj/item/clothing/shirt/undershirt/colored/red
	armor = /obj/item/clothing/armor/leather/splint
	backl = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/neck/keffiyeh/colored/red
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/lockpick = 1
	)

