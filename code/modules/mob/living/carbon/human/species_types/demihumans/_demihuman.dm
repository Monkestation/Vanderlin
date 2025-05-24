/mob/living/carbon/human/species/demihuman
	race = /datum/species/demihuman

/datum/species/demihuman
	name = "Hollow-Kin"
	id = "demihuman"
	desc = "Amber Hollow is a \"nation\" to the North of Vanderlin and East of Rosewood. It is located atop a great, earthen mound of tightly-rooted Redwoods. At this mound's peak lies a chasm, bordered by a woven, almost quilt-like ring of sequoias. This chasm is the largest entry point of many in Psydonia to Subterra, the land of the drow.\
	This ring has been built upon and turned into a civilization of Hollowkin, a people showing traits of an animal nature. These people are short lived, diverse, and have an insatiable hatred for drow. This hate has been from their long standing political neighbor, the dark-elven kingdoms of Subterra.\
	The patrons of these people are by in large Dendor and Xylix. They view freedom to be of the upmost importance due to their dark-elven neighbors' tendencies toward slavery and their own history of subjugation. They worship Dendor for the boon of their animalistic nature, seeing him as the provider for their traits and talents.\
	In actuality, however, they are the product of dark-elven ingenuity and fleshcrafting. Their creation is a simple story of malice and greed- the desire for a house slave that is cute and cat-like, a person turned product which they could market and sell to other great houses of modern Zizonian Subterra. \
	The history of their origin was centuries ago, and the true nature of their existence is largely lost to the Hollowkin. The drow still recall, of course, viciously mocking their creations from deep within their caves, treating them but nothing more than animals or pets. The Hollowkin react violently to drow attempts at oppression, this leads to conflicts across the world of Psydonia.\
	To the unaligned observer, Hollowkin are often seen amongst bandit bands, Working openly with Agents of Matthios, conflating the idea of freedom between the two deities. There is, of course, the old wives' tales that circulate... how Hollowkin lead to infestations of Werewolves. Weather this is true or not is unknown to the normal man, but to those familiar with the horrendous magics used by the drow, they have no choice but to assume. To Orcs and goblins, they are good eats.\
	Hollowkin are often denied nobility due to these rumors alone, though their animalism certainly does not help. If one miraculously does appear in the court, they are treated at best like a pet, though more likely distrusted as just another bandit people of Amber Hollow."
	skin_tone_wording = "Ancestry"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = TRUE
	possible_ages = NORMAL_AGES_LIST_CHILD
	disliked_food = NONE
	liked_food = NONE
	changesource_flags = WABBAJACK
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon_m = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	exotic_bloodtype = /datum/blood_type/human/demihuman
	offset_features = list(
		OFFSET_RING = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,1), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_RING_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		)
	specstats = list(STAT_PERCEPTION = 1)
	specstats_f = list(STAT_PERCEPTION = 1)
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

	patreon_req = TRUE

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
	"red - maroon" = "612929"

	))

/datum/species/demihuman/check_roundstart_eligible()
	return TRUE

/datum/species/demihuman/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/demihuman/on_species_gain(mob/living/carbon/foreign, datum/species/old_species)
	..()
	foreign.grant_language(/datum/language/common)
//	languages(foreign)

/*
/datum/species/demihuman/proc/languages(mob/living/carbon/human/foreign)
	if(foreign.skin_tone == SKIN_COLOR_GRENZELHOFT)
		foreign.grant_language(/datum/language/grenzelhoftian)
*/

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
