/datum/animal_gene/barren
	name = "Barren"
	desc = "Dulls reproductive drive, significantly extending the cooldown between breeding cycles."
	rarity = 6
	exclusion_group = GENE_GROUP_BREEDING
	intensity_min = 1
	intensity_max = 10

/datum/animal_gene/barren/apply_to(mob/living/simple_animal/target)
	. = ..()
	if(.)
		return
	var/datum/component/breed/breed_component = target.GetComponent(/datum/component/breed)
	if(!breed_component)
		return
	// At max intensity, timer is doubled. At min, barely changed.
	// Multiplier lands between ~1.05 (min) and 2.0 (max)
	var/multiplier = 1.0 + (intensity * 1.0)
	breed_component.breed_timer = breed_component.breed_timer * multiplier

/datum/animal_gene/barren/remove_from(mob/living/simple_animal/target)
	. = ..()
	if(!.)
		return
	var/datum/component/breed/breed_component = target.GetComponent(/datum/component/breed)
	if(!breed_component)
		return
	var/multiplier = 1.0 + (intensity * 1.0)
	breed_component.breed_timer = breed_component.breed_timer / multiplier
