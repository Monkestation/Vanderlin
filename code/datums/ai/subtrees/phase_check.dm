/datum/ai_planning_subtree/fishboss_check_phase

/datum/ai_planning_subtree/fishboss_check_phase/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/mob/living/simple_animal/hostile/boss/fishboss/boss = controller.pawn
	if(!istype(boss))
		return

	var/current_phase = controller.blackboard[BB_RAGE_PHASE]
	var/health_percent = boss.health / boss.maxHealth

	var/new_phase = 0
	if(health_percent <= 0.25)
		new_phase = 3 // Final phase
	else if(health_percent <= 0.5)
		new_phase = 2 // Third phase
	else if(health_percent <= 0.75)
		new_phase = 1 // Second phase

	// If we're entering a new phase
	if(new_phase > current_phase)
		controller.set_blackboard_key(BB_RAGE_PHASE, new_phase)
		SEND_SIGNAL(boss, COMSIG_PHASE_CHANGE, new_phase)
		INVOKE_ASYNC(boss, TYPE_PROC_REF(/mob/living/simple_animal/hostile/boss/fishboss, enter_new_phase), new_phase)
