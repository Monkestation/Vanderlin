
//Here are the procs used to modify status effects of a mob.
//The effects include: stun, knockdown, unconscious, sleeping, resting, jitteriness, dizziness, ear damage,
// eye damage, eye_blind, eye_blurry, druggy, TRAIT_BLIND trait, and TRAIT_NEARSIGHT trait.

///Set the slowdown of a mob
/mob/proc/Slowdown(amount)
	return

/mob/proc/psydo_nyte()
	sleep(2)
	overlay_fullscreen("LIVES", /atom/movable/screen/fullscreen/zezuspsyst)
	sleep(2)
	clear_fullscreen("LIVES")

///Adjust the disgust level of a mob
/mob/proc/adjust_disgust(amount)
	return

///Set the disgust level of a mob
/mob/proc/set_disgust(amount)
	return

///Adjust the body temperature of a mob, with min/max settings
/mob/proc/adjust_bodytemperature(amount,min_temp=BODYTEMP_MIN_TEMPERATURE,max_temp=BODYTEMP_MAX_TEMPERATURE)
	if(bodytemperature >= min_temp && bodytemperature <= max_temp)
		bodytemperature = CLAMP(bodytemperature + amount,min_temp,max_temp)
