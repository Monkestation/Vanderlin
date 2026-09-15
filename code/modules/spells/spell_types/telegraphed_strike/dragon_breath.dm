/datum/action/cooldown/spell/telegraphed_strike/dragons_breath
	button_icon = 'icons/mob/actions/spells/mage_pyromancy.dmi'
	name = "Dragon's Breath"
	desc = "Let loose a wide cone of flame that erupts forward, burning everything in its path and pushing back anyone it hits. \
	The windup leaves you committed and wide open."
	button_icon_state = "fire_blast"
	sound = 'sound/magic/fireball.ogg'

	required_form = FORM_FIRE
	required_technique = TECHNIQUE_CREATION

	invocation_type = INVOCATION_SHOUT
	invocation = "Exhala, Draco!"

	spell_cost = 60

	cooldown_time = 20 SECONDS

	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	damage = 60
	strike_damage_type = BURN
	blade_class = BCLASS_BURN
	npc_simple_damage_mult = 2
	committed_strike = TRUE
	interruptible = FALSE
	charging_slowdown = CHARGING_SLOWDOWN_SMALL
	windup_time = 1.6 SECONDS
	sweep_step = 0
	strike_sound = 'sound/magic/fireball.ogg'
	detonate_sound = 'sound/misc/explode/incendiary (1).ogg'

	var/cone_range = 4
	var/push_dist = 2

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/proc/cone_rings()
	var/list/rings = list()
	for(var/d in 1 to cone_range)
		var/list/ring = list()
		var/half = max(1, round(d / 2))
		for(var/lat in -half to half)
			ring += list(list(lat, d))
		rings += list(ring)
	return rings

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/get_sweep_bands()
	return list(get_pattern_offsets())

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/get_pattern_offsets()
	var/list/flat = list()
	for(var/list/ring in cone_rings())
		flat += ring
	return flat

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/on_hit_target(mob/living/carbon/human/H, mob/living/L, facing)
	apply_scorch_stack(L, 1)
	var/push_dir = get_dir(H, L)
	if(!push_dir)
		push_dir = facing
	L.safe_throw_at(get_ranged_target_turf(L, push_dir, push_dist), push_dist, 2, H, force = MOVE_FORCE_STRONG)

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/on_impact(mob/living/carbon/human/H, facing, atom/movable/visual)
	var/turf/origin = get_turf(H)
	if(!origin)
		return
	for(var/list/off in get_pattern_offsets())
		var/list/r = rotate_offset(off[1], off[2], facing)
		var/turf/T = locate(origin.x + r[1], origin.y + r[2], origin.z)
		if(!T || T.density)
			continue
		new /obj/effect/temp_visual/dragonfire(T)
		for(var/atom/movable/A in T)
			if(ismob(A))
				continue
			A.fire_act()

/obj/effect/temp_visual/dragonfire
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	layer = GASFIRE_LAYER
	light_outer_range = LIGHT_RANGE_FIRE
	light_color = LIGHT_COLOR_FIRE
	blend_mode = BLEND_ADD
	duration = 8
