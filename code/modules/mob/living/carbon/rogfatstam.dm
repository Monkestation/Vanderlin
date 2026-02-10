/mob/living/proc/update_stamina() //update hud and regen after last_fatigued delay on taking
	var/athletics_skill = 0
	if(mind)
		athletics_skill = get_skill_level(/datum/skill/misc/athletics, TRUE)
	maximum_stamina = (STAEND + athletics_skill) * 10 //This here is the calculation for max STAMINA / GREEN

	var/delay = (HAS_TRAIT(src, TRAIT_APRICITY) && (GLOB.tod == TOD_DAWN || GLOB.tod == TOD_DAY)) ? 11 : 20
	if(world.time > last_fatigued + delay) //regen fatigue
		var/added = energy / max_energy
		added = round(-10+ (added*-40))
		if(HAS_TRAIT(src, TRAIT_MISSING_NOSE))
			added = round(added * 0.5, 1)
		//Assuming full energy bar give you 50 regen, this make it with the trait that even if you have higher endurance/athletics skill, which mean a higher fatigue bar, you won't have your regen halved
		if(HAS_TRAIT(src, TRAIT_NOENERGY))
			added = -50
		if(stamina >= 1)
			adjust_stamina(added)
		else
			stamina = 0

	update_health_hud(TRUE)

/mob/living/proc/update_energy()
	///this is kinda weird and not at the same time for energy being tied to this,
	/// since energy is both a magical and physical system
	var/athletics_skill = 0
	if(mind)
		athletics_skill = get_skill_level(/datum/skill/misc/athletics, TRUE)
	max_energy = (STAEND + athletics_skill) * 100 // ENERGY / BLUE (Average of 1000)
	if(cmode)
		if(!HAS_TRAIT(src, TRAIT_BREADY))
			adjust_energy(-2)

/mob/proc/adjust_energy(added as num)
	return

/mob/living/adjust_energy(added as num)
	///this trait affects both stamina and energy since they are part of the same system.
	if(HAS_TRAIT(src, TRAIT_NOSTAMINA))
		return TRUE
	///This trait specifically affect energy.
	if(HAS_TRAIT(src, TRAIT_NOENERGY))
		return TRUE
	energy += added
	if(energy >= max_energy)
		energy = max_energy
		update_health_hud(TRUE)
		return FALSE
	else
		if(energy <= 0)
			energy = 0
			if(m_intent == MOVE_INTENT_RUN) //can't sprint at zero stamina
				toggle_rogmove_intent(MOVE_INTENT_WALK)
		if(added < 0)
			SEND_SIGNAL(src, COMSIG_MOB_ENERGY_SPENT, abs(added))
		update_health_hud(TRUE)
		return TRUE

/mob/proc/check_energy(has_amount)
	return TRUE

/mob/living/check_energy(has_amount)
	if(!has_amount || has_amount > max_energy)
		return FALSE
	if((max_energy - energy) < has_amount)
		return FALSE
	return TRUE

/mob/proc/adjust_stamina(added as num)
	return TRUE

