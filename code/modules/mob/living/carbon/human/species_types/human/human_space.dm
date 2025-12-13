	/*==============*
	*				*
	*	 Human		*
	*				*
	*===============*/

//	( +1 STR, +1 PER, +4 INT, +1 CON, +2 END, +2 SPD -1 FOR)

/mob/living/carbon/human/species/human/space
	race = /datum/species/human/space

/datum/species/human/space
	name = "Human"
	id = SPEC_ID_HUMAN_SPACE
	desc = "A space-faring species. \
	\n\n\
	Humans have long since departed from the restraints of their homeworld, 'Earth.' \
	Most live within megacorporation jurisdiction, TerraGov space, or politically irrelevant planetary colonies. \
	Most humans rightfully avoid this section of space, however the corporation Interdyne Pharmaceuticals \
	avoids these warnings with Syndicate backing, repeatedly attempting planetary landing in effort to create \
	some nondescript bioweapon under codename 'Romero.' \
	\n\n\
	While genetic alteration technologies allow for a wide range of hair colours, \
	only those considered 'natural' are allowed on missions to Psydonia. They are expected to blend in \
	with the local- and strikingly similar- 'humen' species population due to difficulties of extraction. \
	\n\n\
	Human bodies have largely adapted to their space-faring lifestyle. Through their training, their physical \
	abilities largely overshadow most Psydonia-native species, divine or otherwise. A human's intelligence and knowledge \
	VASTLY dwarfs anything seen on the planet. However, the gods of Psydonia do not smile upon them. They must stay \
	covert, or face an another immediate sunbeam to their location."

	skin_tone_wording = "Ancestry"

	default_color = "FFFFFF"
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, STUBBLE, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)
	use_skintones = TRUE

	possible_ages = NORMAL_AGES_LIST

	changesource_flags = WABBAJACK

	limbs_icon_m = 'icons/roguetown/mob/bodies/male/regular.dmi'	//If we want to be funny, change these in the future? Has to be subtle.
	limbs_icon_f = 'icons/roguetown/mob/bodies/female/regular.dmi'	//We don't want this species to be meta-detectable.

	soundpack_m = /datum/voicepack/male						//Also a funny potential switch, more feasible to stay covert given that this is tied to emotes almost exclusively.
	soundpack_f = /datum/voicepack/female

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

	specstats_m = list(STATKEY_STR = 1, STATKEY_PER = 1, STATKEY_INT = 4, STATKEY_CON = 1, STATKEY_END = 2, STATKEY_SPD = 2, STATKEY_LCK = -1)
	specstats_f = list(STATKEY_STR = 1, STATKEY_PER = 1, STATKEY_INT = 4, STATKEY_CON = 1, STATKEY_END = 2, STATKEY_SPD = 2, STATKEY_LCK = -1)

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

/datum/species/human/space/check_roundstart_eligible()
	return FALSE

/datum/species/human/space/get_skin_list()	//These display pretty overtly upon examine, needs to be humen identical.
	return sortList(list(
		"Pale" = SKIN_COLOR_ICECAP, // - (Pale)
		"Arctic" = SKIN_COLOR_ARCTIC, // - (White 1)
		"Tundra" = SKIN_COLOR_TUNDRA, // - (White 2)
		"Continental" = SKIN_COLOR_CONTINENTAL, // - (White 3)
		"Temperate" = SKIN_COLOR_TEMPERATE, // - (White 4)
		"Coastal" = SKIN_COLOR_COASTAL, // - (Latin)
		"Subtropical" = SKIN_COLOR_SUBTROPICAL, // - (Mediterranean)
		"Tropical Dry" = SKIN_COLOR_TROPICALDRY, // - (Mediterranean 2)
		"Tropical Wet" = SKIN_COLOR_TROPICALWET, // - (Latin 2)
		"Desert" = SKIN_COLOR_DESERT, //  - (Middle-east)
		"Crimson Lands" = SKIN_COLOR_CRIMSONLANDS, // - (Black)
	))

/datum/species/human/space/get_hairc_list()
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
	"red - maroon" = "612929"

	))

/datum/species/human/space/get_possible_names(gender = MALE)
	var/static/list/male_names = world.file2list('strings/rt/names/human/humnorm.txt')
	var/static/list/female_names = world.file2list('strings/rt/names/human/humnorf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/human/space/get_possible_surnames(gender = MALE)
	var/static/list/last_names = world.file2list('strings/rt/names/human/humnorlast.txt')
	return last_names
