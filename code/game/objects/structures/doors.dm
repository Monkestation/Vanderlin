/obj/structure/door
	name = "wooden door"
	desc = "A door that can open and close."
	icon = 'icons/roguetown/misc/doors.dmi'
	icon_state = "woodhandle"
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	layer = OPEN_DOOR_LAYER
	resistance_flags = FLAMMABLE
	max_integrity = 1000
	integrity_failure = 0.5
	armor = list("blunt" = 10, "slash" = 10, "stab" = 10,  "piercing" = 0, "fire" = 0, "acid" = 0)
	damage_deflection = 10
	CanAtmosPass = ATMOS_PASS_DENSITY
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg', 'sound/combat/hits/onwood/woodimpact (2).ogg')
	lock = /datum/lock/key
	can_add_lock = TRUE

	/// Can people riding go through without falling off their mount
	var/ridethrough = FALSE
	/// If TRUE when bumped open we callback close
	var/bump_closed = FALSE
	var/door_opened = FALSE
	/// If we are switching states
	var/switching_states = FALSE
	/// Delay of auto closing, values 0 or below do not auto close.
	var/close_delay = 0
	/// How long should it take for the door to change states? Ideally matches the icon's animation length
	var/animate_time = 1 SECONDS
	var/open_sound = 'sound/foley/doors/creak.ogg'
	var/close_sound = 'sound/foley/doors/shut.ogg'

	/// If we are windowed, to avoid setting opacity
	var/windowed = FALSE
	/// Last bump time
	var/last_bump = null
	/// Initial value is STR requirement to kick, then var is used as how many kicks to force open
	var/kickthresh = 15
	/// Can we knock on the door
	var/can_knock = TRUE
	/// Are ghosts prevented from passing through
	var/ghostproof = FALSE

	var/repairable = TRUE
	var/repair_state = 0
	var/obj/item/repair_cost_first = /obj/item/grown/log/tree/small
	var/obj/item/repair_cost_second = /obj/item/grown/log/tree/small
	var/repair_skill = /datum/skill/craft/carpentry
	metalizer_result = /obj/structure/door/iron
	/// Handle bolting on right click
	var/has_bolt = FALSE
	/// Handle viewport toggle on right click
	var/has_viewport = FALSE

/obj/structure/door/Initialize()
	. = ..()
	if(has_bolt && has_viewport)
		warning("[src] at [AREACOORD(src)] has both a deadbolt and a viewport, these will conflict as they both use attack_right.")
	if(has_bolt && lock?.uses_key)
		warning("[src] at [AREACOORD(src)] has both a deadbolt and a keylock, while this will work it may produce unintended behaviour.")
	if(isopenturf(loc))
		RegisterSignal(loc, COMSIG_ATOM_ATTACK_HAND, PROC_REF(redirect_attack)) // redirect the attack to the door
	set_init_layer()

/obj/structure/door/Destroy()
	. = ..()
	UnregisterSignal(loc, COMSIG_ATOM_ATTACK_HAND, PROC_REF(redirect_attack))

/obj/structure/door/proc/redirect_attack(turf/source, mob/user)
	attack_hand(user)

/obj/structure/door/proc/set_init_layer()
	if(density)
		layer = CLOSED_DOOR_LAYER
	else
		layer = initial(layer)

/obj/structure/door/update_icon()
	if(obj_broken)
		icon_state = "[initial(icon_state)]br"
		return
	icon_state = "[initial(icon_state)][door_opened ? "open":""]"

/obj/structure/door/examine(mob/user)
	. = ..()
	if(has_viewport)
		. += span_info("It has a built-in viewport.")
	if(has_bolt)
		. += span_info("It's lock is a deadbolt.")
	if(lock?.uses_key)
		. += span_info("There is a keyhole below the handle.")
	if(!repairable)
		return
	if(!repair_cost_first || !repair_cost_second)
		return
	if(obj_integrity < max_integrity)
		if(repair_state == 0)
			. += span_notice("A [repair_cost_first.name] can be used to repair it.")
		if(obj_broken || repair_state == 1)
			. += span_notice("An additional [repair_cost_second.name] is needed to finish repairs.")

