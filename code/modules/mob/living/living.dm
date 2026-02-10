/mob/living/New(loc, ...)
	. = ..()
	var/turf/turf = get_turf(loc)
	if(turf)
		if(!("[turf.z]" in GLOB.weatherproof_z_levels))
			if(SSmapping.level_has_any_trait(turf.z, list(ZTRAIT_IGNORE_WEATHER_TRAIT)))
				GLOB.weatherproof_z_levels |= "[turf.z]"
		if("[turf.z]" in GLOB.weatherproof_z_levels)
			faction |= FACTION_MATTHIOS
			SSmatthios_mobs.register_mob(src)
		if(SSterrain_generation.get_island_at_location(turf))
			faction |= "islander"
			SSisland_mobs.register_mob(src, SSterrain_generation.get_island_at_location(turf))

/mob/living/Initialize()
	. = ..()
	register_init_signals()
	update_a_intents()
	swap_rmb_intent(num=1)
	if(unique_name)
		name = "[name] ([rand(1, 1000)])"
		real_name = name
	faction += "[REF(src)]"
	GLOB.mob_living_list += src
	AddElement(/datum/element/movetype_handler)
	init_faith()
	if(has_reflection)
		create_reflection()
	recalculate_stats()

/mob/living/Destroy()
	if(FACTION_MATTHIOS in faction)
		SSmatthios_mobs.unregister_mob(src)
	if(cached_island_id)
		SSisland_mobs.remove_mob(src)

	surgeries = null
	if(LAZYLEN(status_effects))
		for(var/datum/status_effect/S as anything in status_effects)
			if(S.on_remove_on_mob_delete) //the status effect calls on_remove when its mob is deleted
				qdel(S)
			else
				S.be_replaced()
	if(buckled)
		buckled.unbuckle_mob(src,force=1)

	stop_offering_item()

	GLOB.mob_living_list -= src
	for(var/datum/soullink/S as anything in ownedSoullinks)
		S.ownerDies(FALSE)
		qdel(S) //If the owner is destroy()'d, the soullink is destroy()'d
	ownedSoullinks = null
	for(var/datum/soullink/S as anything in sharedSoullinks)
		S.sharerDies(FALSE)
		S.removeSoulsharer(src) //If a sharer is destroy()'d, they are simply removed
	sharedSoullinks = null
	return ..()

/mob/living/update_appearance(updates)
	. = ..()
	update_reflection()

/mob/living/proc/create_reflection()
	//Add custom reflection image
	reflective_icon = copy_appearance_filter_overlays(appearance)
	if(render_target)
		reflective_icon.render_source = render_target
	reflective_icon.plane = REFLECTION_PLANE
	reflective_icon.pixel_y = -32
	reflective_icon.transform = matrix().Scale(1, -1)
	reflective_icon.vis_flags = VIS_INHERIT_DIR
	//filters
	var/icon/I = icon('icons/turf/overlays.dmi', "whiteOverlay")
	I.Flip(NORTH)
	reflective_icon.filters += filter(type = "alpha", icon = I)
	add_overlay(reflective_icon)

/mob/living/carbon/human/dummy
	has_reflection = FALSE

/mob/living/carbon/human/dummy/update_reflection()
	return

/mob/living/proc/update_reflection()
	if(!has_reflection)
		return
	if(!reflective_icon)
		create_reflection()
	cut_overlay(reflective_icon)
	reflective_icon = copy_appearance_filter_overlays(appearance)
	if(render_target)
		reflective_icon.render_source = render_target
	reflective_icon.plane = REFLECTION_PLANE
	reflective_icon.pixel_y = -32
	reflective_icon.transform = matrix().Scale(1, -1)
	reflective_icon.vis_flags = VIS_INHERIT_DIR
	var/icon/I = icon('icons/turf/overlays.dmi', "whiteOverlay")
	I.Flip(NORTH)
	reflective_icon.filters += filter(type = "alpha", icon = I)
	add_overlay(reflective_icon)

/mob/living/onZImpact(turf/T, levels)
	if(SEND_SIGNAL(src, COMSIG_MOB_FALL_IMPACT, levels))
		return

	if(HAS_TRAIT(src, TRAIT_NOFALLDAMAGE2))
		return
	if(HAS_TRAIT(src, TRAIT_NOFALLDAMAGE1))
		if(levels <= 2)
			return
	if(movement_type & FLYING)
		to_chat(src, span_info("You glide down to a more manageable height."))
		playsound(src, 'sound/mobs/wingflap.ogg', 75, FALSE)
		return
	var/dex_save = src.get_skill_level(/datum/skill/misc/climbing)
	if(dex_save >= 5) // Master climbers can fall down 2 levels without hurting themselves
		if(levels <= 2)
			to_chat(src, span_info("My dexterity allowed me to land on my feet unscathed!"))
			if(m_intent != MOVE_INTENT_SNEAK) // If we're sneaking, don't make a sound
				playsound(src, 'sound/foley/bodyfall (1).ogg', 100, FALSE)
			return
	var/points
	for(var/i in 2 to levels)
		i++
		points += "!"
	visible_message(span_danger("[src] falls down[points]"), span_danger("I fall down[points]"))
	playsound(src, 'sound/foley/zfall.ogg', 100, FALSE)
	if(!isgroundlessturf(T))
		ZImpactDamage(T, levels)
		record_round_statistic(STATS_MOAT_FALLERS)
	return ..()

/mob/living/proc/ZImpactDamage(turf/T, levels)
	if(!density) //lets cats and similar avoid death by falling
		visible_message("<span class='notice'>The creature lands unharmed...</span>")
		return
	var/encumberance_multiplier = 0.5 * (get_encumbrance() + 1) // half base falling damage. scale up to 100% based on encumberance
	adjustBruteLoss(((levels * 10) * encumberance_multiplier) ** 1.5)
	AdjustStun(levels * 2 SECONDS * encumberance_multiplier)
	AdjustKnockdown(levels * 2 SECONDS * encumberance_multiplier)

/mob/living/proc/OpenCraftingMenu()
	return

//Generic Bump(). Override MobBump() and ObjBump() instead of this.
/mob/living/Bump(atom/A)
	if(..()) //we are thrown onto something
		return
	if (buckled || now_pushing)
		return
	if(ismob(A))
		var/mob/M = A
		if(MobBump(M))
			return
	if(isobj(A))
		var/obj/O = A
		if(ObjBump(O))
			return
	if(ismovableatom(A))
		var/atom/movable/AM = A
		if(PushAM(AM, move_force))
			return

/mob/living/Bumped(atom/movable/AM)
	..()
	last_bumped = world.time

//Called when we bump onto a mob
/mob/living/proc/MobBump(mob/M)
	//Even if we don't push/swap places, we "touched" them, so spread fire
	spreadFire(M)

	if(now_pushing)
		return TRUE

	var/they_can_move = TRUE
	if(isliving(M))
		var/mob/living/L = M
		they_can_move = !HAS_TRAIT(L, TRAIT_IMMOBILIZED)

		//Should stop you pushing a restrained person out of the way
		if(L.pulledby && L.pulledby != src && L.pulledby != L && HAS_TRAIT(L, TRAIT_RESTRAINED))
			if(!(world.time % 5))
				to_chat(src, "<span class='warning'>[L] is restrained, you cannot push past.</span>")
			return TRUE

		if(L.pulling)
			if(ismob(L.pulling) && L.pulling != L)
				var/mob/P = L.pulling
				if(!(world.time % 5))
					to_chat(src, "<span class='warning'>[L] is grabbing [P], you cannot push past.</span>")
				return TRUE

	if(moving_diagonally)//no mob swap during diagonal moves.
		return TRUE

	if(!M.buckled && !M.has_buckled_mobs())
		var/mob_swap = FALSE
		var/too_strong = (M.move_resist > move_force) //can't swap with immovable objects unless they help us
		if(!they_can_move) //we have to physically move them
			if(!too_strong)
				mob_swap = FALSE
		else
			//You can swap with the person you are dragging on grab intent, and restrained people in most cases
			if(M.pulledby == src && !too_strong)
				mob_swap = FALSE
			else if(
				!( HAS_TRAIT(M, TRAIT_NOMOBSWAP) || HAS_TRAIT(src, TRAIT_NOMOBSWAP) ) &&\
				( (HAS_TRAIT(M, TRAIT_RESTRAINED) && !too_strong) ) &&\
				( HAS_TRAIT(src, TRAIT_RESTRAINED) )
				)
				mob_swap = FALSE
		if(mob_swap)
			//switch our position with M
			if(loc && !loc.Adjacent(M.loc))
				return TRUE
			now_pushing = 1
			var/oldloc = loc
			var/oldMloc = M.loc


			var/M_passmob = (M.pass_flags & PASSMOB) // we give PASSMOB to both mobs to avoid bumping other mobs during swap.
			var/src_passmob = (pass_flags & PASSMOB)
			M.pass_flags |= PASSMOB
			pass_flags |= PASSMOB

			var/move_failed = FALSE
			if(!M.Move(oldloc) || !Move(oldMloc))
				M.forceMove(oldMloc)
				forceMove(oldloc)
				move_failed = TRUE
			if(!src_passmob)
				pass_flags &= ~PASSMOB
			if(!M_passmob)
				M.pass_flags &= ~PASSMOB

			now_pushing = 0

			if(!move_failed)
				return TRUE

	if(m_intent == MOVE_INTENT_RUN && dir == get_dir(src, M))
		if(isliving(M))
			var/sprint_distance = sprinted_tiles
			var/instafail = FALSE
			toggle_rogmove_intent(MOVE_INTENT_WALK, TRUE)

			var/mob/living/L = M

			var/self_points = FLOOR((STACON + STASTR + get_skill_level(/datum/skill/misc/athletics))/2, 1)
			var/target_points = FLOOR((L.STAEND + L.STASTR + L.get_skill_level(/datum/skill/misc/athletics))/2, 1)

			switch(sprint_distance)
				// Point blank
				if(0 to 1)
					self_points -= 99
					instafail = TRUE
				// One to two tile between the people
				if(2 to 3)
					self_points -= 3
				// Five or above tiles between people
				if(6 to INFINITY)
					self_points += 1

			// If charging into the BACK of the enemy (facing away)
			if(L.dir == get_dir(src, L))
				self_points += 2

			// Random 1 in 10 crit chance of 20 virtual stat points to make it less consistent.
			if(prob(10))
				switch(rand(1,2))
					if(1)
						self_points += 10
					if(2)
						self_points -= 10

			if(self_points > target_points)
				L.Knockdown(1)
			if(self_points < target_points)
				Knockdown(30)
			if(self_points == target_points)
				L.Knockdown(1)
				Knockdown(30)
			Immobilize(30)
			var/playsound = FALSE
			if(apply_damage(15, BRUTE, "head", run_armor_check("head", "blunt", damage = 20)))
				playsound = TRUE
			if(!instafail)
				if(L.apply_damage(15, BRUTE, "chest", L.run_armor_check("chest", "blunt", damage = 10)))
					playsound = TRUE
			if(playsound)
				playsound(src, "genblunt", 100, TRUE)
			if(!instafail)
				visible_message(span_warning("[src] charges into [L]!"), span_warning("I charge into [L]!"))
			else
				visible_message(span_warning("[src] smashes facefirst into [L]!"), span_warning("I charge into [L] too early!"))
			return TRUE

	//okay, so we didn't switch. but should we push?
	//not if he's not CANPUSH of course
	if(!(M.status_flags & CANPUSH))
		return TRUE
	if(isliving(M))
		var/mob/living/L = M
		if(HAS_TRAIT(L, TRAIT_PUSHIMMUNE))
			return TRUE

		//stat checking block
		if(!(world.time % 5))
			var/statchance = 50

			if(STASTR > L.STASTR)
				statchance = 50 + (STASTR - L.STASTR * 10)

			else if(STASTR < L.STASTR)
				statchance = 50 - (L.STASTR - STASTR * 10)
			if(statchance < 10)
				statchance = 10
			if(prob(statchance))
				visible_message("<span class='info'>[src] pushes [M].</span>")
			else
				visible_message("<span class='warning'>[src] pushes [M].</span>")
				return TRUE

	//anti-riot equipment is also anti-push
	for(var/obj/item/I in M.held_items)
		if(!istype(M, /obj/item/clothing))
			if(prob(I.block_chance*2))
				return
//Called when we bump onto an obj
/mob/living/proc/ObjBump(obj/O)
	return

//Called when we want to push an atom/movable
/mob/living/proc/PushAM(atom/movable/AM, force = move_force)
	if(now_pushing)
		return TRUE
	if(moving_diagonally)// no pushing during diagonal moves.
		return TRUE
	if(!client && (mob_size < MOB_SIZE_SMALL))
		return
	now_pushing = TRUE
	var/dir_to_pushed = get_dir(src, AM)
	var/push_anchored = FALSE
	if((AM.move_resist * MOVE_FORCE_CRUSH_RATIO) <= force)
		if(move_crush(AM, move_force, dir_to_pushed))
			push_anchored = TRUE
	if((AM.move_resist * MOVE_FORCE_FORCEPUSH_RATIO) <= force)			//trigger move_crush and/or force_push regardless of if we can push it normally
		if(force_push(AM, move_force, dir_to_pushed, push_anchored))
			push_anchored = TRUE
	if((AM.anchored && !push_anchored) || (force < (AM.move_resist * MOVE_FORCE_PUSH_RATIO)))
		now_pushing = FALSE
		return

	var/current_dir
	if(isliving(AM))
		current_dir = AM.dir
	if(AM.pushed(get_step(AM.loc, dir_to_pushed), dir_to_pushed, glide_size, current_dir))
		Move(get_step(loc, dir_to_pushed), dir_to_pushed)
	now_pushing = FALSE

/mob/living/carbon/can_be_pulled(user, grab_state, force)
	. = ..()
	if(isliving(user))
		var/mob/living/L = user
		if(!get_bodypart(check_zone(L.zone_selected)))
			to_chat(L, "<span class='warning'>[src] is missing that.</span>")
			return FALSE
		if(!lying_attack_check(L))
			return FALSE
	return TRUE

/mob/living/carbon/proc/kick_attack_check(mob/living/L)
	if(L == src)
		return FALSE
	if(body_position == LYING_DOWN)
		return TRUE
	var/list/acceptable = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_R_ARM, BODY_ZONE_CHEST, BODY_ZONE_L_ARM)
	if( !(check_zone(L.zone_selected) in acceptable) )
		to_chat(L, "<span class='warning'>I can't reach that.</span>")
		return FALSE
	return TRUE

