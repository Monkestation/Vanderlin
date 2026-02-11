/mob/living/carbon/Initialize()
	. = ..()
	create_reagents(1000)
	update_body_parts() //to update the carbon's new bodyparts appearance
	GLOB.carbon_list += src

/mob/living/carbon/Destroy()
	//This must be done first, so the mob ghosts correctly before DNA etc is nulled
	. =  ..()

	QDEL_LIST(hand_bodyparts)
	QDEL_LIST(internal_organs)
	QDEL_LIST(bodyparts)
	QDEL_LIST(implants)
	QDEL_NULL(dna)
	GLOB.carbon_list -= src

/mob/living/carbon/ZImpactDamage(turf/T, levels)
	var/obj/item/bodypart/affecting
	if(prob(66))
		affecting = get_bodypart("[pick("r","l")]_leg")
		to_chat(src, "<span class='warning'>I land on my leg!</span>")
		if(affecting && apply_damage((levels * 10), BRUTE, affecting))		// 100 brute damage
			update_damage_overlays()
	else
		switch(rand(1,3))
			if(1)
				affecting = get_bodypart("[pick("r","l")]_arm")
				to_chat(src, "<span class='warning'>I land on my arm!</span>")
				if(affecting && apply_damage((levels * 10), BRUTE, affecting))		// 100 brute damage
					update_damage_overlays()
			if(2)
				affecting = get_bodypart("chest")
				to_chat(src, "<span class='warning'>I land on my chest!</span>")
				adjustOxyLoss(50)
				emote("breathgasp")
				if(affecting && apply_damage((levels * 10), BRUTE, affecting))		// 100 brute damage
					update_damage_overlays()
			if(3)
				affecting = get_bodypart("head")
				to_chat(src, "<span class='warning'>I land on my head!</span>")
				if(levels > 2)
					AdjustUnconscious(levels * 100)
					if(affecting && apply_damage((levels * 10), BRUTE, affecting))		// 100 brute damage
						update_damage_overlays()
				else
					if(affecting && apply_damage((levels * 10), BRUTE, affecting))		// 100 brute damage
						update_damage_overlays()

	AdjustStun(levels * 20)
	AdjustKnockdown(levels * 20)

/mob/living/carbon/swap_hand(held_index)
	if(!held_index)
		held_index = (active_hand_index % held_items.len)+1

	var/obj/item/item_in_hand = src.get_active_held_item()
	if(SEND_SIGNAL(src, COMSIG_MOB_SWAPPING_HANDS, item_in_hand) & COMPONENT_BLOCK_SWAP)
		to_chat(src, span_warning("My other hand is too busy holding [item_in_hand]."))
		return FALSE
	if(atkswinging || atkreleasing)
		stop_attack(FALSE)
	var/oindex = active_hand_index
	active_hand_index = held_index
	if(hud_used)
		hud_used.throw_icon?.update_appearance(UPDATE_ICON_STATE)
		hud_used.give_intent?.update_appearance(UPDATE_ICON_STATE)
		var/atom/movable/screen/inventory/hand/H
		H = hud_used.hand_slots["[oindex]"]
		if(H)
			H.update_appearance(UPDATE_OVERLAYS)
		H = hud_used.hand_slots["[held_index]"]
		if(H)
			H.update_appearance(UPDATE_OVERLAYS)
		H = hud_used.action_intent

	update_a_intents()

	return TRUE

/mob/living/carbon/activate_hand(selhand) //l/r OR 1-held_items.len
	if(!selhand)
		selhand = (active_hand_index % held_items.len)+1

	if(istext(selhand))
		selhand = lowertext(selhand)
		if(selhand == "right" || selhand == "r")
			selhand = 2
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != active_hand_index)
		swap_hand(selhand)
	else
		mode() // Activate held item

/mob/living/carbon/attackby(obj/item/I, mob/user, list/modifiers)
	if(!user.cmode && (istype(user.rmb_intent, /datum/rmb_intent/weak) || istype(user.rmb_intent, /datum/rmb_intent/strong)))
		var/try_to_fail = !istype(user.rmb_intent, /datum/rmb_intent/weak)
		var/list/possible_steps = list()
		for(var/datum/surgery_step/surgery_step as anything in GLOB.surgery_steps)
			if(!surgery_step.name)
				continue
			if(surgery_step.can_do_step(user, src, user.zone_selected, I, user.used_intent))
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
			if(done_step?.try_op(user, src, user.zone_selected, I, user.used_intent, try_to_fail))
				return TRUE
		if(I.item_flags & SURGICAL_TOOL)
			to_chat(user, span_warning("You're unable to perform surgery!"))
			return TRUE

	return ..()

/mob/living/carbon/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	var/hurt = TRUE
	if(hit_atom.density && isturf(hit_atom))
		if(hurt)
			if(IsOffBalanced())
				Paralyze(20)
			else
				Immobilize(1 SECONDS)
			if(prob(20))
				emote("scream") // lifeweb reference ?? xd
			take_bodypart_damage(10,check_armor = TRUE)
			playsound(src,"genblunt",100,TRUE)
	if(iscarbon(hit_atom) && hit_atom != src)
		var/mob/living/carbon/victim = hit_atom
		if(victim.movement_type & FLYING)
			return
		if(hurt)
			victim.take_bodypart_damage(10,check_armor = TRUE)
			take_bodypart_damage(10,check_armor = TRUE)
			if(victim.IsOffBalanced())
				victim.Knockdown(30)
			visible_message("<span class='danger'>[src] crashes into [victim]!",\
				"<span class='danger'>I violently crash into [victim]!</span>")
		playsound(src,"genblunt",100,TRUE)


