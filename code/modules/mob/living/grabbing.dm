// Sorry for what you're about to see. //

///////////OFFHAND///////////////
/obj/item/grabbing
	name = "pulling"
	icon_state = "pulling"
	icon = 'icons/mob/roguehudgrabs.dmi'
	w_class = WEIGHT_CLASS_HUGE
	possible_item_intents = list(/datum/intent/grab/upgrade)
	item_flags = ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	grab_state = 0 //this is an atom/movable var i guess
	no_effect = TRUE
	force = 0
	experimental_inhand = FALSE
	/// The atom that is currently being grabbed by [var/grabbee].
	var/atom/grabbed
	/// The carbon that is grabbing [var/grabbed]
	var/mob/living/carbon/grabbee
	var/obj/item/bodypart/limb_grabbed		//ref to actual bodypart being grabbed if we're grabbing a carbo
	var/sublimb_grabbed		//ref to what precise (sublimb) we are grabbing (if any) (text)
	var/list/dependents = list()
	var/handaction
	var/bleed_suppressing = 0.25 //multiplier for how much we suppress bleeding, can accumulate so two grabs means 25% bleeding
	var/chokehold = FALSE

/atom/movable //reference to all obj/item/grabbing
	var/list/grabbedby = list()

/turf
	var/list/grabbedby = list()

/obj/item/grabbing/Initialize()
	. = ..()
	START_PROCESSING(SSfastprocess, src)

/obj/item/grabbing/process()
	if(valid_check())
		if(sublimb_grabbed == BODY_ZONE_PRECISE_NECK && (grabbee && (grabbed.dir == turn(get_dir(grabbed,grabbee), 180))))
			chokehold = TRUE
		else
			chokehold = FALSE

/obj/item/grabbing/proc/valid_check()
	if(QDELETED(grabbee) || QDELETED(grabbed))
		grabbee?.stop_pulling(FALSE)
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
	grabbee.stop_pulling(FALSE)
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
		if(modifiers["right"])
			qdel(src)
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

/datum/proc/grabdropped(obj/item/grabbing/G)
	if(G)
		for(var/datum/D in G.dependents)
			if(D == src)
				G.dependents -= D

/obj/item/grabbing/proc/relay_cancel_action()
	if(handaction)
		for(var/datum/D in dependents) //stop fapping
			if(handaction == D)
				D.grabdropped(src)
		handaction = null

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
	if(isturf(grabbed))
		var/turf/T = grabbed
		T.grabbedby -= src
	if(grabbee)
		if(grabbee.r_grab == src)
			grabbee.r_grab = null
		if(grabbee.l_grab == src)
			grabbee.l_grab = null
		if(grabbee.mouth == src)
			grabbee.mouth = null
	for(var/datum/D in dependents)
		D.grabdropped(src)
	return ..()

/obj/item/grabbing/dropped(mob/living/user, show_message = TRUE)
	SHOULD_CALL_PARENT(FALSE)
	// Dont stop the pull if another hand grabs the person
	if(user.r_grab == src)
		if(user.l_grab && user.l_grab.grabbed == user.r_grab.grabbed)
			qdel(src)
			return
	if(user.l_grab == src)
		if(user.r_grab && user.r_grab.grabbed == user.l_grab.grabbed)
			qdel(src)
			return
	if(grabbed == user.pulling)
		user.stop_pulling(FALSE)
	if(!user.pulling)
		user.stop_pulling(FALSE)
	for(var/mob/M in user.buckled_mobs)
		if(M == grabbed)
			user.unbuckle_mob(M, force = TRUE)
	if(QDELETED(src))
		return
	qdel(src)

/mob/living/carbon/human/proc/attackhostage()
	if(!istype(hostagetaker.get_active_held_item(), /obj/item/weapon))
		return
	var/obj/item/weapon/WP = hostagetaker.get_active_held_item()
	WP.attack(src, hostagetaker)
	hostagetaker.visible_message("<span class='danger'>\The [hostagetaker] attacks \the [src] reflexively!</span>")
	hostagetaker.hostage = null
	hostagetaker = null

