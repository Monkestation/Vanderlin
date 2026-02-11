
/mob/living/carbon/human/Stun(amount, ignore_canstun = FALSE)
	amount = dna?.species?.spec_stun(src, amount)
	return ..()

/mob/living/carbon/human/Knockdown(amount, ignore_canstun = FALSE)
	amount = dna?.species?.spec_stun(src, amount)
	return ..()

/mob/living/carbon/human/Paralyze(amount, ignore_canstun = FALSE)
	amount = dna?.species?.spec_stun(src, amount)
	return ..()

/mob/living/carbon/human/Immobilize(amount, ignore_canstun = FALSE)
	amount = dna?.species?.spec_stun(src, amount)
	return ..()

/mob/living/carbon/human/Unconscious(amount, ignore_canstun = FALSE)
	amount = dna?.species?.spec_stun(src, amount)
	return ..()

/mob/living/carbon/human/Sleeping(amount)
	return ..()

/mob/living/carbon/human/cure_husk(list/sources)
	. = ..()
	if(.)
		update_body()

/mob/living/carbon/human/become_husk(source)
	. = ..()
	if(.)
		update_body()

/mob/proc/adjust_hygiene(amount)
	return

/mob/living/carbon/human/adjust_hygiene(amount)
	..()
	hygiene = CLAMP(hygiene+amount, 0, HYGIENE_LEVEL_CLEAN)
	update_smell()

/mob/proc/set_hygiene(amount)
	return

/mob/living/carbon/human/set_hygiene(amount)
	hygiene	 = CLAMP(amount, 0, HYGIENE_LEVEL_CLEAN)
	update_smell()
