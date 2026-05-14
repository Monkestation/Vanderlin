/datum/idle_behavior/idle_random_bum
	///Chance that the mob random walks per second
	var/walk_chance = 25
	var/cooldown = 2 SECONDS
	var/next_time = 0

/datum/idle_behavior/idle_random_bum/perform_idle_behavior(delta_time, datum/ai_controller/controller)
	. = ..()
	if(next_time > world.time)
		return
	if(controller.blackboard[BB_BASIC_MOB_FOOD_TARGET]) // this means we are likely eating a corpse
		return

	var/mob/living/simple_animal/wanderer = controller.pawn
	if(istype(wanderer))
		if(wanderer.binded)
			return

	next_time = world.time + cooldown
	var/mob/living/living_pawn = controller.pawn
	if(prob(walk_chance) && !HAS_TRAIT(living_pawn, TRAIT_IMMOBILIZED) && isturf(living_pawn.loc) && !living_pawn.pulledby)
		var/move_dir = pick(GLOB.alldirs)
		var/turf/step_turf = get_step(living_pawn, move_dir)
		if(is_type_in_typecache(step_turf, GLOB.dangerous_turfs))
			return
		living_pawn.Move(step_turf, move_dir)

	if(prob(3))
		living_pawn.say(pick(GLOB.bum_quotes))
	if(prob(3))
		living_pawn.emote(pick("laugh","burp","yawn","grumble","mumble","blink_r","clap"))
