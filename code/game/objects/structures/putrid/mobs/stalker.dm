/mob/living/simple_animal/hostile/retaliate/meatvine/stalker
	icon_state = "stalker"
	icon_living = "stalker"
	icon_dead = "stalker_dead"

	tether_distance = 5
	possible_evolutions = list(
		/mob/living/simple_animal/hostile/retaliate/meatvine/skin_stealer,
	)

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/evade,
		/datum/action/cooldown/meatvine/personal/triple_charge,
	)

	structures = list(
		/datum/action/cooldown/meatvine/spread_tracking_beacon,
		/datum/action/cooldown/meatvine/spread_spike_multi,
	)
