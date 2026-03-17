/datum/action/cooldown/mob_cooldown/voidblast
	name = "void blast"
	desc = "Unleash a barrage of void energies in the targeted direction."
	cooldown_time = 5 SECONDS
	/// How far does our beam go?
	var/beam_range = 10
	/// How long does our beam last?
	var/beam_duration = 2 SECONDS
	/// How long do we wind up before firing?
	var/charge_duration = 1 SECONDS
	/// Overlay we show when we're about to fire
	var/static/image/direction_overlay = image('icons/effects/effects.dmi', "obeliak_telegraph_dir")
	/// A list of all the beam parts.
	var/list/beam_parts = list()

/datum/action/cooldown/mob_cooldown/voidblast/Destroy()
	extinguish_laser()
	return ..()

/datum/action/cooldown/mob_cooldown/voidblast/Activate(atom/target)
	StartCooldown(360 SECONDS)

	owner.face_atom(target)
	owner.move_resist = MOVE_FORCE_VERY_STRONG
	owner.add_overlay(direction_overlay)

	var/fully_charged = do_after(owner, delay = charge_duration, target = owner)
	owner.cut_overlay(direction_overlay)
	if (!fully_charged)
		StartCooldown()
		return TRUE

	if (!fire_laser())
		var/static/list/fail_emotes = list("coughs.", "wheezes.", "belches out a puff of black smoke.")
		owner.manual_emote(pick(fail_emotes))
		StartCooldown()
		return TRUE

	do_after(owner, delay = beam_duration, target = owner)
	extinguish_laser()
	StartCooldown()
	return TRUE

/// Create a laser in the direction we are facing
/datum/action/cooldown/mob_cooldown/voidblast/proc/fire_laser()
	owner.visible_message(span_danger("[src] fires a aberrant beam!"))
	playsound(owner, 'sound/magic/obeliskbeam.ogg', 150, FALSE, 0, 3)
	var/turf/target_turf = get_ranged_target_turf(owner, owner.dir, beam_range)
	var/turf/origin_turf = get_turf(owner)
	var/list/affected_turfs = get_line(origin_turf, target_turf) - origin_turf
	for(var/turf/affected_turf in affected_turfs)
		if(IS_OPAQUE_TURF(affected_turf))
			break
		var/blocked = FALSE
		for(var/obj/potential_block in affected_turf.contents)
			if(potential_block.opacity)
				blocked = TRUE
				break
		if(blocked)
			break
		var/obj/effect/obeliskbeam/new_obeliskbeam = new(affected_turf)
		new_obeliskbeam.dir = owner.dir
		beam_parts += new_obeliskbeam
		new_obeliskbeam.assign_creator(src)
		for(var/mob/living/hit_mob in affected_turf.contents)
			hit_mob.apply_damage(damage = 25, damagetype = BURN)
			to_chat(hit_mob, span_userdanger("You're blasted by [owner]'s brimbeam!"))
		RegisterSignal(new_obeliskbeam, COMSIG_PARENT_QDELETING, PROC_REF(extinguish_laser)) // In case idk a singularity eats it or something
	if(!length(beam_parts))
		return FALSE
	var/atom/last_obeliskbeam = beam_parts[length(beam_parts)]
	last_obeliskbeam.icon_state = "obeliskbeam_end"
	var/atom/first_obeliskbeam = beam_parts[1]
	first_obeliskbeam.icon_state = "obeliskbeam_start"
	return TRUE

/// Get rid of our laser when we are done with it
/datum/action/cooldown/mob_cooldown/voidblast/proc/extinguish_laser()
	if(!length(beam_parts))
		return FALSE
	owner.move_resist = initial(owner.move_resist)
	for(var/obj/effect/obeliskbeam/beam in beam_parts)
		beam.disperse()
	beam_parts = list()