/obj/structure/door/onkick(mob/user)
	if(obj_broken || switching_states)
		return
	if(door_opened)
		playsound(get_turf(src), pick(attacked_sound), 100)
		user.visible_message(span_warning("[user] kicks [src] shut!"), \
			span_notice("I kick [src] shut!"))
		force_closed()
		return
	if(!locked())
		playsound(get_turf(src), pick(attacked_sound), 100)
		user.visible_message(span_warning("[user] kicks [src] open!"), \
			span_notice("I kick [src] open!"))
		force_open()
		return
	if(isliving(user))
		var/mob/living/L = user
		if(L.STASTR < initial(kickthresh))
			playsound(get_turf(src), pick(attacked_sound), 100)
			user.visible_message(span_warning("[user] kicks [src]! It's not effective."), \
			span_notice("I kick [src]! It's not effective."))
			return
		if((prob(L.STASTR * 0.5) || kickthresh-- == 0))
			playsound(get_turf(src), pick(attacked_sound), 100)
			user.visible_message(span_warning("[user] kicks open [src]!"), \
				span_notice("I kick open [src]!"))
			unlock()
			force_open()
			return
		playsound(get_turf(src), pick(attacked_sound), 100)
		user.visible_message(span_warning("[user] kicks [src]!"), \
			span_notice("I kick [src]!"))

/obj/structure/door/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/door/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(obj_broken || switching_states)
		return
	if(!locked())
		return TryToSwitchState(user)
	if(user.used_intent.type == /datum/intent/unarmed/claw)
		user.changeNext_move(CLICK_CD_MELEE)
		to_chat(user, span_warning("I claw at [src]"))
		take_damage(40, BRUTE, BCLASS_CUT, TRUE)
		return
	if(isliving(user))
		var/mob/living/L = user
		if(L.m_intent == MOVE_INTENT_SNEAK)
			to_chat(user, span_warning("This door is locked."))
			return
	if(can_knock)
		if(user.a_intent?.name == "punch")
			playsound(src, 'sound/foley/doors/knocking.ogg', 100)
			user.visible_message(span_warning("[user] knocks on [src]."), \
				span_notice("I knock on [src]."))
			return
		rattle()
		user.visible_message(span_warning("[user] tries the handle, but the door does not move."), \
			span_notice("I try the handle, but the door does not move."))

/obj/structure/door/pre_lock_interact(mob/user)
	if(switching_states)
		return FALSE
	if(door_opened)
		to_chat(user, span_notice("I cannot lock \the [src] while it is open."))
		return FALSE
	return ..()

/obj/structure/door/attackby(obj/item/I, mob/user)
	if(switching_states)
		return
	if(repairable && (user.get_skill_level(repair_skill) > 0) && ((istype(I, repair_cost_first)) || (istype(I, repair_cost_second)))) // At least 1 skill level needed
		repairdoor(I, user)
		return
	return ..()

/obj/structure/door/attack_right(mob/user)
	if(switching_states)
		return
	user.changeNext_move(CLICK_CD_FAST)
	if(!user.get_active_held_item())
		if(has_bolt)
			if(obj_broken)
				to_chat(user, span_warning("The bolt has nothing to latch to!"))
				return
			if(get_dir(src, user) == dir)
				lock?.toggle(user)
				return
			to_chat(user, span_notice("I can't reach the bolt from this side."))
			return
		if(has_viewport)
			if(obj_broken)
				to_chat(user, span_warning("The viewport is broken!"))
				return
			if(get_dir(src, user) == dir)
				viewport_toggle(user)
				return
			to_chat(user, span_notice("The viewport does not open from this side."))
			return
	return ..()

/obj/structure/door/attack_ghost(mob/dead/observer/user)	// lets ghosts click on windows to transport across
	if(!ghostproof)
		density = FALSE
		. = step(user, get_dir(user, loc))
		density = TRUE

/obj/structure/door/Bumped(atom/movable/AM)
	. = ..()
	if(obj_broken || switching_states)
		return
	if(world.time < last_bump + 20)
		return
	last_bump = world.time
	if(ismob(AM))
		var/mob/user = AM
		if(HAS_TRAIT(user, TRAIT_BASHDOORS))
			if(locked())
				user.visible_message(span_warning("[user] bashes into [src]!"))
				take_damage(200, BRUTE, BCLASS_BLUNT, TRUE)
			else
				playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
				force_open()
				user.visible_message(span_warning("[user] smashes through [src]!"))
			return
		if(HAS_TRAIT(user, TRAIT_ROTMAN))
			if(locked())
				user.visible_message(span_warning("The deadite bashes into [src]!"))
				take_damage(50, BRUTE, BCLASS_BLUNT, TRUE)
			else
				playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 90)
				force_open()
				user.visible_message(span_warning("The deadite smashes through [src]!"))
			return
		if(locked())
			rattle()
			return
		if(TryToSwitchState(AM))
			if(isliving(AM) && bump_closed)
				var/mob/living/M = AM
				var/delay = (close_delay >= 0) ? close_delay : 2.5 SECONDS
				if(M.m_intent == MOVE_INTENT_SNEAK)
					addtimer(CALLBACK(src, PROC_REF(Close), TRUE), delay)
				else
					addtimer(CALLBACK(src, PROC_REF(Close), FALSE), delay)

