
/mob/living/carbon/get_elemental_resistance(resistance_type = COLD_DAMAGE)
	var/resistance = 0
	var/max_resistance_modifers = 0
	for(var/obj/item/item in get_equipped_items())
		var/item_resistance = SEND_SIGNAL(item, COMSIG_ATOM_GET_RESISTANCE, resistance_type)
		var/item_max_resistance = SEND_SIGNAL(item, COMSIG_ATOM_GET_MAX_RESISTANCE, resistance_type)

		if(item_resistance)
			resistance += item_resistance
		if(item_max_resistance)
			max_resistance_modifers += item_max_resistance

	switch(resistance_type)
		if(COLD_DAMAGE)
			return min(cold_res + resistance, max_cold_res + max_resistance_modifers)
		if(FIRE_DAMAGE)
			return min(fire_res + resistance, max_fire_res + max_resistance_modifers)
		if(LIGHTNING_DAMAGE)
			return min(lightning_res + resistance, max_lightning_res + max_resistance_modifers)


/mob/living/carbon/get_status_mod(status_key)
	var/total_modifier = LAZYACCESS(status_modifiers, status_key)
	for(var/obj/item/item in get_equipped_items())
		var/item_modifier = SEND_SIGNAL(item, COMSIG_ATOM_GET_STATUS_MOD, status_key)
		if(item_modifier)
			total_modifier += item_modifier
	return total_modifier


/mob/living/carbon/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE, damage_type, skip_dtype, can_crit = TRUE)
	SEND_SIGNAL(src, COMSIG_MOB_APPLY_DAMAGE, damage, damagetype, def_zone)
	var/hit_percent = 1
	damage = max(damage-blocked,0)
//	var/hit_percent = (100-blocked)/100
	if(!damage || (!forced && hit_percent <= 0))
		return 0

	var/obj/item/bodypart/BP = null
	if(!spread_damage)
		if(isbodypart(def_zone)) //we specified a bodypart object
			BP = def_zone
		else
			if(!def_zone)
				def_zone = ran_zone(def_zone)
			BP = get_bodypart(check_zone(def_zone))
			if(!BP)
				BP = bodyparts[1]

	var/damage_amount = forced ? damage : damage * hit_percent
	switch(damagetype)
		if(BRUTE)
			if(BP)
				if(BP.receive_damage(damage_amount, 0))
					update_damage_overlays()
			else //no bodypart, we deal damage with a more general method.
				adjustBruteLoss(damage_amount, forced = forced)
		if(BURN)
			if(BP)
				if(BP.receive_damage(0, damage_amount))
					update_damage_overlays()
			else
				adjustFireLoss(damage_amount, forced = forced)
		if(TOX)
			adjustToxLoss(damage_amount, forced = forced)
		if(OXY)
			adjustOxyLoss(damage_amount, forced = forced)
		if(CLONE)
			adjustCloneLoss(damage_amount, forced = forced)
		if(PAIN, SHOCK_PAIN)
			if(BP)
				BP.add_pain(damage_amount)
			else
				adjustPainLoss(damage_amount, forced = forced)
	if(damage_amount)
		return damage_amount
	else
		return TRUE


//These procs fetch a cumulative total damage from all bodyparts
/mob/living/carbon/getBruteLoss()
	var/amount = 0
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		amount += BP.brute_dam
	return amount

/mob/living/carbon/getFireLoss()
	var/amount = 0
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		amount += BP.burn_dam
	return amount

/mob/living/carbon/setBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_bodytype, damage_type)
	var/current = getBruteLoss()
	var/diff = amount - current
	if(!diff)
		return
	adjustBruteLoss(diff, updating_health, forced, required_bodytype, damage_type)

/mob/living/carbon/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_status, damage_type = WOUND_INTERNAL_BRUISE, can_crit = FALSE, true_heal = FALSE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	if(amount > 0)
		take_overall_damage(amount, 0, updating_health, required_status, damage_type = damage_type, no_crit = can_crit)
	else
		heal_overall_damage(abs(amount), 0, required_status ? required_status : BODYPART_ORGANIC, updating_health, true_heal)
	return amount

/mob/living/carbon/setFireLoss(amount, updating_health = TRUE, forced = FALSE, required_bodytype)
	var/current = getFireLoss()
	var/diff = amount - current
	if(!diff)
		return
	adjustFireLoss(diff, updating_health, forced, required_bodytype)

