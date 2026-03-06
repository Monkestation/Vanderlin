/datum/rmb_intent
	var/name = "intent"
	var/desc = ""
	var/icon_state = ""
	var/def_bonus = 0
	/// Whether the rclick will try to get turfs as target.
	var/target_turf = FALSE
	/// Needs the user to be Adjacent to the target or be in weapon range
	var/check_range = TRUE

/datum/rmb_intent/proc/get_target(atom/initial_target)
	if(target_turf)
		return get_turf(initial_target)

	if(ismob(initial_target))
		return initial_target

	for(var/mob/living/potential in get_turf(initial_target))
		return potential

/**
 * A special attack for this intent
 *
 * return TRUE to cancel the attack chain, FALSE to attack normally.
 */
/datum/rmb_intent/proc/special_attack(mob/living/user, atom/target)
	if(!user || !target)
		return FALSE

	if(check_range)
		var/obj/item/attacker_item = user.get_active_held_item()
		if(!attacker_item && !user.Adjacent(target))
			return FALSE

		var/range = (user.used_intent?.reach || 1)
		if(get_dist(user, target) > range)
			return FALSE

	return TRUE

/datum/rmb_intent/aimed
	name = "aimed"
	desc = "Your attacks are more precise but have a longer recovery time. Higher chance for certain critical hits. Reduced dodge bonus."
	icon_state = "rmbaimed"
	def_bonus = -20

/datum/rmb_intent/aimed/special_attack(mob/living/user, atom/target)
	. = ..()
	if(!.)
		return

	if(user == target)
		return FALSE

	if(user.incapacitated(IGNORE_GRAB))
		return FALSE

	if(user.has_status_effect(/datum/status_effect/debuff/baitcd))
		return FALSE

	var/mob/living/carbon/human/defender = get_target(target)
	if(!istype(defender))
		return FALSE

	// See effect for more info and effects
	var/datum/status_effect/stacking/baited/baited = defender.has_status_effect(/datum/status_effect/stacking/baited)
	if(baited && !COOLDOWN_FINISHED(baited, bait_cooldown))
		return FALSE

	// if(defender.is_blind() || !defender.can_see_cone(user))
	// 	to_chat(user, span_notice("[defender.p_they()] didn't see me! Nothing happened!"))
	// 	user.apply_status_effect(/datum/status_effect/debuff/baitcd, 5 SECONDS)
	// 	return TRUE

	user.visible_message(
		span_danger("[user] baits an attack from [defender]."),
		span_notice("I bait an attack from [defender].")
	)
	user.apply_status_effect(/datum/status_effect/debuff/baitcd, BAIT_COOLDOWN_TIME)

	var/defender_zone = defender.zone_selected
	var/attacker_zone = user.zone_selected

	if(defender_zone != attacker_zone || defender_zone == BODY_ZONE_CHEST || attacker_zone == BODY_ZONE_CHEST)
		if(!check_face_subzone(defender_zone) && !check_face_subzone(attacker_zone))	//We simplify the myriad of face targeting zones
			to_chat(user, span_danger("It didn't work! [defender.p_their(TRUE)] footing returned!"))
			to_chat(defender, span_notice("I fooled [user.p_them()]! I've regained my footing!"))
			user.emote("groan")
			user.adjust_stamina(user.maximum_stamina * 0.2)
			defender.remove_status_effect(/datum/status_effect/stacking/baited)
			return TRUE

	defender.apply_status_effect(/datum/status_effect/debuff/exposed)
	defender.apply_status_effect(/datum/status_effect/debuff/clickcd, 5 SECONDS)

	user.changeNext_move(CLICK_CD_RAPID)

	if(!baited)
		to_chat(user, span_notice("[defender.p_they(TRUE)] fell for my bait <b>perfectly</b>! One more!"))
		to_chat(defender, span_danger("I fall for [user.p_their()]'s bait <b>perfectly</b>! I'm losing my footing! <b>I can't let this happen again!</b>"))
	else
		to_chat(user, span_notice("[defender.p_they(TRUE)] fell for it again and is off-balanced! NOW!"))
		to_chat(defender, span_danger("I fall for [user.p_their()] bait <b>perfectly</b>! My balance is GONE!</b>"))

	defender.apply_status_effect(/datum/status_effect/stacking/baited, null, 1)

	if(!defender.pulling)
		return TRUE

	defender.stop_pulling()
	to_chat(user, span_notice("[defender.p_they(TRUE)] fell for my dirty trick! I am loose!"))
	to_chat(defender, span_danger("I fall for [user.p_their()] dirty trick! My hold is broken!"))
	user.OffBalance(2 SECONDS)
	defender.OffBalance(2 SECONDS)

	playsound(user, 'sound/combat/riposte.ogg', 100, TRUE)

	return TRUE

