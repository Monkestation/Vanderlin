
/mob/living/proc/get_elemental_resistance(resistance_type = COLD_DAMAGE)
	switch(resistance_type)
		if(COLD_DAMAGE)
			return min(cold_res, max_cold_res)
		if(FIRE_DAMAGE)
			return min(fire_res, max_fire_res)
		if(LIGHTNING_DAMAGE)
			return min(lightning_res, max_lightning_res)

/mob/living/proc/get_status_mod(status_key)
	if(!length(status_modifiers))
		return 0
	return LAZYACCESS(status_modifiers, status_key)

/mob/living/proc/apply_elemental_damage(damage = 0, damage_type = COLD_DAMAGE, elemental_pen = 0)
	var/elemental_resistance = get_elemental_resistance(damage_type)
	elemental_resistance = max(0, elemental_resistance - elemental_pen)
	damage *= (1 - (elemental_resistance * 0.01))
	apply_damage(damage)

/*
	apply_damage(a,b,c)
	args
	a:damage - How much damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/

/mob/living/proc/apply_damage(damage = 0, damagetype = BRUTE, def_zone = null, blocked = 0, forced = FALSE, spread_damage = FALSE)
	SEND_SIGNAL(src, COMSIG_MOB_APPLY_DAMGE, damage, damagetype, def_zone)
	var/hit_percent = 1
	damage = max(damage-blocked,0)
	if(!damage || (!forced && hit_percent <= 0))
		return 0
	set_typing_indicator(FALSE)
	var/damage_amount =  forced ? damage : damage * hit_percent
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage_amount, forced = forced)
		if(BURN)
			adjustFireLoss(damage_amount, forced = forced)
		if(TOX)
			adjustToxLoss(damage_amount, forced = forced)
		if(OXY)
			adjustOxyLoss(damage_amount, forced = forced)
		if(CLONE)
			adjustCloneLoss(damage_amount, forced = forced)
	update_damage_overlays()
	return 1

/mob/living/proc/apply_damage_type(damage = 0, damagetype = BRUTE) //like apply damage except it always uses the damage procs
	switch(damagetype)
		if(BRUTE)
			return adjustBruteLoss(damage)
		if(BURN)
			return adjustFireLoss(damage)
		if(TOX)
			return adjustToxLoss(damage)
		if(OXY)
			return adjustOxyLoss(damage)
		if(CLONE)
			return adjustCloneLoss(damage)

/mob/living/proc/get_damage_amount(damagetype = BRUTE)
	switch(damagetype)
		if(BRUTE)
			return getBruteLoss()
		if(BURN)
			return getFireLoss()
		if(TOX)
			return getToxLoss()
		if(OXY)
			return getOxyLoss()
		if(CLONE)
			return getCloneLoss()



/mob/living/proc/apply_effect(effect = 0,effecttype = EFFECT_STUN, blocked = FALSE)
	var/hit_percent = (100-blocked)/100
	if(!effect || (hit_percent <= 0))
		return 0
	switch(effecttype)
		if(EFFECT_STUN)
			Stun(effect * hit_percent)
		if(EFFECT_KNOCKDOWN)
			Knockdown(effect * hit_percent)
		if(EFFECT_PARALYZE)
			Paralyze(effect * hit_percent)
		if(EFFECT_IMMOBILIZE)
			Immobilize(effect * hit_percent)
		if(EFFECT_UNCONSCIOUS)
			Unconscious(effect * hit_percent)
		if(EFFECT_SLUR)
			slurring = max(slurring,(effect * hit_percent))
		if(EFFECT_STUTTER)
			if((status_flags & CANSTUN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) // stun is usually associated with stutter
				stuttering = max(stuttering,(effect * hit_percent))
		if(EFFECT_JITTER)
			if((status_flags & CANSTUN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE))
				set_jitter_if_lower(effect * hit_percent SECONDS)
	return 1


/mob/living/proc/apply_effects(stun = 0, knockdown = 0, unconscious = 0, irradiate = 0, slur = 0, stutter = 0, eyeblur = 0, drowsy = 0, blocked = FALSE, jitter = 0, paralyze = 0, immobilize = 0)
	if(blocked >= 100)
		return BULLET_ACT_BLOCK
	if(stun)
		apply_effect(stun, EFFECT_STUN, blocked)
	if(knockdown)
		apply_effect(knockdown, EFFECT_KNOCKDOWN, blocked)
	if(unconscious)
		apply_effect(unconscious, EFFECT_UNCONSCIOUS, blocked)
	if(paralyze)
		apply_effect(paralyze, EFFECT_PARALYZE, blocked)
	if(immobilize)
		apply_effect(immobilize, EFFECT_IMMOBILIZE, blocked)
	if(irradiate)
		apply_effect(irradiate, EFFECT_IRRADIATE, blocked)
	if(slur)
		apply_effect(slur, EFFECT_SLUR, blocked)
	if(stutter)
		apply_effect(stutter, EFFECT_STUTTER, blocked)
	if(jitter)
		apply_effect(jitter, EFFECT_JITTER, blocked)
	return BULLET_ACT_HIT


/mob/living/proc/getBruteLoss()
	return bruteloss

/mob/living/proc/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_status)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	bruteloss = CLAMP((bruteloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	SEND_SIGNAL(src, COMSIG_LIVING_ADJUSTED, (amount * CONFIG_GET(number/damage_multiplier)), BRUTE)
	if(updating_health)
		updatehealth(amount)
	return amount

/mob/living/proc/setBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_bodytype)
	if(!forced && (status_flags & GODMODE))
		return
	. = bruteloss
	bruteloss = amount
	if(updating_health)
		updatehealth(amount)

/mob/living/proc/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return
	. = oxyloss
	oxyloss = clamp((oxyloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	SEND_SIGNAL(src, COMSIG_LIVING_ADJUSTED, (amount * CONFIG_GET(number/damage_multiplier)), OXY)
	if(updating_health)
		updatehealth(amount)

/mob/living/proc/setOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && status_flags & GODMODE)
		return
	. = oxyloss
	oxyloss = amount
	if(updating_health)
		updatehealth(amount)

/mob/living/proc/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return
	toxloss = clamp((toxloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	SEND_SIGNAL(src, COMSIG_LIVING_ADJUSTED, (amount * CONFIG_GET(number/damage_multiplier)), TOX)
	if(updating_health)
		updatehealth(amount)
	return amount

/mob/living/proc/setToxLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	toxloss = amount
	if(updating_health)
		updatehealth(amount)
	return amount

/mob/living/proc/getFireLoss()
	return fireloss

/mob/living/proc/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	fireloss = CLAMP((fireloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	SEND_SIGNAL(src, COMSIG_LIVING_ADJUSTED, (amount * CONFIG_GET(number/damage_multiplier)), BURN)
	if(updating_health)
		updatehealth(amount)
	return amount

/mob/living/proc/setFireLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return
	. = fireloss
	fireloss = amount
	if(updating_health)
		updatehealth(amount)

/mob/living/proc/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	cloneloss = CLAMP((cloneloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	SEND_SIGNAL(src, COMSIG_LIVING_ADJUSTED, (amount * CONFIG_GET(number/damage_multiplier)), CLONE)
	if(updating_health)
		updatehealth(amount)
	return amount

/mob/living/proc/setCloneLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	cloneloss = amount
	if(updating_health)
		updatehealth(amount)
	return amount

/mob/living/proc/adjustOrganLoss(slot, amount, maximum)
	return

/mob/living/proc/setOrganLoss(slot, amount, maximum)
	return

/mob/living/proc/getOrganLoss(slot)
	return

// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_bodypart_damage(brute = 0, burn = 0, updating_health = TRUE, required_status)
	adjustBruteLoss(-brute, FALSE) //zero as argument for no instant health update
	adjustFireLoss(-burn, FALSE)
	if(updating_health)
		updatehealth()

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_bodypart_damage(brute = 0, burn = 0, updating_health = TRUE, required_status, check_armor = FALSE)
	adjustBruteLoss(brute, FALSE) //zero as argument for no instant health update
	adjustFireLoss(burn, FALSE)
	if(updating_health)
		updatehealth(brute + burn)

// heal MANY bodyparts, in random order
/mob/living/proc/heal_overall_damage(brute = 0, burn = 0, required_status, updating_health = TRUE)
	adjustBruteLoss(-brute, FALSE) //zero as argument for no instant health update
	adjustFireLoss(-burn, FALSE)
	if(updating_health)
		updatehealth(brute + burn)

// damage MANY bodyparts, in random order
/mob/living/proc/take_overall_damage(brute = 0, burn = 0, updating_health = TRUE, required_status = null)
	adjustBruteLoss(brute, FALSE) //zero as argument for no instant health update
	adjustFireLoss(burn, FALSE)
	if(updating_health)
		updatehealth(brute + burn)

//heal up to amount damage, in a given order
/mob/living/proc/heal_ordered_damage(amount, list/damage_types)
	. = amount //we'll return the amount of damage healed
	for(var/i in damage_types)
		var/amount_to_heal = min(amount, get_damage_amount(i)) //heal only up to the amount of damage we have
		if(amount_to_heal)
			apply_damage_type(-amount_to_heal, i)
			amount -= amount_to_heal //remove what we healed from our current amount
		if(!amount)
			break
	. -= amount //if there's leftover healing, remove it from what we return

/**
 * Check if defense is possible against an attack
 * @param datum/intent/intenty The intent used for the attack
 * @param mob/living/user The attacker
 * @return TRUE if defense successful, FALSE otherwise
 */
