/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
//This is mainly modified by click code, to modify click delays elsewhere, use next_move and changeNext_move()
/mob/var/next_click	= 0

// THESE DO NOT EFFECT THE BASE 1 DECISECOND DELAY OF NEXT_CLICK
/mob/var/next_move_adjust = 0 //Amount to adjust action/click delays by, + or -
/mob/var/next_move_modifier = 1 //Value to multiply action/click delays by


//Delays the mob's next click/action by num deciseconds
// eg: 10-3 = 7 deciseconds of delay
// eg: 10*0.5 = 5 deciseconds of delay
// DOES NOT EFFECT THE BASE 1 DECISECOND DELAY OF NEXT_CLICK

/mob/proc/changeNext_move(num, hand)
	next_move = world.time + ((num+next_move_adjust)*next_move_modifier)

/mob/living/changeNext_move(num, hand)
	var/mod = next_move_modifier
	var/adj = next_move_adjust
	for(var/datum/status_effect/S as anything in status_effects)
		mod *= S.nextmove_modifier()
		adj += S.nextmove_adjust()
	if(!hand)
		next_move = world.time + ((num + adj)*mod * (InCritical()? 3 : 1))
		hud_used?.cdmid?.mark_dirty()
		return
	if(hand == 1)
		next_lmove = world.time + ((num + adj)*mod * (InCritical()? 3 : 1))
		hud_used?.cdleft?.mark_dirty()
	else
		next_rmove = world.time + ((num + adj)*mod * (InCritical()? 3 : 1))
		hud_used?.cdright?.mark_dirty()

/*
	Before anything else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every mob's variation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to maintain.

	Note that this proc can be overridden, and is in the case of screen objects.
*/
/atom/Click(location, control, params)
	if(flags_1 & INITIALIZED_1)
		SEND_SIGNAL(src, COMSIG_CLICK, location, control, params, usr)
		usr.ClickOn(src, params)

/atom/DblClick(location, control, params)
	if(flags_1 & INITIALIZED_1)
		usr.DblClickOn(src, params)

// Default behavior: ignore double clicks (the second click that makes the doubleclick call already calls for a normal click)
/mob/proc/DblClickOn(atom/clicked_atom, params)
	return

/atom/MouseWheel(delta_x, delta_y, location, control, params)
	if(flags_1 & INITIALIZED_1)
		usr.MouseWheelOn(src, delta_x, delta_y, params)

