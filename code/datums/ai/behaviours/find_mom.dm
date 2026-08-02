/datum/ai_behavior/find_mom
	///range to look for the mom
	var/look_range = 7
	/// Ignore mother setting checks if mob has this
	var/priority_trait

/datum/ai_behavior/find_mom/perform(seconds_per_tick, datum/ai_controller/controller, mom_key, ignore_mom_key, found_mom)
	. = ..()

	var/mob/living_pawn = controller.pawn
	var/list/mom_types = controller.blackboard[mom_key]
	var/list/all_moms = list()
	var/list/ignore_types = controller.blackboard[ignore_mom_key]

	if(!length(mom_types))
		finish_action(controller, FALSE)
		return

	for(var/mob/mother in oview(look_range, living_pawn))
		if(priority_trait && HAS_TRAIT(mother, priority_trait))
			all_moms += mother
			continue
		if(!is_type_in_list(mother, mom_types))
			continue
		if(is_type_in_list(mother, ignore_types)) //so the not permanent baby and the permanent baby subtype dont followed each other
			continue
		all_moms += mother

	if(length(all_moms))
		var/mob/mom = pick(all_moms)
		controller.set_blackboard_key(found_mom, mom)
		controller.set_blackboard_key(BB_FRIENDS_LIST, mom.ai_controller.blackboard[BB_FRIENDS_LIST])
		APPLY_FACTION_AND_ALLIES_FROM(living_pawn, mom)
		finish_action(controller, TRUE)
		return
	finish_action(controller, FALSE)

/datum/ai_behavior/find_mom/kitten
	priority_trait = TRAIT_KITTEN_MOM
