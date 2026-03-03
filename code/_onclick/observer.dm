/mob/dead/observer/DblClickOn(atom/clicked_atom, params)
	if(check_click_intercept(params2list(params), clicked_atom))
		return

	if(can_reenter_corpse && mind && mind.current)
		if(clicked_atom == mind.current || (mind.current in clicked_atom)) // double click your corpse or whatever holds it
			reenter_corpse()						// (cloning scanner, body bag, closet, mech, etc)
			return									// seems legit.

	// Things you might plausibly want to follow
	if(ismovableatom(clicked_atom))
		ManualFollow(clicked_atom)

	// Otherwise jump
	else if(clicked_atom.loc)
		forceMove(get_turf(clicked_atom))

/mob/dead/observer/profane/DblClickOn(atom/clicked_atom, params) // Souls trapped by the dagger should not be jumping around.
	return

/mob/dead/observer/rogue/DblClickOn(atom/clicked_atom, params)
	if(check_click_intercept(params2list(params), clicked_atom))
		return

	if(can_reenter_corpse && mind && mind.current)
		if(clicked_atom == mind.current || (mind.current in clicked_atom))
			reenter_corpse()

/mob/dead/observer/ClickOn(atom/clicked_atom, params)
	var/list/modifiers = params2list(params)

	if(check_click_intercept(modifiers, clicked_atom))
		return

	if(SEND_SIGNAL(src, COMSIG_MOB_CLICKON, clicked_atom, modifiers) & COMSIG_MOB_CANCEL_CLICKON)
		return

	if(LAZYACCESS(modifiers, SHIFT_CLICKED) && LAZYACCESS(modifiers, MIDDLE_CLICK))
		ShiftMiddleClickOn(clicked_atom, modifiers)
		return
	if(LAZYACCESS(modifiers, SHIFT_CLICKED) && LAZYACCESS(modifiers, CTRL_CLICKED))
		CtrlShiftClickOn(clicked_atom, modifiers)
		return
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		MiddleClickOn(clicked_atom, modifiers)
		return
	if(LAZYACCESS(modifiers, SHIFT_CLICKED))
		ShiftClickOn(clicked_atom, modifiers)
		return
	if(LAZYACCESS(modifiers, ALT_CLICKED) && LAZYACCESS(modifiers, RIGHT_CLICK))
		AltRightClickOn(clicked_atom, modifiers)
		return
	if(LAZYACCESS(modifiers, CTRL_CLICKED))
		CtrlClickOn(clicked_atom, modifiers)
		return

	if(world.time <= next_move)
		return

	// You are responsible for checking config.ghost_interaction when you override this function
	// Not all of them require checking, see below
	clicked_atom.attack_ghost(src, modifiers)

// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/dead/observer/user, list/modifiers)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_GHOST, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	if(user.client)
		if(user.client.prefs.inquisitive_ghost)
			user.examinate(src)
	return FALSE

/mob/living/attack_ghost(mob/dead/observer/user)
	return ..()
