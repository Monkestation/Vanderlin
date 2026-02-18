/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/carbon/UnarmedAttack(atom/A, proximity, list/modifiers, atom/source)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return FALSE

	if(!has_active_hand()) //can't attack without a hand.
		to_chat(src, span_warning("I lack working hands."))
		return FALSE

	if(!has_hand_for_held_index(used_hand)) //can't attack without a hand.
		to_chat(src, span_warning("I can't move this hand."))
		return FALSE

	var/obj/item/grabbing/arm_grab = check_arm_grabbed(active_hand_index)
	if(arm_grab)
		// to_chat(src, span_warning("Someone is grabbing my arm!"))
		resist_grab()
		return TRUE

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines
	if(proximity && istype(G) && G.Touch(A,1))
		return TRUE
	//This signal is needed to prevent gloves of the north star + hulk.
	if(SEND_SIGNAL(src, COMSIG_HUMAN_EARLY_UNARMED_ATTACK, A, proximity) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	SEND_SIGNAL(src, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, A, proximity)
	var/rmb_stam_penalty = 1
	if(istype(rmb_intent, /datum/rmb_intent/strong) || istype(rmb_intent, /datum/rmb_intent/swift))
		rmb_stam_penalty = 1.5	//Uses a modifer instead of a flat addition, less than weapons no matter what rn. 50% extra stam cost basically.
	if(isliving(A))
		var/mob/living/L = A
		if(!used_intent.noaa)
			playsound(src, pick(GLOB.unarmed_swingmiss), 100, FALSE)
//			src.emote("attackgrunt")
		var/intent_drain = used_intent.get_releasedrain()
		adjust_stamina(ceil(intent_drain * rmb_stam_penalty))
		if(L.checkmiss(src))
			return TRUE
		if(!L.checkdefense(used_intent, src))
			if(LAZYACCESS(modifiers, RIGHT_CLICK))
				if(L.attack_hand_secondary(src, modifiers) != SECONDARY_ATTACK_CALL_NORMAL)
					return TRUE
			L.attack_hand(src, modifiers)
		return TRUE
	var/item_skip = FALSE
	if(isitem(A))
		var/obj/item/I = A
		if(I.w_class < WEIGHT_CLASS_GIGANTIC)
			item_skip = TRUE
	if(!item_skip)
		if(used_intent.type == INTENT_GRAB)
			var/obj/AM = A
			if(istype(AM) && !AM.anchored)
				start_pulling(A) //add params to grab bodyparts based on loc
				return TRUE
		if(used_intent.type == INTENT_DISARM)
			var/obj/AM = A
			if(istype(AM) && !AM.anchored)
				var/jadded = max(100-(STASTR*10),5)
				if(adjust_stamina(jadded))
					visible_message(span_info("[src] pushes [AM]."))
					PushAM(AM, MOVE_FORCE_STRONG)
				else
					visible_message(span_warning("[src] pushes [AM]."))
				changeNext_move(CLICK_CD_MELEE)
				return TRUE
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(A.attack_hand_secondary(src, modifiers) != SECONDARY_ATTACK_CALL_NORMAL)
			return TRUE
	A.attack_hand(src, modifiers)

/mob/living/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	user.changeNext_move(CLICK_CD_MELEE)

	if(user.cmode)
		if(user.rmb_intent)
			user.rmb_intent.special_attack(user, src)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		// Throw hands

/mob/living/carbon/human/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(user.cmode)
		return

	if(ishuman(src) && ishuman(user))
		var/mob/living/carbon/human/target = src
		var/datum/job/job = SSjob.GetJob(target.job)
		if(length(user.return_apprentices()) >= user.return_max_apprentices())
			return
		if((target.age == AGE_CHILD || job?.type == /datum/job/vagrant) && target.mind && !target.is_apprentice())
			to_chat(user, span_notice("You offer apprenticeship to [target]."))
			user.make_apprentice(target)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/turf/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	user.changeNext_move(CLICK_CD_MELEE)
	user.face_atom(src)
	if(user.cmode)
		if(user.rmb_intent)
			user.rmb_intent.special_attack(user, src)

/atom/proc/onkick(mob/user)
	return

/obj/item/onkick(mob/user)
	if(!ontable())
		if(w_class < WEIGHT_CLASS_HUGE)
			throw_at(get_ranged_target_turf(src, get_dir(user,src), 2), 2, 2, user, FALSE)

/mob/living/proc/bite(atom/A)
	if(SEND_SIGNAL(src, COMSIG_LIVING_PREBITE_SELF, A) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	var/finished_attack_chain = !A.onbite(src)
	SEND_SIGNAL(src, COMSIG_LIVING_POSTBITE_SELF, A, finished_attack_chain)
	return finished_attack_chain

/// Returns true to cancel further attacks doesn't call
/atom/proc/onbite(mob/living/user)
	. = FALSE
	if(!istype(user))
		return TRUE

/mob/living/onbite(mob/living/user)
	. = ..()
	if(.)
		return
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("I don't want to harm [src]!"))
		return TRUE
	var/datum/intent/bite/bitten = new()
	if(checkdefense(bitten, user))
		return TRUE

/mob/living/carbon/onbite(mob/living/user)
	. = ..()
	if(.)
		return
	if(user.pulling != src)
		if(!lying_attack_check(user))
			return TRUE

	var/def_zone = check_zone(user.zone_selected)
	var/obj/item/bodypart/affecting = get_bodypart(def_zone)
	if(!affecting)
		to_chat(user, span_warning("Nothing to bite."))
		return TRUE

	user.do_attack_animation(src, ATTACK_EFFECT_BITE, used_item = FALSE, atom_bounce = TRUE)
	next_attack_msg.Cut()

	var/dmg = user.STASTR*0.5
	dmg *= HAS_TRAIT(user, TRAIT_STRONGBITE) ? 2 : \
		affecting.has_wound(/datum/wound/bite) ? 1 : 0
	if(dmg)
		dmg = apply_damage(dmg, BRUTE, def_zone, run_armor_check(user.zone_selected, "stab", blade_dulling=BCLASS_BITE), user)
		if(dmg)
			affecting.bodypart_attacked_by(BCLASS_BITE, dmg, user, user.zone_selected, crit_message = TRUE)
			playsound(src, "smallslash", 100, TRUE, -1)
			if(HAS_TRAIT(user, TRAIT_POISONBITE) && src.reagents)
				var/poison = user.STACON/2
				src.reagents.add_reagent(/datum/reagent/toxin/venom, poison/2)
				src.reagents.add_reagent(/datum/reagent/medicine/soporpot, poison)
				to_chat(user, span_warning("Your fangs inject venom into [src]!"))
		else
			next_attack_msg += span_warning("Armor stops the damage.")

	visible_message(span_danger("[user] bites [src]'s [parse_zone(user.zone_selected)]![next_attack_msg.Join()]"), \
					span_userdanger("[user] bites my [parse_zone(user.zone_selected)]![next_attack_msg.Join()]"))
	next_attack_msg.Cut()

	var/obj/item/grabbing/bite/B = new()
	if(user.equip_to_slot_or_del(B, ITEM_SLOT_MOUTH))
		var/used_limb = src.find_used_grab_limb(user, accurate = TRUE)
		B.name = "[src]'s [parse_zone(used_limb)]"
		var/obj/item/bodypart/BP = get_bodypart(check_zone(used_limb))
		BP.grabbedby += B
		B.grabbed = src
		B.grabbee = user
		B.limb_grabbed = BP
		B.sublimb_grabbed = used_limb

		lastattacker = user.real_name
		lastattackerckey = user.ckey
		if(mind)
			mind.attackedme[user.real_name] = world.time
		log_combat(user, src, "bit")
	return !dmg

/mob/living/carbon/human/onbite(mob/living/user)
	. = ..()
	if(.)
		return
	var/obj/item/bodypart/affecting = get_bodypart(check_zone(user.zone_selected))
	if(!affecting)
		return TRUE // how tf did we lose it between the carbon proc and this one
	var/datum/wound/bite/open_wound = affecting.has_wound(/datum/wound/bite)
	if(!open_wound)
		return TRUE
	if(user.mind && mind)
		if(is_species(user, /datum/species/werewolf))
			var/mob/living/carbon/human/H = user
			if(HAS_TRAIT(src, TRAIT_SILVER_BLESSED))
				to_chat(user, span_warning("BLEH! [src] tastes of SILVER! My gift cannot take hold."))
			else
				open_wound.werewolf_infect_attempt()
				if(prob(30))
					H.werewolf_feed(src)
		if(user.mind.has_antag_datum(/datum/antagonist/zombie) && !src.mind.has_antag_datum(/datum/antagonist/zombie))
			INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/carbon/human, zombie_infect_attempt))


