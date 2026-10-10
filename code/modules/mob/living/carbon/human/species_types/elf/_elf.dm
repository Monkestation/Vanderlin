/mob/living/carbon/human/species/elf
	race = /datum/species/elf

/datum/species/elf
	name = "Elfb"
	id = SPEC_ID_ELF
	accents_list = list(
		ACCENT_ELF,
		ACCENT_WINTERMARE,
		ACCENT_OSSLAND,
		ACCENT_NONE
	)
	changesource_flags = WABBAJACK
	default_accent = ACCENT_ELF
	exotic_bloodtype = /datum/blood_type/human/elf
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)

/datum/species/elf/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	C.grant_language(/datum/language/common)
	C.grant_language(/datum/language/elvish)

/datum/species/elf/check_roundstart_eligible()
	return FALSE

/datum/species/elf/after_creation(mob/living/carbon/C)
	..()
	C.grant_language(/datum/language/elvish)
	to_chat(C, "<span class='info'>I can speak Elfish with ,e before my speech.</span>")

/datum/species/elf/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.remove_language(/datum/language/elvish)

/datum/species/elf/qualifies_for_rank(rank, list/features)
	return TRUE
