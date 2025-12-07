/mob/proc/add_stress(event)
	return TRUE

/mob/proc/remove_stress(event)
	return TRUE

/mob/proc/update_stress()
	return TRUE

/mob/proc/add_stress_list(list/event_list)
	return

/mob/proc/get_positive_stressors()
	return

/mob/proc/get_neutral_stressors()
	return

/mob/proc/get_negative_stressors()
	return

/mob/proc/get_stress_amount()
	return 0

/mob/proc/adjust_stress(amt)
	return TRUE

/mob/proc/has_stress_type(event)
	return

/mob/living/carbon
	var/stress = 0
	var/oldstress = 0
	var/stressbuffer = 0
	/// List of stressor instances
	var/list/stressors = list()
	var/last_announced_event_type
	COOLDOWN_DECLARE(stress_indicator)

/mob/living/carbon/adjust_stress(amt)
	stressbuffer = stressbuffer + amt
	stress = stress + stressbuffer
	stressbuffer = 0

	if(stress < STRESS_VGOOD)
		stressbuffer = stress - STRESS_VGOOD
		stress = STRESS_VGOOD

/mob/living/carbon/update_stress()
	if(HAS_TRAIT(src, TRAIT_NOMOOD))
		stress = 0
	for(var/datum/stress_event/event as anything in stressors)
		if(event.timer)
			if(world.time >= event.timer)
				remove_stress(event)

	if(stress != oldstress)
		switch(stress)
			if(STRESS_VGOOD)
				apply_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressvbad)
				remove_status_effect(/datum/status_effect/stress/stressinsane)
			if(STRESS_VGOOD+1 to STRESS_BAD-1)
				remove_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressvbad)
				remove_status_effect(/datum/status_effect/stress/stressinsane)
			if(STRESS_BAD to STRESS_VBAD-1)
				apply_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressvbad)
				remove_status_effect(/datum/status_effect/stress/stressinsane)
			if(STRESS_VBAD to STRESS_INSANE-1)
				apply_status_effect(/datum/status_effect/stress/stressvbad)
				remove_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressinsane)
			if(STRESS_INSANE to INFINITY)
				apply_status_effect(/datum/status_effect/stress/stressinsane)
				remove_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressvbad)
				if(!rogue_sneaking && !HAS_TRAIT(src, TRAIT_IMPERCEPTIBLE))
					INVOKE_ASYNC(src, PROC_REF(play_mental_break_indicator))

		var/event
		var/datum/stress_event/last_event = (length(stressors) ? stressors[length(stressors)] : null)
		var/event_type = last_event?.type
		
		if(last_event?.desc)
			var/desc = last_event.get_desc()
			event = islist(desc) ? jointext(desc, " ") : desc
			
		if(stress > oldstress)
			if(event && last_event.stress_change > 0)
				if(last_announced_event_type != event_type)
					to_chat(src, "[event]")
					last_announced_event_type = event_type
			to_chat(src, span_red(" I gain stress."))
			
			if(!rogue_sneaking && !HAS_TRAIT(src, TRAIT_IMPERCEPTIBLE))
				INVOKE_ASYNC(src, PROC_REF(play_stress_indicator))
			
		else
			if(event && last_event.stress_change <= 0)
				if(last_announced_event_type != event_type)
					to_chat(src, "[event]")
					last_announced_event_type = event_type
			to_chat(src, span_green(" I gain peace."))
			
			if(!rogue_sneaking && !HAS_TRAIT(src, TRAIT_IMPERCEPTIBLE))
				INVOKE_ASYNC(src, PROC_REF(play_relief_indicator))

		if(hud_used?.stressies)
			hud_used.stressies.update_appearance(UPDATE_OVERLAYS)
	oldstress = stress

	if(stress >= STRESS_INSANE && prob(5))
		var/text = pick_list("stress_messages.json", "insanity")
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_blurb), \
			targets = src, \
			duration = 3 SECONDS, \
			message = text, \
			fade_time = 3 SECONDS, \
			screen_position = "WEST+[rand(2,13)], SOUTH+[rand(1,12)]", \
			text_alignment = pick("left", "right", "center"), \
			text_color = "red")

/mob/living/carbon/get_stress_amount()
	if(HAS_TRAIT(src, TRAIT_NOMOOD))
		return 0
	return stress

/mob/living/carbon/has_stress_type(event_type)
	return locate(event_type) in stressors

/mob/living/carbon/get_positive_stressors()
	. = list()
	for(var/datum/stress_event/event as anything in stressors)
		if(event.get_stress(src) < 0)
			. += event

/mob/living/carbon/get_neutral_stressors()
	. = list()
	for(var/datum/stress_event/event as anything in stressors)
		if(event.get_stress(src) == 0)
			. += event

/mob/living/carbon/get_negative_stressors()
	. = list()
	for(var/datum/stress_event/event as anything in stressors)
		if(event.get_stress(src) < 0)
			. += event

/mob/living/carbon/add_stress(event_type)
	if(HAS_TRAIT(src, TRAIT_NOMOOD))
		return FALSE
	var/datum/stress_event/new_event = new event_type()
	if(!new_event.can_apply(src))
		return FALSE

	. = TRUE
	var/datum/stress_event/existing_event = has_stress_type(event_type)
	if(existing_event)
		existing_event.timer = initial(existing_event.timer) + world.time // RESET THE TIMER
		if(existing_event.stacks >= existing_event.max_stacks)
			return
		var/pre_stack = existing_event.get_stress()
		existing_event.stacks++
		var/post_stack = existing_event.get_stress()
		adjust_stress(post_stack-pre_stack)
		existing_event.on_apply(src)
	else
		new_event.timer += world.time
		stressors += new_event
		adjust_stress(new_event.get_stress())
		new_event.on_apply(src)
	SEND_SIGNAL(src, COMSIG_MOB_ADD_STRESS, new_event)

/// Accepts stress typepaths or a list of stress typepaths to remove.
/mob/living/carbon/remove_stress(event_to_remove)
	// if(HAS_TRAIT(src, TRAIT_NOMOOD))
	// 	return FALSE
	var/list/events_to_remove = islist(event_to_remove) ? event_to_remove : list(event_to_remove)
	for(var/stress_type in events_to_remove)
		var/datum/stress_event/stress_event = has_stress_type(stress_type)
		if(stress_event)
			adjust_stress(-1 * stress_event.get_stress())
			stressors -= stress_event
			qdel(stress_event)

/mob/living/carbon/add_stress_list(list/event_list)
	for(var/event_type in event_list)
		add_stress(event_type)