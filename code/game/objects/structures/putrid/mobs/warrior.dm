/mob/living/simple_animal/hostile/retaliate/meatvine/warrior
	icon_state = "warrior"
	icon_living = "warrior"
	icon_dead = "warrior_dead"
	icon = 'icons/obj/cellular/putrid_large.dmi'

	possible_evolutions = list()

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/slicing_sweep,
		/datum/action/cooldown/meatvine/personal/literally_too_angry_to_die,
		/datum/action/cooldown/meatvine/personal/charge_slash,
		/datum/action/cooldown/meatvine/personal/ranged/spread,
	)
