/* * * * * * * * * * * **
 *						*	-Azaraks total Farming conversion, 90% + of the code is his
 *		 Neu Farming	*	-Yeets old RT:s bad copy of TG hydroponics completely
 *						*	-Tweaks and various improvements added, lots of new art
 *						*
 * * * * * * * * * * * **/


/proc/get_soil_on_turf(turf/target_turf)
	for(var/atom/movable/movable as anything in target_turf.contents)
		// Soil does not have subtypes
		if(movable.type == /obj/structure/soil)
			return movable
	return null

/proc/get_farming_effort_divisor(mob/user)
	return (1 / get_farming_effort_multiplier(user))

/proc/get_farming_effort_multiplier(mob/user, factor = 2)
	return (10 + (user.get_skill_level(/datum/skill/labor/farming, TRUE) * factor)) * 0.1

/proc/get_farming_do_time(mob/user, time)
	return time / get_farming_effort_multiplier(user, 3)

/proc/apply_farming_fatigue(mob/user, fatigue_amount)
	var/multiplier = get_farming_effort_multiplier(user)
	user.adjust_stamina(fatigue_amount / multiplier)

/proc/adjust_experience(mob/user, skill_type, exp_amount)
	user.adjust_experience(skill_type, exp_amount)

/proc/add_sleep_experience(mob/user, skill_type, exp_amount)
	if(user.mind)
		user.mind?.add_sleep_experience(skill_type, exp_amount)
	else
		user.adjust_experience(skill_type, exp_amount)
