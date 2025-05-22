/mob/living/New(loc, ...)
	. = ..()
	var/turf/turf = get_turf(loc)
	if(turf)
		if(SSmapping.level_has_any_trait(turf.z, list(ZTRAIT_IGNORE_WEATHER_TRAIT)))
			faction |= FACTION_MATTHIOS
			SSmobs.matthios_mobs |= src

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
	init_faith()
	if(has_reflection)
		create_reflection()

/mob/living/Destroy()
	if(FACTION_MATTHIOS in faction)
		SSmobs.matthios_mobs -= src
	surgeries = null
	if(LAZYLEN(status_effects))
		for(var/s in status_effects)
			var/datum/status_effect/S = s
			if(S.on_remove_on_mob_delete) //the status effect calls on_remove when its mob is deleted
				qdel(S)
			else
				S.be_replaced()
	if(ranged_ability)
		ranged_ability.remove_ranged_ability(src)
	if(buckled)
		buckled.unbuckle_mob(src,force=1)

	GLOB.mob_living_list -= src
	for(var/s in ownedSoullinks)
		var/datum/soullink/S = s
		S.ownerDies(FALSE)
		qdel(s) //If the owner is destroy()'d, the soullink is destroy()'d
	ownedSoullinks = null
	for(var/s in sharedSoullinks)
		var/datum/soullink/S = s
		S.sharerDies(FALSE)
		S.removeSoulsharer(src) //If a sharer is destroy()'d, they are simply removed
	sharedSoullinks = null
	return ..()


/mob/living/update_overlays()
	. = ..()
	update_reflection()

/mob/living/update_icon()
	. = ..()
	update_reflection()


/mob/living/proc/create_reflection()
	//Add custom reflection image
	var/mutable_appearance/MAM = new()
	//appearance stuff
	MAM.appearance = appearance
	if(render_target)
		MAM.render_source = render_target
	MAM.plane = REFLECTION_PLANE
	//transform stuff
	var/matrix/n_transform = MAM.transform
	n_transform.Scale(1, -1)
	MAM.transform = n_transform
	MAM.vis_flags = VIS_INHERIT_DIR
	//filters
	var/icon/I = icon('icons/turf/overlays.dmi', "whiteOverlay")
	I.Flip(NORTH)
	MAM.filters += filter(type = "alpha", icon = I)
	reflective_icon = MAM
	reflective_icon.pixel_y = -32
	add_overlay(reflective_icon)
	update_vision_cone()

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
	reflective_icon.appearance = appearance
	if(render_target)
		reflective_icon.render_source = render_target
	reflective_icon.plane = REFLECTION_PLANE
	reflective_icon.pixel_y = -32
	//transform stuff
	var/matrix/n_transform = reflective_icon.transform
	n_transform.Scale(1, -1)
	reflective_icon.transform = n_transform
	reflective_icon.vis_flags = VIS_INHERIT_DIR
	//filters
	var/icon/I = icon('icons/turf/overlays.dmi', "partialOverlay")
	I.Flip(NORTH)
	reflective_icon.filters += filter(type = "alpha", icon = I)
	add_overlay(reflective_icon)
	update_vision_cone()

/mob/living/onZImpact(turf/T, levels)
	if(HAS_TRAIT(src, TRAIT_NOFALLDAMAGE2))
		return
	if(HAS_TRAIT(src, TRAIT_NOFALLDAMAGE1))
		if(levels <= 2)
			return
	var/dex_save = src.get_skill_level(/datum/skill/misc/climbing)
	var/sneak_fall = FALSE // If we're sneaking, don't announce it to our surroundings
	if(dex_save >= 5) // Master climbers can fall down 2 levels without hurting themselves
		if(levels <= 2)
			to_chat(src, "<span class='info'>My dexterity allowed me to land on my feet unscathed!</span>")
			if(src.m_intent != MOVE_INTENT_SNEAK) // If we're sneaking, don't make a sound
				sneak_fall = TRUE
				playsound(src.loc, 'sound/foley/bodyfall (1).ogg', 100, FALSE)
			return
	var/points
	for(var/i in 2 to levels)
		i++
		points += "!"
	if(!sneak_fall)
		visible_message("<span class='danger'>[src] falls down[points]</span>", \
						"<span class='danger'>I fall down[points]</span>")
		playsound(src.loc, 'sound/foley/zfall.ogg', 100, FALSE)
	if(!isgroundlessturf(T))
		ZImpactDamage(T, levels)
		GLOB.vanderlin_round_stats[STATS_MOAT_FALLERS]++
	return ..()

