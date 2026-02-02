/mob/living/carbon/human/species/kobold/formikrag
	race = /datum/species/kobold/formikrag

/datum/species/kobold/formikrag
	name = "Formikrag Kobold"
	id = SPEC_ID_KOBOLD_FORMIKRAG
	id_override = SPEC_ID_KOBOLD
	desc = ""

	specstats_m = list(STATKEY_STR = -2, STATKEY_PER = -1, STATKEY_INT = -2, STATKEY_END = 1, STATKEY_SPD = -2)
	specstats_f = list(STATKEY_STR = -2, STATKEY_PER = -1, STATKEY_INT = -2, STATKEY_END = 1, STATKEY_SPD = -2)

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/smooth,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/kobold,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/acid_spit,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/kobold,
		ORGAN_SLOT_WINGS = /obj/item/organ/wings/flight/kobold,
	)

	hungry_hungry_kobold = FALSE

/datum/species/kobold/formikrag/preference_accessible(datum/preferences/prefs)
	. = ..()
	if(!.)
		return

	if(!prefs?.parent)
		return FALSE

	return prefs.parent.has_triumph_buy(TRIUMPH_BUY_FORMIKRAG_KOBOLD)
