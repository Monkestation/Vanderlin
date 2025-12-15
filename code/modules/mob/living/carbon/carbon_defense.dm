/mob/living/carbon/get_eye_protection()
	. = ..()
	var/obj/item/organ/eyes/E = getorganslot(ORGAN_SLOT_EYES)
	if(!E)
		return INFINITY //Can't get flashed without eyes
	else
		. += E.flash_protect
	if(isclothing(head)) //Adds head protection
		. += head.flash_protect
	if(isclothing(wear_mask)) //Mask
		. += wear_mask.flash_protect

/mob/living/carbon/get_ear_protection()
	. = ..()
	var/obj/item/organ/ears/E = getorganslot(ORGAN_SLOT_EARS)
	if(!E)
		return INFINITY
	else
		. += E.bang_protect

/mob/living/carbon/is_mouth_covered(head_only = 0, mask_only = 0)
	if( (!mask_only && head && (head.flags_cover & HEADCOVERSMOUTH)) || (!head_only && wear_mask && (wear_mask.flags_cover & MASKCOVERSMOUTH)) )
		return TRUE

/mob/living/carbon/is_eyes_covered(check_glasses = TRUE, check_head = TRUE, check_mask = TRUE)
	if(check_head && head && (head.flags_cover & HEADCOVERSEYES))
		return head
	if(check_mask && wear_mask && (wear_mask.flags_cover & MASKCOVERSEYES))
		return wear_mask
/mob/living/carbon/is_pepper_proof(check_head = TRUE, check_mask = TRUE)
	if(check_head &&(head?.flags_cover & PEPPERPROOF))
		return head
	if(check_mask &&(wear_mask?.flags_cover & PEPPERPROOF))
		return wear_mask

/mob/living/carbon/check_projectile_dismemberment(obj/projectile/P, def_zone)
	var/obj/item/bodypart/affecting = get_bodypart(check_zone(def_zone))
	if(affecting && affecting.dismemberable && affecting.get_damage() >= (affecting.max_damage - P.dismemberment))
		affecting.dismember(P.damtype, P.woundclass)

/mob/living/carbon/proc/can_catch_item(skip_throw_mode_check)
	. = FALSE
	if(!skip_throw_mode_check && !in_throw_mode)
		return
	if(get_active_held_item())
		return
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	return TRUE

/mob/living/carbon/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum, damage_type = "blunt")
	if(!skipcatch)	//ugly, but easy
		if(can_catch_item())
			if(istype(AM, /obj/item))
				if(!istype(AM, /obj/item/net))
					var/obj/item/I = AM
					if(isturf(I.loc))
						I.attack_hand(src)
						if(get_active_held_item() == I) //if our attack_hand() picks up the item...
							visible_message("<span class='warning'>[src] catches [I]!</span>", \
											"<span class='danger'>I catch [I] in mid-air!</span>")
							throw_mode_off()
							return 1
				else
					var/obj/item/net/N
					visible_message("<span class='warning'>[src] tries to catch \the [N] but gets snared by it!</span>", \
									"<span class='danger'>Why did I even try to do this...?</span>") // Hahaha dumbass!!!
					throw_mode_off()
					N.ensnare(src)
					return
	..()


/mob/living/carbon/check_projectile_wounding(obj/projectile/P, def_zone, blocked)
	var/obj/item/bodypart/BP = get_bodypart(check_zone(def_zone))
	if(BP)
		var/newdam = P.damage * (100-blocked)/100
		BP.bodypart_attacked_by(P.woundclass, newdam, zone_precise = def_zone, crit_message = TRUE, reduce_crit = P.reduce_crit_chance)
		return TRUE

/mob/living/carbon/check_projectile_embed(obj/projectile/P, def_zone, blocked)
	var/obj/item/bodypart/BP = get_bodypart(check_zone(def_zone))
	if(!BP)
		return FALSE
	var/newdam = P.damage * (100-blocked)/100
	if(newdam <= 8)
		return FALSE
	if(prob(P.embedchance) && P.dropped)
		BP.add_embedded_object(P.dropped, silent = FALSE, crit_message = TRUE)
		return TRUE
	return FALSE

