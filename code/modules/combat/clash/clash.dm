// File for clashing procs see [/datum/status_effect/buff/clash]

/// Clash with the attacker, either resulting in a disarm, a riposte or a strike
/mob/living/proc/process_clash(mob/living/user)
	if(user == src)
		return

	var/obj/item/our_item = get_active_held_item()
	var/obj/item/their_item = user.get_active_held_item()

	if(!their_item)	//The opponent is trying to rawdog us with their bare hands while we have Guard up. We get a free attack on their active hand.
		var/obj/item/bodypart/affecting = user.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
		var/force = get_complex_damage(our_item, src)
		var/armor_block = user.run_armor_check(BODY_ZONE_PRECISE_L_HAND, used_intent.item_damage_type, armor_penetration = used_intent.penfactor, damage = force)
		if(user.apply_damage(force, our_item.damtype, affecting, armor_block))
			visible_message(span_suicide("[src] gores [user]'s hands with \the [our_item]!"))
			affecting?.bodypart_attacked_by(used_intent.blade_class, force, crit_message = TRUE)
		else
			visible_message(span_suicide("[src] clashes into [user]'s hands with \the [our_item]!"))

		playsound(src, pick(used_intent.hitsound), 80)
		remove_status_effect(/datum/status_effect/buff/clash)
		return

	if(user.has_status_effect(/datum/status_effect/buff/clash))
		clash(user, our_item, their_item)
		return

	var/damage = get_complex_damage(our_item, src, their_item.blade_dulling)
	if(our_item.wbalance < 0)
		damage *= 1.5

	their_item.take_damage(max(damage, 1), BRUTE, our_item.damage_type)
	visible_message(span_suicide("[src] ripostes [user] with \the [our_item]!"))
	span_notice("[capitalize(user.p_theyre())] exposed!")
	playsound(src, 'sound/combat/clash_struck.ogg', 100)

	user.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
	user.apply_status_effect(/datum/status_effect/debuff/clickcd, 3 SECONDS)

	remove_status_effect(/datum/status_effect/buff/clash)

