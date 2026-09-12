/datum/attribute_holder/sheet/job/courtagent/dunewalker
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_SPEED = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = -1,
		/datum/attribute/skill/combat/knives = 40,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/sneaking = 50,
		/datum/attribute/skill/misc/stealing = 40,
		/datum/attribute/skill/misc/lockpicking = 40,
		/datum/attribute/skill/craft/traps = 20,
	)

/datum/job/advclass/courtagent/dunewalker
	title = "Zalad Dunewalker"
	tutorial = "You are one of the Hand's loyal Agents. \
	Hailing from Zalad lands you are a master thief and unseen killer. \
	In service to the Hand of Vanderlin following an unfortunate incident with an Emir back home, \
	you now put your expertise to use in acquiring items of interest for your master, disposing of their owners when needed."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_ELF,\
		SPEC_ID_RAKSHARI,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_TIEFLING,\
		SPEC_ID_DROW,\
		SPEC_ID_HALF_DROW,\
	)
	outfit = /datum/outfit/courtagent/dunewalker
	category_tags = list(CTAG_COURTAGENT)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/dunewalker

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_LIGHT_STEP,
		TRAIT_DUALWIELDER,
	)

	languages = list(/datum/language/zalad)

/datum/job/advclass/courtagent/dunewalker/after_spawn(mob/living/carbon/human/spawned, client/player_client)
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

/datum/outfit/courtagent/dunewalker
	name = "Zalad Dunewalker (Court Agent)"
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/shalal
	gloves = /obj/item/clothing/gloves/angle
	belt = /obj/item/storage/belt/leather/shalal/courtagent
	beltl = /obj/item/weapon/knife/dagger/steel/special
	beltr = /obj/item/weapon/knife/dagger/steel/special
	shirt = /obj/item/clothing/shirt/undershirt/colored/red
	armor = /obj/item/clothing/armor/leather/splint
	backl = /obj/item/storage/backpack/satchel/black
	head = /obj/item/clothing/neck/keffiyeh/colored/red
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
	)

