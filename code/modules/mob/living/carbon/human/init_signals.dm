/mob/living/carbon/register_init_signals()
	. = ..()

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_NO_SPLIT_PERSONALITY), PROC_REF(on_no_split_personality_trait_gain))

/**
 * On gain of TRAIT_NO_SPLIT_PERSONALITY
 *
 * This will make the mob lose the split personality trauma if they have it.
 */
/mob/living/carbon/proc/on_no_split_personality_trait_gain(datum/source)
	SIGNAL_HANDLER

	cure_trauma_type(/datum/brain_trauma/severe/split_personality, TRAUMA_LIMIT_ABSOLUTE)