/datum/rmb_intent/strong
	name = "strong"
	desc = "Your attacks have increased strength and have increased force but use more stamina. Higher chance for certain critical hits. Intentionally fails surgery steps. Reduced dodge bonus."
	icon_state = "rmbstrong"
	def_bonus = -20
	target_turf = TRUE
	check_range = FALSE // specials have their own range checks

/datum/rmb_intent/strong/special_attack(mob/living/user, atom/target)
	. = ..()
	if(!.)
		return

	if(user.incapacitated(IGNORE_GRAB))
		return FALSE

	if(user.has_status_effect(/datum/status_effect/debuff/specialcd))
		return FALSE

	var/turf/T = get_target(target)
	if(!istype(T))
		return FALSE

	var/obj/item/weapon/held_weapon = user.get_active_held_item()

	if(!istype(held_weapon) || !held_weapon.weapon_special)
		return FALSE

	var/datum/special_intent/special = held_weapon.weapon_special

	if(!special.deploy(user, held_weapon, target))
		return FALSE // Invalid starting args somehow

	special.apply_cost(user)

	user.changeNext_move(CLICK_CD_MELEE)

	return TRUE

/datum/rmb_intent/swift
	name = "swift"
	desc = "Your attacks have less recovery time but are less accurate and have reduced strength."
	icon_state = "rmbswift"

/datum/rmb_intent/feint
	name = "feint"
	desc = "(RMB WHILE IN COMBAT MODE) A deceptive half-attack with no follow-through, meant to force your opponent to open their guard.."
	icon_state = "rmbfeint"
	def_bonus = 10
	/// Duration of the feint expose / vulnerable effect
	var/feint_duration = 7.5 SECONDS