/mob/living/MiddleClickOn(atom/A, list/modifiers)
	..()
	if(!mmb_intent)
		if(!A.Adjacent(src))
			return
		A.MiddleClick(src, modifiers)
	else
		switch(mmb_intent.type)
			if(INTENT_KICK)
				if(src.usable_legs < 2)
					return
				if(!A.Adjacent(src))
					return
				if(A == src)
					var/list/mobs_here = list()
					for(var/mob/M in get_turf(src))
						if(M.invisibility || M == src)
							continue
						mobs_here += M
					if(mobs_here.len)
						A = pick(mobs_here)
					if(A == src) //auto aim couldn't select another target
						return
				if(IsOffBalanced())
					to_chat(src, span_warning("I haven't regained my balance yet."))
					return
				changeNext_move(mmb_intent.clickcd)
				face_atom(A)

				if(ismob(A))
					var/mob/living/M = A
					if(src.used_intent)

						do_attack_animation(M, visual_effect_icon = ATTACK_EFFECT_KICK, used_item = FALSE, atom_bounce = TRUE)
						playsound(src, pick(PUNCHWOOSH), 100, FALSE, -1)

						sleep(src.used_intent.swingdelay)
						if(QDELETED(src) || QDELETED(M))
							return
						if(!M.Adjacent(src))
							return
						if(src.incapacitated(IGNORE_GRAB))
							return
						if(M.checkmiss(src))
							return
						if(M.checkdefense(src.used_intent, src))
							return
					if(M.checkmiss(src))
						return
					if(!M.checkdefense(mmb_intent, src))
						if(ishuman(M))
							var/mob/living/carbon/human/H = M
							H.dna.species.kicked(src, H)
						else
							M.onkick(src)
							OffBalance(15) // Off balance for human enemies moved to dna.species.onkick
				else
					A.onkick(src)
					OffBalance(10)
				return
			if(INTENT_JUMP)
				jump_action(A)
			if(INTENT_BITE)
				if(!A.Adjacent(src))
					return
				if(A == src)
					return
				if(src.incapacitated(IGNORE_GRAB))
					return
				if(stat != CONSCIOUS)
					return
				if(is_mouth_covered())
					to_chat(src, span_warning("My mouth is blocked."))
					return
				if(HAS_TRAIT(src, TRAIT_NO_BITE))
					to_chat(src, span_warning("I can't bite."))
					return
				if(iscarbon(src))
					var/mob/living/carbon/C = src
					if(C.mouth)
						to_chat(src, span_warning("My mouth has something in it."))
						return
				changeNext_move(mmb_intent.clickcd)
				face_atom(A)
				bite(A)
				return
			if(INTENT_STEAL)
				steal_action(A)

