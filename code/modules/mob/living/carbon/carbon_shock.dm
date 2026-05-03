
/mob/living/carbon/update_shock()
	. = ..()
	if(!client || !hud_used)
		return
	//Pain fucks up our vision
	switch(traumatic_shock)
		if(-INFINITY to SHOCK_STAGE_2)
			hud_used.update_chromatic_aberration(intensity = 0)
		if(SHOCK_STAGE_2 to SHOCK_STAGE_4)
			hud_used.update_chromatic_aberration(intensity = 1, red_x = 0, red_y = 0, blue_x = 0, blue_y = 0)
		if(SHOCK_STAGE_4 to SHOCK_STAGE_6)
			hud_used.update_chromatic_aberration(intensity = 1, red_x = 1, red_y = 0, blue_x = 0, blue_y = 0)
		if(SHOCK_STAGE_6 to INFINITY)
			hud_used.update_chromatic_aberration(intensity = 1	, red_x = 1, red_y = 1, blue_x = 0, blue_y = 0)

/mob/living/carbon/proc/update_shock_penalty(incoming = 0, duration = SHOCK_PENALTY_COOLDOWN_DURATION)
	//use remove_shock_penalty() you idiot
	if(!incoming || !duration)
		return
	if(shock_penalty_timer)
		deltimer(shock_penalty_timer)
		shock_penalty_timer = null
	//pick the bigger value between what we already are suffering and the incoming modification
	shock_penalty = max(incoming, shock_penalty)
	attributes?.add_or_update_variable_attribute_modifier(/datum/attribute_modifier/shock_penalty, TRUE, list(STAT_PERCEPTION = -shock_penalty, STAT_INTELLIGENCE = -shock_penalty, STAT_SPEED = -shock_penalty))
	shock_penalty_timer = addtimer(CALLBACK(src, PROC_REF(remove_shock_penalty)), duration, TIMER_STOPPABLE)

/mob/living/carbon/proc/remove_shock_penalty()
	attributes?.remove_attribute_modifier(/datum/attribute_modifier/shock_penalty)
	shock_penalty = 0
	shock_penalty_timer = null

/mob/living/carbon/proc/handle_shock(delta_time, times_fired)
	if(!can_feel_pain())
		return
	if(stat >= UNCONSCIOUS)
		return

	var/our_endurance = GET_MOB_ATTRIBUTE_VALUE(src, STAT_ENDURANCE)

	/*
	if(traumatic_shock >= (PAIN_GIVES_IN * (our_endurance/ATTRIBUTE_MIDDLING)))
		if(buckled || (body_position == LYING_DOWN))
			Knockdown(4 SECONDS)
		else
			visible_message(PAIN_KNOCKDOWN_MESSAGE, \
						PAIN_KNOCKDOWN_MESSAGE_SELF)
			//Blood on screen
			//flash_pain(100)
			emote("scream")
			//Immobilize for a second
			Immobilize(1 SECONDS)
			//After immobilize runs out, fall down
			addtimer(CALLBACK(src, PROC_REF(Knockdown), 4 SECONDS), 1 SECONDS)
	*/

	var/maxbpshock = 0
	var/obj/item/bodypart/damaged_bodypart
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		var/bpshock = bodypart.get_shock(FALSE, TRUE)
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if((bpshock >= maxbpshock) && ((maxbpshock <= 0) || prob(70)) )
			damaged_bodypart = bodypart
			maxbpshock = bpshock

	if(damaged_bodypart && (get_chem_effect(CE_PAINKILLER) < maxbpshock))
		var/burning = (damaged_bodypart.burn_dam >= damaged_bodypart.brute_dam)
		var/message
		switch(CEILING(maxbpshock, 1))
			if(1 to 10)
				message = "My [damaged_bodypart.name] [burning ? "burns" : "hurts"]."
			if(11 to 90)
				message = "My [damaged_bodypart.name] [burning ? "burns" : "hurts"] badly!"
			if(91 to INFINITY)
				message = "[pick("WHAT A PAIN!", "OH GOD!", "OH LORD!")]! My [damaged_bodypart.name] [damaged_bodypart.p_are()] [burning ? "on fire" : "hurting terribly"]!"
		custom_pain(message, maxbpshock, TRUE, damaged_bodypart, TRUE)

	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/organ as anything in internal_organs)
		if(DT_PROB(1, delta_time) && organ.can_feel_pain() && (organ.get_shock() >= 5))
			var/obj/item/bodypart/parent = get_bodypart(organ.current_zone)
			if(parent)
				var/pain = 10
				var/message = "I feel a dull pain in my [parent.name]."
				if(organ.is_failing())
					pain = 40
					message = "I feel a sharp pain in my [parent.name]!"
				else if(organ.damage >= organ.low_threshold)
					pain = 25
					message = "I feel a pain in my [parent.name]."
				else
					pain = 10
					message = "I feel a dull pain in my [parent.name]."
				custom_pain(message, pain, FALSE, parent, pain_emote = FALSE)

	if(traumatic_shock >= PAIN_SHOCK_PENALTY)
		var/penalty = min(SHOCK_PENALTY_CAP, FLOOR(traumatic_shock/(our_endurance*3), 1))
		if(penalty)
			var/probability = CEILING(min(60, traumatic_shock/(2 * (our_endurance/ATTRIBUTE_MIDDLING))), 1)
			if(DT_PROB(probability/2, delta_time))
				update_shock_penalty(penalty)

	var/general_damage_message = null
	var/general_message_prob = 1
	var/general_damage = getToxLoss() + getCloneLoss()
	switch(CEILING(general_damage, 1))
		if(1 to 5)
			general_message_prob = 0.5
			general_damage_message = "My body stings slightly."
		if(5 to 10)
			general_message_prob = 1
			general_damage_message = "My body hurts a little."
		if(10 to 20)
			general_message_prob = 1
			general_damage_message = "My whole body hurts."
		if(20 to 30)
			general_message_prob = 2
			general_damage_message = "My whole body hurts badly."
		if(30 to INFINITY)
			general_message_prob = 3
			general_damage_message = "My whole body aches, it's driving me mad!"

	if(general_damage_message && DT_PROB(general_message_prob, delta_time))
		custom_pain(general_damage_message, general_damage)