/mob/living/carbon/send_pull_message(mob/living/target)
	var/used_limb = parse_zone(BODY_ZONE_CHEST)
	var/obj/item/grabbing/I
	if(active_hand_index == 1)
		I = r_grab
	else
		I = l_grab
	if(I)
		used_limb = parse_zone(I.sublimb_grabbed)

	if(used_limb)
		if(!cmode && target != src) // No self love here
			if(used_limb == parse_zone(BODY_ZONE_PRECISE_R_HAND) || used_limb == parse_zone(BODY_ZONE_PRECISE_L_HAND))
				record_round_statistic(STATS_HANDS_HELD)
		target.visible_message(span_warning("[src] grabs [target]'s [used_limb]."), \
						span_warning("[src] grabs my [used_limb]."), span_hear("I hear shuffling."), null, list(src))
		to_chat(src, span_info("I grab [target]'s [used_limb]."))
	else
		target.visible_message(span_warning("[src] grabs [target]."), \
						span_warning("[src] grabs me."), span_hear("I hear shuffling."), null, list(src))
		to_chat(src, span_info("I grab [target]."))

/mob/living/carbon/send_grabbed_message(mob/living/carbon/user)
	var/used_limb = "chest"
	var/obj/item/grabbing/I
	if(user.active_hand_index == 1)
		I = user.r_grab
	else
		I = user.l_grab
	if(I)
		used_limb = parse_zone(I.sublimb_grabbed)

	if(HAS_TRAIT(user, TRAIT_NOTIGHTGRABMESSAGE))
		return

	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		visible_message("<span class='danger'>[user] firmly grips [src]'s [used_limb]!</span>",
						"<span class='danger'>[user] firmly grips my [used_limb]!</span>", "<span class='hear'>I hear aggressive shuffling!</span>", null, user)
		to_chat(user, "<span class='danger'>I firmly grip [src]'s [used_limb]!</span>")
	else
		visible_message("<span class='danger'>[user] tightens [user.p_their()] grip on [src]'s [used_limb]!</span>", \
						"<span class='danger'>[user] tightens [user.p_their()] grip on my [used_limb]!</span>", "<span class='hear'>I hear aggressive shuffling!</span>", null, user)
		to_chat(user, "<span class='danger'>I tighten my grip on [src]'s [used_limb]!</span>")

/mob/living/carbon/proc/precise_attack_check(zone, obj/item/bodypart/affecting) //for striking eyes, throat, etc
	if(zone && affecting)
		if(zone in affecting.subtargets)
			return parse_zone(zone)
		return affecting.name

/mob/living/carbon/proc/find_used_grab_limb(mob/living/user, accurate = FALSE) //for finding the exact limb or inhand to grab
	var/used_limb = BODY_ZONE_CHEST
	var/missing_nose = HAS_TRAIT(src, TRAIT_MISSING_NOSE)
	var/obj/item/bodypart/affecting
	var/selzone = user.zone_selected
	if(cmode && !accurate)
		selzone = accuracy_check(user.zone_selected, user, src, /datum/skill/combat/wrestling, user.used_intent)
	affecting = get_bodypart(check_zone(selzone))
	if(selzone && affecting)
		if(selzone in affecting.grabtargets)
			if(missing_nose && selzone == BODY_ZONE_PRECISE_NOSE)
				used_limb = BODY_ZONE_HEAD
			else
				used_limb = selzone
		else
			used_limb = affecting.body_zone
	return used_limb

/// Checks which arm is grabbed using index. Returns the found grabbing item.
/mob/proc/check_arm_grabbed(index)
	return

/mob/living/carbon/check_arm_grabbed(index)
	if(pulledby && pulledby != src)
		var/obj/item/bodypart/BP
		if(index == 1)
			BP = get_bodypart(BODY_ZONE_L_ARM)
		else if(index == 2)
			BP = get_bodypart(BODY_ZONE_R_ARM)
		if(BP)
			for(var/obj/item/grabbing/G in src.grabbedby)
				if(G.limb_grabbed == BP)
					return G

/mob/proc/check_leg_grabbed()
	return

/// Checks which leg is grabbed using index. Returns the found grabbing item.
/mob/living/carbon/check_leg_grabbed(index)
	if(pulledby)
		var/obj/item/bodypart/BP
		if(index == 1)
			BP = get_bodypart(BODY_ZONE_R_LEG)
		else if(index == 2)
			BP = get_bodypart(BODY_ZONE_L_LEG)
		if(BP)
			for(var/obj/item/grabbing/G in src.grabbedby)
				if(G.limb_grabbed == BP)
					return G


