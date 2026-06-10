
/mob/living/brain/Life(seconds_per_tick)
	set invisibility = 0

	if (HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

	if(isnull(loc) || HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

	. = ..()

/mob/living/brain/update_stat()
	if(status_flags & GODMODE)
		return
	if(health <= HEALTH_THRESHOLD_DEAD)
		if(stat != DEAD)
			death()
		var/obj/item/organ/brain/BR
		if(istype(loc, /obj/item/organ/brain))
			BR = loc
		if(BR)
			BR.brain_death = TRUE //beaten to a pulp

/mob/living/brain/handle_status_effects(seconds_per_tick)
	return
