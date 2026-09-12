/mob/living/simple_animal/hostile/retaliate/meatvine/broodmother
	icon_state = "mama"
	icon_living = "mama"
	icon_dead = "mama_dead"
	icon = 'icons/obj/cellular/putrid_big.dmi'

	possible_evolutions = list()

	structures = list(
		/datum/action/cooldown/meatvine/spread_healing_well,
		/datum/action/cooldown/meatvine/spread_wormhole,
		/datum/action/cooldown/meatvine/spread_lair,
	)

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/repair_walls,
		/datum/action/cooldown/meatvine/personal/mark_target,
	)
