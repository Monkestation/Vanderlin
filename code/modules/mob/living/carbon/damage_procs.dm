
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


/mob/living/carbon/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE)
	SEND_SIGNAL(src, COMSIG_MOB_APPLY_DAMGE, damage, damagetype, def_zone)
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

/mob/living/carbon/setBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_bodytype)
	var/current = getBruteLoss()
	var/diff = amount - current
	if(!diff)
		return
	adjustBruteLoss(diff, updating_health, forced, required_bodytype)

/mob/living/carbon/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_status)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	if(amount > 0)
		take_overall_damage(amount, 0, updating_health, required_status)
	else
		heal_overall_damage(abs(amount), 0, required_status ? required_status : BODYPART_ORGANIC, updating_health)
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
/mob/living/carbon/heal_overall_damage(brute = 0, burn = 0, required_status, updating_health = TRUE)
	. = FALSE

	var/list/obj/item/bodypart/parts = get_damaged_bodyparts(brute, burn, required_status)
	var/update = NONE
	while(length(parts) && (brute > 0 || burn > 0))
		var/obj/item/bodypart/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam
		. += picked.get_damage()

		update |= picked.heal_damage(brute, burn, required_status, FALSE)

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
/mob/living/carbon/take_overall_damage(brute = 0, burn = 0, updating_health = TRUE, required_status = BODYPART_ORGANIC)
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
