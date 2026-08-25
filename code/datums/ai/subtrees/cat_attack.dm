/datum/ai_planning_subtree/basic_melee_attack_subtree/cat
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack/cat
	end_planning = TRUE

/datum/ai_behavior/basic_melee_attack/cat
	action_cooldown = 0.2 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/basic_melee_attack/cat/perform(seconds_per_tick, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()

	var/mob/living/simple_animal/pet/cat/cat_pawn = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	if(QDELETED(target))
		finish_action(controller, FALSE, target_key)
		return

	if(istype(target, /obj/item/reagent_containers/food/snacks/smallrat))
		var/obj/item/reagent_containers/food/snacks/smallrat/rat = target
		if(!rat.dead && cat_pawn.CanReach(rat))
			cat_pawn.visible_message("<span class='notice'>\The [cat_pawn] kills the rat!</span>")
			rat.atom_destruction()
			finish_action(controller, TRUE, target_key)
			return

	// Default attack behavior for other targets
	return ..()