/mob/living/carbon/proc/lying_attack_check(mob/living/L, obj/item/I)
	if(L == src)
		return TRUE
	var/CZ = FALSE
	var/list/acceptable = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_HEAD, BODY_ZONE_R_ARM, BODY_ZONE_CHEST, BODY_ZONE_L_ARM)
	if((L.body_position != LYING_DOWN) && (body_position != LYING_DOWN)) //we are both standing
		if(I)
			if(I.wlength > WLENGTH_NORMAL)
				CZ = TRUE
			else if(HAS_TRAIT(L, TRAIT_TINY) && !HAS_TRAIT(src, TRAIT_TINY)) //midget variant, allows neck no head
				acceptable = list(BODY_ZONE_R_ARM,BODY_ZONE_L_ARM,BODY_ZONE_PRECISE_R_HAND,BODY_ZONE_PRECISE_L_HAND,BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_CHEST, BODY_ZONE_PRECISE_NECK, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)
			else if(!HAS_TRAIT(L, TRAIT_TINY)) //we have a short/medium weapon, so allow hitting legs
				acceptable = list(BODY_ZONE_HEAD, BODY_ZONE_R_ARM, BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_NECK, BODY_ZONE_PRECISE_R_EYE,BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_EARS, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)
		else
			if(HAS_TRAIT(L, TRAIT_TINY) && !HAS_TRAIT(src, TRAIT_TINY)  && (!CZ)) //tiny punches
				acceptable = list(BODY_ZONE_R_ARM,BODY_ZONE_L_ARM,BODY_ZONE_PRECISE_R_HAND,BODY_ZONE_PRECISE_L_HAND,BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_CHEST, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)
			else if(!HAS_TRAIT(L, TRAIT_TINY) && (!CZ)) //we are punching, no legs
				acceptable = list(BODY_ZONE_HEAD, BODY_ZONE_R_ARM, BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_NECK, BODY_ZONE_PRECISE_R_EYE,BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_EARS, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)
	else if(L.body_position == LYING_DOWN && (body_position != LYING_DOWN)) //we are prone, victim is standing
		if(I)
			if(I.wlength > WLENGTH_NORMAL)
				CZ = TRUE
			else
				acceptable = list(BODY_ZONE_R_ARM,BODY_ZONE_L_ARM,BODY_ZONE_PRECISE_R_HAND,BODY_ZONE_PRECISE_L_HAND,BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)
		else
			if(!CZ)
				acceptable = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)
	else
		CZ = TRUE
	if(CZ)
		if( !(check_zone(L.zone_selected) in acceptable) )
			to_chat(L, "<span class='warning'>I can't reach that.</span>")
			return FALSE
	else
		if( !(L.zone_selected in acceptable) )
			to_chat(L, "<span class='warning'>I can't reach that.</span>")
			return FALSE
	return TRUE

/mob/living/start_pulling(atom/movable/AM, state, force = pull_force, suppress_message = FALSE, obj/item/item_override, accurate = FALSE)
	if(!AM || !src)
		return FALSE
	if(!(AM.can_be_pulled(src, state, force)))
		return FALSE

	if(throwing || !(mobility_flags & MOBILITY_PULL))
		return FALSE

	if(isliving(AM))
		var/mob/living/target = AM

		var/positioning_mod = get_positioning_modifier(target)
		if(positioning_mod < 0.8) // Significant positioning disadvantage
			if(prob(20)) // Chance to avoid grab due to bad position
				visible_message(span_warning("[src] fails to get a good grip on [target]!"))
				log_combat(src, target, "failed to grab due to positioning", addition="bad position")
				return FALSE

		if(target.has_status_effect(/datum/status_effect/buff/oiled))
			// Determine which limb we're trying to grab
			var/target_zone = zone_selected
			if(!target_zone)
				target_zone = "chest" // Default if no zone selected

			// Check if the target limb is covered by clothing
			var/is_covered = FALSE
			if(iscarbon(target))
				var/mob/living/carbon/carbon_target = target
				var/obj/item/bodypart/target_limb = carbon_target.get_bodypart(check_zone(target_zone))
				if(target_limb)
					is_covered = carbon_target.is_limb_covered(target_limb)

			// If limb is not covered and oiled, chance to slip away
			if(!is_covered)
				if(prob(35)) // 35% chance to slip away from grab attempt
					visible_message(span_warning("[target] slips away from [src]'s oily grasp!"), \
							span_warning("[target.name] slips away from my grip - they're too oily!"))
					target.visible_message(span_notice("I slip away from [src]'s grip thanks to the oil!"))
					log_combat(src, target, "failed to grab due to oil", addition="oiled skin")
					return FALSE // Grab attempt fails

	AM.add_fingerprint(src)
	// If we're pulling something then drop what we're currently pulling and pull this instead.
	if(pulling && AM != pulling)
		stop_pulling()
	changeNext_move(CLICK_CD_GRABBING)

	if(AM != src)
		/*
			Multiple people can have the same pulling mob, but the pulled mob can only have one pulledby mob.
			We lose out on having multiple people being able to drag, but this provides accurate feedback on who's the actual puller.
		*/
		if(AM.pulledby && AM.pulledby != src)
			if(!suppress_message)
				AM.visible_message(span_danger("[src] pulls [AM] from [AM.pulledby]'s grip."), \
								span_danger("[src] pulls you from [AM.pulledby]'s grip."), null, null, src)
				to_chat(src, span_notice("You pull [AM] from [AM.pulledby]'s grip."))
			log_combat(AM, AM.pulledby, "pulled from", src)
			AM.pulledby.stop_pulling() //an object can't be pulled by two mobs at once.

		pulling = AM
		AM.set_pulledby(src)
		SEND_SIGNAL(src, COMSIG_LIVING_START_PULL, AM, state, force)
	update_pull_hud_icon()

	if(isliving(AM))
		var/mob/living/M = AM
		if(!iscarbon(src))
			M.LAssailant = null
		else
			M.LAssailant = usr
		// Makes it so people who recently broke out of grabs cannot be grabbed again
		if(TIMER_COOLDOWN_RUNNING(M, "broke_free") && !HAS_TRAIT(M, TRAIT_INCAPACITATED))
			M.visible_message(span_warning("[M] slips from [src]'s grip."), \
					span_warning("I slip from [src]'s grab."))
			log_combat(src, M, "tried grabbing", addition="passive grab")
			stop_pulling()
			return
		log_combat(src, M, "grabbed", addition="passive grab")
		playsound(src, 'sound/combat/shove.ogg', 50, TRUE, -1)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			var/obj/item/grabbing/O = new()
			var/used_limb = C.find_used_grab_limb(src, accurate)
			O.name = "[C]'s [parse_zone(used_limb)]"
			var/obj/item/bodypart/BP = C.get_bodypart(check_zone(used_limb))
			C.grabbedby += O
			O.grabbed = C
			O.grabbee = src
			O.limb_grabbed = BP
			BP.grabbedby += O
			if(item_override)
				O.sublimb_grabbed = item_override
			else
				O.sublimb_grabbed = used_limb
			O.icon_state = zone_selected
			put_in_hands(O)
			O.update_hands(src)
			if(state > GRAB_PASSIVE || (HAS_TRAIT(src, TRAIT_STRONG_GRABBER) && cmode) || item_override)
				suppress_message = TRUE
				C.grippedby(src)
			if(!suppress_message)
				send_pull_message(M)
		else
			var/obj/item/grabbing/O = new()
			O.name = "[M.name]"
			O.grabbed = M
			O.grabbee = src
			if(item_override)
				O.sublimb_grabbed = item_override
			else
				O.sublimb_grabbed = M.simple_limb_hit(zone_selected)
			put_in_hands(O)
			O.update_hands(src)
			if(state > GRAB_PASSIVE || (HAS_TRAIT(src, TRAIT_STRONG_GRABBER) && cmode) || item_override)
				suppress_message = TRUE
				M.grippedby(src)
			if(!suppress_message)
				send_pull_message(M)
		update_pull_movespeed()
		set_pull_offsets(M, max(state, grab_state))
	else
		if(!suppress_message)
			var/sound_to_play = 'sound/combat/shove.ogg'
			playsound(src, sound_to_play, 50, TRUE, -1)
		var/obj/item/grabbing/O = new(src)
		O.name = "[AM.name]"
		O.grabbed = AM
		O.grabbee = src
		src.put_in_hands(O)
		O.update_hands(src)
		O.update_grab_intents()

	if(isliving(AM))
		var/mob/living/living = AM
		for(var/hand in living.hud_used?.hand_slots)
			var/atom/movable/screen/inventory/hand/H = living.hud_used.hand_slots[hand]
			H?.update_appearance(UPDATE_OVERLAYS)

	return TRUE

/mob/living/proc/is_limb_covered(obj/item/bodypart/limb)
	if(!limb)
		return FALSE

	// Check for clothing covering this limb
	for(var/obj/item/clothing/C in src.get_equipped_items())
		if(C.body_parts_covered & limb.body_part)
			return TRUE
	return FALSE

/mob/living/proc/send_pull_message(mob/living/target)
	target.visible_message(span_warning("[src] grabs [target]."), \
					src != target ? span_warning("[src] grabs me.") : "",
					span_hear("I hear shuffling."), null, src)
	to_chat(src, span_info("I grab [src != target ? "[target]" : "myself"]."))

/mob/living/proc/set_pull_offsets(mob/living/M, grab_state = GRAB_PASSIVE)
	if(M.buckled)
		return //don't make them change direction or offset them if they're buckled into something.
	var/offset = 0
	switch(grab_state)
		if(GRAB_PASSIVE)
			offset = GRAB_PIXEL_SHIFT_PASSIVE
		if(GRAB_AGGRESSIVE)
			offset = GRAB_PIXEL_SHIFT_AGGRESSIVE
	var/target_pixel_x = M.base_pixel_x + M.body_position_pixel_x_offset
	var/target_pixel_y = M.base_pixel_y + M.body_position_pixel_y_offset
	switch(get_dir(M, src))
		if(NORTH)
			animate(M, pixel_x = target_pixel_x, pixel_y = target_pixel_y + offset, 3)
		if(NORTHEAST)
			animate(M, pixel_x = target_pixel_x + offset, pixel_y = target_pixel_y + offset, 3)
		if(EAST)
			if(M.lying_angle == 270) //update the dragged dude's direction if we've turned
				M.set_lying_angle(90)
			animate(M, pixel_x = target_pixel_x + offset, pixel_y = target_pixel_y, 3)
		if(SOUTHEAST)
			animate(M, pixel_x = target_pixel_x + offset, pixel_y = target_pixel_y - offset, 3)
		if(SOUTH)
			animate(M, pixel_x = target_pixel_x, pixel_y = target_pixel_y - offset, 3)
		if(SOUTHWEST)
			animate(M, pixel_x = target_pixel_x - offset, pixel_y = target_pixel_y - offset, 3)
		if(WEST)
			if(M.lying_angle == 90)
				M.set_lying_angle(270)
			animate(M, pixel_x = target_pixel_x - offset, pixel_y = target_pixel_y, 3)
		if(NORTHWEST)
			animate(M, pixel_x = target_pixel_x - offset, pixel_y = target_pixel_y + offset, 3)

/mob/living/proc/reset_pull_offsets(mob/living/M, override)
	if(!override && M.buckled)
		return
	var/target_pixel_x = M.base_pixel_x + M.body_position_pixel_x_offset
	var/target_pixel_y = M.base_pixel_y + M.body_position_pixel_y_offset
	animate(M, pixel_x = target_pixel_x, pixel_y = target_pixel_y, 1)

/mob/living/proc/set_mob_offsets(index, _x = 0, _y = 0)
	if(index)
		if(mob_offsets[index])
			reset_offsets(index)
		mob_offsets[index] = list("x" = _x, "y" = _y)
	update_transform()

/mob/living/proc/reset_offsets(index)
	if(index)
		if(mob_offsets[index])
			mob_offsets[index] = null
	update_transform()

//mob verbs are a lot faster than object verbs
//for more info on why this is not atom/pull, see examinate() in mob.dm
/mob/living/verb/pulled(atom/movable/AM as mob|obj in oview(1))
	set name = "Pull"
	set hidden = 1

	if(istype(AM) && Adjacent(AM))
		start_pulling(AM)
	else
		stop_pulling()

/mob/living/stop_pulling(pulling_broke_free = FALSE)
	if(pulling_broke_free && ismob(pulling) && grab_state >= GRAB_AGGRESSIVE)
		var/wrestling_cooldown_reduction = 0
		if(pulledby?.get_skill_level(/datum/skill/combat/wrestling))
			wrestling_cooldown_reduction = 0.2 SECONDS * pulledby.get_skill_level(/datum/skill/combat/wrestling, TRUE)
		TIMER_COOLDOWN_START(src, "broke_free", max(0, 2 SECONDS - wrestling_cooldown_reduction)) // BUFF: Reduced cooldown

	for(var/obj/item/grabbing/grabber_item in held_items)
		if(grabber_item.grabbed == pulling)
			dropItemToGround(grabber_item, silent = FALSE)

	if(ismob(pulling))
		reset_pull_offsets(pulling)

	. = ..()

	update_pull_movespeed()
	update_pull_hud_icon()

/mob/living/verb/stop_pulling1()
	set name = "Stop Pulling"
	set category = "IC.Interaction"
	set hidden = 1
	stop_pulling()

//same as above
/mob/living/pointed(atom/A as mob|obj|turf in view(client.view, src))
	if(incapacitated(IGNORE_GRAB))
		return FALSE
	return ..()


/mob/living/verb/succumb(whispered as null, reaper as null)
	set hidden = TRUE
	if(stat == DEAD)
		return
	if(!reaper)
		return
	if (InCritical() || health <= 0 || (blood_volume < BLOOD_VOLUME_SURVIVE))
		log_message("Has [whispered ? "whispered his final words" : "succumbed to death"] while in [InFullCritical() ? "hard":"soft"] critical with [round(health, 0.1)] points of health!", LOG_ATTACK)

		if(istype(src.loc, /turf/open/water) && !HAS_TRAIT(src, TRAIT_NOBREATH) && body_position == LYING_DOWN && client)
			record_round_statistic(STATS_PEOPLE_DROWNED)

		adjustOxyLoss(201)
		updatehealth()
//		if(!whispered)
//			to_chat(src, "<span class='userdanger'>I have given up life and succumbed to death.</span>")
		death()

/**
 * Checks if a mob is incapacitated
 *
 * Normally being restrained, agressively grabbed, or in stasis counts as incapacitated
 * unless there is a flag being used to check if it's ignored
 *
 * args:
 * * flags (optional) bitflags that determine if special situations are exempt from being considered incapacitated
 *
 * bitflags: (see code/__DEFINES/status_effects.dm)
 * * IGNORE_RESTRAINTS - mob in a restraint (handcuffs) is not considered incapacitated
 * * IGNORE_STASIS - mob in stasis (stasis bed, etc.) is not considered incapacitated
 * * IGNORE_GRAB - mob that is agressively grabbed is not considered incapacitated
**/
/mob/living/incapacitated(flags)
	if(!(flags & IGNORE_RESTRAINTS) && HAS_TRAIT(src, TRAIT_RESTRAINED))
		return TRUE
	if(!(flags & IGNORE_GRAB) && pulledby && (pulledby != src) && pulledby.grab_state >= GRAB_AGGRESSIVE)
		return TRUE
	if(!(flags & IGNORE_STASIS) && HAS_TRAIT(src, TRAIT_STASIS))
		return TRUE

	if(HAS_TRAIT(src, TRAIT_INCAPACITATED))
		return TRUE

	return FALSE

