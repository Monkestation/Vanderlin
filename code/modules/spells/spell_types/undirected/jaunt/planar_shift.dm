/datum/action/cooldown/spell/undirected/planar_shift
	name = "Planar Shift"
	desc = "This spell turns your form ethereal, making you invisible and able to pass through walls. Unlike lesser variants, this shift is permanent."
	button_icon_state = "jaunt"
	sound = 'sound/magic/ethereal_enter.ogg'

	cooldown_time = 25 SECONDS

	required_form = null
	invocation_type = INVOCATION_NONE
	spell_flags = SPELL_UNETCHABLE
	charge_required = FALSE
	check_flags = AB_CHECK_CONSCIOUS

	/// Is the transformation active?
	var/shift_active = FALSE
	/// List of valid exit points
	var/list/exit_point_list
	/// The shifted mob
	var/obj/effect/dummy/phased_mob/spell_jaunt/holder_mob
	/// Blood magic?
	var/blood = FALSE


/datum/action/cooldown/spell/undirected/planar_shift/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	var/area/owner_area = get_area(owner)
	var/turf/owner_turf = get_turf(owner)
	if(!owner_area || !owner_turf)
		return FALSE // nullspaced?

	if(owner_area.area_flags & NO_TELEPORT)
		if(feedback)
			to_chat(owner, span_danger("Some dull, universal force is stopping you from shifting here."))
		return FALSE

	if(owner_turf?.turf_flags & NO_JAUNT)
		if(feedback)
			to_chat(owner, span_danger("An otherworldly force is preventing you from shifting here."))
		return FALSE

	return isliving(owner)

/datum/action/cooldown/spell/undirected/planar_shift/before_cast(atom/cast_on)
	return ..() | SPELL_NO_FEEDBACK // Don't do the feedback until after we're shifted

/datum/action/cooldown/spell/undirected/planar_shift/proc/enter_shift(mob/living/cast_on, turf/loc_override)
	var/mob_path = /obj/effect/dummy/phased_mob/spell_jaunt
	var/exit_path = /obj/effect/temp_visual/wizard/out
	if(blood)
		mob_path = /obj/effect/dummy/phased_mob/spell_jaunt/blood
		exit_path = /obj/effect/temp_visual/wizard/blood/out

	holder_mob = new mob_path(loc_override || get_turf(cast_on), cast_on)
	RegisterSignal(holder_mob, COMSIG_MOB_EJECTED_FROM_JAUNT, PROC_REF(on_shift_exit))
	spell_requirements |= SPELL_CASTABLE_WHILE_PHASED
	cast_on.add_traits(list(TRAIT_MAGICALLY_PHASED, TRAIT_RUNECHAT_HIDDEN, TRAIT_WEATHER_IMMUNE), REF(src))
	holder_mob.name = cast_on.name
	SEND_SIGNAL(cast_on, COMSIG_FOV_HIDE)
	// Don't do the feedback until we have runechat hidden.
	// Otherwise the text will follow the shifter, which reveals where they're is travelling.
	spell_feedback()

	// This needs to happen at the end, after all the traits and stuff is handled
	SEND_SIGNAL(cast_on, COMSIG_MOB_ENTER_JAUNT, src, holder_mob)

	var/turf/cast_turf = get_turf(holder_mob)
	new exit_path(cast_turf, cast_on.dir)
	cast_on.ExtinguishMob()
	do_steam_effects(cast_turf)
	return

/datum/action/cooldown/spell/undirected/planar_shift/cast(mob/living/cast_on)
	. = ..()
	if(!shift_active)
		do_shift(cast_on)
		return
	stop_shift(cast_on, get_turf(holder_mob))

/**
 * Begin the shift, and the entire shift chain.
 * Puts cast_on in the phased mob holder here.
 */
/datum/action/cooldown/spell/undirected/planar_shift/proc/do_shift(mob/living/cast_on)
	// Makes sure they don't die or get jostled or something during the shift entry
	// Honestly probably not necessary anymore, but better safe than sorry
	ADD_TRAIT(cast_on, TRAIT_NO_TRANSFORM, "[REF(src)]")
	enter_shift(cast_on)
	REMOVE_TRAIT(cast_on, TRAIT_NO_TRANSFORM, "[REF(src)]")

	if(!holder_mob)
		CRASH("[type] attempted do_shift but failed to create a shift holder_mob via enter_shift.")

	start_shift(cast_on)

/**
 * The actual process of starting the shift.
 * Sets up the signals and exit points and allows
 * the caster to actually start moving around.
 */
/datum/action/cooldown/spell/undirected/planar_shift/proc/start_shift(mob/living/cast_on)
	if(QDELETED(cast_on) || QDELETED(holder_mob) || QDELETED(src))
		return

	LAZYINITLIST(exit_point_list)
	RegisterSignal(holder_mob, COMSIG_MOVABLE_MOVED, PROC_REF(update_exit_point), target)
	shift_active = TRUE

/**
 * The stopping of the shift.
 * Unregisters and signals and places
 * the shifter on the turf they will exit at.
 */
