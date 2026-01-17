/mob/living/simple_animal/hostile/retaliate/elemental
	dendor_taming_chance = DENDOR_TAME_PROB_NONE

/mob/living/simple_animal/hostile/retaliate/elemental/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/elemental/simple_limb_hit(zone)
	return ..()

/mob/living/simple_animal/hostile/retaliate/elemental/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//no wounding the elementals
	return

/datum/intent/simple/elemental_unarmed
	name = "elemental unarmed"
	icon_state = "instrike"
	attack_verb = list("punches", "strikes", "rolls on", "crushes")
	animname = "blank22"
	blade_class = BCLASS_BLUNT
	hitsound = null
	chargetime = 0
	penfactor = 10
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