//Throwing stuff
/mob/living/carbon/proc/toggle_throw_mode()
	if(stat)
		return
	if(in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()


/mob/living/carbon/proc/throw_mode_off()
	in_throw_mode = 0
	if(client && hud_used)
		hud_used.throw_icon?.throwy = 0
		hud_used.throw_icon?.update_appearance(UPDATE_ICON_STATE)


/mob/living/carbon/proc/throw_mode_on()
	in_throw_mode = 1
	if(client && hud_used)
		hud_used.throw_icon?.throwy = 1
		hud_used.throw_icon?.update_appearance(UPDATE_ICON_STATE)

/mob/proc/throw_item(atom/target, offhand = FALSE)
	SEND_SIGNAL(src, COMSIG_MOB_THROW, target)

/mob/living/carbon/throw_item(atom/target, offhand = FALSE)
	. = ..()
	throw_mode_off()
	if(!target || !isturf(loc))
		return
	if(istype(target, /atom/movable/screen))
		return

	var/atom/movable/thrown_thing
	var/thrown_speed
	var/thrown_range
	var/obj/item/I = get_active_held_item()
	if(offhand)
		I = get_inactive_held_item()

	var/used_sound
	var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
	var/turf/end_T = get_turf(target)

	if(I)
		if(istype(I, /obj/item/grabbing))
			if(pulling && pulling != src)
				if(isliving(pulling))
					var/mob/living/throwable_mob = pulling
					if(!throwable_mob.buckled)
						var/obj/item/grabbing/other_grab = offhand ? get_active_held_item() : get_inactive_held_item()
						if(grab_state < GRAB_AGGRESSIVE)
							stop_pulling(pulling_broke_free = TRUE)
							return
						stop_pulling(pulling_broke_free = TRUE)
						if(HAS_TRAIT(src, TRAIT_PACIFISM))
							to_chat(src, span_notice("I gently let go of [throwable_mob]."))
							return
						thrown_thing = throwable_mob
						thrown_speed = 1
						thrown_range = round((STASTR/throwable_mob.STACON)*2)
						if(body_position == LYING_DOWN || (!HAS_TRAIT(thrown_thing, TRAIT_TINY) && throwable_mob.cmode && (throwable_mob.body_position != LYING_DOWN || STASTR < 15)))
							while(end_T.z > start_T.z)
								end_T = GET_TURF_BELOW(end_T)
						if((end_T.z > start_T.z) && throwable_mob.cmode)
							thrown_range -= 1
						if(!istype(other_grab) || other_grab.grabbed != throwable_mob)
							thrown_range -= 1
						if(thrown_range <= 0)
							return
						if(start_T && end_T)
							log_combat(src, throwable_mob, "thrown", addition="grab from tile in [AREACOORD(start_T)] towards tile at [AREACOORD(end_T)]")
				else
					thrown_thing = pulling
					dropItemToGround(I, silent = TRUE)

		else if(!CHECK_BITFIELD(I.item_flags, ABSTRACT) && !HAS_TRAIT(I, TRAIT_NODROP))
			thrown_thing = I
			if(ismobholder(thrown_thing))
				var/obj/item/mob_holder/old = thrown_thing
				thrown_thing = thrown_thing:held_mob
				old.release()
				used_sound = pick(I.swingsound)
			else
				dropItemToGround(I, silent = TRUE)

			if(HAS_TRAIT(src, TRAIT_PACIFISM) && I.throwforce)
				to_chat(src, "<span class='notice'>I set [I] down gently on the ground.</span>")
				return


	if(thrown_thing)
		if(!thrown_speed)
			thrown_speed = thrown_thing.throw_speed
		if(!thrown_range)
			thrown_range = thrown_thing.throw_range
		visible_message("<span class='danger'>[src] throws [thrown_thing].</span>", \
						"<span class='danger'>I toss [thrown_thing].</span>")
		log_message("has thrown [thrown_thing]", LOG_ATTACK)
		thrown_thing.safe_throw_at(end_T, thrown_range, thrown_speed, src, null, null, null, move_force)
		if(!used_sound)
			used_sound = pick(PUNCHWOOSH)
		playsound(src, used_sound, 60, FALSE)

/mob/living/carbon/proc/canBeHandcuffed()
	return 0


/mob/living/carbon/show_inv(mob/user)
	user.set_machine(src)
	var/dat = {"
	<HR>
	<B><FONT size=3>[name]</FONT></B>
	<HR>
	<BR><B>Head:</B> <A href='byond://?src=[REF(src)];item=[ITEM_SLOT_HEAD]'>[(head && !(head.item_flags & ABSTRACT)) ? head : "Nothing"]</A>"}

	var/obscured = check_obscured_slots()

	if(obscured & ITEM_SLOT_NECK)
		dat += "<BR><B>Neck:</B> Obscured"
	else
		dat += "<BR><B>Neck:</B> <A href='byond://?src=[REF(src)];item=[ITEM_SLOT_NECK]'>[(wear_neck && !(wear_neck.item_flags & ABSTRACT)) ? (wear_neck) : "Nothing"]</A>"

	if(obscured & ITEM_SLOT_MASK)
		dat += "<BR><B>Mask:</B> Obscured"
	else
		dat += "<BR><B>Mask:</B> <A href='byond://?src=[REF(src)];item=[ITEM_SLOT_MASK]'>[(wear_mask && !(wear_mask.item_flags & ABSTRACT))	? wear_mask	: "Nothing"]</a>"

	for(var/i in 1 to held_items.len)
		var/obj/item/I = get_item_for_held_index(i)
		dat += "<BR><B>[get_held_index_name(i)]:</B> </td><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_HANDS];hand_index=[i]'>[(I && !(I.item_flags & ABSTRACT)) ? I : "Nothing"]</a>"

	if(handcuffed)
		dat += "<BR><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_HANDCUFFED]'>Handcuffed</A>"
	if(legcuffed)
		dat += "<BR><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_LEGCUFFED]'>Legcuffed</A>"

	var/datum/status_effect/bugged/effect = has_status_effect(/datum/status_effect/bugged)
	if(effect && HAS_TRAIT(user, TRAIT_INQUISITION))
		dat += "<BR><A href='?src=[REF(src)];item=[effect.device]'>BUGGED</A>"

	dat += {"
	<BR>
	<BR><A href='byond://?src=[REF(user)];mach_close=mob[REF(src)]'>Close</A>
	"}
	user << browse(dat, "window=mob[REF(src)];size=325x500")
	onclose(user, "mob[REF(src)]")

/mob/living/carbon/on_fall()
	. = ..()
	loc?.handle_fall(src)//it's loc so it doesn't call the mob's handle_fall which does nothing

/mob/living/carbon/is_muzzled()
	for(var/obj/item/clothing/clothing in get_equipped_items())
		if(clothing.clothing_flags & BLOCKS_SPEECH)
			return TRUE
	return FALSE

/obj/structure
	var/breakoutextra = 30 SECONDS

/mob/living/carbon/resist_buckle()
	if(HAS_TRAIT(src, TRAIT_RESTRAINED))
		changeNext_move(CLICK_CD_BREAKOUT)
		last_special = world.time + CLICK_CD_BREAKOUT
		var/buckle_cd = 1 MINUTES
		if(handcuffed)
			var/obj/item/restraints/O = src.get_item_by_slot(ITEM_SLOT_HANDCUFFED)
			buckle_cd = O.breakouttime
		if(istype(buckled, /obj/structure))
			var/obj/structure/S = buckled
			buckle_cd += S.breakoutextra
		if(STASTR > 15)
			buckle_cd = 3 SECONDS
		visible_message("<span class='warning'>[src] attempts to struggle free!</span>", \
					"<span class='notice'>I attempt to struggle free...</span>")
		if(do_after(src, buckle_cd, timed_action_flags = (IGNORE_HELD_ITEM)))
			if(!buckled)
				return
			buckled.user_unbuckle_mob(src,src)
		else
			if(src && buckled)
				to_chat(src, "<span class='warning'>I fail to struggle free!</span>")
	else
		buckled.user_unbuckle_mob(src,src)

/mob/living/carbon/resist_fire()
	fire_stacks = max(0, fire_stacks - 2.5)
	divine_fire_stacks = max(0, divine_fire_stacks - 2.5)
	if(fire_stacks + divine_fire_stacks > 10 || body_position == LYING_DOWN)
		Paralyze(50, ignore_canstun = TRUE)
		spin(32,2)
		fire_stacks = max(0, fire_stacks - 5)
		divine_fire_stacks = max(0, divine_fire_stacks - 5)
		visible_message("<span class='warning'>[src] rolls on the ground, trying to put [p_them()]self out!</span>")
	else
		visible_message("<span class='notice'>[src] pats the flames to extinguish them.</span>")
	sleep(30)
	if(fire_stacks + divine_fire_stacks <= 0)
		ExtinguishMob(TRUE)
	return

/mob/living/carbon/resist_restraints()
	var/obj/item/I = null
	var/type = 0
	if(handcuffed)
		I = handcuffed
		type = 1
	else if(legcuffed)
		I = legcuffed
		type = 2
	if(I)
		if(type == 1)
			changeNext_move(CLICK_CD_BREAKOUT)
			last_special = world.time + CLICK_CD_BREAKOUT
		if(type == 2)
			changeNext_move(CLICK_CD_RANGE)
			last_special = world.time + CLICK_CD_RANGE
		cuff_resist(I)


/mob/living/carbon/proc/cuff_resist(obj/item/I, breakouttime = 1 MINUTES, cuff_break = 0)
	if(I.item_flags & BEING_REMOVED)
		to_chat(src, span_warning("I'm already trying to get out of \the [I]\s!"))
		return
	I.item_flags |= BEING_REMOVED
	breakouttime = I.slipouttime
	if(STASTR > 10)
		cuff_break = FAST_CUFFBREAK
		breakouttime = I.breakouttime
	if(STASTR > 15 || (mind && mind.has_antag_datum(/datum/antagonist/zombie)) )
		cuff_break = INSTANT_CUFFBREAK
	if(!cuff_break)
		to_chat(src, span_notice("I try to get out of \the [I]\s..."))
		if(do_after(src, breakouttime, timed_action_flags = (IGNORE_HELD_ITEM)))
			clear_cuffs(I, cuff_break)
		else
			to_chat(src, span_danger("I fail to get out of \the [I]\s!"))

	else if(cuff_break == FAST_CUFFBREAK)
		to_chat(src, span_notice("I attempt to break \the [I]\s..."))
		if(do_after(src, breakouttime, timed_action_flags = (IGNORE_HELD_ITEM)))
			clear_cuffs(I, cuff_break)
		else
			to_chat(src, span_danger("I fail to break \the [I]\s!"))

	else if(cuff_break == INSTANT_CUFFBREAK)
		clear_cuffs(I, cuff_break)
	I.item_flags &= ~BEING_REMOVED

/mob/living/carbon/proc/uncuff()
	if (handcuffed)
		var/obj/item/W = handcuffed
		set_handcuffed(null)
		if (buckled && buckled.buckle_requires_restraints)
			buckled.unbuckle_mob(src)
		update_handcuffed()
		if (client)
			client.screen -= W
		if (W)
			W.forceMove(drop_location())
			W.dropped(src)
			if (W)
				W.layer = initial(W.layer)
				W.plane = initial(W.plane)
		changeNext_move(0)
	if (legcuffed)
		var/obj/item/W = legcuffed
		legcuffed = null
		remove_movespeed_modifier(MOVESPEED_ID_LEGCUFF_SLOWDOWN, TRUE)
		update_inv_legcuffed()
		if (client)
			client.screen -= W
		if (W)
			W.forceMove(drop_location())
			W.dropped(src)
			if (W)
				W.layer = initial(W.layer)
				W.plane = initial(W.plane)
		changeNext_move(0)

/mob/living/carbon/proc/clear_cuffs(obj/item/I, cuff_break)
	if(!I.loc || buckled)
		return FALSE
	if(I != handcuffed && I != legcuffed)
		return FALSE
	visible_message(span_danger("[src] manages to [cuff_break ? "break" : "remove"] [I]!"))
	to_chat(src, span_notice("You successfully [cuff_break ? "break" : "remove"] [I]."))

	if(istype(I, /obj/item/net))
		if(has_status_effect(/datum/status_effect/debuff/netted))
			remove_status_effect(/datum/status_effect/debuff/netted)

	if(cuff_break)
		. = !((I == handcuffed) || (I == legcuffed))
		qdel(I)
		return TRUE

	else
		if(I == handcuffed)
			handcuffed.forceMove(drop_location())
			handcuffed.dropped(src)
			set_handcuffed(null)
			if(buckled?.buckle_requires_restraints)
				buckled.unbuckle_mob(src)
			update_handcuffed()
			return TRUE
		if(I == legcuffed)
			legcuffed.forceMove(drop_location())
			legcuffed.dropped()
			legcuffed = null
			remove_movespeed_modifier(MOVESPEED_ID_LEGCUFF_SLOWDOWN, TRUE)
			update_inv_legcuffed()
			return TRUE

/mob/living/carbon/proc/accident(obj/item/I)
	if(!I || (I.item_flags & ABSTRACT) || HAS_TRAIT(I, TRAIT_NODROP))
		return

	dropItemToGround(I)

	var/modifier = 0

	switch(rand(1,100)+modifier) //91-100=Nothing special happens
		if(-INFINITY to 0) //attack yourself
			I.attack(src,src)
		if(1 to 30) //throw it at yourself
			I.throw_impact(src)
		if(31 to 60) //Throw object in facing direction
			var/turf/target = get_turf(loc)
			var/range = rand(2,I.throw_range)
			for(var/i = 1; i < range; i++)
				var/turf/new_turf = get_step(target, dir)
				target = new_turf
				if(new_turf.density)
					break
			I.throw_at(target,I.throw_range,I.throw_speed,src)
		if(61 to 90) //throw it down to the floor
			var/turf/target = get_turf(loc)
			I.safe_throw_at(target,I.throw_range,I.throw_speed,src, force = move_force)

/mob/living/carbon/proc/get_str_arms(num)
	if(!domhand || !num || HAS_TRAIT(src, TRAIT_DUALWIELDER))
		return STASTR
	var/used = STASTR
	if(num == domhand)
		return used
	else
		used = STASTR - 1
		if(used < 1)
			used = 1
		return used

/mob/living/get_status_tab_items()
	. = ..()
	. += "STR: \Roman[STASTR]"
	. += "PER: \Roman[STAPER]"
	. += "INT: \Roman[STAINT]"
	. += "CON: \Roman[STACON]"
	. += "END: \Roman[STAEND]"
	. += "SPD: \Roman[STASPD]"
	. += "PATRON: [uppertext(patron.name)]"

/mob/living/carbon/attack_ui(slot)
	if(!has_hand_for_held_index(active_hand_index))
		return 0
	return ..()

/mob/living/carbon/var/nausea = 0

/mob/living/carbon/proc/add_nausea(amt)
	nausea = clamp(nausea + amt, 0, 300)

/mob/living/carbon/proc/handle_nausea()
	if(HAS_TRAIT(src, TRAIT_ROTMAN))
		return TRUE
	if(stat == DEAD)
		return TRUE
	if(nausea <= 50 && MOBTIMER_EXISTS(src, MT_PUKE))
		MOBTIMER_UNSET(src, MT_PUKE)
	if(nausea >= 100)
		if(!MOBTIMER_EXISTS(src, MT_PUKE))
			MOBTIMER_SET(src, MT_PUKE)
			to_chat(src, span_warning("I feel sick..."))
		if(MOBTIMER_FINISHED(src, MT_PUKE, 16 SECONDS))
			if(getorgan(/obj/item/organ/stomach))
				MOBTIMER_SET(src, MT_PUKE)
				to_chat(src, span_warning("I'm going to puke..."))
				addtimer(CALLBACK(src, PROC_REF(vomit), 50), rand(8 SECONDS, 15 SECONDS))
		else
			if(prob(3))
				to_chat(src, span_warning("I feel sick..."))

	add_nausea(-1)

/mob/living/carbon/proc/vomit(lost_nutrition = 50, blood = FALSE, stun = TRUE, distance = 1, message = TRUE, toxic = FALSE, harm = FALSE, force = FALSE)
	if(HAS_TRAIT(src, TRAIT_TOXINLOVER) && !force)
		return TRUE

	MOBTIMER_SET(src, MT_PUKE)

	if(nutrition <= 50 && !blood)
		if(message)
			emote("gag")
		if(stun)
			Immobilize(50)
		return TRUE
	if(!blood)
		if(HAS_TRAIT(src, TRAIT_NOHUNGER))
			return TRUE
		add_nausea(-100)
		adjust_energy(-50)
		if(is_mouth_covered()) //make this add a blood/vomit overlay later it'll be hilarious
			if(message)
				visible_message("<span class='danger'>[src] throws up all over [p_them()]self!</span>", \
								"<span class='danger'>I puke all over myself!</span>")
				add_stress(/datum/stress_event/vomitself)
				if(iscarbon(src))
					var/mob/living/carbon/C = src
					C.add_stress(/datum/stress_event/vomitself)
					C.adjust_hygiene(-25)
			distance = 0
		else
			if(message)
				visible_message("<span class='danger'>[src] pukes!</span>", "<span class='danger'>I puke!</span>")
				add_stress(/datum/stress_event/vomit)
				if(iscarbon(src))
					var/mob/living/carbon/C = src
					C.add_stress(/datum/stress_event/vomit)
	else
		if(NOBLOOD in dna?.species?.species_traits)
			return TRUE
		if(message)
			visible_message("<span class='danger'>[src] coughs up blood!</span>", "<span class='danger'>I cough up blood!</span>")

	if(stun)
		Immobilize(59)

	if(!blood)
		playsound(src, pick('sound/vo/vomit.ogg','sound/vo/vomit_2.ogg'), 100, TRUE)
	else
		if(stat != DEAD)
			playsound(src, pick('sound/vo/throat.ogg','sound/vo/throat2.ogg','sound/vo/throat3.ogg'), 100, FALSE)

	set_eye_blur_if_lower(20 SECONDS)

	var/turf/T = get_turf(src)
	if(!blood)
		if(nutrition > 50)
			adjust_nutrition(-lost_nutrition)
			adjust_hydration(-lost_nutrition)
	if(harm)
		adjustBruteLoss(3)

	for(var/i=0 to distance)
		if(blood)
			if(T)
				bleed(5)
		else
			if(T)
				T.add_vomit_floor(src, VOMIT_TOXIC)//toxic barf looks different
		T = get_step(T, dir)
		if (is_blocked_turf(T))
			break
	return TRUE

/**
 * Expel the reagents you just tried to ingest
 *
 * When you try to ingest reagents but you do not have a stomach
 * you will spew the reagents on the floor.
 *
 * Vars:
 * * bite: /atom the reagents to expel
 * * amount: int The amount of reagent
 */
/mob/living/carbon/proc/expel_ingested(atom/bite, amount)
	visible_message("<span class='danger'>[src] throws up all over [p_them()]self!</span>", \
					"<span class='userdanger'>You are unable to keep the [bite] down without a stomach!</span>")

	var/turf/floor = get_turf(src)
	var/obj/effect/decal/cleanable/vomit/spew = new(floor)
	bite.reagents.trans_to(spew, amount, transfered_by = src)

/mob/living/carbon/proc/spew_organ(power = 5, amt = 1)
	for(var/i in 1 to amt)
		if(!internal_organs.len)
			break //Guess we're out of organs!
		var/obj/item/organ/guts = pick(internal_organs)
		var/turf/T = get_turf(src)
		guts.Remove(src)
		guts.forceMove(T)
		var/atom/throw_target = get_edge_target_turf(guts, dir)
		guts.throw_at(throw_target, power, 4, src)


/mob/living/carbon/fully_replace_character_name(oldname, newname)
	..()
	if(dna)
		dna.real_name = real_name

/mob/living/carbon/set_body_position(new_value)
	. = ..()
	if(isnull(.))
		return
	if(new_value == LYING_DOWN)
		add_movespeed_modifier(MOVESPEED_ID_CARBON_CRAWLING, TRUE, multiplicative_slowdown = CRAWLING_ADD_SLOWDOWN)
	else
		remove_movespeed_modifier(MOVESPEED_ID_CARBON_CRAWLING, TRUE)

//Updates the mob's health from bodyparts and mob damage variables
/mob/living/carbon/updatehealth(amount)
	if(status_flags & GODMODE)
		return
	var/total_burn	= 0
//	var/total_brute	= 0
	var/total_tox = getToxLoss()
	var/total_oxy = getOxyLoss()
	var/used_damage = 0
	var/static/list/lethal_zones = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
	)
	for(var/obj/item/bodypart/bodypart as anything in bodyparts) //hardcoded to streamline things a bit
		if(!(bodypart.body_zone in lethal_zones))
			continue
		var/my_burn = abs((bodypart.burn_dam / bodypart.max_damage) * DAMAGE_THRESHOLD_FIRE_CRIT)
		total_burn = max(total_burn, my_burn)
		used_damage = max(used_damage, my_burn)
	if(used_damage < total_tox)
		used_damage = total_tox
	if(used_damage < total_oxy)
		used_damage = total_oxy
	set_health(round(maxHealth - used_damage, DAMAGE_PRECISION))
	update_stat()

	if(stat == SOFT_CRIT)
		add_movespeed_modifier(MOVESPEED_ID_CARBON_SOFTCRIT, TRUE, multiplicative_slowdown = SOFTCRIT_ADD_SLOWDOWN)
	else
		remove_movespeed_modifier(MOVESPEED_ID_CARBON_SOFTCRIT, TRUE)
	SEND_SIGNAL(src, COMSIG_LIVING_HEALTH_UPDATE)

/mob/living/carbon/var/lightning_flashing = FALSE

/mob/living/carbon/update_sight()
	if(!client)
		return

	sight = initial(sight)
	lighting_alpha = initial(lighting_alpha)
	var/obj/item/organ/eyes/E = getorganslot(ORGAN_SLOT_EYES)
	if(!E)
		update_tint()
	else
		if(HAS_TRAIT(src, TRAIT_SEE_LEYLINES))
			see_invisible = SEE_INVISIBLE_LEYLINES
		else
			see_invisible = E.see_invisible
		see_in_dark = E.see_in_dark
		sight |= E.sight_flags
		if(!isnull(E.lighting_alpha))
			lighting_alpha = E.lighting_alpha

	if(lightning_flashing)
		lighting_alpha = min(lighting_alpha, LIGHTING_PLANE_ALPHA_INVISIBLE)

	if(client.eye != src)
		var/atom/A = client.eye
		if(A)
			if(A.update_remote_sight(src)) //returns 1 if we override all other sight updates.
				return

	if(HAS_TRAIT(src, TRAIT_BESTIALSENSE))
		lighting_alpha = min(lighting_alpha, LIGHTING_PLANE_ALPHA_DARKVISION)
		see_in_dark = max(see_in_dark, 4)

	if(HAS_TRAIT(src, TRAIT_DARKVISION))
		lighting_alpha = min(lighting_alpha, LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
		see_in_dark = max(see_in_dark, 6)

	if(HAS_TRAIT(src, TRAIT_THERMAL_VISION))
		sight |= (SEE_MOBS)
		lighting_alpha = min(lighting_alpha, LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)

	if(HAS_TRAIT(src, TRAIT_XRAY_VISION))
		sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
		see_in_dark = max(see_in_dark, 8)

	if(HAS_TRAIT(src, TRAIT_NOCSHADES))
		lighting_alpha = min(lighting_alpha, LIGHTING_PLANE_ALPHA_NOCSHADES)
		see_in_dark = max(see_in_dark, 12)
		add_client_colour(/datum/client_colour/nocshaded)
		overlay_fullscreen("inqvision", /atom/movable/screen/fullscreen/inqvision)
	else
		remove_client_colour(/datum/client_colour/nocshaded)
		clear_fullscreen("inqvision")

	if(see_override)
		see_invisible = see_override
	. = ..()


//to recalculate and update the mob's total tint from tinted equipment it's wearing.
/mob/living/carbon/proc/update_tint()
	if(!GLOB.tinted_weldhelh)
		return
	tinttotal = 0
	if(tinttotal >= TINT_BLIND)
		become_blind(EYES_COVERED)
	else if(tinttotal >= TINT_DARKENED)
		cure_blind(EYES_COVERED)
		overlay_fullscreen("tint", /atom/movable/screen/fullscreen/impaired, 2)
	else
		cure_blind(EYES_COVERED)
		clear_fullscreen("tint", 0)

/mob/living/carbon/proc/get_total_tint()
	. = 0
	if(isclothing(head))
		. += head.tint
	if(isclothing(wear_mask))
		. += wear_mask.tint

	var/obj/item/organ/eyes/E = getorganslot(ORGAN_SLOT_EYES)
	if(E)
		. += E.tint

	else
		. += INFINITY

/mob/living/carbon/get_permeability_protection(list/target_zones = list(HANDS,CHEST,GROIN,LEGS,FEET,ARMS,HEAD))
	var/list/tally = list()
	for(var/obj/item/I in get_equipped_items())
		for(var/zone in target_zones)
			if(I.body_parts_covered & zone)
				tally["[zone]"] = max(1 - I.permeability_coefficient, target_zones["[zone]"])
	var/protection = 0
	for(var/key in tally)
		protection += tally[key]
	protection *= INVERSE(target_zones.len)
	return protection

/mob/living
	var/succumb_timer = 0

//this handles hud updates
/mob/living/carbon/update_damage_hud()

	if(!client)
		return
	if(cmode)
		overlay_fullscreen("CMODE", /atom/movable/screen/fullscreen/crit/cmode)
	else
		clear_fullscreen("CMODE")

	if(health <= crit_threshold || ((blood_volume in -INFINITY to BLOOD_VOLUME_SURVIVE) && !HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE)))
		var/severity = 0
		switch(health)
			if(-20 to -10)
				severity = 1
			if(-30 to -20)
				severity = 2
			if(-40 to -30)
				severity = 3
			if(-50 to -40)
				severity = 4
			if(-50 to -40)
				severity = 5
			if(-60 to -50)
				severity = 6
			if(-70 to -60)
				severity = 7
			if(-90 to -70)
				severity = 8
			if(-95 to -90)
				severity = 9
			if(-INFINITY to -95)
				severity = 10
		if(!InFullCritical())
			var/visionseverity = 4
			switch(health)
				if(-8 to -4)
					visionseverity = 5
				if(-12 to -8)
					visionseverity = 6
				if(-16 to -12)
					visionseverity = 7
				if(-20 to -16)
					visionseverity = 8
				if(-24 to -20)
					visionseverity = 9
				if(-INFINITY to -24)
					visionseverity = 10
			overlay_fullscreen("critvision", /atom/movable/screen/fullscreen/crit/vision, visionseverity)
		else
			clear_fullscreen("critvision")
		if(!succumb_timer)
			succumb_timer = world.time
		overlay_fullscreen("crit", /atom/movable/screen/fullscreen/crit, severity)
		overlay_fullscreen("DD", /atom/movable/screen/fullscreen/crit/death)
		overlay_fullscreen("DDZ", /atom/movable/screen/fullscreen/crit/dying)
	else
		if(succumb_timer)
			succumb_timer = 0
		clear_fullscreen("crit")
		clear_fullscreen("critvision")
		clear_fullscreen("DD")
		clear_fullscreen("DDZ")
	if(hud_used)
		if(hud_used.stressies)
			hud_used.stressies.update_appearance(UPDATE_OVERLAYS)
//	if(blood_volume <= 0)
//		overlay_fullscreen("DD", /atom/movable/screen/fullscreen/crit/death)
//	else
//		clear_fullscreen("DD")

	//Oxygen damage overlay
	if(oxyloss)
		var/severity = 0
		switch(oxyloss)
			if(10 to 20)
				severity = 1
			if(20 to 25)
				severity = 2
			if(25 to 30)
				severity = 3
			if(30 to 35)
				severity = 4
			if(35 to 40)
				severity = 5
			if(40 to 45)
				severity = 6
			if(45 to INFINITY)
				severity = 7
		overlay_fullscreen("oxy", /atom/movable/screen/fullscreen/oxy, severity)
	else
		clear_fullscreen("oxy")

	var/hurtdamage = ((get_complex_pain() / (STAEND * 10)) * 100) //what percent out of 100 to max pain
	if(hurtdamage)
		var/severity = 0
		switch(hurtdamage)
			if(5 to 20)
				severity = 1
			if(20 to 40)
				severity = 2
			if(40 to 60)
				severity = 3
				overlay_fullscreen("painflash", /atom/movable/screen/fullscreen/painflash)
			if(60 to 80)
				severity = 4
				overlay_fullscreen("painflash", /atom/movable/screen/fullscreen/painflash, 1)
			if(80 to 99)
				severity = 5
				overlay_fullscreen("painflash", /atom/movable/screen/fullscreen/painflash, 2)
			if(99 to INFINITY)
				severity = 6
				overlay_fullscreen("painflash", /atom/movable/screen/fullscreen/painflash, 3)
		overlay_fullscreen("brute", /atom/movable/screen/fullscreen/brute, severity)
	else
		clear_fullscreen("brute")
		clear_fullscreen("painflash")

/mob/living/carbon/update_health_hud(shown_health_amount)
	if(!client || !hud_used)
		return
	if(hud_used.healths)
		if(stat != DEAD)
			. = 1
			if(shown_health_amount == null)
				shown_health_amount = health
			if(shown_health_amount >= maxHealth)
				hud_used.healths.icon_state = "health0"
			else if(shown_health_amount > maxHealth*0.8)
				hud_used.healths.icon_state = "health1"
			else if(shown_health_amount > maxHealth*0.6)
				hud_used.healths.icon_state = "health2"
			else if(shown_health_amount > maxHealth*0.4)
				hud_used.healths.icon_state = "health3"
			else if(shown_health_amount > maxHealth*0.2)
				hud_used.healths.icon_state = "health4"
			else if(shown_health_amount > 0)
				hud_used.healths.icon_state = "health5"
			else
				hud_used.healths.icon_state = "health6"
		else
			hud_used.healths.icon_state = "health7"

/mob/living/carbon/set_health(new_value)
	. = ..()
	if(. > hardcrit_threshold)
		if(health <= hardcrit_threshold && !HAS_TRAIT(src, TRAIT_NOHARDCRIT))
			ADD_TRAIT(src, TRAIT_KNOCKEDOUT, CRIT_HEALTH_TRAIT)
	else if(health > hardcrit_threshold)
		REMOVE_TRAIT(src, TRAIT_KNOCKEDOUT, CRIT_HEALTH_TRAIT)
	if(CONFIG_GET(flag/near_death_experience))
		if(. > HEALTH_THRESHOLD_NEARDEATH)
			if(health <= HEALTH_THRESHOLD_NEARDEATH && !HAS_TRAIT(src, TRAIT_NODEATH))
				ADD_TRAIT(src, TRAIT_SIXTHSENSE, "near-death")
		else if(health > HEALTH_THRESHOLD_NEARDEATH)
			REMOVE_TRAIT(src, TRAIT_SIXTHSENSE, "near-death")

/mob/living/carbon/update_stat()
	if(status_flags & GODMODE)
		return
	if(stat != DEAD)
		if(health <= HEALTH_THRESHOLD_DEAD && !HAS_TRAIT(src, TRAIT_NODEATH))
			INVOKE_ASYNC(src, PROC_REF(emote), "deathgurgle")
			death()
			return
		if(HAS_TRAIT(src, TRAIT_KNOCKEDOUT))
			set_stat(UNCONSCIOUS)
		else
			if(health <= crit_threshold && !HAS_TRAIT(src, TRAIT_NOSOFTCRIT))
				set_stat(SOFT_CRIT)
			else
				set_stat(CONSCIOUS)
	update_damage_hud()
	update_health_hud()
	update_spd()

//called when we get cuffed/uncuffed
/mob/living/carbon/proc/update_handcuffed()
	if(handcuffed)
		stop_pulling()
		throw_alert("handcuffed", /atom/movable/screen/alert/restrained/handcuffed, new_master = src.handcuffed)
		add_stress(/datum/stress_event/handcuffed)
	else
		clear_alert("handcuffed")
		remove_stress(/datum/stress_event/handcuffed)
	update_mob_action_buttons()
	update_inv_handcuffed()
	update_hud_handcuffed()

/mob/living/carbon/revive(full_heal_flags = NONE, excess_healing = 0, force_grab_ghost = FALSE)
	if(excess_healing)
		if(dna && !(NOBLOOD in dna.species.species_traits))
			blood_volume += (excess_healing * 2) //1 excess = 10 blood

		for(var/obj/item/organ/organ as anything in internal_organs)
			organ.applyOrganDamage(excess_healing * -1) //1 excess = 5 organ damage healed

	return ..()

/mob/living/carbon/fully_heal(heal_flags = HEAL_ALL)

	spill_embedded_objects()

	if(heal_flags & HEAL_ADMIN) //reset rot on admin revives
		var/datum/component/rot/corpse/CR = GetComponent(/datum/component/rot/corpse)
		if(CR)
			CR.amount = 0

	if(heal_flags & HEAL_LIMBS)
		regenerate_limbs()
		if(heal_flags & HEAL_ADMIN) //reset rot on admin revives
			for(var/obj/item/bodypart/bodypart as anything in bodyparts)
				bodypart.rotted = FALSE
				bodypart.skeletonized = FALSE

	if(heal_flags & (HEAL_REFRESH_ORGANS|HEAL_ORGANS))
		// regenerate_organs(regenerate_existing = (heal_flags & HEAL_REFRESH_ORGANS))
		regenerate_organs()
		var/obj/item/organ/brain/B = getorgan(/obj/item/organ/brain)
		if(B)
			B.brain_death = FALSE

	if(heal_flags & HEAL_TRAUMAS)
		cure_all_traumas(TRAUMA_RESILIENCE_MAGIC)

	if(heal_flags & HEAL_RESTRAINTS)
		QDEL_NULL(handcuffed)
		QDEL_NULL(legcuffed)
		set_handcuffed(null)
		update_handcuffed()

	drunkenness = 0

	return ..()

/mob/living/carbon/can_be_revived()
	if(!getorgan(/obj/item/organ/brain) && (!mind))
		return FALSE
	return ..()

/mob/living/carbon/harvest(mob/living/user)
	if(QDELETED(src))
		return
	var/organs_amt = 0
	for(var/obj/item/organ/O as anything in internal_organs)
		if(prob(50))
			organs_amt++
			O.Remove(src)
			O.forceMove(drop_location())
	if(organs_amt)
		to_chat(user, "<span class='notice'>I retrieve some of [src]'s internal organs!</span>")

/mob/living/carbon/ExtinguishMob(itemz = TRUE)
	if(itemz)
		for(var/obj/item/I as anything in get_equipped_items())
			I.acid_level = 0 //washes off the acid on our clothes
			I.extinguish() //extinguishes our clothes
		var/obj/item/I = get_active_held_item()
		if(I)
			I.extinguish()
		I = get_inactive_held_item()
		if(I)
			I.extinguish()
	..()

/mob/living/carbon/fakefire(fire_icon = "Generic_mob_burning")
	var/mutable_appearance/new_fire_overlay = mutable_appearance('icons/mob/OnFire.dmi', fire_icon, -FIRE_LAYER)
	new_fire_overlay.appearance_flags = RESET_COLOR
	overlays_standing[FIRE_LAYER] = new_fire_overlay
	apply_overlay(FIRE_LAYER)

/mob/living/carbon/fakefireextinguish()
	remove_overlay(FIRE_LAYER)

/mob/living/carbon/proc/create_bodyparts()
	var/l_arm_index_next = -1
	var/r_arm_index_next = 0
	for(var/bodypart_path in bodyparts)
		var/obj/item/bodypart/bodypart_instance = new bodypart_path()
		bodypart_instance.set_owner(src)
		bodyparts -= bodypart_path
		add_bodypart(bodypart_instance)
		switch(bodypart_instance.body_part)
			if(ARM_LEFT)
				l_arm_index_next += 2
				bodypart_instance.held_index = l_arm_index_next //1, 3, 5, 7...
				hand_bodyparts += bodypart_instance
			if(ARM_RIGHT)
				r_arm_index_next += 2
				bodypart_instance.held_index = r_arm_index_next //2, 4, 6, 8...
				hand_bodyparts += bodypart_instance

///Proc to hook behavior on bodypart additions.
/mob/living/carbon/proc/add_bodypart(obj/item/bodypart/new_bodypart)
	bodyparts += new_bodypart
	new_bodypart.set_owner(src)

	switch(new_bodypart.body_part)
		if(LEG_LEFT, LEG_RIGHT)
			set_num_legs(num_legs + 1)
			if(!new_bodypart.bodypart_disabled)
				set_usable_legs(usable_legs + 1)
		if(ARM_LEFT, ARM_RIGHT)
			set_num_hands(num_hands + 1)
			if(!new_bodypart.bodypart_disabled)
				set_usable_hands(usable_hands + 1)

///Proc to hook behavior on bodypart removals.
/mob/living/carbon/proc/remove_bodypart(obj/item/bodypart/old_bodypart)
	bodyparts -= old_bodypart

	switch(old_bodypart.body_part)
		if(LEG_LEFT, LEG_RIGHT)
			set_num_legs(num_legs - 1)
			if(!old_bodypart.bodypart_disabled)
				set_usable_legs(usable_legs - 1)
		if(ARM_LEFT, ARM_RIGHT)
			set_num_hands(num_hands - 1)
			if(!old_bodypart.bodypart_disabled)
				set_usable_hands(usable_hands - 1)

/mob/living/carbon/proc/create_internal_organs()
	for(var/obj/item/organ/I as anything in internal_organs)
		I.Insert(src)

/mob/living/carbon/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_BODYPART, "Modify bodypart")
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_ORGANS, "Modify organs")
	VV_DROPDOWN_OPTION(VV_HK_MARTIAL_ART, "Give Martial Arts")
	VV_DROPDOWN_OPTION(VV_HK_GIVE_TRAUMA, "Give Brain Trauma")
	VV_DROPDOWN_OPTION(VV_HK_CURE_TRAUMA, "Cure Brain Traumas")

