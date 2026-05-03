/datum/component/rope
	var/icon = 'icons/effects/beam.dmi'
	var/icon_state = "r_beam"
	var/beam_type = /obj/effect/ebeam
	var/atom/roped
	var/maximum_rope_distance = 3
	var/connect_loc = TRUE
	var/datum/callback/rope_broken_callback
	var/datum/beam/rope_beam
	var/depth = 0

/datum/component/rope/Initialize(atom/roped, \
								icon = 'icons/effects/beam.dmi', \
								icon_state = "r_beam", \
								maximum_rope_distance = 3, \
								connect_loc = TRUE,
								beam_type = /obj/effect/ebeam, \
								datum/callback/rope_broken_callback)
	. = ..()
	if((!isatom(parent) || isarea(parent)) || (!isatom(roped) || isarea(roped)))
		return COMPONENT_INCOMPATIBLE
	src.roped = roped
	src.icon = icon
	src.icon_state = icon_state
	src.maximum_rope_distance = maximum_rope_distance
	src.connect_loc = connect_loc
	src.beam_type = beam_type
	src.rope_broken_callback = rope_broken_callback
	create_beam(parent, roped)
	START_PROCESSING(SSdcs, src)

/datum/component/rope/Destroy(force, silent)
	. = ..()
	roped = null
	rope_beam = null

/datum/component/rope/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(parent_moved))
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(parent_qdeleted))
	RegisterSignal(roped, COMSIG_MOVABLE_MOVED, PROC_REF(roped_moved))
	RegisterSignal(roped, COMSIG_QDELETING, PROC_REF(roped_qdeleted))

/datum/component/rope/UnregisterFromParent()
	. = ..()
	if(!QDELETED(rope_beam))
		UnregisterSignal(rope_beam, COMSIG_QDELETING)
// This ensures that when parent cannot reach roped, the beam is broken
/datum/component/rope/process(delta_time)
	var/atom/beam_origin = rope_beam.origin
	var/atom/beam_target = rope_beam.target
	if(!can_see(beam_origin, beam_target, maximum_rope_distance))
		qdel(rope_beam)
		return PROCESS_KILL

/datum/component/rope/proc/parent_moved(atom/movable/source, oldloc, dir, forced)
	SIGNAL_HANDLER

	// source moved inside something
	var/atom/movable/sourceloc = source.loc
	if(istype(sourceloc))
		if(!connect_loc)
			qdel(rope_beam)
			return
		var/atom/movable/loc_of_loc = sourceloc.loc
		// i'm not dealing with this shit, go fuck yourself if the depth gets too insane dude
		if(istype(loc_of_loc))
			qdel(rope_beam)
			return
		var/beam_target = rope_beam.target
		UnregisterSignal(rope_beam, COMSIG_QDELETING)
		QDEL_NULL(rope_beam)
		create_beam(sourceloc, beam_target)
	else if(rope_beam.origin != source)
		var/beam_target = rope_beam.target
		UnregisterSignal(rope_beam, COMSIG_QDELETING)
		QDEL_NULL(rope_beam)
		create_beam(source, beam_target)

/datum/component/rope/proc/roped_moved(atom/movable/source, oldloc, dir, forced)
	SIGNAL_HANDLER

	// source moved inside something
	var/atom/movable/sourceloc = source.loc
	if(istype(sourceloc))
		if(!connect_loc)
			qdel(rope_beam)
			return
		var/atom/movable/loc_of_loc = sourceloc.loc
		// i'm not dealing with this shit, go fuck yourself if the depth gets too insane dude
		if(istype(loc_of_loc))
			qdel(rope_beam)
			return
		var/beam_origin = rope_beam.origin
		UnregisterSignal(rope_beam, COMSIG_QDELETING)
		QDEL_NULL(rope_beam)
		create_beam(beam_origin, sourceloc)
	else if(rope_beam.target != source)
		var/beam_origin = rope_beam.origin
		UnregisterSignal(rope_beam, COMSIG_QDELETING)
		QDEL_NULL(rope_beam)
		create_beam(beam_origin, source)

/datum/component/rope/proc/parent_qdeleted(atom/source)
	SIGNAL_HANDLER

	qdel(rope_beam)

/datum/component/rope/proc/roped_qdeleted(atom/source)
	SIGNAL_HANDLER

	qdel(rope_beam)

/datum/component/rope/proc/create_beam(atom/beam_owner, atom/beam_target)
	rope_beam = beam_owner.Beam(beam_target, icon_state, icon, INFINITY, maximum_rope_distance, beam_type, connect_loc)
	RegisterSignal(rope_beam, COMSIG_QDELETING, PROC_REF(rope_beam_broken))
	return TRUE

/datum/component/rope/proc/rope_beam_broken(datum/beam/source)
	SIGNAL_HANDLER

	var/datum/callback/broken_callback = rope_broken_callback
	UnregisterSignal(source, COMSIG_QDELETING)
	if(!QDELING(src))
		qdel(src)
	if(broken_callback)
		broken_callback.Invoke()
