#define DIET_HARPY list(/obj/item/natural/worms/grub_silk, /obj/item/natural/worms) + typesof(/obj/item/neuFarm/seed)

/mob/living/carbon/human/species/harpy
	race = /datum/species/harpy

/datum/species/harpy
	name = "Harpy"
	id = SPEC_ID_HARPY
	desc = "Harpies, or less ceremoniously known as 'magpies,' resemble the despised hollow-kin in appearance at first glance. \
	One would rightfully assume they are similar in nature- with accuracy even, much to the harpies' chagrin. \
	Harpies have been uplifted and reconnected to divinity by Eora, having developed culture of music and song which caught the attention of such a goddess. \
	Their songs and voices may be their own, or proud mimicking other voices they've heard with unnatural accuracy. \
	\
	Whilst harpies may fly, their freedom is weighed by corruption of fleshcrafting to this day. Complete open-air freedom is still foreign to them. \
	Harpies tend to live and gather in colonies at the tops of great sequoia forests and in nearby cliffs. Due to their laden flight, they must employ use of updrafts and proximity to large objects or structures to bolster their limited range and air-dancing performances. \
	Their serene songs and blissful music can be heard echoing far below, guiding travelers and thieves both to respite... or treasure. For as lifted into grace as they might be, these 'magpies' earn such a nickname from instinctual Matthiosan greed and love for anything that shines. \
	Yet if one can work past that distrust and compensate them well, harpies make for unparalleled couriers. \
	\
	Harpies and Feculents often find themselves in conflict, mirroring the quarrels of their patrons, whether of conscious faith or not."

	skin_tone_wording = "Heritage"
	default_color = "FFFFFF"

	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, STUBBLE, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)
	inherent_skills = list(
		/datum/skill/misc/music = 1,
	)

	use_skintones = TRUE
	possible_ages = NORMAL_AGES_LIST_CHILD
	changesource_flags = WABBAJACK

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/harpy.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/harpy.dmi'

	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female

	//related to preening emote - lets preening be used roundstart
	COOLDOWN_DECLARE(time_to_next_preen)

	offset_features_m = list(
		OFFSET_RING = list(0,1),\
		OFFSET_GLOVES = list(0,1),\
		OFFSET_WRISTS = list(0,1),\
		OFFSET_HANDS = list(0,1),\
		OFFSET_CLOAK = list(0,1),\
		OFFSET_FACEMASK = list(0,1),\
		OFFSET_HEAD = list(0,1),\
		OFFSET_FACE = list(0,0),\
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

	inherent_traits = list(TRAIT_HOLLOWBONES, TRAIT_AMAZING_BACK, TRAIT_DODGEEXPERT)

	specstats_m = list(STATKEY_STR = -4, STATKEY_PER = 2, STATKEY_INT = 1, STATKEY_CON = -4, STATKEY_END = 0, STATKEY_SPD = 3, STATKEY_LCK = 0)
	specstats_f = list(STATKEY_STR = -4, STATKEY_PER = 2, STATKEY_INT = 1, STATKEY_CON = -4, STATKEY_END = 0, STATKEY_SPD = 3, STATKEY_LCK = 0)

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
		ORGAN_SLOT_VOICE = /obj/item/organ/vocal_cords/harpy,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/harpy,
		ORGAN_SLOT_WINGS = /obj/item/organ/wings/flight/harpy,
	)

	meat = /obj/item/reagent_containers/food/snacks/meat/poultry/cutlet

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
		/datum/customizer/organ/tail/harpy,
		/datum/customizer/organ/wings/harpy,
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

/datum/species/harpy/get_hairc_list()
	return sortList(list(
	"black - raven" = "1a1d21",
	"black - magpie" = "1d1b2b",

	"brown - hawk" = "201616",
	"brown - falcon" = "2b201b",

	"red - sparrow" = "2d1300",
	"red - robin" = "612929",
	"red - cardinal" = "822b2b",

	"grey - osprey" = "7c828a",

	"orange - oriole" = "d55f2a",

	"white - swan" = "d3d9e3",
	"white - egret" = "dee9ed",
	"white - owl" = "f4f4f4",

	"yellow - parakeet" = "d5ba7b",
	"yellow - goldfinch" = "c69b71",

	"pink - cockatoo" = "ead6e2",

	"blue - jay" = "a1b4d4"
	))

/datum/species/harpy/check_roundstart_eligible()
	return TRUE

/datum/species/harpy/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/harpy/on_species_gain(mob/living/carbon/foreign, datum/species/old_species)
	..()
	foreign.AddComponent(/datum/component/abberant_eater, DIET_HARPY, TRUE)
	foreign.grant_language(/datum/language/common)

/datum/species/harpy/get_skin_list()
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

#undef DIET_HARPY
