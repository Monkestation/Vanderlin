/datum/animal_gene/frail
	name = "Frail"
	desc = "Delicate constitution. Lower max health."
	rarity = 6
	exclusion_group = GENE_GROUP_CONSTITUTION
	intensity_min = 1
	intensity_max = 5

/datum/animal_gene/frail/apply_to(mob/living/simple_animal/hostile/target)
	if(..())
		return
	var/loss = round(initial(target.maxHealth) * intensity)
	target.maxHealth = max(5, target.maxHealth - loss)
	target.health = min(target.health, target.maxHealth)

/datum/animal_gene/frail/remove_from(mob/living/simple_animal/hostile/target)
	if(!..())
		return
	var/loss = round(initial(target.maxHealth) * intensity)
	target.maxHealth += loss
	target.health = min(target.health, target.maxHealth)
