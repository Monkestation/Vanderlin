/mob/living/proc/checkmiss(mob/living/user)
	if(user == src)
		return FALSE
	if(stat)
		return FALSE
	if(body_position == LYING_DOWN)
		return FALSE
	if(user.stat_roll(STATKEY_LCK,4,10,TRUE))
		var/list/usedp = list("Critical miss!", "Damn! Critical miss!", "No! Critical miss!", "It can't be! Critical miss!", "Betrayed by lady luck! Critical miss!", "Bad luck! Critical miss!", "Curse creation! Critical miss!", "What?! Critical miss!")
		to_chat(user, "<span class='boldwarning'>[pick(usedp)]</span>")
		flash_fullscreen("blackflash2")
		user.aftermiss()
		return TRUE

/**
 * Determines the hit zone when attacking
 * @param zone The targeted zone
 * @param mob/living/user The attacker
 * @param mob/living/target The target
 * @param associated_skill The skill being used for the attack
 * @param datum/intent/used_intent The intent used for the attack
 * @param obj/item/I The item used for the attack
 * @return The zone that was hit (potentially different from the targeted zone)
 */
/proc/accuracy_check(zone, mob/living/user, mob/living/target, associated_skill, datum/intent/used_intent, obj/item/I)
	if(!zone || user == target || zone == BODY_ZONE_CHEST || (target.grabbedby == user && user.grab_state >= GRAB_AGGRESSIVE) ||  target.body_position == LYING_DOWN || (target.dir == turn(get_dir(target, user), 180)))
		return zone

	var/chance2hit = calculate_hit_chance(zone, user, target, associated_skill, used_intent, I)
	if(prob(chance2hit))
		return zone

	if(prob(chance2hit + 5))
		if(check_zone(zone) == zone)
			return zone

		if(user.client?.prefs.showrolls)
			to_chat(user, "<span class='warning'>Accuracy fail! [chance2hit]%</span>")
		return check_zone(zone)

	if(user.client?.prefs.showrolls)
		to_chat(user, "<span class='warning'>Ultra accuracy fail! [chance2hit]%</span>")
	return BODY_ZONE_CHEST

/**
 * Calculate hit chance for accuracy check
 * @param zone The targeted zone
 * @param mob/living/user The attacker
 * @param mob/living/target The target
 * @param associated_skill The skill being used for the attack
 * @param datum/intent/used_intent The intent used for the attack
 * @param obj/item/I The item used for the attack
 * @return Hit chance percentage
 */
/proc/calculate_hit_chance(zone, mob/living/user, mob/living/target, associated_skill, datum/intent/used_intent, obj/item/I)
	var/chance2hit = 0

	if(check_zone(zone) == zone)
		chance2hit += 10

	if(user.mind)
		chance2hit += (user.get_skill_level(associated_skill, TRUE) * 5)

	if(used_intent)
		if(used_intent.blade_class == BCLASS_STAB)
			chance2hit += 20
		else if(used_intent.blade_class == BCLASS_CUT)
			chance2hit += 12

	if(I && I.wlength == WLENGTH_SHORT)
		chance2hit += 10

	if(user.STAPER > 10)
		chance2hit += ((user.STAPER - 10) * 3)
	else if(user.STAPER < 10)
		chance2hit -= ((10 - user.STAPER) * 3)

	if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
		chance2hit += 20
	else if(istype(user.rmb_intent, /datum/rmb_intent/swift))
		chance2hit -= 40

	return CLAMP(chance2hit, 5, 99)
