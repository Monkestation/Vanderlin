/datum/action/cooldown/spell/telegraphed_strike
	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	invocation_type = INVOCATION_SHOUT
	invocation = "FIX ME!"

	var/damage = 50
	var/strike_damage_type = BRUTE
	var/npc_simple_damage_mult = 1.5
	var/blade_class = BCLASS_CUT
	var/strike_armor_pen = 0
	var/detonate_sound = 'sound/combat/newstuck.ogg'
	var/strike_sound = 'sound/magic/blade_burst.ogg'
	var/windup_time = 8
	var/charging_slowdown = 0
	var/committed_strike = TRUE
	var/interruptible = FALSE
	var/lock_direction = FALSE
	var/redraw_interval = 2
	var/sweep_step = 1
	var/impact_delay = 0
	var/stop_at_dense = TRUE
	var/damage_structures = TRUE
	var/structure_damage = 0
	var/swipe_state = null
	var/vuln_on_hit = 0
	var/immobilize_on_hit = 0
	var/telegraph_type = /obj/effect/temp_visual/trap
	var/requires_weapon = FALSE
	var/weapon_missing_message = "I need a weapon to strike with!"
	var/sweep_hit_count = 0
	var/list/struck_obstacles
	var/list/struck_mobs

/datum/action/cooldown/spell/telegraphed_strike/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(requires_weapon && !get_strike_weapon(H))
		to_chat(H, span_warning(weapon_missing_message))
		return FALSE
	var/strike_duration = windup_time + impact_delay + max(0, length(get_pattern_offsets()) - 1) * sweep_step
	if(committed_strike)
		H.changeNext_move(strike_duration)
		if(interruptible)
			H.apply_status_effect(/datum/status_effect/swingdelay/disrupt, strike_duration + 2, FALSE)
		else
			H.apply_status_effect(/datum/status_effect/swingdelay/penalty/committed, strike_duration + 2, TRUE)
	INVOKE_ASYNC(src, PROC_REF(windup_and_strike), H)
	return TRUE

/datum/action/cooldown/spell/telegraphed_strike/proc/windup_and_strike(mob/living/carbon/human/H)
	var/list/indicator = list()
	var/iterations = max(1, round(windup_time / redraw_interval))
	var/turf/last_turf
	var/last_facing
	var/locked_facing = lock_direction ? get_cardinal(H.dir) : null
	if(locked_facing)
		H.setDir(locked_facing)
		H.tempfixeye = TRUE
	if(charging_slowdown)
		H.add_movespeed_modifier("telegraphed_strike_windup", TRUE, 100, override = TRUE, multiplicative_slowdown = charging_slowdown)
	for(var/i in 1 to iterations)
		if(QDELETED(H) || H.stat != CONSCIOUS || strike_disrupted(H))
			break
		var/facing = locked_facing || get_cardinal(H.dir)
		if(get_turf(H) != last_turf || facing != last_facing)
			last_turf = get_turf(H)
			last_facing = facing
			draw_indicators(H, facing, indicator)
		sleep(redraw_interval)
	if(charging_slowdown && !QDELETED(H))
		H.remove_movespeed_modifier("telegraphed_strike_windup")
	if(locked_facing && !QDELETED(H))
		H.tempfixeye = FALSE
	if(QDELETED(H) || H.stat != CONSCIOUS || strike_disrupted(H))
		clear_indicators(indicator)
		return
	strike(H, locked_facing || get_cardinal(H.dir), indicator)

/datum/action/cooldown/spell/telegraphed_strike/proc/strike_disrupted(mob/living/carbon/human/H)
	if(!interruptible)
		return FALSE
	var/datum/status_effect/swingdelay/disrupt/SW = H.has_status_effect(/datum/status_effect/swingdelay/disrupt)
	return SW && SW.is_disrupted()

/datum/action/cooldown/spell/telegraphed_strike/proc/draw_indicators(mob/living/carbon/human/H, facing, list/indicator)
	draw_offsets(H, facing, indicator, get_pattern_offsets())