//Return TRUE to cancel other attack hand effects that respect it.
/atom/proc/attack_hand(mob/user, list/modifiers)
	. = FALSE
	if(!(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_ATTACK_HAND))
		add_fingerprint(user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		. |= TRUE
	if(interaction_flags_atom & INTERACT_ATOM_ATTACK_HAND)
		. |= _try_interact(user)

/// When the user uses their hand on an item while holding right-click
/// Returns a SECONDARY_ATTACK_* value.
/atom/proc/attack_hand_secondary(mob/user, list/modifiers)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND_SECONDARY, user, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return SECONDARY_ATTACK_CALL_NORMAL

//Return a non FALSE value to cancel whatever called this from propagating, if it respects it.
/atom/proc/_try_interact(mob/user)
	if(IsAdminGhost(user))		//admin abuse
		return interact(user)
	if(can_interact(user))
		return interact(user)
	return FALSE

/atom/proc/can_interact(mob/user)
	if(!user.can_interact_with(src))
		return FALSE
	if((interaction_flags_atom & INTERACT_ATOM_REQUIRES_DEXTERITY) && !user.IsAdvancedToolUser())
		to_chat(user, span_warning("I don't have the dexterity to do this!"))
		return FALSE
	if(!(interaction_flags_atom & INTERACT_ATOM_IGNORE_INCAPACITATED))
		var/ignore_flags = NONE
		if(interaction_flags_atom & INTERACT_ATOM_IGNORE_RESTRAINED)
			ignore_flags |= IGNORE_RESTRAINTS
		if(!(interaction_flags_atom & INTERACT_ATOM_CHECK_GRAB))
			ignore_flags |= IGNORE_GRAB

		if(user.incapacitated(ignore_flags))
			return FALSE
	return TRUE

/atom/ui_status(mob/user)
	. = ..()
	if(!can_interact(user))
		. = min(., UI_UPDATE)

/atom/movable/can_interact(mob/user)
	. = ..()
	if(!.)
		return
	if(!anchored && (interaction_flags_atom & INTERACT_ATOM_REQUIRES_ANCHORED))
		return FALSE

/atom/proc/interact(mob/user)
	if(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_INTERACT)
		add_hiddenprint(user)
	else
		add_fingerprint(user)
	if(interaction_flags_atom & INTERACT_ATOM_UI_INTERACT)
		return ui_interact(user)
	return FALSE


/mob/living/carbon/human/RangedAttack(atom/A, list/modifiers)
	. = ..()
	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		if(istype(G) && G.Touch(A,0)) // for magic gloves
			return
	if(!used_intent.noaa && ismob(A))
		do_attack_animation(A, visual_effect_icon = used_intent.animname, used_item = FALSE, used_intent = used_intent)
		changeNext_move(used_intent.clickcd)
		playsound(src, used_intent.miss_sound, 100, FALSE)
		if(used_intent.miss_text)
			visible_message(span_warning("[src] [used_intent.miss_text]!"), \
							span_warning("I [used_intent.miss_text]!"))
		aftermiss()

/mob/living/proc/steal_action(atom/A)
	if(!A.Adjacent(src))
		return
	if(A == src)
		return
	if(ishuman(A))
		var/mob/living/carbon/human/thief = src
		var/mob/living/carbon/human/victim = A
		var/thiefskill = thief.get_skill_level(/datum/skill/misc/stealing) + (has_world_trait(/datum/world_trait/matthios_fingers) ? (is_ascendant(MATTHIOS) ? 2 : 1) : 0)
		var/thief_skill_base = thief.get_skill_level(/datum/skill/misc/stealing)
		if(thiefskill <= 0)
			thiefskill = 1
		if(thief.rogue_sneaking)
			thiefskill += 1
		var/stealroll = roll("[thiefskill]d6")
		var/target_perception = victim.STAPER
		var/target_skill = victim.get_skill_level(/datum/skill/misc/stealing)
		var/exp_to_gain = thief.STAINT * 1.5
		var/list/stealablezones = list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_NECK, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND)
		var/list/stealpos = list()
		if(client?.prefs.showrolls)
			to_chat(thief, span_info("Your stealing skill roll of [thiefskill]d6 is [stealroll]..."))
		if(stealroll >= target_perception)
			if(thief.get_active_held_item())
				to_chat(thief, span_warning("I can't pickpocket while my hand is full!"))
				return
			if(!(zone_selected in stealablezones))
				to_chat(thief, span_warning("What am I going to steal from there?"))
				return
			//2.5 seconds for those without skill
			//better skill shortens time, up to one second with legendary
			if(do_after(thief, (2.5 - (thief_skill_base * 0.25)) SECONDS, victim, progress = FALSE))
				switch(thief.zone_selected)
					if(BODY_ZONE_CHEST)
						if (victim.get_item_by_slot(ITEM_SLOT_BACK_L))
							stealpos.Add(victim.get_item_by_slot(ITEM_SLOT_BACK_L))
						if (victim.get_item_by_slot(ITEM_SLOT_BACK_R))
							stealpos.Add(victim.get_item_by_slot(ITEM_SLOT_BACK_R))
					if(BODY_ZONE_L_ARM)
						if (victim.get_item_by_slot(ITEM_SLOT_BACK_L))
							stealpos.Add(victim.get_item_by_slot(ITEM_SLOT_BACK_L))
					if(BODY_ZONE_R_ARM)
						if (victim.get_item_by_slot(ITEM_SLOT_BACK_R))
							stealpos.Add(victim.get_item_by_slot(ITEM_SLOT_BACK_R))
					if(BODY_ZONE_PRECISE_NECK)
						if (victim.get_item_by_slot(ITEM_SLOT_NECK))
							stealpos.Add(victim.get_item_by_slot(ITEM_SLOT_NECK))
					if(BODY_ZONE_PRECISE_GROIN)
						if (victim.get_item_by_slot(ITEM_SLOT_BELT_R))
							stealpos.Add(victim.get_item_by_slot(ITEM_SLOT_BELT_R))
						if (victim.get_item_by_slot(ITEM_SLOT_BELT_L))
							stealpos.Add(victim.get_item_by_slot(ITEM_SLOT_BELT_L))
					if(BODY_ZONE_L_ARM)
						if (victim.get_item_by_slot(ITEM_SLOT_BELT_L))
							stealpos.Add(victim.get_item_by_slot(ITEM_SLOT_BELT_L))
					if(BODY_ZONE_R_ARM)
						if (victim.get_item_by_slot(ITEM_SLOT_BELT_R))
							stealpos.Add(victim.get_item_by_slot(ITEM_SLOT_BELT_R))
					if(BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND)
						if (victim.get_item_by_slot(ITEM_SLOT_RING))
							stealpos.Add(victim.get_item_by_slot(ITEM_SLOT_RING))
				if(length(stealpos) > 0)
					var/obj/item/picked = pick(stealpos)
					if(HAS_TRAIT(picked, TRAIT_HARD_TO_STEAL))
						to_chat(thief, span_danger("[picked] is strapped on tight, I can't steal it!"))
						return

					victim.dropItemToGround(picked)
					put_in_active_hand(picked)
					to_chat(thief, span_green("I stole [picked]!"))
					log_combat(thief, victim, "stole [picked] from ")
					exp_to_gain += thief.get_learning_boon(thiefskill) * 5
					if(victim.client && victim.stat != DEAD)
						SEND_SIGNAL(thief, COMSIG_ITEM_STOLEN, victim)
						record_featured_stat(FEATURED_STATS_THIEVES, thief)
						record_featured_stat(FEATURED_STATS_CRIMINALS, thief)
						record_round_statistic(STATS_ITEMS_PICKPOCKETED)
						SEND_SIGNAL(src, COMSIG_PICKPOCKET_SUCCESS)
					if(has_quirk(/datum/quirk/vice/kleptomaniac))
						sate_addiction(/datum/quirk/vice/kleptomaniac)
				else
					exp_to_gain /= 2
					to_chat(thief, span_warning("I didn't find anything there. Perhaps I should look elsewhere."))
					log_combat(thief, victim, "tried to steal from ")
			else
				to_chat(thief, span_warning("I fumbled it!"))
				log_combat(thief, victim, "tried to steal from ")
		if(thief_skill_base <= target_skill)
			to_chat(victim, span_danger("Someone tried pickpocketing me!"))
			if(thief_skill_base >= 3)
				to_chat(thief, span_danger("[victim] probably realized I tried pickpocketing them!"))
		if(stealroll < target_perception)
			exp_to_gain /= 2
			to_chat(thief, span_danger("I failed to pick the pocket!"))
		thief.adjust_experience(/datum/skill/misc/stealing, exp_to_gain, FALSE)
		changeNext_move(mmb_intent.clickcd)