/*
	Standard mob ClickOn()
	Handles exceptions: Buildmode, middle click, modified clicks, mech actions

	After that, mostly just check your state, check whether you're holding an item,
	check whether you're adjacent to the target, then pass off the click to whoever
	is receiving it.
	The most common are:
	* mob/UnarmedAttack(atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
	* atom/attackby(item,user) - used only when adjacent
	* item/afterattack(atom,user,adjacent,params) - used both ranged and adjacent
	* mob/RangedAttack(atom,params) - used only ranged, only used for tk and laser eyes but could be changed
*/
/mob/proc/ClickOn(atom/clicked_atom, params)
	if(world.time <= next_click)
		return

	var/list/modifiers = params2list(params)

	next_click = world.time + 1

	if(check_click_intercept(modifiers, clicked_atom) || HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

	if(SEND_SIGNAL(src, COMSIG_MOB_CLICKON, clicked_atom, modifiers) & COMSIG_MOB_CANCEL_CLICKON)
		return

	if(SEND_SIGNAL(clicked_atom, COMSIG_ATOM_CLICKEDON, src, modifiers) & COMSIG_MOB_CANCEL_CLICKON)
		return

	if(curplaying)
		curplaying.on_mouse_up()

	if(next_move > world.time) // in the year 2000...
		return

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(LAZYACCESS(modifiers, SHIFT_CLICKED))
			ShiftRightClickOn(clicked_atom, modifiers)
			return

		if(LAZYACCESS(modifiers, CTRL_CLICKED))
			CtrlRightClickOn(clicked_atom, modifiers)
			return

		if(LAZYACCESS(modifiers, ALT_CLICKED))
			AltRightClickOn(clicked_atom, modifiers)
			return

	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		if(atkswinging == MIDDLE_CLICK && mmb_intent?.get_chargetime())
			if(mmb_intent.no_early_release && client?.chargedprog < 100)
				changeNext_move(mmb_intent.clickcd)
		else
			MiddleClickOn(clicked_atom, modifiers)
		return

	if(LAZYACCESS(modifiers, SHIFT_CLICKED))
		ShiftClickOn(clicked_atom, modifiers)
		return

	if(LAZYACCESS(modifiers, ALT_CLICKED)) // alt and alt-gr (rightalt)
		AltClickOn(clicked_atom, modifiers)
		return

	if(LAZYACCESS(modifiers, CTRL_CLICKED))
		CtrlClickOn(clicked_atom, modifiers)
		return

	if(incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB))
		return

	if(!LAZYACCESS(modifiers, CLICK_CATCHER) && clicked_atom.IsObscured())
		return

	if(dir == get_dir(clicked_atom, src)) //they are behind us and we are not facing them
		return

	face_atom(clicked_atom)

	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		changeNext_move(CLICK_CD_HANDCUFFED)   //Doing shit in cuffs shall be vey slow
		UnarmedAttack(clicked_atom, modifiers = modifiers, source = src)
		return

	if(in_throw_mode)
		throw_item(clicked_atom)
		return

	var/obj/item/held_item = get_active_held_item()
	if(held_item == clicked_atom)
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			held_item.attack_self_secondary(src, modifiers)
			update_inv_hands()
			return
		held_item.attack_self(src, modifiers)
		update_inv_hands()
		return

	if(LAZYACCESS(modifiers, LEFT_CLICK) && atkswinging == LEFT_CLICK)
		if(active_hand_index == 1)
			used_hand = 1
			if(next_lmove > world.time)
				return
		else
			used_hand = 2
			if(next_rmove > world.time)
				return
		if(uses_intents)
			if(!ispath(used_intent) && used_intent?.get_chargetime())
				if(used_intent.no_early_release && client?.chargedprog < 100)
					var/adf = used_intent.clickcd
					if(istype(rmb_intent, /datum/rmb_intent/aimed))
						adf = round(adf * 1.4)
					if(istype(rmb_intent, /datum/rmb_intent/swift))
						adf = round(adf * 0.6)
					changeNext_move(adf, used_hand)
					return

	// operate three levels deep here (item in backpack in src; item in box in backpack in src, not any deeper)
	if(!isturf(clicked_atom) && clicked_atom == loc || (clicked_atom in contents) || (clicked_atom.loc in contents) || (clicked_atom.loc && (clicked_atom.loc.loc in contents)))
		// the above ensures adjacency
		resolveAdjacentClick(clicked_atom, held_item, modifiers)
		return

	if(clicked_atom && ismob(clicked_atom) && CanReach(clicked_atom, held_item))
		resolveAdjacentClick(clicked_atom, held_item, modifiers)
		return

	if(!loc.AllowClick()) // This is going to stop you from telekinesing from inside a closet, but I don't shed many tears for that
		return

	// Allows you to click on a box's contents, if that box is on the ground, but no deeper than that
	if(isturf(clicked_atom) || isturf(clicked_atom.loc) || (clicked_atom.loc && (isturf(clicked_atom.loc.loc) || isturf(clicked_atom.loc.loc.loc))))
		if(CanReach(clicked_atom) || CanReach(clicked_atom, held_item))
			if(isopenturf(clicked_atom))
				var/turf/T = clicked_atom
				if(used_intent.noaa)
					resolveAdjacentClick(clicked_atom, held_item, modifiers, used_hand)
					return
				if(T)
					var/list/mobs_here = list()
					for(var/mob/M in T)
						if(M.invisibility || M == src)
							continue
						mobs_here += M
					if(length(mobs_here))
						var/mob/target = pick(mobs_here)
						if(target)
							if(target.Adjacent(src))
								resolveAdjacentClick(target, held_item, modifiers, used_hand)
								atkswinging = null
								return

					resolveAdjacentClick(T, held_item, modifiers, used_hand)
					return
			else
				resolveAdjacentClick(clicked_atom, held_item, modifiers, used_hand)
				atkswinging = null
				return
		else // non-adjacent click
			resolveRangedClick(clicked_atom, held_item, modifiers, used_hand)
			atkswinging = null
			return

	atkswinging = null