/mob/living/carbon/proc/handle_shock_stage(delta_time, times_fired)
	if(!can_feel_pain())
		setShockStage(0)
		remove_movespeed_modifier(MOVESPEED_ID_SHOCK, FALSE)
		remove_movespeed_modifier(MOVESPEED_ID_CARDIAC_ARREST, TRUE)
		hud_used?.update_chromatic_aberration(intensity = 0)
		return

	var/previous_shock_stage = shock_stage
	var/our_endurance = max(1, GET_MOB_ATTRIBUTE_VALUE(src, STAT_ENDURANCE))

	//Cardiac arrest automatically throws us into sofcrit territory
	if(undergoing_cardiac_arrest())
		setShockStage(max(shock_stage, SHOCK_STAGE_4))
		add_movespeed_modifier(MOVESPEED_ID_CARDIAC_ARREST, TRUE, multiplicative_slowdown = 5)
	else
		remove_movespeed_modifier(MOVESPEED_ID_CARDIAC_ARREST, TRUE)

	if(traumatic_shock >= max(SHOCK_STAGE_2, 0.8 * shock_stage))
		adjustShockStage(0.5 * delta_time * (ATTRIBUTE_MIDDLING/our_endurance))
	else if(!undergoing_cardiac_arrest())
		setShockStage(min(shock_stage, SHOCK_STAGE_7))
		var/recovery = 0.5 * delta_time
		//Lower shock faster the less pain we feel
		if(traumatic_shock < 0.5 * shock_stage)
			recovery += 0.5 * delta_time
		if(traumatic_shock < 0.25 * shock_stage)
			recovery += 0.5 * delta_time
		adjustShockStage(-recovery * (our_endurance/ATTRIBUTE_MIDDLING))

	//Shock makes us slow
	if(shock_stage >= (SHOCK_STAGE_2 * (our_endurance/ATTRIBUTE_MIDDLING)))
		add_movespeed_modifier(MOVESPEED_ID_SHOCK, TRUE, multiplicative_slowdown = 0.25)
	else
		remove_movespeed_modifier(MOVESPEED_ID_SHOCK, TRUE)

	if((stat >= UNCONSCIOUS) || (shock_stage <= 0))
		return

	if((shock_stage >= SHOCK_STAGE_1) && (previous_shock_stage < SHOCK_STAGE_1))
		/** Please be very careful when calling custom_pain() from within code that relies on pain/trauma values. There's the
		 * possibility of a feedback loop from custom_pain() being called with a positive power, incrementing pain on a limb,
		 * which triggers this proc, which calls custom_pain(), etc. Make sure you call it with nopainloss = TRUE in these cases!
		 */
		custom_pain("[pick("It hurts so much", "I really need some opium", "Ooh, the pain")]!", 10, nopainloss = TRUE)

	if((shock_stage >= SHOCK_STAGE_2) && (previous_shock_stage < SHOCK_STAGE_2))
		emote("is having trouble keeping [p_their()] eyes open.")
		//Attempt to inject combat cocktail for the first time
		endorphinate()

	if((shock_stage >= SHOCK_STAGE_2) && (previous_shock_stage >= SHOCK_STAGE_2))
		if(DT_PROB(3, delta_time))
			//adjust_eye_blur(rand(1, 2))
			stuttering = max(stuttering, 5)

	if((shock_stage >= SHOCK_STAGE_3) && (previous_shock_stage < SHOCK_STAGE_3))
		custom_pain("[pick("The pain is excruciating", "Please, just end the pain", "My whole body is going numb")]!", 40, nopainloss = TRUE)

	if((shock_stage >= SHOCK_STAGE_4) && (previous_shock_stage < SHOCK_STAGE_4))
		emote("becomes limp.")
		if(!HAS_TRAIT(src, TRAIT_NOPAINSTUN))
			Immobilize(rand(2, 3) SECONDS)
		//Attempt to inject combat cocktail a second time
		endorphinate()

	if((shock_stage >= SHOCK_STAGE_4) && (previous_shock_stage >= SHOCK_STAGE_4))
		if(DT_PROB(1, delta_time))
			custom_pain("[pick("The pain is excruciating", "Please, just end the pain", "My whole body is going numb")]!", shock_stage, nopainloss = TRUE)
			if(!HAS_TRAIT(src, TRAIT_NOPAINSTUN))
				Knockdown(2 SECONDS)
		if(DT_PROB(2, delta_time))
			emote("gasp")

	if((shock_stage >= SHOCK_STAGE_5) && (previous_shock_stage >= SHOCK_STAGE_5))
		if(DT_PROB(2.5, delta_time))
			custom_pain("[pick("The pain is excruciating", "Please, just end the pain", "My whole body is going numb")]!", shock_stage, nopainloss = TRUE)
			if(!HAS_TRAIT(src, TRAIT_NOPAINSTUN))
				Paralyze(5 SECONDS)

	if((shock_stage >= SHOCK_STAGE_6) && (previous_shock_stage >= SHOCK_STAGE_6))
		if(DT_PROB(1, delta_time))
			if(!IsUnconscious())
				custom_pain("[pick("I black out", "I feel like i could die at any moment now", "I'm about to lose consciousness")]!", shock_stage, nopainloss = TRUE)
			if(!HAS_TRAIT(src, TRAIT_NOPAINSTUN))
				Unconscious(1 SECONDS)

	if((shock_stage >= SHOCK_STAGE_7) && (previous_shock_stage < SHOCK_STAGE_7))
		if(body_position != LYING_DOWN)
			emote("can no longer stand, collapsing!")
		emote("gargle")
		if(!HAS_TRAIT(src, TRAIT_NOPAINSTUN))
			Paralyze(5 SECONDS)
		//Attempt to inject combat cocktail, even though at this point it won't help much
		endorphinate()

	if((shock_stage >= SHOCK_STAGE_7) && (previous_shock_stage >= SHOCK_STAGE_7))
		if(!HAS_TRAIT(src, TRAIT_NOPAINSTUN))
			Paralyze(5 SECONDS)
		if(DT_PROB(1, delta_time))
			Unconscious(5)
		if(DT_PROB(4, delta_time))
			emote("gargle")

	if((shock_stage >= SHOCK_STAGE_8) && (previous_shock_stage < SHOCK_STAGE_8))
		//Attempt to inject combat cocktail - ONE FINAL TIME
		endorphinate()
		//Death is near...
		emote("scream")
		if(!HAS_TRAIT(src, TRAIT_NOPAINSTUN))
			Unconscious(10 SECONDS)

	if((shock_stage >= SHOCK_STAGE_8) && (previous_shock_stage >= SHOCK_STAGE_8))
		//How the fuck are we still alive?
		if(!IsUnconscious())
			visible_message(PAIN_KNOCKOUT_MESSAGE)
			custom_pain(PAIN_KNOCKOUT_MESSAGE_SELF, 100, nopainloss = TRUE)
			//death_rattle()
		if(!HAS_TRAIT(src, TRAIT_NOPAINSTUN))
			Unconscious(15 SECONDS)
