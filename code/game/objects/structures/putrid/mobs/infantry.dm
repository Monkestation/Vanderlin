/mob/living/simple_animal/hostile/retaliate/meatvine/infantry
	icon_state = "infantry"
	icon_living = "infantry"
	icon_dead = "infantry_dead"
	ranged = TRUE
	projectiletype = /obj/projectile/meatbullet

	minimum_distance = 2

	possible_evolutions = list(
		/mob/living/simple_animal/hostile/retaliate/meatvine/artiliery,
		/mob/living/simple_animal/hostile/retaliate/meatvine/warrior,
	)

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/ranged/spread/lethal,
		/datum/action/cooldown/meatvine/personal/slow_ground,
		/datum/action/cooldown/meatvine/personal/acid_spray,
	)
