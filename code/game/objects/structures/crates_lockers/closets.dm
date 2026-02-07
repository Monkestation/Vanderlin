#define LOCKER_FULL -1

/obj/structure/closet
	name = "closet"
	desc = ""
	icon = 'icons/obj/closet.dmi'
	icon_state = "generic"
	density = TRUE
	drag_slowdown = 1.5		// Same as a prone mob
	max_integrity = 200
	integrity_failure = 0.25
	armor = list("blunt" = 20, "slash" = 20, "stab" = 20,  "piercing" = 10, "fire" = 70, "acid" = 60)

	var/icon_door = null
	var/icon_door_override = FALSE //override to have open overlay use icon different to its base's
	var/secure = FALSE //secure locker or not, also used if overriding a non-secure locker with a secure door overlay to add fancy lights
	var/opened = FALSE
	var/welded = FALSE
	var/large = TRUE
	var/wall_mounted = 0 //never solid (You can always pass over it)
	var/breakout_time = 1200
	var/message_cooldown
	var/can_weld_shut = TRUE
	var/horizontal = FALSE
	var/allow_dense = FALSE
	var/dense_when_open = FALSE //if it's dense when open or not
	var/max_mob_size = MOB_SIZE_HUMAN //Biggest mob_size accepted by the container
	var/mob_storage_capacity = 2 // how many human sized mob/living can fit together inside a closet.
	var/storage_capacity = 30 //This is so that someone can't pack hundreds of items in a locker/crate then open it in a populated area to crash clients.
	var/open_sound = 'sound/misc/cupboard_open.ogg'
	var/close_sound = 'sound/misc/cupboard_close.ogg'
	var/open_sound_volume = 100
	var/close_sound_volume = 100
	var/material_drop
	var/material_drop_amount = 2
	var/anchorable = TRUE
	throw_speed = 1
	throw_range = 1
	anchored = FALSE

	can_add_lock = TRUE
	lock = /datum/lock/key

	var/alternative_icon_handling = FALSE
	var/list/spawn_contents

/obj/structure/closet/crate/Initialize()
	. = ..()
	if(!base_icon_state)
		base_icon_state = initial(icon_state)
	update_appearance(UPDATE_ICON_STATE)

/*
/obj/structure/closet/get_save_vars()
	. = ..()
	spawn_contents = list()
	for(var/obj/item/item in contents)
		LAZYADD(spawn_contents, item.type)
	. += NAMEOF(src, spawn_contents)
*/

/obj/structure/closet/Initialize(mapload)
	if(length(spawn_contents))
		for(var/atom/movable/spawning_atom as anything in spawn_contents)
			new spawning_atom(get_turf(src))
	if(mapload && !opened)		// if closed, any item at the crate's loc is put in the contents
		addtimer(CALLBACK(src, PROC_REF(take_contents)), 0)
	. = ..()
	update_appearance(UPDATE_ICON_STATE)
	populate_contents()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_MAGICALLY_UNLOCKED = PROC_REF(on_magic_unlock),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/closet/Destroy()
	dump_contents()
	return ..()

//USE THIS TO FILL IT, NOT INITIALIZE OR NEW
/obj/structure/closet/proc/populate_contents()
	return

// TODO: REIMPLEMENT TG CLOSET AND CRATE OVERLAYS
/obj/structure/closet/update_icon_state()
	. = ..()
	if(!alternative_icon_handling)
		icon_state = "[base_icon_state][opened ? "open" : ""]"

/obj/structure/closet/pre_sell()
	open()
	..()

/obj/structure/closet/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(wall_mounted)
		return TRUE

/obj/structure/closet/proc/can_open(mob/living/user)
	if(welded || locked())
		if(user)
			to_chat(user, "<span class='warning'>Locked.</span>" )
		return FALSE
	return TRUE

/obj/structure/closet/proc/can_close(mob/living/user)
	return TRUE

/obj/structure/closet/dump_contents()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in src)
		AM.forceMove(L)
		if(throwing) // you keep some momentum when getting out of a thrown closet
			step(AM, dir)
	if(throwing)
		throwing.finalize(FALSE)

