	/*==============*
	*				*
	*	  Dwarf		*
	*				*
	*===============*/

//	( + Poison Resistance )

/mob/living/carbon/human/species/dwarf/mountain
	race = /datum/species/dwarf/mountain

/datum/species/dwarf/mountain
	name = "Dwarf"
	id = SPEC_ID_DWARF
	desc = "Shaped by Psydon and Necra, chosen by Malum.\
	\n\n\
	A proud and robust species of vertically challenged folk, \
	dwarves are known for their martial strength \
	and their tenacity towards their ancient customs of craft and honour. \
	Dwarves hold a strong alliance with humenkind and have done so throughout history, as was their original purpose decreed by Psydon. \
	A Dwarf, much like the rock that they carve their fortress out of, is stubborn and ancient. \
	\n\n\
	They are revered craftsmen, sculptors, smiths, and miners. \
	As an old and mostly out-of-date saying goes, \"If you want it done right, lose 2 feet and grow a beard.\" \
	\n\n\
	Despite their cultural praise, a long-standing feud remains between dwarves and elves \
	stemming from old industrial practices."

	skin_tone_wording = "Ore Attunement"

	default_color = "FFFFFF"
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, YOUNGBEARD, STUBBLE, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP, TRAIT_POISON_RESILIENCE)
	inherent_skills = list(
		/datum/skill/labor/mining = 1,
	)

	possible_ages = NORMAL_AGES_LIST
	use_skintones = TRUE

	changesource_flags = WABBAJACK

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/md.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fd.dmi'

	hairyness = "t3"

	soundpack_m = /datum/voicepack/male/dwarf
	soundpack_f = /datum/voicepack/female/dwarf

	custom_clothes = TRUE

	offset_features_m = list(
		OFFSET_RING = list(0,0),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,0),\
		OFFSET_HANDS = list(0,-3),\
		OFFSET_CLOAK = list(0,0),\
		OFFSET_FACEMASK = list(0,-4),\
		OFFSET_HEAD = list(0,-4),\
		OFFSET_FACE = list(0,-4),\
		OFFSET_BELT = list(0,0),\
		OFFSET_BACK = list(0,-4),\
		OFFSET_NECK = list(0,-4),\
		OFFSET_MOUTH = list(0,-4),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,0),\
		OFFSET_ARMOR = list(0,0),\
		OFFSET_UNDIES = list(0,0),\
	)

	offset_features_f = list(
		OFFSET_RING = list(0,-4),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,0),\
		OFFSET_HANDS = list(0,-4),\
		OFFSET_CLOAK = list(0,0),\
		OFFSET_FACEMASK = list(0,-5),\
		OFFSET_HEAD = list(0,-5),\
		OFFSET_FACE = list(0,-5),\
		OFFSET_BELT = list(0,0),\
		OFFSET_BACK = list(0,-5),\
		OFFSET_NECK = list(0,-5),\
		OFFSET_MOUTH = list(0,-5),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,0),\
		OFFSET_ARMOR = list(0,0),\
		OFFSET_UNDIES = list(0,0)\
	)

	specstats_m = list(STATKEY_STR = 1, STATKEY_PER = -2, STATKEY_INT = 0, STATKEY_CON = 2, STATKEY_END = 2, STATKEY_SPD = -1, STATKEY_LCK = 0)
	specstats_f = list(STATKEY_STR = 1, STATKEY_PER = -2, STATKEY_INT = 0, STATKEY_CON = 2, STATKEY_END = 2, STATKEY_SPD = -1, STATKEY_LCK = 0)

	enflamed_icon = "widefire"

	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
	)
	body_markings = list(
		/datum/body_marking/tonage,
	)

/datum/species/dwarf/mountain/check_roundstart_eligible()
	return TRUE

/datum/species/dwarf/mountain/get_span_language(datum/language/message_language)
	if(!message_language)
		return
	if(message_language.type == /datum/language/dwarvish)
		return list(SPAN_DWARF)
	return message_language.spans

/datum/species/dwarf/mountain/get_skin_list()
	return sortList(list(
		"Platinum" = SKIN_COLOR_PLATINUM, // - (White 1)
		"Aurum" = SKIN_COLOR_AURUM, // - (White 2)
		"Quicksilver" = SKIN_COLOR_QUICKSILVER, // - (White 3)
		"Brass" = SKIN_COLOR_BRASS, // - (White 4)
		"Iron" = SKIN_COLOR_IRON, // - (Tan)
		"Malachite" = SKIN_COLOR_MALACHITE, // - (Middle-Eastern)
		"Obsidian" = SKIN_COLOR_OBSIDIAN, // - (Black)
		"Brimstone" = SKIN_COLOR_BRIMSTONE, // - (Black 2)
		"Cerargyrite" =	SKIN_COLOR_CERARGYRITE, // - (Purple)
	))

/datum/species/dwarf/mountain/get_hairc_list()
	return sortList(list(
		"black - oil" = "181a1d",
		"black - cave" = "201616",
		"black - rogue" = "2b201b",
		"black - midnight" = "1d1b2b",

		"blond - pale" = "9d8d6e",
		"blond - dirty" = "88754f",
		"blond - drywheat" = "d5ba7b",
		"blond - strawberry" = "c69b71",

		"brown - mud" = "362e25",
		"brown - oats" = "7a4e1e",
		"brown - grain" = "58433b",
		"brown - soil" = "48322a",
		"brown - bark" = "2d1300",

		"red - berry" = "b23434",
		"red - wine" = "b87f77",
		"red - sunset" = "bf6821",
		"red - blood" = "822b2b",
		"red - maroon" = "612929",

		"white - withered" = "7c828a"
	))

/datum/species/dwarf/mountain/get_possible_names(gender = MALE)
	var/static/list/male_names = world.file2list('strings/rt/names/dwarf/dwarmm.txt')
	var/static/list/female_names = world.file2list('strings/rt/names/dwarf/dwarmf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/dwarf/mountain/get_possible_surnames(gender = MALE)
	var/static/list/last_names = world.file2list('strings/rt/names/dwarf/dwarmlast.txt')
	return last_names
