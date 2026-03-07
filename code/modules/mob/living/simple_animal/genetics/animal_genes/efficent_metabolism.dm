/datum/animal_gene/efficient_metabolism
	name = "Efficient Metabolism"
	desc = "Processes food slowly and efficiently, requiring fewer calories to sustain itself."
	rarity = 6
	exclusion_group = GENE_GROUP_METABOLISM
	intensity_min = 11
	intensity_max = 18

/datum/animal_gene/efficient_metabolism/apply_to(mob/living/simple_animal/target)
	if(..())
		return
	var/datum/component/generic_mob_hunger/hunger = target.GetComponent(/datum/component/generic_mob_hunger)
	if(!hunger)
		return
	var/reduction = (intensity - 1.0) * 0.5  // 0.05–0.40 multiplier reduction
	hunger.hunger_drain = max(0.01, hunger.hunger_drain * (1.0 - reduction))

/datum/animal_gene/efficient_metabolism/remove_from(mob/living/simple_animal/target)
	if(!..())
		return
	var/datum/component/generic_mob_hunger/hunger = target.GetComponent(/datum/component/generic_mob_hunger)
	if(!hunger)
		return
	var/reduction = (intensity - 1.0) * 0.5
	hunger.hunger_drain = hunger.hunger_drain / (1.0 - reduction)
