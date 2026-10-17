/datum/ingredient_buff/blood_restoration
	status_effect_type = /datum/status_effect/buff/ingredient/blood_restoration

/datum/ingredient_buff/blood_restoration/examine_string()
	return span_notice("Promotes blood restoration when cooked with.")

/datum/status_effect/buff/ingredient/blood_restoration
	id = "Ingredient Buff: Blood Restoration"

/datum/status_effect/buff/ingredient/blood_restoration/on_apply()
	. = ..()
	var/mob/living/carbon/C = owner
	C?.add_chem_effect(CE_BLOODRESTORE, 3 + (2 * quality), "[type]")

/datum/status_effect/buff/ingredient/blood_restoration/on_remove()
	. = ..()
	var/mob/living/carbon/C = owner
	C?.remove_chem_effect(CE_BLOODRESTORE, "[type]")

/datum/ingredient_buff/energizing
	status_effect_type = /datum/status_effect/buff/ingredient/energizing

/datum/ingredient_buff/energizing/examine_string()
	return span_notice("Promotes stamina regeneration when cooked with.")

/datum/status_effect/buff/ingredient/energizing
	id = "Ingredient Buff: Energizing"

/datum/status_effect/buff/ingredient/energizing/on_apply()
	. = ..()
	var/mob/living/carbon/C = owner
	C?.add_chem_effect(CE_ENERGETIC, 1 + (1 * quality), "[type]")

/datum/status_effect/buff/ingredient/energizing/on_remove()
	. = ..()
	var/mob/living/carbon/C = owner
	C?.remove_chem_effect(CE_ENERGETIC, "[type]")

/datum/ingredient_buff/antibiotic
	status_effect_type = /datum/status_effect/buff/ingredient/antibiotic

/datum/ingredient_buff/antibiotic/examine_string()
	return span_notice("Boosts your immune system when cooked with.")

/datum/status_effect/buff/ingredient/antibiotic
	id = "Ingredient Buff: Antibiotic"

/datum/status_effect/buff/ingredient/antibiotic/on_apply()
	. = ..()
	var/mob/living/carbon/C = owner
	C?.add_chem_effect(CE_ANTIBIOTIC, 5 + (4 * quality), "[type]")

/datum/status_effect/buff/ingredient/energizing/on_remove()
	. = ..()
	var/mob/living/carbon/C = owner
	C?.remove_chem_effect(CE_ANTIBIOTIC, "[type]")

/datum/ingredient_buff/stimulant
	status_effect_type = /datum/status_effect/buff/ingredient/stimulant

/datum/ingredient_buff/antibiotic/examine_string()
	return span_notice("Acts as a stimulant when cooked with.")

/datum/status_effect/buff/ingredient/stimulant
	id = "Ingredient Buff: Stimulant"

/datum/status_effect/buff/ingredient/stimulant/on_apply()
	. = ..()
	var/mob/living/carbon/C = owner
	C?.add_chem_effect(CE_STIMULANT, 2 + (1 * quality), "[type]")

/datum/status_effect/buff/ingredient/energizing/on_remove()
	. = ..()
	var/mob/living/carbon/C = owner
	C?.remove_chem_effect(CE_STIMULANT, "[type]")

/datum/ingredient_buff/painkiller
	status_effect_type = /datum/status_effect/buff/ingredient/painkiller
	random_choice = 2

/datum/ingredient_buff/painkiller/examine_string()
	return span_notice("Acts as a painkiller when cooked with.")

/datum/status_effect/buff/ingredient/painkiller
	id = "Ingredient Buff: Painkiller"

/datum/status_effect/buff/ingredient/painkiller/on_apply()
	. = ..()
	var/mob/living/carbon/C = owner
	C?.add_chem_effect(CE_PAINKILLER, 20 + (5 * quality), "[type]")

/datum/status_effect/buff/ingredient/painkiller/on_remove()
	. = ..()
	var/mob/living/carbon/C = owner
	C?.remove_chem_effect(CE_PAINKILLER, "[type]")
