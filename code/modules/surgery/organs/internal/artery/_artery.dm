/obj/item/organ/artery
	name = "artery"
	desc = "An artery is torn! Literally."
	icon_state = "artery"
	base_icon_state = "artery"
	sellprice = 1

	organ_flags = ORGAN_LIMB_SUPPORTER|ORGAN_INDESTRUCTIBLE|ORGAN_NO_VIOLENT_DAMAGE
	organ_efficiency = list(ORGAN_SLOT_ARTERY = 100)
	needs_processing = TRUE

	maxHealth = ARTERY_MAX_HEALTH
	high_threshold = ARTERY_MAX_HEALTH * 0.8
	low_threshold = ARTERY_MAX_HEALTH * 0.2
	pain_multiplier = 0.05

	organ_volume = 0.5
	max_blood_storage = 100
	current_blood = 100
	oxygen_req = 0.25
	nutriment_req = 0.09
	hydration_req = 0.03

	/// How much blood we gush when torn
	var/blood_flow = ARTERIAL_BLOOD_FLOW
	/// If torn, this is basically the time until we gush again
	COOLDOWN_DECLARE(next_squirt)
	/// Minimum time until we squirt again
	var/squirt_delay_min_seconds = 4
	/// Maximum time until we squirt again
	var/squirt_delay_max_seconds = 10
	///squirting sound
	var/squirt_sound = list('sound/gore/artery1.ogg', 'sound/gore/artery2.ogg', 'sound/gore/artery3.ogg')

/obj/item/organ/artery/can_heal(delta_time, times_fired)
	return FALSE

/obj/item/organ/artery/on_life(delta_time, times_fired)
	. = ..()
	// Dead, pulseless or cryosleep people do not pump blood
	if(!(is_bruised() || is_failing()) || !owner.pulse || (owner.bodytemperature <= -15))
		return
	var/bleed_mod = 1 * (damage/maxHealth)
	var/obj/item/bodypart/limb = owner.get_bodypart(current_zone)
	for(var/obj/item/grabbing/grab in grabbedby)
		bleed_mod *= grab.bleed_suppressing
	if(limb.bandage)
		bleed_mod *= limb.bandage.bandage_effectiveness
	switch(owner.pulse)
		if(PULSE_NONE)
			bleed_mod *= 0
		if(PULSE_SLOW)
			bleed_mod *= 0.8
		if(PULSE_FAST)
			bleed_mod *= 1.25
		if(PULSE_FASTER, PULSE_THREADY)
			bleed_mod *= 1.5
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		if(human_owner.physiology)
			bleed_mod *= human_owner.physiology.bleed_mod
	var/final_bleed_rate = CEILING(blood_flow * bleed_mod, 0.1)
	if(!final_bleed_rate)
		return
	if(COOLDOWN_FINISHED(src, next_squirt))
		squirt(final_bleed_rate)
	else
		squirt_less(final_bleed_rate)

/obj/item/organ/artery/tear()
	if(!owner)
		return
	if(owner.stat < UNCONSCIOUS)
		owner.emote("scream")
	owner.bleed(blood_flow)
	current_blood = 0
	applyOrganDamage(maxHealth * 0.5)
	var/cd_time = rand(squirt_delay_min_seconds, squirt_delay_max_seconds) SECONDS
	COOLDOWN_START(src, next_squirt, cd_time)

/obj/item/organ/artery/dissect()
	if(!owner)
		return
	if(owner.stat < UNCONSCIOUS)
		owner.emote("scream")
	owner.bleed(blood_flow)
	current_blood = 0
	applyOrganDamage(maxHealth)
	var/cd_time = rand(squirt_delay_min_seconds, squirt_delay_max_seconds) SECONDS
	COOLDOWN_START(src, next_squirt, cd_time)

/obj/item/organ/artery/applyOrganDamage(amount, maximum = maxHealth, silent = FALSE)
	. = ..()
	if(damage <= 0)
		mend()

/obj/item/organ/artery/proc/squirt(amount = 1, force = FALSE)
	var/obj/item/bodypart/limb = owner.get_bodypart(current_zone)
	var/open_wound = FALSE
	for(var/datum/wound/wound as anything in limb.wounds)
		if(wound.bleed_rate)
			open_wound = TRUE
			break
	/*
	for(var/datum/injury/injury as anything in limb.injuries)
		if(injury.is_bleeding())
			open_wound = TRUE
			break
	*/
	var/unrestricted_flow = TRUE
	if(LAZYLEN(limb.grabbedby) || limb.bandage)
		unrestricted_flow = FALSE
	if(unrestricted_flow || force)
		if(open_wound && (owner.get_blood_circulation() >= amount) || force)
			playsound(owner, squirt_sound, 75, 0)
			owner.bleed(amount)
			//owner.do_arterygush()
			COOLDOWN_START(src, next_squirt, rand(squirt_delay_min_seconds, squirt_delay_max_seconds) SECONDS)
		else
			COOLDOWN_START(src, next_squirt, rand(squirt_delay_min_seconds, squirt_delay_max_seconds) SECONDS)
			return squirt_less(amount, open_wound)
	else
		return squirt_less(amount, open_wound)

/obj/item/organ/artery/proc/squirt_less(amount = 1, open_wound = TRUE)
	// Just bleed without being *too* dramatic
	if(open_wound)
		owner.bleed(amount)
	// No open wound, even less drama
	else
		owner.adjust_bloodvolume(-amount)