/mob/living/proc/ZImpactDamage(turf/T, levels)
	if(!density) //lets cats and similar avoid death by falling
		visible_message("<span class='notice'>The creature lands unharmed...</span>")
		return
	adjustBruteLoss((levels * 10) ** 1.5)
	AdjustStun(levels * 20)
	AdjustKnockdown(levels * 20)

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
	var/t = get_dir(src, AM)
	var/push_anchored = FALSE
	if((AM.move_resist * MOVE_FORCE_CRUSH_RATIO) <= force)
		if(move_crush(AM, move_force, t))
			push_anchored = TRUE
	if((AM.move_resist * MOVE_FORCE_FORCEPUSH_RATIO) <= force)			//trigger move_crush and/or force_push regardless of if we can push it normally
		if(force_push(AM, move_force, t, push_anchored))
			push_anchored = TRUE
	if((AM.anchored && !push_anchored) || (force < (AM.move_resist * MOVE_FORCE_PUSH_RATIO)))
		now_pushing = FALSE
		return

	var/current_dir
	if(isliving(AM))
		current_dir = AM.dir
	if(AM.Move(get_step(AM.loc, t), t, glide_size))
		Move(get_step(loc, t), t)
	if(current_dir)
		AM.setDir(current_dir)
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

	AM.add_fingerprint(src)

	// If we're pulling something then drop what we're currently pulling and pull this instead.
	if(pulling && AM != pulling)
		stop_pulling()

	changeNext_move(CLICK_CD_GRABBING)

	if(AM != src)
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
		if(TIMER_COOLDOWN_RUNNING(M, "broke_free") && M.stat == CONSCIOUS)
			M.visible_message(span_warning("[M] slips from [src]'s grip."), \
					span_warning("I slip from [src]'s grab."))
			log_combat(src, M, "tried grabbing", addition="passive grab")
			stop_pulling()
			return

		log_combat(src, M, "grabbed", addition="passive grab")
		playsound(src.loc, 'sound/combat/shove.ogg', 50, TRUE, -1)
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
			if((HAS_TRAIT(src, TRAIT_STRONG_GRABBER) && cmode) || item_override)
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
			if((HAS_TRAIT(src, TRAIT_STRONG_GRABBER) && cmode) || item_override)
				suppress_message = TRUE
				M.grippedby(src)
			if(!suppress_message)
				send_pull_message(M)

		update_pull_movespeed()
		set_pull_offsets(M, state)
	else
		if(!suppress_message)
			var/sound_to_play = 'sound/combat/shove.ogg'
			playsound(src.loc, sound_to_play, 50, TRUE, -1)
		var/obj/item/grabbing/O = new(src)
		O.name = "[AM.name]"
		O.grabbed = AM
		O.grabbee = src
		src.put_in_hands(O)
		O.update_hands(src)
		update_grab_intents()

/mob/living/proc/send_pull_message(mob/living/target)
	target.visible_message("<span class='warning'>[src] grabs [target].</span>", \
					"<span class='warning'>[src] grabs me.</span>", "<span class='hear'>I hear shuffling.</span>", null, src)
	to_chat(src, "<span class='info'>I grab [target].</span>")

/mob/living/proc/set_pull_offsets(mob/living/M, grab_state = GRAB_PASSIVE)
	return //rtd fix not updating because no dirchange

/mob/living
	var/list/mob_offsets = list()

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

/mob/living/stop_pulling(forced = TRUE)
	if(pulling)
		if(ismob(pulling))
			var/mob/living/M = pulling
			M.reset_offsets("pulledby")

		if(forced) //if false, called by the grab item itself, no reason to drop it again
			if(istype(get_active_held_item(), /obj/item/grabbing))
				var/obj/item/grabbing/I = get_active_held_item()
				if(I.grabbed == pulling)
					dropItemToGround(I, silent = FALSE)
			if(istype(get_inactive_held_item(), /obj/item/grabbing))
				var/obj/item/grabbing/I = get_inactive_held_item()
				if(I.grabbed == pulling)
					dropItemToGround(I, silent = FALSE)

	. = ..()

	update_pull_movespeed()
	update_pull_hud_icon()

/mob/living/carbon/stop_pulling(forced = TRUE)
	. = ..()
	if(forced)
		if(istype(mouth, /obj/item/grabbing))
			var/obj/item/grabbing/I = mouth
			if(I.grabbed == pulling)
				dropItemToGround(I, silent = FALSE)


/mob/living/verb/stop_pulling1()
	set name = "Stop Pulling"
	set category = "IC"
	set hidden = 1
	stop_pulling()

//same as above
/mob/living/pointed(atom/A as mob|obj|turf in view(client.view, src))
	if(incapacitated(ignore_grab = TRUE))
		return FALSE
	return ..()

/mob/living/_pointed(atom/pointing_at)
	if(!..())
		return FALSE
	log_message("points at [pointing_at]", LOG_EMOTE)
	visible_message("<span class='infoplain'>[span_name("[src]")] points at [pointing_at].</span>", span_notice("You point at [pointing_at]."))