/datum/action/cooldown/spell/telegraphed_strike/proc/draw_offsets(mob/living/carbon/human/H, facing, list/indicator, list/offs)
	var/turf/origin = get_turf(H)
	var/list/wanted = list()
	if(origin)
		for(var/list/off in offs)
			var/list/r = rotate_offset(off[1], off[2], facing)
			var/turf/T = locate(origin.x + r[1], origin.y + r[2], origin.z)
			if(!T || T.density)
				continue
			if(stop_at_dense && path_blocked(origin, T))
				continue
			wanted |= T
	for(var/obj/effect/old in indicator.Copy())
		var/turf/ot = get_turf(old)
		if(!QDELETED(old) && (ot in wanted))
			wanted -= ot
		else
			indicator -= old
			qdel(old)
	for(var/turf/T in wanted)
		indicator += new telegraph_type(T)

/datum/action/cooldown/spell/telegraphed_strike/proc/clear_indicators(list/indicator)
	for(var/obj/effect/old in indicator)
		if(!QDELETED(old))
			qdel(old)

/datum/action/cooldown/spell/telegraphed_strike/proc/strike(mob/living/carbon/human/H, facing, list/indicator)
	if(!length(get_pattern_offsets()))
		clear_indicators(indicator)
		return
	if(strike_sound)
		playsound(get_turf(H), strike_sound, 75, TRUE)
	var/atom/movable/visual = do_blade_animation(H, facing)
	INVOKE_ASYNC(src, PROC_REF(execute_hits), H, facing, indicator, visual)

/datum/action/cooldown/spell/telegraphed_strike/proc/execute_hits(mob/living/carbon/human/H, facing, list/indicator, atom/movable/visual)
	var/turf/last_turf = get_turf(H)
	draw_indicators(H, facing, indicator)
	var/elapsed = 0
	while(elapsed < impact_delay)
		if(QDELETED(H) || H.stat != CONSCIOUS)
			clear_indicators(indicator)
			return
		if(get_turf(H) != last_turf)
			last_turf = get_turf(H)
			draw_indicators(H, facing, indicator)
		sleep(redraw_interval)
		elapsed += redraw_interval
	if(!QDELETED(H) && H.stat == CONSCIOUS)
		on_impact(H, facing, visual)
	var/list/bands = get_sweep_bands()
	var/deflected = FALSE
	sweep_hit_count = 0
	struck_obstacles = list()
	struck_mobs = list()
	for(var/b in 1 to length(bands))
		if(QDELETED(H) || H.stat != CONSCIOUS)
			break
		var/turf/origin = get_turf(H)
		for(var/list/off in bands[b])
			var/list/r = rotate_offset(off[1], off[2], facing)
			var/turf/T = origin ? locate(origin.x + r[1], origin.y + r[2], origin.z) : null
			if(!T)
				continue
			if(stop_at_dense)
				var/turf/blocker = path_blocked(origin, T)
				if(blocker)
					if(damage_structures)
						damage_obstacles(blocker)
					continue
			if(damage_structures)
				damage_obstacles(T)
			deflected = hit_turf(H, T, facing, deflected)
			if(swipe_state)
				var/obj/effect/temp_visual/dir_setting/attack_effect/slash = new(T, facing)
				slash.icon_state = swipe_state
		var/list/remaining = list()
		for(var/j in b + 1 to length(bands))
			remaining += bands[j]
		draw_offsets(H, facing, indicator, remaining)
		if(sweep_step > 0 && b < length(bands))
			sleep(sweep_step)
	clear_indicators(indicator)
	on_strike_complete(H, sweep_hit_count, deflected)

/datum/action/cooldown/spell/telegraphed_strike/proc/on_impact(mob/living/carbon/human/H, facing, atom/movable/visual)
	return

/datum/action/cooldown/spell/telegraphed_strike/proc/hit_turf(mob/living/carbon/human/H, turf/T, facing, deflected = FALSE)
	if(QDELETED(H) || QDELETED(T))
		return deflected
	var/obj/item/weapon = get_strike_weapon(H)
	var/dmg = get_strike_damage()
	var/hit_any = FALSE
	for(var/mob/living/L in T.contents)
		if(L == H)
			continue
		if(L in struck_mobs)
			continue
		struck_mobs += L
		if(L.can_block_magic())
			on_antimagic_block(L)
			continue
		hit_any = TRUE
		sweep_hit_count++
		if(ishuman(L))
			var/target_zone = H.zone_selected || BODY_ZONE_CHEST
			arcyne_strike(H, L, weapon, dmg, target_zone, blade_class, armor_penetration = strike_armor_pen, spell_name = name, damage_type = strike_damage_type, npc_simple_damage_mult = npc_simple_damage_mult, skip_animation = TRUE)
		else
			var/actual_damage = dmg
			if(!L.mind)
				actual_damage *= npc_simple_damage_mult
			if(strike_damage_type == BURN)
				L.adjustFireLoss(actual_damage)
			else
				L.adjustBruteLoss(actual_damage)
		if(vuln_on_hit)
			L.apply_status_effect(/datum/status_effect/debuff/vulnerable, vuln_on_hit)
		if(immobilize_on_hit)
			L.apply_status_effect(STATUS_EFFECT_IMMOBILIZED, immobilize_on_hit)
		new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)
		on_hit_target(H, L, facing)
	if(hit_any && detonate_sound)
		playsound(T, detonate_sound, 65, TRUE)
	return deflected

