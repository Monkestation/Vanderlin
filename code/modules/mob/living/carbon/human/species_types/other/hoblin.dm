/mob/living/carbon/human/species/hoblin
	race = /datum/species/hoblin

/datum/attribute_holder/sheet/job/species/hoblin
	raw_attribute_list = list(
		STAT_SPEED = 2,
		STAT_ENDURANCE = 1,
		STAT_INTELLIGENCE = -2,
		STAT_CONSTITUTION = -2,
		STAT_FORTUNE = -2,
	)

/datum/species/hoblin
	name = "Hoblin"
	id = SPEC_ID_HOBLIN
	multiple_accents = list(
		"Half-Orc Accent" = ACCENT_HORC,
		"Ossland Accent" = ACCENT_OSSLAND,
	)
	native_language = "Orcish"
	desc = "The bastards of Graggar. \
	\n\n\
	Half-Orcs are the offspring of orcs and another species, half-orcs, \
	or another species who has consumed much kinsflesh on their way to orcishness. \
	An outsider cannot tell a half-orc product of heritage or cannibalism at a glance, leading to much social ostracization.\
	\n\n\
	Due to their parent's refusal to nurture them, \
	as well as their other parent often rejecting or attacking them, most Half-Orcs will grow as orphans. \
	Their rejection by the rest of society causes their growth to stunt, \
	often making them hostile and prone to violence. Because of this, most will assume the worst in them, \
	believing that they are cursed to follow their orcish parent's footsteps in the gorging of kin-flesh. \
	\n\n\
	A Half-Orc may display Orcish features, sporting tusks and natural strength. \
	Many are nigh-indistinguishable visually from full orcs, save for their remaining grasp on self-control.\
	\n\n\
	THIS IS AN <I>EXTREMELY</I> DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. <B>NOBLES EVEN MORE SO.</B> PLAY AT YOUR OWN RISK."

	species_traits = list(EYECOLOR, LIPS, STUBBLE, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP, TRAIT_DEADNOSE, TRAIT_STINKY)

	allowed_voicetypes_m = VOICE_TYPES_MASCANDRO

	allowed_voicetypes_f = VOICE_TYPES_MASCANDRO

	use_skintones = 1

	possible_ages = NORMAL_AGES_LIST
	changesource_flags = WABBAJACK

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/goblin_male.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/goblin_female.dmi'

	custom_id = "dwarf"
	custom_clothes = TRUE

	swap_male_clothes = TRUE

	soundpack_m = /datum/voicepack/male/elf
	soundpack_f = /datum/voicepack/female/elf

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
		OFFSET_UNDIES = list(0,-4),\
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
		OFFSET_UNDIES = list(0,-4)\
	)

	statsheet_male = /datum/attribute_holder/sheet/job/species/hoblin

	enflamed_icon = "widefire"

	exotic_bloodtype = /datum/blood_type/human/horc
	meat = list(/obj/item/reagent_containers/food/snacks/meat/steak/human = 1, /obj/item/reagent_containers/food/snacks/meat/strange = 0.5)

	customizers = list(
		/datum/customizer/organ/ears/goblin,
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
		ORGAN_SLOT_SPLEEN = /obj/item/organ/spleen,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision/nightmare,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)

	hygiene_mod = 1.5

/datum/species/hoblin/check_roundstart_eligible()
	return TRUE

/datum/species/hoblin/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)
	C.grant_language(/datum/language/orcish)

/datum/species/hoblin/after_creation(mob/living/carbon/C)
	..()
	C.grant_language(/datum/language/orcish)
	to_chat(C, span_info("I can speak Orcish with ,o before my speech."))
	if(ishuman(C)) //Horcs are STINKY
		var/mob/living/carbon/human/stinky_horc = C
		stinky_horc.hygiene = HYGIENE_LEVEL_DISGUSTING

/datum/species/hoblin/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	C.remove_language(/datum/language/orcish)

/datum/species/hoblin/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/hoblin/get_skin_list()
	return list(
		"Beach" = SKIN_COLOR_SHELLCREST,
		"Infernal" = SKIN_COLOR_BLOOD_AXE,
		"Cyan" = SKIN_COLOR_GROONN, //Changed name from Gronn, which no longer aligned with lore here or elsewhere.
		"Cave" = SKIN_COLOR_BLACK_HAMMER,
		"Mountain" = SKIN_COLOR_SKULL_SEEKER,
		"Swamp" = SKIN_COLOR_CRESCENT_FANG,
		"Bogfoot" = SKIN_COLOR_MURKWALKER,
		"Moon" = SKIN_COLOR_SHATTERHORN,
	)

/datum/species/hoblin/get_hairc_list()
	return sortList(list(
		"brown - minotaur" = "58433b",
		"brown - volf" = "48322a",
		"brown - bark" = "2d1300",

		"green - maneater" = "458745",
		"green - swampgrass" = "2A3B2B",

		"black - charcoal" = "201616"
	))

/datum/species/hoblin/get_possible_names(gender = MALE)
	var/static/list/male_names = file2list('strings/rt/names/other/halforcm.txt')
	var/static/list/female_names = file2list('strings/rt/names/other/halforcf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/hoblin/get_possible_surnames(gender = MALE)
	return null
