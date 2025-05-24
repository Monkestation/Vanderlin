	/*==============*
	*				*
	*	Half-Drow	*
	*				*
	*===============*/

/mob/living/carbon/human/species/human/halfdrow
	race = /datum/species/human/halfdrow

/datum/species/human/halfdrow
	name = "Half-Drow"
	id = "human"
	desc = "The child of a Dark Elf and Humen. \
	\n\n\
	The distinction between Half-Elves and 'Half-Drow' has been a subject of debate for centuries. \
	While similar in physicality and longevity to their non-drow cousins, their origins cause them to face discrimination akin to their elven side. \
	\n\n\
	Groups of half-elves and half-drow have been known to congregate together and consider themselves one species. \
	According to some radical academic scholars, they might be one species indeed- yet the people of Psydonia certainly do not believe the same at large. \
	\n\
	THIS IS A DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. <B>NOBLES EVEN MORE SO.</B> PLAY AT YOUR OWN RISK."

	skin_tone_wording = "Half-Drow Identity"

	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)
	customizers = list(
		/datum/customizer/organ/ears/elf,
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
	)
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/elf/less,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/elf,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)

	use_skintones = 1
	possible_ages = NORMAL_AGES_LIST_CHILD
	disliked_food = NONE
	liked_food = NONE
	changesource_flags = WABBAJACK
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mm.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon_m = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	hairyness = "t2"
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(OFFSET_RING = list(0,0), OFFSET_GLOVES = list(0,0), OFFSET_WRISTS = list(0,0),\
	OFFSET_CLOAK = list(0,0), OFFSET_FACEMASK = list(0,0), OFFSET_HEAD = list(0,0), \
	OFFSET_FACE = list(0,0), OFFSET_BELT = list(0,0), OFFSET_BACK = list(0,0), \
	OFFSET_NECK = list(0,0), OFFSET_MOUTH = list(0,0), OFFSET_PANTS = list(0,0), \
	OFFSET_SHIRT = list(0,0), OFFSET_ARMOR = list(0,0), OFFSET_HANDS = list(0,0), OFFSET_UNDIES = list(0,0), \
	OFFSET_RING_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
	OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
	OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,-1), OFFSET_BACK_F = list(0,-1), \
	OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
	OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,0))
	specstats = list(STATKEY_STR = 0, STATKEY_PER = 1, STATKEY_INT = 1, STATKEY_CON = 0, STATKEY_END = 0, STATKEY_SPD = 1, STATKEY_LCK = 0)
	specstats_f = list(STATKEY_STR = 0, STATKEY_PER = 1, STATKEY_INT = 1, STATKEY_CON = 0, STATKEY_END = 0, STATKEY_SPD = 1, STATKEY_LCK = 0)
	enflamed_icon = "widefire"

	body_markings = list(
		/datum/body_marking/tonage,
	)

/datum/species/human/halfdrow/check_roundstart_eligible()
	return TRUE

/datum/species/human/halfdrow/get_skin_list()
	return sortList(list(
		"Zizo-Cursed" = SKIN_COLOR_ZIZO_CURSED, // - (Pale)
		"Parasite-Taineted" = SKIN_COLOUR_PARASITE_TAINTED, // - (Light purple)
		"Mushroom-Minded" = SKIN_COLOR_MUSHROOM_MINDED, // - (Mid purple)
		"Cave-Attuned" = SKIN_COLOR_CAVE_ATTUNED, // - (Deep purple)
		"Fungus-Stained" = SKIN_COLOR_FUNGUS_STAINED, // - (Pink)
		"Depth-Departed" = SKIN_COLOR_DEPTH_DEPARTED, // - (Grey-blue)
	))

/datum/species/human/halfdrow/get_hairc_list()
	return sortList(list(
	"black - oil" = "181a1d",
	"black - cave" = "201616",
	"black - rogue" = "2b201b",
	"black - midnight" = "1d1b2b",

	"brown - mud" = "362e25",
	"brown - oats" = "584a3b",
	"brown - grain" = "58433b",
	"brown - soil" = "48322a",

	"red - berry" = "b23434",
	"red - wine" = "82534c",
	"red - sunset" = "82462b",
	"red - blood" = "822b2b",
	"red - maroon" = "612929",

	"blond - pale" = "9d8d6e",
	"blond - dirty" = "88754f",
	"blond - drywheat" = "d5ba7b",
	"blond - strawberry" = "c69b71",

	"white - ice" = "f4f4f4",
	"white - cavedew" = "dee9ed",
	"white - spiderweb" = "f4f4f4"

	))

/datum/species/human/halfdrow/get_possible_names(gender = MALE)
	var/static/list/male_names = world.file2list('strings/rt/names/elf/elfwm.txt')
	var/static/list/female_names = world.file2list('strings/rt/names/elf/elfwf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/human/halfdrow/get_possible_surnames(gender = MALE)
	return null

/datum/species/human/halfdrow/after_creation(mob/living/carbon/human/C)
	..()
	if(C.skin_tone == SKIN_COLOR_ZIZO_CURSED)
		exotic_bloodtype = /datum/blood_type/human/cursed_elf
	C.grant_language(/datum/language/elvish)
	to_chat(C, "<span class='info'>I can speak Elvish with ,e before my speech.</span>")

/datum/species/human/halfdrow/get_native_language()
	return pick("Elfish", "Imperial")
