/mob/living/simple_animal/hostile/retaliate/meatvine/constructor
	icon_state = "constructor"
	icon_living = "constructor"
	icon_dead = "constructor_dead"

	possible_evolutions = list(
		/mob/living/simple_animal/hostile/retaliate/meatvine/broodmother,
		/mob/living/simple_animal/hostile/retaliate/meatvine/burrower,
		/mob/living/simple_animal/hostile/retaliate/meatvine/spawnlord,
	)

	structures = list(
		/datum/action/cooldown/meatvine/spread_wormhole,
	)

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/transfer_resources,
		/datum/action/cooldown/meatvine/personal/emit_aura,
	)