/mob/living/verb/succumb(whispered as null, reaper as null)
	set hidden = TRUE
	if(stat == DEAD)
		return
	if(!reaper)
		return
	if (InCritical() || health <= 0 || (blood_volume < BLOOD_VOLUME_SURVIVE))
		log_message("Has [whispered ? "whispered his final words" : "succumbed to death"] while in [InFullCritical() ? "hard":"soft"] critical with [round(health, 0.1)] points of health!", LOG_ATTACK)

		if(istype(src.loc, /turf/open/water) && !HAS_TRAIT(src, TRAIT_NOBREATH) && body_position == LYING_DOWN && client)
			GLOB.vanderlin_round_stats[STATS_PEOPLE_DROWNED]++

		adjustOxyLoss(201)
		updatehealth()
//		if(!whispered)
//			to_chat(src, "<span class='userdanger'>I have given up life and succumbed to death.</span>")
		death()

/mob/living/incapacitated(ignore_restraints = FALSE, ignore_grab = FALSE, ignore_stasis = FALSE)
	if(HAS_TRAIT(src, TRAIT_INCAPACITATED) || (!ignore_restraints && (HAS_TRAIT(src, TRAIT_RESTRAINED) || (!ignore_grab && pulledby && (pulledby != src) && pulledby.grab_state >= GRAB_AGGRESSIVE))))
		return TRUE

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
	set category = "IC"
	set hidden = 1
	if(IsSleeping())
		to_chat(src, "<span class='warning'>I am already sleeping!</span>")
		return
	else
		if(alert(src, "You sure you want to sleep for a while?", "Sleep", "Yes", "No") == "Yes")
			SetSleeping(400) //Short nap
	// update_mobility()

/mob/proc/get_contents()
	return

/mob/living/proc/lay_down()
	set name = "Lay down"
	set category = "IC"
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
	set category = "IC"
	set hidden = 1
	if(stat)
		return
	if(pulledby)
		to_chat(src, span_warning("I'm grabbed!"))
		return
	if(resting)
		if(!HAS_TRAIT(src, TRAIT_FLOORED))
			visible_message(span_notice("[src] begins standing up."), span_notice("I begin to stand up."))
			set_resting(FALSE, FALSE)
			return TRUE
		else
			visible_message(span_warning("[src] struggles to stand up."), span_danger("I am struggling to stand up."))
			return FALSE

/mob/living/proc/toggle_rest()
	set name = "Rest/Stand"
	set category = "IC"
	set hidden = 1
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
	if(!instant && !do_after(src, 2 SECONDS, src, timed_action_flags = (IGNORE_USER_LOC_CHANGE|IGNORE_TARGET_LOC_CHANGE|IGNORE_HELD_ITEM), extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob/living, rest_checks_callback)), interaction_key = DOAFTER_SOURCE_GETTING_UP))
		if(body_position == LYING_DOWN) // stay lying down
			set_resting(TRUE, silent = TRUE)
		return
	if(!rest_checks_callback())
		if(body_position == LYING_DOWN)
			set_resting(TRUE, silent = TRUE)
		return
	set_lying_angle(0)
	set_body_position(STANDING_UP)

/mob/living/proc/rest_checks_callback()
	if(resting || body_position == STANDING_UP || HAS_TRAIT(src, TRAIT_FLOORED) || pulledby)
		return FALSE
	return TRUE

/mob/living/proc/set_lying_down(new_lying_angle)
	set_body_position(LYING_DOWN)

/// Proc to append behavior related to lying down.
/mob/living/proc/on_lying_down(new_lying_angle)
	if(layer == initial(layer)) //to avoid things like hiding larvas.
		layer = LYING_MOB_LAYER //so mob lying always appear behind standing mobs
	// ADD_TRAIT(src, TRAIT_UI_BLOCKED, LYING_DOWN_TRAIT)
	// ADD_TRAIT(src, TRAIT_PULL_BLOCKED, LYING_DOWN_TRAIT)
	density = FALSE // We lose density and stop bumping passable dense things.
	if(HAS_TRAIT(src, TRAIT_FLOORED) && !(dir & (NORTH|SOUTH)))
		setDir(pick(NORTH, SOUTH)) // We are and look helpless.
	update_wallpress()

/// Proc to append behavior related to lying down.
/mob/living/proc/on_standing_up()
	if(layer == LYING_MOB_LAYER)
		layer = initial(layer)
	density = initial(density) // We were prone before, so we become dense and things can bump into us again.
	// REMOVE_TRAIT(src, TRAIT_UI_BLOCKED, LYING_DOWN_TRAIT)
	// REMOVE_TRAIT(src, TRAIT_PULL_BLOCKED, LYING_DOWN_TRAIT)

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

