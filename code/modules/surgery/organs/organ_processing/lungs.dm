/datum/organ_process/lungs
	slot = ORGAN_SLOT_LUNGS

/datum/organ_process/lungs/needs_process(mob/living/carbon/owner)
	if(!owner.needs_lungs())
		if(owner.getOxyLoss())
			owner.setOxyLoss(0)
		owner.losebreath = 0
		owner.failed_last_breath = FALSE
		return FALSE
	return ..()

/datum/organ_process/lungs/handle_process(mob/living/carbon/owner, delta_time, times_fired)
	handle_breathing(owner, delta_time, times_fired)
	var/obj/item/organ/lungs/lungs = owner.getorganslot(ORGAN_SLOT_LUNGS)
	lungs?.cough_blood(delta_time)
	return TRUE

/datum/organ_process/lungs/proc/handle_breathing(mob/living/carbon/owner, delta_time, times_fired)
	var/next_breath = 4
	var/obj/item/organ/lungs/lungs = owner.getorganslot(ORGAN_SLOT_LUNGS)
	var/obj/item/organ/heart/heart = owner.getorganslot(ORGAN_SLOT_HEART)
	if(lungs && lungs.get_slot_efficiency(ORGAN_SLOT_LUNGS) <= failing_threshold)
		next_breath--
	if(heart && heart.get_slot_efficiency(ORGAN_SLOT_HEART) <= failing_threshold)
		next_breath--

	var/owner_failed_breath = owner.failed_last_breath
	if((times_fired % next_breath) == 0 || owner_failed_breath)
		// Breathe per 4 ticks if healthy, down to 2 if our lungs or heart are damaged, unless suffocating
		breathe(owner, delta_time, times_fired, owner_failed_breath ? 1 : next_breath)
	else if(isobj(owner.loc))
		var/obj/location_as_object = owner.loc
		location_as_object.handle_internal_lifeform(owner, 0)

/*
	var/lung_efficiency = owner.getorganslotefficiency(ORGAN_SLOT_LUNGS)
	var/effective_oxygenation = ((100 - owner.getOxyLoss()) * (lung_efficiency/optimal_threshold))

	if(effective_oxygenation < owner.total_oxygen_req)
		if(DT_PROB(0.5, delta_time))
			if(owner.body_position != LYING_DOWN)
				owner.visible_message(span_danger("<b>[owner]</b> falls to the ground and hyperventilates!"), \
								span_userdanger("I need more air!"))
			else
				owner.visible_message(span_danger("<b>[owner]</b> hyperventilates!"), \
					span_userdanger("I need more air!"))
			owner.Knockdown(8 SECONDS)
			INVOKE_ASYNC(src, PROC_REF(gasp_spam), owner)
		if(DT_PROB(2, delta_time))
			owner.adjust_eye_blur_up_to(5, 5)
			owner.adjust_confusion(16)
		if(DT_PROB(2, delta_time))
			owner.emote("gasp")
			owner.losebreath = max(owner.losebreath, rand(8, 16))
		if(DT_PROB(4, delta_time))
			owner.emote("cough")
	if(effective_oxygenation < (owner.total_oxygen_req/5))
		if(DT_PROB(20, delta_time))
			ADJUSTBRAINLOSS(owner, BRAIN_DAMAGE_LOWEST_OXYGENATION)
		if(effective_oxygenation < (owner.total_oxygen_req/10))
			ADJUSTBRAINLOSS(owner, BRAIN_DAMAGE_LOWEST_OXYGENATION)

/datum/organ_process/lungs/proc/gasp_spam(mob/living/carbon/victim)
	for(var/i in 1 to 3)
		if(QDELETED(victim))
			return
		if(prob(80))
			victim.emote("gasp")
		else
			victim.emote("choke")
		sleep(1 SECONDS)
*/

