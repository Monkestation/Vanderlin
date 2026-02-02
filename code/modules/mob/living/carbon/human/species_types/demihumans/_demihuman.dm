	/*=================*
	*				   *
	*	 Hollow-kin	   *
	*				   *
	*==================*/

// ( -1 STR, +2 PER, +1 INT, -1 CON, +1 SPD, -1 FOR)

/mob/living/carbon/human/species/demihuman
	race = /datum/species/demihuman

/datum/species/demihuman
	name = "Hollow-Kin"
	id = SPEC_ID_HOLLOWKIN
	desc = "Hollowkin are short lived, widely diverse, and have an insatiable hatred for dark elves. \
	This hate stems from their long standing political neighbor and rival, \
	the Zizonic dark-elven kingdoms of Subterra. \
	Dendor and Xylix stand as the 'patron-deities' of this species despite having no hand in their creation. \
	Hollowkin view freedom to be of the upmost importance due to their dark-elven neighbors' tendencies toward slavery and their own history of subjugation. \
	They also, often mistakenly, worship Dendor for the boon of their animalistic nature, perceiving him as the source of their traits, talents, and instinct. \
	\n\n\
	Their true origin is much darker. Hollowkin are the product of dark-elven ingenuity and fleshcrafting. \
	Their creation is a simple story of malice and greed- of sapient animal hybrid slave homunculi, \
	a person turned product which they could market and sell to other great houses of modern Zizonic Subterra. \
	The true nature of their existence is largely lost to the hollowkin through centuries. \
	The dark elves still recall, of course, viciously mocking their creations from deep within their caves, \
	declaring them but nothing more than animals or pets. \
	Hollowkin react violently to dark-elven attempts at oppression, this leads to conflicts across the world of Psydonia. \
	\n\n\
	To the unaligned observer, hollowkin are often seen amongst bandit bands, working openly with Agents of Matthios, \
	conflating the idea of freedom between the two deities. There is, of course, the old wives' tales that circulate... \
	how hollowkin lead to infestations of Werewolves. Hollowkin are often denied nobility from this rumour alone. \
	Whether this is true or not is unknown to the common person, \
	but to those familiar with the horrendous magics used by the dark elves, they must only assume the worst. \
	\n\n\
	THIS IS A DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. PLAY AT YOUR OWN RISK."

	allowed_pronouns = PRONOUNS_LIST
	skin_tone_wording = "Ancestry"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR, HAIR ,FACEHAIR, LIPS, STUBBLE, OLDGREY)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = TRUE
	possible_ages = NORMAL_AGES_LIST_CHILD
	disliked_food = NONE
	liked_food = NONE
	changesource_flags = WABBAJACK

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'

	exotic_bloodtype = /datum/blood_type/human/demihuman

	offset_features_m = list(
		OFFSET_RING = list(0,1),\
		OFFSET_GLOVES = list(0,1),\
		OFFSET_WRISTS = list(0,1),\
		OFFSET_HANDS = list(0,1),\
		OFFSET_CLOAK = list(0,1),\
		OFFSET_FACEMASK = list(0,1),\
		OFFSET_HEAD = list(0,1),\
		OFFSET_FACE = list(0,1),\
		OFFSET_BELT = list(0,1),\
		OFFSET_BACK = list(0,1),\
		OFFSET_NECK = list(0,1),\
		OFFSET_MOUTH = list(0,1),\
		OFFSET_PANTS = list(0,1),\
		OFFSET_SHIRT = list(0,1),\
		OFFSET_ARMOR = list(0,1),\
		OFFSET_UNDIES = list(0,1),\
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

	specstats_m = list(STATKEY_STR = -1, STATKEY_PER = 2, STATKEY_INT = 1, STATKEY_CON = -1, STATKEY_SPD = 1, STATKEY_LCK = -1)
	specstats_f = list(STATKEY_STR = -1, STATKEY_PER = 2, STATKEY_INT = 1, STATKEY_CON = -1, STATKEY_SPD = 1, STATKEY_LCK = -1)

	enflamed_icon = "widefire"

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail,
	)
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/organ/ears/demihuman,
		/datum/customizer/organ/horns/demihuman,
		/datum/customizer/organ/tail/demihuman,
	)

	descriptor_choices = list(
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/skin,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one_wild,
		/datum/descriptor_choice/prominent_two_wild,
		/datum/descriptor_choice/prominent_three_wild,
		/datum/descriptor_choice/prominent_four_wild,
	)

/datum/species/demihuman/get_hairc_list()
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

	"orange - flame" = "b24c2e"

	))

/datum/species/demihuman/check_roundstart_eligible()
	return TRUE

/datum/species/demihuman/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/demihuman/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)

/datum/species/demihuman/after_creation(mob/living/carbon/C)
	. = ..()
	C.grant_language(/datum/language/beast)
	to_chat(C, "<span class='info'>I can speak Beastish with ,b before my speech.</span>")

/datum/species/demihuman/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	C.remove_language(/datum/language/beast)

/datum/species/demihuman/get_skin_list()
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
		"Desert" = SKIN_COLOR_DESERT, //  - (Middle-east)
		"Crimson Lands" = SKIN_COLOR_CRIMSONLANDS, // - (Black)
	))
