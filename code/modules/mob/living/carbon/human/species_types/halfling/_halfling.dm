/mob/living/carbon/human/species/halfling
	race = /datum/species/halfling

/datum/species/halfling
	name = "Halfling"
	id = SPEC_ID_HALFLING
	desc = "Halflings, merry-folk, pipe-tokers, these people are one of many names and few insults. Beloved, not for their glory and their honor, like men, or their crafts and stout ales like dwarves, \
	nor the graceful mystique of elfen kind- but for their bright smile and richly warm welcome that they provide even to the most boorish of visitors. The truest union of Psydon's dwarven and humen-kind. \
	And true to their nature, Halflings are most commonly known to have full bellies, smaller frames than that of dwarves and far less width to them as well. \
	\n\
	Curly hair of warm and earthy coloration, with coarse tufts atop the bridge of their proportionally large feet rather than a propensity to wear any sort of shoe to protect their already leathery soles. \
	No magick is present among these people, blessed not with the grand wizardry of Noc but that simpler everyday magicks of the world, for a halfling goes unseen as easily as the wind blows. Truly, they are a hearth in this age."

	default_color = "FFFFFF"
	native_language = "Halfling"
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, STUBBLE, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP, TRAIT_LIGHT_STEP, TRAIT_COIN_ILLITERATE, TRAIT_LUCKY_COOK)
	inherent_skills = list(
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/sneaking = 1,
	)

	use_skintones = TRUE

	possible_ages = NORMAL_AGES_LIST_CHILD

	changesource_flags = WABBAJACK

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/male_short.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fd.dmi'
	swap_male_clothes = TRUE
	custom_clothes = TRUE
	custom_id = SPEC_ID_DWARF

	// Both from female dwarf
	offset_features_m = list(
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
		OFFSET_UNDIES = list(0,0)\
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
		OFFSET_UNDIES = list(0,0)\
	)

	// Gets 2 SPD if they aren't wearing shoes
	// Gets 0 / 1 END if they eat enough
	specstats_m = list(STATKEY_STR = -1, STATKEY_PER = 2, STATKEY_CON = -1, STATKEY_END = 0, STATKEY_SPD = 1, STATKEY_LCK = 1)
	specstats_f = list(STATKEY_STR = -1, STATKEY_PER = 2, STATKEY_CON = -1, STATKEY_END = 0, STATKEY_SPD = 1, STATKEY_LCK = 1)

	enflamed_icon = "widefire"

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

	nutrition_mod = 2

/datum/species/halfling/check_roundstart_eligible()
	return TRUE

/datum/species/halfling/after_creation(mob/living/carbon/C)
	..()
	C.dna.species.accent_language = C.dna.species.get_accent(native_language, 1)
	C.grant_language(/datum/language/halfling)
	to_chat(C, span_info("I can speak Halfspeak with ,p before my speech."))

/datum/species/halfling/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	. = ..()

	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)
	C.grant_language(/datum/language/halfling)

	RegisterSignal(C, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(handle_equip))

	if(!C.shoes)
		C.apply_status_effect(/datum/status_effect/buff/free_feet)

/datum/species/halfling/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	if(QDELETED(C))
		return
	C.remove_language(/datum/language/common)
	C.remove_language(/datum/language/halfling)
	UnregisterSignal(C, COMSIG_MOB_SAY)
	UnregisterSignal(C, COMSIG_MOB_EQUIPPED_ITEM)
	C.remove_status_effect(/datum/status_effect/buff/free_feet)
	C.remove_status_effect(/datum/status_effect/buff/stuffed)

/datum/species/halfling/proc/handle_equip(mob/living/carbon/source, obj/item/equipping, slot)
	if(QDELETED(source) || !istype(source))
		return

	// This is bad :(
	if(slot & ITEM_SLOT_SHOES)
		source.remove_status_effect(/datum/status_effect/buff/free_feet)
	else if(!source.shoes)
		source.apply_status_effect(/datum/status_effect/buff/free_feet)

/datum/species/halfling/handle_digestion(mob/living/carbon/human/H)
	. = ..()
	if(H.stat == DEAD || HAS_TRAIT(H, TRAIT_NOHUNGER))
		return

	if(H.nutrition > NUTRITION_LEVEL_FAT)
		H.apply_status_effect(/datum/status_effect/buff/stuffed)
	else
		H.remove_status_effect(/datum/status_effect/buff/stuffed)
