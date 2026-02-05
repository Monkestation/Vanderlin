// Sorry for what you're about to see. //

/mob/living/carbon
	var/grab_fatigue = 0 // Accumulated fatigue from maintaining grabs

/mob/living/carbon/proc/add_grab_fatigue(amount = 1)
	grab_fatigue += amount
	if(grab_fatigue > 10) // High fatigue starts affecting performance
		adjust_stamina(max(grab_fatigue - 10, 1)) // Extra stamina drain

/datum/status_effect/buff/oiled
	id = "oiled"
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/oiled
	var/slip_chance = 3 // chance to slip when moving

/atom/movable/screen/alert/status_effect/oiled
	name = "Oiled"
	desc = "I'm covered in oil, making me slippery and harder to grab!"
	icon_state = "debuff"

/datum/status_effect/buff/oiled/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))

/datum/status_effect/buff/oiled/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

/datum/status_effect/buff/oiled/proc/on_move(mob/living/mover, atom/oldloc, direction, forced)
	if(forced || mover.movement_type & (FLYING|FLOATING) || mover.throwing)
		return

	var/slipping_prob = slip_chance
	if(iscarbon(mover))
		var/mob/living/carbon/carbon = mover
		if(!carbon.shoes) // being barefoot makes you slip lesss
			slipping_prob /= 2

	if(!prob(slip_chance))
		return

	if(istype(mover))
		if(is_jester_job(mover.mind?.assigned_role))
			mover.liquid_slip(total_time = 1 SECONDS, stun_duration = 1 SECONDS, height = 30, flip_count = 10)
		else
			mover.liquid_slip(total_time = 1 SECONDS, stun_duration = 1 SECONDS, height = 12, flip_count = 0)

/atom/proc/liquid_slip(total_time = 0.5 SECONDS, stun_duration = 0.5 SECONDS, height = 16, flip_count = 1)
	var/turn = 90
	if(dir == EAST)
		turn = 90
	else if(dir == WEST)
		turn = -90
	else if(prob(50))
		turn = -90

	if(isliving(src))
		var/mob/living/living = src
		living.Immobilize(total_time)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living, Knockdown), total_time), stun_duration)

	var/matrix/transform_before = transform
	var/flip_anim_step_time = total_time / (1 + 4 * flip_count)

	animate(src, transform = transform.Turn(turn), time = flip_anim_step_time, flags = ANIMATION_PARALLEL)

	if(flip_count)
		do_spin_animation(flip_anim_step_time, flip_count, 4)

	animate(transform = matrix().Scale(1.2, 0.7), time = total_time * 0.3)
	animate(transform = matrix(), time = total_time * 0.3)

	animate(src, pixel_z = height, time = total_time * 0.5, flags = ANIMATION_PARALLEL|ANIMATION_RELATIVE)
	animate(pixel_z = -height, time = total_time * 0.5, flags = ANIMATION_RELATIVE)

	animate(src, transform = transform_before, time = 0, flags = ANIMATION_PARALLEL)

///////////OFFHAND///////////////
/obj/item/grabbing
	name = "pulling"
	icon_state = "pulling"
	icon = 'icons/mob/roguehudgrabs.dmi'
	w_class = WEIGHT_CLASS_HUGE
	possible_item_intents = list(/datum/intent/grab/upgrade)
	item_flags = ABSTRACT | DROPDEL
	resistance_flags = EVERYTHING_PROOF
	grab_state = GRAB_PASSIVE //this is an atom/movable var i guess
	no_effect = TRUE
	force = 0
	experimental_inhand = FALSE
	/// The atom that is currently being grabbed by [var/grabbee].
	var/atom/grabbed
	/// The carbon that is grabbing [var/grabbed]
	var/mob/living/carbon/grabbee
	var/obj/item/bodypart/limb_grabbed		//ref to actual bodypart being grabbed if we're grabbing a carbo
	var/sublimb_grabbed		//ref to what precise (sublimb) we are grabbing (if any) (text)
	var/bleed_suppressing = 0.75 //multiplier for how much we suppress bleeding, can accumulate so two grabs means 25% bleeding
	var/chokehold = FALSE

/atom/movable //reference to all obj/item/grabbing
	var/list/grabbedby = list()

/obj/item/grabbing/Initialize()
	. = ..()
	START_PROCESSING(SSfastprocess, src)

