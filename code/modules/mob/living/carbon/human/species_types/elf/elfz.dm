	/*==============*
	*				*
	*	Snow Elf	*
	*				*
	*===============*/

//	( + Night Vision Plus )

/mob/living/carbon/human/species/elf/zizo
	race = /datum/species/elf/zizo

/datum/attribute_holder/sheet/job/species/zizo
	raw_attribute_list = list(
		STAT_PERCEPTION = -1,
		STAT_INTELLIGENCE = 1,
		STAT_ENDURANCE = 2,
		STAT_SPEED = 2,
	)

/datum/attribute_holder/sheet/job/species/zizo/female
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_PERCEPTION = -1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 1
	)

/datum/species/elf/zizo
	name = "Snow Elf"
	id = SPEC_ID_SNOW_ELF
	id_override = SPEC_ID_DROW
	desc = "Zizo's progeny. \
	\n\n\
	These elves hail from an underground expanse of newly-reborn empires. \
	They lead harsh, matriarchal lives under the watchful gaze of Zizo, \
	the vast majority hoping to one day achieve such power and domination for themselves. \
	Zizo's spawn, the last snow elves, integrated themselves- whether gleefully or resentfully- within the dark elf culture \
	their grandmother had carved through conquest. \
	\n\n\
	To most in Psydonia, a dark elf is nothing more than a servant of Zizo waiting to betray for power, \
	leading most dark elves to remain within their safe underground strongholds. Those who breach the surface \
	rarely receive fair treatment. \
	Dark elves over 500 years old may remember their Ravoxian empire of old, yet few remain who were not killed or converted. \
	\n\n\
	WARNING: THIS IS A HEAVILY DISCRIMINATED AGAINST CHALLENGE SPECIES WITH ACTIVE SPECIES DETRIMENTS. YOU CAN AND WILL DIE A LOT; PLAY AT YOUR OWN RISK!"

	skin_tone_wording = "Bloodline"

	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)
	use_skintones = 1
	disliked_food = NONE
	liked_food = NONE
	possible_ages = NORMAL_AGES_LIST_CHILD
	changesource_flags = WABBAJACK
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mem.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/ft.dmi'
	hairyness = "t3"
	exotic_bloodtype = /datum/blood_type/human/cursed_elf

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_SPLEEN = /obj/item/organ/spleen,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/elf,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/elf,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)


	customizers = list(
		/datum/customizer/organ/ears/elf,
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
	)

	swap_male_clothes = TRUE

	soundpack_m = /datum/voicepack/male/elf
	soundpack_f = /datum/voicepack/female/elf

	offset_features_m = list(
		OFFSET_RING = list(0,0),\
		OFFSET_GLOVES = list(0,1),\
		OFFSET_WRISTS = list(0,1),\
		OFFSET_HANDS = list(0,0),\
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

	offset_features_f = list(
		OFFSET_RING = list(0,0),\
		OFFSET_GLOVES = list(0,1),\
		OFFSET_WRISTS = list(0,1),\
		OFFSET_HANDS = list(0,1),\
		OFFSET_CLOAK = list(0,1),\
		OFFSET_FACEMASK = list(0,0),\
		OFFSET_HEAD = list(0,0),\
		OFFSET_FACE = list(0,0),\
		OFFSET_BELT = list(0,0),\
		OFFSET_BACK = list(0,0),\
		OFFSET_NECK = list(0,0),\
		OFFSET_MOUTH = list(0,0),\
		OFFSET_PANTS = list(0,1),\
		OFFSET_SHIRT = list(0,1),\
		OFFSET_ARMOR = list(0,1),\
		OFFSET_UNDIES = list(0,1),\
	)

	statsheet_male = /datum/attribute_holder/sheet/job/species/zizo
	statsheet_female = /datum/attribute_holder/sheet/job/species/zizo/female
	enflamed_icon = "widefire"

	body_markings = list(
		/datum/body_marking/tonage,
	)

/datum/species/elf/dark/get_span_language(datum/language/message_language)
	if(!message_language)
		return
	if(message_language.type == /datum/language/elvish)
		return list(SPAN_DELF)
	return message_language.spans
/datum/species/elf/zizo/check_roundstart_eligible()
	return TRUE

/datum/species/elf/zizo/get_skin_list()
	return sortList(list(
		"Zizo Descendant" = SKIN_COLOR_ICECAP, // - (Pale white)
	))

/datum/species/elf/zizo/get_hairc_list()
	return sortList(list(
		"black - oil" = "181a1d",
		"black - cave" = "201616",
		"black - rogue" = "2b201b",
		"black - midnight" = "1d1b2b",

		"white - cavedew" = "dee9ed",
		"white - spiderweb" = "f4f4f4"
	))

/datum/species/elf/zizo/get_possible_names(gender = MALE)
	var/static/list/male_names = file2list('strings/rt/names/elf/elfdm.txt')
	var/static/list/female_names = file2list('strings/rt/names/elf/elfdf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/elf/zizo/get_possible_surnames(gender = MALE)
	var/static/list/last_names = file2list('strings/rt/names/elf/elfsnf.txt')
	return last_names

/datum/species/elf/zizo/after_creation(mob/living/carbon/human/C)
	C.dna.species.accent_language = C.dna.species.get_accent(native_language, 2)

/datum/species/elf/zizo/preference_accessible(datum/preferences/prefs)
	. = ..()
	if(!.)
		return

	if(!prefs?.parent)
		return FALSE

	if(prefs.parent.is_donator())
		return TRUE

	return prefs.parent.has_triumph_buy(TRIUMPH_BUY_SNOW_ELF)
