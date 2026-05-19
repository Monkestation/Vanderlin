
#define CRESCENDO_FILTER "crescendo_glow"

/// Get the 3x3 grid of turfs in front of the user (3 deep, 3 wide)
/proc/get_frontal_turfs(mob/living/user)
	var/list/turfs = list()
	var/facing = user.dir
	var/left = turn(facing, 90)
	var/right = turn(facing, -90)
	var/turf/center = get_turf(user)
	for(var/i in 1 to 3)
		center = get_step(center, facing)
		if(!center)
			break
		turfs += center
		var/turf/L = get_step(center, left)
		if(L)
			turfs += L
		var/turf/R = get_step(center, right)
		if(R)
			turfs += R
	return turfs

/datum/action/cooldown/spell/crescendo
	name = "Crescendo"
	desc = "Prime your next melee strike to unleash a 3x3 blast based on your last rhythm. Build 3 rhythm procs to unlock.\n\n\
	<b>Resonating:</b> Parry-bypassing brute damage.\n\
	<b>Concussive:</b> Brute damage + knockback.\n\
	<b>Frigid:</b> Applies frost stacks to slow/freezes.\n\
	<b>Regenerating (T2 Bard only):</b> Heal-over-time on hit for your audience."
	button_icon = 'icons/mob/actions/bardsongs.dmi'
	button_icon_state = "crescendo"
	click_to_activate = FALSE
	self_cast_possible = TRUE

	spell_cost = 0
	spell_type = NONE


	charge_required = FALSE
	cooldown_time = 2 SECONDS

	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_HUMAN

	var/datum/rhythm_tracker/tracker = null
	var/primed = FALSE
	var/prime_timer_id = null

/datum/action/cooldown/spell/crescendo/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!tracker)
		return FALSE
	tracker.check_decay()
	if(tracker.greater_stacks < CRESCENDO_STACKS)
		if(feedback)
			to_chat(owner, span_warning("I haven't built enough rhythm yet! ([tracker.greater_stacks]/[CRESCENDO_STACKS])"))
		return FALSE
	if(tracker.last_rhythm_type == RHYTHM_NONE)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/crescendo/cast(atom/cast_on)
	. = ..()
	if(!tracker)
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(!ishuman(H))
		return FALSE

	// Prime the next melee strike
	primed = TRUE
	H.add_filter(CRESCENDO_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_BARDIC, "alpha" = 180, "size" = 2))
	H.visible_message(span_warning("[H]'s weapon surges with building power!"))
	to_chat(H, span_info("I channel my crescendo - strike now!"))
	H.balloon_alert_to_viewers("Crescendo primed!")
	playsound(H, 'sound/magic/charged.ogg', 50, TRUE)

	// Register for the next melee hit
	RegisterSignal(H, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, PROC_REF(on_melee_hit))

	// Window timer - same as rhythm
	prime_timer_id = addtimer(CALLBACK(src, PROC_REF(crescendo_fizzle)), RHYTHM_WINDOW, TIMER_STOPPABLE)
	return TRUE

/// Melee hit while primed - fire the crescendo cone
/datum/action/cooldown/spell/crescendo/proc/on_melee_hit(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(!primed)
		return
	if(!isliving(target) || target == owner || target.stat == DEAD)
		return

	primed = FALSE
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY)
	if(prime_timer_id)
		deltimer(prime_timer_id)
		prime_timer_id = null
	owner.remove_filter(CRESCENDO_FILTER)

	var/mob/living/carbon/human/H = owner
	if(!ishuman(H))
		return

	var/tname = tracker.last_rhythm_type
	H.visible_message(span_danger("[H] unleashes a [tname] Crescendo!"))
	playsound(H, 'sound/magic/antimagic.ogg', 60, TRUE)

	switch(tracker.last_rhythm_type)
		if(RHYTHM_RESONATING)
			crescendo_resonating(H)
		if(RHYTHM_CONCUSSIVE)
			crescendo_concussive(H)
		if(RHYTHM_FRIGID)
			crescendo_frigid(H)
		if(RHYTHM_REGENERATING)
			crescendo_regenerating(H)

	tracker.greater_stacks = 0
	tracker.last_rhythm_type = RHYTHM_NONE
	tracker.update_crescendo_button()

