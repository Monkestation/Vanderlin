/// Pretend to be dead
/datum/ai_behavior/play_dead

/datum/ai_behavior/play_dead/setup(datum/ai_controller/controller)
	. = ..()
	var/mob/living/basic_pawn = controller.pawn
	if(!istype(basic_pawn) || basic_pawn.stat) // Can't act dead if you're dead
		return
	basic_pawn.emote("deathgasp", intentional = FALSE)
	ADD_TRAIT(basic_pawn, TRAIT_FAKEDEATH, "basic_death")
	basic_pawn.look_dead()

/datum/ai_behavior/play_dead/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	if(SPT_PROB(10, seconds_per_tick))
		finish_action(controller, TRUE)

/datum/ai_behavior/play_dead/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	var/mob/living/basic_pawn = controller.pawn
	if(QDELETED(basic_pawn) || basic_pawn.stat) // imagine actually dying while playing dead. hell, imagine being the kid waiting for your pup to get back up :(
		return
	basic_pawn.visible_message(span_notice("[basic_pawn] miraculously springs back to life!"))
	REMOVE_TRAIT(basic_pawn, TRAIT_FAKEDEATH, "basic_death")
	basic_pawn.look_alive()
	controller.clear_blackboard_key(BB_ACTIVE_PET_COMMAND)

/// Apply the appearance and properties this mob has when it is alive
/mob/living/proc/look_alive()

/mob/living/simple_animal/look_alive()
	icon_state = icon_living
	density = initial(density)

/**
 * Apply the appearance and properties this mob has when it dies
 * This is called by the mob pretending to be dead too so don't put loot drops in here or something
 */
/mob/living/proc/look_dead()

/mob/living/simple_animal/look_dead()
	icon_state = icon_dead
	density = TRUE