/datum/organ_process/lungs/proc/breathe(mob/living/carbon/owner, delta_time, times_fired, next_breath = 4)
	var/obj/item/organ/lungs/lungs = owner.getorganslot(ORGAN_SLOT_LUNGS)
	if((owner.pulledby?.grab_state >= GRAB_KILL) || (lungs?.is_failing()))
		owner.losebreath++  //You can't breath at all when being choked or if your lungs are failing, so you're going to miss a breath

	var/pre_sig_return = SEND_SIGNAL(owner, COMSIG_CARBON_ATTEMPT_BREATHE, delta_time, times_fired)
	if(pre_sig_return & COMSIG_CARBON_BLOCK_BREATH)
		return
	if(pre_sig_return & BREATHE_SKIP_BREATH)
		owner.losebreath = max(owner.losebreath, 1)

	SEND_SIGNAL(owner, COMSIG_CARBON_PRE_BREATHE, delta_time)

	var/breath

	// Suffocate
	var/skip_breath = FALSE
	if(owner.losebreath >= 1)
		owner.losebreath -= 1
		skip_breath = TRUE
		if(isobj(owner.loc))
			var/obj/location_as_object = owner.loc
			location_as_object.handle_internal_lifeform(owner, 0, delta_time)
	else
		breath = TRUE
		if(isobj(owner.loc))
			var/obj/loc_as_obj = owner.loc
			loc_as_obj.handle_internal_lifeform(owner, 1.99, delta_time)

	owner.check_breath(breath, skip_breath, delta_time)

/**
 * This proc tests if the lungs can breathe, if the mob can breathe a given gas mixture, and throws/clears gas alerts.
 * If there are moles of gas in the given gas mixture, side-effects may be applied/removed on the mob.
 * This proc expects a lungs organ in order to breathe successfully, but does not defer any work to it.
 *
 * Returns TRUE if the breath was successful, or FALSE if otherwise.
 *
 * Arguments:
 * * breath: A gas mixture to test (TRUE), or null.
 * * skip_breath: Used to differentiate between a failed breath and a lack of breath.
 * A mob suffocating due to being in a vacuum may be treated differently than a mob suffocating due to lung failure.
 */
/mob/living/carbon/proc/check_breath(breath, skip_breath = FALSE, delta_time)
	if(status_flags & GODMODE)
		failed_last_breath = FALSE
		return FALSE

	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return FALSE
	return TRUE

/mob/living/carbon/human/check_breath(breath, skip_breath = FALSE, delta_time)
	. = ..()
	if(!.)
		return

	var/obj/item/organ/lungs/human_lungs = getorganslot(ORGAN_SLOT_LUNGS)
	if(human_lungs)
		return human_lungs.check_breath(breath, src, skip_breath, delta_time)

	// Lungs are missing! Can't breathe.
	// Extra damage, let God sort ’em out!
	adjustOxyLoss((total_oxygen_req / 10) * delta_time)
	failed_last_breath = TRUE
	return FALSE

/obj/item/organ/lungs/proc/check_breath(breath, mob/living/carbon/human/breather, skip_breath, delta_time)
	. = TRUE
	if(breather.status_flags & GODMODE)
		breather.failed_last_breath = FALSE
		return FALSE

	if(HAS_TRAIT(breather, TRAIT_NOBREATH))
		return FALSE

	// If the breath is null, it's actually a failed breath
	var/no_breath = isnull(breath) || skip_breath
	if(no_breath)
		breath = null

	if(breath)
		breather.failed_last_breath = FALSE
		handle_breath_temperature(breath, breather)
	else
		// Can't breathe!
		. = FALSE // Returning FALSE indicates the breath failed.
		breather.failed_last_breath = TRUE

	breathe_air(breather, breath, delta_time)
	breathe_pollution(breather, breath, delta_time)

/obj/item/organ/lungs/proc/breathe_air(mob/living/carbon/breather, breath, delta_time)
	if(!breath)
		return handle_suffocation(breather, delta_time)

	if(breather.getOxyLoss())
		var/lung_efficiency = get_slot_efficiency(ORGAN_SLOT_LUNGS)/ORGAN_OPTIMAL_EFFICIENCY
		// Less blood so breaths give you less oxygen
		var/blood_modifier = 1
		if(CAN_HAVE_BLOOD(breather))
			blood_modifier = breather.get_blood_volume() / BLOOD_VOLUME_NORMAL

		var/oxygen_req_modifier = clamp(30/max(breather.total_oxygen_req, 1), 0.5, 1.5)
		breather.adjustOxyLoss(-5 * blood_modifier * lung_efficiency * oxygen_req_modifier * delta_time)

/obj/item/organ/lungs/proc/breathe_pollution(mob/living/carbon/breather, breath, delta_time)
	if(!breath)
		return

	var/turf/open/breather_loc = breather.loc
	if(!istype(breather_loc))
		return
	if(!breather_loc.pollution)
		return

	breather_loc.pollution.breathe_act(breather)
	if(HAS_TRAIT(breather, TRAIT_DEADNOSE))
		return
	if(breather.next_smell <= world.time)
		breather.next_smell = world.time + 30 SECONDS
		breather_loc.pollution.smell_act(breather)

