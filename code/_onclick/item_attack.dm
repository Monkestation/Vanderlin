/**
 * This is the proc that handles the order of an item_attack.
 *
 * The order of procs called is:
 * * [/atom/proc/tool_act] on the target. If it returns TRUE, the chain will be stopped.
 * * [/obj/item/proc/pre_attack] on src. If this returns TRUE, the chain will be stopped.
 * * [/atom/proc/attackby] on the target. If it returns TRUE, the chain will be stopped.
 * * [/obj/item/proc/afterattack]. The return value does not matter.
 */
/obj/item/proc/melee_attack_chain(mob/user, atom/target, list/modifiers)
	var/obj/item/grabbing/arm_grab = user.check_arm_grabbed(user.active_hand_index)
	if(arm_grab)
		to_chat(user, span_notice("I can't move my arm!"))
		if(HAS_TRAIT(src, TRAIT_WIELDED))
			if(iscarbon(user))
				var/mob/living/carbon/carbon_user = user
				carbon_user.dna?.species.disarm(user, arm_grab.grabbee)
		else
			user.resist_grab()
		return TRUE
	if(!user.has_hand_for_held_index(user.active_hand_index, TRUE)) //we obviously have a hand, but we need to check for fingers/prosthetics
		to_chat(user, span_warning("I can't move the fingers of my [user.active_hand_index == 1 ? "left" : "right"] hand.</span>"))
		return TRUE
	if(!istype(src, /obj/item/grabbing))
		if(HAS_TRAIT(user, TRAIT_CHUNKYFINGERS))
			to_chat(user, span_warning("...What?"))
			return TRUE

	var/is_right_clicking = LAZYACCESS(modifiers, RIGHT_CLICK)

	if(tool_behaviour && target.tool_act(user, src, tool_behaviour))
		return TRUE

	var/pre_attack_result
	if(is_right_clicking)
		switch(pre_attack_secondary(target, user, modifiers))
			if(SECONDARY_ATTACK_CALL_NORMAL)
				pre_attack_result = pre_attack(target, user, modifiers)
			if(SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
				return TRUE
			if(SECONDARY_ATTACK_CONTINUE_CHAIN)
				EMPTY_BLOCK_GUARD // Normal behavior
			else
				CRASH("pre_attack_secondary must return an SECONDARY_ATTACK_* define, please consult code/__DEFINES/combat.dm")
	else
		pre_attack_result = pre_attack(target, user, modifiers)

	if(pre_attack_result)
		return TRUE

	var/attackby_result

	if(is_right_clicking)
		switch(target.attackby_secondary(src, user, modifiers))
			if(SECONDARY_ATTACK_CALL_NORMAL)
				attackby_result = target.attackby(src, user, modifiers)
			if(SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
				return TRUE
			if(SECONDARY_ATTACK_CONTINUE_CHAIN)
				EMPTY_BLOCK_GUARD // Normal behavior
			else
				CRASH("attackby_secondary must return an SECONDARY_ATTACK_* define, please consult code/__DEFINES/combat.dm")
	else
		attackby_result = target.attackby(src, user, modifiers)

	if(attackby_result)
		return TRUE

	if(QDELETED(src) || QDELETED(target))
		attack_qdeleted(target, user, TRUE, modifiers)
		return

	if(is_right_clicking)
		var/after_attack_secondary_result = afterattack_secondary(target, user, TRUE, modifiers)

		// There's no chain left to continue at this point, so CANCEL_ATTACK_CHAIN and CONTINUE_CHAIN are functionally the same.
		if(after_attack_secondary_result == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || after_attack_secondary_result == SECONDARY_ATTACK_CONTINUE_CHAIN)
			return TRUE

	return afterattack(target, user, TRUE, modifiers)

// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user, list/modifiers)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	interact(user)

/obj/item/proc/attack_self_secondary(mob/user, list/modifiers)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF_SECONDARY, user, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	toggle_altgrip(user)

/**
 * Called on the item before it hits something
 *
 * Arguments:
 * * atom/A - The atom about to be hit
 * * mob/living/user - The mob doing the htting
 * * list/modifers - is the params string from byond [/atom/proc/Click] code turned into a list, see that documentation.
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/obj/item/proc/pre_attack(atom/A, mob/living/user, list/modifiers) //do stuff before attackby!
	if(SEND_SIGNAL(src, COMSIG_ITEM_PRE_ATTACK, A, user, modifiers) & COMPONENT_NO_ATTACK)
		return TRUE
	return FALSE //return TRUE to avoid calling attackby after this proc does stuff

/**
 * Called on the item before it hits something, when right clicking.
 *
 * Arguments:
 * * atom/target - The atom about to be hit
 * * mob/living/user - The mob doing the htting
 * * list/modifers - is the params string from byond [/atom/proc/Click] code turned into a list, see that documentation.
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/obj/item/proc/pre_attack_secondary(atom/target, mob/living/user, list/modifiers)
	var/signal_result = SEND_SIGNAL(src, COMSIG_ITEM_PRE_ATTACK_SECONDARY, target, user, modifiers)

	if(signal_result & COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(signal_result & COMPONENT_SECONDARY_CONTINUE_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	return SECONDARY_ATTACK_CALL_NORMAL

/**
 * Called on an object being hit by an item
 *
 * Arguments:
 * * obj/item/attacking_item - The item hitting this atom
 * * mob/user - The wielder of this item
 * * list/modifers - is the params string from byond [/atom/proc/Click] code turned into a list, see that documentation.
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/atom/proc/attackby(obj/item/attacking_item, mob/user, list/modifiers)
	if(user.used_intent.tranged)
		return FALSE

	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACKBY, attacking_item, user, modifiers) & COMPONENT_NO_AFTERATTACK)
		return TRUE
	return FALSE

/**
 * Called on an object being right-clicked on by an item
 *
 * Arguments:
 * * obj/item/weapon - The item hitting this atom
 * * mob/user - The wielder of this item
 * * list/modifers - is the params string from byond [/atom/proc/Click] code turned into a list, see that documentation.
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/atom/proc/attackby_secondary(obj/item/weapon, mob/user, list/modifiers)
	if(user.used_intent.tranged)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/signal_result = SEND_SIGNAL(src, COMSIG_ATOM_ATTACKBY_SECONDARY, weapon, user, modifiers)

	if(signal_result & COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(signal_result & COMPONENT_SECONDARY_CONTINUE_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	return SECONDARY_ATTACK_CALL_NORMAL

/obj/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(!user.cmode)
		if(user.try_recipes(src, I, user))
			user.changeNext_move(CLICK_CD_FAST)
			return TRUE
	if(I.obj_flags_ignore)
		return I.attack_atom(src, user)
	return ..() || ((obj_flags & CAN_BE_HIT) && I.attack_atom(src, user))

/turf/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(liquids && I.heat)
		hotspot_expose(I.heat)
	return ..() || (uses_integrity && I.attack_atom(src, user))

/mob/living/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(..())
		return TRUE
	var/adf = user.used_intent?.clickcd
	if(I.force && user.used_intent && !user.used_intent.tranged && !user.used_intent.tshield && !user.used_intent.noaa)
		if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
			adf = round(adf * 1.4)
		if(istype(user.rmb_intent, /datum/rmb_intent/swift))
			adf = round(adf * 0.6)
	user.changeNext_move(adf)

	for(var/obj/item/clothing/worn_thing in get_equipped_items(include_pockets = TRUE))//checks clothing worn by src.
	// Things that are supposed to be worn, being held = cannot block
		if(isclothing(worn_thing))
			if(worn_thing in held_items)
				continue
		// Things that are supposed to be held, being worn = cannot block
		else if(!(worn_thing in held_items))
			continue
		worn_thing.hit_response(src, user) //checks if clothing has hit response. Refer to Items.dm

	return I.attack(src, user, modifiers)

/mob/living/attackby_secondary(obj/item/weapon, mob/living/user, list/modifiers)
	. = ..()
	if(user.cmode)
		if(user.rmb_intent)
			user.rmb_intent.special_attack(user, src)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		// Normal attackby updates click cooldown, so we have to make up for it
		var/result = weapon.attack_secondary(src, user, modifiers)

		if(result != SECONDARY_ATTACK_CALL_NORMAL)
			var/adf = user.used_intent.clickcd
			if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
				adf = round(adf * 1.4)
			if(istype(user.rmb_intent, /datum/rmb_intent/swift))
				adf = round(adf * 0.6)
			user.changeNext_move(adf)

		return result

	if(weapon.item_flags & ABSTRACT)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(src == user)
		if(offered_item_ref)
			cancel_offering_item()
		else
			to_chat(user, span_warning("I can't offer myself an item!"))
		return

	var/obj/offered_item
	if(user.offered_item_ref)
		offered_item = user.offered_item_ref.resolve()
		if(offered_item == weapon)
			user.cancel_offering_item()
			return
		else
			to_chat(user, span_notice("I'm already offering [offered_item]!"))
			return

	offered_item = user.get_active_held_item()

	if(HAS_TRAIT(offered_item, TRAIT_NODROP))
		to_chat(user, span_warning("I can't offer this."))
		return
	user.offer_item(src, offered_item)

/**
 * Called from [/mob/living/proc/attackby]
 *
 * Arguments:
 * * mob/living/M - The mob being hit by this item
 * * mob/living/user - The mob hitting with this item
 * * list/modifers - is the params string from byond [/atom/proc/Click] code turned into a list, see that documentation.
 */
/obj/item/proc/attack(mob/living/M, mob/living/user, list/modifiers)
	var/signal_return = SEND_SIGNAL(src, COMSIG_ITEM_ATTACK, M, user, modifiers) || SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK, M, src)
	if(signal_return & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	if(signal_return & COMPONENT_SKIP_ATTACK)
		return FALSE

	if(item_flags & NOBLUDGEON)
		return FALSE

	if(force && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, "<span class='warning'>I don't want to harm other living beings!</span>")
		return FALSE

	M.lastattacker = user.real_name
	M.lastattackerckey = user.ckey
	if(M.mind)
		M.mind.attackedme[user.real_name] = world.time
	if(!force)
		return FALSE
	if(user.used_intent)
		if(!user.used_intent.noaa)
			playsound(src, pick(swingsound), 100, FALSE, -1)
		if(user.used_intent.no_attack) //BYE!!!
			return TRUE

	var/datum/intent/cached_intent = user.used_intent
	if(user.used_intent.swingdelay)
		sleep(user.used_intent.swingdelay)
	if(user.a_intent != cached_intent)
		return
	if(QDELETED(src) || QDELETED(M))
		return
	if(!user.CanReach(M,src))
		return
	if(user.get_active_held_item() != src)
		return
	if(user.incapacitated(IGNORE_GRAB))
		return
	if((M.body_position != LYING_DOWN))
		if(M.checkmiss(user))
			return
	if(istype(user.rmb_intent, /datum/rmb_intent/strong))
		user.adjust_stamina(10)
	if(istype(user.rmb_intent, /datum/rmb_intent/swift))
		user.adjust_stamina(10)
	var/turf/turf_before = get_turf(M)
	if(M.checkdefense(user.used_intent, user))
		if(M.d_intent == INTENT_PARRY)
			if(!M.get_active_held_item() && !M.get_inactive_held_item()) //we parried with a bracer, redirect damage
				if(M.active_hand_index == 1)
					user.tempatarget = BODY_ZONE_L_ARM
				else
					user.tempatarget = BODY_ZONE_R_ARM
				if(M.attacked_by(src, user)) //we change intents when attacking sometimes so don't play if we do (embedding items)
					if(user.used_intent == cached_intent)
						var/tempsound = user.used_intent.hitsound
						if(tempsound)
							playsound(M, tempsound, get_clamped_volume(), FALSE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
						else
							playsound(M, "nodmg", get_clamped_volume(), FALSE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
				log_combat(user, M, "attacked", src.name, "(INTENT: [uppertext(user.used_intent.name)]) (DAMTYPE: [uppertext(damtype)])")
				add_fingerprint(user)
		if(M.d_intent == INTENT_DODGE)
			// if(!user.used_intent.swingdelay)
			if(get_dist(get_turf(user), get_turf(M)) <= user.used_intent.reach)
				user.do_attack_animation(turf_before, visual_effect_icon = user.used_intent.animname, used_item = src, used_intent = user.used_intent)
			else
				user.do_attack_animation(get_ranged_target_turf(user, get_dir(user, M), 1), visual_effect_icon = user.used_intent.animname, used_item = src, used_intent = user.used_intent)
		return
	if(!user.used_intent.noaa)
		if(get_dist(get_turf(user), get_turf(M)) <= user.used_intent.reach)
			user.do_attack_animation(M, visual_effect_icon = user.used_intent.animname, used_item = src, used_intent = user.used_intent)
		else
			user.do_attack_animation(get_ranged_target_turf(user, get_dir(user, M), 1), visual_effect_icon = user.used_intent.animname, used_item = src, used_intent = user.used_intent)
	if(user.zone_selected == BODY_ZONE_PRECISE_R_INHAND)
		var/offh = 0
		var/obj/item/W = M.held_items[1]
		if(W)
			if(M.body_position == LYING_DOWN)
				M.throw_item(get_step(M,turn(M.dir, 90)), offhand = offh)
			else
				M.dropItemToGround(W)
			M.visible_message("<span class='notice'>[user] disarms [M]!</span>", \
							"<span class='boldwarning'>I'm disarmed by [user]!</span>")
			return

	if(user.zone_selected == BODY_ZONE_PRECISE_L_INHAND)
		var/offh = 0
		var/obj/item/W = M.held_items[2]
		if(W)
			if(M.body_position == LYING_DOWN)
				M.throw_item(get_step(M,turn(M.dir, 270)), offhand = offh)
			else
				M.dropItemToGround(W)
			M.visible_message("<span class='notice'>[user] disarms [M]!</span>", \
							"<span class='boldwarning'>I'm disarmed by [user]!</span>")
			return

	if(M.attacked_by(src, user))
		if(user.used_intent == cached_intent)
			var/tempsound = user.used_intent.hitsound
			if(tempsound)
				playsound(M,  tempsound, 100, FALSE, -1)
			else
				playsound(M,  "nodmg", 100, FALSE, -1)

	log_combat(user, M, "attacked", src.name, "(INTENT: [uppertext(user.used_intent.name)]) (DAMTYPE: [uppertext(damtype)])")
	add_fingerprint(user)


/// The equivalent of [/obj/item/proc/attack] but for alternate attacks, AKA right clicking
/obj/item/proc/attack_secondary(mob/living/victim, mob/living/user, list/modifiers)
	var/signal_result = SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SECONDARY, victim, user, modifiers)

	if(signal_result & COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(signal_result & COMPONENT_SECONDARY_CONTINUE_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	return SECONDARY_ATTACK_CALL_NORMAL

/// The equivalent of the standard version of [/obj/item/proc/attack] but for non-mob targets. Return TRUE to end the attack chain.
/obj/item/proc/attack_atom(atom/attacked_atom, mob/living/user)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_OBJ, attacked_atom, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	if(item_flags & NOBLUDGEON)
		return TRUE
	user.changeNext_move(CLICK_CD_MELEE)
	if(attacked_atom.attacked_by(src, user) && !isopenturf(attacked_atom)) // this check is due to attack animations in /obj/item/proc/afterattack()
		user.do_attack_animation(attacked_atom, used_item = src, used_intent = user.used_intent)

/// Called from [/obj/item/proc/attack_obj] and [/obj/item/proc/attack] if the attack succeeds.
/atom/proc/attacked_by(obj/item/attacking_item, mob/living/user)
	if(!uses_integrity)
		CRASH("attacked_by() was called on [type], which doesn't use integrity!")

	if(user.used_intent.no_attack)
		return

	var/newforce = get_complex_damage(attacking_item, user, blade_dulling)
	if(!newforce)
		return

	var/damage_verb = "hits"

	damage_verb = pick(user.used_intent.attack_verb)
	if(newforce > 1)
		attacking_item.take_damage(1, BRUTE, "blunt")
		if(!user.adjust_stamina(5))
			damage_verb = "ineffectively hits"
			newforce = 1

	user.visible_message(span_danger("[user] [damage_verb] [src] with [attacking_item]!"))
	take_damage(newforce, attacking_item.damtype, attacking_item.damage_type, TRUE)
	log_combat(user, src, "attacked", attacking_item)
	return TRUE

/area/attacked_by(obj/item/attacking_item, mob/living/user)
	CRASH("areas are NOT supposed to have attacked_by() called on them!")

/*
* I didnt code this but this is what ive deciphered.
* Complex damage is the final calculation of damage
* and the source of dulling for weapons.
* This proc is also not overridable due to having no root.
* -IP
*/
/proc/get_complex_damage(obj/item/I, mob/living/user, blade_dulling)
	var/dullfactor = 1
	if(!I?.force)
		return 0
	// newforce starts here and is the default amount of damage the item does.
	var/newforce = I.force
	// If this weapon has no user and is somehow attacking you just return default.
	if(!istype(user))
		return newforce
	var/cont = FALSE
	var/used_str = user.STASTR
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		/*
		* If you have a dominant hand which is assigned at
		* character creation. You suffer a -1 Str if your
		* no using the item in your dominant hand.
		* Check living/carbon/carbon.dm for more info.
		*/
		if(C.domhand)
			used_str = C.get_str_arms(C.used_hand)
	//STR is +1 from STRONG stance and -1 from SWIFT stance
	if(istype(user.rmb_intent, /datum/rmb_intent/strong))
		used_str++
	if(istype(user.rmb_intent, /datum/rmb_intent/swift))
		used_str--
	if(istype(user.rmb_intent, /datum/rmb_intent/weak))
		used_str /= 2
	//Your max STR is 20.
	used_str = CLAMP(used_str, 1, 20)
	//Vampire checks for Potence
	if(ishuman(user))
		var/mob/living/carbon/human/user_human = user
		if(user_human.clan)
			used_str += floor(0.5 * user_human.potence_weapon_buff)
			// For each level of potence user gains 0.5 STR, at 5 Potence their STR buff is 2.5
	if(used_str >= 11)
		newforce = newforce + (newforce * ((used_str - 10) * 0.1))
	else if(used_str <= 9)
		newforce = newforce - (newforce * ((10 - used_str) * 0.1))

	if(I.minstr)
		var/effective = I.minstr
		if(HAS_TRAIT(I, TRAIT_WIELDED))
			effective *= 0.75
		//Strength influence is reduced to 30%
		if(effective > user.STASTR)
			newforce = max(newforce*0.3, 1)

	//Blade Dulling Starts here.
	switch(blade_dulling)
		if(DULLING_CUT) //wooden that can't be attacked by clubs (trees, bushes, grass)
			switch(user.used_intent.blade_class)
				if(BCLASS_CUT)
					var/mob/living/lumberjacker = user
					var/lumberskill = lumberjacker.get_skill_level(/datum/skill/labor/lumberjacking, TRUE)
					if(!I.remove_bintegrity(1, user))
						dullfactor = 0.2
					else
						dullfactor = 0.45 + (lumberskill * 0.15)
						lumberjacker.mind.add_sleep_experience(/datum/skill/labor/lumberjacking, (lumberjacker.STAINT*0.2))
					cont = TRUE
				if(BCLASS_CHOP)
					//Additional damage for axes against trees.
					if(istype(I, /obj/item/weapon))
						var/obj/item/weapon/R = I
						if(R.axe_cut)
							//Yes i know its cheap to just make it a flat plus.
							newforce = newforce + R.axe_cut
					if(!I.remove_bintegrity(1, user))
						dullfactor = 0.2
					else
						dullfactor = 1.5
					cont = TRUE
			if(!cont)
				return 0
		if(DULLING_BASH) //stone/metal, can't be attacked by cutting
			switch(user.used_intent.blade_class)
				if(BCLASS_BLUNT)
					cont = TRUE
				if(BCLASS_SMASH)
					dullfactor = 1.5
					cont = TRUE
				if(BCLASS_DRILL)
					dullfactor = 10
					cont = TRUE
				if(BCLASS_PICK)
					dullfactor = 1.5
					cont = TRUE
			if(!cont)
				return 0
		if(DULLING_BASHCHOP) //structures that can be attacked by clubs also (doors fences etc)
			switch(user.used_intent.blade_class)
				if(BCLASS_CUT)
					if(!I.remove_bintegrity(1, user))
						dullfactor = 0.8
					cont = TRUE
				if(BCLASS_CHOP)
					if(!I.remove_bintegrity(1, user))
						dullfactor = 0.8
					else
						dullfactor = 1.5
					cont = TRUE
				if(BCLASS_SMASH)
					dullfactor = 1.5
					cont = TRUE
				if(BCLASS_DRILL)
					dullfactor = 10
					cont = TRUE
				if(BCLASS_BLUNT)
					cont = TRUE
				if(BCLASS_PICK)
					var/mob/living/miner = user
					var/mineskill = miner.get_skill_level(/datum/skill/labor/mining, TRUE)
					dullfactor = 1.6 - (mineskill * 0.1)
					cont = TRUE
			if(!cont)
				return 0
		if(DULLING_PICK) //cannot deal damage if not a pick item. aka rock walls
			if(user.body_position == LYING_DOWN)
				to_chat(user, span_warning("I need to stand up to get a proper swing."))
				return 0
			if(user.used_intent.blade_class != BCLASS_PICK && user.used_intent.blade_class != BCLASS_DRILL)
				return 0
			var/mob/living/miner = user
			//Mining Skill force multiplier.
			var/mineskill = miner.get_skill_level(/datum/skill/labor/mining, TRUE)
			newforce = newforce * (8+(mineskill*1.5))
			// Pick quality multiplier. Affected by smithing, or material of the pick.
			if(istype(I, /obj/item/weapon/pick))
				var/obj/item/weapon/pick/P = I
				newforce *= P.pickmult
			shake_camera(user, 1, 0.1)
			miner.adjust_experience(/datum/skill/labor/mining, (miner.STAINT*0.2))
	/*
	* Ill be honest this final thing is extremely confusing.
	* Newforce after being altered by strength stat is then
	* multiplied by the damage factor of used_intent datum
	* for exsample /datum/intent/mace/smash has a damfactor
	* of 1.1. This value is then multiplied again by the
	* dullfactor which ranges from 0.2 to 1.6 and is 1 by
	* default. Picks are not effected by dullfactor if hitting
	* a rock wall or anything with DULLING_PICK blade_dulling
	* flag. This is alot.
	*/
	newforce = (newforce * user.used_intent.damfactor) * dullfactor
	if(user.used_intent.get_chargetime() && user.client?.chargedprog < 100)
		newforce = newforce * round(user.client?.chargedprog / 100, 0.1)
	// newforce = round(newforce, 1)
	if(user.body_position == LYING_DOWN)
		newforce *= 0.5
	if(user.has_status_effect(/datum/status_effect/divine_strike))
		newforce += 5
	// newforce is rounded upto the nearest intiger.
	newforce = round(newforce,1)
	//This is returning the maximum of the arguments meaning this is to prevent negative values.
	newforce = max(newforce, 1)
	return newforce

/mob/living/proc/simple_limb_hit(zone)
	if(!zone)
		return ""
	return "body"

/mob/living/simple_animal/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND) // front legs
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) // back legs
			return "leg"
		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			return "foreleg"
	return zone

/obj/item/proc/funny_attack_effects(mob/living/target, mob/living/user, nodmg)
	return

/mob/living/attacked_by(obj/item/I, mob/living/user)
	var/hitlim = simple_limb_hit(user.zone_selected)
	I.funny_attack_effects(src, user)
	if(I.force)
		var/newforce = get_complex_damage(I, user)
		apply_damage(newforce, I.damtype, def_zone = hitlim)
		if(I.damtype == BRUTE)
			next_attack_msg.Cut()
			if(HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
				var/datum/wound/crit_wound  = simple_woundcritroll(user.used_intent.blade_class, newforce, user, hitlim)
				if(crit_wound?.should_embed(I))
					// throw_alert("embeddedobject", /atom/movable/screen/alert/embeddedobject)
					simple_add_embedded_object(I, silent = FALSE, crit_message = TRUE)
					src.grabbedby(user, 1, item_override = I)
			var/haha = user.used_intent.blade_class
			if(newforce > 5)
				if(haha != BCLASS_BLUNT)
					I.add_mob_blood(src)
					var/turf/location = get_turf(src)
					add_splatter_floor(location)
					if(get_dist(user, src) <= 1)	//people with TK won't get smeared with blood
						user.add_mob_blood(src)
						user.adjust_hygiene(-10)
			if(newforce > 15)
				if(haha == BCLASS_BLUNT)
					I.add_mob_blood(src)
					var/turf/location = get_turf(src)
					add_splatter_floor(location)
					if(get_dist(user, src) <= 1)	//people with TK won't get smeared with blood
						user.add_mob_blood(src)
						user.adjust_hygiene(-10)
	send_item_attack_message(I, user, hitlim)
	if(I.force)
		return TRUE

/mob/living/simple_animal/attacked_by(obj/item/I, mob/living/user)
	if(I.force < force_threshold || I.damtype == STAMINA)
		playsound(src, 'sound/blank.ogg', I.get_clamped_volume(), TRUE, -1)
	else
		. = ..()
		I.do_special_attack_effect(user, null, null, src, null)

/**
 * Last proc in the [/obj/item/proc/melee_attack_chain]
 *
 * Arguments:
 * * atom/target - The thing that was hit
 * * mob/user - The mob doing the hitting
 * * proximity_flag - is 1 if this afterattack was called on something adjacent, in your square, or on your person.
 * * list/modifers - is the params string from byond [/atom/proc/Click] code turned into a list, see that documentation.
 */
/obj/item/proc/afterattack(atom/target, mob/living/user, proximity_flag, list/modifiers)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, target, user, proximity_flag, modifiers)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_AFTERATTACK, target, user, proximity_flag, modifiers)
	if(force && !user.used_intent.tranged && !user.used_intent.tshield)
		if(proximity_flag && isopenturf(target) && !user.used_intent?.noaa)
			var/adf = user.used_intent.clickcd
			if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
				adf = round(adf * 1.4)
			if(istype(user.rmb_intent, /datum/rmb_intent/swift))
				adf = round(adf * 0.6)
			user.changeNext_move(adf)
			if(get_dist(get_turf(user), get_turf(target)) <= user.used_intent.reach)
				user.do_attack_animation(target, visual_effect_icon = user.used_intent.animname, used_item = src, used_intent = user.used_intent)
			else
				user.do_attack_animation(get_ranged_target_turf(user, get_dir(user, target), 1), visual_effect_icon = user.used_intent.animname, used_item = src, used_intent = user.used_intent)
			playsound(src, pick(swingsound), 100, FALSE, -1)
			user.aftermiss()
		if(!proximity_flag && ismob(target) && !user.used_intent?.noaa) //this block invokes miss cost clicking on seomone who isn't adjacent to you
			playsound(src, pick(swingsound), 100, FALSE, -1)
			user.aftermiss()

/**

 * Called at the end of the attack chain if the user right-clicked.
 *
 * Arguments:
 * * atom/target - The thing that was hit
 * * mob/user - The mob doing the hitting
 * * proximity_flag - is 1 if this afterattack was called on something adjacent, in your square, or on your person.
 * * list/modifers - is the params string from byond [/atom/proc/Click] code turned into a list, see that documentation.
 */
/obj/item/proc/afterattack_secondary(atom/target, mob/user, proximity_flag, list/modifiers)
	var/signal_result = SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK_SECONDARY, target, user, proximity_flag, modifiers)

	if(signal_result & COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(signal_result & COMPONENT_SECONDARY_CONTINUE_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	// This allows afterattack() to be called
	return SECONDARY_ATTACK_CALL_NORMAL

// Called if the target gets deleted by our attack
/obj/item/proc/attack_qdeleted(atom/target, mob/user, proximity_flag, list/modifiers)
	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_QDELETED, target, user, proximity_flag, modifiers)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK_QDELETED, target, user, proximity_flag, modifiers)

/obj/item/proc/do_special_attack_effect(user, obj/item/bodypart/affecting, intent, mob/living/victim, selzone, thrown = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(victim, COMSIG_ITEM_ATTACK_EFFECT, user, affecting, intent, selzone, src)
	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_EFFECT, user, affecting, intent, victim, selzone)

/obj/item/proc/get_clamped_volume()
	if(w_class)
		if(force)
			return CLAMP((force + w_class) * 4, 30, 100)// Add the item's force to its weight class and multiply by 4, then clamp the value between 30 and 100
		else
			return CLAMP(w_class * 6, 10, 100) // Multiply the item's weight class by 6, then clamp the value between 10 and 100

/mob/living/proc/send_item_attack_message(obj/item/I, mob/living/user, hit_area)
	var/message_verb = "attacked"
	if(user.used_intent)
		message_verb = "[pick(user.used_intent.attack_verb)]"
	else if(!I.force)
		return
	var/message_hit_area = ""
	if(hit_area)
		message_hit_area = " in the [hit_area]"
	var/attack_message = "[user] [message_verb] [src][message_hit_area] with [I]!"
	var/attack_message_local = "[user] [message_verb] me[message_hit_area] with [I]!"
	visible_message("<span class='danger'>[attack_message][next_attack_msg.Join()]</span>",\
		"<span class='danger'>[attack_message_local][next_attack_msg.Join()]</span>", null, COMBAT_MESSAGE_RANGE)
	next_attack_msg.Cut()
	return 1