/// Positive added values deplete stamina. Negative added values restore stamina and deplete energy unless internal_regen is FALSE.
/mob/living/adjust_stamina(added as num, emote_override, force_emote = TRUE, internal_regen = TRUE) //call update_stamina here and set last_fatigued, return false when not enough fatigue left
	if(HAS_TRAIT(src, TRAIT_NOSTAMINA))
		return TRUE
	stamina = CLAMP(stamina+added, 0, maximum_stamina)
	SEND_SIGNAL(src, COMSIG_LIVING_ADJUSTED, -added, STAMINA)
	if(internal_regen && added < 0)
		adjust_energy(added)
	if(added >= 5)
		if(energy <= 0)
			if(iscarbon(src))
				var/mob/living/carbon/C = src
				if(!HAS_TRAIT(C, TRAIT_NOHUNGER))
					if(C.nutrition <= 0)
						if(C.hydration <= 0)
							C.heart_attack()
							return FALSE
	if(stamina >= maximum_stamina)
		stamina = maximum_stamina
		update_health_hud(TRUE)
		if(m_intent == MOVE_INTENT_RUN) //can't sprint at full fatigue
			toggle_rogmove_intent(MOVE_INTENT_WALK, TRUE)
		if(!emote_override)
			emote("fatigue", forced = force_emote)
		else
			emote(emote_override, forced = force_emote)
		set_eye_blur_if_lower(4 SECONDS)
		last_fatigued = world.time + 30 //extra time before fatigue regen sets in
		stop_attack()
		changeNext_move(CLICK_CD_EXHAUSTED)
		flash_fullscreen("blackflash")
		if(energy <= 0)
			addtimer(CALLBACK(src, PROC_REF(Knockdown), 30), 10)
		addtimer(CALLBACK(src, PROC_REF(Immobilize), 30), 10)
		if(iscarbon(src))
			var/mob/living/carbon/C = src
			if(C.stress >= 30)
				C.heart_attack()
			if(!HAS_TRAIT(C, TRAIT_NOHUNGER))
				if(C.nutrition <= 0)
					if(C.hydration <= 0)
						C.heart_attack()
		return FALSE
	else
		if(internal_regen)
			last_fatigued = world.time
		update_health_hud(TRUE)
		return TRUE

/mob/proc/check_stamina(has_amount)
	return TRUE

/mob/living/check_stamina(has_amount)
	if(!has_amount || has_amount > maximum_stamina)
		return FALSE
	if((maximum_stamina - stamina) < has_amount)
		return FALSE
	return TRUE

/mob/living/carbon
	var/heart_attacking = FALSE

/mob/living/carbon/proc/heart_attack()
	if(HAS_TRAIT(src, TRAIT_NOSTAMINA))
		return
	if(!heart_attacking)
		var/mob/living/carbon/C = src
		C.visible_message(C, "<span class='danger'>[C] clutches at [C.p_their()] chest!</span>") // Other people know something is wrong.
		emote("breathgasp", forced = TRUE)
		shake_camera(src, 1, 3)
		set_eye_blur_if_lower(80 SECONDS)
		var/stuffy = list("ZIZO GRABS MY WEARY HEART!","ARGH! MY HEART BEATS NO MORE!","NO... MY HEART HAS BEAT IT'S LAST!","MY HEART HAS GIVEN UP!","MY HEART BETRAYS ME!","THE METRONOME OF MY LIFE STILLS!")
		to_chat(src, "<span class='userdanger'>[pick(stuffy)]</span>")
		addtimer(CALLBACK(src, PROC_REF(set_heartattack), TRUE), 3 SECONDS) //no penthrite so just doing this
		// addtimer(CALLBACK(src, PROC_REF(adjustOxyLoss), 110), 30) This was commented out because the heart attack already kills, why put people into oxy crit instantly?

/mob/living/proc/freak_out()
	return

/mob/proc/do_freakout_scream()
	emote("scream", forced=TRUE)

/mob/living/carbon/freak_out()
	if(!MOBTIMER_FINISHED(src, MT_FREAKOUT, 10 SECONDS))
		flash_fullscreen("stressflash")
		return
	MOBTIMER_SET(src, MT_FREAKOUT)

	shake_camera(src, 1, 3)
	flash_fullscreen("stressflash")
	changeNext_move(CLICK_CD_EXHAUSTED)
	add_stress(/datum/stress_event/freakout)
	var/heart_value = 30
	if(HAS_TRAIT(src, TRAIT_WEAK_HEART))
		heart_value *= 0.5
	if(stress >= heart_value)
		heart_attack()
	else
		emote("fatigue", forced = TRUE)
		if(stress > 15)
			addtimer(CALLBACK(src, TYPE_PROC_REF(/mob, do_freakout_scream)), rand(30,50))
	if(hud_used)
		var/matrix/skew = matrix()
		skew.Scale(2)
		var/atom/movable/plane_master_controller/pm_controller = hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
		for(var/atom/movable/screen/plane_master/pm_iterator as anything in pm_controller.get_planes())
			animate(pm_iterator, transform = skew, time = 1, easing = QUAD_EASING)
			animate(transform = -skew, time = 30, easing = QUAD_EASING)

/mob/living/proc/stamina_reset()
	stamina = 0
	last_fatigued = 0