/mob/living/carbon/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_MODIFY_BODYPART])
		if(!check_rights(R_SPAWN))
			return
		var/edit_action = input(usr, "What would you like to do?","Modify Body Part") as null|anything in list("add","remove", "augment")
		if(!edit_action)
			return
		var/list/limb_list = list()
		if(edit_action == "remove" || edit_action == "augment")
			for(var/obj/item/bodypart/B in bodyparts)
				limb_list += B.body_zone
			if(edit_action == "remove")
				limb_list -= BODY_ZONE_CHEST
		else
			limb_list = list(BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			for(var/obj/item/bodypart/B in bodyparts)
				limb_list -= B.body_zone
		var/result = input(usr, "Please choose which body part to [edit_action]","[capitalize(edit_action)] Body Part") as null|anything in sortList(limb_list)
		if(result)
			var/obj/item/bodypart/BP = get_bodypart(result)
			switch(edit_action)
				if("remove")
					if(BP)
						BP.drop_limb()
					else
						to_chat(usr, "<span class='boldwarning'>[src] doesn't have such bodypart.</span>")
				if("add")
					if(BP)
						to_chat(usr, "<span class='boldwarning'>[src] already has such bodypart.</span>")
					else
						if(!regenerate_limb(result))
							to_chat(usr, "<span class='boldwarning'>[src] cannot have such bodypart.</span>")
				if("augment")
					if(ishuman(src))
						if(BP)
							BP.change_bodypart_status(BODYPART_ROBOTIC, TRUE, TRUE)
						else
							to_chat(usr, "<span class='boldwarning'>[src] doesn't have such bodypart.</span>")
					else
						to_chat(usr, "<span class='boldwarning'>Only humans can be augmented.</span>")
		admin_ticket_log("[key_name_admin(usr)] has modified the bodyparts of [src]")
	if(href_list[VV_HK_MODIFY_ORGANS])
		if(!check_rights(NONE))
			return
		usr.client.manipulate_organs(src)
	if(href_list[VV_HK_MARTIAL_ART])
		if(!check_rights(NONE))
			return
		var/list/artpaths = subtypesof(/datum/martial_art)
		var/list/artnames = list()
		for(var/datum/martial_art/M as anything in artpaths)
			artnames[initial(M.name)] = M
		var/result = input(usr, "Choose the martial art to teach","JUDO CHOP") as null|anything in sortNames(artnames)
		if(!usr)
			return
		if(QDELETED(src))
			to_chat(usr, "<span class='boldwarning'>Mob doesn't exist anymore.</span>")
			return
		if(result)
			var/chosenart = artnames[result]
			var/datum/martial_art/MA = new chosenart
			MA.teach(src)
			log_admin("[key_name(usr)] has taught [MA] to [key_name(src)].")
			message_admins("<span class='notice'>[key_name_admin(usr)] has taught [MA] to [key_name_admin(src)].</span>")
	if(href_list[VV_HK_GIVE_TRAUMA])
		if(!check_rights(NONE))
			return
		var/list/traumas = subtypesof(/datum/brain_trauma)
		var/result = input(usr, "Choose the brain trauma to apply","Traumatize") as null|anything in sortList(traumas, GLOBAL_PROC_REF(cmp_typepaths_asc))
		if(!usr)
			return
		if(QDELETED(src))
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!result)
			return
		var/datum/brain_trauma/BT = gain_trauma(result)
		if(BT)
			log_admin("[key_name(usr)] has traumatized [key_name(src)] with [BT.name]")
			message_admins("<span class='notice'>[key_name_admin(usr)] has traumatized [key_name_admin(src)] with [BT.name].</span>")
	if(href_list[VV_HK_CURE_TRAUMA])
		if(!check_rights(NONE))
			return
		cure_all_traumas(TRAUMA_RESILIENCE_ABSOLUTE)
		log_admin("[key_name(usr)] has cured all traumas from [key_name(src)].")
		message_admins("<span class='notice'>[key_name_admin(usr)] has cured all traumas from [key_name_admin(src)].</span>")

