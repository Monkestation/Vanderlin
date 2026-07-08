SUBSYSTEM_DEF(objectivequests)
	name = "Objective Quests"
	wait = 5 SECONDS
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	init_order = INIT_ORDER_OBJECTIVE_QUEST

	///singleton list of all objective_quest_driver subtypes
	var/list/datum/objective_quest_driver/objectives = list()

/datum/controller/subsystem/objectivequests/Initialize(start_timeofday)
	for(var/atom/subtype as anything in subtypesof(/datum/objective_quest_driver))
		if(IS_ABSTRACT(subtype))
			continue
		objectives += new subtype()
	return ..()

/datum/controller/subsystem/objectivequests/fire(resumed)
	for(var/datum/objective_quest_driver/OQD as anything in objectives)
		if(!COOLDOWN_FINISHED(OQD, trigger_cooldown))
			continue
		if(!OQD.is_eligible())
			continue

		var/to_spawn = OQD.get_spawn_amount()
		for(var/i in 1 to to_spawn)
			var/datum/quest/Q = OQD.generate_quest()
			if(!Q)
				continue
			SSquestboard.quest_pool[Q.quest_difficulty] += Q

		COOLDOWN_START(OQD, trigger_cooldown, OQD.cooldown_time)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/objectivequests/proc/get_driver(driver_type)
	for(var/datum/objective_quest_driver/OQD as anything in objectives)
		if(istype(OQD, driver_type))
			return OQD
	return null

///this avoids globals or signals idk if its better tbh
/datum/controller/subsystem/objectivequests/proc/modify_value(quest_driver_type, amount)
	for(var/datum/objective_quest_driver/OQD as anything in objectives)
		if(!istype(OQD, quest_driver_type))
			continue
		OQD.current_value = clamp(OQD.current_value + amount, OQD.value_min, OQD.value_max)
		return TRUE
	return FALSE

/datum/controller/subsystem/objectivequests/proc/increase_value(quest_driver_type, amount)
	return modify_value(quest_driver_type, abs(amount))

/datum/controller/subsystem/objectivequests/proc/decrease_value(quest_driver_type, amount)
	return modify_value(quest_driver_type, -abs(amount))