/// Crescendo window expired without hitting
/datum/action/cooldown/spell/crescendo/proc/crescendo_fizzle()
	if(!primed)
		return
	primed = FALSE
	prime_timer_id = null
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY)
	owner.remove_filter(CRESCENDO_FILTER)
	to_chat(owner, span_warning("My crescendo fades before I could strike..."))
	// Stacks are NOT consumed on fizzle - you can try again

/datum/action/cooldown/spell/crescendo/Remove(mob/remove_from)
	if(primed)
		primed = FALSE
		UnregisterSignal(remove_from, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY)
		if(prime_timer_id)
			deltimer(prime_timer_id)
			prime_timer_id = null
		remove_from.remove_filter(CRESCENDO_FILTER)
	. = ..()

// ---- Crescendo Effects (3x3 frontal square) ----

/datum/action/cooldown/spell/crescendo/proc/crescendo_resonating(mob/living/carbon/human/user)
	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	var/list/turfs = get_frontal_turfs(user)
	for(var/turf/T in turfs)
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/mob/living/L in T)
			if(L == user || L.stat == DEAD)
				continue
			var/armor_block = L.run_armor_check(def_zone, "slash", armor_penetration = 0, damage = CRESCENDO_RESONATING_DAMAGE)
			L.apply_damage(CRESCENDO_RESONATING_DAMAGE, BRUTE, def_zone, armor_block, damage_type = BCLASS_CUT)
			var/zone_name = parse_zone(def_zone)
			L.balloon_alert_to_viewers("resonant strike - [zone_name]!")
			L.visible_message(span_danger("A wave of rhythmic force reverberates through [L]!"))

/datum/action/cooldown/spell/crescendo/proc/crescendo_concussive(mob/living/carbon/human/user)
	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	var/list/turfs = get_frontal_turfs(user)
	for(var/turf/T in turfs)
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/mob/living/L in T)
			if(L == user || L.stat == DEAD)
				continue
			if(L.anchored || L.move_resist >= MOVE_FORCE_STRONG)
				continue
			var/armor_block = L.run_armor_check(def_zone, "slash", armor_penetration = 0, damage = CRESCENDO_CONCUSSIVE_DAMAGE)
			L.apply_damage(CRESCENDO_CONCUSSIVE_DAMAGE, BRUTE, def_zone, armor_block, damage_type = BCLASS_BLUNT)
			var/push_dir = get_dir(user, L)
			if(push_dir)
				L.safe_throw_at(get_ranged_target_turf(L, push_dir, 3), 3, 2, user, force = MOVE_FORCE_STRONG)
			L.visible_message(span_danger("[L] is repelled by the concussive blast!"))

/datum/action/cooldown/spell/crescendo/proc/crescendo_frigid(mob/living/carbon/human/user)
	var/list/turfs = get_frontal_turfs(user)
	for(var/turf/T in turfs)
		new /obj/effect/temp_visual/snap_freeze(T)
		for(var/mob/living/L in T)
			if(L == user || L.stat == DEAD)
				continue
			apply_frost_stack(L, 3)
			L.visible_message(span_danger("A wave of frost chills [L] to the bone!"))

/datum/action/cooldown/spell/crescendo/proc/crescendo_regenerating(mob/living/carbon/human/user)
	// Heal-over-time applied to all audience members (no cone - heals allies, not enemies)
	if(!user.inspiration)
		return
	for(var/mob/living/carbon/human/ally in user.inspiration.audience)
		if(ally.stat == DEAD)
			continue
		if(!(ally in hearers(10, user)))
			continue
		ally.apply_status_effect(/datum/status_effect/buff/healing/crescendo_mending)
		new /obj/effect/temp_visual/heal_rogue(get_turf(ally))
		to_chat(ally, span_info("A mending melody washes over me."))

// Crescendo Mending - heal-over-time applied to audience
/datum/status_effect/buff/healing/crescendo_mending
	id = "crescendo_mending"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = CRESCENDO_MENDING_DURATION
	healing_on_tick = CRESCENDO_MENDING_TICK
	outline_colour = GLOW_COLOR_BARDIC

#undef CRESCENDO_FILTER
