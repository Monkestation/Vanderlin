	/*==============*
	*				*
	*		Elf		*
	*				*
	*===============*/

//	( + Night Vision )


/mob/living/carbon/human/species/elf/snow
	race = /datum/species/elf/snow

/datum/species/elf/snow
	name = "Elf"
	id = SPEC_ID_ELF
	desc = "Necra's guides.\
	\n\n\
	Elves, created by Necra to guide humenity, are characterized by lengthened age, \
	low fertility, and a magical aptitude originating from a vast array of tribal cultures. \
	With the ascension of Zizo, the entire culture of snow-elves was all but destroyed, \
	leading the remaining tribes to live in fear and paranoia of suffering the same fate. \
	Many elves sought safety through mixing culture, \
	positioning themselves under the watchful guard of their stronger humen counterparts. \
	\n\n\
	A longstanding feud remains between elves and dwarves. \
	Elvenkind has yet to forgive the dwarves for their destruction of homeland \
	and pillaging of natural resources within the former snow-elf territory. \n\
	To elves, it was the greatest disrespect to those lost. "

	skin_tone_wording = "Tribal Identity"

	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)
	use_skintones = 1
	disliked_food = NONE
	liked_food = NONE
	possible_ages = NORMAL_AGES_LIST_CHILD
	changesource_flags = WABBAJACK
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/met.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/ft.dmi'
	hairyness = "t1"

	customizers = list(
		/datum/customizer/organ/ears/elf,
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
	)

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/elf,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/elfw,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)

	swap_male_clothes = TRUE

	soundpack_m = /datum/voicepack/male/elf
	soundpack_f = /datum/voicepack/female/elf

	offset_features_m = list(
		OFFSET_RING = list(0,2),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,1),\
		OFFSET_HANDS = list(0,2),\
		OFFSET_CLOAK = list(0,2),\
		OFFSET_FACEMASK = list(0,1),\
		OFFSET_HEAD = list(0,1),\
		OFFSET_FACE = list(0,1),\
		OFFSET_BELT = list(0,1),\
		OFFSET_BACK = list(0,2),\
		OFFSET_NECK = list(0,1),\
		OFFSET_MOUTH = list(0,2),\
		OFFSET_PANTS = list(0,2),\
		OFFSET_SHIRT = list(0,2),\
		OFFSET_ARMOR = list(0,2),\
		OFFSET_UNDIES = list(0,0),\
	)

	offset_features_f = list(
		OFFSET_RING = list(0,0),\
		OFFSET_GLOVES = list(0,1),\
		OFFSET_WRISTS = list(0,1),\
		OFFSET_HANDS = list(0,1),\
		OFFSET_CLOAK = list(0,1),\
		OFFSET_FACEMASK = list(0,0),\
		OFFSET_HEAD = list(0,0),\
		OFFSET_FACE = list(0,0),\
		OFFSET_BELT = list(0,1),\
		OFFSET_BACK = list(0,0),\
		OFFSET_NECK = list(0,0),\
		OFFSET_MOUTH = list(0,0),\
		OFFSET_PANTS = list(0,1),\
		OFFSET_SHIRT = list(0,1),\
		OFFSET_ARMOR = list(0,1),\
		OFFSET_UNDIES = list(0,1),\
	)

	specstats_m = list(STATKEY_STR = -1, STATKEY_PER = 1, STATKEY_INT = 1, STATKEY_CON = -1, STATKEY_END = 0, STATKEY_SPD = 2, STATKEY_LCK = 0)
	specstats_f = list(STATKEY_STR = -1, STATKEY_PER = 1, STATKEY_INT = 1, STATKEY_CON = -1, STATKEY_END = 0, STATKEY_SPD = 2, STATKEY_LCK = 0)
	enflamed_icon = "widefire"

	body_markings = list(
		/datum/body_marking/tonage,
	)

/datum/species/elf/snow/check_roundstart_eligible()
	return TRUE

/datum/species/elf/snow/get_span_language(datum/language/message_language)
	if(!message_language)
		return
//	if(message_language.type == /datum/language/elvish)
//		return list(SPAN_SELF)
//	if(message_language.type == /datum/language/common)
//		return list(SPAN_SELF)
	return message_language.spans

/datum/species/elf/snow/get_skin_list()
	return sortList(list(
		"Plain Elf" = SKIN_COLOR_PLAIN_ELF, // - (White 2)
		"Mountain Elf" = SKIN_COLOR_MOUNTAIN_ELF, // - (White 3)
		"Coastal Elf" = SKIN_COLOR_COASTAL_ELF, // - (White 4)
		"Wood Elf" = SKIN_COLOR_WOOD_ELF, // - (Mediterranean 1)
		"Sea Elf" = SKIN_COLOR_SEA_ELF, // - (Mediterranean 2)
		"Jungle Elf" = SKIN_COLOR_JUNGLE_ELF, // - (Latin)
		"Savannah Elf" = SKIN_COLOR_SAVANNAH_ELF, // - (Middle-Eastern 1)
		"Desert Elf" = SKIN_COLOR_DESERT_ELF, // - (Middle-Eastern 2)
		"Sand Elf" = SKIN_COLOR_SAND_ELF, // - (Black 1)
		"Crimson Elf" = SKIN_COLOR_CRIMSON_ELF, // - (Black2)
		"Bayou Elf" = SKIN_COLOR_BAYOU_ELF, // - (Native American 1)
		"Taiga Elf" = SKIN_COLOR_TAIGA_ELF, // - (Native American 2)
		"Archipelago Elf" = SKIN_COLOR_ARCHIPELAGO_ELF, // - (Polynesian)
		"Volcano Elf" = SKIN_COLOR_VOLCANO_ELF, // (Melanesian)
	))

/datum/species/elf/snow/get_hairc_list()
	return sortList(list(
	"black - oil" = "181a1d",
	"black - cave" = "201616",
	"black - rogue" = "2b201b",
	"black - midnight" = "1d1b2b",

	"blond - pale" = "9d8d6e",
	"blond - dirty" = "88754f",
	"blond - drywheat" = "d5ba7b",
	"blond - strawberry" = "c69b71",

	"white - snow" = "dee9ed",
	"white - ice" = "f4f4f4",

	"brown - mud" = "362e25",
	"brown - oats" = "584a3b",
	"brown - grain" = "58433b",
	"brown - soil" = "48322a",
	"brown - bark" = "2d1300",

	"red - berry" = "b23434",
	"red - wine" = "82534c",
	"red - sunset" = "82462b",
	"red - blood" = "822b2b",
	"red - maroon" = "612929",

	"green - grass" = "2a482c",
	"green - swamp" = "3b482a",
	"green - leaf" = "2f3c2e",
	"green - moss" = "3b3c2a"

	))

/datum/species/elf/snow/get_possible_names(gender = MALE)
	var/static/list/male_names = world.file2list('strings/rt/names/elf/elfwm.txt')
	var/static/list/female_names = world.file2list('strings/rt/names/elf/elfwf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/elf/snow/get_possible_surnames(gender = MALE)
	var/static/list/last_names = world.file2list('strings/rt/names/elf/elfwlast.txt')
	return last_names

/datum/species/elf/snow/after_creation(mob/living/carbon/C)
	C.dna.species.accent_language = C.dna.species.get_accent(C.dna.species.native_language, 1)
