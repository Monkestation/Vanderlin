/mob/living/simple_animal/hostile/retaliate/meatvine/range
	icon_state = "harvester"
	icon_living = "harvester"
	icon_dead = "harvester_dead"
	ranged = TRUE
	projectiletype = /obj/projectile/meatbullet

	minimum_distance = 2

	possible_evolutions = list(
		/mob/living/simple_animal/hostile/retaliate/meatvine/infantry,
	)

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/ranged/spread/lethal,
		/datum/action/cooldown/meatvine/personal/slow_ground,
	)
