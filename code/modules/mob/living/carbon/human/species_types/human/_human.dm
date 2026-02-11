/datum/species/human
	name = "Humanb"
	id = SPEC_ID_HUMEN
	changesource_flags = WABBAJACK
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)

/datum/species/human/check_roundstart_eligible()
	return FALSE

/datum/species/human/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)

/datum/species/human/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	C.remove_language(/datum/language/common)

/datum/species/human/qualifies_for_rank(rank, list/features)
	return TRUE	//Pure humans are always allowed in all roles.