/mob/living/proc/jump_action(atom/A)
	if(istype(get_turf(src), /turf/open/water))
		to_chat(src, span_warning("I can't jump while floating."))
		return

	if(A == src || A == loc)
		return

	if(usable_legs < 2)
		return

	if(pulledby && pulledby != src)
		to_chat(src, span_warning("I'm being grabbed."))
		resist_grab()
		return

	if(IsOffBalanced())
		to_chat(src, span_warning("I haven't regained my balance yet."))
		return

	if(lying_angle)
		to_chat(src, span_warning("I should stand up first."))
		return

	if(!isatom(A))
		return

	if(A.z != z)
		if(!HAS_TRAIT(src, TRAIT_ZJUMP))
			to_chat(src, span_warning("That's too high for me..."))
			return

	changeNext_move(mmb_intent?.clickcd ? mmb_intent.clickcd : CLICK_CD_MELEE)

	face_atom(A)

	var/jadded
	var/jrange
	var/jextra = FALSE

	if(m_intent == MOVE_INTENT_RUN)
		emote("leap", forced = TRUE)
		OffBalance(30)
		jadded = 45
		jrange = 3
		jextra = TRUE
	else
		emote("jump", forced = TRUE)
		OffBalance(20)
		jadded = 20
		jrange = 2

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		jadded += H.get_complex_pain() / 50
		if(H.get_encumbrance() >= 0.7)
			jadded += 50
			jrange = 1

	jump_action_resolve(A, jadded, jrange, jextra)
	return TRUE