/mob/living/canUseStorage()
	if (num_hands <= 0)
		return FALSE
	return TRUE

/mob/living/proc/InCritical()
	return (health <= crit_threshold && (stat == SOFT_CRIT || stat == UNCONSCIOUS))

/mob/living/proc/InFullCritical()
	return ((health <= HEALTH_THRESHOLD_FULLCRIT) && stat == UNCONSCIOUS)

/mob/living/proc/getMaxHealth()
	return maxHealth

/mob/living/proc/setMaxHealth(newMaxHealth)
	maxHealth = newMaxHealth

// MOB PROCS //END

/mob/living/proc/mob_sleep()
	set name = "Sleep"
	set category = "IC.Interaction"
	set hidden = 1
	if(IsSleeping())
		to_chat(src, "<span class='warning'>I am already sleeping!</span>")
		return
	else
		if(alert(src, "You sure you want to sleep for a while?", "Sleep", "Yes", "No") == "Yes")
			SetSleeping(400) //Short nap

/mob/proc/get_contents()
	return

/mob/living/proc/lay_down()
	set name = "Lay down"
	set category = "IC.Interaction"
	set hidden = 1
	if(stat)
		return
	if(pulledby)
		to_chat(src, span_warning("I'm grabbed!"))
		return
	if(!resting)
		set_resting(TRUE, FALSE)

/mob/living/proc/stand_up()
	set name = "Stand up"
	set category = "IC.Interaction"
	set hidden = 1
	if(stat)
		return
	if(pulledby && pulledby.grab_state >= GRAB_AGGRESSIVE)
		var/fail_resist = resist_grab()
		if(fail_resist)
			to_chat(src, span_warning("I failed to resist their grab and i can't get up!"))
			return FALSE
		else
			to_chat(src, span_notice("I resisted their grab!"))
	if(resting)
		if(!HAS_TRAIT(src, TRAIT_FLOORED))
			visible_message(span_notice("[src] begins standing up."), span_notice("I begin to stand up."))
			set_resting(FALSE, FALSE)
			return TRUE
		else
			visible_message(span_warning("[src] struggles to stand up."), span_danger("I am struggling to stand up."))
			return FALSE

/mob/living/verb/toggle_rest_verb()
	set name = "Rest"
	set category = "IC.Interaction"

	toggle_rest()

/mob/living/proc/toggle_rest()
	if(resting)
		stand_up()
	else
		lay_down()

///Proc to hook behavior to the change of value in the resting variable.
/mob/living/proc/set_resting(new_resting, silent = TRUE, instant = FALSE)
	if(new_resting == resting)
		return
	. = resting
	resting = new_resting
	update_resting()
	SEND_SIGNAL(src, COMSIG_LIVING_SET_RESTING, new_resting)
	if(new_resting == resting)
		if(resting)
			if(m_intent == MOVE_INTENT_RUN)
				toggle_rogmove_intent(MOVE_INTENT_WALK, TRUE)
	if(new_resting)
		if(body_position == LYING_DOWN)
			if(!silent)
				to_chat(src, span_notice("You will now try to stay lying down on the floor."))
		else if(buckled && buckled.buckle_lying != NO_BUCKLE_LYING)
			if(!silent)
				to_chat(src, span_notice("You will now lay down as soon as you are able to."))
		else
			if(!silent)
				playsound(src, 'sound/foley/toggledown.ogg', 100, FALSE)
				src.visible_message(span_info("[src] lays down."))
			set_lying_down()
	else
		if(body_position == STANDING_UP)
			if(!silent)
				to_chat(src, span_notice("You will now try to remain standing up."))
		else if(HAS_TRAIT(src, TRAIT_FLOORED) || (buckled && buckled.buckle_lying != NO_BUCKLE_LYING))
			if(!silent)
				to_chat(src, span_notice("You will now stand up as soon as you are able to."))
		else
			get_up(instant)

/mob/living/proc/update_resting()
	update_rest_hud_icon()

/mob/living/proc/get_up(instant = FALSE)
	set waitfor = FALSE
	var/timer = 2

	if(pulledby && pulledby.grab_state >= GRAB_AGGRESSIVE)
		var/fail_resist = resist_grab()
		if(fail_resist)
			set_resting(TRUE, silent = TRUE)
			return

	if(iscarbon(src))
		var/mob/living/carbon/getter_upper = src
		var/obj/item/clothing/armor/got_armor = getter_upper.get_item_by_slot(ITEM_SLOT_ARMOR) //grabs the item in your armorslot

		var/stand_speed_mult = 1
		if(got_armor) //sanity checks so mult doesnt runtime
			stand_speed_mult = (1 + getter_upper.get_encumbrance()) * got_armor.stand_speed_reduction

		var/proto_timer = 2 * stand_speed_mult
		if(proto_timer >= timer) //sanity check so you can't stand up faster if you somehow get negative encumbrance
			timer = proto_timer

	if(!instant && !do_after(src, timer SECONDS, src, timed_action_flags = (IGNORE_USER_LOC_CHANGE|IGNORE_TARGET_LOC_CHANGE|IGNORE_HELD_ITEM|IGNORE_USER_DIR_CHANGE), extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob/living, rest_checks_callback)), interaction_key = DOAFTER_SOURCE_GETTING_UP))
		if(body_position == LYING_DOWN) // stay lying down
			set_resting(TRUE, silent = TRUE)
		return

	if(!rest_checks_callback())
		if(body_position == LYING_DOWN)
			set_resting(TRUE, silent = TRUE)
		return

	set_body_position(STANDING_UP)
	set_lying_angle(0)

/mob/living/proc/rest_checks_callback()
	if(resting || body_position == STANDING_UP || HAS_TRAIT(src, TRAIT_FLOORED))
		return FALSE
	return TRUE

/mob/living/proc/set_lying_down(new_lying_angle)
	set_body_position(LYING_DOWN)

/// Proc to append behavior related to lying down.
/mob/living/proc/on_lying_down(new_lying_angle)
	if(layer == initial(layer)) //to avoid things like hiding larvas.
		layer = LYING_MOB_LAYER //so mob lying always appear behind standing mobs
	density = FALSE // We lose density and stop bumping passable dense things.
	if(HAS_TRAIT(src, TRAIT_FLOORED) && !(dir & (NORTH|SOUTH)))
		setDir(pick(NORTH, SOUTH)) // We are and look helpless.
	body_position_pixel_y_offset = PIXEL_Y_OFFSET_LYING
	update_wallpress()

/// Proc to append behavior related to lying down.
/mob/living/proc/on_standing_up()
	if(layer == LYING_MOB_LAYER)
		layer = initial(layer)
	density = initial(density) // We were prone before, so we become dense and things can bump into us again.
	body_position_pixel_y_offset = 0

//Recursive function to find everything a mob is holding. Really shitty proc tbh, you should use get_all_gear for carbons.
/mob/living/get_contents()
	var/list/ret = list()
	ret |= contents						//add our contents
	for(var/i in ret.Copy())			//iterate storage objects
		var/atom/A = i
		SEND_SIGNAL(A, COMSIG_TRY_STORAGE_RETURN_INVENTORY, ret)
	return ret

// Living mobs use can_inject() to make sure that the mob is not syringe-proof in general.
/mob/living/proc/can_inject()
	return TRUE

/mob/living/is_injectable(mob/user, allowmobs = TRUE)
	return (allowmobs && reagents && can_inject(user))

/mob/living/is_drawable(mob/user, allowmobs = TRUE)
	return (allowmobs && reagents && can_inject(user))

///Sets the current mob's health value. Do not call directly if you don't know what you are doing, use the damage procs, instead.
/mob/living/proc/set_health(new_value)
	. = health
	health = min(new_value, maxHealth)

/mob/living/proc/updatehealth(amount = 0)
	if(status_flags & GODMODE)
		return
	set_health(maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss())
	if(HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS) && !HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
		// You dont have any blood and your not bloodloss immune? Dead.
		if(blood_volume <= 0)
			set_health(NONE)
	update_stat()
	SEND_SIGNAL(src, COMSIG_LIVING_HEALTH_UPDATE, amount)

/**
 * Proc used to resuscitate a mob, bringing them back to life.
 *
 * Note that, even if a mob cannot be revived, the healing from this proc will still be applied.
 *
 * Arguments
 * * full_heal_flags - Optional. If supplied, [/mob/living/fully_heal] will be called with these flags before revival.
 * * excess_healing - Optional. If supplied, this number will be used to apply a bit of healing to the mob. Currently, 1 "excess healing" translates to -1 oxyloss, -1 toxloss, +2 blood, -5 to all organ damage.
 * * force_grab_ghost - We grab the ghost of the mob on revive. If TRUE, we force grab the ghost (includes suiciders). If FALSE, we do not. See [/mob/grab_ghost].
 *
 */
/mob/living/proc/revive(full_heal_flags = NONE, excess_healing = 0, force_grab_ghost = FALSE)
	if(excess_healing)
		adjustOxyLoss(-excess_healing, FALSE)
		adjustToxLoss(-excess_healing, FALSE, TRUE)
		updatehealth()

	// grab_ghost(force_grab_ghost)
	if(full_heal_flags)
		fully_heal(full_heal_flags)

	if(stat == DEAD && can_be_revived()) //in some cases you can't revive (e.g. no brain)
		GLOB.dead_mob_list -= src
		GLOB.alive_mob_list += src
		set_suicide(FALSE)
		set_stat(UNCONSCIOUS) //the mob starts unconscious,
		updatehealth() //then we check if the mob should wake up.
		// if(full_heal_flags & HEAL_ADMIN)
		// 	get_up(TRUE)
		update_sight()
		clear_alert("not_enough_oxy")
		reload_fullscreen()
		remove_client_colour(/datum/client_colour/monochrome/death)
		. = TRUE
		if(mind)
			mind.remove_antag_datum(/datum/antagonist/zombie)
		if(ishuman(src))
			var/mob/living/carbon/human/human = src
			human.funeral = FALSE
		if(excess_healing)
			INVOKE_ASYNC(src, PROC_REF(emote), "breathgasp")
			log_combat(src, src, "revived")

	// else if(full_heal_flags & HEAL_ADMIN)
	// 	updatehealth()
	// 	get_up(TRUE)

	// The signal is called after everything else so components can properly check the updated values
	SEND_SIGNAL(src, COMSIG_LIVING_REVIVE, full_heal_flags)

/mob/living/Crossed(atom/movable/AM)
	. = ..()
	for(var/obj/item/item as anything in get_equipped_items())
		SEND_SIGNAL(item, COMSIG_ITEM_WEARERCROSSED, AM, src)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent == MOVE_INTENT_RUN && body_position == LYING_DOWN && !buckle_lying)
			L.visible_message("<span class='warning'>[L] trips over [src]!</span>","<span class='warning'>I trip over [src]!</span>")
			L.Knockdown(10)
			L.Immobilize(20)

/**
 * A grand proc used whenever this mob is, quote, "fully healed".
 * Fully healed could mean a number of things, such as "healing all the main damage types", "healing all the organs", etc
 * So, you can pass flags to specify
 *
 * See [mobs.dm] for more information on the flags
 *
 * If you ever think "hey I'm adding something and want it to be reverted on full heal",
 * consider handling it via signal instead of implementing it in this proc
 */
/mob/living/proc/fully_heal(heal_flags = HEAL_ALL)
	SHOULD_CALL_PARENT(TRUE)

	if(heal_flags & HEAL_TOX) //zero as second argument not automatically call updatehealth().
		setToxLoss(0, FALSE, TRUE)
	if(heal_flags & HEAL_OXY)
		setOxyLoss(0, FALSE, TRUE)
	if(heal_flags & HEAL_CLONE)
		setCloneLoss(0, FALSE, TRUE)
	if(heal_flags & HEAL_BRUTE)
		setBruteLoss(0, FALSE, TRUE)
	if(heal_flags & HEAL_BURN)
		setFireLoss(0, FALSE, TRUE)
	if(heal_flags & HEAL_STAM)
		adjust_stamina(-maximum_stamina, internal_regen = FALSE)

	if(heal_flags & HEAL_ESSENTIALS)
		set_nutrition(NUTRITION_LEVEL_FED + 50)
		set_hydration(HYDRATION_LEVEL_HYDRATED + 50)

	set_disgust(0)
	cure_husk()

	if(heal_flags & HEAL_WOUNDS)
		for(var/datum/wound/wound as anything in get_wounds())
			if(heal_flags & ADMIN_HEAL_ALL)
				qdel(wound)
			else
				wound.heal_wound(wound.whp)

	if(heal_flags & HEAL_TEMP)
		bodytemperature = BODYTEMP_NORMAL
	if(heal_flags & HEAL_BLOOD)
		restore_blood()
	if(reagents && (heal_flags & HEAL_ALL_REAGENTS))
		for(var/addi in reagents.addiction_list)
			reagents.remove_addiction(addi)
		reagents.clear_reagents()

	ExtinguishMob()
	fire_stacks = 0
	divine_fire_stacks = 0

	stuttering = 0
	slurring = 0
	slowdown = 0

	if(heal_flags & HEAL_ADMIN)
		suiciding = FALSE

	updatehealth()
	stop_sound_channel(CHANNEL_HEARTBEAT)
	SEND_SIGNAL(src, COMSIG_LIVING_POST_FULLY_HEAL, heal_flags)

//proc called by revive(), to check if we can actually ressuscitate the mob (we don't want to revive him and have him instantly die again)
/mob/living/proc/can_be_revived()
	if(health <= HEALTH_THRESHOLD_DEAD)
		return FALSE
	return TRUE


/mob/living/carbon/human/can_be_revived()
	. = ..()
	var/obj/item/bodypart/head/H = get_bodypart(BODY_ZONE_HEAD)
	if(H)
		if(H.rotted || H.skeletonized || H.brainkill)
			return FALSE


/mob/living/proc/update_damage_overlays()
	return

/mob/living/proc/update_wallpress(turf/T, atom/newloc, direct)
	if(!wallpressed)
		reset_offsets("wall_press")
		return FALSE
	if(buckled || body_position == LYING_DOWN)
		wallpressed = FALSE
		update_wallpress_slowdown()
		reset_offsets("wall_press")
		return FALSE
	var/turf/newwall = get_step(newloc, wallpressed)
	if(!T.Adjacent(newwall))
		return reset_offsets("wall_press")
	if(isclosedturf(newwall) && fixedeye)
		var/turf/closed/C = newwall
		if(C.wallpress)
			return TRUE
	wallpressed = FALSE
	reset_offsets("wall_press")
	update_wallpress_slowdown()

/mob/living/proc/update_pixelshift(turf/T, atom/newloc, direct)
	if(!pixelshifted)
		reset_offsets("pixel_shift")
		return FALSE
	pixelshifted = FALSE
	pixelshift_x = 0
	pixelshift_y = 0
	reset_offsets("pixel_shift")