/mob/living/carbon/attacked_by(obj/item/I, mob/living/user)
	var/obj/item/bodypart/affecting
	var/useder = user.zone_selected
	if(user.tempatarget)
		useder = user.tempatarget
		user.tempatarget = null
	if(!lying_attack_check(user, I))
		return
	affecting = get_bodypart(check_zone(useder)) //precise attacks, on yourself or someone you are grabbing
	if(!affecting) //missing limb
		to_chat(user, span_warning("Unfortunately, there's nothing there."))
		return FALSE
	SEND_SIGNAL(I, COMSIG_ITEM_ATTACK_ZONE, src, user, affecting)
	I.funny_attack_effects(src, user)
	var/statforce = get_complex_damage(I, user)
	if(statforce)
		next_attack_msg.Cut()
		affecting.bodypart_attacked_by(user.used_intent.blade_class, statforce, crit_message = TRUE)
		apply_damage(statforce, I.damtype, affecting)
		if(I.damtype == BRUTE && affecting.status == BODYPART_ORGANIC)
			if(prob(statforce))
				I.add_mob_blood(src)
				user.update_inv_hands()
				var/turf/location = get_turf(src)
				add_splatter_floor(location)
				if(get_dist(user, src) <= 1)	//people with TK won't get smeared with blood
					user.add_mob_blood(src)
				var/splatter_dir = get_dir(user, src)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(loc, splatter_dir)
				if(affecting.body_zone == BODY_ZONE_HEAD)
					if(wear_mask)
						wear_mask.add_mob_blood(src)
						update_inv_wear_mask()
					if(wear_neck)
						wear_neck.add_mob_blood(src)
						update_inv_neck()
					if(head)
						head.add_mob_blood(src)
						update_inv_head()

	if(user == src || pulledby == user)
		send_item_attack_message(I, user, precise_attack_check(useder, affecting))
	else
		send_item_attack_message(I, user, affecting.name)

	if(statforce)
		var/probability = I.get_dismemberment_chance(affecting, user)
		if(prob(probability) && affecting.dismember(I.damtype, user.used_intent?.blade_class, user, user.zone_selected))
			I.add_mob_blood(src)
		return TRUE //successful attack