/mob/living/carbon/can_resist()
	return bodyparts.len > 2 && ..()

/mob/living/carbon/proc/hypnosis_vulnerable()
	if(HAS_TRAIT(src, TRAIT_MINDSHIELD))
		return FALSE
	if(IsSleeping())
		return TRUE
	if(HAS_TRAIT(src, TRAIT_DUMB))
		return TRUE

/// Modifies the handcuffed value if a different value is passed, returning FALSE otherwise. The variable should only be changed through this proc.
/mob/living/carbon/proc/set_handcuffed(new_value)
	if(handcuffed == new_value)
		return FALSE
	. = handcuffed
	handcuffed = new_value
	if(.)
		if(!handcuffed)
			REMOVE_TRAIT(src, TRAIT_RESTRAINED, HANDCUFFED_TRAIT)
	else if(handcuffed)
		ADD_TRAIT(src, TRAIT_RESTRAINED, HANDCUFFED_TRAIT)

/mob/living/carbon/on_lying_down(new_lying_angle)
	. = ..()
	if(!buckled || buckled.buckle_lying != 0)
		lying_angle_on_lying_down(new_lying_angle)

/// Special carbon interaction on lying down, to transform its sprite by a rotation.
/mob/living/carbon/proc/lying_angle_on_lying_down(new_lying_angle)
	if(!new_lying_angle)
		set_lying_angle(pick(90, 270))
	else
		set_lying_angle(new_lying_angle)