/mob/living/Move(atom/newloc, direct, glide_size_override)

	var/old_direction = dir
	var/turf/T = loc

	if(m_intent == MOVE_INTENT_RUN)
		sprinted_tiles++
		var/boon = get_learning_boon(/datum/skill/misc/athletics)
		adjust_experience(/datum/skill/misc/athletics, (STAEND*0.05) * boon)

	if(wallpressed)
		update_wallpress(T, newloc, direct)

	if(pixelshifted)
		update_pixelshift(T, newloc, direct)

	if(lying_angle)
		if(direct & EAST)
			lying_angle = 90
		if(direct & WEST)
			lying_angle = 270
		update_transform()
		lying_prev = lying_angle
	if (buckled && buckled.loc != newloc) //not updating position
		if (!buckled.anchored)
			return buckled.Move(newloc, direct, glide_size)
		else
			return FALSE

	if(pulling)
		update_pull_movespeed()

	. = ..()

	update_sneak_invis()

	if(pulledby && moving_diagonally != FIRST_DIAG_STEP && get_dist(src, pulledby) > 1 && (pulledby != moving_from_pull))//separated from our puller and not in the middle of a diagonal move.
		pulledby.stop_pulling()
	else
		if(isliving(pulledby))
			var/mob/living/L = pulledby
			L.set_pull_offsets(src, pulledby.grab_state)

//	if(active_storage && !(CanReach(active_storage.parent,view_only = TRUE)))
	if(active_storage)
		active_storage.close(src)

	if(body_position == LYING_DOWN && !buckled && prob(getBruteLoss() * (200/max(maxHealth, 1))))
		makeTrail(newloc, T, old_direction)

/mob/living/setDir(newdir)
	var/olddir = dir
	..()
	if(olddir != dir)
		stop_looking()
		if(client)
			update_vision_cone()

/mob/living/proc/makeTrail(turf/target_turf, turf/start, direction)
	var/blood_exists = FALSE

	for(var/obj/effect/decal/cleanable/trail_holder/C in start) //checks for blood splatter already on the floor
		blood_exists = TRUE
	if(isturf(start))
		var/trail_type = getTrail()
		if(trail_type)
			var/brute_ratio = round(getBruteLoss() / maxHealth, 0.1)
			if(blood_volume && blood_volume > max(BLOOD_VOLUME_NORMAL*(1 - brute_ratio * 0.25), 0))//don't leave trail if blood volume below a threshold
				blood_volume = max(blood_volume - max(1, brute_ratio * 2), 0) 					//that depends on our brute damage.
				var/newdir = get_dir(target_turf, start)
				if(newdir != direction)
					newdir = newdir | direction
					if(newdir == 3) //N + S
						newdir = NORTH
					else if(newdir == 12) //E + W
						newdir = EAST
				if((newdir in GLOB.cardinals) && (prob(50)))
					newdir = turn(get_dir(target_turf, start), 180)
				if(!blood_exists)
					new /obj/effect/decal/cleanable/trail_holder(start)

				for(var/obj/effect/decal/cleanable/trail_holder/TH in start)
					if((!(newdir in TH.existing_dirs) || trail_type == "trails_1" || trail_type == "trails_2") && TH.existing_dirs.len <= 16) //maximum amount of overlays is 16 (all light & heavy directions filled)
						TH.existing_dirs += newdir
						TH.add_overlay(image('icons/effects/blood.dmi', trail_type, dir = newdir))
						TH.transfer_mob_blood_dna(src)

/mob/living/carbon/human/makeTrail(turf/T)
	if((NOBLOOD in dna.species.species_traits) || !bleed_rate || bleedsuppress)
		return
	..()

/mob/living/proc/getTrail()
	if(getBruteLoss() < 300)
		return pick("ltrails_1", "ltrails_2")
	else
		return pick("trails_1", "trails_2")

/mob/living/can_resist()
	if(next_move > world.time)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_INCAPACITATED))
		return FALSE
	return TRUE

/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC.Interaction"
	set hidden = 1
	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(execute_resist)))

///proc extender of [/mob/living/verb/resist] meant to make the process queable if the server is overloaded when the verb is called
/mob/living/proc/execute_resist()
	if(!can_resist() || surrendering)
		return

	changeNext_move(CLICK_CD_RESIST)

	if(atkswinging)
		stop_attack(FALSE)

	SEND_SIGNAL(src, COMSIG_LIVING_RESIST, src)
	//resisting grabs (as if it helps anyone...)
	if(!HAS_TRAIT(src, TRAIT_RESTRAINED) && pulledby)
		log_combat(src, pulledby, "resisted grab")
		resist_grab()
		return

	//unbuckling yourself
	if(buckled && last_special <= world.time)
		resist_buckle()

	//Breaking out of a container (Locker, sleeper, cryo...)
	else if(isobj(loc))
		var/obj/C = loc
		C.container_resist(src)

	else if(!HAS_TRAIT(src, TRAIT_IMMOBILIZED))
		if(on_fire)
			resist_fire() //stop, drop, and roll
		else if(last_special <= world.time)
			resist_restraints() //trying to remove cuffs.

/mob/living/carbon/human/verb/ic_pray()
	set name = "Prayer"
	set category = "IC.Interaction"

	emote("pray", intentional = TRUE)

/mob/living/verb/submit()
	set name = "Yield"
	set category = "IC.Interaction"

	if(surrendering)
		return
	if(stat)
		return
	surrendering = 1
	if(alert(src, "Yield in surrender?",,"YES","NO") == "YES")
		record_round_statistic(STATS_YIELDS)
		changeNext_move(CLICK_CD_EXHAUSTED)
		var/image/flaggy = image('icons/effects/effects.dmi',src,"surrender",ABOVE_MOB_LAYER)
		flaggy.appearance_flags = RESET_TRANSFORM|KEEP_APART
		flaggy.transform = null
		flaggy.pixel_y = 12
		flick_overlay_view(flaggy, 150)
		drop_all_held_items()
		Stun(150)
		src.visible_message("<span class='notice'>[src] yields!</span>")
		playsound(src, 'sound/misc/surrender.ogg', 100, FALSE, -1)
		toggle_cmode()
		sleep(150)
		log_attack("[key_name(src)] has yielded!")
	surrendering = 0


/mob/proc/stop_attack(message = FALSE)
	if(atkswinging)
		atkswinging = FALSE
		if(message)
			to_chat(src, "<span class='warning'>Attack stopped.</span>")
	if(client)
		client.charging = 0
		client.chargedprog = 0
		client.tcompare = null //so we don't shoot the attack off
		client.mouse_pointer_icon = 'icons/effects/mousemice/human.dmi'
	if(used_intent && istype(used_intent))
		used_intent.on_mouse_up()
	if(mmb_intent)
		mmb_intent.on_mouse_up()
	update_warning()

/mob/living/stop_attack(message = FALSE)
	..()
	update_charging_movespeed()

/mob/living/proc/mutual_grab_break()
	if(!pulledby || !pulling)
		return FALSE

	// Check if we're in a mutual grab situation
	var/mutual_grab = FALSE
	if(pulledby == pulling) // Direct mutual grab
		mutual_grab = TRUE
	else if(pulling && pulledby) // Both grabbing different people but grabbed by someone
		for(var/obj/item/grabbing/G in grabbedby)
			if(G.grabbee == pulling) // The person we're pulling is also grabbing us
				mutual_grab = TRUE
				break

	if(!mutual_grab)
		return FALSE

	var/my_wrestling = 0
	var/their_wrestling = 0
	if(mind)
		my_wrestling = get_skill_level(/datum/skill/combat/wrestling, TRUE)
	if(pulledby.mind)
		their_wrestling = pulledby.get_skill_level(/datum/skill/combat/wrestling, TRUE)

	var/break_chance = 15 // Base chance
	break_chance += (my_wrestling - their_wrestling)
	break_chance += (STASTR - pulledby.STASTR) * 0.4

	// Both parties get a chance to break free
	if(prob(break_chance))
		visible_message(span_warning("[src] and [pulledby] struggle and break free from each other's grips!"))
		log_combat(src, pulledby, "mutual grab break")
		stop_pulling(pulling_broke_free = TRUE)
		pulledby.stop_pulling(pulling_broke_free = TRUE)

		// Both get briefly stunned from the struggle
		Immobilize(5)
		pulledby?.Immobilize(5)
		adjust_stamina(rand(3,5))
		pulledby?.adjust_stamina(rand(3,5))

		playsound(src, 'sound/combat/grabbreak.ogg', 75, TRUE, -1)
		return TRUE
	else
		// visible_message(span_warning("[src] and [pulledby] struggle against each other's grips!"))
		adjust_stamina(rand(1,3))
		pulledby?.adjust_stamina(rand(1,3))

	return FALSE

/datum/status_effect/grab_counter_cd
	id = "grab_counter_cd"
	alert_type = null
	duration = 10 SECONDS

/mob/living/proc/grab_counter_attack(mob/living/carbon/attacker)
	if(!cmode || stat >= UNCONSCIOUS)
		return FALSE

	// Can't counter if we're already heavily grabbed
	var/grab_count = length(grabbedby)
	if(grab_count > 1)
		return FALSE

	// // Check if we're in a position to counter
	// if(pulledby && pulledby != attacker) // Already grabbed by someone else
	// 	return FALSE

	if(has_status_effect(/datum/status_effect/grab_counter_cd))
		return FALSE

	var/counter_chance = 20 // Base chance

	counter_chance += get_skill_level(/datum/skill/combat/wrestling, TRUE) * 4
	counter_chance += get_skill_level(/datum/skill/combat/unarmed, TRUE) * 4

	// Stat differences
	counter_chance += (STASTR - attacker.STASTR) * 2
	counter_chance += (STASPD - attacker.STASPD) * 1.5

	// Positioning bonuses
	// if(attacker.body_position == LYING_DOWN && body_position != LYING_DOWN)
	// 	counter_chance += 20
	counter_chance *= (1/attacker.get_positioning_modifier(src))

	// Fatigue penalties for attacker
	if(iscarbon(attacker))
		var/mob/living/carbon/C = attacker
		counter_chance += C.grab_fatigue * 2

	// Equipment in hands affects counter ability
	var/obj/item/my_weapon = get_active_held_item()
	var/obj/item/their_weapon = attacker.get_active_held_item()

	if(my_weapon && !istype(my_weapon, /obj/item/grabbing))
		if(my_weapon.wlength > WLENGTH_SHORT)
			counter_chance += 15

	if(their_weapon && !istype(their_weapon, /obj/item/grabbing))
		if(their_weapon.wlength > WLENGTH_SHORT)
			counter_chance -= 10 // Harder to counter armed grabs

	counter_chance = clamp(counter_chance, 5, 95)
	changeNext_move(CLICK_CD_MELEE)

	if(prob(counter_chance))
		apply_status_effect(/datum/status_effect/grab_counter_cd)

		var/counter_type
		if(get_skill_level(/datum/skill/combat/unarmed) >= 4)
			counter_type = pickweight(list("knee" = 30, "elbow" = 70))
		else
			counter_type = pickweight(list("knee" = 60, "elbow" = 40))
		switch(counter_type)
			if("knee")
				visible_message(span_danger("[src] drives a knee into [attacker]'s midsection!"), \
							   span_notice("I drive my knee into [attacker]'s gut!"))
				var/damage = get_punch_dmg() * 0.9
				attacker.apply_damage(damage, BRUTE, BODY_ZONE_CHEST)
				attacker.OffBalance(1.5 SECONDS)

			if("elbow")
				visible_message(span_danger("[src] throws a sharp elbow at [attacker]!"), \
							   span_notice("I throw a sharp elbow at [attacker]!"))
				var/damage = get_punch_dmg() * 1.1
				var/target_zone = pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST)
				attacker.apply_damage(damage, BRUTE, target_zone)
				attacker.OffBalance(1.5 SECONDS)
				attacker.adjust_confusion(4 SECONDS)

			// if("stomp")
			// 	if(attacker.body_position != LYING_DOWN && body_position != LYING_DOWN)
			// 		visible_message("<span class='danger'>[src] stomps on [attacker]'s foot!</span>", "<span class='notice'>I stomp on [attacker]'s foot!</span>")
			// 		var/damage = get_punch_dmg() * 0.6
			// 		attacker.apply_damage(damage, BRUTE, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
			// 		attacker.Knockdown(1)

		attacker.Immobilize(rand(5, 10))
		// adjust_stamina(rand(3,6))
		attacker.adjust_stamina(rand(5,10))

		log_combat(src, attacker, "counter-attacked grab attempt")
		playsound(src, "genblunt", 80, TRUE, -1)

		// Add grab fatigue to the attacker
		if(iscarbon(attacker))
			var/mob/living/carbon/C = attacker
			C.add_grab_fatigue(2)

		return TRUE

	// to_chat(src, span_warning("I fail to do a counterattack!"))
	return FALSE

/mob/living/proc/get_positioning_modifier(mob/living/target)
	var/modifier = 1.0

	if(src == target)
		return modifier

	// Check relative positions
	var/their_dir = target.dir
	var/approach_dir = get_dir(src, target)

	// Behind target (they're not facing us)
	if(approach_dir == their_dir || approach_dir == turn(their_dir, -45) || approach_dir == turn(their_dir, 45))
		modifier += 0.3 // Significant advantage from behind

	// Target is facing us directly
	else if(approach_dir == turn(their_dir, 180))
		modifier -= 0.1 // Slight disadvantage when they see us coming

	// Height advantage (standing vs lying)
	if(body_position != LYING_DOWN && target.body_position == LYING_DOWN)
		modifier += 0.35
	else if(body_position == LYING_DOWN && target.body_position != LYING_DOWN)
		modifier -= 0.35

	if(ishuman(src))
		var/mob/living/carbon/human/human = src
		var/mob/living/carbon/human/target_human = target
		var/target_height = FALSE
		if(istype(target_human))
			if(target_human.age == AGE_CHILD)
				target_height = TRUE

		if((human.age == AGE_CHILD) && (!HAS_TRAIT(target, TRAIT_TINY) || !target_height))
			modifier -= 0.3

		if(human.age != AGE_CHILD && (HAS_TRAIT(target, TRAIT_TINY) || target_height))
			modifier += 0.5

	// Environmental factors
	var/turf/open/our_turf = get_turf(src)
	var/turf/open/their_turf = get_turf(target)

	// Against walls/corners limits escape options
	var/wall_count = 0
	for(var/turf/T in range(1, target))
		if(isclosedturf(T))
			wall_count++

	if(wall_count >= 6) // Cornered
		modifier += 0.25
	else if(wall_count >= 3) // Against wall
		modifier += 0.15

	// Difficult terrain
	if(our_turf.slowdown > their_turf.slowdown)
		modifier -= 0.1 // We're disadvantaged by terrain
	else if(their_turf.slowdown > our_turf.slowdown)
		modifier += 0.1 // They're disadvantaged

	return modifier

/mob/proc/resist_grab(moving_resist)
	return 1 //returning 0 means we successfully broke free

