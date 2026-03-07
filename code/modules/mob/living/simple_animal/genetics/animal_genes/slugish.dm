/datum/animal_gene/sluggish
	name = "Sluggish"
	desc = "Slower than average. Easy to herd."
	rarity = 8
	exclusion_group = GENE_GROUP_SPEED
	intensity_min = 10
	intensity_max = 50

/datum/animal_gene/sluggish/apply_to(mob/living/simple_animal/hostile/target)
	if(..())
		return
	var/penalty = round(intensity)
	target.genetic_speed_delta += penalty
	if(target.ai_controller)
		target.ai_controller.movement_delay += penalty
	target.move_to_delay += penalty

/datum/animal_gene/sluggish/remove_from(mob/living/simple_animal/hostile/target)
	if(!..())
		return
	var/penalty = round(intensity)
	target.genetic_speed_delta -= penalty
	if(target.ai_controller)
		target.ai_controller.movement_delay -= penalty
	target.move_to_delay -= penalty
