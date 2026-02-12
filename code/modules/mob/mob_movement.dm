/**
 * If your mob is concious, drop the item in the active hand
 *
 * This is a hidden verb, likely for binding with winset for hotkeys
 */
/client/verb/drop_item()
	set hidden = 1
	return

/**
 * force move the control_object of your client mob
 *
 * Used in admin possession and called from the client Move proc
 * ensures the possessed object moves and not the admin mob
 *
 * Has no sanity other than checking density
 */
/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)
				return
			mob.control_object.setDir(direct)
		else
			mob.control_object.forceMove(get_step(mob.control_object,direct))

/**
 * Move a client in a direction
 *
 * Huge proc, has a lot of functionality
 *
 * Mostly it will despatch to the mob that you are the owner of to actually move
 * in the physical realm
 *
 * Things that stop you moving as a mob:
 * * world time being less than your next move_delay
 * * not being in a mob, or that mob not having a loc
 * * missing the n and direction parameters
 * * being in remote control of an object (calls Moveobject instead)
 * * being dead (it ghosts you instead)
 *
 * Things that stop you moving as a mob living (why even have OO if you're just shoving it all
 * in the parent proc with istype checks right?):
 * * having incorporeal_move set (calls Process_Incorpmove() instead)
 * * being grabbed
 * * being buckled  (relaymove() is called to the buckled atom instead)
 * * having your loc be some other mob (relaymove() is called on that mob instead)
 * * Not having MOBILITY_MOVE
 * * Failing Process_Spacemove() call
 *
 * At this point, if the mob is is confused, then a random direction and target turf will be calculated for you to travel to instead
 *
 * Now the parent call is made (to the byond builtin move), which moves you
 *
 * Some final move delay calculations (doubling if you moved diagonally successfully)
 *
 * if mob throwing is set I believe it's unset at this point via a call to finalize
 *
 * Finally if you're pulling an object and it's dense, you are turned 180 after the move
 * (if you ask me, this should be at the top of the move so you don't dance around)
 *
 */
/atom/movable
	var/facepull = TRUE

/mob
	facepull = FALSE

/client/Move(n, direct)
	if(world.time < move_delay) //do not move anything ahead of this check please
		return FALSE
	next_move_dir_add = 0
	next_move_dir_sub = 0
	var/old_move_delay = move_delay
	move_delay = world.time + world.tick_lag //this is here because Move() can now be called mutiple times per tick
	if(!mob || !mob.loc)
		return FALSE
	if(!n || !direct)
		return FALSE
	if(HAS_TRAIT(mob, TRAIT_NO_TRANSFORM))
		return FALSE	//This is sota the goto stop mobs from moving var
	if(mob.control_object)
		return Move_object(direct)
	if(!isliving(mob))
		return mob.Move(n, direct)
	else
		if (HAS_TRAIT(mob, TRAIT_IN_FRENZY) || HAS_TRAIT(mob, TRAIT_MOVEMENT_BLOCKED))
			return FALSE

	if(mob.stat == DEAD)
#ifdef TESTSERVER
		mob.ghostize()
		return FALSE