/mob/living/resist_grab(moving_resist)
	. = TRUE

	if(HAS_TRAIT(src, TRAIT_RESTRAINED))
		to_chat(src, span_warning("I'm restrained!"))
		return

	if(!MOBTIMER_FINISHED(pulledby, MT_RESIST_GRAB, 2 SECONDS))
		return

	SEND_SIGNAL(src, COMSIG_LIVING_RESIST_GRAB, src, pulledby, moving_resist)

	var/wrestling_diff = 0
	var/resist_chance = BASE_GRAB_RESIST_CHANCE
	var/mob/living/L = pulledby
	var/combat_modifier = 1

	// Modifier of pulledby against the resisting src
	var/positioning_modifier = L.get_positioning_modifier(src)

	wrestling_diff += (get_skill_level(/datum/skill/combat/wrestling, TRUE))
	wrestling_diff -= (L.get_skill_level(/datum/skill/combat/wrestling, TRUE))

	if(has_status_effect(/datum/status_effect/buff/oiled))
		var/obj/item/grabbing/grabbed = L.get_active_held_item()
		if(!grabbed)
			grabbed = L.get_inactive_held_item()
		if(is_limb_covered(grabbed.limb_grabbed))
			combat_modifier += 0.6
			resist_chance += 25

	if(pulledby.grab_state >= GRAB_AGGRESSIVE)
		combat_modifier -= 0.15

	var/obj/item/puller_hand = pulledby.get_active_held_item()
	if(isitem(puller_hand))
		if(!istype(puller_hand, /obj/item/grabbing) && puller_hand.wlength > WLENGTH_SHORT)
			combat_modifier += 0.25

	if(cmode && !L.cmode)
		combat_modifier += 0.2
	else if(!cmode && L.cmode)
		combat_modifier -= 0.2

	if(L.buckled)
		combat_modifier += 0.5

	var/stamina_factor = 1.0
	if(L.stamina / L.maximum_stamina < 0.5)
		stamina_factor += 0.3 // Tired grabbers are weaker
	if(stamina / maximum_stamina < 0.3)
		stamina_factor -= 0.2 // But tired victims also struggle more

	var/grab_count = 0
	for(var/obj/item/grabbing/G in L.held_items)
		if(G && G.grabbed)
			grab_count++
	if(grab_count > 1)
		combat_modifier += (grab_count - 1) * 0.2 // Harder to maintain multiple grabs

	for(var/obj/item/grabbing/G in grabbedby)
		if(G.chokehold)
			combat_modifier -= 0.1 // BUFF: Reduced chokehold penalty (was 0.15)

	resist_chance += ((((STASTR - L.STASTR)/3) + wrestling_diff) * 5)
	resist_chance *= combat_modifier * stamina_factor * (1/positioning_modifier)
	resist_chance = clamp(resist_chance, 5, 95)

	var/time_grabbed = S_TIMER_COOLDOWN_TIMELEFT(src, "broke_free")
	if(time_grabbed)
		resist_chance += min(time_grabbed / 50, 20) // Up to +20% after long grabs

	if(moving_resist) //we resisted by trying to move
		client?.move_delay = world.time + 50

	var/pain_factor = 1
	if(istype(pulledby, /mob/living/carbon))
		var/mob/living/carbon/C = pulledby
		pain_factor += C.get_pain_percent() * 0.5

	resist_chance *= pain_factor

	adjust_stamina(rand(2,5))
	pulledby.adjust_stamina(rand(2,5))
	if(iscarbon(pulledby))
		var/mob/living/carbon/carbon_pulledby = pulledby
		grab_counter_attack(carbon_pulledby)
		carbon_pulledby.add_grab_fatigue(0.5)

	MOBTIMER_SET(pulledby, MT_RESIST_GRAB)

	var/shitte = ""
	if(client?.prefs.showrolls)
		shitte = " ([resist_chance]%)"
	if(prob(resist_chance))
		visible_message("<span class='warning'>[src] breaks free of [pulledby]'s grip!</span>", \
						"<span class='notice'>I break free of [pulledby]'s grip![shitte]</span>", null, null, pulledby)
		to_chat(pulledby, "<span class='danger'>[src] breaks free of my grip!</span>")
		log_combat(pulledby, src, "broke grab")
		pulledby.stop_pulling(pulling_broke_free = TRUE)
		playsound(src.loc, 'sound/combat/grabbreak.ogg', 50, TRUE, -1)
		. = FALSE
	else
		visible_message(span_warning("[src] struggles to break free from [L]'s grasp!"), \
						span_warning("I struggle against [L]'s grasp![shitte]"), null, null)
		playsound(src.loc, 'sound/combat/grabstruggle.ogg', 50, TRUE, -1)
		pulledby.Immobilize(rand(1, 3))

	SEND_SIGNAL(src, COMSIG_LIVING_RESIST_GRAB, src, pulledby, moving_resist, .)

/mob/living/carbon/human/resist_grab(moving_resist)
	var/mob/living/L = pulledby
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if((HAS_TRAIT(H, TRAIT_NOSEGRAB) && !HAS_TRAIT(src, TRAIT_MISSING_NOSE)) || (HAS_TRAIT(H, TRAIT_EARGRAB) && age == AGE_CHILD))
			var/obj/item/bodypart/head = get_bodypart(BODY_ZONE_HEAD)
			for(var/obj/item/grabbing/G in grabbedby)
				if(G.limb_grabbed == head)
					if(G.grabbee == pulledby)
						if(HAS_TRAIT(H, TRAIT_NOSEGRAB) && G.sublimb_grabbed == BODY_ZONE_PRECISE_NOSE)
							visible_message("<span class='warning'>[src] struggles to break free from [pulledby]'s grip!</span>", \
											"<span class='warning'>I struggle against [pulledby]'s grip!</span>", null, null, pulledby)
							to_chat(pulledby, "<span class='warning'>[src] struggles against my grip!</span>")
							playsound(src, 'sound/combat/grabstruggle.ogg', 50, TRUE, -1)
							client?.move_delay = world.time + 20
							return TRUE
						if(HAS_TRAIT(H, TRAIT_EARGRAB) && G.sublimb_grabbed == BODY_ZONE_PRECISE_EARS)
							visible_message("<span class='warning'>[src] struggles to break free from [pulledby]'s grip!</span>", \
												"<span class='warning'>I struggle against [pulledby]'s grip!</span>", null, null, pulledby)
							to_chat(pulledby, "<span class='warning'>[src] struggles against my grip!</span>")
							playsound(src, 'sound/combat/grabstruggle.ogg', 50, TRUE, -1)
							client?.move_delay = world.time + 20
							return TRUE
	return ..()

/mob/living/proc/resist_buckle()
	buckled.user_unbuckle_mob(src,src)
	return TRUE

/mob/living/proc/resist_fire()
	return

/mob/living/proc/resist_restraints()
	return

/mob/living/proc/get_visible_name()
	return name

// The src mob is trying to strip an item from someone
// Override if a certain type of mob should be behave differently when stripping items (can't, for example)
/mob/living/stripPanelUnequip(obj/item/what, mob/who, where)
	if(!what.canStrip(who))
		to_chat(src, "<span class='warning'>I can't remove \the [what.name], it appears to be stuck!</span>")
		return

	if(!has_active_hand()) //can't attack without a hand.
		to_chat(src, "<span class='warning'>I lack working hands.</span>")
		return

	if(!has_hand_for_held_index(active_hand_index)) //can't attack without a hand.
		to_chat(src, "<span class='warning'>I can't move this hand.</span>")
		return

	if(check_arm_grabbed(active_hand_index))
		to_chat(src, "<span class='warning'>Someone is grabbing my arm!</span>")
		return

	var/surrender_mod = 1
	if(isliving(who))
		var/mob/living/L = who
		if(L.surrendering)
			surrender_mod = 0.5

	if(!who.Adjacent(src))
		return
	if(!enhanced_strip)
		who.visible_message("<span class='warning'>[src] tries to remove [who]'s [what.name].</span>", \
						"<span class='danger'>[src] tries to remove my [what.name].</span>", null, null, src)
	to_chat(src, "<span class='danger'>I try to remove [who]'s [what.name]...</span>")
	what.add_fingerprint(src)
	var/strip_delayed = what.strip_delay
	if(enhanced_strip)
		strip_delayed = 0.1 SECONDS
	if(do_after(src, strip_delayed * surrender_mod, who))
		if(what && (Adjacent(who) || (enhanced_strip && (get_dist(src, who) <= 3))))
			enhanced_strip = FALSE
			if(islist(where))
				var/list/L = where
				if(what == who.get_item_for_held_index(L[2]))
					if(what.doStrip(src, who))
						log_combat(src, who, "stripped [what] off")
			if(what == who.get_item_by_slot(where))
				if(what.doStrip(src, who))
					log_combat(src, who, "stripped [what] off")

	if(Adjacent(who)) //update inventory window
		who.show_inv(src)
	else
		src << browse(null,"window=mob[REF(who)]")

// The src mob is trying to place an item on someone
// Override if a certain mob should be behave differently when placing items (can't, for example)
/mob/living/stripPanelEquip(obj/item/what, mob/who, where)
	what = src.get_active_held_item()
	if(what && (HAS_TRAIT(what, TRAIT_NODROP)))
		to_chat(src, "<span class='warning'>I can't put \the [what.name] on [who], it's stuck to my hand!</span>")
		return
	if(what)
		var/list/where_list
		var/final_where

		if(islist(where))
			where_list = where
			final_where = where[1]
		else
			final_where = where

		if(!what.mob_can_equip(who, src, final_where, TRUE, TRUE))
			to_chat(src, "<span class='warning'>\The [what.name] doesn't fit in that place!</span>")
			return

		who.visible_message("<span class='notice'>[src] tries to put [what] on [who].</span>", \
						"<span class='notice'>[src] tries to put [what] on you.</span>", null, null, src)
		to_chat(src, "<span class='notice'>I try to put [what] on [who]...</span>")
		if(do_after(src, what.equip_delay_other, who))
			if(what && Adjacent(who) && what.mob_can_equip(who, src, final_where, TRUE, TRUE))
				if(temporarilyRemoveItemFromInventory(what))
					if(where_list)
						if(!who.put_in_hand(what, where_list[2]))
							what.forceMove(get_turf(who))
					else
						who.equip_to_slot(what, where, TRUE)

		if(Adjacent(who)) //update inventory window
			who.show_inv(src)
		else
			src << browse(null,"window=mob[REF(who)]")

/mob/living/proc/get_standard_pixel_x_offset()
	var/_x = base_pixel_x
	for(var/o in mob_offsets)
		if(mob_offsets[o])
			if(mob_offsets[o]["x"])
				_x = _x + mob_offsets[o]["x"]
	return _x + body_position_pixel_x_offset

/mob/living/proc/get_standard_pixel_y_offset()
	var/_y = base_pixel_y
	for(var/o in mob_offsets)
		if(mob_offsets[o])
			if(mob_offsets[o]["y"])
				_y = _y + mob_offsets[o]["y"]
	return _y + body_position_pixel_y_offset

/mob/living/cancel_camera()
	..()
	cameraFollow = null

/mob/living/proc/can_track(mob/living/user)
	//basic fast checks go first. When overriding this proc, I recommend calling ..() at the end.
	if(SEND_SIGNAL(src, COMSIG_LIVING_CAN_TRACK, args) & COMPONENT_CANT_TRACK)
		return FALSE
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	if(is_centcom_level(T.z)) //dont detect mobs on centcom
		return FALSE
	if(is_away_level(T.z))
		return FALSE
	if(user != null && src == user)
		return FALSE
	if(invisibility || alpha == 0)//cloaked
		return FALSE
	return TRUE

//used in datum/reagents/reaction() proc
/mob/living/proc/get_permeability_protection(list/target_zones)
	return 0

/mob/living/proc/harvest(mob/living/user) //used for extra objects etc. in butchering
	return

/mob/living/can_hold_items(obj/item/I)
	return ..() && usable_hands

/mob/living/can_perform_action(atom/movable/target, action_bitflags)
	if(!istype(target))
		CRASH("Missing target arg for can_perform_action")

	// If the MOBILITY_UI bitflag is not set it indicates the mob's hands are cutoff, blocked, or handcuffed
	// Also if it is not set, the mob could be incapcitated, knocked out, unconscious, asleep, EMP'd, etc.
	// Honestly this should be a body_position check but that can be done later
	if(!(mobility_flags & MOBILITY_UI) && !(action_bitflags & ALLOW_RESTING))
		to_chat(src, span_warning("You can't do that right now!"))
		return FALSE

	// // NEED_HANDS is already checked by MOBILITY_UI for humans so this is for silicons
	// if((action_bitflags & NEED_HANDS))
	// 	if(!can_hold_items(isitem(target) ? target : null)) // almost redundant if it weren't for mobs
	// 		to_chat(src, span_warning("You don't have the physical ability to do this!"))
	// 		return FALSE

	if(!Adjacent(target) && (target.loc != src))
		if((action_bitflags & FORBID_TELEKINESIS_REACH))
			to_chat(src, span_warning("You are too far away!"))
			return FALSE

	if((action_bitflags & NEED_DEXTERITY) && !IsAdvancedToolUser()) // !ISADVANCEDTOOLUSER(src)
		to_chat(src, span_warning("You don't have the dexterity to do this!"))
		return FALSE

	if((action_bitflags & NEED_LITERACY) && !is_literate())
		to_chat(src, span_warning("You can't comprehend any of this!"))
		return FALSE

	if((action_bitflags & NEED_LIGHT) && !has_light_nearby() && !has_nightvision())
		to_chat(src, span_warning("You need more light to do this!"))
		return FALSE

	return TRUE

/mob/living/proc/can_use_guns(obj/item/G)//actually used for more than guns!
	if(G.trigger_guard == TRIGGER_GUARD_NONE)
		to_chat(src, "<span class='warning'>I am unable to fire this!</span>")
		return FALSE
	if(G.trigger_guard != TRIGGER_GUARD_ALLOW_ALL && !IsAdvancedToolUser())
		to_chat(src, "<span class='warning'>I try to fire [G], but can't use the trigger!</span>")
		return FALSE
	return TRUE

/mob/living/proc/owns_soul()
	if(mind)
		return mind.soulOwner == mind
	return TRUE

/mob/living/proc/return_soul()
	hellbound = 0
	if(mind)
		mind.soulOwner = mind

/mob/living/proc/check_weakness(obj/item/weapon, mob/living/attacker)
	return 1 //This is not a boolean, it's the multiplier for the damage the weapon does.

/mob/living/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force, gentle = FALSE)
	stop_pulling()
	. = ..()

// Used in polymorph code to shapeshift mobs into other creatures
/**
 * Polymorphs our mob into another mob.
 * If successful, our current mob is qdeleted!
 *
 * what_to_randomize - what are we randomizing the mob into? See the defines for valid options.
 * change_flags - only used for humanoid randomization (currently), what pool of changeflags should we draw from?
 *
 * Returns a mob (what our mob turned into) or null (if we failed).
 */
