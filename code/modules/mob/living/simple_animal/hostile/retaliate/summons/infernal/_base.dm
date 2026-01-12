/mob/living/simple_animal/hostile/retaliate/infernal
	food_max = 0
	dendor_taming_chance = DENDOR_TAME_PROB_NONE
/mob/living/simple_animal/hostile/retaliate/infernal/Initialize()
	. = ..()
	ADD_TRAIT(src,TRAIT_NOFIRE, "[type]")
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/infernal/simple_limb_hit(zone)
	return ..()