/mob/living/proc/checkdefense(datum/intent/intenty, mob/living/user)
	if(!cmode || stat || (!canparry && !candodge) || user == src || HAS_TRAIT(src, TRAIT_IMMOBILIZED))
		return FALSE
	if(client && used_intent && client.charging && used_intent.tranged && !used_intent.tshield)
		return FALSE

	var/prob2defend = user.defprob
	var/can_dodge_see = TRUE
	if(src && user)
		prob2defend = 0

	if(!can_see_cone(user)) //for future, if you can't see the attacker, parrying will be useless, unless you're on dodge intent. this also affect being blinded?
		if(d_intent == INTENT_PARRY && !HAS_TRAIT(src, TRAIT_BLINDFIGHTING))
			return FALSE
		can_dodge_see = FALSE
		prob2defend = max(prob2defend - 15, 0)

	if(m_intent == MOVE_INTENT_RUN)
		prob2defend = max(prob2defend - 15, 0)

	// Handle defense based on intent
	switch(d_intent)
		if(INTENT_PARRY)
			if(HAS_TRAIT(src, TRAIT_UNPARRYING))
				return FALSE
			return attempt_parry(intenty, user, prob2defend)
		if(INTENT_DODGE)
			if(HAS_TRAIT(src, TRAIT_UNDODGING))
				return FALSE
			return attempt_dodge(intenty, user, can_dodge_see)

	return FALSE
