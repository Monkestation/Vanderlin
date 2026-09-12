/mob/living/simple_animal/hostile/retaliate/meatvine/tank
	icon_state = "tank"
	icon_living = "tank"
	icon_dead = "tank_dead"
	icon = 'icons/obj/cellular/putrid_big.dmi'

	possible_evolutions = list(
		/mob/living/simple_animal/hostile/retaliate/meatvine/defender,
	)

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/literally_too_angry_to_die,
	)