//ATTACK HAND IGNORING PARENT RETURN VALUE
/mob/living/carbon/attack_hand(mob/living/carbon/human/user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		. = TRUE

	if(!lying_attack_check(user))
		return FALSE

	if(!get_bodypart(check_zone(user.zone_selected)))
		to_chat(user, "<span class='warning'>[src] is missing that.</span>")
		return FALSE

	if(!user.cmode && (istype(user.rmb_intent, /datum/rmb_intent/weak) || istype(user.rmb_intent, /datum/rmb_intent/strong)))
		var/try_to_fail = !istype(user.rmb_intent, /datum/rmb_intent/weak)
		var/list/possible_steps = list()
		for(var/datum/surgery_step/surgery_step as anything in GLOB.surgery_steps)
			if(!surgery_step.name)
				continue
			if(surgery_step.can_do_step(user, src, user.zone_selected, null, user.used_intent))
				possible_steps[surgery_step.name] = surgery_step
		var/possible_len = length(possible_steps)
		if(possible_len)
			var/datum/surgery_step/done_step
			if(possible_len > 1)
				var/input = input(user, "Which surgery step do you want to perform?", "PESTRA", ) as null|anything in possible_steps
				if(input)
					done_step = possible_steps[input]
			else
				done_step = possible_steps[possible_steps[1]]
			if(done_step?.try_op(user, src, user.zone_selected, null, user.used_intent, try_to_fail))
				return TRUE
	/*
	for(var/datum/surgery/S in surgeries)
		if(!(mobility_flags & MOBILITY_STAND) || !S.lying_required)
			if(user.used_intent.type == INTENT_HELP || user.used_intent.type == INTENT_DISARM)
				if(S.next_step(user, user.used_intent))
					return TRUE
	*/
	return FALSE


/mob/living/carbon/attack_paw(mob/living/carbon/monkey/M)
	if(M.used_intent.type == INTENT_HELP)
		help_shake_act(M)
		return 0

	if(..()) //successful monkey bite.
		return 1

/mob/living/carbon/proc/dismembering_strike(mob/living/attacker, dam_zone)
	if(!attacker.limb_destroyer)
		return dam_zone
	if(attacker.a_intent.blade_class != BCLASS_CHOP && attacker.a_intent.blade_class != BCLASS_CUT)
		return dam_zone
	var/obj/item/bodypart/affecting
	if(dam_zone && attacker.client)
		affecting = get_bodypart(dam_zone)
	else
		var/list/things_to_ruin = shuffle(bodyparts.Copy())
		for(var/obj/item/bodypart/bodypart as anything in things_to_ruin)
			if(bodypart.dismemberable)
				affecting = bodypart
	if(affecting)
		dam_zone = affecting.body_zone
		if(affecting.get_damage() >= affecting.max_damage)
			affecting.dismember(BRUTE, attacker.a_intent.blade_class, attacker, attacker.zone_selected)
			return null
		return affecting.body_zone
	return dam_zone

///Adds to the parent by also adding functionality to propagate shocks through pulling and doing some fluff effects.
/mob/living/carbon/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	. = ..()
	if(!.)
		return
	//Propagation through pulling, fireman carry
	if(!(flags & SHOCK_ILLUSION))
		var/list/shocking_queue = list()
		if(iscarbon(pulling) && source != pulling)
			shocking_queue += pulling
		if(iscarbon(pulledby) && source != pulledby)
			shocking_queue += pulledby
		if(iscarbon(buckled) && source != buckled)
			shocking_queue += buckled
		for(var/mob/living/carbon/carried in buckled_mobs)
			if(source != carried)
				shocking_queue += carried
		//Found our victims, now lets shock them all
		for(var/mob/living/carbon/C as anything in shocking_queue)
			C.electrocute_act(shock_damage*0.75, src, 1, flags)
	//Stun
	var/should_stun = (!(flags & SHOCK_TESLA) || siemens_coeff > 0.5) && !(flags & SHOCK_NOSTUN)
	if(!HAS_TRAIT(src, TRAIT_NOPAIN))
		if(should_stun && !HAS_TRAIT(src, TRAIT_NOPAINSTUN) && !has_status_effect(/datum/status_effect/shock_recovery))
			Paralyze(3 SECONDS)
		//Jitter and other fluff.
		jitteriness += 1000
		do_jitter_animation(jitteriness)
		stuttering += 2
		emote("painscream")
	addtimer(CALLBACK(src, PROC_REF(secondary_shock), should_stun), 20)
	return shock_damage

///Called slightly after electrocute act to reduce jittering and apply a secondary stun.
/mob/living/carbon/proc/secondary_shock(should_stun)
	jitteriness = max(jitteriness - 990, 10)
	if(should_stun && !HAS_TRAIT(src, TRAIT_NOPAINSTUN) && !has_status_effect(/datum/status_effect/shock_recovery))
		Paralyze(6 SECONDS)
		apply_shock_paralyze_immunity(12 SECONDS)

/mob/living/carbon/proc/apply_shock_paralyze_immunity(time)
	apply_status_effect(/datum/status_effect/shock_recovery)
	addtimer(CALLBACK(src, PROC_REF(remove_shock_paralyze_immunity), src), time)

/mob/living/carbon/proc/remove_shock_paralyze_immunity()
	remove_status_effect(/datum/status_effect/shock_recovery)

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if(on_fire)
		if(M.gloves)
			M.changeNext_move(CLICK_CD_MELEE)
			M.visible_message(span_warning("[M] pats out the flames on [src]!"))
			adjust_divine_fire_stacks(-2)
			if(fire_stacks > 0)
				adjust_fire_stacks(-2)
			M.gloves.take_damage(10, BURN, "fire")
		else
			to_chat(M, span_warning("I can't put [p_them()] out with just my bare hands!"))
		return

//	if(!(mobility_flags & MOBILITY_STAND))
//		if(buckled)
//			to_chat(M, "<span class='warning'>I need to unbuckle [src] first to do that!</span>")
//			return
//		M.visible_message("<span class='notice'>[M] shakes [src] trying to get [p_them()] up!</span>", "<span class='notice'>I shake [src] trying to get [p_them()] up!</span>")
//	else
	M.visible_message("<span class='notice'>[M] shakes [src].</span>", \
				"<span class='notice'>I shake [src] to get [p_their()] attention.</span>")
	shake_camera(src, 2, 1)
	add_stress(/datum/stress_event/hug)
	for(var/datum/brain_trauma/trauma in M.get_traumas())
		trauma.on_hug(M, src)
	AdjustStun(-60)
	AdjustKnockdown(-60)
	AdjustUnconscious(-60)
	AdjustSleeping(-100)
	AdjustParalyzed(-60)
	AdjustImmobilized(-60)
	set_resting(FALSE)

	playsound(loc, 'sound/blank.ogg', 50, TRUE, -1)


/mob/living/carbon/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0)
	var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(!eyes) //can't flash what can't see!
		return

	. = ..()

	var/damage = intensity - get_eye_protection()
	if(.) // we've been flashed
		if(visual)
			return

		if (damage == 1)
			to_chat(src, "<span class='warning'>My eyes sting a little.</span>")
			if(prob(40))
				eyes.applyOrganDamage(1)

		else if (damage == 2)
			to_chat(src, "<span class='warning'>My eyes burn.</span>")
			eyes.applyOrganDamage(rand(2, 4))

		else if( damage >= 3)
			to_chat(src, "<span class='warning'>My eyes itch and burn severely!</span>")
			eyes.applyOrganDamage(rand(12, 16))

		if(eyes.damage > 10)
			blind_eyes(damage)
			blur_eyes(damage * rand(3, 6))

			if(eyes.damage > 20)
				if(prob(eyes.damage - 20))
					if(!HAS_TRAIT(src, TRAIT_NEARSIGHT))
						to_chat(src, "<span class='warning'>My eyes start to burn badly!</span>")
					become_nearsighted(EYE_DAMAGE)

				else if(prob(eyes.damage - 25))
					if(!HAS_TRAIT(src, TRAIT_BLIND))
						to_chat(src, "<span class='warning'>I can't see anything!</span>")
					eyes.applyOrganDamage(eyes.maxHealth)

			else
				to_chat(src, "<span class='warning'>My eyes are really starting to hurt. This can't be good for you!</span>")
		return 1
	else if(damage == 0) // just enough protection
		if(prob(20))
			to_chat(src, "<span class='notice'>Something bright flashes in the corner of my vision!</span>")


