/datum/augment
	var/name = "base augment"
	var/desc = "A mechanical augmentation."
	var/stability_cost = 0 // Negative values add stability, positive values reduce it
	var/engineering_difficulty = SKILL_RANK_NOVICE
	var/installation_time = 10 SECONDS
	var/mob/living/carbon/parent
	var/list/incompatible_installations = list()
	var/color = COLOR_ASSEMBLY_BLUE
	var/enabled = FALSE

/datum/augment/proc/on_install(mob/living/carbon/human/H)
	if(!enabled)
		enabled = TRUE
		return TRUE

/datum/augment/proc/on_remove(mob/living/carbon/human/H)
	if(enabled)
		enabled = FALSE
		return TRUE

/datum/augment/Destroy(force, ...)
	if(parent)
		on_remove(parent)
		parent = null
	. = ..()

/datum/augment/proc/get_examine_info()
	return