/mob/living/carbon/can_speak_vocal()
	. = ..()
	if(!.)
		return
	if(mouth?.muteinmouth)
		return FALSE
	for(var/obj/item/grabbing/grab in grabbedby)
		if(grab.sublimb_grabbed == BODY_ZONE_PRECISE_MOUTH)
			return FALSE
	if(istype(loc, /turf/open/water) && body_position == LYING_DOWN)
		return FALSE

///Returns a list of all body_zones covered by clothing
/mob/living/carbon/proc/get_covered_body_zones()
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/covered_flags = NONE
	var/list/all_worn_items = get_all_worn_items(src)
	for(var/obj/item/worn_item in all_worn_items)
		covered_flags |= worn_item.body_parts_covered

	return body_parts_covered2organ_names(covered_flags)

/mob/living/carbon/proc/try_skin_burn(reaction_volume)
	var/list/covered_zones = get_covered_body_zones()

	var/successful_burns = 0
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(bodypart.body_zone in covered_zones)
			continue
		if(bodypart.acid_damage_intensity >= 1)
			continue
		if(!prob(100 - (successful_burns * 35)))
			continue

		if(prob(reaction_volume * 10))
			bodypart.acid_damage_intensity++

	update_body_parts(TRUE)

/mob/living/carbon/get_encumbrance()
	return round(get_total_weight() / get_carry_capacity(), 0.01)

