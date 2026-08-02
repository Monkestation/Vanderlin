/datum/animal_gene/hardy
	name = "Hardy"
	desc = "Robust constitution. Significantly higher max health."
	rarity = 6

	exclusion_group = GENE_GROUP_CONSTITUTION
	intensity_min = 2
	intensity_max = 6

/datum/animal_gene/hardy/apply_to(mob/living/simple_animal/hostile/target)
	if(..())
		return
	var/bonus = round(initial(target.maxHealth) * intensity)
	target.maxHealth += bonus
	target.health = min(target.health + bonus, target.maxHealth)

/datum/animal_gene/hardy/remove_from(mob/living/simple_animal/hostile/target)
	if(!..())
		return
	var/bonus = round(initial(target.maxHealth) * intensity)
	target.maxHealth -= bonus
	target.health = min(target.health, target.maxHealth)
