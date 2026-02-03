/datum/augment
	var/name = "base augment"
	var/desc = "A mechanical augmentation."
	var/stability_cost = 0 // Negative values add stability, positive values reduce it
	var/engineering_difficulty = SKILL_LEVEL_NOVICE
	var/installation_time = 10 SECONDS
	var/mob/living/carbon/parent

/datum/augment/proc/on_install(mob/living/carbon/human/H)
	return

/datum/augment/proc/on_remove(mob/living/carbon/human/H)
	return

/datum/augment/proc/get_examine_info()
	return