/mob/living/proc/wabbajack(what_to_randomize, change_flags = WABBAJACK)
	if(stat == DEAD || (status_flags & GODMODE) || HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

	if(SEND_SIGNAL(src, COMSIG_LIVING_PRE_WABBAJACKED, what_to_randomize) & STOP_WABBAJACK)
		return

	add_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED, TRAIT_NO_TRANSFORM), MAGIC_TRAIT)
	icon = null
	cut_overlays()
	invisibility = INVISIBILITY_ABSTRACT

	var/list/item_contents = list()

	for(var/obj/item/item in src)
		if(!dropItemToGround(item))
			qdel(item)
			continue
		item_contents += item

	var/mob/living/new_mob

	var/static/list/possible_results = list(
		WABBAJACK_HUMAN,
		WABBAJACK_ANIMAL,
	)

	// If we weren't passed one, pick a default one
	what_to_randomize ||= pick(possible_results)

	switch(what_to_randomize)

		if(WABBAJACK_ANIMAL)
			var/picked_animal = pick(
				/mob/living/simple_animal/hostile/retaliate/bat,
				/mob/living/simple_animal/hostile/retaliate/chicken,
				/mob/living/simple_animal/hostile/retaliate/cow,
				/mob/living/simple_animal/hostile/retaliate/goat,
				/mob/living/simple_animal/hostile/retaliate/spider,
				/mob/living/simple_animal/pet/cat,
				/mob/living/simple_animal/pet/cat/cabbit,
			)
			new_mob = new picked_animal(loc)

		if(WABBAJACK_HUMAN)
			var/mob/living/carbon/human/new_human = new(loc)

			// 50% chance that we'll also randomice race
			if(prob(50))
				var/list/chooseable_races = list()
				for(var/datum/species/species_type as anything in subtypesof(/datum/species))
					if(initial(species_type.changesource_flags) & change_flags)
						chooseable_races += species_type

				if(length(chooseable_races))
					new_human.set_species(pick(chooseable_races))

			// Randomize everything but the species, which was already handled above.
			new_human.randomize_human_appearance(~RANDOMIZE_SPECIES)
			new_human.update_body()
			new_human.dna.update_dna_identity()
			new_mob = new_human

		else
			stack_trace("wabbajack() was called without an invalid randomization choice. ([what_to_randomize])")

	if(!new_mob)
		return

	to_chat(src, span_hypnophrase(span_big("Your form morphs into that of a [what_to_randomize]!")))

	// And of course, make sure they get policy for being transformed
	var/poly_msg = get_policy(POLICY_POLYMORPH)
	if(poly_msg)
		to_chat(src, poly_msg)

	// Some forms can still wear some items
	for(var/obj/item/item as anything in item_contents)
		new_mob.equip_to_appropriate_slot(item)

	// // I don't actually know why we do this
	// new_mob.set_combat_mode(TRUE)

	// on_wabbajack is where we handle setting up the name,
	// transfering the mind and observerse, and other miscellaneous
	// actions that should be done before we delete the original mob.
	on_wabbajacked(new_mob)

	qdel(src)
	return new_mob

// Called when we are hit by a bolt of polymorph and changed
// Generally the mob we are currently in is about to be deleted
/mob/living/proc/on_wabbajacked(mob/living/new_mob)
	log_message("became [new_mob.name] ([new_mob.type])", LOG_ATTACK, color = "orange")
	SEND_SIGNAL(src, COMSIG_LIVING_ON_WABBAJACKED, new_mob)
	new_mob.name = real_name
	new_mob.real_name = real_name
	// Transfer mind to the new mob (also handles actions and observers and stuff)
	if(mind)
		mind.transfer_to(new_mob)

	// Well, no mmind, guess we should try to move a key over
	else if(key)
		new_mob.PossessByPlayer(key)

/mob/living/proc/fakefireextinguish()
	return

/mob/living/proc/fakefire()
	return

//Mobs on Fire
/mob/living/proc/IgniteMob()
	if(!ishuman(src) && HAS_TRAIT(src, TRAIT_NOFIRE))
		return
	if((fire_stacks > 0 || divine_fire_stacks > 0) && !on_fire)
		on_fire = TRUE
		src.visible_message("<span class='warning'>[src] catches fire!</span>", \
						"<span class='danger'>I'm set on fire!</span>")
		new/obj/effect/dummy/lighting_obj/moblight/fire(src)
		throw_alert("fire", /atom/movable/screen/alert/fire)
		update_fire()
		SEND_SIGNAL(src, COMSIG_LIVING_IGNITED,src)
		return TRUE
	return FALSE


/mob/living/proc/SoakMob(locations, dirty_water = FALSE, rain = FALSE)
	if(locations & CHEST)
		ExtinguishMob()
		if(locations & HEAD)
			adjust_fire_stacks(-2)
		else
			adjust_fire_stacks(-1)

/mob/living/proc/ExtinguishMob()
	if(on_fire)
		on_fire = FALSE
		fire_stacks = 0
		divine_fire_stacks = 0
		for(var/obj/effect/dummy/lighting_obj/moblight/fire/F in src)
			qdel(F)
		clear_alert("fire")
		remove_stress(/datum/stress_event/on_fire)
		SEND_SIGNAL(src, COMSIG_LIVING_EXTINGUISHED, src)
		update_fire()
	for(var/obj/item/I in (get_equipped_items() + held_items))
		I.extinguish()

/mob/living/proc/adjust_fire_stacks(add_fire_stacks) //Adjusting the amount of fire_stacks we have on person
	if(HAS_TRAIT(src, TRAIT_NOFIRE) && add_fire_stacks > 0)
		add_fire_stacks = 0
	fire_stacks = CLAMP(fire_stacks + add_fire_stacks, -20, 100)
	if(on_fire && (fire_stacks <= 0) && (divine_fire_stacks <= 0))
		ExtinguishMob()

/mob/living/proc/adjust_divine_fire_stacks(add_fire_stacks) //Adjusting the amount of divine_fire_stacks we have on person. Always call before adjust_fire_stacks for proper extinguish behavior
	divine_fire_stacks = CLAMP(divine_fire_stacks + add_fire_stacks, 0, 100)

//Share fire evenly between the two mobs
//Called in MobBump() and Crossed()
/mob/living/proc/spreadFire(mob/living/L)
	if(!istype(L))
		return
	if(HAS_TRAIT(L, TRAIT_NOFIRE) || HAS_TRAIT(src, TRAIT_NOFIRE))
		return
	if(on_fire && fire_stacks > 0)
		if(L.on_fire) // If they were also on fire
			var/firesplit = (fire_stacks + L.fire_stacks)/2
			fire_stacks = firesplit
			L.fire_stacks = firesplit
		else // If they were not
			fire_stacks /= 2
			L.fire_stacks += fire_stacks
			if(L.IgniteMob()) // Ignite them
				log_game("[key_name(src)] bumped into [key_name(L)] and set them on fire")

	else if(L.on_fire) // If they were on fire and we were not
		L.fire_stacks /= 2
		fire_stacks += L.fire_stacks
		IgniteMob() // Ignite us

//Mobs on Fire end

// used by secbot and monkeys Crossed
/mob/living/proc/knockOver(mob/living/carbon/C)
	if(C.key) //save us from monkey hordes
		C.visible_message("<span class='warning'>[pick( \
						"[C] dives out of [src]'s way!", \
						"[C] stumbles over [src]!", \
						"[C] jumps out of [src]'s path!", \
						"[C] trips over [src] and falls!", \
						"[C] topples over [src]!", \
						"[C] leaps out of [src]'s way!")]</span>")
	C.Paralyze(40)

/mob/living/ConveyorMove()
	if((movement_type & FLYING) && !stat)
		return
	..()

/mob/living/can_be_pulled()
	return ..() && !(buckled && buckled.buckle_prevents_pull)

/mob/living/proc/fall(forced)
	if(!(mobility_flags & MOBILITY_USE))
		drop_all_held_items()

/// Called when mob changes from a standing position into a prone while lacking the ability to stand up at the moment.
/mob/living/proc/on_fall()
	return

/mob/living/forceMove(atom/destination)
//	stop_pulling()
//	if(buckled)
//		buckled.unbuckle_mob(src, force = TRUE)
//	if(has_buckled_mobs())
//		unbuckle_all_mobs(force = TRUE)
	. = ..()
	if(.)
		if(client)
			reset_perspective()

/mob/living/proc/update_z(new_z) // 1+ to register, null to unregister
	if (registered_z != new_z)
		if (registered_z)
			SSmobs.clients_by_zlevel[registered_z] -= src
		if (client)
			//Check the amount of clients exists on the Z level we're leaving from,
			//this excludes us because at this point we are not registered to any z level.
			var/old_level_new_clients = (registered_z ? SSmobs.clients_by_zlevel[registered_z].len : null)
			if(registered_z && old_level_new_clients == 0)
				if(SSmapping.level_has_any_trait(registered_z, list(ZTRAIT_IGNORE_WEATHER_TRAIT)) && !SSmapping.level_has_any_trait(new_z, list(ZTRAIT_IGNORE_WEATHER_TRAIT)))
					for(var/datum/ai_controller/controller as anything in GLOB.ai_controllers_by_zlevel[registered_z])
						controller.set_ai_status(AI_STATUS_OFF)

			if (new_z)
				//Check the amount of clients exists on the Z level we're moving towards, excluding ourselves.
				var/new_level_old_clients = SSmobs.clients_by_zlevel[new_z].len
				SSmobs.clients_by_zlevel[new_z] += src

				if(new_level_old_clients == 0) //No one was here before, wake up all the AIs.
					for (var/datum/ai_controller/controller as anything in GLOB.ai_controllers_by_zlevel[new_z])
						//We don't set them directly on, for instances like AIs acting while dead and other cases that may exist in the future.
						//This isn't a problem for AIs with a client since the client will prevent this from being called anyway.
						controller.set_ai_status(controller.get_expected_ai_status())

			registered_z = new_z
		else
			registered_z = null

/mob/living/onTransitZ(old_z,new_z)
	..()
	update_z(new_z)

/mob/living/MouseDrop(mob/over)
	. = ..()
	var/mob/living/user = usr
	if(HAS_TRAIT(src, TRAIT_TINY) && isturf(over.loc))
		if(stat == DEAD || !Adjacent(over))
			return
		if(incapacitated())
			return
		for(var/obj/item/grabbing/G in grabbedby)
			if(G.grab_state == GRAB_AGGRESSIVE)
				return
		var/datum/component/storage = over.GetComponent(/datum/component/storage)
		if(storage)
			var/obj/item/mob_holder/holder = new(get_turf(src), src)
			visible_message(span_warning("[src] starts to climb into [over]."), span_warning("You start to climb into [over]."))
			if(do_after(src, 1.2 SECONDS, over))
				if(over.loc == src)
					return
				if(!SEND_SIGNAL(over, COMSIG_TRY_STORAGE_INSERT, holder, null, TRUE, TRUE))
					qdel(holder)

	if(HAS_TRAIT(src, TRAIT_TINY) && ismob(over) && over != src)
		if(stat == DEAD || !Adjacent(over))
			return
		if(incapacitated())
			return
		for(var/obj/item/grabbing/G in grabbedby)
			if(G.grab_state == GRAB_AGGRESSIVE)
				return
		var/list/pickable_items = list()
		for(var/obj/item/item in over.get_all_contents())
			var/datum/component/storage = item.GetComponent(/datum/component/storage)
			if(storage)
				pickable_items |= item
		var/obj/item/picked = input(src, "What bag do you want to crawl into?") as null|anything in pickable_items
		if(!picked)
			return
		var/obj/item/mob_holder/holder = new(get_turf(src), src)
		visible_message(span_warning("[src] starts to climb into [picked] on [over]."), span_warning("You start to climb into [picked] on [over]."))
		if(do_after(src, 3 SECONDS, over))
			if(picked.loc == src)
				return
			if(!SEND_SIGNAL(picked, COMSIG_TRY_STORAGE_INSERT, holder, null, TRUE, TRUE))
				qdel(holder)

	if(!istype(over) || !istype(user))
		return
	if(!over.Adjacent(src) || (user != src) || !can_perform_action(over))
		return

/mob/living/MouseDrop_T(atom/dropping, atom/user)
	var/mob/living/U = user
	if(!user.Adjacent(src))
		return
	if(isliving(dropping))
		var/mob/living/M = dropping
		if((M.can_be_held ||  HAS_TRAIT(M, TRAIT_TINY)) && U.cmode)
			M.mob_try_pickup(U)//blame kevinz
			return//dont open the mobs inventory if you are picking them up
	. = ..()


/mob/living/proc/mob_pickup(mob/living/user)
	var/obj/item/mob_holder/holder = new(get_turf(src), src)
	user.visible_message(span_warning("[user] scoops up [src]!"))
	user.put_in_hands(holder)

/mob/living/proc/mob_try_pickup(mob/living/user)
	if(!ishuman(user))
		return
	if(user.get_active_held_item())
		to_chat(user, "<span class='warning'>My hands are full!</span>")
		return FALSE
	if(buckled)
		to_chat(user, "<span class='warning'>[src] is buckled to something!</span>")
		return FALSE
	user.visible_message("<span class='warning'>[user] starts trying to scoop up [src]!</span>", \
					"<span class='danger'>I start trying to scoop up [src]...</span>", null, null, src)
	to_chat(src, "<span class='danger'>[user] starts trying to scoop you up!</span>")
	if(!do_after(user, 2 SECONDS, src))
		return FALSE
	mob_pickup(user)
	return TRUE

/mob/living/reset_perspective(atom/A)
	if(..())
		update_sight()
		if(client.eye && client.eye != src)
			var/atom/AT = client.eye
			AT.get_remote_view_fullscreens(src)
		else
			clear_fullscreen("remote_view", 0)

/mob/living/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_STATS, "Modify Stats")

/mob/living/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_MODIFY_STATS])
		if(!check_rights(R_ADMIN))
			return

		switch(browser_alert(usr, "Add or remove?", "MODIFY STATS", list("ADD", "REMOVE")))
			if("REMOVE")
				if(!LAZYLEN(stat_modifiers))
					return

				var/source = browser_input_list(usr, "Source to Remove", "MODIFY STATS", stat_modifiers)
				if(!source)
					return

				remove_stat_modifier(source)
			if("ADD")
				var/stat_key = browser_input_list(usr, "Stat to Add", "MODIFY STATS", MOBSTATS)
				if(!stat_key)
					return

				var/amount = input(usr, "Stat amount", "MODIFY_STATS") as num|null
				if(!amount)
					return

				set_stat_modifier(ADMIN_TRAIT, stat_key, amount)
		return

