/mob/living/simple_animal/hostile/retaliate/meatvine/burrower
	icon_state = "bloodling_stage_5"
	icon_living = "bloodling_stage_5"
	icon_dead = "bloodling_stage_5_dead"

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