/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		return
	set_health(maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss())
	if(HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS) && !HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
		// You dont have any blood and your not bloodloss immune? Dead.
		if(blood_volume <= 0)
			set_health(NONE)
	update_stat()
	SEND_SIGNAL(src, COMSIG_LIVING_HEALTH_UPDATE)

//Proc used to resuscitate a mob, for full_heal see fully_heal()
/mob/living/proc/revive(full_heal = FALSE, admin_revive = FALSE)
	SEND_SIGNAL(src, COMSIG_LIVING_REVIVE, full_heal, admin_revive)
	if(full_heal)
		fully_heal(admin_revive = admin_revive)
	if(stat == DEAD && can_be_revived()) //in some cases you can't revive (e.g. no brain)
		GLOB.dead_mob_list -= src
		GLOB.alive_mob_list += src
		set_suicide(FALSE)
		set_stat(UNCONSCIOUS) //the mob starts unconscious,
		updatehealth() //then we check if the mob should wake up.
		update_sight()
		clear_alert("not_enough_oxy")
		reload_fullscreen()
		remove_client_colour(/datum/client_colour/monochrome/death)
		. = TRUE
		if(mind)
			for(var/S in mind.spell_list)
				var/obj/effect/proc_holder/spell/spell = S
				spell.updateButtonIcon()
			mind.remove_antag_datum(/datum/antagonist/zombie)
		if(ishuman(src))
			var/mob/living/carbon/human/human = src
			human.funeral = FALSE
		client?.verbs -= /client/proc/descend

/mob/living/proc/remove_CC()
	SetStun(0, TRUE)
	SetKnockdown(0, TRUE)
	SetImmobilized(0, TRUE)
	SetParalyzed(0, TRUE)
	SetSleeping(0, TRUE)
	SetUnconscious(0, TRUE)

/mob/living/Crossed(atom/movable/AM)
	. = ..()
	for(var/i in get_equipped_items())
		var/obj/item/item = i
		SEND_SIGNAL(item, COMSIG_ITEM_WEARERCROSSED, AM, src)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent == MOVE_INTENT_RUN && body_position == LYING_DOWN && !buckle_lying)
			L.visible_message("<span class='warning'>[L] trips over [src]!</span>","<span class='warning'>I trip over [src]!</span>")
			L.Knockdown(10)
			L.Immobilize(20)



//proc used to completely heal a mob.
//admin_revive = TRUE is used in other procs, for example mob/living/carbon/fully_heal()
/mob/living/proc/fully_heal(admin_revive = FALSE)
	restore_blood()
	setToxLoss(0, 0) //zero as second argument not automatically call updatehealth().
	setOxyLoss(0, 0)
	setCloneLoss(0, 0)
	remove_CC()
	set_disgust(0)
	set_nutrition(NUTRITION_LEVEL_FED + 50)
	bodytemperature = BODYTEMP_NORMAL
	set_blindness(0)
	set_blurriness(0)
	set_dizziness(0)
	cure_nearsighted()
	cure_blind()
	cure_husk()
	heal_overall_damage(INFINITY, INFINITY, null, TRUE) //heal brute and burn dmg on both organic and robotic limbs, and update health right away.
	for(var/datum/wound/wound as anything in get_wounds())
		if(admin_revive)
			qdel(wound)
		else
			wound.heal_wound(wound.whp)
	ExtinguishMob()
	fire_stacks = 0
	divine_fire_stacks = 0
	confused = 0
	dizziness = 0
	drowsyness = 0
	stuttering = 0
	slurring = 0
	jitteriness = 0
	slowdown = 0
	// update_mobility()
	stop_sound_channel(CHANNEL_HEARTBEAT)

//proc called by revive(), to check if we can actually ressuscitate the mob (we don't want to revive him and have him instantly die again)
/mob/living/proc/can_be_revived()
	. = TRUE
	if(health <= HEALTH_THRESHOLD_DEAD)
		return FALSE


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

	if(body_position == LYING_DOWN && !buckled && prob(getBruteLoss()*200/maxHealth))
		makeTrail(newloc, T, old_direction)

/mob/living/setDir(newdir)
	var/olddir = dir
	..()
	if(olddir != dir)
		stop_looking()
		if(client)
			update_vision_cone()

/mob/living/proc/makeTrail(turf/target_turf, turf/start, direction)
	if(!has_gravity())
		return
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
	return !((next_move > world.time) || incapacitated(ignore_restraints = TRUE, ignore_stasis = TRUE))

/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"
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

/mob/living/verb/submit()
	set name = "Yield"
	set category = "IC"
	set hidden = 1
	if(surrendering)
		return
	if(stat)
		return
	surrendering = 1
	if(alert(src, "Yield in surrender?",,"YES","NO") == "YES")
		GLOB.vanderlin_round_stats[STATS_YIELDS]++
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
	if(used_intent)
		used_intent.on_mouse_up()
	if(mmb_intent)
		mmb_intent.on_mouse_up()
	update_warning()

