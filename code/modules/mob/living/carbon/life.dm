/mob/living/carbon/Life(delta_time = SSMOBS_DT, times_fired)
	set invisibility = 0

	if(grab_fatigue > 0)
		if(!pulling)
			// Exponential decay mostly
			grab_fatigue -= max(grab_fatigue * 0.15, 0.5)
		else
			grab_fatigue -= 0.5
		grab_fatigue = max(0, grab_fatigue)

	if(HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

	if(damageoverlaytemp)
		damageoverlaytemp = 0
		update_damage_hud()

	if(HAS_TRAIT(src, TRAIT_STASIS))
		. = ..()
	else
		//Reagent processing needs to come before breathing, to prevent edge cases.
		handle_organs(delta_time, times_fired)
		handle_bodyparts(delta_time, times_fired)

		. = ..()

		if (QDELETED(src))
			return

		handle_wounds()
		handle_embedded_objects()
		handle_roguebreath()
		update_stress()
		handle_nausea()

		handle_shock(delta_time, times_fired)
		handle_shock_stage(delta_time, times_fired)

		if((blood_volume > BLOOD_VOLUME_SURVIVE) || HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
			if(!heart_attacking)
				if(oxyloss)
					adjustOxyLoss(-5)
			else
				if(getOxyLoss() < 20)
					heart_attacking = FALSE

		handle_sleep()

	check_cremation()

	if(stat != DEAD)
		return 1

/mob/living/carbon/DeadLife()
	set invisibility = 0

	if(HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

	. = ..()
	if (QDELETED(src))
		return
	handle_wounds()
	handle_embedded_objects()

	check_cremation()

/mob/living/carbon/handle_random_events() //BP/WOUND BASED PAIN
	return


/mob/living/carbon/proc/handle_roguebreath()
	return

/mob/living/carbon/human/handle_roguebreath()
	..()
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return TRUE
	if(istype(loc, /obj/structure/closet/dirthole))
		adjustOxyLoss(5)
	if(istype(loc, /obj/structure/closet/burial_shroud))
		var/obj/O = loc
		if(istype(O.loc, /obj/structure/closet/dirthole))
			adjustOxyLoss(5)
	if(isopenturf(loc))
		var/turf/open/T = loc
		if(reagents && T.pollution)
			T.pollution.breathe_act(src)
			if(HAS_TRAIT(src, TRAIT_DEADNOSE))
				return
			if(next_smell <= world.time)
				next_smell = world.time + 30 SECONDS
				T.pollution.smell_act(src)

///////////////
// BREATHING //
///////////////

/mob/living/carbon/handle_temperature()
	var/turf/open/turf = get_turf(src)
	if(!istype(turf))
		return
	var/temp = turf.return_temperature()

	if(temp < 0 )
		snow_shiver = world.time + 3 SECONDS + abs(temp)

//Start of a breath chain, calls breathe()
/mob/living/carbon/handle_breathing(times_fired)
	var/breath_effect_prob = 0
	var/turf/turf = get_turf(src)
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
	if(bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT)
		var/cold_severity = (BODYTEMP_COLD_DAMAGE_LIMIT - bodytemperature)
		breath_effect_prob += min(cold_severity * 15, 40)

	// Environmental modifiers
	var/turf/snow_turf = get_turf(src)
	if(snow_shiver > world.time || snow_turf?.snow)
		breath_effect_prob = min(breath_effect_prob + 30, 100)

	// Heavy breathing from exertion or cold body
	if(bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT - 3)
		breath_effect_prob = min(breath_effect_prob + 50, 100)
		if(prob(15) && !is_mouth_covered())
			to_chat(src, span_warning("Your breath comes out in heavy puffs of vapor."))

	if(prob(breath_effect_prob) && !is_mouth_covered())
		emit_breath_particle(/particles/fog/breath)

	return

/mob/living/proc/emit_breath_particle(particle_type)
	ASSERT(ispath(particle_type, /particles))

	var/obj/effect/abstract/particle_holder/holder = new(src, particle_type)
	var/particles/breath_particle = holder.particles
	var/breath_dir = dir

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

/mob/living/carbon/proc/has_smoke_protection()
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return TRUE
	return FALSE

/mob/living/carbon/proc/handle_bodyparts(delta_time, times_fired)
	for(var/I in bodyparts)
		var/obj/item/bodypart/BP = I
		if(BP.needs_processing)
			. |= BP.on_life(delta_time, times_fired)


/mob/living/carbon/proc/handle_organs(delta_time, times_fired)
	if(HAS_TRAIT(src, TRAIT_NO_ORGAN_PROCESS)) //internal stasis basically
		return
	if(stat < DEAD)
		var/list/already_processed_life = list()
		var/list/organlist
		var/obj/item/organ/organ
		for(var/organ_slot in GLOB.organ_process_order)
			if(QDELETED(src))
				break
			organlist = LAZYACCESS(internal_organs_slot, organ_slot)
			for(var/thing in organlist)
				if(QDELETED(src))
					break
				organ = thing
				// This exists mostly because reagent metabolization can cause organ shuffling
				if(!QDELETED(organ) && !already_processed_life[organ_slot] && (organ.owner == src))
					if(organ.needs_processing)
						organ.on_life(delta_time, times_fired)
					already_processed_life[organ] = TRUE
		var/datum/organ_process/organ_process
		for(var/thing in GLOB.organ_process_datum_order)
			if(QDELETED(src))
				break
			organ_process = GLOB.organ_processes_by_slot[thing]
			if(organ_process.needs_process(src))
				organ_process.handle_process(src, delta_time, times_fired)
	else
		var/obj/item/organ/organ
		for(var/thing in internal_organs)
			organ = thing
			//Needed so organs decay while inside the body
			organ.on_death(delta_time, times_fired)


/mob/living/carbon/handle_embedded_objects()
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		for(var/obj/item/embedded as anything in bodypart.embedded_objects)
			if(embedded.on_embed_life(src, bodypart))
				continue

			if(prob(embedded.embedding.embedded_pain_chance))
				bodypart.receive_damage(embedded.w_class*embedded.embedding.embedded_pain_multiplier)
				to_chat(src, "<span class='danger'>[embedded] in my [bodypart.name] hurts!</span>")

			if(prob(embedded.embedding.embedded_fall_chance))
				bodypart.receive_damage(embedded.w_class*embedded.embedding.embedded_fall_pain_multiplier)
				bodypart.remove_embedded_object(embedded)
				to_chat(src,"<span class='danger'>[embedded] falls out of my [bodypart.name]!</span>")

/*
Alcohol Poisoning Chart
Note that all higher effects of alcohol poisoning will inherit effects for smaller amounts (i.e. light poisoning inherts from slight poisoning)
In addition, severe effects won't always trigger unless the drink is poisonously strong
All effects don't start immediately, but rather get worse over time; the rate is affected by the imbiber's alcohol tolerance

0: Non-alcoholic
1-10: Barely classifiable as alcohol - occassional slurring
11-20: Slight alcohol content - slurring
21-30: Below average - imbiber begins to look slightly drunk
31-40: Just below average - no unique effects
41-50: Average - mild disorientation, imbiber begins to look drunk
51-60: Just above average - disorientation, vomiting, imbiber begins to look heavily drunk
61-70: Above average - small chance of blurry vision, imbiber begins to look smashed
71-80: High alcohol content - blurry vision, imbiber completely shitfaced
81-90: Extremely high alcohol content - light brain damage, passing out
91-100: Dangerously toxic - swift death
*/

//this updates all special effects: stun, sleeping, knockdown, druggy, stuttering, etc..
/mob/living/carbon/handle_status_effects()
	..()

	// These should all be real status effects :)))))))))

	if(stuttering)
		stuttering = max(stuttering-1, 0)

	if(slurring)
		slurring = max(slurring-1,0)

	if(cultslurring)
		cultslurring = max(cultslurring-1, 0)

	if(drunkenness)
		drunkenness = max(drunkenness - (drunkenness * 0.04) - 0.01, 0)
		if(drunkenness >= 1)
			SEND_SIGNAL(src, COMSIG_DRUG_INDULGE)
			if(has_quirk(/datum/quirk/vice/alcoholic))
				sate_addiction(/datum/quirk/vice/alcoholic)
		if(drunkenness >= 3)
			if(prob(3))
				slurring += 2
			adjust_jitter(-6 SECONDS)
			apply_status_effect(/datum/status_effect/buff/drunk)
		else
			remove_stress(/datum/stress_event/drunk)
		if(drunkenness >= 11 && slurring < 5)
			slurring += 1.2
		if(drunkenness >= 41)
			if(prob(25))
				adjust_confusion(4 SECONDS)
			set_dizzy(10 SECONDS)

		if(drunkenness >= 51)
			adjustToxLoss(1)
			if(prob(3))
				adjust_confusion(15 SECONDS)
				vomit() // vomiting clears toxloss, consider this a blessing
			set_dizzy(25 SECONDS)

		if(drunkenness >= 61)
			adjustToxLoss(1)
			if(prob(50))
				set_eye_blur_if_lower(10 SECONDS)

		if(drunkenness >= 71)
			adjustToxLoss(1)
			if(prob(10))
				set_eye_blur_if_lower(10 SECONDS)

		if(drunkenness >= 81)
			adjustToxLoss(3)
			if(prob(5) && !stat)
				to_chat(src, "<span class='warning'>Maybe I should lie down for a bit...</span>")

		if(drunkenness >= 91)
			adjustToxLoss(5)
			if(prob(20) && !stat)
				to_chat(src, "<span class='warning'>Just a quick nap...</span>")
				Sleeping(900)

		if(drunkenness >= 101)
			adjustToxLoss(5) //Let's be honest you shouldn't be alive by now

//used in human and monkey handle_environment()
/mob/living/carbon/proc/natural_bodytemperature_stabilization()
	var/body_temperature_difference = BODYTEMP_NORMAL - bodytemperature
	switch(bodytemperature)
		if(-INFINITY to BODYTEMP_COLD_DAMAGE_LIMIT) //Cold damage limit is 50 below the default, the temperature where you start to feel effects.
			return max((body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
		if(BODYTEMP_COLD_DAMAGE_LIMIT to BODYTEMP_NORMAL)
			return max(body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR, min(body_temperature_difference, BODYTEMP_AUTORECOVERY_MINIMUM/4))
		if(BODYTEMP_NORMAL to BODYTEMP_HEAT_DAMAGE_LIMIT) // Heat damage limit is 50 above the default, the temperature where you start to feel effects.
			return min(body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR, max(body_temperature_difference, -BODYTEMP_AUTORECOVERY_MINIMUM/4))
		if(BODYTEMP_HEAT_DAMAGE_LIMIT to INFINITY)
			return min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)	//We're dealing with negative numbers

///////////
//Stomach//
///////////

/mob/living/carbon/get_fullness()
	var/fullness = nutrition

	var/obj/item/organ/stomach/belly = getorganslot(ORGAN_SLOT_STOMACH)
	if(!belly) //nothing to see here if we do not have a stomach
		return fullness

	for(var/datum/reagent/bits as anything in belly.reagents.reagent_list)
		if(istype(bits, /datum/reagent/consumable))
			var/datum/reagent/consumable/goodbit = bits
			fullness += goodbit.nutriment_factor * goodbit.volume / goodbit.metabolization_rate
			continue
		fullness += 0.6 * bits.volume / bits.metabolization_rate //not food takes up space

	return fullness


/////////////
//CREMATION//
/////////////
/mob/living/carbon/proc/check_cremation()
	//Only cremate while actively on fire
	if(!on_fire)
		return

	if(stat != DEAD)
		return

	//Only starts when the chest has taken full damage
	var/obj/item/bodypart/chest = get_bodypart(BODY_ZONE_CHEST)
	if(!(chest.get_damage() >= (chest.max_damage - 5)))
		return

	//Burn off limbs one by one
	var/obj/item/bodypart/limb
	var/list/limb_list = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/should_update_body = FALSE
	for(var/zone in limb_list)
		limb = get_bodypart(zone)
		if(limb && !limb.skeletonized)
			if(limb.get_damage() >= (limb.max_damage - 5))
				limb.cremation_progress += rand(2,5)
				if(dna && dna.species && !(NOBLOOD in dna.species.species_traits))
					blood_volume = max(blood_volume - 10, 0)
				if(limb.cremation_progress >= 50)
					if(limb.status == BODYPART_ORGANIC) //Non-organic limbs don't burn
						limb.skeletonize()
						should_update_body = TRUE
						limb.drop_limb()
						limb.visible_message("<span class='warning'>[src]'s [limb.name] crumbles into ash!</span>")
						qdel(limb)
					else
						limb.drop_limb()
						limb.visible_message("<span class='warning'>[src]'s [limb.name] detaches from [p_their()] body!</span>")

	//Burn the head last
	var/obj/item/bodypart/head = get_bodypart(BODY_ZONE_HEAD)
	if(head && !head.skeletonized)
		if(head.get_damage() >= (head.max_damage - 5))
			head.cremation_progress += rand(1,4)
			if(head.cremation_progress >= 50)
				if(head.status == BODYPART_ORGANIC) //Non-organic limbs don't burn
					head.skeletonize()
					should_update_body = TRUE
					head.drop_limb()
					head.visible_message("<span class='warning'>[src]'s head crumbles into ash!</span>")
					qdel(head)
				else
					head.drop_limb()
					head.visible_message("<span class='warning'>[src]'s head detaches from [p_their()] body!</span>")

	//Nothing left: dust the body, drop the items (if they're flammable they'll burn on their own)
	if(chest && !chest.skeletonized)
		if(chest.get_damage() >= (chest.max_damage - 5))
			chest.cremation_progress += rand(1,4)
			if(chest.cremation_progress >= 100)
				visible_message("<span class='warning'>[src]'s body crumbles into a pile of ash!</span>")
				dust(TRUE, TRUE)
				chest.skeletonized = TRUE
				if(ishuman(src))
					var/mob/living/carbon/human/H = src
					H.underwear = "Nude"
				should_update_body = TRUE
				if(dna && dna.species)
					if(dna && dna.species && !(NOBLOOD in dna.species.species_traits))
						blood_volume = 0
					dna.species.species_traits |= NOBLOOD

	if(should_update_body)
		update_body()

////////////////
//BRAIN DAMAGE//
////////////////

/mob/living/carbon/proc/handle_brain_damage()
	for(var/datum/brain_trauma/BT as anything in get_traumas())
		BT.on_life()

/////////////////////////////////////
//MONKEYS WITH TOO MUCH CHOLOESTROL//
/////////////////////////////////////

/mob/living/carbon/proc/can_heartattack()
	if(!needs_heart())
		return FALSE
	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(!heart || (heart.organ_flags & ORGAN_SYNTHETIC))
		return FALSE
	return TRUE

/mob/living/carbon/proc/needs_heart()
	if(HAS_TRAIT(src, TRAIT_STABLEHEART))
		return FALSE
	if(NOBLOOD in dna?.species?.species_traits) //not all carbons have species!
		return FALSE
	return TRUE

/*
 * The mob is having a heart attack
 *
 * NOTE: this is true if the mob has no heart and needs one, which can be suprising,
 * you are meant to use it in combination with can_heartattack for heart attack
 * related situations (i.e not just cardiac arrest)
 */
/mob/living/carbon/proc/undergoing_cardiac_arrest()
	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(istype(heart) && heart.beating)
		return FALSE
	else if(!needs_heart())
		return FALSE
	return TRUE

/mob/living/proc/set_heartattack(status)
	return

/mob/living/carbon/set_heartattack(status)
	if(!can_heartattack())
		return FALSE

	var/list/hearts = getorganslotlist(ORGAN_SLOT_HEART)
	if(status)
		pulse = PULSE_NONE
		for(var/obj/item/organ/heart/heart in hearts)
			heart.Stop()
	else
		pulse = PULSE_NORM
		for(var/obj/item/organ/heart/heart in hearts)
			heart.Restart()

/// Brain is poopy (hardcrit)
/mob/living/proc/undergoing_nervous_system_failure()
	return FALSE

/mob/living/carbon/undergoing_nervous_system_failure()
	var/obj/item/organ/brain/brain = getorganslot(ORGAN_SLOT_BRAIN)
	if(!brain)
		return TRUE
	if(brain.is_failing())
		return TRUE

/// Handles sleep. Mobs with no_sleep trait cannot sleep.
/*
*	The mob tries to go to sleep or IS sleeping
*
*	Accounts for...
*	TRAIT_NOSLEEP
*	CANT_SLEEP_IN
*	Hunger and Hydration.
*/

/mob/living/carbon/proc/handle_sleep()
	if(HAS_TRAIT(src, TRAIT_NOSLEEP))
		return
	var/cant_fall_asleep = FALSE
	var/cause = "I just can't..."
	var/list/equipped_items = get_equipped_items(FALSE)
	if(HAS_TRAIT(src, TRAIT_NUDE_SLEEPER) && length(equipped_items))
		cant_fall_asleep = TRUE
		cause = "I can't sleep in clothes, it's too uncomfortable.."
	else
		for(var/obj/item/clothing/thing in equipped_items)
			if(thing.clothing_flags & CANT_SLEEP_IN)
				cant_fall_asleep = TRUE
				cause = "\The [thing] bothers me..."
				break

	//Healing while sleeping in a bed
	if(stat >= UNCONSCIOUS)
		var/sleepy_mod = buckled?.sleepy || 0.5
		var/bleed_rate = get_bleed_rate()
		var/yess = HAS_TRAIT(src, TRAIT_NOHUNGER)
		if(nutrition > 0 || yess)
			adjust_energy(sleepy_mod * (max_energy * 0.02))
		if(HAS_TRAIT(src, TRAIT_BETTER_SLEEP))
			adjust_energy(sleepy_mod * (max_energy * 0.004))
		if(locate(/obj/item/bedsheet) in get_turf(src))
			adjust_energy(sleepy_mod * (max_energy * 0.004))
		if(hydration > 0 || yess)
			if(!bleed_rate)
				adjust_bloodvolume(4 * sleepy_mod, BLOOD_VOLUME_NORMAL)
			for(var/obj/item/bodypart/affecting as anything in bodyparts)
				//for context, it takes 5 small cuts (0.4 x 5) or 3 normal cuts (0.8 x 3) for a bodypart to not be able to heal itself
				if(affecting.get_bleed_rate() >= 2)
					continue
				if(affecting.heal_damage(sleepy_mod * 1.5, sleepy_mod * 1.5, required_status = BODYPART_ORGANIC, updating_health = FALSE)) // multiplier due to removing healing from sleep effect
					src.update_damage_overlays()
				for(var/datum/wound/wound as anything in affecting.wounds)
					if(!wound.sleep_healing)
						continue
					wound.heal_wound(wound.sleep_healing * sleepy_mod)
			adjustToxLoss( - ( sleepy_mod * 0.15) )
			updatehealth()
			if(eyesclosed && !HAS_TRAIT(src, TRAIT_NOSLEEP))
				Sleeping(300)
		tiredness = 0
	else if(!IsSleeping() && !HAS_TRAIT(src, TRAIT_NOSLEEP))
		// Resting on a bed or something
		if(buckled?.sleepy)
			if(eyesclosed && !cant_fall_asleep || (eyesclosed && !(fallingas >= 10 && cant_fall_asleep)))
				if(!fallingas)
					to_chat(src, span_warning("I'll fall asleep soon..."))
				fallingas++
				if(istype(buckled, /obj/structure/bed))
					var/obj/structure/bed/bed_check = buckled
					if(bed_check.sheet_tucked)
						if(fallingas > 10)
							to_chat(src, ("This bed is so cozy..."))
							add_stress(/datum/stress_event/cozy_sleep)
							Sleeping(30 SECONDS)
							bed_check.sheet_tucked = FALSE

				if(fallingas > 15)
					Sleeping(300)
			else if(eyesclosed && fallingas >= 10 && cant_fall_asleep)
				if(fallingas != 13)
					to_chat(src, span_boldwarning("I can't sleep...[cause]"))
				fallingas -= 5
			else
				adjust_energy(buckled.sleepy * (max_energy * 0.01))
		// Resting on the ground (not sleeping or with eyes closed and about to fall asleep)
		else if(body_position == LYING_DOWN)
			if(eyesclosed && !cant_fall_asleep || (eyesclosed && !(fallingas >= 10 && cant_fall_asleep)))
				if(!fallingas)
					to_chat(src, span_warning("I'll fall asleep soon, although a bed would be more comfortable..."))
				fallingas++
				if(fallingas > 25)
					Sleeping(300)
			else if(eyesclosed && fallingas >= 10 && cant_fall_asleep)
				if(fallingas != 13)
					to_chat(src, span_boldwarning("I can't sleep...[cause]"))
				fallingas -= 5
			else
				adjust_energy((max_energy * 0.01))
		else if(fallingas)
			fallingas = 0
		tiredness = min(tiredness + 1, 100)