#define FLIP_DIRECTION_CLOCKWISE 1
#define FLIP_DIRECTION_ANTICLOCKWISE 0

/mob/living/proc/jump_action_resolve(atom/A, jadded, jrange, jextra)
	var/do_a_flip
	var/flip_direction = FLIP_DIRECTION_CLOCKWISE
	var/prev_pixel_z = pixel_z
	var/prev_transform = transform
	if(get_skill_level(/datum/skill/misc/athletics) > 4)
		do_a_flip = TRUE
		if((dir & SOUTH) || (dir & WEST))
			flip_direction = FLIP_DIRECTION_ANTICLOCKWISE

	if(adjust_stamina(min(jadded,100)))
		if(do_a_flip)
			var/flip_angle = flip_direction ? 120 : -120
			animate(src, pixel_z = pixel_z + 6, transform = turn(transform, flip_angle), time = 1)
			animate(transform = turn(transform, flip_angle), time=1)
			animate(pixel_z = prev_pixel_z, transform = turn(transform, flip_angle), time=1)
			animate(transform = prev_transform, time = 0)
		else
			animate(src, pixel_z = pixel_z + 6, time = 1)
			animate(pixel_z = prev_pixel_z, transform = turn(transform, pick(-12, 0, 12)), time=2)
			animate(transform = prev_transform, time = 0)

		if(jextra)
			throw_at(A, jrange, 1, src, spin = FALSE)
			while(src.throwing)
				sleep(1)
			throw_at(get_step(src, src.dir), 1, 1, src, spin = FALSE)
		else
			throw_at(A, jrange, 1, src, spin = FALSE)
			while(src.throwing)
				sleep(1)
		if(isopenturf(src.loc))
			var/turf/open/T = src.loc
			if(T.landsound)
				playsound(T, T.landsound, 100, FALSE)
			T.Entered(src)
	else
		animate(src, pixel_z = pixel_z + 6, time = 1)
		animate(pixel_z = prev_pixel_z, transform = turn(transform, pick(-12, 0, 12)), time=2)
		animate(transform = prev_transform, time = 0)
		throw_at(A, 1, 1, src, spin = FALSE)

