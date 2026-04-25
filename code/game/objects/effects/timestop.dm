/obj/effect/timestop //Ported from Monkestation 2.0 (https://github.com/Monkestation/Monkestation2.0)
	anchored = TRUE
	name = "chronofield"
	desc = "A field where all time seems frozen..."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "time"
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	pixel_x = -64
	pixel_y = -64
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 125
	/// The one who creates the timestop is immune, or if they have `TRAIT_TIME_STOP_IMMUNE`
	var/list/immune = list()
	/// Center turf where timestop will expand from
	var/turf/target
	/// How wide the area of effect will be from `target`
	/// Default is 2 tiles away from `target` (5x5)
	var/freezerange = 2
	/// How long the effect will last
	var/duration = 14 SECONDS
	var/datum/proximity_monitor/advanced/timestop/chronofield
	/// If person in range is resistant to specified Magic, added to `immune`
	/// Should be set to what the magick source of the effect is
	var/antimagic_flags = MAGIC_RESISTANCE
	/// If `TRUE`, immune atoms moving ends the timestop instead of duration.
	var/channelled = FALSE
	/// Hides time icon effect and mutes sound
	var/hidden = FALSE

/obj/effect/timestop/Initialize(mapload, radius, time, list/immune_atoms, magic_source, start = TRUE, silent = FALSE)
	. = ..()
	if(!isnull(time))
		duration = time
	if(!isnull(radius))
		freezerange = radius
	if(silent)
		hidden = TRUE
		alpha = 0
	if(magic_source)
		antimagic_flags = magic_source
	for(var/A in immune_atoms)
		immune[A] = TRUE
	for(var/mob/living/to_check in GLOB.player_list)
		if(HAS_TRAIT(to_check, TRAIT_TIME_STOP_IMMUNE))
			immune[to_check] = TRUE
	if(start)
		INVOKE_ASYNC(src, PROC_REF(timestop))

/obj/effect/timestop/Destroy()
	QDEL_NULL(chronofield)
	if(!hidden)
		playsound(src, 'sound/magic/timeparadox2.ogg', 75, TRUE, frequency = -1) //reverse!
	return ..()

/obj/effect/timestop/proc/timestop()
	target = get_turf(src)
	if(!hidden)
		playsound(src, 'sound/magic/timeparadox2.ogg', 75, TRUE, -1)
	chronofield = new (src, freezerange, TRUE, immune, antimagic_flags, channelled)
	if(!channelled)
		QDEL_IN(src, duration)

/// Indefinite version, but only if no immune atoms move.
/obj/effect/timestop/channelled
	channelled = TRUE

/datum/proximity_monitor/advanced/timestop
	edge_is_a_field = TRUE
	var/list/immune = list()
	var/list/frozen_things = list()
	/// Cached separately for processing
	var/list/frozen_mobs = list()
	/// Also machinery, and only frozen aestethically
	var/list/frozen_structures = list()
	/// Only aesthetically
	var/list/frozen_turfs = list()
	var/antimagic_flags = NONE
	/// If `TRUE`, this doesn't time out after a duration but rather when an immune atom inside moves.
	var/channelled = FALSE

	var/static/list/global_frozen_atoms = list()

/datum/proximity_monitor/advanced/timestop/New(atom/_host, range, _ignore_if_not_on_turf = TRUE, list/immune, antimagic_flags, channelled)
	..()
	src.immune = immune
	src.antimagic_flags = antimagic_flags
	src.channelled = channelled
	recalculate_field(full_recalc = TRUE)
	START_PROCESSING(SSfastprocess, src)

/datum/proximity_monitor/advanced/timestop/Destroy()
	unfreeze_all()
	if(channelled)
		for(var/atom in immune)
			UnregisterSignal(atom, COMSIG_MOVABLE_MOVED)
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/datum/proximity_monitor/advanced/timestop/field_turf_crossed(atom/movable/movable, turf/old_location, turf/new_location)
	freeze_atom(movable)

/// Proc that runs checks to determine which version of freezing we will do
/datum/proximity_monitor/advanced/timestop/proc/freeze_atom(atom/movable/A)
	if(global_frozen_atoms[A] || !istype(A))
		return FALSE
	if(immune[A]) //a little special logic but yes immune things don't freeze
		if(channelled)
			RegisterSignal(A, COMSIG_MOVABLE_MOVED, PROC_REF(atom_broke_channel), override = TRUE)
		return FALSE
	if(ismob(A))
		var/mob/M = A
		if(M.can_block_magic(antimagic_flags))
			immune[A] = TRUE
			return
	var/frozen = TRUE
	if(isliving(A))
		freeze_mob(A)
	else if(isprojectile(A))
		freeze_projectile(A)
	else if((ismachinery(A) && !istype(A, /obj/machinery/light)) || isstructure(A)) //Special exception for light fixtures since recoloring causes them to change light
		freeze_structure(A)
	else
		frozen = FALSE
	if(A.throwing)
		freeze_throwing(A)
		frozen = TRUE
	if(!frozen)
		return

	frozen_things[A] = A.move_resist
	A.move_resist = INFINITY
	global_frozen_atoms[A] = src
	into_the_negative_zone(A)
	RegisterSignal(A, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(unfreeze_atom))
	RegisterSignal(A, COMSIG_ITEM_PICKUP, PROC_REF(unfreeze_atom))

	return TRUE

