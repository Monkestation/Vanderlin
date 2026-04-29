/datum/animal_gene/lean
	name = "Lean"
	desc = "Slender build. Less meat when butchered, but slightly quicker."
	rarity = 8
	exclusion_group = GENE_GROUP_BODY_SIZE
	intensity_min = 3
	intensity_max = 8

/datum/animal_gene/lean/apply_to(mob/living/simple_animal/hostile/target)
	if(..())
		return
	target.genetic_butcher_scale = intensity
	var/hp_loss = round(initial(target.maxHealth) * (1.0 - intensity) * 0.4)
	target.maxHealth = max(5, target.maxHealth - hp_loss)
	target.health = min(target.health, target.maxHealth)
	var/delay_bonus = round((1.0 - intensity) * 3)
	target.genetic_speed_delta -= delay_bonus
	if(target.ai_controller)
		target.ai_controller.movement_delay = max(1, target.ai_controller.movement_delay - delay_bonus)
	target.move_to_delay = max(1, target.move_to_delay - delay_bonus)

/datum/animal_gene/lean/remove_from(mob/living/simple_animal/hostile/target)
	if(!..())
		return
	target.genetic_butcher_scale = initial(target.genetic_butcher_scale)
	var/hp_loss = round(initial(target.maxHealth) * (1.0 - intensity) * 0.4)
	target.maxHealth += hp_loss
	target.health = min(target.health, target.maxHealth)
	var/delay_bonus = round((1.0 - intensity) * 3)
	target.genetic_speed_delta += delay_bonus
	if(target.ai_controller)
		target.ai_controller.movement_delay += delay_bonus
	target.move_to_delay += delay_bonus