//Branching path for Adjacent clicks with or without items
//DOES NOT ACTUALLY KNOW IF YOU'RE ADJACENT, DO NOT CALL ON IT'S OWN
/mob/proc/resolveAdjacentClick(atom/clicked_atom, obj/item/held_item, list/modifiers, used_hand)
	if(!clicked_atom)
		return

	if(held_item)
		held_item.melee_attack_chain(src, clicked_atom, modifiers)
		return

	if(ismob(clicked_atom))
		var/adf = used_intent.clickcd
		if(istype(rmb_intent, /datum/rmb_intent/aimed))
			adf = round(adf * 1.4)
		if(istype(rmb_intent, /datum/rmb_intent/swift))
			adf = round(adf * 0.6)
		changeNext_move(adf)
	UnarmedAttack(clicked_atom, 1, modifiers)

//Branching path for Ranged clicks with or without items
//DOES NOT ACTUALLY KNOW IF YOU'RE RANGED, DO NoT CALL ON IT'S OWN
/mob/proc/resolveRangedClick(atom/clicked_atom, obj/item/held_item, list/modifiers, used_hand)
	if(!clicked_atom)
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK) && uses_intents && used_intent.rmb_ranged)
		used_intent.rmb_ranged(clicked_atom, src) //get the message from the intent
		return
	if(held_item)
		held_item.afterattack(clicked_atom, src, 0, modifiers) // 0: not Adjacent
	else
		RangedAttack(clicked_atom, modifiers)

/mob/proc/swingbarcut()
	client.images -= swingi

/mob/proc/swingiupdate()
	if(swingi && swingtarget)
		swingi.loc = swingtarget.loc

/mob/proc/aftermiss()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.adjust_stamina(used_intent.misscost)

//Is the atom obscured by a PREVENT_CLICK_UNDER_1 object above it
/atom/proc/IsObscured()
	if(!isturf(loc)) //This only makes sense for things directly on turfs for now
		return FALSE
	var/turf/T = get_turf_pixel(src)
	if(!T)
		return FALSE
	for(var/atom/movable/AM in T)
		if(AM.flags_1 & PREVENT_CLICK_UNDER_1 && AM.density && AM.layer > layer)
			return TRUE
	return FALSE

/turf/IsObscured()
	for(var/atom/movable/AM as anything in src)
		if(AM.flags_1 & PREVENT_CLICK_UNDER_1)
			return TRUE
	return FALSE

/atom/movable/proc/CanReach(atom/ultimate_target, obj/item/tool, view_only = FALSE)
	// A backwards depth-limited breadth-first-search to see if the target is
	// logically "in" anything adjacent to us.
	var/list/direct_access = DirectAccess()
	var/depth = 1 + (view_only ? STORAGE_VIEW_DEPTH : INVENTORY_DEPTH)

	var/list/closed = list()
	var/list/checking = list(ultimate_target)
	while (checking.len && depth > 0)
		var/list/next = list()
		--depth

		for(var/atom/target in checking)  // will filter out nulls
			if(closed[target] || isarea(target))  // avoid infinity situations
				continue
			closed[target] = TRUE
			var/usedreach = 1
			if(ismob(src))
				var/mob/user = src
				if(user.used_intent)
					usedreach = user.used_intent.reach
			if(isturf(target) || isturf(target.loc) || (target in direct_access) || (ismovable(target) && target.flags_1 & IS_ONTOP_1)) //Directly accessible atoms
				if(Adjacent(target) || (tool && CheckToolReach(src, target, usedreach))) //Adjacent or reaching attacks
					return TRUE

			if (!target.loc)
				continue

			if(!(SEND_SIGNAL(target.loc, COMSIG_ATOM_CANREACH, next) & COMPONENT_BLOCK_REACH))
				next += target.loc

		checking = next
	return FALSE

