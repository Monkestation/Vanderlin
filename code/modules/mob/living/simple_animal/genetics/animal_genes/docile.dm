/datum/animal_gene/docile
	name = "Docile"
	desc = "Exceptionally calm. Much easier to tame; won't flee when struck."
	rarity = 4
	exclusion_group = GENE_GROUP_HAPPINESS

/datum/animal_gene/docile/apply_to(mob/living/simple_animal/hostile/target)
	if(..())
		return
	target.tame_chance = min(95, target.tame_chance + 30)
	target.bonus_tame_chance += 10
	if(target.ai_controller)
		target.ai_controller.remove_subtree(/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee)
		target.ai_controller.remove_subtree(/datum/ai_planning_subtree/flee_target)
		target.ai_controller.remove_subtree(/datum/ai_planning_subtree/aggro_find_target)
		target.ai_controller.remove_subtree(/datum/ai_planning_subtree/basic_melee_attack_subtree)

/datum/animal_gene/docile/remove_from(mob/living/simple_animal/hostile/target)
	if(!..())
		return
	target.tame_chance = max(0, target.tame_chance - 30)
	target.bonus_tame_chance -= 10
	if(target.ai_controller)
		target.ai_controller.add_subtree_at(/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee)
		target.ai_controller.add_subtree_at(/datum/ai_planning_subtree/flee_target)