/mob/living/stop_attack(message = FALSE)
	..()
	update_charging_movespeed()

/mob/proc/resist_grab(moving_resist)
	return 1 //returning 0 means we successfully broke free

/mob/living/resist_grab(moving_resist)
	. = TRUE

	var/wrestling_diff = 0
	var/resist_chance = BASE_GRAB_RESIST_CHANCE
	var/mob/living/L = pulledby
	var/combat_modifier = 1

	if(mind)
		wrestling_diff += (get_skill_level(/datum/skill/combat/wrestling)) //NPCs don't use this
	if(L.mind)
		wrestling_diff -= (L.get_skill_level(/datum/skill/combat/wrestling))

	if(HAS_TRAIT(src, TRAIT_RESTRAINED))
		combat_modifier -= 0.25

	if(L.body_position == LYING_DOWN && body_position != LYING_DOWN)
		combat_modifier += 0.1
	if(body_position == LYING_DOWN)
		combat_modifier -= 0.1

	if(pulledby.grab_state >= GRAB_AGGRESSIVE)
		combat_modifier -= 0.1

	var/obj/item/puller_hand = pulledby.get_active_held_item()
	if(isitem(puller_hand))
		if(!istype(puller_hand, /obj/item/grabbing) && puller_hand.wlength > WLENGTH_SHORT)  // so you can't pummel them with a weapon
			combat_modifier += 0.25

	if(cmode && !L.cmode)
		combat_modifier += 0.5
	else if(!cmode && L.cmode)
		combat_modifier -= 0.3

	if(L.buckled)
		combat_modifier += 0.5

	for(var/obj/item/grabbing/G in grabbedby)
		if(G.chokehold)
			combat_modifier -= 0.15

	resist_chance += ((((STASTR - L.STASTR)/2) + wrestling_diff) * 7 + rand(-5, 5))
	resist_chance *= combat_modifier
	resist_chance = clamp(resist_chance, 7, 95)

	// if(moving_resist && client) //we resisted by trying to move
	client?.move_delay = world.time + 20
	changeNext_move(CLICK_CD_RESIST)
	adjust_stamina(rand(4,9))
	pulledby.adjust_stamina(rand(2,5))
	if(prob(resist_chance))
		visible_message("<span class='warning'>[src] breaks free of [pulledby]'s grip!</span>", \
						"<span class='notice'>I break free of [pulledby]'s grip!</span>", null, null, pulledby)
		to_chat(pulledby, "<span class='danger'>[src] breaks free of my grip!</span>")
		log_combat(pulledby, src, "broke grab")
		pulledby.stop_pulling()

		var/wrestling_cooldown_reduction = 0
		if(pulledby?.get_skill_level(/datum/skill/combat/wrestling))
			wrestling_cooldown_reduction = 0.2 SECONDS * pulledby.get_skill_level(/datum/skill/combat/wrestling)
		TIMER_COOLDOWN_START(src, "broke_free", max(0, 2.5 SECONDS - wrestling_cooldown_reduction))
		playsound(src.loc, 'sound/combat/grabbreak.ogg', 50, TRUE, -1)
		return FALSE
	else
		var/shitte = ""
		if(client?.prefs.showrolls)
			shitte = " ([resist_chance]%)"
		visible_message("<span class='warning'>[src] struggles to break free from [pulledby]'s grip!</span>", \
						"<span class='warning'>I struggle against [pulledby]'s grip![shitte]</span>", null, null, pulledby)
		to_chat(pulledby, "<span class='warning'>[src] struggles against my grip!</span>")
		playsound(src.loc, 'sound/combat/grabstruggle.ogg', 50, TRUE, -1)
		return TRUE

/mob/living/carbon/human/resist_grab(moving_resist)
	var/mob/living/L = pulledby
	if(hostagetaker)
		attackhostage()
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
							playsound(src.loc, 'sound/combat/grabstruggle.ogg', 50, TRUE, -1)
							client?.move_delay = world.time + 20
							return TRUE
						if(HAS_TRAIT(H, TRAIT_EARGRAB) && G.sublimb_grabbed == BODY_ZONE_PRECISE_EARS)
							visible_message("<span class='warning'>[src] struggles to break free from [pulledby]'s grip!</span>", \
												"<span class='warning'>I struggle against [pulledby]'s grip!</span>", null, null, pulledby)
							to_chat(pulledby, "<span class='warning'>[src] struggles against my grip!</span>")
							playsound(src.loc, 'sound/combat/grabstruggle.ogg', 50, TRUE, -1)
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