/datum/action/cooldown/spell/telegraphed_strike/proc/path_blocked(turf/origin, turf/target)
	if(!origin || !target || origin == target)
		return null
	for(var/turf/step in getline(origin, target))
		if(step == origin)
			continue
		if(step == target)
			break
		if(step.density)
			return step
		for(var/obj/structure/S in step)
			if(S.density && !S.climbable)
				return step
	return null

/datum/action/cooldown/spell/telegraphed_strike/proc/damage_obstacles(turf/T)
	if(!T || (T in struck_obstacles))
		return
	struck_obstacles += T
	var/dmg = structure_damage ? structure_damage : damage
	var/hit_any = FALSE
	for(var/obj/structure/S in T)
		S.take_damage(dmg, BRUTE, "blunt", TRUE)
		hit_any = TRUE
	if(hit_any)
		new /obj/effect/temp_visual/spell_impact(T, spell_color, spell_impact_intensity)
		if(detonate_sound)
			playsound(T, detonate_sound, 65, TRUE)

/datum/action/cooldown/spell/telegraphed_strike/proc/forward_reach(mob/living/carbon/human/H, facing, max_steps)
	var/reach = 0
	var/turf/current = get_turf(H)
	for(var/i in 1 to max_steps)
		var/turf/next = get_step(current, facing)
		if(!next || next.density)
			break
		current = next
		reach++
		for(var/obj/structure/S in next)
			if(S.density && !S.climbable)
				return reach
	return reach

/datum/action/cooldown/spell/telegraphed_strike/proc/get_strike_weapon(mob/living/carbon/human/H)
	return null

/datum/action/cooldown/spell/telegraphed_strike/proc/get_strike_damage()
	return damage

/datum/action/cooldown/spell/telegraphed_strike/proc/on_hit_target(mob/living/carbon/human/H, mob/living/L, facing)
	return

/datum/action/cooldown/spell/telegraphed_strike/proc/on_strike_complete(mob/living/carbon/human/H, hit_count, deflected)
	return

/datum/action/cooldown/spell/telegraphed_strike/proc/on_antimagic_block(mob/living/L)
	L.visible_message(span_warning("The arcyne blades dispel as they near [L]!"))
	playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)

/datum/action/cooldown/spell/telegraphed_strike/proc/do_blade_animation(mob/living/carbon/human/H, facing)
	return

/datum/action/cooldown/spell/telegraphed_strike/proc/get_pattern_offsets()
	return list()

/datum/action/cooldown/spell/telegraphed_strike/proc/get_sweep_bands()
	var/list/bands = list()
	for(var/list/off in get_pattern_offsets())
		bands += list(list(off))
	return bands

/datum/action/cooldown/spell/telegraphed_strike/proc/get_cardinal(dir)
	if(dir & NORTH)
		return NORTH
	if(dir & SOUTH)
		return SOUTH
	if(dir & EAST)
		return EAST
	if(dir & WEST)
		return WEST
	return NORTH

/datum/action/cooldown/spell/telegraphed_strike/proc/rotate_offset(dx, dy, facing)
	switch(facing)
		if(SOUTH)
			return list(-dx, -dy)
		if(EAST)
			return list(dy, -dx)
		if(WEST)
			return list(-dy, dx)
	return list(dx, dy)

/datum/action/cooldown/spell/telegraphed_strike/proc/facing_position_angle(facing)
	switch(facing)
		if(EAST)
			return 90
		if(SOUTH)
			return 180
		if(WEST)
			return 270
	return 0
