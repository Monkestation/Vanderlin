/mob/living/simple_animal/hostile/retaliate/meatvine/flyer
	icon_state = "flyer"
	icon_living = "flyer"
	icon_dead = "flyer_dead"
	icon = 'icons/obj/cellular/wide_putrid.dmi'

	movement_type = FLYING

	tether_distance = 11
	possible_evolutions = list()

	structures = list(
		/datum/action/cooldown/meatvine/spread_tracking_beacon,
	)

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/evade,
	)

/mob/living/simple_animal/hostile/retaliate/meatvine/flyer/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "flyer_emissive")
	. += emissive_appearance(icon, "flyer_emissive_eye")
