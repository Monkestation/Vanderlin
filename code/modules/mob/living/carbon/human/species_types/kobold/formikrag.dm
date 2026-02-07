/mob/living/carbon/human/species/kobold/formikrag
	race = /datum/species/kobold/formikrag

/datum/species/kobold/formikrag
	name = "Formikrag Kobold"
	id = SPEC_ID_KOBOLD_FORMIKRAG
	id_override = SPEC_ID_KOBOLD
	desc = "Believed to be once native to a particular Subterran region, \
	now a hostile pest that has achieved grotesque mutation. \
	\n\n\
	Crawling out of the acid pools of the Subterra, consuming the local fauna and the rare Wurm's ichor, \
	those which survive have become the ultimate vermin of those acidic lands. \
	\n\n\
	Having sprouted pitiful wings and garnered meagre resistance to the elements, \
	the minerals and lighting of the pools have stripped their ability to consume stone and \
	negated the need for strong vision. \
	\n\n\
	More stout than their \"normal\" kin, they are more accoustomed to taking beatings. \
	Especially from Subterran wurm herders. \
	\n\n\
	WARNING: THIS IS A HEAVILY DISCRIMINATED AGAINST CHALLENGE SPECIES WITH ACTIVE SPECIES DETRIMENTS. YOU CAN AND WILL DIE A LOT; PLAY AT YOUR OWN RISK!"

	specstats_m = list(STATKEY_STR = -2, STATKEY_PER = -1, STATKEY_INT = -2, STATKEY_END = 1, STATKEY_SPD = -2)
	specstats_f = list(STATKEY_STR = -2, STATKEY_PER = -1, STATKEY_INT = -2, STATKEY_END = 1, STATKEY_SPD = -2)

	limbs_icon_m = 'icons/roguetown/mob/bodies/f/kobold_alt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/kobold_alt.dmi'

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
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/kobold/round,
		ORGAN_SLOT_WINGS = /obj/item/organ/wings/flight/kobold,
	)

	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
	)

	hungry_hungry_kobold = FALSE

/datum/species/kobold/formikrag/preference_accessible(datum/preferences/prefs)
	. = ..()
	if(!.)
		return

	if(!prefs?.parent)
		return FALSE

	return prefs.parent.has_triumph_buy(TRIUMPH_BUY_FORMIKRAG_KOBOLD)