#undef FLIP_DIRECTION_CLOCKWISE
#undef FLIP_DIRECTION_ANTICLOCKWISE

/*
	Animals & All Unspecified
*/
/mob/living/UnarmedAttack(atom/A, proximity_flag, list/modifiers, atom/source)
	if(!isliving(A))
		if(used_intent.type == INTENT_GRAB)
			var/obj/structure/AM = A
			if(istype(AM) && !AM.anchored)
				start_pulling(A) //add params to grab bodyparts based on loc
				return
		if(used_intent.type == INTENT_DISARM)
			var/obj/structure/AM = A
			if(istype(AM) && !AM.anchored)
				var/jadded = max(100-(STASTR*10),5)
				if(adjust_stamina(jadded))
					visible_message(span_info("[src] pushes [AM]."))
					PushAM(AM, MOVE_FORCE_STRONG)
				else
					visible_message(span_warning("[src] pushes [AM]."))
				return

	A.attack_animal(src)

/atom/proc/attack_animal(mob/user)
	SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_ANIMAL, user)

/*
	Monkeys
*/
/mob/living/carbon/monkey/UnarmedAttack(atom/A, proximity_flag, list/modifiers, atom/source)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		if(a_intent != INTENT_HARM || is_muzzled())
			return
		if(!iscarbon(A))
			return
		var/mob/living/carbon/victim = A
		var/obj/item/bodypart/affecting = null
		if(ishuman(victim))
			var/mob/living/carbon/human/human_victim = victim
			affecting = human_victim.get_bodypart(pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
		var/armor = victim.run_armor_check(affecting, "melee")
		if(prob(25))
			victim.visible_message("<span class='danger'>[src]'s bite misses [victim]!</span>",
				"<span class='danger'>You avoid [src]'s bite!</span>", "<span class='hear'>You hear jaws snapping shut!</span>", COMBAT_MESSAGE_RANGE, src)
			to_chat(src, "<span class='danger'>Your bite misses [victim]!</span>")
			return
		victim.apply_damage(rand(1, 3), BRUTE, affecting, armor)
		victim.visible_message("<span class='danger'>[name] bites [victim]!</span>",
			"<span class='userdanger'>[name] bites you!</span>", "<span class='hear'>You hear a chomp!</span>", COMBAT_MESSAGE_RANGE, name)
		to_chat(name, "<span class='danger'>You bite [victim]!</span>")
		if(armor >= 2)
			return
		return
	A.attack_paw(src)

/atom/proc/attack_paw(mob/user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_PAW, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	return FALSE

/*
	Brain
*/

/mob/living/brain/UnarmedAttack(atom/A, proximity_flag, list/modifiers, atom/source)//Stops runtimes due to attack_animal being the default
	return

/*
	Simple animals
*/

/mob/living/simple_animal/UnarmedAttack(atom/A, proximity, list/modifiers, atom/source)
	if(!dextrous)
		return ..()
	if(!ismob(A))
		A.attack_hand(src, modifiers)
		update_inv_hands()

/*
	Hostile animals
*/

/mob/living/simple_animal/hostile/UnarmedAttack(atom/A, proximity_flag, list/modifiers, atom/source)
	target = A
	if(dextrous && !ismob(A))
		..()
	else
		AttackingTarget(A)

/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/dead/new_player/ClickOn(atom/clicked_atom, params)
	return