/obj/item/grabbing/attack(mob/living/M, mob/living/user)
	if(!valid_check())
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
	user.changeNext_move(CLICK_CD_MELEE)
	var/skill_diff = 0
	var/combat_modifier = 1
	if(user.mind)
		skill_diff += (user.get_skill_level(/datum/skill/combat/wrestling))
	if(M.mind)
		skill_diff -= (M.get_skill_level(/datum/skill/combat/wrestling))

	if(M.surrendering)																//If the target has surrendered
		combat_modifier = 2

	if(HAS_TRAIT(M, TRAIT_RESTRAINED))																//If the target is restrained
		combat_modifier += 0.25

	if(M.body_position == LYING_DOWN && user.body_position != LYING_DOWN) //We are on the ground, target is not
		combat_modifier += 0.1

	if(user.cmode && !M.cmode)
		combat_modifier += 0.3
	else if(!user.cmode && M.cmode)
		combat_modifier -= 0.3

	if(chokehold)
		combat_modifier += 0.15

	if(pulledby && pulledby.grab_state >= GRAB_AGGRESSIVE)
		combat_modifier -= 0.2

	combat_modifier *= ((skill_diff * 0.1) + 1)

	switch(user.used_intent.type)
		if(/datum/intent/grab/upgrade)
			if(!(M.status_flags & CANPUSH) || HAS_TRAIT(M, TRAIT_PUSHIMMUNE))
				to_chat(user, span_warning("I can't get a grip!"))
				return FALSE
			user.adjust_stamina(1) //main stamina consumption in grippedby() struggle
			if(M.grippedby(user)) // grab was strengthened
				bleed_suppressing = 0.5
		if(/datum/intent/grab/choke)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			if(limb_grabbed && grab_state > 0) //this implies a carbon victim
				if(iscarbon(M) && M != user)
					user.adjust_stamina(rand(1,3))
					var/mob/living/carbon/C = M
					if(get_location_accessible(C, BODY_ZONE_PRECISE_NECK))
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
						to_chat(user, span_warning("I can't reach [C]'s throat!"))
					user.changeNext_move(CLICK_CD_MELEE)
		if(/datum/intent/grab/hostage)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			if(limb_grabbed && grab_state > GRAB_PASSIVE) //this implies a carbon victim
				if(ishuman(M) && M != user)
					var/mob/living/carbon/human/H = M
					var/mob/living/carbon/human/U = user
					if(U.cmode)
						if(H.cmode)
							to_chat(U, "<span class='warning'>[H] is too prepared for combat to be taken hostage.</span>")
							return
						to_chat(U, "<span class='warning'>I take [H] hostage.</span>")
						to_chat(H, "<span class='danger'>[U] takes us hostage!</span>")

						U.swap_hand() // Swaps hand to weapon so you can attack instantly if hostage decides to resist

						U.hostage = H
						H.hostagetaker = U
		if(/datum/intent/grab/twist)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			if(limb_grabbed && grab_state > 0) //this implies a carbon victim
				if(iscarbon(M))
					user.adjust_stamina(rand(3,8))
					twistlimb(user)
		if(/datum/intent/grab/twistitem)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			if(limb_grabbed && grab_state > 0) //this implies a carbon victim
				if(ismob(M))
					user.adjust_stamina(rand(3,8))
					twistitemlimb(user)
		if(/datum/intent/grab/remove)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			if(isitem(sublimb_grabbed))
				user.adjust_stamina(rand(3,8))
				removeembeddeditem(user)
			else
				user.stop_pulling()
		if(/datum/intent/grab/shove)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			if(user.body_position == LYING_DOWN)
				to_chat(user, "<span class='warning'>I must stand up first.</span>")
				return
			if(M.body_position == LYING_DOWN)
				if(user.loc != M.loc)
					to_chat(user, "<span class='warning'>I must be on top of them.</span>")
					return
				if(src == user.r_grab)
					if(!user.l_grab || user.l_grab.grabbed != M)
						to_chat(user, span_warning("I must grab them with my left hand too."))
						return
				if(src == user.l_grab)
					if(!user.r_grab || user.r_grab.grabbed != M)
						to_chat(user, span_warning("I must grab them with my right hand too."))
						return
				user.adjust_stamina(rand(1,3))
				M.visible_message(span_danger("[user] pins [M] to the ground!"), \
								span_userdanger("[user] pins me to the ground!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
				M.Stun(max(20 + (skill_diff * 10) + (user.STASTR * 5) - (M.STACON * 5) * combat_modifier, 1))
				user.Immobilize(max(20 - skill_diff, 1))
				user.changeNext_move(max(20 - skill_diff, CLICK_CD_GRABBING))
				user.adjust_stamina(rand(3,8))
			else
				user.adjust_stamina(rand(5,15))
				if(prob(clamp((((4 + ((user.STASTR - (M.STACON+2))/2) + skill_diff) * 10 + rand(-5, 5)) * combat_modifier), 5, 95)))
					M.Knockdown(max(10 + (skill_diff * 2), 1))
					M.drop_all_held_items()
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
					user.dropItemToGround(src, force = TRUE, silent = TRUE)
					user.start_pulling(M, suppress_message = TRUE, accurate = TRUE)
				user.changeNext_move(CLICK_CD_GRABBING)
		if(/datum/intent/grab/disarm)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			var/obj/item/I
			if(sublimb_grabbed == BODY_ZONE_PRECISE_L_HAND && M.active_hand_index == 1)
				I = M.get_active_held_item()
			else
				if(sublimb_grabbed == BODY_ZONE_PRECISE_R_HAND && M.active_hand_index == 2)
					I = M.get_active_held_item()
				else
					I = M.get_inactive_held_item()
			user.adjust_stamina(rand(3,8))
			var/probby = clamp((((3 + (((user.STASTR - M.STACON)/4) + skill_diff)) * 10) * combat_modifier), 5, 95)
			if(I)
				if(M.mind)
					if(I.associated_skill)
						probby -= M.get_skill_level(I.associated_skill) * 5
				if(I.wielded)
					probby -= 20
				if(prob(probby))
					M.dropItemToGround(I, force = FALSE, silent = FALSE)
					user.dropItemToGround(src, force = TRUE, silent = TRUE)
					if(prob(probby))
						if(!QDELETED(I))
							user.put_in_active_hand(I)
							M.visible_message(span_danger("[user] takes [I] from [M]'s hand!"), \
										span_userdanger("[user] takes [I] from my hand!"), span_hear("I hear aggressive shuffling!"), COMBAT_MESSAGE_RANGE)
							playsound(src.loc, 'sound/combat/weaponr1.ogg', 100, FALSE, -1) //sound queue to let them know that they got disarmed
						user.changeNext_move(CLICK_CD_MELEE)//avoids instantly attacking with the new weapon
					else
						M.visible_message(span_danger("[user] disarms [M] of [I]!"), \
								span_userdanger("[user] disarms me of [I]!"), span_hear("I hear aggressive shuffling!"), COMBAT_MESSAGE_RANGE)
						M.changeNext_move(6)//slight delay to pick up the weapon
				else
					user.Immobilize(10)
					M.Immobilize(6)
					M.visible_message(span_warning("[user.name] struggles to disarm [M.name]!"), COMBAT_MESSAGE_RANGE)
					playsound(src.loc, 'sound/foley/struggle.ogg', 100, FALSE, -1)
					user.dropItemToGround(src, force = TRUE, silent = TRUE)
					user.start_pulling(M, suppress_message = TRUE, accurate = TRUE)
					user.changeNext_move(CLICK_CD_GRABBING)
			else
				to_chat(user, span_warning("They aren't holding anything in that hand!"))
				return
		if(/datum/intent/grab/armdrag)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			var/obj/item/I
			if(ispath(limb_grabbed.type, /obj/item/bodypart/l_arm))
				I = M.get_item_for_held_index(1)
			else
				I = M.get_item_for_held_index(2)
			user.adjust_stamina(rand(3,8))
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
					playsound(src.loc, 'sound/foley/struggle.ogg', 100, FALSE, -1)
					user.dropItemToGround(src, force = TRUE, silent = TRUE)
					user.start_pulling(M, suppress_message = TRUE, accurate = TRUE)
					user.changeNext_move(CLICK_CD_GRABBING)
			else
				to_chat(user, span_warning("They aren't holding anything in that hand!"))
				return

/obj/item/grabbing/proc/twistlimb(mob/living/user) //implies limb_grabbed and sublimb are things
	var/mob/living/carbon/C = grabbed
	var/armor_block = C.run_armor_check(limb_grabbed, "blunt")
	var/damage = user.get_punch_dmg()
	playsound(C.loc, "genblunt", 100, FALSE, -1)
	C.next_attack_msg.Cut()
	C.apply_damage(damage, BRUTE, limb_grabbed, armor_block)
	limb_grabbed.bodypart_attacked_by(BCLASS_TWIST, damage, user, sublimb_grabbed, crit_message = TRUE)
	C.visible_message("<span class='danger'>[user] twists [C]'s [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]</span>", \
					"<span class='userdanger'>[user] twists my [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]</span>", "<span class='hear'>I hear a sickening sound of pugilism!</span>", COMBAT_MESSAGE_RANGE, user)
	to_chat(user, "<span class='warning'>I twist [C]'s [parse_zone(sublimb_grabbed)].[C.next_attack_msg.Join()]</span>")
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
	playsound(C.loc, "genblunt", 100, FALSE, -1)
	C.apply_damage(damage*1.5, , Chead, armor_block)
	Chead.bodypart_attacked_by(BCLASS_SMASH, damage*1.5, H, crit_message=TRUE)
	H.apply_damage(damage, BRUTE, Hhead, armor_block_user)
	Hhead.bodypart_attacked_by(BCLASS_SMASH, damage/1.2, H, crit_message=TRUE)
	C.stop_pulling(TRUE)
	C.Immobilize(10)
	C.OffBalance(10)
	H.Immobilize(5)

	C.visible_message("<span class='danger'>[H] headbutts [C]'s [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]</span>", \
					"<span class='userdanger'>[H] headbutts my [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]</span>", "<span class='hear'>I hear a sickening sound of pugilism!</span>", COMBAT_MESSAGE_RANGE, H)
	to_chat(H, "<span class='warning'>I headbutt [C]'s [parse_zone(sublimb_grabbed)].[C.next_attack_msg.Join()]</span>")
	C.next_attack_msg.Cut()
	log_combat(H, C, "headbutted ")

/obj/item/grabbing/proc/twistitemlimb(mob/living/user) //implies limb_grabbed and sublimb are things
	var/mob/living/M = grabbed
	var/damage = rand(5,10)
	var/obj/item/I = sublimb_grabbed
	playsound(M.loc, "genblunt", 100, FALSE, -1)
	M.apply_damage(damage, BRUTE, limb_grabbed)
	M.visible_message("<span class='danger'>[user] twists [I] in [M]'s wound!</span>", \
					"<span class='userdanger'>[user] twists [I] in my wound!</span>", "<span class='hear'>I hear a sickening sound of pugilism!</span>", COMBAT_MESSAGE_RANGE)
	log_combat(user, M, "itemtwisted [sublimb_grabbed] ")

/obj/item/grabbing/proc/removeembeddeditem(mob/living/user) //implies limb_grabbed and sublimb are things
	var/mob/living/M = grabbed
	var/obj/item/bodypart/L = limb_grabbed
	playsound(M.loc, "genblunt", 100, FALSE, -1)
	log_combat(user, M, "itemremovedgrab [sublimb_grabbed] ")
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		var/obj/item/I = locate(sublimb_grabbed) in L.embedded_objects
		if(QDELETED(I) || QDELETED(L) || !L.remove_embedded_object(I))
			return FALSE
		L.receive_damage(I.embedding.embedded_unsafe_removal_pain_multiplier*I.w_class) //It hurts to rip it out, get surgery you dingus.
		user.dropItemToGround(src)
		user.put_in_hands(I)
		C.emote("paincrit", TRUE)
		playsound(C, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
		if(usr == src)
			user.visible_message("<span class='notice'>[user] rips [I] out of [user.p_their()] [L.name]!</span>", "<span class='notice'>I rip [I] from my [L.name].</span>")
		else
			user.visible_message("<span class='notice'>[user] rips [I] out of [C]'s [L.name]!</span>", "<span class='notice'>I rip [I] from [C]'s [L.name].</span>")
		sublimb_grabbed = limb_grabbed.body_zone
	else if(HAS_TRAIT(M, TRAIT_SIMPLE_WOUNDS))
		var/obj/item/I = locate(sublimb_grabbed) in M.simple_embedded_objects
		if(QDELETED(I) || !M.simple_remove_embedded_object(I))
			return FALSE
		M.apply_damage(I.embedding.embedded_unsafe_removal_pain_multiplier*I.w_class, BRUTE) //It hurts to rip it out, get surgery you dingus.
		user.dropItemToGround(src)
		user.put_in_hands(I)
		M.emote("paincrit", TRUE)
		playsound(M, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
		if(user == M)
			user.visible_message("<span class='notice'>[user] rips [I] out of [user.p_them()]self!</span>", "<span class='notice'>I remove [I] from myself.</span>")
		else
			user.visible_message("<span class='notice'>[user] rips [I] out of [M]!</span>", "<span class='notice'>I rip [I] from [src].</span>")
		sublimb_grabbed = M.simple_limb_hit(user.zone_selected)
	user.update_grab_intents(grabbed)
	return TRUE

/obj/item/grabbing/attack_turf(turf/T, mob/living/user)
	if(!valid_check())
		return
	user.changeNext_move(CLICK_CD_MELEE)
	switch(user.used_intent.type)
		if(/datum/intent/grab/move)
			if(isturf(T))
				user.Move_Pulled(T)
		if(/datum/intent/grab/smash)
			if(user.body_position == LYING_DOWN)
				to_chat(user, "<span class='warning'>I must stand.</span>")
				return
			if(limb_grabbed && grab_state > 0) //this implies a carbon victim
				if(isopenturf(T))
					if(iscarbon(grabbed))
						var/mob/living/carbon/C = grabbed
						if(!C.Adjacent(T))
							return FALSE
						if(C.body_position != LYING_DOWN)
							return
						playsound(C.loc, T.attacked_sound, 100, FALSE, -1)
						smashlimb(T, user)
				else if(isclosedturf(T))
					if(iscarbon(grabbed))
						var/mob/living/carbon/C = grabbed
						if(!C.Adjacent(T))
							return FALSE
						if(!(C.body_position != LYING_DOWN))
							return
						playsound(C.loc, T.attacked_sound, 100, FALSE, -1)
						smashlimb(T, user)

/obj/item/grabbing/attack_obj(obj/O, mob/living/user)
	if(!valid_check())
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(user.used_intent.type == /datum/intent/grab/smash)
		if(isstructure(O) && O.blade_dulling != DULLING_CUT)
			if(user.body_position == LYING_DOWN)
				to_chat(user, "<span class='warning'>I must stand.</span>")
				return
			if(limb_grabbed && grab_state > 0) //this implies a carbon victim
				if(iscarbon(grabbed))
					var/mob/living/carbon/C = grabbed
					if(!C.Adjacent(O))
						return FALSE
					playsound(C.loc, O.attacked_sound, 100, FALSE, -1)
					smashlimb(O, user)


/obj/item/grabbing/proc/smashlimb(atom/A, mob/living/user) //implies limb_grabbed and sublimb are things
	var/mob/living/carbon/C = grabbed
	var/armor_block = C.run_armor_check(limb_grabbed, "blunt")
	var/damage = user.get_punch_dmg()
	C.next_attack_msg.Cut()
	if(C.apply_damage(damage, BRUTE, limb_grabbed, armor_block))
		limb_grabbed.bodypart_attacked_by(BCLASS_BLUNT, damage, user, sublimb_grabbed, crit_message = TRUE)
		playsound(C.loc, "smashlimb", 100, FALSE, -1)
	else
		C.next_attack_msg += " <span class='warning'>Armor stops the damage.</span>"
	C.visible_message("<span class='danger'>[user] smashes [C]'s [limb_grabbed.name] into [A]![C.next_attack_msg.Join()]</span>", \
					"<span class='userdanger'>[user] smashes my [limb_grabbed.name] into [A]![C.next_attack_msg.Join()]</span>", "<span class='hear'>I hear a sickening sound of pugilism!</span>", COMBAT_MESSAGE_RANGE, user)
	to_chat(user, "<span class='warning'>I smash [C]'s [limb_grabbed.name] against [A].[C.next_attack_msg.Join()]</span>")
	C.next_attack_msg.Cut()
	log_combat(user, C, "limbsmashed [limb_grabbed] ")

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
		if(modifiers["right"])
			qdel(src)
			return 1
		var/_y = text2num(params2list(params)["icon-y"])
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
	user.do_attack_animation(C, ATTACK_EFFECT_BITE)
	C.next_attack_msg.Cut()
	if(C.apply_damage(damage, BRUTE, limb_grabbed, armor_block))
		playsound(C.loc, "smallslash", 100, FALSE, -1)
		limb_grabbed.bodypart_attacked_by(BCLASS_BITE, damage, user, sublimb_grabbed, crit_message = TRUE)
		var/datum/wound/caused_wound = limb_grabbed.bodypart_attacked_by(BCLASS_BITE, damage, user, sublimb_grabbed, crit_message = TRUE)
		if(user.mind)
			//TODO: Werewolf Signal
			if(user.mind.has_antag_datum(/datum/antagonist/werewolf))
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
							C.visible_message("<span class='danger'>[user] consumes [C]'s brain!</span>", \
								"<span class='userdanger'>[user] consumes my brain!</span>", "<span class='hear'>I hear a sickening sound of chewing!</span>", COMBAT_MESSAGE_RANGE, user)
							to_chat(user, "<span class='boldnotice'>Braaaaaains!</span>")
							if(!MOBTIMER_EXISTS(user, MT_ZOMBIETRIUMPH))
								user.adjust_triumphs(1)
								MOBTIMER_SET(user, MT_ZOMBIETRIUMPH)
							playsound(C.loc, 'sound/combat/fracture/headcrush (2).ogg', 100, FALSE, -1)
							if(C.client)
								GLOB.vanderlin_round_stats[STATS_LIMBS_BITTEN]++
							return
		if(HAS_TRAIT(user, TRAIT_POISONBITE))
			if(C.reagents)
				var/poison = user.STACON/2 //more peak species level, more poison
				C.reagents.add_reagent(/datum/reagent/toxin/venom, poison/2)
				C.reagents.add_reagent(/datum/reagent/medicine/soporpot, poison)
				to_chat(user, span_warning("Your fangs inject venom into [C]!"))
	else
		C.next_attack_msg += " <span class='warning'>Armor stops the damage.</span>"
	C.visible_message("<span class='danger'>[user] bites [C]'s [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]</span>", \
					"<span class='userdanger'>[user] bites my [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]</span>", "<span class='hear'>I hear a sickening sound of chewing!</span>", COMBAT_MESSAGE_RANGE, user)
	to_chat(user, "<span class='danger'>I bite [C]'s [parse_zone(sublimb_grabbed)].[C.next_attack_msg.Join()]</span>")
	C.next_attack_msg.Cut()
	if(C.client && C.stat != DEAD)
		GLOB.vanderlin_round_stats[STATS_LIMBS_BITTEN]++
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
		to_chat(user, "<span class='warning'>Sigh. It's not bleeding.</span>")
		return
	var/mob/living/carbon/C = grabbed
	if(C.dna?.species && (NOBLOOD in C.dna.species.species_traits))
		to_chat(user, "<span class='warning'>Sigh. No blood.</span>")
		return
	if(C.blood_volume <= 0)
		to_chat(user, "<span class='warning'>Sigh. No blood.</span>")
		return
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(istype(H.wear_neck, /obj/item/clothing/neck/psycross/silver))
			to_chat(user, "<span class='userdanger'>SILVER! HISSS!!!</span>")
			return
	last_drink = world.time
	user.changeNext_move(CLICK_CD_MELEE)

	if(user.mind && C.mind)
		var/datum/antagonist/vampire/VDrinker = user.mind.has_antag_datum(/datum/antagonist/vampire)
		var/datum/antagonist/vampire/VVictim = C.mind.has_antag_datum(/datum/antagonist/vampire)
		var/zomwerewolf = C.mind.has_antag_datum(/datum/antagonist/werewolf)
		if(!zomwerewolf)
			if(C.stat != DEAD)
				zomwerewolf = C.mind.has_antag_datum(/datum/antagonist/zombie)
		if(VDrinker)
			if(zomwerewolf)
				to_chat(user, "<span class='danger'>I'm going to puke...</span>")
				addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), rand(8 SECONDS, 15 SECONDS))
			else
				if(VVictim)
					to_chat(user, "<span class='warning'>I cannot drain vitae from a fellow nitewalker.</span>")
					return
				else if(C.vitae_pool > 500)
					C.blood_volume = max(C.blood_volume-45, 0)
					if(ishuman(C))
						var/mob/living/carbon/human/H = C
						if(H.virginity)
							to_chat(user, "<span class='love'>Virgin blood, delicious!</span>")
							var/mob/living/carbon/V = user
							V.add_stress(/datum/stressevent/vblood)
							var/used_vitae = 750

							if(C.vitae_pool >= 750)
								to_chat(user, "<span class='love'>...And empowering!</span>")
							else
								used_vitae = C.vitae_pool // We assume they're left with 250 vitae or less, so we take it all
								to_chat(user, "<span class='warning'>...But alas, only leftovers...</span>")
							VDrinker.adjust_vitae(used_vitae, used_vitae)
							C.vitae_pool -= used_vitae

						else
							VDrinker.adjust_vitae(500, 500)
							C.vitae_pool -= 500
				else
					to_chat(user, span_warning("No more vitae from this blood..."))
		else // Don't larp as a vampire, kids.
			to_chat(user, "<span class='warning'>I'm going to puke...</span>")
			addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), rand(8 SECONDS, 15 SECONDS))
	else
		if(user.mind) // We're drinking from a mob or a person who disconnected from the game
			if(user.mind.has_antag_datum(/datum/antagonist/vampire))
				var/datum/antagonist/vampire/VDrinker = user.mind.has_antag_datum(/datum/antagonist/vampire)
				C.blood_volume = max(C.blood_volume-45, 0)
				if(C.vitae_pool >= 250)
					VDrinker.adjust_vitae(250, 250)
				else
					to_chat(user, "<span class='warning'>And yet, not enough vitae can be extracted from them... Tsk.</span>")

	C.blood_volume = max(C.blood_volume-5, 0)
	C.handle_blood()

	playsound(user.loc, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)

	C.visible_message("<span class='danger'>[user] drinks from [C]'s [parse_zone(sublimb_grabbed)]!</span>", \
					"<span class='userdanger'>[user] drinks from my [parse_zone(sublimb_grabbed)]!</span>", "<span class='hear'>...</span>", COMBAT_MESSAGE_RANGE, user)
	to_chat(user, "<span class='warning'>I drink from [C]'s [parse_zone(sublimb_grabbed)].</span>")
	log_combat(user, C, "drank blood from ")

	if(ishuman(C) && C.mind)
		var/datum/antagonist/vampire/lord/VDrinker = user.mind.has_antag_datum(/datum/antagonist/vampire/lord)
		if(VDrinker && C.blood_volume <= BLOOD_VOLUME_SURVIVE)
			if(browser_alert(user, "Would you like to sire a new spawn?", "THE CURSE OF KAIN", DEFAULT_INPUT_CHOICES) != CHOICE_YES)
				to_chat(user, span_warning("I decide [C] is unworthy."))
			else
				user.visible_message(span_danger("Some dark energy begins to flow from [user] into [C]..."), span_userdanger("I begin siring [C]..."))
				if(do_after(user, 3 SECONDS, C))
					C.visible_message(span_red("[C] rises as a new spawn!"))
					var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire()
					C.mind.add_antag_datum(new_antag, VDrinker.team)
					// this is bad, should give them a healing buff instead
					sleep(2 SECONDS)
					C.fully_heal()