/mob/living/update_gravity(has_gravity, override)
	. = ..()
	if(!SSticker.HasRoundStarted())
		return
	if(has_gravity)
		if(has_gravity == 1)
			clear_alert("gravity")
		else
			if(has_gravity >= GRAVITY_DAMAGE_TRESHOLD)
				throw_alert("gravity", /atom/movable/screen/alert/veryhighgravity)
			else
				throw_alert("gravity", /atom/movable/screen/alert/highgravity)
	else
		throw_alert("gravity", /atom/movable/screen/alert/weightless)
	if(!override && !is_flying())
		float(!has_gravity)

/mob/living/float(on)
	if(throwing)
		return
	var/fixed = 0
	if(anchored || (buckled && buckled.anchored))
		fixed = 1
	if(on && !(movement_type & FLOATING) && !fixed)
		animate(src, pixel_y = pixel_y + 2, time = 10, loop = -1)
		sleep(10)
		animate(src, pixel_y = pixel_y - 2, time = 10, loop = -1)
		setMovetype(movement_type | FLOATING)
	else if(((!on || fixed) && (movement_type & FLOATING)))
		animate(src, pixel_y = get_standard_pixel_y_offset(lying_angle), time = 10)
		setMovetype(movement_type & ~FLOATING)

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

	who.visible_message("<span class='warning'>[src] tries to remove [who]'s [what.name].</span>", \
					"<span class='danger'>[src] tries to remove my [what.name].</span>", null, null, src)
	to_chat(src, "<span class='danger'>I try to remove [who]'s [what.name]...</span>")
	what.add_fingerprint(src)
	if(do_after(src, what.strip_delay * surrender_mod, who))
		if(what && Adjacent(who))
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

/mob/living/proc/do_jitter_animation(jitteriness)
	var/amplitude = min(4, (jitteriness/100) + 1)
	var/pixel_x_diff = rand(-amplitude, amplitude)
	var/pixel_y_diff = rand(-amplitude/3, amplitude/3)
	var/final_pixel_x = get_standard_pixel_x_offset(lying_angle)
	var/final_pixel_y = get_standard_pixel_y_offset(lying_angle)
	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff , time = 2, loop = 6)
	animate(pixel_x = final_pixel_x , pixel_y = final_pixel_y , time = 2)
	setMovetype(movement_type & ~FLOATING) // If we were without gravity, the bouncing animation got stopped, so we make sure to restart it in next life().

/mob/living/proc/get_standard_pixel_x_offset(lying = 0)
	var/_x = initial(pixel_x)
	for(var/o in mob_offsets)
		if(mob_offsets[o])
			if(mob_offsets[o]["x"])
				_x = _x + mob_offsets[o]["x"]
	return _x

/mob/living/proc/get_standard_pixel_y_offset(lying = 0)
	var/_y = initial(pixel_y)
	for(var/o in mob_offsets)
		if(mob_offsets[o])
			if(mob_offsets[o]["y"])
				_y = _y + mob_offsets[o]["y"]
	return _y

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

/mob/living/canUseTopic(atom/movable/M, be_close=FALSE, no_dexterity=FALSE, no_tk=FALSE)
	if(incapacitated(ignore_grab = TRUE))
		to_chat(src, "<span class='warning'>I can't do that right now!</span>")
		return FALSE
	if(be_close && !in_range(M, src))
		to_chat(src, "<span class='warning'>I am too far away!</span>")
		return FALSE
	if(!no_dexterity)
		to_chat(src, "<span class='warning'>I don't have the dexterity to do this!</span>")
		return FALSE
	return TRUE

/mob/living/proc/can_use_guns(obj/item/G)//actually used for more than guns!
	if(G.trigger_guard == TRIGGER_GUARD_NONE)
		to_chat(src, "<span class='warning'>I are unable to fire this!</span>")
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

/mob/living/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force)
	stop_pulling()
	. = ..()

// Called when we are hit by a bolt of polymorph and changed
// Generally the mob we are currently in is about to be deleted
/mob/living/proc/wabbajack_act(mob/living/new_mob)
	new_mob.name = real_name
	new_mob.real_name = real_name

	if(mind)
		mind.transfer_to(new_mob)
	else
		new_mob.key = key

/mob/living/anti_magic_check(magic = TRUE, holy = FALSE, tinfoil = FALSE, chargecost = 1, self = FALSE)
	. = ..()
	if(.)
		return
	if((magic && HAS_TRAIT(src, TRAIT_ANTIMAGIC)) || (holy && HAS_TRAIT(src, TRAIT_HOLY)))
		return src

/mob/living/proc/fakefireextinguish()
	return

/mob/living/proc/fakefire()
	return

//Mobs on Fire
/mob/living/proc/IgniteMob()
	if (HAS_TRAIT(src, TRAIT_NOFIRE))
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

/mob/living/proc/SoakMob(locations)
	if(locations & CHEST)
		ExtinguishMob()