/atom/movable/proc/DirectAccess()
	return list(src, loc)

/mob/DirectAccess(atom/target)
	return ..() + contents

/mob/living/DirectAccess(atom/target)
	return ..() + GetAllContents()

/atom/proc/AllowClick()
	return FALSE

/turf/AllowClick()
	return TRUE

/proc/CheckToolReach(atom/movable/here, atom/movable/there, reach)
	if(!here || !there)
		return
	switch(reach)
		if(0)
			return FALSE
		if(1)
			return FALSE //here.Adjacent(there)
		if(2 to INFINITY)
			var/obj/effect/dummy = new(get_turf(here))
			dummy.pass_flags |= PASSTABLE
			dummy.movement_type = FLYING
			dummy.invisibility = INVISIBILITY_ABSTRACT
			for(var/i in 1 to reach) //Limit it to that many tries
				var/turf/T = get_step(dummy, get_dir(dummy, there))
				if(dummy.CanReach(there))
					qdel(dummy)
					return TRUE
				if(!dummy.Move(T)) //we're blocked!
					qdel(dummy)
					return
			qdel(dummy)

/*
	Translates into attack_hand, etc.

	Note: proximity_flag here is used to distinguish between normal usage (flag=1),
	and usage when clicking on things telekinetically (flag=0).  This proc will
	not be called at ranged except with telekinesis.

	proximity_flag is not currently passed to attack_hand, and is instead used
	in human click code to allow glove touches only at melee range.
*/
/mob/proc/UnarmedAttack(atom/clicked_atom, proximity_flag, list/modifiers, atom/source)
	return