#endif
		if(MOBTIMER_FINISHED(mob, MT_LASTDIED, 60 SECONDS))
			mob.ghostize()
		else
			if(!world.time%5)
				to_chat(src, "<span class='warning'>My spirit hasn't manifested yet.</span>")
		return FALSE

	if(mob.force_moving)
		return FALSE

	var/mob/living/L = mob  //Already checked for isliving earlier
	if(L.incorporeal_move)	//Move though walls
		Process_Incorpmove(direct)
		return FALSE

	if(mob.remote_control)					//we're controlling something, our movement is relayed to it
		return mob.remote_control.relaymove(mob, direct)

	if(Process_Grab()) //are we restrained by someone's grip?
		return

	if(mob.buckled)							//if we're buckled to something, tell it we moved.
		return mob.buckled.relaymove(mob, direct)

	if(HAS_TRAIT(L, TRAIT_IMMOBILIZED))
		return FALSE

	if(isobj(mob.loc) || ismob(mob.loc))	//Inside an object, tell it we moved
		var/atom/O = mob.loc
		return O.relaymove(mob, direct)

	if(SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_PRE_MOVE, args) & COMSIG_MOB_CLIENT_BLOCK_PRE_MOVE)
		return FALSE

	//We are now going to move
	var/add_delay = mob.cached_multiplicative_slowdown
	//If the move was recent, count using old_move_delay
	//We want fractional behavior and all
	if(old_move_delay + world.tick_lag > world.time)
		//Yes this makes smooth movement stutter if add_delay is too fractional
		move_delay = old_move_delay
	else
		move_delay = world.time

	var/target_dir = get_dir(L, n)

	//backpedal and strafe slowdown for quick intent
	if(L.fixedeye || L.tempfixeye)
		if(L.dir != target_dir)
			add_delay += 2
			if(L.m_intent == MOVE_INTENT_RUN)
				L.toggle_rogmove_intent(MOVE_INTENT_WALK)
	else
		if(L.dir != target_dir)
			// Remove sprint intent if we change direction, but only if we sprinted at least 1 tile
			if(L.m_intent == MOVE_INTENT_RUN && L.sprinted_tiles > 0)
				L.toggle_rogmove_intent(MOVE_INTENT_WALK)

	var/old_direct = mob.dir

	. = ..()

	if((direct & (direct - 1)) && mob.loc == n) //moved diagonally successfully
		add_delay *= sqrt(2)

	var/after_glide = 0
	if(visual_delay)
		after_glide = visual_delay
	else
		after_glide = DELAY_TO_GLIDE_SIZE(add_delay)

	mob.set_glide_size(after_glide)

	move_delay += add_delay
	if(.) // If mob is null here, we deserve the runtime
		if(mob.throwing)
			mob.throwing.finalize(FALSE)

		// At this point we've moved the client's attached mob. This is one of the only ways to guess that a move was done
		// as a result of player input and not because they were pulled or any other magic.
		SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_MOVED, direct, old_direct)

	var/atom/movable/P = mob.pulling
	if(P)
		if(isliving(P))
			var/mob/living/M = P
			if(M.body_position == LYING_DOWN)
				if(!M.buckled) //carrying/piggyback
					mob.setDir(turn(mob.dir, 180))
		else
			if(P.facepull)
				mob.setDir(turn(mob.dir, 180))
	if(mob.used_intent?.movement_interrupt && mob.atkswinging == "left" && charging)
		if(mob.cast_move < mob.used_intent?.move_limit)
			to_chat(src, "<span class='warning'>I am starting to lose focus!</span>")
			mob.cast_move++
		else
			to_chat(src, "<span class='warning'>I lost my concentration!</span>")
			mob.stop_attack(FALSE)
			mob.changeNext_move(CLICK_CD_MELEE)
			mob.cast_move = 0
	if(mob.mmb_intent?.movement_interrupt && mob.atkswinging == "middle" && charging)
		if(mob.cast_move < mob.used_intent?.move_limit)
			to_chat(src, "<span class='warning'>I am starting to lose focus!</span>")
			mob.cast_move++
		else
			to_chat(src, "<span class='warning'>I lost my concentration!</span>")
			mob.stop_attack(FALSE)
			mob.changeNext_move(CLICK_CD_MELEE)
			mob.cast_move = 0

/**
 * Checks to see if you're being grabbed and if so attempts to break it
 *
 * Called by client/Move()
 */
