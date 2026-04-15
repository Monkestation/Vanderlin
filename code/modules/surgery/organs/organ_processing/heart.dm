/datum/organ_process/heart
	slot = ORGAN_SLOT_HEART
	mob_types = list(/mob/living/carbon/human)
	var/static/sound/slowbeat = sound('sound/heart/slowbeat.ogg', volume = 20, channel = CHANNEL_HEARTBEAT, repeat = TRUE)
	var/static/sound/fastbeat = sound('sound/heart/fastbeat.ogg', volume = 10, channel = CHANNEL_HEARTBEAT, repeat = TRUE)

/datum/organ_process/heart/handle_process(mob/living/carbon/owner, delta_time, times_fired)
	if(owner.needs_heart())
		handle_pulse(owner, delta_time, times_fired)
		handle_heart_failure(owner, delta_time, times_fired)
		if(owner.pulse)
			handle_heartbeat(owner, delta_time, times_fired)
	handle_blood(owner, delta_time, times_fired)
	return TRUE

/// Handles the failure messaging and cardiac arrest flagging for a failing heart.
/// Separated from handle_pulse so the logic is readable and the failed flag is managed cleanly.
/datum/organ_process/heart/proc/handle_heart_failure(mob/living/carbon/owner, delta_time, times_fired)
	for(var/thing in owner.getorganslotlist(ORGAN_SLOT_HEART))
		var/obj/item/organ/heart/heart = thing
		if(!istype(heart))
			continue
		if(heart.is_failing() && owner.needs_heart())
			if(!heart.failed)
				if(owner.stat == CONSCIOUS)
					owner.visible_message(span_danger("<b>[owner]</b> clutches at [owner.p_their()] [parse_zone(BODY_ZONE_CHEST)]!"))
				playsound(owner, heart.convulsion_sound, 95, FALSE)
				heart.failed = TRUE
		else
			// Reset the flag once the heart recovers so the message can fire again next time
			heart.failed = FALSE

