	/*==============*
	*				*
	*	  Dwarf		*
	*				*
	*===============*/

//	( + Poison Resistance )

/mob/living/carbon/human/species/kobold
	race = /datum/species/kobold

/datum/species/kobold
	name = "Kobold"
	id = "kobold"
	desc = "Speculated to have originated from the dank depths of Subterra, \
	Kobolds are a species of stout sea-faring and mountain-dwelling lizardfolk infamous for their skills in trap-making, \
	their habit of hoarding grandiose amounts of trinkets and artifacts, and their opportunism.\
	\n\n\
	They are often in servitude to great beasts such as dragons and giants - trapping their lairs and utilizing pack tactics to dispose of ambitious adventurers and thieves alike. \
	But in their lonesome, Kobolds are generally weak and quick to die, as they noticeably lack the meaningful amount of constitution, strength, and endurance that other species usually have. \
	\n\n\
	WARNING: THIS IS A HEAVILY DISCRIMINATED AGAINST CHALLENGE SPECIES WITH ACTIVE SPECIES DETRIMENTS. YOU CAN AND WILL DIE A LOT; PLAY AT YOUR OWN RISK!"
	skin_tone_wording = "Fur Color"
	default_color = "FFFFFF"
	specstats = list(STATKEY_STR = -4, STATKEY_PER = -2, STATKEY_INT = -2, STATKEY_CON = -4, STATKEY_END = 2, STATKEY_SPD = 2, STATKEY_LCK = 0)
	specstats_f = list(STATKEY_STR = -4, STATKEY_PER = -2, STATKEY_INT = -2, STATKEY_CON = -4, STATKEY_END = 2, STATKEY_SPD = 2, STATKEY_LCK = 0)

	possible_ages = NORMAL_AGES_LIST
	use_skintones = TRUE
	disliked_food = NONE
	liked_food = NONE
	changesource_flags = WABBAJACK
	limbs_icon_m = 'icons/roguetown/mob/bodies/f/kobold.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/kobold.dmi'
	dam_icon_m = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	hairyness = "t3"
	soundpack_m = /datum/voicepack/male/dwarf
	soundpack_f = /datum/voicepack/female/dwarf

	exotic_bloodtype = /datum/blood_type/human/kobold

	custom_id = "dwarf"
	custom_clothes = TRUE

	swap_female_clothes = FALSE
	swap_male_clothes = TRUE
	inherent_traits = list(TRAIT_TINY)

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/smooth,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)

	offset_features = list(OFFSET_RING = list(0,0), OFFSET_GLOVES = list(0,0), OFFSET_WRISTS = list(0,0),\
	OFFSET_CLOAK = list(0,0), OFFSET_FACEMASK = list(0,-4), OFFSET_HEAD = list(0,-4), \
	OFFSET_FACE = list(0,-4), OFFSET_BELT = list(0,-5), OFFSET_BACK = list(0,-4), \
	OFFSET_NECK = list(0,-4), OFFSET_MOUTH = list(0,-4), OFFSET_PANTS = list(0,0), \
	OFFSET_SHIRT = list(0,0), OFFSET_ARMOR = list(0,0), OFFSET_HANDS = list(0,-3), \
	OFFSET_RING_F = list(0,-4), OFFSET_GLOVES_F = list(0,-4), OFFSET_WRISTS_F = list(0,-4), OFFSET_HANDS_F = list(0,-4), \
	OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-5), OFFSET_HEAD_F = list(0,-5), \
	OFFSET_FACE_F = list(0,-5), OFFSET_BELT_F = list(0,-5), OFFSET_BACK_F = list(0,-5), \
	OFFSET_NECK_F = list(0,-5), OFFSET_MOUTH_F = list(0,-5), OFFSET_PANTS_F = list(0,0), \
	OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES = list(0,0), OFFSET_UNDIES_F = list(0,0))
	enflamed_icon = "widefire"
	patreon_req = TRUE

/datum/species/kobold/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	. = ..()
	C.AddComponent(/datum/component/abberant_eater, list(/obj/item/natural/dirtclod, /obj/item/natural/stone, /obj/item/coin, /obj/item/gem))
	ADD_TRAIT(C, TRAIT_DARKVISION, SPECIES_TRAIT)


/datum/species/kobold/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)

/datum/species/kobold/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	C.remove_language(/datum/language/common)

/datum/species/kobold/check_roundstart_eligible()
	return TRUE

/datum/species/kobold/get_span_language(datum/language/message_language)
	if(!message_language)
		return
	if(message_language.type == /datum/language/dwarvish)
		return list(SPAN_DWARF)
	return message_language.spans

/datum/species/kobold/get_skin_list()
	return sortList(list(
		"Moonshade" = SKIN_COLOR_MOONSHADE,
		"Sunstreak" = SKIN_COLOR_SUNSTREAK,
		"Stonepaw" = SKIN_COLOR_STONEPAW,
		"Emberhide" = SKIN_COLOR_EMBERHIDE,
		"Sandswept" = SKIN_COLOR_SANDSWEPT,
		"Quick Silver" = SKIN_COLOR_QUICKSILVER,
		"Brass" = SKIN_COLOR_BRASS,
		"Iron" = SKIN_COLOR_IRON,
	))

/datum/species/kobold/get_possible_names(gender = MALE)
	var/static/list/male_names = world.file2list('strings/rt/names/dwarf/dwarmm.txt')
	var/static/list/female_names = world.file2list('strings/rt/names/dwarf/dwarmf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/kobold/get_possible_surnames(gender = MALE)
	var/static/list/last_names = world.file2list('strings/rt/names/dwarf/dwarmlast.txt')
	return last_names
