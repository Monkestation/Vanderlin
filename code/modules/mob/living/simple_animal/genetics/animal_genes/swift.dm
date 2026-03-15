/datum/animal_gene/swift
	name = "Swift"
	desc = "Faster than average. Harder to herd or catch."
	rarity = 6
	exclusion_group = GENE_GROUP_SPEED
	intensity_min = 5
	intensity_max = 30

/datum/animal_gene/swift/apply_to(mob/living/simple_animal/hostile/target)
	if(..())
		return
	var/reduction = round(intensity)
	target.genetic_speed_delta -= reduction
	if(target.ai_controller)
		target.ai_controller.movement_delay = max(1, target.ai_controller.movement_delay - reduction)

	target.move_to_delay = max(1, target.move_to_delay - reduction)

/datum/animal_gene/swift/remove_from(mob/living/simple_animal/hostile/target)
	if(!..())
		return
	var/reduction = round(intensity)
	target.genetic_speed_delta += reduction
	if(target.ai_controller)
		target.ai_controller.movement_delay += reduction
	target.move_to_delay += reduction
