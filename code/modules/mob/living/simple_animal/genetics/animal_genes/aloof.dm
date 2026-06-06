/datum/animal_gene/aloof
	name = "Aloof"
	desc = "Keeps to itself. Takes significantly longer to warm up to caretakers."
	rarity = 8
	exclusion_group = GENE_GROUP_TEMPERAMENT
	intensity_min = 11
	intensity_max = 18

/datum/animal_gene/aloof/apply_to(mob/living/simple_animal/target)
	if(..())
		return
	var/penalty_mult = 1.0 - ((intensity - 1.0) * 0.5)
	SEND_SIGNAL(target, COMSIG_MOB_SET_HAPPINESS_MULTIPLIER, penalty_mult)

/datum/animal_gene/aloof/remove_from(mob/living/simple_animal/target)
	if(!..())
		return
	SEND_SIGNAL(target, COMSIG_MOB_SET_HAPPINESS_MULTIPLIER, 1.0)