/obj/structure/closet/proc/take_contents(mapload = FALSE)
	var/atom/location = drop_location()
	if(!location)
		return
	for(var/atom/movable/AM in location)
		if(AM != src && insert(AM, mapload) == LOCKER_FULL) // limit reached
			if(mapload) // Yea, it's a mapping issue. Blame mappers.
				log_mapping("Closet storage capacity of [type] exceeded on mapload at [AREACOORD(src)]")
			break

/obj/structure/closet/proc/open(mob/living/user)
	if(opened)
		return
	if(user)
		if(!can_open(user))
			return
	playsound(src, open_sound, open_sound_volume, FALSE, -3)
	opened = TRUE
	if(!dense_when_open)
		density = FALSE
	dump_contents()
	update_appearance(UPDATE_ICON_STATE)
	return 1

/obj/structure/closet/proc/insert(atom/movable/inserted, mapload = FALSE)
	if(length(contents) >= storage_capacity)
		if(!mapload)
			return LOCKER_FULL
		//For maploading, we only return LOCKER_FULL if the movable was otherwise insertable. This way we can avoid logging false flags.
		return insertion_allowed(inserted) ? LOCKER_FULL : FALSE
	if(!insertion_allowed(inserted))
		return FALSE
	inserted.forceMove(src)
	return TRUE

/obj/structure/closet/proc/insertion_allowed(atom/movable/AM)
	if(ismob(AM))
		if(!isliving(AM)) //let's not put ghosts or eye mobs inside closets...
			return FALSE
		var/mob/living/L = AM
		if(L.anchored || L.buckled || L.incorporeal_move || L.has_buckled_mobs())
			return FALSE
		if(L.mob_size > MOB_SIZE_TINY) // Tiny mobs are treated as items.
			if(horizontal && L.density)
				return FALSE
			if(L.mob_size > max_mob_size)
				return FALSE
			var/mobs_stored = 0
			for(var/mob/living/M in contents)
				mobs_stored++
				if(mobs_stored >= mob_storage_capacity)
					return FALSE
		L.stop_pulling()

	else if(istype(AM, /obj/structure/closet))
		return FALSE
	else if(isobj(AM))
		if((!allow_dense && AM.density) || AM.anchored || AM.has_buckled_mobs())
			return FALSE
		else if(isitem(AM) && !HAS_TRAIT(AM, TRAIT_NODROP))
			return TRUE
	else
		return FALSE

	return TRUE

/obj/structure/closet/proc/close(mob/living/user)
	if(!opened)
		return FALSE
	if(user)
		if(!can_close(user))
			return FALSE
	take_contents()
	playsound(src, close_sound, close_sound_volume, FALSE, -3)
	opened = FALSE
	density = TRUE
	update_appearance(UPDATE_ICON_STATE)
	return TRUE

/obj/structure/closet/proc/toggle(mob/living/user)
	if(opened)
		return close(user)
	else
		return open(user)

/obj/structure/closet/deconstruct(disassembled = TRUE)
	if(ispath(material_drop) && material_drop_amount && !(flags_1 & NODECONSTRUCT_1))
		new material_drop(loc, material_drop_amount)
	qdel(src)

/obj/structure/closet/atom_break(damage_flag)
	if(!obj_broken && !(flags_1 & NODECONSTRUCT_1))
		bust_open()
	. = ..()

/obj/structure/closet/attackby(obj/item/I, mob/user, list/modifiers)
	if(user in src)
		return TRUE
	if(tool_interact(I, user))
		return TRUE
	return ..()

/obj/structure/closet/proc/tool_interact(obj/item/I, mob/user)//returns TRUE if attackBy call shouldnt be continued (because tool was used/closet was of wrong type), FALSE if otherwise
	. = FALSE
	if(opened)
		if(user.transferItemToLoc(I, drop_location())) // so we put in unlit welder too
			return TRUE

