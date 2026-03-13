/datum/animal_gene/ravenous
	name = "Ravenous"
	desc = "A bottomless appetite. Burns through food reserves at an alarming rate."
	rarity = 8
	exclusion_group = GENE_GROUP_METABOLISM
	intensity_min = 11
	intensity_max = 18

/datum/animal_gene/ravenous/apply_to(mob/living/simple_animal/target)
	if(..())
		return
	var/datum/component/generic_mob_hunger/hunger = target.GetComponent(/datum/component/generic_mob_hunger)
	if(!hunger)
		return
	// intensity 1.1–1.8 maps to a 10–80% increase in drain
	var/increase = (intensity - 1.0) * 0.5
	hunger.hunger_drain = hunger.hunger_drain * (1.0 + increase)

/datum/animal_gene/ravenous/remove_from(mob/living/simple_animal/target)
	if(!..())
		return
	var/datum/component/generic_mob_hunger/hunger = target.GetComponent(/datum/component/generic_mob_hunger)
	if(!hunger)
		return
	var/increase = (intensity - 1.0) * 0.5
	hunger.hunger_drain = hunger.hunger_drain / (1.0 + increase)
