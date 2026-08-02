/datum/animal_gene/affectionate
	name = "Affectionate"
	desc = "Bonds quickly with caretakers, forming attachments faster than most animals."
	rarity = 6
	exclusion_group = GENE_GROUP_TEMPERAMENT
	intensity_min = 11
	intensity_max = 18

/datum/animal_gene/affectionate/apply_to(mob/living/simple_animal/target)
	if(..())
		return
	var/bonus_mult = 1.0 + ((intensity - 1.0) * 0.5)
	SEND_SIGNAL(target, COMSIG_MOB_SET_HAPPINESS_MULTIPLIER, bonus_mult)

/datum/animal_gene/affectionate/remove_from(mob/living/simple_animal/target)
	if(!..())
		return
	SEND_SIGNAL(target, COMSIG_MOB_SET_HAPPINESS_MULTIPLIER, 1.0)