/mob/living/proc/ExtinguishMob()
	if(on_fire)
		on_fire = FALSE
		fire_stacks = 0
		divine_fire_stacks = 0
		for(var/obj/effect/dummy/lighting_obj/moblight/fire/F in src)
			qdel(F)
		clear_alert("fire")
		SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "on_fire")
		SEND_SIGNAL(src, COMSIG_LIVING_EXTINGUISHED, src)
		update_fire()

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

/mob/living/proc/AddAbility(obj/effect/proc_holder/A)
	abilities.Add(A)
	A.on_gain(src)
	if(A.has_action)
		A.action.Grant(src)

/mob/living/proc/RemoveAbility(obj/effect/proc_holder/A)
	abilities.Remove(A)
	A.on_lose(src)
	if(A.action)
		A.action.Remove(src)

/mob/living/proc/add_abilities_to_panel()
	for(var/obj/effect/proc_holder/A in abilities)
		statpanel("[A.panel]",A.get_panel_text(),A)

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

				for (var/I in length(SSidlenpcpool.idle_mobs_by_zlevel[new_z]) to 1 step -1) //Backwards loop because we're removing (guarantees optimal rather than worst-case performance), it's fine to use .len here but doesn't compile on 511
					var/mob/living/simple_animal/SA = SSidlenpcpool.idle_mobs_by_zlevel[new_z][I]
					if (SA)
						SA.toggle_ai(AI_ON) // Guarantees responsiveness for when appearing right next to mobs
					else
						SSidlenpcpool.idle_mobs_by_zlevel[new_z] -= SA

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
			var/obj/item/clothing/head/mob_holder/holder = new(get_turf(src), src)
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
		var/obj/item/clothing/head/mob_holder/holder = new(get_turf(src), src)
		visible_message(span_warning("[src] starts to climb into [picked] on [over]."), span_warning("You start to climb into [picked] on [over]."))
		if(do_after(src, 3 SECONDS, over))
			if(picked.loc == src)
				return
			if(!SEND_SIGNAL(picked, COMSIG_TRY_STORAGE_INSERT, holder, null, TRUE, TRUE))
				qdel(holder)

	if(!istype(over) || !istype(user))
		return
	if(!over.Adjacent(src) || (user != src) || !canUseTopic(over))
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
	var/obj/item/clothing/head/mob_holder/holder = new(get_turf(src), src)
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

/mob/living/update_mouse_pointer()
	..()
	if (client && ranged_ability && ranged_ability.ranged_mousepointer)
		client.mouse_pointer_icon = ranged_ability.ranged_mousepointer

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
			set_blindness(var_value)
		if("eye_damage")
			var/obj/item/organ/eyes/E = getorganslot(ORGAN_SLOT_EYES)
			if(E)
				E.setOrganDamage(var_value)
		if("eye_blurry")
			set_blurriness(var_value)
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

	if(new_value > .) // Gained leg usage.
		REMOVE_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
		REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
	else if(!(movement_type & (FLYING | FLOATING))) //Lost leg usage, not flying.
		if(!usable_legs)
			ADD_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
			if(!usable_hands)
				ADD_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)

	if(usable_legs < default_num_legs)
		var/limbless_slowdown = (default_num_legs - usable_legs) * 3
		if(!usable_legs && usable_hands < default_num_hands)
			limbless_slowdown += (default_num_hands - usable_hands) * 3
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

	if(new_value > .) // Gained hand usage.
		REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
	else if(!(movement_type & (FLYING | FLOATING)) && !usable_hands && !usable_legs) //Lost a hand, not flying, no hands left, no legs.
		ADD_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)

/// Changes the value of the [living/body_position] variable.
/mob/living/proc/set_body_position(new_value)
	if(body_position == new_value)
		return
	. = body_position
	body_position = new_value
	if(new_value == LYING_DOWN) // From standing to lying down.
		on_lying_down()
	else // From lying down to standing up.
		on_standing_up()

	update_cone_show()

