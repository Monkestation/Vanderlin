/mob/living/simple_animal/hostile/retaliate/meatvine/burrower
	icon_state = "burrower"
	icon_living = "burrower"
	icon_dead = "burrower_dead"
	icon = 'icons/obj/cellular/putrid_small.dmi'

	possible_evolutions = list()

	structures = list(
		/datum/action/cooldown/meatvine/spread_wormhole,
		/datum/action/cooldown/meatvine/spread_tracking_beacon,
	)

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/burrow_through,
	)