/*
	Ranged unarmed attack:

	This currently is just a default for all mobs, involving
	laser eyes and telekinesis.  You could easily add exceptions
	for things like ranged glove touches, spitting alien acid/neurotoxin,
	animals lunging, etc.
*/
/mob/proc/RangedAttack(atom/clicked_atom, list/modifiers)
	if(SEND_SIGNAL(src, COMSIG_MOB_ATTACK_RANGED, clicked_atom, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE

/**
 *Middle click
 *Mainly used for swapping hands
 */
/mob/proc/MiddleClickOn(atom/clicked_atom, list/modifiers)
	if(SEND_SIGNAL(src, COMSIG_MOB_MIDDLECLICKON, clicked_atom, modifiers) & COMSIG_MOB_CANCEL_CLICKON)
		return

/atom/proc/MiddleClick(mob/user, list/modifiers)
	return

/turf/open/MiddleClick(mob/user, list/modifiers)
	if(!user.TurfAdjacent(src))
		return
	if(user.get_active_held_item())
		return
	var/list/obj/item/atomy = list()
	var/list/atomcounts = list()
	var/list/atomrefs = list()
	var/list/overrides = list()
	for(var/image/I in user.client.images)
		if(I.loc && I.loc.loc == src && I.override)
			overrides += I.loc
	for(var/obj/item/clicked_atom in src)
		if(!clicked_atom.mouse_opacity)
			continue
		if(clicked_atom.invisibility > user.see_invisible)
			continue
		if(overrides.len && (clicked_atom in overrides))
			continue
		if(clicked_atom.IsObscured())
			continue
		if(!clicked_atom.name)
			continue
		var/AN = clicked_atom.name
		atomcounts[AN] += 1
		if(!atomrefs[AN]) // Only the FIRST item that matches the same name
			atomrefs[AN] = clicked_atom // If this one item can't get picked up, sucks to be you
	if(length(atomrefs))
		for(var/AC in atomrefs)
			var/AD = "[AC] ([atomcounts[AC]])"
			atomy[AD] = atomrefs[AC]
	var/atom/AB = input(user, "What will I take?","Items on [src.name ? "\the [src.name]:" : "the floor:"]",null) as null|anything in atomy
	if(!AB)
		return
	if(QDELETED(atomy[AB]))
		return
	if(atomy[AB].loc != src)
		return
	var/AE = atomy[AB]
	user.cast_move = 0
	user.used_intent = user.a_intent
	user.UnarmedAttack(AE, 1, modifiers)

/mob/proc/ShiftMiddleClickOn(atom/clicked_atom, list/modifiers)
	if(SEND_SIGNAL(src, COMSIG_MOB_MIDDLECLICKON, clicked_atom, modifiers) & COMSIG_MOB_CANCEL_CLICKON)
		return

/*
	Shift click
	For most mobs, examine.
	This is overridden in ai.dm
*/
/mob/proc/ShiftClickOn(atom/clicked_atom, list/modifiers)
	clicked_atom.ShiftClick(src, modifiers)

/atom/proc/ShiftClick(mob/user, list/modifiers)
	SEND_SIGNAL(src, COMSIG_CLICK_SHIFT, user, modifiers)
	if(user.client && user.client.eye == user || user.client.eye == user.loc)
		user.examinate(src)

/*
	Ctrl click
	For most objects, pull
*/
/mob/proc/CtrlClickOn(atom/clicked_atom, list/modifiers)
	clicked_atom.CtrlClick(src, modifiers)

/atom/proc/CtrlClick(mob/user, list/modifiers)
	SEND_SIGNAL(src, COMSIG_CLICK_CTRL, user, modifiers)

/*
	Alt click
*/
/mob/proc/AltClickOn(atom/clicked_atom, list/modifiers)
	. = SEND_SIGNAL(src, COMSIG_MOB_ALTCLICKON, clicked_atom, modifiers)
	if(. & COMSIG_MOB_CANCEL_CLICKON)
		return

	clicked_atom.AltClick(src, modifiers)

/atom/proc/AltClick(mob/user, list/modifiers)
	SEND_SIGNAL(src, COMSIG_CLICK_ALT, user, modifiers)

/mob/proc/TurfAdjacent(turf/tile)
	return tile.Adjacent(src)

/*
	Control+Shift click
	Unused except for AI
*/
/mob/proc/CtrlShiftClickOn(atom/clicked_atom, list/modifiers)
	clicked_atom.CtrlShiftClick(src, modifiers)
	return

/atom/proc/CtrlShiftClick(mob/user, list/modifiers)
	SEND_SIGNAL(src, COMSIG_CLICK_CTRL_SHIFT, modifiers)

/mob/proc/AltRightClickOn(atom/clicked_atom, list/modifiers)
	SEND_SIGNAL(src, COMSIG_CLICK_ALT, clicked_atom, modifiers)
	clicked_atom.AltRightClick(src, modifiers)

/atom/proc/AltRightClick(mob/user, list/modifiers)
	if(!user.can_interact_with(src))
		return FALSE

	if(HAS_TRAIT(src, TRAIT_ALT_CLICK_BLOCKER) && !isobserver(user))
		return TRUE

	var/turf/tile = get_turf(src)
	if(isnull(tile))
		return FALSE

	if(!isturf(loc) && !isturf(src))
		return FALSE

	if(!user.TurfAdjacent(tile))
		return FALSE

	var/datum/lootpanel/panel = user.client?.loot_panel
	if(isnull(panel))
		return FALSE

	/// No loot panel if it's on our person
	if(isobj(src) && iscarbon(user))
		var/mob/living/carbon/carbon_user = user
		if(src in carbon_user.get_all_gear())
			to_chat(carbon_user, span_warning("You can't search for this item, it's already in your inventory! Take it off first."))
			return

	panel.open(tile)
	return TRUE

/mob/proc/CtrlRightClickOn(atom/clicked_atom, list/modifiers)
	pointed(clicked_atom)

/*
	Misc helpers
	face_atom: turns the mob towards what you clicked on
*/
/atom/proc/face_me(location, control, params)
	return src

// Simple helper to face another atom, much nicer than byond's dir = get_dir(src,clicked_atom) which is biased in some ugly ways
/atom/proc/face_atom(atom/clicked_atom, location, control, params)
	if(!clicked_atom)
		return
	if(!clicked_atom.xyoverride)
		if((!clicked_atom || !x || !y || !clicked_atom.x || !clicked_atom.y))
			return
	var/atom/holder = clicked_atom.face_me(location, control, params)
	if(!holder)
		return
	var/dx = holder.x - x
	var/dy = holder.y - y
	if(!dx && !dy) // Wall items are graphically shifted but on the floor
		if(holder.pixel_y > 16)
			setDir(NORTH)
		else if(holder.pixel_y < -16)
			setDir(SOUTH)
		else if(holder.pixel_x > 16)
			setDir(EAST)
		else if(holder.pixel_x < -16)
			setDir(WEST)
		return

	if(abs(dx) < abs(dy))
		if(dy > 0)
			setDir(NORTH)
		else
			setDir(SOUTH)
	else
		if(dx > 0)
			setDir(EAST)
		else
			setDir(WEST)

/mob/face_atom(atom/clicked_atom)
	if(!canface(clicked_atom))
		return FALSE
	..()

/mob/living/face_atom(atom/clicked_atom)
	var/olddir = dir
	..()
	if(dir != olddir)
		last_dir_change = world.time

//debug
/atom/movable/screen/proc/scale_to(x1,y1)
	if(!y1)
		y1 = x1
	var/matrix/M = new
	M.Scale(x1,y1)
	transform = M

/atom/movable/screen/click_catcher
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "catcher"
	plane = CLICKCATCHER_PLANE
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	screen_loc = "CENTER"
	xyoverride = TRUE
	blockscharging = FALSE

#define MAX_SAFE_BYOND_ICON_SCALE_TILES (MAX_SAFE_BYOND_ICON_SCALE_PX / world.icon_size)
#define MAX_SAFE_BYOND_ICON_SCALE_PX (33 * 32)			//Not using world.icon_size on purpose.

/atom/movable/screen/click_catcher/proc/UpdateGreed(view_size_x = 15, view_size_y = 15)
	var/icon/newicon = icon('icons/mob/screen_gen.dmi', "catcher")
	var/ox = min(MAX_SAFE_BYOND_ICON_SCALE_TILES, view_size_x)
	var/oy = min(MAX_SAFE_BYOND_ICON_SCALE_TILES, view_size_y)
	var/px = view_size_x * world.icon_size
	var/py = view_size_y * world.icon_size
	var/sx = min(MAX_SAFE_BYOND_ICON_SCALE_PX, px)
	var/sy = min(MAX_SAFE_BYOND_ICON_SCALE_PX, py)
	newicon.Scale(sx, sy)
	icon = newicon
	screen_loc = "CENTER-[(ox-1)*0.5],CENTER-[(oy-1)*0.5]"
	var/matrix/M = new
	M.Scale(px/sx, py/sy)
	transform = M

#undef MAX_SAFE_BYOND_ICON_SCALE_TILES
#undef MAX_SAFE_BYOND_ICON_SCALE_PX

/atom/movable/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	var/turf/T = params2turf(LAZYACCESS(modifiers, SCREEN_LOC), get_turf(usr.client ? usr.client.eye : usr), usr.client)
	params += "&catcher=1"
	if(T)
		T.Click(location, control, params)
	. = 1

/atom/movable/screen/click_catcher/face_me(location, control, params)
	var/list/modifiers = params2list(params)
	var/turf/T = params2turf(LAZYACCESS(modifiers, SCREEN_LOC), get_turf(usr.client ? usr.client.eye : usr), usr.client)
	if(T)
		return T


/* MouseWheelOn */

/mob/proc/MouseWheelOn(atom/clicked_atom, delta_x, delta_y, params)
	return

/mob/living/MouseWheelOn(atom/clicked_atom, delta_x, delta_y, params)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICKED))
		if(delta_y > 0)
			aimheight_change("up")
		else
			aimheight_change("down")