/mob/living/vv_edit_var(var_name, var_value)
	switch(var_name)
		if ("maxHealth")
			if (!isnum(var_value) || var_value <= 0)
				return FALSE
		if("stat")
			if((stat == DEAD) && (var_value < DEAD))//Bringing the dead back to life
				GLOB.dead_mob_list -= src
				GLOB.alive_mob_list += src
			if((stat < DEAD) && (var_value == DEAD))//Kill he
				GLOB.alive_mob_list -= src
				GLOB.dead_mob_list += src
	. = ..()
	switch(var_name)
		if("knockdown")
			SetKnockdown(var_value)
		if("paralyzed")
			SetParalyzed(var_value)
		if("stun")
			SetStun(var_value)
		if("unconscious")
			SetUnconscious(var_value)
		if("sleeping")
			SetSleeping(var_value)
		if("eye_blind")
			adjust_temp_blindness(var_value)
		if("eye_damage")
			var/obj/item/organ/eyes/E = getorganslot(ORGAN_SLOT_EYES)
			if(E)
				E.setOrganDamage(var_value)
		if("maxHealth")
			updatehealth()
		if("resize")
			update_transform()
		if("lighting_alpha")
			sync_lighting_plane_alpha()

/mob/living/vv_get_header()
	. = ..()
	var/refid = REF(src)
	. += {"
		<br><font size='1'>[VV_HREF_TARGETREF_1V(refid, VV_HK_BASIC_EDIT, "[ckey || "no ckey"]", NAMEOF(src, ckey))] / [VV_HREF_TARGETREF_1V(refid, VV_HK_BASIC_EDIT, "[real_name || "no real name"]", NAMEOF(src, real_name))]</font>
		<br><font size='1'>
			BRUTE:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=brute' id='brute'>[getBruteLoss()]</a>
			FIRE:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=fire' id='fire'>[getFireLoss()]</a>
			TOXIN:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=toxin' id='toxin'>[getToxLoss()]</a>
			OXY:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=oxygen' id='oxygen'>[getOxyLoss()]</a>
			CLONE:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=clone' id='clone'>[getCloneLoss()]</a>
			BRAIN:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=brain' id='brain'>[getOrganLoss(ORGAN_SLOT_BRAIN)]</a>
		</font>
	"}

/**
	* Changes the inclination angle of a mob, used by humans and others to differentiate between standing up and prone positions.
	*
	* In BYOND-angles 0 is NORTH, 90 is EAST, 180 is SOUTH and 270 is WEST.
	* This usually means that 0 is standing up, 90 and 270 are horizontal positions to right and left respectively, and 180 is upside-down.
	* Mobs that do now follow these conventions due to unusual sprites should require a special handling or redefinition of this proc, due to the density and layer changes.
	* The return of this proc is the previous value of the modified lying_angle if a change was successful (might include zero), or null if no change was made.
**/
/mob/living/proc/set_lying_angle(new_lying)
	if(new_lying == lying_angle)
		return
	. = lying_angle
	lying_angle = new_lying
	if(lying_angle != lying_prev)
		update_transform()
		lying_prev = lying_angle

/// Updates the grab state of the mob and updates movespeed
/mob/living/setGrabState(newstate)
	. = ..()
	switch(grab_state)
		if(GRAB_PASSIVE)
			remove_movespeed_modifier(MOVESPEED_ID_MOB_GRAB_STATE)
		if(GRAB_AGGRESSIVE)
			if(pulling) // grabbing yourself doesn't set pulling
				add_movespeed_modifier(MOVESPEED_ID_MOB_GRAB_STATE, TRUE, 100, override=TRUE, multiplicative_slowdown = 3, blacklisted_movetypes=FLOATING)
		if(GRAB_NECK)
			if(pulling) // grabbing yourself doesn't set pulling
				add_movespeed_modifier(MOVESPEED_ID_MOB_GRAB_STATE, TRUE, 100, override=TRUE, multiplicative_slowdown = 6, blacklisted_movetypes=FLOATING)
		if(GRAB_KILL)
			if(pulling) // grabbing yourself doesn't set pulling
				add_movespeed_modifier(MOVESPEED_ID_MOB_GRAB_STATE, TRUE, 100, override=TRUE, multiplicative_slowdown = 9, blacklisted_movetypes=FLOATING)

///Reports the event of the change in value of the buckled variable.
/mob/living/proc/set_buckled(new_buckled)
	if(new_buckled == buckled)
		return
	SEND_SIGNAL(src, COMSIG_LIVING_SET_BUCKLED, new_buckled)
	. = buckled
	buckled = new_buckled
	if(buckled)
		if(!HAS_TRAIT(buckled, TRAIT_NO_IMMOBILIZE))
			ADD_TRAIT(src, TRAIT_IMMOBILIZED, BUCKLED_TRAIT)
		switch(buckled.buckle_lying)
			if(NO_BUCKLE_LYING) // The buckle doesn't force a lying angle.
				REMOVE_TRAIT(src, TRAIT_FLOORED, BUCKLED_TRAIT)
			if(0) // Forcing to a standing position.
				REMOVE_TRAIT(src, TRAIT_FLOORED, BUCKLED_TRAIT)
				set_body_position(STANDING_UP)
				set_lying_angle(0)
			else // Forcing to a lying position.
				ADD_TRAIT(src, TRAIT_FLOORED, BUCKLED_TRAIT)
				set_body_position(LYING_DOWN)
				set_lying_angle(buckled.buckle_lying)
	else
		REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, BUCKLED_TRAIT)
		REMOVE_TRAIT(src, TRAIT_FLOORED, BUCKLED_TRAIT)
		if(.) // We unbuckled from something.
			var/atom/movable/old_buckled = .
			if(old_buckled.buckle_lying == 0 && (resting || HAS_TRAIT(src, TRAIT_FLOORED))) // The buckle forced us to stay up (like a chair)
				set_lying_down() // We want to rest or are otherwise floored, so let's drop on the ground.

///Proc to modify the value of num_legs and hook behavior associated to this event.
/mob/living/proc/set_num_legs(new_value)
	if(num_legs == new_value)
		return
	. = num_legs
	num_legs = new_value

///Proc to modify the value of usable_legs and hook behavior associated to this event.
/mob/living/proc/set_usable_legs(new_value)
	if(usable_legs == new_value)
		return
	. = usable_legs
	usable_legs = new_value

	update_limbless_locomotion()
	update_limbless_movespeed_mod()

/// Updates whether the mob is floored or immobilized based on how many limbs they have or are missing.
/mob/living/proc/update_limbless_locomotion()
	if(usable_legs > 0 || (movement_type & (FLYING|FLOATING)) || COUNT_TRAIT_SOURCES(src, TRAIT_NO_LEG_AID) >= 2) // Gained leg usage
		REMOVE_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
		REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
		return
	// No legs, not flying
	ADD_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
	if(usable_hands == 0)
		ADD_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)

/// Updates the mob's movespeed based on how many limbs they have or are missing.
/mob/living/proc/update_limbless_movespeed_mod()
	if(usable_legs < default_num_legs)
		var/limbless_slowdown = (default_num_legs - usable_legs) * 3
		if(!usable_legs && usable_hands < default_num_hands)
			limbless_slowdown += (default_num_hands - usable_hands) * 3
		var/list/slowdown_mods = list()
		SEND_SIGNAL(src, COMSIG_LIVING_LIMBLESS_MOVESPEED_UPDATE, slowdown_mods)
		for(var/num in slowdown_mods)
			limbless_slowdown *= num
		add_movespeed_modifier(MOVESPEED_ID_LIVING_LIMBLESS, update=TRUE, priority=100, override=TRUE, multiplicative_slowdown=limbless_slowdown, movetypes=GROUND)
	else
		remove_movespeed_modifier(MOVESPEED_ID_LIVING_LIMBLESS, update=TRUE)

///Proc to modify the value of num_hands and hook behavior associated to this event.
/mob/living/proc/set_num_hands(new_value)
	if(num_hands == new_value)
		return
	. = num_hands
	num_hands = new_value

///Proc to modify the value of usable_hands and hook behavior associated to this event.
/mob/living/proc/set_usable_hands(new_value)
	if(usable_hands == new_value)
		return
	. = usable_hands
	usable_hands = new_value

	if(usable_legs < default_num_legs)
		update_limbless_locomotion()
		update_limbless_movespeed_mod()

/// Changes the value of the [living/body_position] variable.
/mob/living/proc/set_body_position(new_value)
	if(body_position == new_value)
		return
	. = body_position
	body_position = new_value
	SEND_SIGNAL(src, COMSIG_LIVING_SET_BODY_POSITION, new_value, .)
	if(new_value == LYING_DOWN) // From standing to lying down.
		on_lying_down()
	else // From lying down to standing up.
		on_standing_up()

	update_cone_show()

/// Proc to append behavior to the condition of being floored. Called when the condition starts.
/mob/living/proc/on_floored_start()
	if(body_position == STANDING_UP) //force them on the ground
		set_body_position(LYING_DOWN)
		set_lying_angle(pick(90, 270))
		on_fall()

/// Proc to append behavior to the condition of being floored. Called when the condition ends.
/mob/living/proc/on_floored_end()
	if(!resting)
		get_up()

/// Proc to append behavior to the condition of being handsblocked. Called when the condition starts.
/mob/living/proc/on_handsblocked_start()
	drop_all_held_items()
	ADD_TRAIT(src, TRAIT_UI_BLOCKED, TRAIT_HANDS_BLOCKED)
	ADD_TRAIT(src, TRAIT_PULL_BLOCKED, TRAIT_HANDS_BLOCKED)

/// Proc to append behavior to the condition of being handsblocked. Called when the condition ends.
/mob/living/proc/on_handsblocked_end()
	REMOVE_TRAIT(src, TRAIT_UI_BLOCKED, TRAIT_HANDS_BLOCKED)
	REMOVE_TRAIT(src, TRAIT_PULL_BLOCKED, TRAIT_HANDS_BLOCKED)

///Checks if the user is incapacitated or on cooldown.
/mob/living/proc/can_look_up()
	return !((next_move > world.time) || incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB))

/mob/living/proc/look_around()
	if(!client)
		return
	if(client.perspective != MOB_PERSPECTIVE) //We are already looking up.
		stop_looking()
		return
	if(client.pixel_x || client.pixel_y)
		stop_looking()
		return
	if(!can_look_up())
		return
	changeNext_move(CLICK_CD_EXHAUSTED)
	if(m_intent != MOVE_INTENT_SNEAK)
		visible_message(span_info("[src] looks around."), span_info("I look around."))
	var/looktime = 5 SECONDS - (STAPER * 2)
	if(has_quirk(/datum/quirk/boon/keen_eye))
		looktime *= 0.25
	if(do_after(src, looktime))
		// var/huhsneak
		SEND_GLOBAL_SIGNAL(COMSIG_MOB_ACTIVE_PERCEPTION, src)
		for(var/mob/living/M in oview(7, src))
			if(see_invisible < M.invisibility)
				continue
			if(HAS_TRAIT(M, TRAIT_IMPERCEPTIBLE)) // Check if the mob is affected by the invisibility spell
				continue
			var/probby = 3 * STAPER
			if(M.mind)
				probby -= (M.get_skill_level(/datum/skill/misc/sneaking, TRUE) * 10)
			probby = (max(probby, 5))
			if(prob(probby))
				found_ping(get_turf(M), client, "hidden")
				if(M.m_intent == MOVE_INTENT_SNEAK)
					emote("huh")
					to_chat(M, "<span class='danger'>[src] sees me! I'm found!</span>")
					MOBTIMER_SET(M, MT_FOUNDSNEAK)
			else
				if(M.m_intent == MOVE_INTENT_SNEAK)
					if(M.client?.prefs.showrolls)
						to_chat(M, "<span class='warning'>[src] didn't find me... [probby]%</span>")
					else
						to_chat(M, "<span class='warning'>[src] didn't find me.</span>")
				else
					found_ping(get_turf(M), client, "hidden")

		for(var/obj/O in view(7,src))
			if(istype(O, /obj/item/restraints/legcuffs/beartrap))
				var/obj/item/restraints/legcuffs/beartrap/M = O
				if(isturf(M.loc) && M.armed)
					found_ping(get_turf(M), client, "trap")
			if(istype(O, /obj/structure/flora/grass/maneater/real))
				found_ping(get_turf(O), client, "trap")
			if(istype(O, /obj/structure/lever/hidden) || istype(O, /obj/structure/door/secret))
				var/accessor_trait
				var/hidden_dc
				if(istype(O, /obj/structure/lever/hidden))
					var/obj/structure/lever/hidden/lever = O
					accessor_trait = lever.accessor_trait
					hidden_dc = lever.hidden_dc
				else
					var/obj/structure/door/secret/door = O
					accessor_trait = door.accessor_trait
					hidden_dc = door.hidden_dc
				var/bonuses = (HAS_TRAIT(src, TRAIT_THIEVESGUILD) || HAS_TRAIT(src, TRAIT_ASSASSIN)) ? 2 : 0
				if(STAPER + bonuses >= hidden_dc || (accessor_trait && HAS_MIND_TRAIT(src, accessor_trait)))
					found_ping(get_turf(O), client, "hidden")
		for(var/obj/effect/skill_tracker/potential_track in orange(7, src)) //Can't use view because they're invisible by default.
			if(!can_see(src, potential_track, 10))
				continue
			if(!potential_track.check_reveal(src))
				continue
			found_ping(get_turf(potential_track), client, "hidden")
			potential_track.handle_revealing(src)

/proc/found_ping(atom/A, client/C, state)
	if(!A || !C || !state)
		return
	var/image/I = image('icons/effects/effects.dmi', A, state)
	I.plane = ABOVE_LIGHTING_PLANE
	flick_overlay(I, list(C), 3 SECONDS)

/**
 * look_up Changes the perspective of the mob to any openspace turf above the mob
 *
 * This also checks if an openspace turf is above the mob before looking up or resets the perspective if already looking up
 *
 */
/mob/proc/look_up()
	return

/mob/living/look_up()
	if(client.perspective != MOB_PERSPECTIVE) //We are already looking up.
		stop_looking()
		return
	if(client.pixel_x || client.pixel_y)
		stop_looking()
		return
	if(!can_look_up())
		return
	changeNext_move(CLICK_CD_MELEE)
	if(m_intent != MOVE_INTENT_SNEAK)
		visible_message(span_info("[src] looks up."))
	var/turf/ceiling = get_step_multiz(src, UP)
	var/turf/T = get_turf(src)
	if(isnull(ceiling)) //Can't check what isn't there
		return
	if(!istransparentturf(ceiling)) //There is no turf we can look through above us
		to_chat(src, span_warning("A ceiling above my head."))
		return

	var/ttime = 1 SECONDS
	if(STAPER > 5)
		ttime -= (STAPER - 5)
		if(ttime < 0)
			ttime = 0

	if(!do_after(src, ttime))
		return
	reset_perspective(ceiling)
	update_cone_show()
	if(T.can_see_sky())
		switch(GLOB.forecast)
			if("prerain")
				to_chat(src, span_info("Dark clouds gather..."))
				return
			if("rain")
				to_chat(src, span_info("The wet wind is blowing."))
				return
			if("rainbow")
				to_chat(src, span_smallnotice("A beautiful rainbow!"))
				return
			if("fog")
				to_chat(src, span_warning("I can't see anything, the fog has set in."))
				return
		to_chat(src, span_info("There is nothing special to say about this weather."))
		do_time_change()

