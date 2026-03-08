/datum/animal_gene/fat
	name = "Fat"
	desc = "Heavyset build. More meat when butchered, but slower."
	rarity = 8
	exclusion_group = GENE_GROUP_BODY_SIZE
	intensity_min = 11
	intensity_max = 18

/datum/animal_gene/fat/apply_to(mob/living/simple_animal/hostile/target)
	if(..())
		return
	target.genetic_butcher_scale = intensity
	var/hp_bonus = round(initial(target.maxHealth) * (intensity - 1.0) * 0.5)
	target.maxHealth += hp_bonus
	target.health = min(target.health + hp_bonus, target.maxHealth)
	var/delay_penalty = round((intensity - 1.0) * 5)
	target.genetic_speed_delta += delay_penalty
	if(target.ai_controller)
		target.ai_controller.movement_delay = max(1, target.ai_controller.movement_delay + delay_penalty)
	target.move_to_delay = max(1, target.move_to_delay + delay_penalty)

/datum/animal_gene/fat/remove_from(mob/living/simple_animal/hostile/target)
	if(!..())
		return
	target.genetic_butcher_scale = initial(target.genetic_butcher_scale)
	var/hp_bonus = round(initial(target.maxHealth) * (intensity - 1.0) * 0.5)
	target.maxHealth -= hp_bonus
	target.health = min(target.health, target.maxHealth)
	var/delay_penalty = round((intensity - 1.0) * 5)
	target.genetic_speed_delta -= delay_penalty
	if(target.ai_controller)
		target.ai_controller.movement_delay -= delay_penalty
	target.move_to_delay = max(1, target.move_to_delay - delay_penalty)