/mob/dead/observer/MouseWheelOn(atom/clicked_atom, delta_x, delta_y, params)
	return

/mob/proc/check_click_intercept(modifiers, clicked_atom)
	//Client level intercept
	if(client && client.click_intercept)
		if(call(client.click_intercept, "InterceptClickOn")(src, modifiers, clicked_atom))
			return TRUE

	//Mob level intercept
	if(click_intercept)
		if(call(click_intercept, "InterceptClickOn")(src, modifiers, clicked_atom))
			return TRUE

	return FALSE

/mob/proc/TargetMob(mob/target)
	if(ismob(target))
		if(targetting) //untarget old target
			UntargetMob()
		targetting = target
		if(!fixedeye) //If fixedeye isn't already enabled, we need to set this var
			atom_flags |= NO_DIR_CHANGE_ON_MOVE
		tempfixeye = TRUE //Change icon to 'target' red eye
		targeti = image('icons/mouseover.dmi', targetting.loc, "target")
		var/icon/I = icon(icon, icon_state, dir)
		targeti.pixel_y = I.Height() - world.icon_size - 4
		targeti.pixel_x = -1
		src.client.images |= targeti
		for(var/atom/movable/screen/eye_intent/eyet in hud_used.static_inventory)
			eyet.update_appearance(UPDATE_ICON)
	else
		UntargetMob()

