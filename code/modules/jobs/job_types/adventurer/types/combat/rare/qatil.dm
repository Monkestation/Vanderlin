/datum/attribute_holder/sheet/job/qatil
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_SPEED = 2,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/knives = 40,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/misc/stealing = 20,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/craft/traps = 10,
	)

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
	roll_chance = 10
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/qatil

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

