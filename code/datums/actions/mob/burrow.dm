/datum/action/cooldown/spell/burrow
	name = "Burrow"
	desc = "Tunnels forward through the earth until reaching open ground, provided nothing blocks the way."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "spell_default"
	cooldown_time = 5 MINUTES
	spell_type = SPELL_STAMINA
	spell_cost = 50
	charge_required = FALSE

	/// Time spent standing still before the burrow actually starts moving
	var/channel_time = 10 SECONDS
	/// Time to move through one /turf/closed/mineral tile
	var/mineral_move_time = 1 SECONDS
	/// Time to move through any other closed tile
	var/other_move_time = 5 SECONDS
	/// Safety cap on how many tiles ahead we'll scan looking for an opening
	var/max_scan_range = 50

/datum/action/cooldown/spell/burrow/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	if(!istype(caster))
		return

	var/direction = caster.dir
	var/list/turf/path = calculate_path(caster, direction)
	if(!path)
		to_chat(caster, span_warning("You can't burrow that way."))
		return

	caster.visible_message(span_danger("[caster] begins tunneling into the ground!"))

	INVOKE_ASYNC(src, PROC_REF(burrow), path, direction)

/datum/action/cooldown/spell/burrow/proc/burrow(list/path, direction)
	var/mob/living/caster = owner
	if(!do_after(caster, channel_time, caster))
		to_chat(caster, span_warning("Your burrowing is interrupted!"))
		return

	// do_after can succeed even if something grabbed/stunned us right at the
	// tail end of the channel, so double check before we actually commit
	if(is_burrow_interrupted(caster))
		return

	begin_burrow(caster, path, direction)

/// Returns TRUE (and messages the caster) if the caster is in a state that
/// should stop the burrow; grabbed, stunned, buckled, dead, etc.
/datum/action/cooldown/spell/burrow/proc/is_burrow_interrupted(mob/living/caster)
	if(QDELETED(caster))
		return TRUE

	if(caster.pulledby)
		to_chat(caster, span_warning("You're grabbed and can't continue burrowing!"))
		return TRUE

	if(caster.buckled)
		to_chat(caster, span_warning("You're restrained and can't continue burrowing!"))
		return TRUE

	if(caster.incapacitated())
		to_chat(caster, span_warning("You're incapacitated and stop burrowing!"))
		return TRUE

	return FALSE

/datum/action/cooldown/spell/burrow/proc/begin_burrow(mob/living/caster, list/turf/path, direction)
	if(QDELETED(caster) || !length(path))
		return

	if(is_burrow_interrupted(caster))
		return

	playsound(caster, PUNCHWOOSH, 70)
	var/turf/queued_turf = path[1]
	path.Cut(1, 2)

	var/turf/next_turf = QDELETED(queued_turf) ? get_step(get_turf(caster), direction) : queued_turf
	if(!next_turf)
		to_chat(caster, span_warning("The ground gives way beneath you - you're forced to stop!"))
		return

	if(next_turf.turf_flags & NO_JAUNT)
		to_chat(caster, span_warning("Something blocks your tunnel - you're forced to stop!"))
		return

	var/move_time
	var/reached_open = isopenturf(next_turf)
	if(reached_open)
		move_time = 0
	else if(istype(next_turf, /turf/closed/mineral))
		move_time = mineral_move_time
	else
		move_time = other_move_time

	caster.forceMove(next_turf)

	if(reached_open || !length(path))
		caster.visible_message(span_danger("[caster] bursts up out of the ground!"))
		return

	addtimer(CALLBACK(src, PROC_REF(begin_burrow), caster, path, direction), move_time)

/datum/action/cooldown/spell/burrow/proc/calculate_path(mob/living/caster, direction)
	var/turf/current = get_turf(caster)
	var/list/turf/path = list()

	for(var/i in 1 to max_scan_range)
		current = get_step(current, direction)
		if(!current)
			return null

		if(current.type == /turf/closed)
			return null
		if(current.turf_flags & NO_JAUNT)
			return null

		path += current

		if(isopenturf(current))
			return path

	return null // never found an opening within range