/client/proc/Process_Grab()
	if(mob.pulledby && mob.pulledby != mob)
		if(HAS_TRAIT(mob, TRAIT_INCAPACITATED))
			COOLDOWN_START(src, move_delay, 1 SECONDS)
			to_chat(src, span_warning("I can't move!"))
			return TRUE
		else if(HAS_TRAIT(mob, TRAIT_RESTRAINED))
			COOLDOWN_START(src, move_delay, 1 SECONDS)
			to_chat(src, span_warning("I'm restrained! I can't move!"))
			return TRUE
		else if(mob.pulledby != mob.pulling || mob.pulledby.grab_state > GRAB_PASSIVE || mob.cmode || mob.pulledby.cmode)	//Don't autoresist passive grabs if we're grabbing them too.
			return mob.resist_grab(TRUE)

	if(mob.pulling && isliving(mob.pulling))
		var/mob/living/L = mob.pulling
		var/mob/living/M = mob
		// If passive grab and trying to pull someone who doesn't want to be pulled
		if(M.grab_state == GRAB_PASSIVE && !isanimal(L) && L.cmode && L.body_position != LYING_DOWN && !HAS_TRAIT(L, TRAIT_INCAPACITATED))
			// Reuse shove check probability
			if(!prob(clamp(30 + (M.stat_compare(L, STATKEY_STR, STATKEY_CON)*10),0,100)))
				COOLDOWN_START(src, move_delay, 1 SECONDS)
				to_chat(src, span_warning("[L]'s footing is too sturdy!"))
				return TRUE

	var/mob/living/simple_animal/bound = mob.pulling
	if(istype(bound))
		if(bound?.binded)
			COOLDOWN_START(src, move_delay, 1 SECONDS)
			to_chat(src, span_warning("[bound] is bound in a summoning circle. I can't move them!"))
			return TRUE

	return FALSE

/**
 * Allows mobs to ignore density and phase through objects
 *
 * Called by client/Move()
 *
 * The behaviour depends on the incorporeal_move value of the mob
 *
 * * INCORPOREAL_MOVE_BASIC - forceMoved to the next tile with no stop
 * * INCORPOREAL_MOVE_SHADOW  - the same but leaves a cool effect path
 * * INCORPOREAL_MOVE_JAUNT - the same but blocked by holy tiles
 *
 * You'll note this is another mob living level proc living at the client level
 */
/client/proc/Process_Incorpmove(direct)
	var/turf/mobloc = get_turf(mob)
	if(!isliving(mob))
		return
	var/mob/living/L = mob
	switch(L.incorporeal_move)
		if(INCORPOREAL_MOVE_BASIC)
			var/T = get_step(L,direct)
			if(T)
				L.forceMove(T)
			L.setDir(direct)
		if(INCORPOREAL_MOVE_SHADOW)
			if(prob(50))
				var/locx
				var/locy
				switch(direct)
					if(NORTH)
						locx = mobloc.x
						locy = (mobloc.y+2)
						if(locy>world.maxy)
							return
					if(SOUTH)
						locx = mobloc.x
						locy = (mobloc.y-2)
						if(locy<1)
							return
					if(EAST)
						locy = mobloc.y
						locx = (mobloc.x+2)
						if(locx>world.maxx)
							return
					if(WEST)
						locy = mobloc.y
						locx = (mobloc.x-2)
						if(locx<1)
							return
					else
						return
				var/target = locate(locx,locy,mobloc.z)
				if(target)
					L.loc = target
					var/limit = 2//For only two trailing shadows.
					for(var/turf/T in getline(mobloc, L.loc))
						new /obj/effect/temp_visual/dir_setting/ninja/shadow(T, L.dir)
						limit--
						if(limit<=0)
							break
			else
				new /obj/effect/temp_visual/dir_setting/ninja/shadow(mobloc, L.dir)
				var/T = get_step(L,direct)
				if(T)
					L.forceMove(T)
			L.setDir(direct)
		if(INCORPOREAL_MOVE_JAUNT) //Incorporeal move, but blocked by holy-watered tiles and salt piles.
			var/turf/open/floor/stepTurf = get_step(L, direct)
			if(stepTurf)
				for(var/obj/effect/decal/cleanable/food/salt/S in stepTurf)
					to_chat(L, "<span class='warning'>[S] bars your passage!</span>")
					return
				if(stepTurf.turf_flags & NO_JAUNT)
					to_chat(L, "<span class='warning'>Some strange aura is blocking the way.</span>")
					return
				if (locate(/obj/effect/blessing, stepTurf))
					to_chat(L, "<span class='warning'>Holy energies block your path!</span>")
					return

				L.forceMove(stepTurf)
			L.setDir(direct)
	return TRUE


/// Called when this mob slips over, override as needed
/mob/proc/slip(knockdown_amount, obj/O, lube, paralyze, force_drop)
	return

//bodypart selection verbs - Cyberboss
//8:repeated presses toggles through head - eyes - mouth
//4: r-arm 5: chest 6: l-arm
//1: r-leg 2: groin 3: l-leg