/datum/organ_process/heart/proc/handle_pulse(mob/living/carbon/owner, delta_time, times_fired)
	// Pulse mod starts out as just the chemical effect amount
	var/heart_efficiency = owner.getorganslotefficiency(ORGAN_SLOT_HEART)
	var/is_stable = owner.get_chem_effect(CE_STABLE) || HAS_TRAIT(owner, TRAIT_STABLEHEART)
	var/pulse_mod = (is_stable ? 0 : owner.get_chem_effect(CE_PULSE))

	// If you have enough heart chemicals to be over 2, you're likely to take extra damage.
	if(pulse_mod > 2 && !is_stable)
		var/damage_chance = (pulse_mod - 2) ** 2
		if(DT_PROB(damage_chance / 2, delta_time))
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 1)

	// Now pulse mod is impacted by shock stage and other things too
	var/oxygenation = GET_EFFECTIVE_BLOOD_VOL(owner.get_blood_oxygenation(), owner.total_blood_req)
	/*
	if(!is_stable)
		if(owner.shock_stage >= SHOCK_STAGE_2)
			pulse_mod++
		if(owner.shock_stage >= SHOCK_STAGE_5)
			pulse_mod++
	*/

	if(oxygenation < BLOOD_VOLUME_OKAY) //Brain wants us to get MOAR OXY
		pulse_mod++
	if(oxygenation < BLOOD_VOLUME_BAD) //MOAR
		pulse_mod++

	if(HAS_TRAIT(owner, TRAIT_FAKEDEATH) || owner.get_chem_effect(CE_NOPULSE))
		owner.pulse = clamp(PULSE_NONE + pulse_mod, PULSE_NONE, PULSE_FASTER) //Pretend that we're dead. unlike actual death, can be influenced by meds
		return

	// If our heart is stopped, it isn't going to restart itself randomly.
	if(heart_efficiency < failing_threshold)
		owner.set_heartattack(TRUE)
		ADD_TRAIT(owner, TRAIT_DEATHS_DOOR, ASYSTOLE_TRAIT)
		return
	if(owner.pulse <= PULSE_NONE)
		ADD_TRAIT(owner, TRAIT_DEATHS_DOOR, ASYSTOLE_TRAIT)
		return

	// Pulse normally shouldn't go above PULSE_FASTER unless you get extremely doped up
	if(pulse_mod < 5)
		owner.pulse = clamp(PULSE_NORM + pulse_mod, PULSE_SLOW, PULSE_FASTER)
	else
		owner.pulse = clamp(PULSE_NORM + pulse_mod, PULSE_SLOW, PULSE_THREADY)

	// If in fibrillation, then it can be PULSE_THREADY
	var/fibrillation = ((oxygenation <= BLOOD_VOLUME_SURVIVE))
	if(owner.pulse && fibrillation)
		owner.pulse = PULSE_THREADY

	// Stabilising chemicals pull the heartbeat towards the center
	if(owner.pulse != PULSE_NORM && is_stable)
		if(owner.pulse > PULSE_NORM)
			owner.pulse--
		else
			owner.pulse++

	// Thready pulse can damage us
	if(owner.pulse >= PULSE_THREADY)
		if(DT_PROB(2.5, delta_time))
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 1)
	else if(owner.pulse >= PULSE_FASTER)
		if(DT_PROB(0.5, delta_time))
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 1)

	// Finally, check if we should go into cardiac arrest
	// cardiovascular shock, not enough liquid to pump
	var/should_stop = (owner.get_blood_circulation() < GET_EFFECTIVE_BLOOD_VOL(BLOOD_VOLUME_SURVIVE, owner.total_blood_req)) && DT_PROB(40, delta_time)
	// brain failing to work heart properly
	should_stop = should_stop || DT_PROB(CEILING(max(0, GETBRAINLOSS(owner) - (owner.maxHealth * 0.5)) / 2, 1), delta_time)
	// erratic heart patterns, usually caused by oxyloss
	should_stop = should_stop || ((owner.pulse >= PULSE_THREADY) && DT_PROB(6, delta_time))

	// One heart has stopped due to going into traumatic or cardiovascular shock
	if(should_stop)
		// We don't use set_heartattack here to avoid stopping all hearts instead of just one
		var/list/hearts = owner.getorganslotlist(ORGAN_SLOT_HEART)
		for(var/heartache in shuffle(hearts))
			var/obj/item/organ/heart/heart = heartache
			if(heart.can_stop())
				heart.Stop()
				break

	// No pulse means we are already having a cardiac arrest moment
	if(owner.pulse <= PULSE_NONE)
		owner.set_heartattack(TRUE)
		ADD_TRAIT(owner, TRAIT_DEATHS_DOOR, ASYSTOLE_TRAIT)
	// High pulse can cause heart damage
	else
		if((owner.pulse == PULSE_FASTER) && DT_PROB(0.5, delta_time))
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 1)
		else if((owner.pulse >= PULSE_THREADY) && DT_PROB(2.5, delta_time))
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 1)
		REMOVE_TRAIT(owner, TRAIT_DEATHS_DOOR, ASYSTOLE_TRAIT)

