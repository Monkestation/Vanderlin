/datum/action/cooldown/spell/essence/momentum_transfer
	name = "Momentum Transfer"
	desc = "Transfers kinetic energy between objects or creatures."
	button_icon_state = "longstrider"
	cast_range = 2
	point_cost = 6
	has_visual_effects = FALSE
	cooldown_time = 2 MINUTES
	attunements = list(/datum/attunement/light, /datum/attunement/aeromancy)
	essences = list(/datum/thaumaturgical_essence/energia, /datum/thaumaturgical_essence/motion)

/datum/action/cooldown/spell/essence/momentum_transfer/cast(atom/cast_on)
	. = ..()
	var/atom/target = cast_on
	if(!target)
		return FALSE
	owner.visible_message(span_notice("[owner] transfers momentum to [target]."))

	if(ismob(target))
		var/mob/living/M = target
		M.apply_status_effect(/datum/status_effect/buff/momentum_boost, 30 SECONDS)
		new /obj/effect/temp_visual/snake/swarm(null, M)

/atom/movable/screen/alert/status_effect/momentum_boost
	name = "Momentum Boost"
	desc = "Kinetic energy surges through you."
	icon_state = "buff"

/datum/status_effect/buff/momentum_boost
	id = "momentum_boost"
	alert_type = /atom/movable/screen/alert/status_effect/momentum_boost
	duration = 30 SECONDS
	/// Tiles moved while the buff is active
	var/tiles_moved = 0
	var/tier_threshold = 10
	var/max_tiers = 5
	var/static/mutable_appearance/guided = mutable_appearance('icons/effects/effects.dmi', "static")

/datum/status_effect/buff/momentum_boost/on_apply()
	. = ..()
	guided.alpha = 80
	owner.add_overlay(guided)
	owner.add_movespeed_modifier(MOVESPEED_ID_STATUS_EFFECT(id), multiplicative_slowdown = -0.4)
	ADD_TRAIT(owner, TRAIT_PUSHIMMUNE, TRAIT_STATUS_EFFECT(id))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	to_chat(owner, span_notice("Kinetic energy surges through you!"))

/datum/status_effect/buff/momentum_boost/on_remove()
	. = ..()
	owner.cut_overlay(guided)
	owner.remove_movespeed_modifier(MOVESPEED_ID_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_PUSHIMMUNE, TRAIT_STATUS_EFFECT(id))
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	discharge()

/datum/status_effect/buff/momentum_boost/proc/on_moved(datum/source, turf/old_turf, turf/new_turf, ...)
	SIGNAL_HANDLER

	if(!old_turf || !new_turf)
		return
	if(old_turf.z != new_turf.z)
		return
	if(get_dist(old_turf, new_turf) > 1)
		return
	tiles_moved++

/datum/status_effect/buff/momentum_boost/proc/discharge()
	var/tiers = min(tiles_moved / tier_threshold, max_tiers)
	if(tiers < 1)
		return // didn't move enough to matter

	var/turf/epicenter = get_turf(owner)
	if(!epicenter)
		return

	// Radius and throw force both scale with tiers
	var/radius = tiers
	var/throw_range = tiers * 2
	var/throw_speed = 3

	new /obj/effect/temp_visual/snake/swarm(null, owner)
	owner.visible_message(span_danger("[owner] releases a tier [tiers] kinetic shockwave!"))

	for(var/atom/movable/AM in range(radius, epicenter))
		if(AM == owner)
			continue
		if(AM.anchored)
			continue
		var/push_dir = get_dir(epicenter, get_turf(AM))
		if(!push_dir)
			push_dir = pick(NORTH, SOUTH, EAST, WEST)
		var/turf/throw_target = get_ranged_target_turf(AM, push_dir, throw_range)
		if(ismob(AM))
			var/mob/M = AM
			if(M.stat == DEAD)
				continue
			M.throw_at(throw_target, throw_range, throw_speed)
			to_chat(M, span_danger("You are hurled by a kinetic shockwave!"))
		else
			AM.throw_at(throw_target, throw_range, throw_speed)