///Validate the client's mob has a valid zone selected
/client/proc/check_has_body_select()
	return mob && mob.hud_used && mob.hud_used.zone_select && istype(mob.hud_used.zone_select, /atom/movable/screen/zone_sel)

/**
 * Hidden verb to set the target zone of a mob to the head
 *
 * (bound to 8) - repeated presses toggles through head - eyes - nose - mouth
 */
/client/verb/body_toggle_head()
	set name = "body-toggle-head"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_HEAD)
			next_in_line = BODY_ZONE_PRECISE_R_EYE
		if(BODY_ZONE_PRECISE_R_EYE)
			next_in_line = BODY_ZONE_PRECISE_NOSE
		if(BODY_ZONE_PRECISE_NOSE)
			next_in_line = BODY_ZONE_PRECISE_MOUTH
		else
			next_in_line = BODY_ZONE_HEAD

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Hidden verb to target the neck, bound to 7
/client/verb/body_neck()
	set name = "body-neck"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_PRECISE_NECK)
			next_in_line = BODY_ZONE_PRECISE_MOUTH
		else
			next_in_line = BODY_ZONE_PRECISE_NECK

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Hidden verb to target the eyes, bound to 9
/client/verb/body_eyes()
	set name = "body_eyes"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_PRECISE_R_EYE)
			next_in_line = BODY_ZONE_PRECISE_L_EYE
		else
			next_in_line = BODY_ZONE_PRECISE_R_EYE

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Hidden verb to target the right arm, bound to 4
/client/verb/body_r_arm()
	set name = "body-r-arm"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_R_ARM)
			next_in_line = BODY_ZONE_PRECISE_R_HAND
		else
			next_in_line = BODY_ZONE_R_ARM

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Hidden verb to target the chest, bound to 5
/client/verb/body_chest()
	set name = "body-chest"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_CHEST)
			next_in_line = BODY_ZONE_PRECISE_STOMACH
		else
			next_in_line = BODY_ZONE_CHEST

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Hidden verb to target the left arm, bound to 6
/client/verb/body_l_arm()
	set name = "body-l-arm"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_L_ARM)
			next_in_line = BODY_ZONE_PRECISE_L_HAND
		else
			next_in_line = BODY_ZONE_L_ARM

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Hidden verb to target the right leg, bound to 1
/client/verb/body_r_leg()
	set name = "body-r-leg"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_R_LEG)
			next_in_line = BODY_ZONE_PRECISE_R_FOOT
		else
			next_in_line = BODY_ZONE_R_LEG

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Hidden verb to target the groin, bound to 2
/client/verb/body_groin()
	set name = "body-groin"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(BODY_ZONE_PRECISE_GROIN, mob)

///Hidden verb to target the left leg, bound to 3
/client/verb/body_l_leg()
	set name = "body-l-leg"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_L_LEG)
			next_in_line = BODY_ZONE_PRECISE_L_FOOT
		else
			next_in_line = BODY_ZONE_L_LEG

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Verb to toggle the walk or run status
/client/verb/toggle_walk_run()
	set name = "toggle-walk-run"
	set hidden = TRUE
	set instant = TRUE
	if(mob)
		mob.toggle_move_intent(usr)

/**
 * Toggle the move intent of the mob
 *
 * triggers an update the move intent hud as well
 */
/mob/proc/toggle_move_intent(mob/user)
	if(m_intent == MOVE_INTENT_RUN)
		m_intent = MOVE_INTENT_WALK
	else
		m_intent = MOVE_INTENT_RUN

/mob/proc/update_sneak_invis(reset = FALSE)
	return

