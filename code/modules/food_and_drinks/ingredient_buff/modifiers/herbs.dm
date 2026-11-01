/datum/ingredient_buff_modifier/atropa
	name = "atropa"
	granted_buff_type = /datum/ingredient_buff/atropa

/datum/ingredient_buff/atropa
	status_effect_type = /datum/status_effect/buff/ingredient/atropa
	random_choice = 0
	base_duration = 1 MINUTES

/datum/ingredient_buff/atropa/examine_string()
	return span_notice("Causes mild poisoning when used as a topping.")

/datum/status_effect/buff/ingredient/atropa
	id = "Topping Effect: Atropa Poisoning"
	tick_interval = 5 SECONDS
	var/vomit_buildup = 0

/datum/status_effect/buff/ingredient/atropa/tick(seconds_between_ticks)
	if(HAS_TRAIT(owner, TRAIT_TOXIMMUNE))
		return
	var/mob/living/carbon/human/human_eater = owner
	if(HAS_TRAIT(owner, TRAIT_TOXINLOVER))
		human_eater.add_stress(/datum/stress_event/favourite_food)
		return
	owner.adjustToxLoss(2 * quality)
	vomit_buildup += 10 + (quality * 5)
	if(vomit_buildup >= 100)
		vomit_buildup -= 100
		human_eater.vomit()

/datum/ingredient_buff_modifier/necran_lily
	name = "necran lily"
	granted_buff_type = /datum/ingredient_buff/necran_lily

/datum/ingredient_buff/atropa
	status_effect_type = /datum/status_effect/buff/ingredient/necran_lily
	random_choice = 0
	base_duration = 1 MINUTES

/datum/ingredient_buff/necran_lily/examine_string()
	return span_notice("Causes severe poisoning when used as a topping.")

/datum/status_effect/buff/ingredient/necran_lily
	id = "Topping Effect: Necran Lily Poisoning"
	tick_interval = 5 SECONDS
	var/vomit_buildup = 0

/datum/status_effect/buff/ingredient/necran_lily/tick(seconds_between_ticks)
	if(HAS_TRAIT(owner, TRAIT_TOXIMMUNE))
		return
	var/mob/living/carbon/human/human_eater = owner
	if(HAS_TRAIT(owner, TRAIT_TOXINLOVER))
		human_eater.add_stress(/datum/stress_event/favourite_food)
		return
	owner.adjustToxLoss(10 * quality)
	vomit_buildup += 10 + (quality * 5)
	if(vomit_buildup >= 100)
		vomit_buildup -= 100
		human_eater.vomit()
