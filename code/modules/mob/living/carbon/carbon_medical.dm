
/mob/living/carbon/proc/pump_heart(mob/user, forced_pump)
	if(!forced_pump)
		var/heymedic = max(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/misc/medicine), 0)/SKILL_MASTER
		recent_heart_pump = list("[world.time]" = (0.3 + CEILING(heymedic, 0.1)))
	else
		recent_heart_pump = list("[world.time]" = (0.3 + CEILING(forced_pump, 0.1)))
	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(heart)
		heart.current_blood = heart.max_blood_storage
	set_heartattack(FALSE)
	return TRUE

/mob/living/carbon/proc/check_pulse(mob/living/carbon/user)
	. = TRUE
	var/self = FALSE
	if(user == src)
		self = TRUE

	var/obj/item/bodypart/pulsating_part = get_bodypart(check_zone(user.zone_selected))
	if(!pulsating_part)
		to_chat(user, span_warning("I cannot measure [self ? "my" : p_their()] pulse without \a [parse_zone(user.zone_selected)]."))
		return
	if(DOING_INTERACTION_WITH_TARGET(user, src))
		to_chat(user, span_warning("I'm unable to check [self ? "my" : "<b>[src]</b>'s"] pulse.</"))
		return

	add_fingerprint(user)
	if(!self)
		user.visible_message(span_notice("<b>[user]</b> puts \his hand on <b>[src]</b>'s wrist and begins counting their pulse."),\
		span_notice("I begin counting <b>[src]</b>'s pulse..."))
	else
		user.visible_message(span_notice("<b>[user]</b> begins counting their own pulse."),\
		span_notice("I begin counting my pulse..."))


	if(!do_after(user, 0.5 SECONDS, src))
		to_chat(user, span_warning("I failed to check [self ? "my" : "<b>[src]</b>'s"] pulse."))
		return

	if(pulse)
		to_chat(user, span_notice("[self ? "I have a" : "<b>[src]</b> has a"] pulse! Counting..."))
	else
		to_chat(user, span_danger("[self ? "I have no" : "<b>[src]</b> has no"] pulse!"))
		return

	if(do_after(user, 2.5 SECONDS, src))
		to_chat(user, span_notice("[self ? "My" : "<b>[src]</b>'s"] pulse is approximately <b>[src.get_pulse(GETPULSE_BASIC)] BPM</b>."))
	else
		to_chat(user, span_warning("I failed to check [self ? "my" : "<b>[src]</b>'s"] pulse."))


/// A pulse to be read by players
/mob/living/carbon/proc/get_pulse_as_number(raw_pulse = pulse)
	switch(raw_pulse)
		if(PULSE_NONE)
			return 0
		if(PULSE_SLOW)
			return rand(40, 60)
		if(PULSE_NORM)
			return rand(60, 90)
		if(PULSE_FAST)
			return rand(90, 120)
		if(PULSE_FASTER)
			return rand(120, 160)
		if(PULSE_THREADY)
			return PULSE_MAX_BPM
	CRASH("For some reason, on a get_pulse_as_number() call, someone's pulse is not a valid integer!")

/// Generates realistic-ish pulse output based on preset levels as text
/mob/living/carbon/proc/get_pulse(method)	//method 0 is for hands, 1 is for machines, more accurate
	if(method == GETPULSE_PERFECT)
		return pulse

	var/list/hearts = getorganslotlist(ORGAN_SLOT_HEART)
	if(!length(hearts))
		// No heart, no pulse
		return "0"

	var/bypassed_heart = FALSE
	for(var/thing in hearts)
		var/obj/item/organ/heart/heart = thing
		if(heart.open)
			bypassed_heart = TRUE

	if(bypassed_heart && (method <= GETPULSE_BASIC))
		// Heart is a open type (?) and cannot be checked unless it's a machine
		return "muddled and unclear"

	var/bpm = get_pulse_as_number()
	if(bpm >= PULSE_MAX_BPM)
		if(method == GETPULSE_ADVANCED)
			return ">[PULSE_MAX_BPM]"
		else
			return "extremely weak and fast"

	if(method == GETPULSE_ADVANCED)
		return "[bpm]"
	else
		return "[bpm > 0 ? max(0, bpm + rand(-10, 10)) : 0]"