/mob/living/carbon/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE, required_status)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	if(amount > 0)
		if(getFireLoss() >= 800)
			return //we are already capped no point
		take_overall_damage(0, amount, updating_health, required_status)
	else
		heal_overall_damage(0, abs(amount), required_status ? required_status : BODYPART_ORGANIC, updating_health)
	return amount

/mob/living/carbon/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && HAS_TRAIT(src, TRAIT_TOXINLOVER)) //damage becomes healing and healing becomes damage
		amount = -amount
		if(amount > 0)
			blood_volume -= 5*amount
		else
			blood_volume -= amount
	if(HAS_TRAIT(src, TRAIT_TOXIMMUNE)) //Prevents toxin damage, but not healing
		amount = min(amount, 0)
	return ..()


/** adjustOrganLoss
 * inputs: slot (organ slot, like ORGAN_SLOT_HEART), amount (damage to be done), and maximum (currently an arbitrarily large number, can be set so as to limit damage)
 * outputs:
 * description: If an organ exists in the slot requested, and we are capable of taking damage (we don't have GODMODE on), call the damage proc on that organ.
 */
/mob/living/carbon/adjustOrganLoss(slot, amount, maximum)
	var/obj/item/organ/O = getorganslot(slot)
	if(O && !(status_flags & GODMODE))
		O.applyOrganDamage(amount, maximum)

/** setOrganLoss
 * inputs: slot (organ slot, like ORGAN_SLOT_HEART), amount(damage to be set to)
 * outputs:
 * description: If an organ exists in the slot requested, and we are capable of taking damage (we don't have GODMODE on), call the set damage proc on that organ, which can
 *				 set or clear the failing variable on that organ, making it either cease or start functions again, unlike adjustOrganLoss.
 */
/mob/living/carbon/setOrganLoss(slot, amount)
	var/obj/item/organ/O = getorganslot(slot)
	if(O && !(status_flags & GODMODE))
		O.setOrganDamage(amount)

/** getOrganLoss
 * inputs: slot (organ slot, like ORGAN_SLOT_HEART)
 * outputs: organ damage
 * description: If an organ exists in the slot requested, return the amount of damage that organ has
 */
/mob/living/carbon/getOrganLoss(slot)
	var/obj/item/organ/O = getorganslot(slot)
	if(O)
		return O.damage

/mob/living/carbon/getPainLoss()
	var/amount = 0
	for(var/X in bodyparts)
		var/obj/item/bodypart/bodypart = X
		amount += bodypart.pain_dam * bodypart.pain_damage_coeff
	return amount

/mob/living/carbon/adjustPainLoss(amount, updating_health = TRUE, forced = FALSE, required_status = null)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	var/old_amount = amount
	var/list/obj/item/bodypart/parts
	if(amount > 0)
		parts = get_painable_bodyparts()
	else
		parts = get_pained_bodyparts()
	var/update = FALSE
	while(parts.len && amount)
		var/obj/item/bodypart/picked = pick(parts)
		var/pain_per_part
		if(amount < 0)
			pain_per_part = FLOOR(amount/parts.len, DAMAGE_PRECISION)
		else
			pain_per_part = CEILING(amount/parts.len, DAMAGE_PRECISION)

		var/pain_was = picked.pain_dam
		if(amount < 0)
			update |= picked.remove_pain(abs(pain_per_part))
		else
			update |= picked.add_pain(abs(pain_per_part))

		if(pain_per_part < 0)
			pain_per_part = FLOOR(amount - (picked.pain_dam - pain_was), DAMAGE_PRECISION)
		else
			pain_per_part = CEILING(amount - (picked.pain_dam - pain_was), DAMAGE_PRECISION)

		parts -= picked
	if(updating_health)
		updatehealth()
	if(update)
		update_damage_overlays()
	return old_amount

/mob/living/carbon/setPainLoss(amount, updating_health = TRUE, forced = FALSE)
	var/current = getPainLoss()
	var/diff = amount - current
	if(!diff)
		return
	adjustPainLoss(diff, updating_health, forced)

/mob/living/carbon/proc/InShock()
	return (shock_stage >= SHOCK_STAGE_4)

/mob/living/carbon/proc/InFullShock()
	return (shock_stage >= SHOCK_STAGE_6)

