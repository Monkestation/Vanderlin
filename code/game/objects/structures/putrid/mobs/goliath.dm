/mob/living/simple_animal/hostile/retaliate/meatvine/goliath
	icon_state = "goliath"
	icon_living = "goliath"
	icon_dead = "goliath_dead"
	icon = 'icons/obj/cellular/putrid_large.dmi'

	possible_evolutions = list()

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/literally_too_angry_to_die,
		/datum/action/cooldown/meatvine/personal/charge_attack,
		/datum/action/cooldown/meatvine/personal/ground_slam,

	)