/datum/rmb_intent/feint/special_attack(mob/living/user, atom/target)
	. = ..()
	if(!.)
		return

	if(user == target)
		return FALSE

	if(user.incapacitated(IGNORE_GRAB))
		return FALSE

	if(user.has_status_effect(/datum/status_effect/debuff/feintcd))
		return FALSE

	var/mob/living/defender = get_target(target)
	if(!istype(defender))
		return FALSE

	var/obj/item/attacker_item = user.get_active_held_item()
	if(!attacker_item && !user.Adjacent(target))
		return FALSE

	if(get_dist(user, target) > user.used_intent?.reach)
		return FALSE

	user.visible_message(
		span_danger("[user] feints an attack at [defender]!"),
		span_userdanger("I feint an attack at [defender]!"),
	)

	var/perc = 50
	var/ourskill = 0
	var/theirskill = 0
	var/skill_factor = 0

	if(attacker_item?.associated_skill)
		ourskill = user.get_skill_level(attacker_item.associated_skill)

	var/obj/item/defender_item = defender.get_active_held_item()
	if(defender_item?.associated_skill)
		theirskill = defender.get_skill_level(defender_item.associated_skill)

	perc += (ourskill - theirskill) * 12 //skill is of the essence
	perc += (user.STAINT - defender.STAINT) * 8 //but it's also mostly a mindgame
	perc += (user.STASPD - defender.STASPD) * 3 //yet a speedy feint is hard to counter
	perc += (user.STAPER - defender.STAPER) * 3 //a good eye helps

	skill_factor = (ourskill - theirskill) / 2

	var/special_message
	var/cooldown_override = 20 SECONDS

	if(defender.has_status_effect(/datum/status_effect/debuff/exposed) || \
		defender.has_status_effect(/datum/status_effect/debuff/vulnerable))
		perc = 0

	if(defender.is_blind() || !defender.can_see_cone(user))
		perc = 0
		cooldown_override = 5 SECONDS
		special_message = span_warning("They need to see me for me to feint them!")

	perc = CLAMP(perc, 0, 90)

	if(!prob(perc))
		playsound(user, 'sound/combat/feint.ogg', 100, TRUE)
		if(user.client?.prefs.showrolls)
			to_chat(user, span_warning("[defender.p_they(TRUE)] did not fall for my feint... [perc]%"))
		user.apply_status_effect(/datum/status_effect/debuff/feintcd)
		if(special_message)
			to_chat(user, special_message)
		return TRUE

	if(defender.has_status_effect(/datum/status_effect/buff/clash))
		defender.remove_status_effect(/datum/status_effect/buff/clash)
		defender.balloon_alert(user, "guard interrupted!")

	var/effect_to_apply = defender.mind ? /datum/status_effect/debuff/vulnerable : /datum/status_effect/debuff/exposed

	defender.apply_status_effect(effect_to_apply, feint_duration)
	defender.apply_status_effect(/datum/status_effect/debuff/clickcd, max(1.5 SECONDS + skill_factor, 2.5 SECONDS))
	defender.Immobilize(0.5 SECONDS)
	defender.adjust_stamina(defender.stamina * 0.1)
	defender.Slowdown(2)

	user.changeNext_move(CLICK_CD_FAST)	//We don't want the feint effect to be popped instantly.
	user.apply_status_effect(/datum/status_effect/debuff/feintcd, cooldown_override)

	to_chat(user, span_notice("[defender.p_they(TRUE)] fell for my feint attack!"))
	to_chat(defender, span_danger("I fall for [user.p_their()] feint attack!"))
	playsound(user, 'sound/combat/riposte.ogg', 100, TRUE)

	return TRUE

/datum/rmb_intent/riposte
	name = "defend"
	desc = "No delay between dodge and parry rolls."
	icon_state = "rmbdef"
	def_bonus = 10

/datum/rmb_intent/riposte/special_attack(mob/living/user, atom/target)
	. = ..()
	if(!.)
		return

	if(user.has_status_effect(/datum/status_effect/buff/clash))
		return FALSE

	if(user.has_status_effect(/datum/status_effect/debuff/clashcd))
		return FALSE

	if(!user.get_active_held_item()) //Nothing in our hand to Guard with.
		return FALSE

	if(user.incapacitated()) //Not usable while grabs are in play.
		return FALSE

	if(user.IsImmobilized() || user.IsOffBalanced()) //Not usable while we're offbalanced or immobilized
		return FALSE

	if(user.m_intent == MOVE_INTENT_RUN)
		to_chat(user, span_warning("I can't focus on this while running."))
		return FALSE

	user.apply_status_effect(/datum/status_effect/buff/clash)

	return TRUE

/datum/rmb_intent/guard
	name = "guarde"
	desc = "(RMB WHILE DEFENSE IS ACTIVE) Raise your weapon, ready to attack any creature who moves onto the space you are guarding."
	icon_state = "rmbguard"

/datum/rmb_intent/weak
	name = "weak"
	desc = "Your attacks have halved strength and will never critically-hit. Surgery steps can only be done with this intent. Useful for longer punishments, play-fighting, and bloodletting."
	icon_state = "rmbweak"
