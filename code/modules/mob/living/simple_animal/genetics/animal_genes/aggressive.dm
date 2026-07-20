/datum/animal_gene/aggressive
	name = "Aggressive"
	desc = "Territorial. Will attack nearby creatures unprovoked."
	rarity = 3
	dominant = TRUE
	exclusion_group = GENE_GROUP_HAPPINESS


/datum/animal_gene/aggressive/apply_to(mob/living/simple_animal/hostile/target)
	if(..())
		return
	if(!target.ai_controller)
		return
	target.ai_controller.remove_subtree(/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee)
	target.ai_controller.remove_subtree(/datum/ai_planning_subtree/flee_target)
	target.ai_controller.remove_subtree(/datum/ai_planning_subtree/look_for_adult)
	target.ai_controller.add_subtree_at(/datum/ai_planning_subtree/aggro_find_target, 1)
	var/aggro_index = target.ai_controller.get_subtree_index(/datum/ai_planning_subtree/aggro_find_target)
	target.ai_controller.add_subtree_at(/datum/ai_planning_subtree/basic_melee_attack_subtree, aggro_index + 1)
	if(!target.GetComponent(/datum/component/ai_aggro_system))
		target.AddComponent(/datum/component/ai_aggro_system)
	target.melee_damage_lower = max(target.melee_damage_lower, 3)
	target.melee_damage_upper = max(target.melee_damage_upper, 6)

/datum/animal_gene/aggressive/remove_from(mob/living/simple_animal/hostile/target)
	if(!..())
		return
	if(!target.ai_controller)
		return
	target.ai_controller.remove_subtree(/datum/ai_planning_subtree/aggro_find_target)
	target.ai_controller.remove_subtree(/datum/ai_planning_subtree/basic_melee_attack_subtree)
	target.ai_controller.add_subtree_at(/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee)
	target.ai_controller.add_subtree_at(/datum/ai_planning_subtree/flee_target)
	qdel(target.GetComponent(/datum/component/ai_aggro_system))
	target.melee_damage_lower = initial(target.melee_damage_lower)
	target.melee_damage_upper = initial(target.melee_damage_upper)
