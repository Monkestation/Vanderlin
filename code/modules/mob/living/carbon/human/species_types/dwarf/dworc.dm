/mob/living/carbon/human/species/dwarf/dwarf/dworc
	race = /datum/species/dwarf/dworc

/datum/attribute_holder/sheet/job/species/dwarf/dworc
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = -2,
		STAT_INTELLIGENCE = -2,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 1,
	)

/datum/attribute_holder/sheet/job/species/dwarf/dworc/female
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = -1,
		STAT_INTELLIGENCE = -2,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
	)

/datum/species/dwarf/dworc
	name = "Dwarven Half-Orc"
	id = SPEC_ID_DWARF_ORC
	multiple_accents = list(
		"Half-Orc Accent" = ACCENT_HORC,
		"Dwarf Accent" = ACCENT_DWARF,
		"Ossland Accent" = ACCENT_OSSLAND,
	)
	native_language = "Orcish"
	desc = "Orkified dwarves. \
	\n\n\
	Often insultingly called hoblins (half-goblins) due to their size, are the offspring of dwarf-orc and another species, \
	or those dwarfs which decided to feast of kinflesh or were forced to do so. \
	\n\n\
	A dwarvened orc was an uncommon sight, until the second Goblin War caused an influx of them, as those dwarves captured by orcish forces were fed flesh of their fallen brothers. \
	Used mostly as cannon-fodder, as they were reluctant to fight their homeland. Some managed to escape captivity, yet they were rarely recognised and in turn shunned and treated like spies. \
	Outside of their size there is not much diffrence between a proper half-orc and dwarvened variant. Both posses unnatural strength, live mostly and isolation and are prone to violence. \
	\n\n\
	THIS IS AN <I>EXTREMELY</I> DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. <B>NOBLES EVEN MORE SO.</B> PLAY AT YOUR OWN RISK."

	species_traits = list(EYECOLOR, LIPS, STUBBLE, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP, TRAIT_DEADNOSE, TRAIT_STINKY)

	use_skintones = 1

	possible_ages = NORMAL_AGES_LIST
	changesource_flags = WABBAJACK

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/goblin_male.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/goblin_female.dmi'

	custom_id = "dwarf"
	custom_clothes = TRUE

	soundpack_m = /datum/voicepack/male/dwarf
	soundpack_f = /datum/voicepack/female/dwarf

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

	statsheet_male = /datum/attribute_holder/sheet/job/species/dwarf/dworc
	statsheet_female = /datum/attribute_holder/sheet/job/species/dwarf/dworc/female

	enflamed_icon = "widefire"

	exotic_bloodtype = /datum/blood_type/human/horc
	meat = list(/obj/item/reagent_containers/food/snacks/meat/steak/human = 1, /obj/item/reagent_containers/food/snacks/meat/strange = 0.5)

	customizers = list(
		/datum/customizer/organ/ears/halforc,
		/datum/customizer/organ/eyes/humanoid/,
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
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/goblin,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)

	hygiene_mod = 1.5

/datum/species/dwarf/dworc/check_roundstart_eligible()
	return TRUE

/datum/species/dwarf/dworc/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	C.grant_language(/datum/language/orcish)

/datum/species/dwarf/dworc/after_creation(mob/living/carbon/C)
	..()
	C.grant_language(/datum/language/orcish)
	to_chat(C, span_info("I can speak Orcish with ,o before my speech."))
	if(ishuman(C)) //Horcs are STINKY
		var/mob/living/carbon/human/stinky_horc = C
		stinky_horc.hygiene = HYGIENE_LEVEL_DISGUSTING

/datum/species/dwarf/dworc/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.remove_language(/datum/language/orcish)


/datum/species/dwarf/dworc/get_skin_list() //same colors as half-orcs, renamed to be goblin-like
	return list(
		"Sea" = SKIN_COLOR_SHELLCREST,
		"Infernal" = SKIN_COLOR_BLOOD_AXE,
		"Beach" = SKIN_COLOR_GROONN,
		"Cave" = SKIN_COLOR_BLACK_HAMMER,
		"Mountain" = SKIN_COLOR_SKULL_SEEKER,
		"Swamp" = SKIN_COLOR_CRESCENT_FANG,
		"Bogfoot" = SKIN_COLOR_MURKWALKER,
		"Moon" = SKIN_COLOR_SHATTERHORN,
	)

/datum/species/dwarf/dworc/get_hairc_list()
	return sortList(list(
		"brown - minotaur" = "58433b",
		"brown - volf" = "48322a",
		"brown - bark" = "2d1300",

		"green - maneater" = "458745",
		"green - swampgrass" = "2A3B2B",

		"black - charcoal" = "201616"
	))

/datum/species/dwarf/dworc/get_possible_names(gender = MALE)
	var/static/list/male_names = file2list('strings/rt/names/dwarf/dwarmm.txt')
	var/static/list/female_names = file2list('strings/rt/names/dwarf/dwarmf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/dwarf/dworc/get_possible_surnames(gender = MALE)
	return null
