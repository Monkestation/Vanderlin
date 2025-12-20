/mob/living/simple_animal/hostile/retaliate/meatvine/spawnlord
	icon_state = "spawnlord"
	icon_living = "spawnlord"
	icon_dead = "spawnlord_dead"
	icon = 'icons/obj/cellular/wide_putrid.dmi'

	possible_evolutions = list()

	structures = list(
		/datum/action/cooldown/meatvine/spread_wormhole,
		/datum/action/cooldown/meatvine/spread_lair,
		/datum/action/cooldown/meatvine/spread_wall_multi,
	)

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/transfer_resources/improved,
		/datum/action/cooldown/meatvine/personal/mark_target,
	)

/mob/living/simple_animal/hostile/retaliate/meatvine/defender/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "spawnlord_emissive")