/obj/item/grabbing/process()
	if(valid_check())
		if(grab_state > GRAB_PASSIVE && sublimb_grabbed == BODY_ZONE_PRECISE_NECK && ((grabbee && (grabbed.dir == turn(get_dir(grabbed,grabbee), 180))) || grabbee.body_position == LYING_DOWN))
			chokehold = TRUE
		else
			chokehold = FALSE

/obj/item/grabbing/proc/valid_check()
	if(QDELETED(grabbee) || QDELETED(grabbed))
		qdel(src)
		return FALSE
	// We should be conscious to do this, first of all...
	if(grabbee.stat < UNCONSCIOUS)
		// Mouth grab while we're adjacent is good
		if(grabbee.mouth == src && grabbee.Adjacent(grabbed))
			return TRUE
		// Other grab requires adjacency and pull status, unless we're grabbing ourselves
		if(grabbee.Adjacent(grabbed) && (grabbee.pulling == grabbed || grabbee == grabbed))
			return TRUE
	qdel(src)
	return FALSE

/obj/item/grabbing/Click(location, control, params)
	if(!valid_check())
		return
	var/list/modifiers = params2list(params)
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C != grabbee)
			qdel(src)
			return 1
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			downgrade_grab()
			return 1
	return ..()

/obj/item/grabbing/proc/update_hands(mob/user)
	if(!user)
		return
	if(!iscarbon(user))
		return
	var/mob/living/carbon/C = user
	for(var/i in 1 to C.held_items.len)
		var/obj/item/I = C.get_item_for_held_index(i)
		if(I == src)
			if(i == 1)
				C.r_grab = src
			else
				C.l_grab = src

/obj/item/grabbing/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	if(isobj(grabbed))
		var/obj/I = grabbed
		I.grabbedby -= src
	if(ismob(grabbed))
		var/mob/M = grabbed
		M.grabbedby -= src
		if(iscarbon(M) && sublimb_grabbed)
			var/mob/living/carbon/carbonmob = M
			var/obj/item/bodypart/part = carbonmob.get_bodypart(sublimb_grabbed)

			// Edge case: if a weapon becomes embedded in a mob, our "grab" will be destroyed...
			// In this case, grabbed will be the mob, and sublimb_grabbed will be the weapon, rather than a bodypart
			// This means we should skip any further processing for the bodypart
			if(part)
				part.grabbedby -= src
				part = null
				sublimb_grabbed = null

	. = ..()

	if(grabbee)
		// Dont stop the pull if another hand grabs the person
		var/stop_pull = TRUE
		if(grabbee.r_grab == src)
			if(grabbee.l_grab && grabbee.l_grab.grabbed == grabbee.r_grab.grabbed)
				stop_pull = FALSE
			grabbee.r_grab = null
		if(grabbee.l_grab == src)
			if(grabbee.r_grab && grabbee.r_grab.grabbed == grabbee.l_grab.grabbed)
				stop_pull = FALSE
			grabbee.l_grab = null

		if(stop_pull)
			grabbee.stop_pulling()
			for(var/mob/M as anything in grabbee.buckled_mobs)
				if(M == grabbed)
					grabbee.unbuckle_mob(M, force = TRUE)

