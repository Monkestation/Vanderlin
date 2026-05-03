/mob/living/carbon/register_init_signals()
	. = ..()

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_NO_SPLIT_PERSONALITY), PROC_REF(on_no_split_personality_trait_gain))

	RegisterSignal(src, SIGNAL_ADDCHEMEFFECT(CE_STIMULANT), PROC_REF(receive_actionboost))
	RegisterSignal(src, SIGNAL_REMOVECHEMEFFECT(CE_STIMULANT), PROC_REF(remove_actionboost))


/**
 * On gain of TRAIT_NO_SPLIT_PERSONALITY
 *
 * This will make the mob lose the split personality trauma if they have it.
 */
/mob/living/carbon/proc/on_no_split_personality_trait_gain(datum/source)
	SIGNAL_HANDLER

	cure_trauma_type(/datum/brain_trauma/severe/split_personality, TRAUMA_LIMIT_ABSOLUTE)

/mob/living/carbon/proc/receive_actionboost(mob/living/carbon/source, chem_effect)
	var/speedboost = get_chem_effect(chem_effect)
	add_or_update_variable_actionspeed_modifier(/datum/actionspeed_modifier/stimulants, STIMULANT_ACTIONSPEED_INCREASE * speedboost)

/mob/living/carbon/proc/remove_actionboost(mob/living/carbon/source, chem_effect)
	remove_actionspeed_modifier(/datum/actionspeed_modifier/stimulants, TRUE)
