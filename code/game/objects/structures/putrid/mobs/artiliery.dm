/mob/living/simple_animal/hostile/retaliate/meatvine/artiliery
	icon_state = "artiliery"
	icon_living = "artiliery"
	icon_dead = "artiliery_dead"
	icon = 'icons/obj/cellular/putrid_large.dmi'

	ranged = TRUE
	projectiletype = /obj/projectile/meatbullet

	minimum_distance = 2

	possible_evolutions = list()

	personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
		/datum/action/cooldown/meatvine/personal/ranged/spread/lethal,
		/datum/action/cooldown/meatvine/personal/slow_ground,
		/datum/action/cooldown/meatvine/personal/bombard,
	)