/mob/living/carbon/human/dummy/get_total_weight()
	return 0

/mob/living/carbon/get_total_weight()
	var/held_weight = 0

	for(var/obj/item/worn_item as anything in (get_equipped_items(TRUE) + held_items))
		if(isnull(worn_item))
			continue
		var/modifier = 1
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			if(H.age == AGE_CHILD)
				modifier = 5
		if(HAS_TRAIT(src, TRAIT_HOLLOWBONES))
			modifier = 4
		if(isclothing(worn_item))
			switch(worn_item:armor_class)
				if(AC_HEAVY)
					if(!HAS_TRAIT(src, TRAIT_HEAVYARMOR))
						held_weight += worn_item.item_weight * 2 * modifier
					else
						held_weight += worn_item.item_weight * modifier
				if(AC_MEDIUM)
					if(!HAS_TRAIT(src, TRAIT_MEDIUMARMOR))
						held_weight += worn_item.item_weight * 2 * modifier
					else
						held_weight += worn_item.item_weight * modifier
				if(AC_LIGHT)
					held_weight += worn_item.item_weight
				else
					held_weight += worn_item.item_weight
		else
			held_weight += worn_item.item_weight
		held_weight += worn_item.get_stored_weight(HAS_TRAIT(src, TRAIT_AMAZING_BACK))

	return held_weight