/datum/organ_process/heart/proc/handle_blood(mob/living/carbon/owner, delta_time, times_fired)
	// Dead or pulseless people do not pump blood
	if(!owner.pulse)
		return

	var/effective_blood_circulation = GET_EFFECTIVE_BLOOD_VOL(owner.get_blood_circulation(), owner.total_blood_req)
	switch(effective_blood_circulation)
		if(BLOOD_VOLUME_MAXIMUM to BLOOD_VOLUME_EXCESS)
			owner.status_flags &= ~BLEEDOUT
			if(DT_PROB(2.5, delta_time))
				to_chat(owner, span_userdanger("Blood starts to tear my arteries apart!"))
				var/obj/item/bodypart/artery_popper = pick(owner.bodyparts)
				if(!artery_popper.is_artery_torn())
					artery_popper.add_wound(/datum/wound/artery)
		if(-INFINITY to BLOOD_VOLUME_BLEEDOUT)
			if(!(owner.status_flags & BLEEDOUT))
				owner.status_flags |= BLEEDOUT
				to_chat(owner, span_userdanger("My organs feel outrageously heavy!"))
			else if(DT_PROB(2.5, delta_time))
				to_chat(owner, span_userdanger("Not... Enough... Blood..."))
		else
			owner.status_flags &= ~BLEEDOUT
	if((owner.status_flags & BLEEDOUT) && DT_PROB(5, delta_time))
		owner.adjust_eye_blur_up_to(4, 4)

	if((effective_blood_circulation <= BLOOD_VOLUME_BLEEDOUT_PASSOUT) && DT_PROB(10, delta_time))
		owner.Unconscious(4 SECONDS)

	var/temp_bleed = 0
	var/bleed_mod = 1
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		if(human_owner.physiology)
			bleed_mod *= human_owner.physiology.bleed_mod
	for(var/obj/item/bodypart/bleed_part as anything in owner.bodyparts)
		var/resulting_bleed = bleed_part.get_bleed_rate(TRUE) * 0.5 * delta_time
		switch(owner.pulse)
			if(PULSE_SLOW)
				resulting_bleed *= 0.8
			if(PULSE_FAST)
				resulting_bleed *= 1.25
			if(PULSE_FASTER, PULSE_THREADY)
				resulting_bleed *= 1.5
		resulting_bleed = CEILING(resulting_bleed * bleed_mod, 0.1)
		if(resulting_bleed <= 0)
			continue
		if(bleed_part.bandage)
			bleed_part.try_bandage_expire()
		else
			temp_bleed += resulting_bleed
	if(temp_bleed)
		if(owner.bleed(temp_bleed) && (temp_bleed >= 1.5))
			var/bleed_sound = "sound/gore/blood[rand(1, 6)].ogg"
			if((temp_bleed > 1) && (owner.body_position == STANDING_UP))
				playsound(owner, bleed_sound, 60, FALSE)

	if(!HAS_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE) && owner.stat != DEAD)
		switch(owner.blood_volume)
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				owner.remove_status_effect(/datum/status_effect/debuff/bleedingworse)
				owner.remove_status_effect(/datum/status_effect/debuff/bleedingworst)
				owner.apply_status_effect(/datum/status_effect/debuff/bleeding)
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				owner.remove_status_effect(/datum/status_effect/debuff/bleeding)
				owner.remove_status_effect(/datum/status_effect/debuff/bleedingworst)
				owner.apply_status_effect(/datum/status_effect/debuff/bleedingworse)
			if(0 to BLOOD_VOLUME_BAD)
				owner.remove_status_effect(/datum/status_effect/debuff/bleedingworse)
				owner.remove_status_effect(/datum/status_effect/debuff/bleeding)
				owner.apply_status_effect(/datum/status_effect/debuff/bleedingworst)
	else
		owner.remove_status_effect(/datum/status_effect/debuff/bleeding)
		owner.remove_status_effect(/datum/status_effect/debuff/bleedingworse)
		owner.remove_status_effect(/datum/status_effect/debuff/bleedingworst)

	var/bleed_rate = owner.get_bleed_rate()
	if(bleed_rate)
		owner.add_stress(/datum/stress_event/bleeding)
	else
		owner.remove_stress(/datum/stress_event/bleeding)

/datum/organ_process/heart/proc/handle_heartbeat(mob/living/carbon/owner, delta_time, times_fired)
	var/cardiac_arrest = owner.undergoing_nervous_system_failure()
	var/nervous_failure = owner.undergoing_nervous_system_failure()
	if((owner.heartbeat_sound != BEAT_SLOW) && (cardiac_arrest || nervous_failure))
		owner.heartbeat_sound = BEAT_SLOW
		SEND_SOUND(owner, slowbeat)
		if(cardiac_arrest || nervous_failure)
			to_chat(owner, span_notice("I feel the grim reaper's cold gaze..."))
		return
	if((owner.heartbeat_sound == BEAT_SLOW) && !cardiac_arrest && !nervous_failure)
		owner.stop_sound_channel(CHANNEL_HEARTBEAT)
		owner.heartbeat_sound = BEAT_NONE
		return
	if((owner.heartbeat_sound != BEAT_FAST) && (owner.has_status_effect(/datum/status_effect/jitter)) && !cardiac_arrest && !nervous_failure)
		SEND_SOUND(owner, fastbeat)
		owner.heartbeat_sound = BEAT_FAST
		return
	if((owner.heartbeat_sound == BEAT_FAST) && (owner.has_status_effect(/datum/status_effect/jitter)))
		owner.stop_sound_channel(CHANNEL_HEARTBEAT)
		owner.heartbeat_sound = BEAT_NONE
		return