/obj/structure/door/CanAStarPass(ID, to_dir, datum/caller)
	. = ..()
	if(.) // we can already go through it
		return TRUE
	if(!anchored)
		return FALSE
	if(HAS_TRAIT(caller, TRAIT_BASHDOORS))
		return TRUE // bash into it!
	// it's openable
	return ishuman(caller) && !locked()

/obj/structure/door/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /mob/camera))
		return TRUE
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/door/setAnchored(anchorvalue) //called in default_unfasten_wrench() chain
	. = ..()
	set_opacity(anchored ? !door_opened : FALSE)

/obj/structure/door/obj_break(damage_flag, silent)
	. = ..()
	unlock()
	force_open()

/obj/structure/door/OnCrafted(dirin, user)
	. = ..()
	if(has_bolt || has_viewport)
		dir = turn(dirin, 180)
	if(has_bolt)
		lock = new /datum/lock(src)
		can_add_lock = FALSE

/obj/structure/door/fire_act(added, maxstacks)
	if(!added)
		return FALSE
	if(added < 10)
		return FALSE
	..()

/obj/structure/door/proc/TryToSwitchState(atom/user)
	if(switching_states || !anchored)
		return FALSE
	if(HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return FALSE
	if(!isliving(user))
		return FALSE
	var/mob/living/M = user
	if(!M.client)
		return FALSE
	if(!iscarbon(M))
		SwitchState()
		return FALSE
	var/mob/living/carbon/C = M
	if(!C.handcuffed)
		if(C.m_intent == MOVE_INTENT_SNEAK)
			SwitchState(TRUE)
		else
			SwitchState()
		return TRUE

/obj/structure/door/proc/SwitchState(silent = FALSE)
	if(door_opened)
		Close(silent)
		return
	Open(silent)

/obj/structure/door/proc/Open(silent = FALSE)
	switching_states = TRUE
	if(!silent)
		playsound(get_turf(src), open_sound, 90)
	if(!windowed)
		set_opacity(FALSE)
	flick("[initial(icon_state)]opening",src)
	sleep(animate_time)
	density = FALSE
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	update_icon()
	switching_states = FALSE

	if(close_delay > 0)
		addtimer(CALLBACK(src, PROC_REF(Close), silent), close_delay)

/obj/structure/door/proc/force_open()
	switching_states = TRUE
	if(!windowed)
		set_opacity(FALSE)
	density = FALSE
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	update_icon()
	switching_states = FALSE

	if(close_delay > 0)
		addtimer(CALLBACK(src, PROC_REF(Close)), close_delay)

/obj/structure/door/proc/Close(silent = FALSE)
	if(switching_states || !door_opened)
		return
	for(var/mob/living/L in get_turf(src))
		return
	switching_states = TRUE
	if(!silent)
		playsound(get_turf(src), close_sound, 90)
	if(!windowed)
		set_opacity(TRUE)
	flick("[initial(icon_state)]closing", src)
	sleep(animate_time)
	density = TRUE
	door_opened = FALSE
	layer = CLOSED_DOOR_LAYER
	update_icon()
	switching_states = FALSE

/obj/structure/door/proc/force_closed()
	switching_states = TRUE
	if(!windowed)
		set_opacity(TRUE)
	density = TRUE
	door_opened = FALSE
	layer = CLOSED_DOOR_LAYER
	update_icon()
	switching_states = FALSE

/obj/structure/door/proc/viewport_toggle(mob/user)
	if(switching_states || door_opened)
		return
	if(!windowed)
		to_chat(user, span_info("I slide the viewport open."))
		windowed = TRUE
		set_opacity(FALSE)
		playsound(src, 'sound/foley/doors/windowup.ogg', 100)
		return
	to_chat(user, span_info("I slide the viewport closed."))
	windowed = FALSE
	set_opacity(TRUE)
	playsound(src, 'sound/foley/doors/windowup.ogg', 100)

/obj/structure/door/proc/repairdoor(obj/item/I, mob/user)
	if(!obj_broken)
		if(obj_integrity < max_integrity)
			user.visible_message(span_notice("[user] starts repairing [src]."), span_notice("I start repairing [src]."))
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
			if(do_after(user, (30 SECONDS / user.get_skill_level(repair_skill)), src))
				qdel(I)
				playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
				obj_integrity = clamp(obj_integrity + max_integrity * integrity_failure, 0, max_integrity)
				user.visible_message(span_notice("[user] finishes repairing [src]."), span_notice("I finished repairing [src]."))
			return
	switch(repair_state)
		if(0)
			if(!istype(I, repair_cost_first))
				return
			user.visible_message(span_notice("[user] starts repairing [src]."), span_notice("I start repairing [src]."))
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
			if(!do_after(user, (30 SECONDS / user.get_skill_level(repair_skill)), src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.
				return
			repair_state = 1
			qdel(I)
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		if(1)
			if(!istype(I, repair_cost_second))
				return
			user.visible_message(span_notice("[user] starts repairing [src]."), span_notice("I start repairing [src]."))
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
			if(!do_after(user, (30 SECONDS / user.get_skill_level(repair_skill)), src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.
				return
			qdel(I)
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
			force_closed()
			obj_broken = FALSE
			obj_integrity = max_integrity
			repair_state = 0
			user.visible_message(span_notice("[user] finishes repairing [src]."), span_notice("I finished repairing [src]."))

/obj/structure/door/green
	icon_state = "wcg"

/obj/structure/door/red
	icon_state = "wcr"

/obj/structure/door/violet
	icon_state = "wcv"

/obj/structure/door/fancy
	icon_state = "fancy_wood"

/obj/structure/door/window
	icon_state = "woodwindow"
	opacity = FALSE
	windowed = TRUE

/obj/structure/door/viewport
	icon_state = MAP_SWITCH("donjon", "donjondir")
	max_integrity = 2000
	has_viewport = TRUE
	lock_sound = 'sound/foley/lockmetal.ogg'
	unlock_sound = 'sound/foley/lockmetal.ogg'
	rattle_sound = 'sound/foley/lockrattlemetal.ogg'
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	repair_cost_second = /obj/item/ingot/iron
	metalizer_result = null

/obj/structure/door/swing
	name = "swing door"
	desc = "A door that swings."
	icon_state = "swing"
	windowed = TRUE
	opacity = FALSE
	lock = null
	metalizer_result = /obj/structure/door/iron/bars
	bump_closed = TRUE
	close_delay =  1 SECONDS
	animate_time = 0.4 SECONDS

/obj/structure/door/weak
	icon_state = "wood"
	max_integrity = 500
	kickthresh = 10
	open_sound = 'sound/foley/doors/shittyopen.ogg'
	close_sound = 'sound/foley/doors/shittyclose.ogg'
	metalizer_result = null

/obj/structure/door/weak/bolt
	icon_state = MAP_SWITCH("wood", "wooddir")
	has_bolt = TRUE
	lock = /datum/lock

/obj/structure/door/weak/bolt/shutter
	name = "serving hatch"
	desc = "Can be locked from the inside."
	icon_state = "serving"
	max_integrity = 250
	open_sound = 'sound/foley/blindsopen.ogg'
	close_sound = 'sound/foley/blindsclose.ogg'
	dir = NORTH
	lock = /datum/lock/locked
	animate_time = 2.1 SECONDS

/obj/structure/door/iron
	name = "iron door"
	icon_state = "donjon"
	armor = list("blunt" = 15, "slash" = 30, "stab" = 30,  "piercing" = 0, "fire" = 50, "acid" = 50)
	max_integrity = 2000
	damage_deflection = 15
	resistance_flags = FIRE_PROOF
	blade_dulling = DULLING_BASH
	open_sound = 'sound/foley/doors/ironopen.ogg'
	close_sound = 'sound/foley/doors/ironclose.ogg'
	lock_sound = 'sound/foley/lockmetal.ogg'
	unlock_sound = 'sound/foley/lockmetal.ogg'
	rattle_sound = 'sound/foley/lockrattlemetal.ogg'
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	repair_cost_first = /obj/item/ingot/iron
	repair_cost_second = /obj/item/ingot/iron
	repair_skill = /datum/skill/craft/blacksmithing
	metalizer_result = null

/obj/structure/door/iron/bars
	icon_state = "bars"
	max_integrity = 1000
	blade_dulling = DULLING_BASHCHOP
	windowed = TRUE
	opacity = FALSE
	ridethrough = TRUE
	animate_time = 0.6 SECONDS

/obj/structure/door/iron/bars/cell
	name = "cell door"
	kickthresh = 20

/obj/structure/door/stone
	name = "stone door"
	icon_state = "stone"
	armor = list("blunt" = 15, "slash" = 30, "stab" = 30,  "piercing" = 0, "fire" = 50, "acid" = 50)
	open_sound = 'sound/foley/doors/stoneopen.ogg'
	close_sound = 'sound/foley/doors/stoneclose.ogg'
	repair_cost_first = /obj/item/natural/stone
	repair_cost_second = /obj/item/natural/stone
	repair_skill = /datum/skill/craft/masonry
	smeltresult = null
	metalizer_result = null