/mob/living/carbon/proc/get_painable_bodyparts(status)
	var/list/obj/item/bodypart/parts = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(status && (BP.status != status))
			continue
		if(BP.pain_dam < BP.max_pain_damage)
			parts += BP
	return parts

/mob/living/carbon/proc/get_pained_bodyparts(status)
	var/list/obj/item/bodypart/parts = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(status && (BP.status != status))
			continue
		if(BP.pain_dam)
			parts += BP
	return parts

/mob/living/carbon/proc/endorphinate(forced = FALSE, silent = FALSE, local_sound = TRUE, flash = TRUE, special_sound)
	var/endurance = GET_MOB_ATTRIBUTE_VALUE(src, STAT_ENDURANCE)
	if(!forced && (TIMER_COOLDOWN_CHECK(src, COOLDOWN_CARBON_ENDORPHINATION) || (diceroll(endurance, context = DICE_CONTEXT_MENTAL) <= DICE_FAILURE)))
		return

	var/endorphin_amount = clamp(endurance, 5, 29)
	reagents?.add_reagent(/datum/reagent/medicine/endorphin, endorphin_amount)
	TIMER_COOLDOWN_START(src, COOLDOWN_CARBON_ENDORPHINATION, ENDORPHINATION_COOLDOWN_DURATION)
	if(!silent)
		var/final_sound = special_sound || 'sound/heart/combatcocktail.ogg'
		if(local_sound)
			playsound_local(src, final_sound, 80, FALSE)
		else
			playsound(src, final_sound, 80, FALSE)


/**
 * Adds pain onto a limb while giving the player a message styled depending on the powerf of the pain added.
 *
 * Arguments:
 * * Message is the custom message to be displayed
 * * Power decides how much painkillers will stop the message, as well as how much pain it causes
 * * Forced means it ignores anti-spam timer
 */
/mob/living/carbon/custom_pain(message, power, forced, obj/item/bodypart/affecting, nopainloss = FALSE, pain_emote = TRUE)
	if((stat >= UNCONSCIOUS) || !can_feel_pain() || (world.time < next_pain_time))
		return FALSE

	if(affecting && !affecting.can_feel_pain())
		return FALSE

	// Take the edge off
	power -= get_chem_effect(CE_PAINKILLER)
	if(power <= 0)
		return FALSE

	// Share the pain
	if(!nopainloss && power)
		if(affecting)
			affecting.add_pain(CEILING(power, 1))
		else
			adjustPainLoss(CEILING(power, 1))

	// Anti message spam checks
	if(forced || (message != last_pain_message) || (world.time >= next_pain_message_time))
		last_pain_message = message
		if(world.time >= next_pain_message_time)
			to_chat(src, span_animatedpain("[message]"))

		if(pain_emote)
			var/force_emote
			if(ishuman(src))
				var/mob/living/carbon/human/human_src = src
				if(human_src.dna?.species)
					force_emote = human_src.dna.species.get_pain_emote(power)
			if(force_emote && prob(power))
				INVOKE_ASYNC(src, PROC_REF(emote), force_emote)

	// Briefly flash the pain overlay
	//flash_pain(power)
	next_pain_time = world.time + (rand(100, 150) + power)
	next_pain_message_time = world.time + (60 SECONDS + power)
	return TRUE

/mob/living/carbon/can_feel_pain()
	return !HAS_TRAIT(src, TRAIT_NOPAIN)

/mob/living/carbon/getShock(painkiller_included = TRUE)
	if(!can_feel_pain())
		return 0

	var/shock = 0
	shock += SHOCK_MOD_CLONE * getCloneLoss()
	for(var/X in bodyparts)
		var/obj/item/bodypart/bodypart = X
		shock += bodypart.get_shock(FALSE, TRUE)

	if(painkiller_included)
		shock = max(0, shock - get_chem_effect(CE_PAINKILLER))

	return max(0, shock)

////////////////////////////////////////////

//Returns a list of damaged bodyparts
/mob/living/carbon/proc/get_damaged_bodyparts(brute = FALSE, burn = FALSE, status)
	var/list/obj/item/bodypart/parts = list()
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(status && (BP.status != status))
			continue
		if((brute && BP.brute_dam) || (burn && BP.burn_dam) || length(BP.wounds))
			parts += BP
	return parts