/obj/item/grabbing/attack(mob/living/M, mob/living/user, list/modifiers)
	if(!valid_check() || !istype(M))
		return FALSE

	// Apply grab spam penalties
	var/spam_penalty = 1.0
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		spam_penalty = 1 + (C.grab_fatigue * 0.15)
		C.add_grab_fatigue(1)
	// Check for mutual grab breaking first
	if(M.mutual_grab_break())
		return FALSE

	if(M != grabbed)
		if(!istype(limb_grabbed, /obj/item/bodypart/head))
			return FALSE
		if(M != user)
			return FALSE
		if(!user.cmode)
			return FALSE
		user.changeNext_move(CLICK_CD_RESIST)
		headbutt(user)
		return

	// Apply positioning modifiers
	var/positioning_mod = user.get_positioning_modifier(M)

	user.changeNext_move(CLICK_CD_MELEE)
	var/skill_diff = 0
	var/combat_modifier = positioning_mod // Start with positioning

	if(user.mind)
		skill_diff += (user.get_skill_level(/datum/skill/combat/wrestling, TRUE))
	if(M.mind)
		skill_diff -= (M.get_skill_level(/datum/skill/combat/wrestling, TRUE))

	if(M.surrendering)
		combat_modifier *= 2

	if(HAS_TRAIT(M, TRAIT_RESTRAINED))
		combat_modifier += 0.25

	if(user.cmode && !M.cmode)
		combat_modifier += 0.3
	else if(!user.cmode && M.cmode)
		combat_modifier -= 0.3

	if(chokehold)
		combat_modifier += 0.15

	if(pulledby && pulledby.grab_state >= GRAB_AGGRESSIVE)
		combat_modifier -= 0.2

	// Apply spam penalty
	combat_modifier /= spam_penalty

	combat_modifier *= ((skill_diff * 0.1) + 1)

	var/static/list/mean_grabs = list(
		/datum/intent/grab/hostage,
		/datum/intent/grab/choke,
		/datum/intent/grab/twist,
		/datum/intent/grab/twistitem,
		/datum/intent/grab/shove
	)

	if(HAS_TRAIT(user, TRAIT_PACIFISM) && is_type_in_list(user.used_intent, mean_grabs))
		to_chat(user, span_warning("I don't want to harm [M]!"))
		return FALSE
	switch(user.used_intent.type)
		if(/datum/intent/grab/upgrade)
			if(!(M.status_flags & CANPUSH) || HAS_TRAIT(M, TRAIT_PUSHIMMUNE))
				to_chat(user, span_warning("I can't get a grip!"))
				return FALSE
			user.adjust_stamina(1 * spam_penalty) //main stamina consumption in grippedby() struggle
			if(M.grippedby(user)) // grab was strengthened
				bleed_suppressing = 0.5
		if(/datum/intent/grab/choke)
			if(limb_grabbed && grab_state > GRAB_PASSIVE) //this implies a carbon victim
				if(iscarbon(M) && M != user)
					user.adjust_stamina(rand(1,3) * spam_penalty)
					var/mob/living/carbon/C = M
					var/obj/item/clothing/neck/neck_armor = C.wear_neck
					var/throat_protected = FALSE
					if(neck_armor)
						throat_protected = (neck_armor.armor_class != ARMOR_CLASS_NONE)
					if(C.head && istype(C.head, /obj/item/clothing/head/helmet/heavy/necked))
						throat_protected = TRUE
					if(!throat_protected)
						if(prob(23))
							C.emote("choke")
						var/choke_damage = user.STASTR * 0.75 // this is too busted
						if(chokehold)
							choke_damage *= 1.2
						if(C.pulling == user && C.grab_state >= GRAB_AGGRESSIVE)
							choke_damage *= 0.95
						C.adjustOxyLoss(choke_damage)
						C.visible_message(span_danger("[user] [pick("chokes", "strangles")] [C][chokehold ? " with a chokehold" : ""]!"), \
								span_userdanger("[user] [pick("chokes", "strangles")] me[chokehold ? " with a chokehold" : ""]!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE, user)
						to_chat(user, span_danger("I [pick("choke", "strangle")] [C][chokehold ? " with a chokehold" : ""]!"))
					else
						to_chat(user, span_warning("[C]'s throat is covered!"))
					user.changeNext_move(CLICK_CD_MELEE)
		if(/datum/intent/grab/hostage)
			if(limb_grabbed && grab_state > GRAB_PASSIVE) //this implies a carbon victim
				if(ishuman(M) && M != user)
					var/mob/living/carbon/human/H = M
					var/mob/living/carbon/human/U = user
					if(!U.cmode)
						to_chat(U, span_warning("You need to be in combat mode first!"))
						return
					if(U.GetComponent(/datum/component/hostage))
						to_chat(U, span_warning("You already have someone hostage!"))
						return
					var/obj/item/offhand_item = U.get_inactive_held_item()
					if(!isitem(offhand_item) || !offhand_item.force)
						to_chat(U, span_warning("You need to hold a weapon in the other hand!"))
						return
					U.swap_hand() // Swaps hand to weapon so you can attack instantly if hostage decides to resist
					U.AddComponent(/datum/component/hostage, H, U.get_active_held_item())
					U.changeNext_move(CLICK_CD_GRABBING)
					H.changeNext_move(CLICK_CD_GRABBING)
		if(/datum/intent/grab/twist)
			if(limb_grabbed && grab_state > 0) //this implies a carbon victim
				if(iscarbon(M))
					user.adjust_stamina(rand(3,6) * spam_penalty)
					twistlimb(user)
		if(/datum/intent/grab/twistitem)
			if(limb_grabbed && grab_state > 0) //this implies a carbon victim
				if(ismob(M))
					user.adjust_stamina(rand(3,6) * spam_penalty)
					twistitemlimb(user)
		if(/datum/intent/grab/remove)
			if(isitem(sublimb_grabbed))
				user.adjust_stamina(rand(3,6) * spam_penalty)
				removeembeddeditem(user)
			else
				user.stop_pulling()
		if(/datum/intent/grab/shove)
			if(user.body_position == LYING_DOWN)
				to_chat(user, span_warning("I must stand up first."))
				return
			if(M.body_position == LYING_DOWN)
				if(user.loc != M.loc)
					to_chat(user, span_warning("I must be on top of them."))
					return
				if(src == user.r_grab)
					if(!user.l_grab || user.l_grab.grabbed != M)
						to_chat(user, span_warning("I must grab them with my left hand too."))
						return
				if(src == user.l_grab)
					if(!user.r_grab || user.r_grab.grabbed != M)
						to_chat(user, span_warning("I must grab them with my right hand too."))
						return
				M.visible_message(span_danger("[user] pins [M] to the ground!"), \
								span_userdanger("[user] pins me to the ground!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
				M.Stun(max(20 + (skill_diff * 10) + (user.STASTR * 5) - (M.STACON * 5) * combat_modifier, 1))
				user.Immobilize(max(20 - skill_diff, 1))
				user.changeNext_move(max(20 - skill_diff, CLICK_CD_GRABBING))
				user.adjust_stamina(rand(3,6) * spam_penalty)
			else
				user.adjust_stamina(rand(5,10) * spam_penalty)
				if(prob(clamp((((4 + ((user.STASTR - (M.STACON+2))/2) + skill_diff) * 10 + rand(-5, 5)) * combat_modifier), 5, 95)))
					M.Knockdown(max(10 + (skill_diff * 2), 1))
					M.set_resting(TRUE, TRUE)
					playsound(src,"genblunt",100,TRUE)
					if(user.l_grab && user.l_grab.grabbed == M && user.r_grab && user.r_grab.grabbed == M && user.r_grab.grab_state == GRAB_AGGRESSIVE )
						M.visible_message(span_danger("[user] throws [M] to the ground!"), \
						span_userdanger("[user] throws me to the ground!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
					else
						M.visible_message(span_danger("[user] tackles [M] to the ground!"), \
						span_userdanger("[user] tackles me to the ground!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
						user.set_resting(TRUE, TRUE)
				else
					M.visible_message(span_warning("[user] tries to shove [M]!"), \
									span_danger("[user] tries to shove me!"), span_hear("I hear aggressive shuffling!"), COMBAT_MESSAGE_RANGE)
					downgrade_grab(silent = TRUE)
				user.changeNext_move(CLICK_CD_GRABBING)
		if(/datum/intent/grab/disarm)
			var/obj/item/I
			if(sublimb_grabbed == BODY_ZONE_PRECISE_L_HAND && M.active_hand_index == 1)
				I = M.get_active_held_item()
			else
				if(sublimb_grabbed == BODY_ZONE_PRECISE_R_HAND && M.active_hand_index == 2)
					I = M.get_active_held_item()
				else
					I = M.get_inactive_held_item()
			user.adjust_stamina(rand(3,6) * spam_penalty)
			var/probby = clamp((((3 + (((user.STASTR - M.STACON)/4) + skill_diff)) * 10) * combat_modifier), 5, 95)
			if(I)
				if(M.mind)
					if(I.associated_skill)
						probby -= M.get_skill_level(I.associated_skill, TRUE) * 5
				if(HAS_TRAIT(I, TRAIT_WIELDED))
					probby -= 20
				if(prob(probby))
					M.dropItemToGround(I, force = FALSE, silent = FALSE)
					qdel(src)
					if(prob(probby))
						if(!QDELETED(I))
							user.put_in_active_hand(I)
							M.visible_message(span_danger("[user] takes [I] from [M]'s hand!"), \
										span_userdanger("[user] takes [I] from my hand!"), span_hear("I hear aggressive shuffling!"), COMBAT_MESSAGE_RANGE)
							playsound(src, 'sound/combat/weaponr1.ogg', 100, FALSE, -1) //sound queue to let them know that they got disarmed
						user.changeNext_move(CLICK_CD_MELEE)//avoids instantly attacking with the new weapon
					else
						M.visible_message(span_danger("[user] disarms [M] of [I]!"), \
								span_userdanger("[user] disarms me of [I]!"), span_hear("I hear aggressive shuffling!"), COMBAT_MESSAGE_RANGE)
						M.changeNext_move(6)//slight delay to pick up the weapon
				else
					user.Immobilize(10)
					M.Immobilize(6)
					M.visible_message(span_warning("[user.name] struggles to disarm [M.name]!"), COMBAT_MESSAGE_RANGE)
					playsound(src, 'sound/foley/struggle.ogg', 100, FALSE, -1)
					downgrade_grab(silent = TRUE)
					user.changeNext_move(CLICK_CD_GRABBING)
			else
				to_chat(user, span_warning("They aren't holding anything in that hand!"))
				return
		if(/datum/intent/grab/armdrag)
			var/obj/item/I
			if(ispath(limb_grabbed.type, /obj/item/bodypart/l_arm))
				I = M.get_item_for_held_index(1)
			else
				I = M.get_item_for_held_index(2)
			user.adjust_stamina(rand(3,6) * spam_penalty)
			var/probby = clamp((((3 + (((user.STASTR - M.STACON)/4) + skill_diff)) * 10) * combat_modifier), 5, 95)
			if(I)
				if(prob(probby))
					M.dropItemToGround(I, force = FALSE, silent = FALSE)
					M.visible_message(span_danger("[user] disarms [M] of [I]!"), \
							span_userdanger("[user] disarms me of [I]!"), span_hear("I hear aggressive shuffling!"), COMBAT_MESSAGE_RANGE)
					M.changeNext_move(6)//slight delay to pick up the weapon
					user.changeNext_move(6)
				else
					user.Immobilize(10)
					M.Immobilize(6)
					M.visible_message(span_warning("[user.name] struggles to disarm [M.name]!"), COMBAT_MESSAGE_RANGE)
					playsound(src, 'sound/foley/struggle.ogg', 100, FALSE, -1)
					downgrade_grab(silent = TRUE)
					user.changeNext_move(CLICK_CD_GRABBING)
			else
				to_chat(user, span_warning("They aren't holding anything in that hand!"))
				return
	user.do_attack_animation(M, used_item = src, item_animation_override = ATTACK_ANIMATION_THRUST)

/obj/item/grabbing/proc/twistlimb(mob/living/user) //implies limb_grabbed and sublimb are things
	var/mob/living/carbon/C = grabbed
	var/armor_block = C.run_armor_check(limb_grabbed, "blunt")
	var/damage = user.get_punch_dmg()
	playsound(C, "genblunt", 100, FALSE, -1)
	C.next_attack_msg.Cut()
	C.apply_damage(damage, BRUTE, limb_grabbed, armor_block)
	limb_grabbed.bodypart_attacked_by(BCLASS_TWIST, damage, user, sublimb_grabbed, crit_message = TRUE)
	C.visible_message(span_danger("[user] twists [C]'s [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]"), \
					span_userdanger("[user] twists my [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_warning("I twist [C]'s [parse_zone(sublimb_grabbed)].[C.next_attack_msg.Join()]"))
	C.next_attack_msg.Cut()
	log_combat(user, C, "limbtwisted [sublimb_grabbed] ")

/obj/item/grabbing/proc/headbutt(mob/living/carbon/human/H)
	var/mob/living/carbon/C = grabbed
	var/obj/item/bodypart/Chead = C.get_bodypart(BODY_ZONE_HEAD)
	var/obj/item/bodypart/Hhead = H.get_bodypart(BODY_ZONE_HEAD)
	var/armor_block = C.run_armor_check(Chead, "blunt")
	var/armor_block_user = H.run_armor_check(Hhead, "blunt")
	var/damage = H.get_punch_dmg()
	C.next_attack_msg.Cut()
	playsound(C, "genblunt", 100, FALSE, -1)
	C.apply_damage(damage*1.5, , Chead, armor_block)
	Chead.bodypart_attacked_by(BCLASS_SMASH, damage*1.5, H, crit_message=TRUE)
	H.apply_damage(damage, BRUTE, Hhead, armor_block_user)
	Hhead.bodypart_attacked_by(BCLASS_SMASH, damage/1.2, H, crit_message=TRUE)

	C.visible_message(span_danger("[H] headbutts [C]'s [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]"), \
					span_userdanger("[H] headbutts my [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE, H)
	to_chat(H, span_warning("I headbutt [C]'s [parse_zone(sublimb_grabbed)].[C.next_attack_msg.Join()]"))
	C.next_attack_msg.Cut()
	log_combat(H, C, "headbutted ")

	qdel(src)
	H.Immobilize(5)
	if(damage)
		C.Immobilize(10)
		C.OffBalance(10)
		for(var/i in 1 to C.held_items.len)
			var/obj/item/grabbing/grab = C.get_item_for_held_index(i)
			if(istype(grab) && grab.grabbee == C && grab.grabbed == H)
				qdel(grab)
				C.changeNext_move(10, i)
				break

/obj/item/grabbing/proc/twistitemlimb(mob/living/user) //implies limb_grabbed and sublimb are things
	var/mob/living/M = grabbed
	var/damage = rand(5,10)
	var/obj/item/I = sublimb_grabbed
	playsound(M, "genblunt", 100, FALSE, -1)
	M.apply_damage(damage, BRUTE, limb_grabbed)
	M.visible_message(span_danger("[user] twists [I] in [M]'s wound!"), \
					span_userdanger("[user] twists [I] in my wound!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
	log_combat(user, M, "itemtwisted [sublimb_grabbed] ")

/obj/item/grabbing/proc/removeembeddeditem(mob/living/user) //implies limb_grabbed and sublimb are things
	var/mob/living/M = grabbed
	var/obj/item/bodypart/L = limb_grabbed
	playsound(M, "genblunt", 100, FALSE, -1)
	log_combat(user, M, "itemremovedgrab [sublimb_grabbed] ")
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		var/obj/item/I = locate(sublimb_grabbed) in L.embedded_objects
		if(QDELETED(I) || QDELETED(L) || !L.remove_embedded_object(I))
			return FALSE
		L.receive_damage(I.embedding.embedded_unsafe_removal_pain_multiplier*I.w_class) //It hurts to rip it out, get surgery you dingus.
		qdel(src)
		user.put_in_hands(I)
		C.emote("paincrit", TRUE)
		playsound(C, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
		if(usr == src)
			user.visible_message(span_notice("[user] rips [I] out of [user.p_their()] [L.name]!"), span_notice("I rip [I] from my [L.name]."))
		else
			user.visible_message(span_notice("[user] rips [I] out of [C]'s [L.name]!"), span_notice("I rip [I] from [C]'s [L.name]."))
		sublimb_grabbed = limb_grabbed.body_zone
	else if(HAS_TRAIT(M, TRAIT_SIMPLE_WOUNDS))
		var/obj/item/I = locate(sublimb_grabbed) in M.simple_embedded_objects
		if(QDELETED(I) || !M.simple_remove_embedded_object(I))
			return FALSE
		M.apply_damage(I.embedding.embedded_unsafe_removal_pain_multiplier*I.w_class, BRUTE) //It hurts to rip it out, get surgery you dingus.
		qdel(src)
		user.put_in_hands(I)
		M.emote("paincrit", TRUE)
		playsound(M, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
		if(user == M)
			user.visible_message(span_notice("[user] rips [I] out of [user.p_them()]self!"), span_notice("I remove [I] from myself."))
		else
			user.visible_message(span_notice("[user] rips [I] out of [M]!"), span_notice("I rip [I] from [src]."))
		sublimb_grabbed = M.simple_limb_hit(user.zone_selected)
	update_grab_intents()
	return TRUE

/obj/item/grabbing/attack_atom(atom/attacked_atom, mob/living/user)
	. = TRUE
	if(!valid_check())
		return
	user.changeNext_move(CLICK_CD_MELEE)
	switch(user.used_intent.type)
		if(/datum/intent/grab/move)
			user.Move_Pulled(get_turf(attacked_atom))
		if(/datum/intent/grab/smash)
			if(!iscarbon(grabbed))
				return
			if(HAS_TRAIT(user, TRAIT_PACIFISM))
				to_chat(user, span_warning("I don't want to harm [grabbed]!"))
				return
			if(user.body_position == LYING_DOWN)
				to_chat(user, span_warning("I must stand."))
				return
			var/mob/living/carbon/C = grabbed
			if(!C.Adjacent(attacked_atom))
				return
			if(limb_grabbed && grab_state > 0) //this implies a carbon victim
				if(isopenturf(attacked_atom))
					if(C.body_position != LYING_DOWN)
						return
					playsound(C, attacked_atom.attacked_sound, 100, FALSE, -1)
					smashlimb(attacked_atom, user)
				else if(isclosedturf(attacked_atom))
					if(C.body_position == LYING_DOWN)
						return
					playsound(C, attacked_atom.attacked_sound, 100, FALSE, -1)
					smashlimb(attacked_atom, user)
				else if(isstructure(attacked_atom) && attacked_atom.blade_dulling != DULLING_CUT)
					playsound(C, attacked_atom.attacked_sound, 100, FALSE, -1)
					smashlimb(attacked_atom, user)

/obj/item/grabbing/proc/smashlimb(atom/A, mob/living/user) //implies limb_grabbed and sublimb are things
	var/mob/living/carbon/C = grabbed
	var/armor_block = C.run_armor_check(limb_grabbed, "blunt")
	var/damage = user.get_punch_dmg()
	C.next_attack_msg.Cut()
	if(C.apply_damage(damage, BRUTE, limb_grabbed, armor_block))
		limb_grabbed.bodypart_attacked_by(BCLASS_BLUNT, damage, user, sublimb_grabbed, crit_message = TRUE)
		playsound(C, "smashlimb", 100, FALSE, -1)
	else
		C.next_attack_msg += " <span class='warning'>Armor stops the damage.</span>"
	C.visible_message(span_danger("[user] smashes [C]'s [limb_grabbed.name] into [A]![C.next_attack_msg.Join()]"), \
					span_userdanger("[user] smashes my [limb_grabbed.name] into [A]![C.next_attack_msg.Join()]"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_warning("I smash [C]'s [limb_grabbed.name] against [A].[C.next_attack_msg.Join()]"))
	C.next_attack_msg.Cut()
	log_combat(user, C, "limbsmashed [limb_grabbed] ")

/obj/item/grabbing/proc/downgrade_grab(silent = FALSE)
	if(grab_state <= GRAB_PASSIVE)
		qdel(src)
		return
	grab_state = max(GRAB_PASSIVE, grab_state - 1)
	grabbee.setGrabState(max(grabbee.r_grab?.grab_state, grabbee.l_grab?.grab_state))
	grabbee.set_pull_offsets(grabbed, grabbee.grab_state)
	update_grab_intents()
	if(!silent)
		grabbee.visible_message(span_warning("[grabbee] loosens [grabbee.p_their()] grip on [grabbed]'s [limb_grabbed.name]."),\
							span_warning("I loosen my grip on [grabbed]'s [limb_grabbed.name]."),\
							vision_distance = COMBAT_MESSAGE_RANGE)

/obj/item/grabbing/proc/update_grab_intents()
	switch(grab_state)
		if(GRAB_PASSIVE)
			possible_item_intents = list(/datum/intent/grab/upgrade)
		else
			if(ismob(grabbed))
				if(isitem(sublimb_grabbed))
					var/obj/item/I = sublimb_grabbed
					possible_item_intents = I.grabbedintents(grabbee, grabbed, sublimb_grabbed)
				else
					if(iscarbon(grabbed) && limb_grabbed)
						var/obj/item/I = limb_grabbed
						possible_item_intents = I.grabbedintents(grabbee, grabbed, sublimb_grabbed)
					else
						var/mob/M = grabbed
						possible_item_intents = M.grabbedintents(grabbee, grabbed, sublimb_grabbed)
			if(isobj(grabbed))
				var/obj/I = grabbed
				possible_item_intents = I.grabbedintents(grabbee, grabbed, sublimb_grabbed)
			if(isturf(grabbed))
				var/turf/T = grabbed
				possible_item_intents = T.grabbedintents(grabbee, grabbed)
	grabbee.update_a_intents()

/datum/intent/grab
	unarmed = TRUE
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	no_attack = TRUE
	misscost = 2
	releasedrain = 2

/datum/intent/grab/move
	name = "grab move"
	desc = ""
	icon_state = "inmove"

/datum/intent/grab/upgrade
	name = "upgrade grab"
	desc = ""
	icon_state = "ingrab"

/datum/intent/grab/smash
	name = "smash"
	desc = ""
	icon_state = "insmash"

/datum/intent/grab/twist
	name = "twist"
	desc = ""
	icon_state = "intwist"

/datum/intent/grab/choke
	name = "choke"
	desc = ""
	icon_state = "inchoke"

/datum/intent/grab/hostage
	name = "hostage"
	desc = ""
	icon_state = "inhostage"

/datum/intent/grab/shove
	name = "shove"
	desc = ""
	icon_state = "intackle"

/datum/intent/grab/twistitem
	name = "twist in wound"
	desc = ""
	icon_state = "intwist"

/datum/intent/grab/remove
	name = "remove"
	desc = ""
	icon_state = "intake"

/datum/intent/grab/disarm
	name = "disarm"
	desc = ""
	icon_state = "intake"

/datum/intent/grab/armdrag
	name = "arm disarm"
	desc = ""
	icon_state = "intake"

/obj/item/grabbing/bite
	name = "bite"
	icon_state = "bite"
	slot_flags = ITEM_SLOT_MOUTH
	bleed_suppressing = 1
	var/last_drink

/obj/item/grabbing/bite/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(!valid_check())
		return
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C != grabbee)
			qdel(src)
			return 1
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			qdel(src)
			return 1
		var/_y = text2num(LAZYACCESS(modifiers, ICON_Y))
		if(_y>=17)
			bitelimb(C)
		else
			drinklimb(C)
	return 1

/obj/item/grabbing/bite/proc/bitelimb(mob/living/user) //implies limb_grabbed and sublimb are things
	if(!user.Adjacent(grabbed))
		qdel(src)
		return
	if(world.time <= user.next_move)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	var/mob/living/carbon/C = grabbed
	var/armor_block = C.run_armor_check(sublimb_grabbed, "stab")
	var/damage = user.get_punch_dmg()
	if(HAS_TRAIT(user, TRAIT_STRONGBITE))
		damage = damage*2
	user.do_attack_animation(C, ATTACK_EFFECT_BITE, used_item = FALSE)
	C.next_attack_msg.Cut()
	if(C.apply_damage(damage, BRUTE, limb_grabbed, armor_block))
		playsound(C, "smallslash", 100, FALSE, -1)
		var/datum/wound/caused_wound = limb_grabbed.bodypart_attacked_by(BCLASS_BITE, damage, user, sublimb_grabbed, crit_message = TRUE)
		if(user.mind)
			//TODO: Werewolf Signal
			var/datum/antagonist/werewolf/werewolf_antag = user.mind.has_antag_datum(/datum/antagonist/werewolf)
			if(werewolf_antag && werewolf_antag.transformed)
				var/mob/living/carbon/human/human = user
				if(istype(caused_wound))
					caused_wound?.werewolf_infect_attempt()
				if(prob(30))
					human.werewolf_feed(C)

			// TODO: Zombie Signal
			if(user.mind.has_antag_datum(/datum/antagonist/zombie))
				var/mob/living/carbon/human/H = C
				if(istype(H))
					INVOKE_ASYNC(H, TYPE_PROC_REF(/mob/living/carbon/human, zombie_infect_attempt))
				if(C.stat)
					if(istype(limb_grabbed, /obj/item/bodypart/head))
						var/obj/item/bodypart/head/HE = limb_grabbed
						if(HE.brain)
							QDEL_NULL(HE.brain)
							C.visible_message(span_danger("[user] consumes [C]'s brain!"), \
								span_userdanger("[user] consumes my brain!"), span_hear("I hear a sickening sound of chewing!"), COMBAT_MESSAGE_RANGE, user)
							to_chat(user, span_boldnotice("Braaaaaains!"))
							if(!MOBTIMER_EXISTS(user, MT_ZOMBIETRIUMPH))
								user.adjust_triumphs(1)
								MOBTIMER_SET(user, MT_ZOMBIETRIUMPH)
							playsound(C, 'sound/combat/fracture/headcrush (2).ogg', 100, FALSE, -1)
							if(C.client)
								record_round_statistic(STATS_LIMBS_BITTEN)
							return
		if(HAS_TRAIT(user, TRAIT_POISONBITE))
			if(C.reagents)
				var/poison = user.STACON/2 //more peak species level, more poison
				C.reagents.add_reagent(/datum/reagent/toxin/venom, poison/2)
				C.reagents.add_reagent(/datum/reagent/medicine/soporpot, poison)
				to_chat(user, span_warning("Your fangs inject venom into [C]!"))
	else
		C.next_attack_msg += " <span class='warning'>Armor stops the damage.</span>"
	C.visible_message(span_danger("[user] bites [C]'s [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]"), \
					span_userdanger("[user] bites my [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]"), span_hear("I hear a sickening sound of chewing!"), COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("I bite [C]'s [parse_zone(sublimb_grabbed)].[C.next_attack_msg.Join()]"))
	C.next_attack_msg.Cut()
	if(C.client && C.stat != DEAD)
		record_round_statistic(STATS_LIMBS_BITTEN)
	log_combat(user, C, "limb chewed [sublimb_grabbed] ")

//this is for carbon mobs being drink only
/obj/item/grabbing/bite/proc/drinklimb(mob/living/user) //implies limb_grabbed and sublimb are things
	if(!user.Adjacent(grabbed))
		qdel(src)
		return
	if(world.time <= user.next_move)
		return
	if(world.time < last_drink + 2 SECONDS)
		return
	if(!limb_grabbed.get_bleed_rate())
		to_chat(user, span_warning("Sigh. It's not bleeding."))
		return
	user.drinksomeblood(grabbed, sublimb_grabbed)
