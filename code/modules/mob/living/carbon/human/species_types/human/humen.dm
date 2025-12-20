	/*==============*
	*				*
	*	 Humen		*
	*				*
	*===============*/

//	( +1 Fortune )

/mob/living/carbon/human/species/human/northern
	race = /datum/species/human/northern

/datum/species/human/northern
	name = "Humen"
	id = SPEC_ID_HUMEN
	desc = "Humenity, created in Psydon's image. \
	\n\n\
	Humens come from a vast swathe of cultures and ethnicities all around Psydonia, most of which \
	have historically been at odds with both one another and other species. \
	With their tenacity and overwhelming population, humens tend to outnumber the other species drastically. \
	Their saturation leads to most world maps representing humen borders and states over other species'. \
	\n\n\
	Humens tend to find fortune easier than the other species, \
	and are so diverse that no other trait is dominant..."

	skin_tone_wording = "Ancestry"

	default_color = "FFFFFF"
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, STUBBLE, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)

	use_skintones = TRUE

	possible_ages = NORMAL_AGES_LIST_CHILD

	changesource_flags = WABBAJACK

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mm.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'

	offset_features_m = list(
		OFFSET_RING = list(0,0),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,0),\
		OFFSET_HANDS = list(0,0),\
		OFFSET_CLOAK = list(0,0),\
		OFFSET_FACEMASK = list(0,0),\
		OFFSET_HEAD = list(0,0),\
		OFFSET_FACE = list(0,0),\
		OFFSET_BELT = list(0,0),\
		OFFSET_BACK = list(0,0),\
		OFFSET_NECK = list(0,0),\
		OFFSET_MOUTH = list(0,0),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,0),\
		OFFSET_ARMOR = list(0,0),\
		OFFSET_UNDIES = list(0,0),\
	)

	offset_features_f = list(
		OFFSET_RING = list(0,-1),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,0),\
		OFFSET_HANDS = list(0,0),\
		OFFSET_CLOAK = list(0,0),\
		OFFSET_FACEMASK = list(0,-1),\
		OFFSET_HEAD = list(0,-1),\
		OFFSET_FACE = list(0,-1),\
		OFFSET_BELT = list(0,0),\
		OFFSET_BACK = list(0,-1),\
		OFFSET_NECK = list(0,-1),\
		OFFSET_MOUTH = list(0,-1),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,0),\
		OFFSET_ARMOR = list(0,0),\
		OFFSET_UNDIES = list(0,0),\
	)

	specstats_m = list(STATKEY_STR = 0, STATKEY_PER = 0, STATKEY_INT = 0, STATKEY_CON = 1, STATKEY_END = 2, STATKEY_SPD = 0, STATKEY_LCK = 1)
	specstats_f = list(STATKEY_STR = 0, STATKEY_PER = 0, STATKEY_INT = 0, STATKEY_CON = 1, STATKEY_END = 2, STATKEY_SPD = 0, STATKEY_LCK = 1)

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

/datum/species/human/northern/check_roundstart_eligible()
	return TRUE

/datum/species/human/northern/get_skin_list()
	return sortList(list(
		"Ice Cap" = SKIN_COLOR_ICECAP, // - (Pale)
		"Arctic" = SKIN_COLOR_ARCTIC, // - (White 1)
		"Tundra" = SKIN_COLOR_TUNDRA, // - (White 2)
		"Continental" = SKIN_COLOR_CONTINENTAL, // - (White 3)
		"Temperate" = SKIN_COLOR_TEMPERATE, // - (White 4)
		"Coastal" = SKIN_COLOR_COASTAL, // - (Latin)
		"Subtropical" = SKIN_COLOR_SUBTROPICAL, // - (Mediterranean)
		"Tropical Dry" = SKIN_COLOR_TROPICALDRY, // - (Mediterranean 2)
		"Tropical Wet" = SKIN_COLOR_TROPICALWET, // - (Latin 2)
		"Desert" = SKIN_COLOR_DESERT, //  - (Middle-east 1)
		"Oasis" = SKIN_COLOR_OASIS, // - (Middle-east 2)
		"Crimson Lands" = SKIN_COLOR_CRIMSONLANDS, // - (Black)
		"Volcanic" = SKIN_COLOR_VOLCANIC, // - Melanesian
		"Island" = SKIN_COLOR_ISLAND, // - Polynesian
		"Taiga" = SKIN_COLOR_TAIGA, // - Native American 1
		"Swamp" = SKIN_COLOR_SWAMP, // - Native American 2

	))

/datum/species/human/northern/get_hairc_list()
	return sortList(list(
	"blond - pale" = "9d8d6e",
	"blond - dirty" = "88754f",
	"blond - drywheat" = "d5ba7b",
	"blond - strawberry" = "c69b71",

	"brown - mud" = "362e25",
	"brown - oats" = "584a3b",
	"brown - grain" = "58433b",
	"brown - soil" = "48322a",
	"brown - bark" = "2d1300",

	"black - oil" = "181a1d",
	"black - cave" = "201616",
	"black - rogue" = "2b201b",
	"black - midnight" = "1d1b2b",

	"red - berry" = "b23434",
	"red - wine" = "82534c",
	"red - sunset" = "82462b",
	"red - blood" = "822b2b",
	"red - maroon" = "612929",

	"orange - rust" = "bc5e35"
	))

/datum/species/human/northern/get_possible_names(gender = MALE)
	var/static/list/male_names = world.file2list('strings/rt/names/human/humnorm.txt')
	var/static/list/female_names = world.file2list('strings/rt/names/human/humnorf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/human/northern/get_possible_surnames(gender = MALE)
	var/static/list/last_names = world.file2list('strings/rt/names/human/humnorlast.txt')
	return last_names