/obj/item/organ/lungs/proc/handle_suffocation(mob/living/carbon/human/suffocator = null, delta_time)
	// Can't suffocate without a Human, or without minimum breath pressure.
	if(!suffocator)
		return
	// Mob is suffocating.
	suffocator.failed_last_breath = TRUE
	// Give them a chance to notice something is wrong.
	if(DT_PROB(5, delta_time))
		suffocator.emote("gasp")
	suffocator.adjustOxyLoss((suffocator.total_oxygen_req / 10) * delta_time, FALSE)
	return ORGAN_PROCESS_UPDATE_HEALTH

/obj/item/organ/lungs/proc/handle_breath_temperature(breath, mob/living/carbon/human/breather)
	var/breath_effect_prob = 0
	var/turf/turf = get_turf(breather)
	var/turf_temp = turf ? turf.return_temperature() : BODYTEMP_NORMAL

	// Breath visibility based on ambient temperature
	// Only visible when it's actually cold enough for condensation
	if(turf_temp <= -10)
		breath_effect_prob = 100    // Always visible in extreme cold
	else if(turf_temp <= -5)
		breath_effect_prob = 90     // Very likely in freezing temps
	else if(turf_temp <= 0)
		breath_effect_prob = 40     // Common at freezing point
	else if(turf_temp <= 5)
		breath_effect_prob = 15     // Sometimes visible in cold

	// Body temperature effects
	if(breather.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT)
		var/cold_severity = (BODYTEMP_COLD_DAMAGE_LIMIT - breather.bodytemperature)
		breath_effect_prob += min(cold_severity * 15, 40)

	// Environmental modifiers
	var/turf/snow_turf = get_turf(breather)
	if(snow_turf?.snow)
		breath_effect_prob = min(breath_effect_prob + 30, 100)

	// Heavy breathing from exertion or cold body
	if(breather.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT - 3)
		breath_effect_prob = min(breath_effect_prob + 50, 100)
		if(prob(15) && !breather.is_mouth_covered())
			to_chat(breather, span_warning("My breath comes out in heavy puffs of vapor."))

	if(prob(breath_effect_prob) && !breather.is_mouth_covered())
		emit_breath_particle(/particles/fog/breath)

/obj/item/organ/lungs/proc/emit_breath_particle(mob/living/carbon/human/breather, particle_type)
	ASSERT(ispath(particle_type, /particles))

	var/obj/effect/abstract/particle_holder/holder = new(breather, particle_type)
	var/particles/breath_particle = holder.particles
	var/breath_dir = breather.dir

	var/list/particle_grav = list(0, 0.1, 0)
	var/list/particle_pos = list(0, 6, 0)
	if(breath_dir & NORTH)
		particle_grav[2] = 0.2
		breath_particle.rotation = pick(-45, 45)
		// Layer it behind the mob since we're facing away from the camera
		holder.pixel_w -= 4
		holder.pixel_y += 4
	if(breath_dir & WEST)
		particle_grav[1] = -0.2
		particle_pos[1] = -5
		breath_particle.rotation = -45
	if(breath_dir & EAST)
		particle_grav[1] = 0.2
		particle_pos[1] = 5
		breath_particle.rotation = 45
	if(breath_dir & SOUTH)
		particle_grav[2] = 0.2
		breath_particle.rotation = pick(-45, 45)
		// Shouldn't be necessary but just for parity
		holder.pixel_w += 4
		holder.pixel_y -= 4

	breath_particle.gravity = particle_grav
	breath_particle.position = particle_pos

	QDEL_IN(holder, breath_particle.lifespan)

/obj/proc/handle_internal_lifeform(mob/living/lifeform_inside_me, breath_request, delta_time)
	return

/obj/structure/closet/dirthole/handle_internal_lifeform(mob/living/lifeform_inside_me, breath_request, delta_time)
	var/suffocation_damage = 5 * (breath_request ? 2 : 1)
	return lifeform_inside_me.adjustOxyLoss(suffocation_damage * delta_time)

/obj/structure/closet/burial_shroud/handle_internal_lifeform(mob/living/lifeform_inside_me, breath_request, delta_time)
	if(recursive_loc_check(lifeform_inside_me, /obj/structure/closet/dirthole))
		var/suffocation_damage = 5 * (breath_request ? 2 : 1)
		return lifeform_inside_me.adjustOxyLoss(suffocation_damage * delta_time)