/mob/living/carbon/soundbang_act(intensity = 1, stun_pwr = 20, damage_pwr = 5, deafen_pwr = 15)
	var/list/reflist = list(intensity) // Need to wrap this in a list so we can pass a reference
	SEND_SIGNAL(src, COMSIG_CARBON_SOUNDBANG, reflist)
	intensity = reflist[1]
	var/ear_safety = get_ear_protection()
	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	var/effect_amount = intensity - ear_safety
	if(effect_amount > 0)
		if(stun_pwr)
			Paralyze((stun_pwr*effect_amount)*0.1)
			Knockdown(stun_pwr*effect_amount)

		if(istype(ears) && (deafen_pwr || damage_pwr))
			var/ear_damage = damage_pwr * effect_amount
			var/deaf = deafen_pwr * effect_amount
			adjustEarDamage(ear_damage,deaf)

			if(ears.damage >= 15)
				to_chat(src, "<span class='warning'>My ears start to ring badly!</span>")
				if(prob(ears.damage - 5))
					to_chat(src, "<span class='danger'>I can't hear anything!</span>")
					ears.damage = min(ears.damage, ears.maxHealth)
					// you need earmuffs, inacusiate, or replacement
			else if(ears.damage >= 5)
				to_chat(src, "<span class='warning'>My ears start to ring!</span>")
			SEND_SOUND(src, sound('sound/blank.ogg',0,1,0,250))
		return effect_amount //how soundbanged we are


/mob/living/carbon/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	if(damage_type != BRUTE && damage_type != BURN)
		return
	damage_amount *= 0.5 //0.5 multiplier for balance reason, we don't want clothes to be too easily destroyed
	if(!def_zone || def_zone == BODY_ZONE_HEAD)
		var/obj/item/clothing/hit_clothes
		if(wear_mask)
			hit_clothes = wear_mask
		if(wear_neck)
			hit_clothes = wear_neck
		if(head)
			hit_clothes = head
		if(hit_clothes)
			hit_clothes.take_damage(damage_amount, damage_type, damage_flag, 0)

/mob/living/carbon/can_hear()
	. = FALSE
	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	if((istype(ears) && !ears.deaf) || (src.stat == DEAD)) // 2nd check so you can hear messages when beheaded
		. = TRUE

/mob/living/carbon/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(isnull(.))
		return
	if(. <= 75)
		if(getOxyLoss() > 75)
			ADD_TRAIT(src, TRAIT_KNOCKEDOUT, OXYLOSS_TRAIT)
	else if(getOxyLoss() <= 75)
		REMOVE_TRAIT(src, TRAIT_KNOCKEDOUT, OXYLOSS_TRAIT)

/mob/living/carbon/setOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(isnull(.))
		return
	if(. <= 75)
		if(getOxyLoss() > 75)
			ADD_TRAIT(src, TRAIT_KNOCKEDOUT, OXYLOSS_TRAIT)
	else if(getOxyLoss() <= 75)
		REMOVE_TRAIT(src, TRAIT_KNOCKEDOUT, OXYLOSS_TRAIT)
