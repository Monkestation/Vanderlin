GLOBAL_LIST_INIT(unlinked_dungeon_entries, list())
GLOBAL_LIST_INIT(dungeon_entries, list())
GLOBAL_LIST_INIT(dungeon_exits, list())

/obj/structure/dungeon_entry/center
	dungeon_id = "center"

/obj/structure/dungeon_entry/center/vanderlin

/obj/structure/dungeon_entry
	name = "The Tomb of Matthios"
	desc = ""

	icon = 'icons/roguetown/misc/portal.dmi'
	icon_state = "portal"
	density = TRUE
	anchored = TRUE
	SET_BASE_PIXEL(-48, 0)
	bound_width = 128
	appearance_flags = NONE
	opacity = TRUE
	resistance_flags = INDESTRUCTIBLE

	var/dungeon_id
	var/list/dungeon_exits = list()
	var/can_enter = TRUE
	/// Requirements for entry/exit
	/// "Time" = "dat" etc
	var/list/entry_requirements = list()
	/// Make the requirements not inclusive
	var/requires_all = FALSE


/obj/structure/dungeon_entry/New(loc, ...)
	GLOB.dungeon_entries |= src
	if(!dungeon_id)
		GLOB.unlinked_dungeon_entries |= src
	return ..()

/obj/structure/dungeon_entry/Initialize()
	. = ..()
	if(dungeon_id)
		for(var/obj/structure/dungeon_exit/exit as anything in GLOB.dungeon_exits)
			if(exit.dungeon_id != dungeon_id)
				continue
			dungeon_exits |= exit
			exit.entry = src
			GLOB.unlinked_dungeon_entries -= src
		return
	shuffle_inplace(GLOB.dungeon_exits)
	for(var/obj/structure/dungeon_exit/exit as anything in GLOB.dungeon_exits)
		if(exit.dungeon_id)
			continue
		dungeon_exits |= exit
		exit.entry = src
		GLOB.unlinked_dungeon_entries -= src
		break

/obj/structure/dungeon_entry/Destroy()
	for(var/obj/structure/dungeon_exit/exit as anything in dungeon_exits)
		exit.entry = null
	dungeon_exits = null
	GLOB.dungeon_entries -= src
	GLOB.unlinked_dungeon_entries -= src

	return ..()

/obj/structure/dungeon_entry/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	use(user)

/obj/structure/dungeon_entry/attackby(obj/item/W, mob/user, list/modifiers)
	return use(user)

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/structure/dungeon_entry/attack_ghost(mob/dead/observer/user)
	use(user, TRUE)
	return ..()

/obj/structure/dungeon_entry/proc/attempt_entry(mob/user, is_ghost)
	if(!is_ghost && !can_enter)
		return FALSE
	if(entry_requirements && !is_ghost)
		if(!has_requirements(user))
			return FALSE
	return TRUE

/obj/structure/dungeon_entry/proc/has_requirements(mob/user)
	var/requirements_met = 0
	if(!requires_all && requirements_met > 0)
		return TRUE
	if(requirements_met < length(entry_requirements))
		return FALSE
	return TRUE

/obj/structure/dungeon_entry/proc/use(mob/user, is_ghost)
	if(!attempt_entry(user, is_ghost))
		return
	if(!length(dungeon_exits))
		return
	var/atom/exit = pick(dungeon_exits)

	if(!is_ghost)
		playsound(src, 'sound/foley/ladder.ogg', 100, FALSE)
		if(!do_after(user, 3 SECONDS, src))
			return
	movable_travel_z_level(user, get_turf(exit))

/obj/structure/dungeon_exit
	name = "dungeon exit"
	desc = ""

	obj_flags = INDESTRUCTIBLE

	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "ladder10"

	var/dungeon_id
	var/obj/structure/dungeon_entry/entry
	var/list/entry_requirements = list()
	var/requires_all = FALSE

	var/delve_level

/obj/structure/dungeon_exit/Initialize()
	. = ..()
	GLOB.dungeon_exits |= src

	if(dungeon_id)
		for(var/obj/structure/dungeon_entry/exit as anything in GLOB.dungeon_entries)
			if(exit.dungeon_id != dungeon_id)
				continue
			exit.dungeon_exits |= src
			entry = exit
			GLOB.unlinked_dungeon_entries -= exit
		return
	shuffle_inplace(GLOB.unlinked_dungeon_entries)
	for(var/obj/structure/dungeon_entry/exit as anything in GLOB.unlinked_dungeon_entries)
		if(exit.dungeon_id)
			continue
		exit.dungeon_exits |= src
		entry = exit
		GLOB.unlinked_dungeon_entries -= exit
		break

/obj/structure/dungeon_exit/Destroy()
	for(var/obj/structure/dungeon_entry/listed as anything in GLOB.dungeon_entries)
		listed.dungeon_exits -= src

	entry = null
	GLOB.dungeon_exits -= src
	return ..()

/obj/structure/dungeon_exit/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	use(user)

/obj/structure/dungeon_exit/attackby(obj/item/W, mob/user, list/modifiers)
	return use(user)

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/structure/dungeon_exit/attack_ghost(mob/dead/observer/user)
	use(user, TRUE)
	return ..()

/obj/structure/dungeon_exit/proc/use(mob/user, is_ghost)
	if(!attempt_entry(user, is_ghost))
		return
	if(!is_ghost)
		playsound(src, 'sound/foley/ladder.ogg', 100, FALSE)
		if(!do_after(user, 3 SECONDS, src))
			return
	movable_travel_z_level(user, get_turf(entry))

/*
	suggest making this proc shared beftween the two, or a refatoring that makes that work
	instead of repeating code that is
*/
/obj/structure/dungeon_exit/proc/attempt_entry(mob/user, is_ghost)
	if(!is_ghost && !entry)
		return FALSE
	if(entry_requirements && !is_ghost)
		if(!has_requirements(user))
			return FALSE
	return TRUE

/obj/structure/dungeon_exit/proc/has_requirements(mob/user)
	var/requirements_met = 0
	if(!requires_all && requirements_met > 0)
		return TRUE
	if(requirements_met < length(entry_requirements))
		return FALSE
	return TRUE