//Returns a list of damageable bodyparts
/mob/living/carbon/proc/get_damageable_bodyparts(status)
	var/list/obj/item/bodypart/parts = list()
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(status && (BP.status != status))
			continue
		if(BP.brute_dam + BP.burn_dam < BP.max_damage)
			parts += BP
	return parts

//Heals ONE bodypart randomly selected from damaged ones.
//It automatically updates damage overlays if necessary
//It automatically updates health status
/mob/living/carbon/heal_bodypart_damage(brute = 0, burn = 0, updating_health = TRUE, required_status)
	var/list/obj/item/bodypart/parts = get_damaged_bodyparts(brute, burn, required_status)
	if(!parts.len)
		return
	var/obj/item/bodypart/picked = pick(parts)
	if(picked.heal_damage(brute, burn, required_status))
		update_damage_overlays()

//Damages ONE bodypart randomly selected from damagable ones.
//It automatically updates damage overlays if necessary
//It automatically updates health status
/mob/living/carbon/take_bodypart_damage(brute = 0, burn = 0, updating_health = TRUE, required_status, check_armor = FALSE)
	var/list/obj/item/bodypart/parts = get_damageable_bodyparts(required_status)
	if(!length(parts))
		return

	var/obj/item/bodypart/picked = pick(parts)
	if(picked.receive_damage(brute, burn,check_armor ? run_armor_check(picked, (brute ? "blunt" : burn ? "fire" :  null)) : FALSE))
		update_damage_overlays()

//Heal MANY bodyparts, in random order
/mob/living/carbon/heal_overall_damage(brute = 0, burn = 0, required_status, updating_health = TRUE, true_heal = FALSE)
	. = FALSE

	var/list/obj/item/bodypart/parts = get_damaged_bodyparts(brute, burn, required_status)
	var/update = NONE
	while(length(parts) && (brute > 0 || burn > 0))
		var/obj/item/bodypart/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam
		. += picked.get_damage()

		update |= picked.heal_damage(brute, burn, required_status, FALSE, true_heal)

		. -= picked.get_damage() // return the net amount of damage healed

		brute = round(brute - (brute_was - picked.brute_dam), DAMAGE_PRECISION)
		burn = round(burn - (burn_was - picked.burn_dam), DAMAGE_PRECISION)

		parts -= picked

	if(!.) // no change? no need to update anything
		return

	if(updating_health)
		updatehealth()

	if(update)
		update_damage_overlays()

// damage MANY bodyparts, in random order
/mob/living/carbon/take_overall_damage(brute = 0, burn = 0, updating_health = TRUE, required_status = BODYPART_ORGANIC, damage_type, no_crit = FALSE)
	. = FALSE
	if(status_flags & GODMODE)
		return	//godmode

	// treat negative args as positive
	brute = abs(brute)
	burn = abs(burn)

	var/list/obj/item/bodypart/parts = get_damageable_bodyparts(required_status)
	var/update = NONE
	while(length(parts) && (brute > 0 || burn > 0))
		var/obj/item/bodypart/picked = pick(parts)
		var/brute_per_part = rand(0, brute)
		var/burn_per_part = rand(0, burn)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam
		. += picked.get_damage()

		if(!burn && !damage_type)
			stack_trace("Carbon has taken damage without a tied damage class! Defaulting to Internal Bruising.")
			damage_type = WOUND_INTERNAL_BRUISE

		if(damage_type || burn)
			if(burn)
				damage_type = BCLASS_BURN
			update = TRUE
			var/list/mods = list()
			if(no_crit)
				mods = list(CRIT_MOD_CHANCE = -100)
			picked.bodypart_attacked_by(damage_type, brute + burn, null, modifiers = mods)
		else
			update |= picked.receive_damage(brute_per_part, burn_per_part, blocked = FALSE, updating_health = FALSE, required_status = BODYPART_ORGANIC)

		. -= picked.get_damage() // return the net amount of damage healed

		brute = round(brute - (picked.brute_dam - brute_was), DAMAGE_PRECISION)
		burn = round(burn - (picked.burn_dam - burn_was), DAMAGE_PRECISION)

		parts -= picked

	if(!.) // no change? no need to update anything
		return

	if(updating_health)
		updatehealth(brute + burn)

	if(update)
		update_damage_overlays()