/mob/living/carbon/encumbrance_to_dodge()
	var/encumbrance = get_encumbrance()
	if(!HAS_TRAIT(src, TRAIT_DODGEEXPERT))
		encumbrance *= 1.5
	if(encumbrance <= 0.3 && HAS_TRAIT(src, TRAIT_DODGEEXPERT))
		return 1
	if(encumbrance >= 1)
		return 0
	return 1 - (encumbrance * 1)

/mob/living/carbon/encumbrance_to_speed()
	var/exponential = (2.71 ** -(get_encumbrance() - 0.6)) * 10
	var/speed_factor = 1 / (1 + exponential)
	var/precentage =  CLAMP(speed_factor, 0, 1)

	add_movespeed_modifier("encumbrance", override = TRUE, multiplicative_slowdown = 5 * precentage)

/// skeletonize all limbs of a carbon mob, pass TRUE as an argument if it's lethal, FALSE if it's not.
/mob/living/carbon/proc/skeletonize(lethal = TRUE)
	for(var/obj/item/bodypart/B in bodyparts)
		B.skeletonize(lethal)
	update_body_parts()

/// grant undead eyes to a carbon mob.
/mob/living/carbon/proc/grant_undead_eyes()
	var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	var/eyecolor = eyes.eye_color
	var/eyesecond = eyes.second_color
	if(eyes)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)

	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.eye_color = eyecolor
	eyes.second_color = eyesecond
	eyes.Insert(src)

