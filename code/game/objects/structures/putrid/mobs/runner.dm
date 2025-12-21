/mob/living/simple_animal/hostile/retaliate/meatvine/runner
	icon_state = "bloodling_stage_2"
	icon_living = "bloodling_stage_2"
	icon_dead = "bloodling_stage_2_dead"

	tether_distance = 5
	possible_evolutions = list(
		/mob/living/simple_animal/hostile/retaliate/meatvine/flyer,
		/mob/living/simple_animal/hostile/retaliate/meatvine/stalker,
	)

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/evade,
	)

	structures = list(
		/datum/action/cooldown/meatvine/spread_tracking_beacon,
		/datum/action/cooldown/meatvine/spread_spike_multi,
	)
