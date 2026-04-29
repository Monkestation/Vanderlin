/datum/ai_planning_subtree/detect_vampire_or_race
	var/detection_range = 5


/datum/ai_planning_subtree/detect_vampire_or_race/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()

	var/mob/living/simple_animal/pet/cat/cat_pawn = controller.pawn
	if(!istype(cat_pawn) || cat_pawn.stat == DEAD)
		return
	if(!controller.blackboard[BB_CAT_RACISM])
		return

	controller.queue_behavior(/datum/ai_behavior/detect_and_hiss, BB_CAT_RACISM)

/datum/ai_behavior/detect_and_hiss
	action_cooldown = 2 SECONDS
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/detect_and_hiss/perform(delta_time, datum/ai_controller/controller, racism_enabled)
	. = ..()

	var/mob/living/simple_animal/pet/cat/cat_pawn = controller.pawn
	if(!istype(cat_pawn) || cat_pawn.stat == DEAD)
		finish_action(controller, FALSE)
		return

	var/datum/ai_planning_subtree/detect_vampire_or_race/subtree = locate() in controller.planning_subtrees
	var/detection_range = subtree?.detection_range || 5

	// Find nearby mobs
	for(var/mob/living/M in oview(detection_range, cat_pawn))
		var/should_hiss = FALSE
		var/slap = FALSE

		if(M.mind && M.mind.has_antag_datum(/datum/antagonist/vampire))
			should_hiss = TRUE
			if(cat_pawn.CanReach(M))
				slap = TRUE

		else if(racism_enabled && (isdarkelf(M) || ishalforc(M) || istiefling(M)))
			should_hiss = TRUE
			if(cat_pawn.CanReach(M))
				slap = TRUE

		if(should_hiss)
			cat_pawn.visible_message(span_notice("\The [cat_pawn] hisses at [M] and slashes in disgust!"))
			cat_pawn.icon_state = "[cat_pawn.icon_living]"
			cat_pawn.set_resting(FALSE)
			playsound(cat_pawn, 'sound/vo/mobs/cat/cathiss.ogg', 80, TRUE, -1)
			if(slap)
				playsound(M, "smallslash", 100, TRUE, -1)
				cat_pawn.do_attack_animation(M, "claw")
				M.adjustBruteLoss(1)

			cat_pawn.dir = pick(GLOB.alldirs)
			step(cat_pawn, cat_pawn.dir)

			cat_pawn.personal_space()

			finish_action(controller, TRUE)
			return

	finish_action(controller, FALSE)