/mob/living/carbon/wash(clean_types)
	. = ..()

	// Wash equipped stuff that cannot be covered
	for(var/obj/item/held_thing in held_items)
		if(held_thing.wash(clean_types))
			. = TRUE


	// Check and wash stuff that can be covered
	var/obscured = check_obscured_slots()

	if(!(obscured & ITEM_SLOT_HEAD) && head?.wash(clean_types))
		update_inv_head()
		. = TRUE

	if(!(obscured & ITEM_SLOT_MASK) && wear_mask?.wash(clean_types))
		update_inv_wear_mask()
		. = TRUE

	if(!(obscured & ITEM_SLOT_NECK) && wear_neck?.wash(clean_types))
		update_inv_neck()
		. = TRUE

	if(!(obscured & ITEM_SLOT_SHOES) && shoes?.wash(clean_types))
		update_inv_shoes()
		. = TRUE

	if(!(obscured & ITEM_SLOT_GLOVES) && gloves?.wash(clean_types))
		update_inv_gloves()
		. = TRUE

/// beheads the carbon mob, if it doesn't find a head - return false.
/mob/living/carbon/proc/behead()
	var/obj/item/bodypart/head/to_dismember = get_bodypart(BODY_ZONE_HEAD)
	if(to_dismember)
		to_dismember.dismember()
		return TRUE
	return FALSE
