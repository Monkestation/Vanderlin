	/*==============*
	*				*
	*	Aasimar		*
	*				*
	*===============*/

//	( + Pain Resist )
//	( + Bleed Resist )

/mob/living/carbon/human/species/aasimar
	race = /datum/species/aasimar

/datum/species/aasimar
	name = "Aasimar"
	id = SPEC_ID_AASIMAR
	native_language = "Celestial"
	desc = "Immortal offspring sculpted by the gods for use in servitude. \
	\n\n\
	Aasimar roaming alone on Psydonia often are those abandoned after serving their purpose. \
	This species is often revered due to their celestial origin, \
	but face great solitude as not many of their kind exist. \
	Many an aasimar will detest the reverence in which they are greeted with, \
	for their greatest failure or unuse that lead to their discarding is not subject for celebration. \
	\n\n\
	An aasimar may be crafted with any number of materials. \
	Many resemble sculptures of stone or are ceramic in skin, \
	but their insides are just as mortal as any other. \
	Most Aasimar were created to serve The Ten, and few if any Psydonic Aasimar remain to this day- \
	decrepit husks of what were once great warriors. "

	skin_tone_wording = "Craft"

	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP, TRAIT_NOHYGIENE)
	use_skintones = TRUE

	possible_ages = list(AGE_IMMORTAL)
	changesource_flags = WABBAJACK

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mm.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'

	soundpack_m = /datum/voicepack/male/serious

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
		OFFSET_BELT = list(0,-1),\
		OFFSET_BACK = list(0,-1),\
		OFFSET_NECK = list(0,-1),\
		OFFSET_MOUTH = list(0,-1),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,0),\
		OFFSET_ARMOR = list(0,0),\
		OFFSET_UNDIES = list(0,0),\
	)

	specstats_m = list(STATKEY_STR = 0, STATKEY_PER = 0, STATKEY_INT = 2, STATKEY_CON = 1, STATKEY_END = 1, STATKEY_SPD = -1, STATKEY_LCK = 0)
	specstats_f = list(STATKEY_STR = 0, STATKEY_PER = 0, STATKEY_INT = 2, STATKEY_CON = 1, STATKEY_END = 1, STATKEY_SPD = -1, STATKEY_LCK = 0)

	enflamed_icon = "widefire"

	meat = /obj/item/natural/stone

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
	)

	body_markings = list(
		/datum/body_marking/tonage,
	)

	pain_mod = 0.9 // 10% less pain from wounds
	bleed_mod = 0.8 // 20% less bleed rate from injuries

/datum/species/aasimar/check_roundstart_eligible()
	return TRUE

/datum/species/aasimar/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)

/datum/species/aasimar/after_creation(mob/living/carbon/C)
	. = ..()
	C.grant_language(/datum/language/celestial)
	to_chat(C, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")

/datum/species/aasimar/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	C.remove_language(/datum/language/celestial)

/datum/species/aasimar/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/aasimar/get_skin_list()
	return sortList(list(
		"Coral" = SKIN_COLOR_CORAL, // - (Pink)
		"Soapstone" = SKIN_COLOR_SOAPSTONE, // - (Seafoam green)
		"Marble" = SKIN_COLOR_MARBLE, // - (White stone)
		"Silver" = SKIN_COLOR_SILVER, // - (Ice Grey)
		"Copper" = SKIN_COLOR_COPPER, // - (Orange)
		"Gold" = SKIN_COLOR_GOLD, // - (Yellow)
		"Rust" = SKIN_COLOR_RUST, // - (Red-brown)
		"Onyx" = SKIN_COLOR_ONYX, // - (Black)
		"Lapis" = SKIN_COLOR_LAPIS, // - (Deep blue)
		"Basalt" = SKIN_COLOR_BASALT, // - (Dark grey)
		"Larimar" = SKIN_COLOR_LARIMAR, // - (Cyan)
		"Amazonite" = SKIN_COLOR_AMAZONITE, // - (Turquoise)
		"Limestone" = SKIN_COLOR_LIMESTONE, // - (Tan)
		"Zinc" = SKIN_COLOR_ZINC, // - (Light aqua)
	))

/datum/species/aasimar/get_hairc_list()
	return sortList(list(
		"black - oil" = "181a1d",
		"black - cave" = "201616",
		"black - rogue" = "2b201b",
		"black - midnight" = "1d1b2b",

		"white - silver" = "d3d9e3",
		"white - alabaster" = "fffffc",
		"white - skies" = "a1b4d4",

		"yellow - sunlight" = "f3f797",
		"blond - strawberry" = "c69b71",
		"blond - pale" = "9d8d6e",

		"red - flame" = "ab4637",
		"red - sunset" = "bf6821",
		"red - blood" = "822b2b",
		"red - maroon" = "612929"
	))

/datum/species/aasimar/get_possible_names(gender = FALSE)
	var/static/list/male_names = world.file2list('strings/rt/names/other/aasm.txt')
	var/static/list/female_names = world.file2list('strings/rt/names/other/aasf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/aasimar/get_possible_surnames(gender)
	return null

