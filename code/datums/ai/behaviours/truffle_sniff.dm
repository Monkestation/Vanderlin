/datum/ai_behavior/truffle_sniff
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/truffle_sniff/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	var/atom/random_target
	var/list/turfs = list()
	for(var/turf/open/turf in view(5, controller.pawn))
		turfs |= turf

	random_target = pick(turfs)
	controller.set_blackboard_key(target_key, random_target)
	set_movement_target(controller, random_target)

/datum/ai_behavior/truffle_sniff/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()
	var/turf/target = controller.blackboard[target_key]
	var/mob/living/pawn = controller.pawn
	if(!isturf(target))
		finish_action(controller, FALSE, target_key)
		return

	controller.PauseAi(5 SECONDS)
	playsound(pawn, pick('sound/vo/mobs/pig/grunt (1).ogg','sound/vo/mobs/pig/grunt (2).ogg'), 100, TRUE, -1)
	pawn.dir = pick(GLOB.cardinals)
	step(pawn, pawn.dir)
	playsound(pawn, 'sound/items/sniff.ogg', 60, FALSE)
	sleep(10)
	pawn.dir = pick(GLOB.cardinals)
	step(pawn, pawn.dir)
	playsound(pawn, 'sound/items/sniff.ogg', 60, FALSE)
	sleep(10)
	pawn.dir = pick(GLOB.cardinals)
	playsound(pawn, pick('sound/vo/mobs/pig/grunt (1).ogg','sound/vo/mobs/pig/grunt (2).ogg'), 100, TRUE, -1)
	var/turf/t = get_turf(pawn)
	trufflesearch(t, 5)

	controller.PauseAi(0)
	finish_action(controller, FALSE, target_key)

/datum/ai_behavior/truffle_sniff/proc/trufflesearch(turf/T, range = world.view)
	var/list/found_stuff = list()
	for(var/turf/open/floor/dirt/M in range(range, T))
		if(M.hidden_truffles)
			found_stuff += M
	if(LAZYLEN(found_stuff))
		for(var/turf/open/floor/dirt/M in found_stuff)
			var/obj/effect/temp_visual/truffle_overlay/oldC = locate(/obj/effect/temp_visual/truffle_overlay) in M
			if(oldC)
				qdel(oldC)
			new /obj/effect/temp_visual/truffle_overlay(M)
