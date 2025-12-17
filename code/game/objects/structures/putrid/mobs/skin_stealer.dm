/mob/living/simple_animal/hostile/retaliate/meatvine/skin_stealer
	icon_state = "skinstealer"
	icon_living = "skinstealer"
	icon_dead = "skinstealer_dead"
	icon = 'icons/obj/cellular/putrid_tall.dmi'

	tether_distance = 5
	possible_evolutions = list()

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/evade,
		/datum/action/cooldown/meatvine/personal/triple_charge,
		/datum/action/cooldown/meatvine/personal/deafening_screech,
	)

	structures = list(
		/datum/action/cooldown/meatvine/spread_tracking_beacon,
		/datum/action/cooldown/meatvine/spread_spike_multi,
	)
