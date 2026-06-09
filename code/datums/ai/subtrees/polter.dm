/datum/ai_planning_subtree/polter/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	controller.queue_behavior(/datum/ai_behavior/polter)

/datum/ai_behavior/polter
	action_cooldown = 1 SECONDS
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/polter/perform(seconds_per_tick, datum/ai_controller/controller, ...)
	. = ..()
	var/mob/living/polter = controller.pawn
	for(var/mob/living/carbon/human/H in view(15, polter))
		var/most_violent = -1
		var/obj/item/throwing
		for(var/obj/item/I in view(15, get_turf(H)))
			if(I.anchored)
				continue
			if(I.throwforce > most_violent)
				most_violent = I.throwforce
				throwing = I
		if(throwing)
			playsound(polter, pick('sound/vo/mobs/poltergeist/polter_damage0.ogg',
						'sound/vo/mobs/poltergeist/polter_damage1.ogg',
						'sound/vo/mobs/poltergeist/polter_damage2.ogg'))
			throwing.throw_at(H, 8, 2)
	finish_action(controller, TRUE)