/// Decide who gets disarmed if both combants have clash enabled
/mob/living/proc/clash(mob/living/user, obj/item/our_item, obj/item/their_item)
	var/instantloss = FALSE
	var/instantwin = FALSE

	//Stat checks. Basic comparison.
	var/strdiff = GET_MOB_ATTRIBUTE_VALUE(src, STAT_STRENGTH) - GET_MOB_ATTRIBUTE_VALUE(user, STAT_STRENGTH)
	var/perdiff = GET_MOB_ATTRIBUTE_VALUE(src, STAT_PERCEPTION) - GET_MOB_ATTRIBUTE_VALUE(user, STAT_PERCEPTION)
	var/spddiff = GET_MOB_ATTRIBUTE_VALUE(src, STAT_SPEED) - GET_MOB_ATTRIBUTE_VALUE(user, STAT_SPEED)
	var/fordiff = GET_MOB_ATTRIBUTE_VALUE(src, STAT_FORTUNE) - GET_MOB_ATTRIBUTE_VALUE(user, STAT_FORTUNE)
	var/intdiff = GET_MOB_ATTRIBUTE_VALUE(src, STAT_INTELLIGENCE) - GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)

	var/list/statdiffs = list(strdiff, perdiff, spddiff, fordiff, intdiff)

	//Skill check, very simple. If you're more skilled with your weapon than the opponent is with theirs -> +10% to disarm or vice-versa.
	var/skilldiff
	if(our_item.associated_skill)
		skilldiff = GET_MOB_SKILL_VALUE_OLD(src, our_item.associated_skill)
	else
		instantloss = TRUE	//We are Guarding with a book or something -- no chance for us.

	if(their_item.associated_skill)
		skilldiff = skilldiff - GET_MOB_SKILL_VALUE_OLD(user, their_item.associated_skill)
	else
		instantwin = TRUE	//THEY are Guarding with a book or something -- no chance for them.

	//Weapon checks.
	var/lengthdiff = our_item.wlength - their_item.wlength //The longer the weapon the better.
	var/wieldeddiff = our_item.is_wielded() - their_item.is_wielded() //If ours is wielded but theirs is not.
	var/weightdiff = our_item.wbalance < their_item.wbalance //If our weapon is heavy-balanced and theirs is not.
	var/wildcard = rand(-1, 1)

	var/list/wepdiffs = list(lengthdiff, wieldeddiff, weightdiff)

	var/prob_us = 0
	var/prob_opp = 0

	//Stat checks only matter if their difference is 2 or more.
	for(var/statdiff in statdiffs)
		if(statdiff >= 2)
			prob_us += 10
		else if(statdiff <= -2)
			prob_opp += 10

	for(var/wepdiff in wepdiffs)
		if(wepdiff > 0)
			prob_us += 10
		else if(wepdiff < 0)
			prob_opp += 10

	//Wildcard modifier that can go either way or to neither.
	if(wildcard > 0)
		prob_us += 10
	else if(wildcard < 0 )
		prob_opp += 10

	//Small bonus to the first one to strike in a Clash.
	var/initiator_bonus = rand(5, 10)
	prob_us += initiator_bonus

	if((!instantloss && !instantwin) || (instantloss && instantwin))	//We are both using normal weapons OR we're both using memes. Either way, proceed as normal.
		visible_message(span_boldwarning("[src] and [user] clash!"))
		flash_fullscreen("whiteflash")
		user.flash_fullscreen("whiteflash")
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_step(src,src.dir)
		S.set_up(1, 1, front)
		S.start()
		var/success
		if(prob(prob_us))
			user.show_overhead_indicator('icons/mob/overhead_effects.dmi', "clashtwo", 1 SECONDS, y_offset = 24, sound = 'sound/combat/clash_disarm_us.ogg')
			disarm_weapon()
			Slowdown(5)
			success = TRUE
		if(prob(prob_opp))
			user.disarm_weapon()
			user.Slowdown(5)
			show_overhead_indicator('icons/mob/overhead_effects.dmi', "clashtwo", 1 SECONDS, y_offset = 24, sound = 'sound/combat/clash_disarm_opp.ogg')
			success = TRUE
		if(!success)
			to_chat(src, span_warningbig("Draw! Opponent's chances were... [prob_opp]%"))
			to_chat(user, span_warningbig("Draw! Opponent's chances were... [prob_us]%"))
			playsound(src, 'sound/combat/clash_draw.ogg', 100, TRUE)
	else if(instantloss)
		disarm_weapon()
	else if(instantwin)
		user.disarm_weapon()

	remove_status_effect(/datum/status_effect/buff/clash)
	user.remove_status_effect(/datum/status_effect/buff/clash)

/// Proc that will try to throw the src's held I and throw it 2 - 4 tiles to their side.
/mob/living/proc/disarm_weapon()
	var/obj/item/disarmed = get_active_held_item()
	if(!disarmed)
		return

	if(!canUnEquip(disarmed))
		return

	visible_message(
		span_suicide("[src] is disarmed!"),
		span_boldwarning("I'm disarmed!"),
	)

	var/turnangle = (prob(50) ? 270 : 90)
	var/turndir = turn(dir, turnangle)
	var/dist = rand(2, 4)
	var/current_turf = get_turf(src)
	var/target_turf = get_ranged_target_turf(current_turf, turndir, dist)

	throw_item(target_turf, FALSE)
	apply_status_effect(/datum/status_effect/debuff/clickcd, 3 SECONDS)

///Proc that cancels Riposte with a small stamina penalty, unless it's an extreme case.
/mob/living/proc/bad_guard(message, custom_value, cheesy = FALSE)
	adjust_stamina(((maximum_stamina * (custom_value ? custom_value : 20)) / 100))
	if(cheesy)	//We tried to hit someone with Riposte (Not Limb Guard) up. Unfortunately this must be super punishing to prevent cheese.
		adjust_energy(-((max_energy * (custom_value ? custom_value : 20)) / 100))
		Immobilize(2 SECONDS)
	if(message)
		to_chat(src, message)
		INVOKE_ASYNC(src, PROC_REF(emote), "strain", forced = TRUE)
	remove_status_effect(/datum/status_effect/buff/clash)
	// remove_status_effect(/datum/status_effect/buff/clash/limbguard)

/mob/living/carbon/human/species/human/northern/clasher/Initialize()
	. = ..()
	put_in_hands(new /obj/item/weapon/sword/sabre)
	apply_status_effect(/datum/status_effect/buff/clash, 1 HOURS)