/obj/structure/closet/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!istype(O) || O.anchored || istype(O, /atom/movable/screen))
		return
	if(!istype(user) || user.incapacitated() || user.body_position == LYING_DOWN)
		return
	if(!Adjacent(user) || !user.Adjacent(O))
		return
	if(user == O) //try to climb onto it
		return ..()
	if(!opened)
		return
	if(!isturf(O.loc))
		return

	var/actuallyismob = FALSE
	if(isliving(O))
		actuallyismob = TRUE
	else if(!isitem(O))
		return
	var/turf/T = get_turf(src)
	add_fingerprint(user)
	user.visible_message("<span class='warning'>[user] [actuallyismob ? "tries to ":""]stuff [O] into [src].</span>", \
						"<span class='warning'>I [actuallyismob ? "try to ":""]stuff [O] into [src].</span>", \
						"<span class='hear'>I hear clanging.</span>")
	if(actuallyismob)
		if(do_after(user, 4 SECONDS, O))
			user.visible_message(span_notice("[user] stuffs [O] into [src]."), \
								span_notice("I stuff [O] into [src]."), \
								span_hear("I hear a loud bang."))
			O.forceMove(T)
			close()
	else
		O.forceMove(T)
	return 1

/obj/structure/closet/relaymove(mob/user)
	if(user.stat || !isturf(loc) || !isliving(user))
		return
	if(locked())
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 50
			to_chat(user, "<span class='warning'>I'm trapped!</span>")
		return
	container_resist(user)

/obj/structure/closet/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(user.body_position == LYING_DOWN && get_dist(src, user) > 0)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	toggle(user)

/obj/structure/closet/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/closet/verb/verb_toggleopen()
	set src in view(1)
	set hidden = 1
	set name = "Toggle Open"

	if(!usr.can_perform_action(src, FORBID_TELEKINESIS_REACH) || !isturf(loc))
		return

	if(iscarbon(usr))
		return toggle(usr)
	else
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")

// Objects that try to exit a locker by stepping were doing so successfully,
// and due to an oversight in turf/Enter() were going through walls.  That
// should be independently resolved, but this is also an interesting twist.
/obj/structure/closet/Exit(atom/movable/AM)
	open()
	if(AM.loc == src)
		return 0
	return 1

/obj/structure/closet/container_resist(mob/living/user)
	if(opened)
		return
	if(ismovableatom(loc))
		user.changeNext_move(CLICK_CD_BREAKOUT)
		user.last_special = world.time + CLICK_CD_BREAKOUT
		var/atom/movable/AM = loc
		AM.relay_container_resist(user, src)
		return
	if(!welded && !locked())
		open()
		return

	//okay, so the closet is either welded or locked... resist!!!
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message("<span class='warning'>[src] shakes violently!</span>")

/obj/structure/closet/proc/bust_open()
	welded = FALSE //applies to all lockers
	unlock()
	obj_broken = TRUE //applies to secure lockers only
	open()

/obj/structure/closet/get_remote_view_fullscreens(mob/user)
	if(user.stat == DEAD || !(user.sight & (SEEOBJS|SEEMOBS)))
		user.overlay_fullscreen("remote_view", /atom/movable/screen/fullscreen/impaired, 1)

/obj/structure/closet/contents_explosion(severity, target)
	for(var/atom/A in contents)
		A.ex_act(severity, target)
		CHECK_TICK

/obj/structure/closet/AllowDrop()
	return TRUE

/// Signal proc for [COMSIG_ATOM_MAGICALLY_UNLOCKED]. Unlock and open up when we get knock casted.
/obj/structure/closet/proc/on_magic_unlock(datum/source, datum/action/cooldown/spell/knock, mob/living/caster)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(unlock))
	INVOKE_ASYNC(src, PROC_REF(open))

#undef LOCKER_FULL

/// Proc that searches inside an atom, specifically for sanctified coffins.
/obj/structure/closet/proc/check_double_consecration(obj/structure/closet/dirthole/closed/grave_to_consecrate, mob/user)
	var/double_consecrated = FALSE
	if(!grave_to_consecrate)
		return FALSE
// If the grave contains a sanctified casket, mark the tomb as doubly-sanctified. This will make anyone trying to graverob regret it.
	for(var/obj/structure/closet/crate/coffin/coffin in grave_to_consecrate.contents)
		if (coffin.consecrated)
			double_consecrated = TRUE
	return double_consecrated