/datum/action/cooldown/spell/undirected/planar_shift/proc/stop_shift(mob/living/cast_on, turf/start_point)
	if(QDELETED(cast_on) || QDELETED(holder_mob) || QDELETED(src))
		return

	UnregisterSignal(holder_mob, COMSIG_MOVABLE_MOVED)
	// The caster escaped our holder_mob somehow?
	if(cast_on.loc != holder_mob)
		qdel(holder_mob)
		return

	// Pick an exit turf to deposit the shifter
	var/turf/found_exit
	for(var/turf/possible_exit as anything in exit_point_list)
		if(possible_exit.is_blocked_turf(TRUE))
			continue
		found_exit = possible_exit
		break

	// No valid exit was found
	if(!found_exit)
		// It's possible no exit was found, because we literally didn't even move
		if(get_turf(cast_on) != start_point)
			to_chat(cast_on, span_danger("Unable to find an unobstructed space, you find yourself ripped back to where you started."))
		// Either way, default to where we started
		found_exit = start_point

	exit_point_list = null
	holder_mob.forceMove(found_exit)
	do_steam_effects(found_exit)
	holder_mob.reappearing = TRUE
	playsound(found_exit, blood ? 'sound/magic/enter_blood.ogg' : 'sound/magic/ethereal_exit.ogg', 50, TRUE)

	ADD_TRAIT(cast_on, TRAIT_IMMOBILIZED, REF(src))
	addtimer(CALLBACK(src, PROC_REF(do_shift_in), cast_on, found_exit), 2 SECONDS)

/**
 * The wind-up (wind-out?) of exiting the shift.
 * Calls end_shift.
 */
/datum/action/cooldown/spell/undirected/planar_shift/proc/do_shift_in(mob/living/cast_on, turf/final_point)
	if(QDELETED(cast_on) || QDELETED(holder_mob) || QDELETED(src))
		return
	var/shift_path = /obj/effect/temp_visual/wizard
	if(blood)
		shift_path = /obj/effect/temp_visual/wizard/blood

	new shift_path(final_point, holder_mob.dir)
	cast_on.setDir(holder_mob.dir)

	addtimer(CALLBACK(src, PROC_REF(end_shift), cast_on, holder_mob, final_point), 0.5 SECONDS)


/**
 * Finally, the actual veritable end of the shift chains.
 * Deletes the phase holder, ejecting the caster at final_point.
 *
 * If the final_point is dense for some reason,
 * tries to put the caster in an adjacent turf.
 */
/datum/action/cooldown/spell/undirected/planar_shift/proc/end_shift(mob/living/cast_on, turf/final_point)
	if(QDELETED(cast_on) || QDELETED(holder_mob) || QDELETED(src))
		return
	ADD_TRAIT(cast_on, TRAIT_NO_TRANSFORM, "[REF(src)]")
	exit_shift(cast_on)
	REMOVE_TRAIT(cast_on, TRAIT_NO_TRANSFORM, "[REF(src)]")

	REMOVE_TRAIT(cast_on, TRAIT_IMMOBILIZED, REF(src))

	if(final_point.density)
		var/list/aside_turfs = get_adjacent_open_turfs(final_point)
		if(length(aside_turfs))
			cast_on.forceMove(pick(aside_turfs))
	shift_active = FALSE
	SEND_SIGNAL(cast_on, COMSIG_FOV_SHOW)
	QDEL_NULL(holder_mob)

/**
 * Updates the exit point of the shift
 *
 * Called when the shifting mob holder moves, this updates the backup exit-shift
 * location, in case the shift ends with the mob still in a wall. Five
 * spots are kept in the list, in case the last few changed since we passed
 * by (doors closing, engineers building walls, etc)
 */
/datum/action/cooldown/spell/undirected/planar_shift/proc/update_exit_point(mob/living/source)
	SIGNAL_HANDLER

	var/turf/location = get_turf(source)
	if(location.is_blocked_turf(TRUE))
		return
	exit_point_list.Insert(1, location)
	if(length(exit_point_list) >= 5)
		exit_point_list.Cut(5)

/// Does some steam effects from the shift at passed loc.
/datum/action/cooldown/spell/undirected/planar_shift/proc/do_steam_effects(turf/loc)
	if(blood)
		var/datum/effect_system/blood_mist_spread/mist = new()
		mist.set_up(10, FALSE, loc)
		mist.start()
		return
	var/datum/effect_system/steam_spread/steam = new()
	steam.set_up(10, FALSE, loc)
	steam.start()

/datum/action/cooldown/spell/undirected/planar_shift/proc/exit_shift(mob/living/shifter, turf/loc_override)
	if(holder_mob.jaunter != shifter)
		CRASH("Planar Shift spell attempted to exit_shift with an invalid shifter, somehow.")

	if(loc_override)
		holder_mob.forceMove(loc_override)
	holder_mob.eject_jaunter()

	return TRUE

/datum/action/cooldown/spell/undirected/planar_shift/proc/on_shift_exit(obj/effect/dummy/phased_mob/shift, mob/living/shifter)
	spell_requirements &= ~SPELL_CASTABLE_WHILE_PHASED
	shifter.remove_traits(list(TRAIT_MAGICALLY_PHASED, TRAIT_RUNECHAT_HIDDEN, TRAIT_WEATHER_IMMUNE), REF(src))
	// This needs to happen at the end, after all the traits and stuff is handled
	SEND_SIGNAL(shifter, COMSIG_MOB_AFTER_EXIT_JAUNT, src)

/datum/action/cooldown/spell/undirected/planar_shift/bloodmagic
	name = "Blood Plane"
	button_icon_state = "watcher"
	sound = 'sound/magic/enter_blood.ogg'
	blood = TRUE
