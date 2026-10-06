/datum/species/human
	name = "Humanb"
	id = SPEC_ID_HUMEN
	accents_list = list(
		ACCENT_NONE,
		ACCENT_OSSLAND,
		ACCENT_GRENZ,
	)
	changesource_flags = WABBAJACK
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)

/datum/species/human/check_roundstart_eligible()
	return FALSE

/datum/species/human/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	C.grant_language(/datum/language/common)

/datum/species/human/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.remove_language(/datum/language/common)

/datum/species/human/qualifies_for_rank(rank, list/features)
	return TRUE	//Pure humans are always allowed in all roles.