/mob/proc/UpdateTargetImage()
	if(targeti)
		targeti.loc = targetting.loc

/mob/proc/FaceTarget()
	return

/mob/proc/UntargetMob()
	targetting = null
	tempfixeye = FALSE
	if(!fixedeye)
		atom_flags &= ~NO_DIR_CHANGE_ON_MOVE
	src.client.images -= targeti
	//clear hud icon
	for(var/atom/movable/screen/eye_intent/eyet in hud_used.static_inventory)
		eyet.update_appearance(UPDATE_ICON)

/mob/proc/ShiftRightClickOn(atom/clicked_atom, list/modifiers)
	if(mind && mind.active_uis["quake_console"])
		if(client.holder)
			client.holder.marked_datum = clicked_atom
			var/datum/visual_ui/console/console =  mind.active_uis["quake_console"]
			var/obj/abstract/visual_ui_element/scrollable/console_output/output = locate(/obj/abstract/visual_ui_element/scrollable/console_output) in console.elements
			output.add_line("MARKED: [clicked_atom]")

/mob/living/ShiftRightClickOn(atom/clicked_atom, list/modifiers)
	var/turf/T = get_turf(clicked_atom)
	if(stat)
		return
	if(clicked_atom.Adjacent(src))
		if(T == loc)
			look_up()
		else
			if(istransparentturf(T))
				look_down(T)
			else
				look_further(T)
	else
		look_further(T)

/atom/proc/ShiftRightClick(mob/user)
	SEND_SIGNAL(src, COMSIG_CLICK_RIGHT_SHIFT, user)
	if(user.client && user.client.eye == user || user.client.eye == user.loc)
		user.examinate(src)

/mob/proc/addtemptarget()
	if(targetting)
		if(targetting == swingtarget)
			return
		UntargetMob()
	temptarget = TRUE
	targetting = swingtarget
	if(!fixedeye)
		atom_flags |= NO_DIR_CHANGE_ON_MOVE
	tempfixeye = TRUE
	for(var/atom/movable/screen/eye_intent/eyet in hud_used.static_inventory)
		eyet.update_appearance(UPDATE_ICON)