/datum/proximity_monitor/advanced/timestop/proc/unfreeze_all()
	for(var/i in frozen_things)
		unfreeze_atom(i)
	for(var/T in frozen_turfs)
		unfreeze_turf(T)

/datum/proximity_monitor/advanced/timestop/proc/unfreeze_atom(atom/movable/A)
	SIGNAL_HANDLER
	if(A.throwing)
		unfreeze_throwing(A)
	if(isliving(A))
		unfreeze_mob(A)
	else if(isprojectile(A))
		unfreeze_projectile(A)

	UnregisterSignal(A, COMSIG_MOVABLE_PRE_MOVE)
	UnregisterSignal(A, COMSIG_ITEM_PICKUP)

	escape_the_negative_zone(A)
	A.move_resist = frozen_things[A]
	frozen_things -= A
	global_frozen_atoms -= A


/datum/proximity_monitor/advanced/timestop/proc/freeze_throwing(atom/movable/AM)
	var/datum/thrownthing/T = AM.throwing
	T.paused = TRUE

/datum/proximity_monitor/advanced/timestop/proc/unfreeze_throwing(atom/movable/AM)
	var/datum/thrownthing/T = AM.throwing
	if(T)
		T.paused = FALSE

/datum/proximity_monitor/advanced/timestop/proc/freeze_turf(turf/T)
	into_the_negative_zone(T)
	frozen_turfs += T

/datum/proximity_monitor/advanced/timestop/proc/unfreeze_turf(turf/T)
	escape_the_negative_zone(T)

/datum/proximity_monitor/advanced/timestop/proc/freeze_structure(obj/O)
	into_the_negative_zone(O)
	frozen_structures += O

/datum/proximity_monitor/advanced/timestop/proc/unfreeze_structure(obj/O)
	escape_the_negative_zone(O)

/datum/proximity_monitor/advanced/timestop/process()
	for(var/mob/living/frozen_mob as anything in frozen_mobs)
		frozen_mob.apply_status_effect(/datum/status_effect/time_stopped)

/datum/proximity_monitor/advanced/timestop/setup_field_turf(turf/target)
	. = ..()
	for(var/i in target.contents)
		freeze_atom(i)
	freeze_turf(target)

/// Proc that forces the projectile to not move while effect active
/datum/proximity_monitor/advanced/timestop/proc/freeze_projectile(obj/projectile/proj)
	proj.paused = TRUE

/// Undoes `freeze_protectile()` for affected projectiles.
/datum/proximity_monitor/advanced/timestop/proc/unfreeze_projectile(obj/projectile/proj)
	proj.paused = FALSE

/datum/proximity_monitor/advanced/timestop/proc/freeze_mob(mob/living/victim)
	frozen_mobs += victim
	victim.apply_status_effect(/datum/status_effect/time_stopped)
	SSmove_manager.stop_looping(victim) //stops them mid pathing even if they're stunimmune //This is really dumb

/datum/proximity_monitor/advanced/timestop/proc/unfreeze_mob(mob/living/victim)
	victim.remove_status_effect(/datum/status_effect/time_stopped)
	frozen_mobs -= victim

/// Modified color palate of atom to be negative
/datum/proximity_monitor/advanced/timestop/proc/into_the_negative_zone(atom/A)
	A.add_atom_colour(list(-1,0,0,0, 0,-1,0,0, 0,0,-1,0, 0,0,0,1, 1,1,1,0), TEMPORARY_COLOUR_PRIORITY)

/// Reverts color palate change of atom caused by `into_the_negative_zone()`
/datum/proximity_monitor/advanced/timestop/proc/escape_the_negative_zone(atom/A)
	A.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)

/// Signal fired when an immune atom moves in the time freeze zone
/datum/proximity_monitor/advanced/timestop/proc/atom_broke_channel(datum/source)
	SIGNAL_HANDLER
	qdel(host)

/datum/status_effect/time_stopped
	id = "time_stopped"
	duration = 2 SECONDS // will get refreshed whenever the timestop processes
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_REFRESH
	processing_speed = STATUS_EFFECT_NORMAL_PROCESS
	alert_type = null
	var/static/list/timestop_traits = list(
		TRAIT_MUTE,
		TRAIT_EMOTEMUTE,
		TRAIT_INCAPACITATED,
		TRAIT_IMMOBILIZED,
		TRAIT_HANDS_BLOCKED,
	)

/datum/status_effect/time_stopped/on_apply()
	. = ..()
	owner.add_traits(timestop_traits, TRAIT_STATUS_EFFECT(id))
	return TRUE

/datum/status_effect/time_stopped/on_remove()
	. = ..()
	owner.remove_traits(timestop_traits, TRAIT_STATUS_EFFECT(id))
