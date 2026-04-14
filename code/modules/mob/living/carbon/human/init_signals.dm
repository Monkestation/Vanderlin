/mob/living/carbon/human/register_init_signals()
	. = ..()

	/* ROGUE */
	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_LEPROSY), PROC_REF(on_leprosy_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_LEPROSY), PROC_REF(on_leprosy_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_CRATEMOVER), PROC_REF(on_cratemover_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_CRATEMOVER), PROC_REF(on_cratemover_trait_loss))
