/mob/living/simple_animal/hostile/retaliate/meatvine/defender
	icon_state = "defender"
	icon_living = "defender"
	icon_dead = "defender_dead"
	icon = 'icons/obj/cellular/wide_putrid.dmi'

	possible_evolutions = list(
		/mob/living/simple_animal/hostile/retaliate/meatvine/goliath,
		/mob/living/simple_animal/hostile/retaliate/meatvine/warrior,
	)

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/literally_too_angry_to_die,
		/datum/action/cooldown/meatvine/personal/charge_attack,
		/datum/action/cooldown/meatvine/personal/fling,
	)

/mob/living/simple_animal/hostile/retaliate/meatvine/defender/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "defender_emissive")
