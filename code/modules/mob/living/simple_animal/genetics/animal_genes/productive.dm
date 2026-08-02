/datum/animal_gene/productive
	name = "Productive"
	desc = "High-yield. Produces milk, wool, or eggs more frequently."
	rarity = 4

/datum/animal_gene/productive/apply_to(mob/living/simple_animal/hostile/target)
	if(..())
		return
	ADD_TRAIT(target, TRAIT_ANIMAL_PRODUCTIVE, GENETICS_TRAIT)

/datum/animal_gene/productive/remove_from(mob/living/simple_animal/hostile/target)
	if(!..())
		return
	REMOVE_TRAIT(target, TRAIT_ANIMAL_PRODUCTIVE, GENETICS_TRAIT)
