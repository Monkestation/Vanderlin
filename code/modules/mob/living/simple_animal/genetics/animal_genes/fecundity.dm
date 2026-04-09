/datum/animal_gene/fecundity
	name = "Fecundity"
	desc = "Affects reproductive drive, altering the cooldown between breeding cycles."
	rarity = 6
	exclusion_group = GENE_GROUP_BREEDING
	intensity_min = 1
	intensity_max = 10

/datum/animal_gene/fecundity/apply_to(mob/living/simple_animal/target)
	. = ..()
	if(.)
		return
	var/datum/component/breed/breed_component = target.GetComponent(/datum/component/breed)
	if(!breed_component)
		return
	// Intensity ranges 0.1–1.0; at max intensity, timer is halved. At min, barely changed.
	// Multiplier lands between 0.5 (max) and ~0.95 (min)
	var/multiplier = 1.0 - (intensity * 0.5)
	breed_component.breed_timer = max(breed_component.breed_timer * multiplier, 10 SECONDS)

/datum/animal_gene/fecundity/remove_from(mob/living/simple_animal/target)
	. = ..()
	if(!.)
		return
	var/datum/component/breed/breed_component = target.GetComponent(/datum/component/breed)
	if(!breed_component)
		return
	// Reverse the multiplier to restore the original timer
	var/multiplier = 1.0 - (intensity * 0.5)
	if(multiplier > 0)
		breed_component.breed_timer = breed_component.breed_timer / multiplier