/mob/proc/toggle_rogmove_intent(intent, silent = FALSE)
	// If we're becoming sprinting from non-sprinting, reset the counter
	if(!(m_intent == MOVE_INTENT_RUN && intent == MOVE_INTENT_RUN))
		sprinted_tiles = 0
	switch(intent)
		if(MOVE_INTENT_SNEAK)
			m_intent = MOVE_INTENT_SNEAK
			update_sneak_invis()
		if(MOVE_INTENT_WALK)
			m_intent = MOVE_INTENT_WALK
		if(MOVE_INTENT_RUN)
			if(isliving(src))
				var/mob/living/L = src
				if(L.stamina >= L.maximum_stamina)
					return
				if(L.energy <= 0)
					return
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(H.get_encumbrance() >= 0.5)
						to_chat(H, span_info("You are too heavy to run!"))
						return
			m_intent = MOVE_INTENT_RUN
	if(hud_used && hud_used.static_inventory)
		for(var/atom/movable/screen/rogmove/selector in hud_used.static_inventory)
			selector.update_appearance(UPDATE_ICON_STATE)
	if(!silent)
		playsound_local(src, 'sound/misc/click.ogg', 100)

/mob/proc/toggle_eye_intent(mob/user) //clicking the fixeye button either makes you fixeye or clears your target
	if(fixedeye)
		fixedeye = 0
		if(!tempfixeye)
			atom_flags &= ~NO_DIR_CHANGE_ON_MOVE
	else
		fixedeye = 1
		atom_flags |= NO_DIR_CHANGE_ON_MOVE

	for(var/atom/movable/screen/eye_intent/eyet in hud_used.static_inventory)
		eyet.update_appearance(UPDATE_ICON)
	playsound_local(src, 'sound/misc/click.ogg', 100)

/client/proc/ghostears()
	set category = "Admin.Ghost"
	set name = "Hear Speech"
	if(!holder)
		return
	if(!prefs)
		return
	prefs.chat_toggles ^= CHAT_GHOSTEARS
	prefs.save_preferences()
	if(prefs.chat_toggles & CHAT_GHOSTEARS)
		to_chat(src, span_info("I will hear all now."))
	else
		to_chat(src, span_info("I will hear like a mortal."))

/client/proc/ghostwhispers()
	set category = "Admin.Ghost"
	set name = "Hear Whispers"
	if(!holder)
		return
	if(!prefs)
		return
	prefs.chat_toggles ^= CHAT_GHOSTWHISPER
	prefs.save_preferences()
	if(prefs.chat_toggles & CHAT_GHOSTWHISPER)
		to_chat(src, span_info("I will hear all whispers now."))
	else
		to_chat(src, span_info("I will hear like a mortal."))

/client/proc/ghosteyes()
	set category = "Admin.Ghost"
	set name = "See Emotes"
	if(!holder)
		return
	if(!prefs)
		return
	prefs.chat_toggles ^= CHAT_GHOSTSIGHT
	prefs.save_preferences()
	if(prefs.chat_toggles & CHAT_GHOSTSIGHT)
		to_chat(src, span_info("I will see all whispers now."))
	else
		to_chat(src, span_info("I will see like a mortal."))


/client/proc/ghost_up()
	set category = "Admin.Ghost"
	set name = "GhostUp"
	if(!holder)
		return
	. = TRUE
	if(isobserver(mob))
		mob.ghost_up()

/client/proc/ghost_down()
	set category = "Admin.Ghost"
	set name = "GhostDown"
	if(!holder)
		return
	. = TRUE
	if(isobserver(mob))
		mob.ghost_down()

///Moves a mob upwards in z level
/mob/proc/ghost_up()
	if(zMove(UP, TRUE))
		to_chat(src, "<span class='notice'>I move upwards.</span>")

///Moves a mob down a z level
/mob/proc/ghost_down()
	if(zMove(DOWN, TRUE))
		to_chat(src, "<span class='notice'>I move down.</span>")

///Move a mob between z levels, if it's valid to move z's on this turf
/mob/proc/zMove(dir, feedback = FALSE)
	if(dir != UP && dir != DOWN)
		return FALSE
	var/turf/target = get_step_multiz(src, dir)
	if(!target)
		if(feedback)
			to_chat(src, "<span class='warning'>There's nothing in that direction!</span>")
		return FALSE
	if(!canZMove(dir, target))
		if(feedback)
			to_chat(src, "<span class='warning'>I couldn't move there!</span>")
		return FALSE
	forceMove(target)
	return TRUE

/// Can this mob move between z levels
/mob/proc/canZMove(direction, turf/target)
	return FALSE