/mob/living/proc/look_further(turf/T)
	if(client.perspective != MOB_PERSPECTIVE)
		stop_looking()
		return
	if(client.pixel_x || client.pixel_y)
		stop_looking()
		return
	if(!can_look_up())
		return
	if(!istype(T))
		return
	changeNext_move(CLICK_CD_MELEE)

	var/_x = T.x-loc.x
	var/_y = T.y-loc.y
	if(_x > 7 || _x < -7)
		return
	if(_y > 7 || _y < -7)
		return
	hide_cone()
	var/ttime = 10
	if(STAPER > 5)
		ttime = 10 - (STAPER - 5)
		if(ttime < 0)
			ttime = 0
	if(m_intent != MOVE_INTENT_SNEAK)
		visible_message("<span class='info'>[src] looks into the distance.</span>")
	animate(client, pixel_x = world.icon_size*_x, pixel_y = world.icon_size*_y, ttime)
//	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(stop_looking))
	update_cone_show()

/mob/proc/look_down(turf/T)
	return

/mob/living/look_down(turf/T)
	if(client.pixel_x || client.pixel_y)
		stop_looking()
		return
	if(client.perspective != MOB_PERSPECTIVE)
		stop_looking()
		return
	if(!can_look_up())
		return
	if(!istype(T))
		return


	var/turf/OS = get_step_multiz(T, DOWN)

	if(!OS)
		return
	var/ttime = 1 SECONDS
	if(STAPER > 5)
		ttime -= (STAPER - 5)
		if(ttime < 0)
			ttime = 0

	visible_message("<span class='info'>[src] looks down through [T].</span>")

	if(!do_after(src, ttime))
		return

	changeNext_move(CLICK_CD_MELEE)
	reset_perspective(OS)
	update_cone_show()
//	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(stop_looking))

/mob/living/proc/stop_looking()
//	animate(client, pixel_x = 0, pixel_y = 0, 2, easing = SINE_EASING)
	if(client)
		client.pixel_x = 0
		client.pixel_y = 0
	reset_perspective()
	update_cone_show()
//	UnregisterSignal(src, COMSIG_MOVABLE_PRE_MOVE)

/mob/living/set_stat(new_stat)
	. = ..()
	if(isnull(.))
		return
	switch(.) //Previous stat.
		if(CONSCIOUS)
			if(stat >= UNCONSCIOUS)
				ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_KNOCKEDOUT)
			add_traits(list(TRAIT_HANDS_BLOCKED, TRAIT_INCAPACITATED, TRAIT_FLOORED), STAT_TRAIT)
		if(SOFT_CRIT)
			if(stat >= UNCONSCIOUS)
				ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_KNOCKEDOUT) //adding trait sources should come before removing to avoid unnecessary updates
			if(pulledby)
				REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, PULLED_WHILE_SOFTCRIT_TRAIT)
		if(UNCONSCIOUS)
			cure_blind(UNCONSCIOUS_TRAIT)
	switch(stat) //Current stat.
		if(CONSCIOUS)
			if(. >= UNCONSCIOUS)
				REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_KNOCKEDOUT)
			remove_traits(list(TRAIT_HANDS_BLOCKED, TRAIT_INCAPACITATED, TRAIT_FLOORED), STAT_TRAIT)
			log_combat(src, src, "regained consciousness")
		if(SOFT_CRIT)
			if(pulledby)
				ADD_TRAIT(src, TRAIT_IMMOBILIZED, PULLED_WHILE_SOFTCRIT_TRAIT) //adding trait sources should come before removing to avoid unnecessary updates
			if(. >= UNCONSCIOUS)
				REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_KNOCKEDOUT)
			log_combat(src, src, "entered soft crit")
		if(UNCONSCIOUS)
			become_blind(UNCONSCIOUS_TRAIT)
			log_combat(src, src, "lost consciousness")
		if(DEAD)
			log_combat(src, src, "died")
	if(!can_hear())
		stop_sound_channel(CHANNEL_AMBIENCE)
	refresh_looping_ambience()

/mob/living/set_pulledby(new_pulledby)
	. = ..()
	if(. == FALSE) //null is a valid value here, we only want to return if FALSE is explicitly passed.
		return
	if(pulledby)
		if(!. && stat == SOFT_CRIT)
			ADD_TRAIT(src, TRAIT_IMMOBILIZED, PULLED_WHILE_SOFTCRIT_TRAIT)
	else if(. && stat == SOFT_CRIT)
		REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, PULLED_WHILE_SOFTCRIT_TRAIT)

	for(var/hand in hud_used?.hand_slots)
		var/atom/movable/screen/inventory/hand/H = hud_used.hand_slots[hand]
		H?.update_appearance(UPDATE_OVERLAYS)

/// Proc for giving a mob a new 'friend', generally used for AI control and targeting. Returns false if already friends.
/mob/living/proc/befriend(mob/living/new_friend)
	SHOULD_CALL_PARENT(TRUE)
	var/friend_ref = REF(new_friend)
	if (faction.Find(friend_ref))
		return FALSE
	faction |= friend_ref
	ai_controller?.insert_blackboard_key_lazylist(BB_FRIENDS_LIST, new_friend)

	SEND_SIGNAL(src, COMSIG_LIVING_BEFRIENDED, new_friend)

	if(src in SSmatthios_mobs.matthios_mobs)
		SSmatthios_mobs.unregister_mob(src)
	if(cached_island_id)
		SSisland_mobs.remove_mob(src)

	return TRUE

/// Proc for removing a friend you added with the proc 'befriend'. Returns true if you removed a friend.
/mob/living/proc/unfriend(mob/living/old_friend)
	SHOULD_CALL_PARENT(TRUE)
	var/friend_ref = REF(old_friend)
	if (!faction.Find(friend_ref))
		return FALSE
	faction -= friend_ref
	ai_controller?.remove_thing_from_blackboard_key(BB_FRIENDS_LIST, old_friend)

	SEND_SIGNAL(src, COMSIG_LIVING_UNFRIENDED, old_friend)
	return TRUE

/mob/living/proc/get_carry_capacity()
	return max(45, max(STAEND, STACON) * 12)

///this is returned as decimal value between 0 and 1
/mob/living/proc/get_encumbrance()
	return 0

/mob/living/proc/get_total_weight()
	return 0

/mob/living/proc/encumbrance_to_dodge()
	return 1

/mob/living/proc/encumbrance_to_speed()

/// checks if this mob can do a dualwielding attack or defense
/mob/living/proc/dual_wielding_check()
	if(!ishuman(src)) // lol
		return FALSE

/mob/proc/food_tempted(/obj/item/W, mob/user)
	return

/mob/proc/taunted(mob/user)
	for(var/mob/living/simple_animal/hostile/retaliate/A in view(7,src))
		if(A.owner == user)
			A.emote("aggro")
	return

/mob/proc/shood(mob/user)
	return

/mob/proc/beckoned(mob/user)
	return

/mob/proc/get_punch_dmg()
	return

/**
 * Get spell instance or null from mob actions with instance or typepath.
 *
 * Args
 * * spell_type - Action instance or typepath
 * * specific - Ignore subtypes
 */
/mob/living/proc/get_spell(datum/action/cooldown/spell/spell_type, specific = FALSE)
	if(QDELETED(src) || !length(actions))
		return

	if(istype(spell_type))
		spell_type = spell_type.type

	if(!specific)
		return locate(spell_type) in actions

	for(var/datum/action/cooldown/spell/spell in actions)
		if(spell.type == spell_type)
			return spell

/**
 * Add action to mob via typepath or instance, only one spell of each type may be present at a time.
 *
 * Args
 * * spell_type - spell to add, if an instance source is not relevant
 * * silent - whether we give a message
 * * source - target of the action, handles deletion on parent removal
 *			  defaults to src and mind makes it transfer with the mind to new mobs.
 * * override - Replace existing spell if present, instead of returning early
 */
/mob/living/proc/add_spell(datum/action/cooldown/spell/spell_type, silent = TRUE, source, override = FALSE)
	if(QDELETED(src))
		return

	var/datum/action/cooldown/spell = get_spell(spell_type, TRUE)
	if(spell)
		if(!override)
			return
		QDEL_NULL(spell)

	if(istype(spell_type))
		spell = spell_type
	else
		if(!source)
			source = src
		spell = new spell_type(source)

	if(!silent)
		to_chat(src, span_nicegreen("I learnt [spell.name]!"))

	spell.Grant(src)

/mob/living/proc/remove_spell(datum/action/cooldown/spell/spell, return_skill_points = FALSE, silent = TRUE)
	if(QDELETED(src))
		return

	var/datum/action/cooldown/spell/real_spell = get_spell(spell, TRUE)
	if(!real_spell)
		return

	if(return_skill_points)
		used_spell_points = max(used_spell_points - real_spell.point_cost, 0)
		spell_points = max(spell_points + real_spell.point_cost, 0)
		check_learnspell()

	if(!silent)
		to_chat(src, span_boldwarning("I forgot [real_spell.name]!"))

	qdel(real_spell)

/**
 * Remove all spells from a mob with the same arguments as single removal
 *
 * Args
 * * return_skill_points - do we return the skillpoints for the spells?
 * * silent - do we notify the player of this change?
 * * source - Instead of removing all spells, remove all spells from this source.
 */
/mob/living/proc/remove_spells(return_skill_points = FALSE, silent = TRUE, source)
	if(QDELETED(src))
		return

	var/silent_individual = TRUE
	if(!silent && source)
		silent_individual = FALSE

	for(var/datum/action/cooldown/spell/spell in actions)
		if(source && (spell.target != source))
			continue
		remove_spell(spell, return_skill_points, silent_individual)

	if(!silent && !silent_individual)
		to_chat(src, span_boldwarning("I forgot all my spells!"))

/**
 * adjusts the amount of available spellpoints
 *
 * Args
 * * points - amount of points to grant or reduce
 * * used_points - ajust used points
*/
/mob/living/proc/adjust_spell_points(points, used_points = FALSE)
	if(QDELETED(src))
		return

	if(used_points)
		used_spell_points += points
	else
		spell_points += points

	check_learnspell()

/// Reset spell points and used spell points
/mob/living/proc/reset_spell_points(silent = TRUE)
	if(QDELETED(src))
		return

	spell_points = 0
	used_spell_points = 0

	if(!silent)
		to_chat(src, span_boldwarning("I lost all my spellpoints!"))

	check_learnspell()

/// Check if learnspell should be removed or granted
/mob/living/proc/check_learnspell()
	if(QDELETED(src))
		return

	if(get_spell(/datum/action/cooldown/spell/undirected/learn))
		return

	// Because of kobolds spellpoints can be decimal, but you can't do anything with that if below 1
	if(floor(spell_points - used_spell_points) > 0)
		add_spell(/datum/action/cooldown/spell/undirected/learn)

/**
 * purges all spells and skills
 * Vars:
 ** silent - do we notify the player of this change?
*/
/mob/living/proc/purge_combat_knowledge(silent = TRUE)
	purge_all_skills(silent)
	remove_spells(silent = silent)
	reset_spell_points(silent)

/mob/living/proc/offer_item(mob/living/offered_to, obj/offered_item)
	if(isnull(offered_to) || isnull(offered_item))
		stack_trace("no offered_to or offered_item in offer_item()")
		return

	var/time_left = COOLDOWN_TIMELEFT(src, offer_cooldown)

	if(time_left)
		to_chat(src, span_danger("I must wait [time_left / 10] seconds before offering again."))
		return FALSE

	offered_item_ref = WEAKREF(offered_item)

	var/stealthy = (m_intent == MOVE_INTENT_SNEAK)

	if(stealthy)
		to_chat(src, span_notice("I secretly offer [offered_item] to [offered_to]."))
		to_chat(offered_to, span_notice("[offered_to] secretly offers [offered_item] to me..."))
	else
		visible_message(
			span_notice("[src] offers [offered_item] to [offered_to] with an outstretched hand."), \
			span_notice("I offer [offered_item] to [offered_to] with an outstretched hand."), \
			vision_distance = COMBAT_MESSAGE_RANGE, \
			ignored_mobs = list(offered_to)
		)
		to_chat(offered_to, span_notice("[src] offers [offered_item] to me..."))

	new /obj/effect/temp_visual/offered_item_effect(get_turf(src), offered_item, src, offered_to, stealthy)

/mob/living/proc/cancel_offering_item(stealthy)
	var/obj/offered_item = offered_item_ref?.resolve()
	if(isnull(offered_item))
		stop_offering_item()
		return
	if(stealthy)
		to_chat(src, "I stop offering [offered_item ? offered_item : "the item"].")
	else
		visible_message(
			span_notice("[src] puts their hand back down."), \
			span_notice("I stop offering [offered_item ? offered_item : "the item"]."), \
			vision_distance = COMBAT_MESSAGE_RANGE, \
		)
	stop_offering_item()

/mob/living/proc/stop_offering_item()
	COOLDOWN_START(src, offer_cooldown, 1 SECONDS)
	SEND_SIGNAL(src, COMSIG_LIVING_STOPPED_OFFERING_ITEM)
	offered_item_ref = null
	update_a_intents()

/mob/living/proc/try_accept_offered_item(mob/living/offerer, obj/offered_item, stealthy)
	if(get_active_held_item())
		to_chat(src, span_warning("I need a free hand to take it!"))
		return FALSE

	accept_offered_item(offerer, offered_item, stealthy)
	return TRUE

/mob/living/proc/accept_offered_item(mob/living/offerer, obj/offered_item, stealthy)
	transferItemToLoc(offered_item, src)
	put_in_active_hand(offered_item)
	if(stealthy)
		to_chat(offerer, span_notice("[src] takes the secretly offered [offered_item]."))
		to_chat(src, span_notice("I take the secretly offered [offered_item] from [offerer]."))
	else
		to_chat(offerer, span_notice("[src] takes [offered_item] from my outstretched hand."))
		visible_message(
			span_warning("[src] takes [offered_item] from [offerer]'s outstretched hand!"), \
			span_notice("I take [offered_item] from [offerer]'s outstretched hand."), \
			vision_distance = COMBAT_MESSAGE_RANGE, \
			ignored_mobs = list(offerer)
		)
	SEND_SIGNAL(offered_item, COMSIG_OBJ_HANDED_OVER, src, offerer)
	offerer.stop_offering_item()

/mob/living/proc/is_dead() // bwuh
	return (!QDELETED(src) && (stat >= DEAD))

/// Set the eyesclosed var updating blindness and UI as needed
/mob/living/proc/set_eyes_closed(closed)
	if(eyesclosed == closed)
		return

	eyesclosed = closed

	if(eyesclosed)
		become_blind("eyelids")
	else
		cure_blind("eyelids")

	if(hud_used)
		var/atom/movable/screen/eye_intent/eyet = locate() in hud_used.static_inventory
		eyet?.update_appearance(UPDATE_ICON)