/// Proc to append behavior to the condition of being floored. Called when the condition starts.
/mob/living/proc/on_floored_start()
	if(body_position == STANDING_UP) //force them on the ground
		set_lying_angle(pick(90, 270))
		set_body_position(LYING_DOWN)
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
	return !((next_move > world.time) || incapacitated(ignore_restraints = TRUE, ignore_grab = TRUE))

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
		visible_message("<span class='info'>[src] looks around.</span>")
	var/looktime = 5 SECONDS - (STAPER * 2)
	if(do_after(src, looktime))
		// var/huhsneak
		SEND_GLOBAL_SIGNAL(COMSIG_MOB_ACTIVE_PERCEPTION,src)
		for(var/mob/living/M in oview(7,src))
			if(see_invisible < M.invisibility)
				continue
			if(HAS_TRAIT(M, TRAIT_IMPERCEPTIBLE)) // Check if the mob is affected by the invisibility spell
				continue
			var/probby = 3 * STAPER
			if(M.mind)
				probby -= (M.get_skill_level(/datum/skill/misc/sneaking) * 10)
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
	var/image/I = image(icon = 'icons/effects/effects.dmi', loc = A, icon_state = state, layer = 19)
	I.layer = 19
	I.plane = 19
	if(!I)
		return
	I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	flick_overlay(I, list(C), 30)

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
				ADD_TRAIT(src, TRAIT_INCAPACITATED, TRAIT_KNOCKEDOUT)
				ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_KNOCKEDOUT)
				ADD_TRAIT(src, TRAIT_HANDS_BLOCKED, TRAIT_KNOCKEDOUT)
			ADD_TRAIT(src, TRAIT_FLOORED, UNCONSCIOUS_TRAIT)
		if(SOFT_CRIT)
			if(stat >= UNCONSCIOUS)
				ADD_TRAIT(src, TRAIT_INCAPACITATED, TRAIT_KNOCKEDOUT)
				ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_KNOCKEDOUT) //adding trait sources should come before removing to avoid unnecessary updates
				ADD_TRAIT(src, TRAIT_HANDS_BLOCKED, TRAIT_KNOCKEDOUT)
			if(pulledby)
				REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, PULLED_WHILE_SOFTCRIT_TRAIT)
		if(UNCONSCIOUS)
			cure_blind(UNCONSCIOUS_TRAIT)
	switch(stat) //Current stat.
		if(CONSCIOUS)
			if(. >= UNCONSCIOUS)
				REMOVE_TRAIT(src, TRAIT_INCAPACITATED, TRAIT_KNOCKEDOUT)
				REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_KNOCKEDOUT)
				REMOVE_TRAIT(src, TRAIT_HANDS_BLOCKED, TRAIT_KNOCKEDOUT)
			REMOVE_TRAIT(src, TRAIT_FLOORED, UNCONSCIOUS_TRAIT)
			log_combat(src, src, "regained consciousness")
		if(SOFT_CRIT)
			if(pulledby)
				ADD_TRAIT(src, TRAIT_IMMOBILIZED, PULLED_WHILE_SOFTCRIT_TRAIT) //adding trait sources should come before removing to avoid unnecessary updates
			if(. >= UNCONSCIOUS)
				REMOVE_TRAIT(src, TRAIT_INCAPACITATED, TRAIT_KNOCKEDOUT)
				REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_KNOCKEDOUT)
				REMOVE_TRAIT(src, TRAIT_HANDS_BLOCKED, TRAIT_KNOCKEDOUT)
			log_combat(src, src, "entered soft crit")
		if(UNCONSCIOUS)
			become_blind(UNCONSCIOUS_TRAIT)
			log_combat(src, src, "lost consciousness")
		if(DEAD)
			log_combat(src, src, "died")

/mob/living/set_pulledby(new_pulledby)
	. = ..()
	if(hud_used)
		for(var/hand in hud_used.hand_slots)
			var/atom/movable/screen/inventory/hand/H = hud_used.hand_slots[hand]
			H?.update_icon()
	if(. == FALSE) //null is a valid value here, we only want to return if FALSE is explicitly passed.
		return
	if(pulledby)
		if(!. && stat == SOFT_CRIT)
			ADD_TRAIT(src, TRAIT_IMMOBILIZED, PULLED_WHILE_SOFTCRIT_TRAIT)
	else if(. && stat == SOFT_CRIT)
		REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, PULLED_WHILE_SOFTCRIT_TRAIT)

/// Proc for giving a mob a new 'friend', generally used for AI control and targeting. Returns false if already friends.
/mob/living/proc/befriend(mob/living/new_friend)
	SHOULD_CALL_PARENT(TRUE)
	var/friend_ref = REF(new_friend)
	if (faction.Find(friend_ref))
		return FALSE
	faction |= friend_ref
	ai_controller?.insert_blackboard_key_lazylist(BB_FRIENDS_LIST, new_friend)

	SEND_SIGNAL(src, COMSIG_LIVING_BEFRIENDED, new_friend)

	if(src in SSmobs.matthios_mobs)
		SSmobs.matthios_mobs -= src

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
	return max(45, STAEND * 12)

///this is returned as decimal value between 0 and 1
/mob/living/proc/get_encumbrance()
	return 0

/mob/living/proc/get_total_weight()
	return 0

/mob/living/proc/encumbrance_to_dodge()
	return 1

/mob/living/proc/encumbrance_to_speed()

/mob/proc/food_tempted(/obj/item/W, mob/user)
	return

/mob/proc/taunted(mob/user)
	for(var/mob/living/simple_animal/hostile/retaliate/A in view(7,src))
		if(A.owner == user)
			A.emote("aggro")
			A.Retaliate()
			A.GiveTarget(src)
	return

/mob/proc/shood(mob/user)
	return

/mob/proc/beckoned(mob/user)
	return

/mob/proc/get_punch_dmg()
	return
