#define ARC_BOLT_JUMPS 3
#define ARC_BOLT_JUMP_RANGE 4
#define ARC_BOLT_ARC_MULT 0.5

/datum/action/cooldown/spell/projectile/arc_bolt
	button_icon = 'icons/mob/actions/spells/mage_fulgurmancy.dmi'
	name = "Arc Bolt"
	desc = "Fire a precise jolt of lightning that sears a target's struck body part with heavy burn. \
	Toggle firing mode (Shift+G) while active: Chain leaps to up to three foes behind the target, searing the same body part for half as much, \
	Focus only strike one target, and Arc lobs a single weakened bolt over obstacles. \
	The bolt loses power past 5 paces."
	button_icon_state = "shock"
	sound = 'sound/magic/lightning.ogg'

	projectile_type = /obj/projectile/magic/arc_bolt
	cast_range = SPELL_RANGE_PROJECTILE

	spell_cost = 20

	required_form = FORM_LIGHTNING
	required_technique = TECHNIQUE_DESTRUCTION

	invocation = "Fulgur!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 6.5 SECONDS

	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/current_mode = 1
	var/list/modes = list(
		list("name" = "Chain", "tag" = "CHAIN", "proj" = /obj/projectile/magic/arc_bolt, "invocation" = "Fulgur!"),
		list("name" = "Focus", "tag" = "FOCUS", "proj" = /obj/projectile/magic/arc_bolt/single, "invocation" = "Fulgur Singularis!"),
		list("name" = "Arc", "tag" = "ARC", "proj" = /obj/projectile/magic/arc_bolt/single/arc, "invocation" = "Fulgur Arcus!"),
	)

/datum/action/cooldown/spell/projectile/arc_bolt/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/projectile/arc_bolt/proc/apply_mode(index)
	var/list/mode = modes[index]
	projectile_type = mode["proj"]
	invocation = mode["invocation"]
	update_mode_maptext(mode["tag"])

/datum/action/cooldown/spell/projectile/arc_bolt/toggle_arc_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]] mode."))

/datum/action/cooldown/spell/projectile/arc_bolt/proc/update_mode_maptext(tag)
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(tag)
		holder.color = "#00ccff"

/obj/projectile/magic/arc_bolt
	name = "arc bolt"
	tracer_type = /obj/effect/projectile/tracer/wormhole
	impact_type = null
	hitscan = TRUE
	damage = 30
	max_range = 12
	damage_type = BURN
	woundclass = BCLASS_BURN
	nodamage = FALSE
	speed = 0.3
	flag = "fire"
	light_outer_range = 5
	var/arcs = TRUE

/obj/projectile/magic/arc_bolt/single
	name = "focused bolt"
	damage = 30
	arcs = FALSE

/obj/projectile/magic/arc_bolt/single/arc
	name = "arced bolt"
	damage = 20
	arcshot = TRUE


/obj/projectile/magic/arc_bolt/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.can_block_magic())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			if(out_of_effective_range())
				qdel(src)
				return
			L.electrocute_act(1, src, 1, SHOCK_NOSTUN)
			if(arcs)
				arc_to_targets(L)
	else if(isatom(target))
		var/atom/A = target
		A.fire_act()
	qdel(src)

/obj/projectile/magic/arc_bolt/proc/arc_to_targets(mob/living/primary)
	var/turf/origin = fired_from || (firer ? get_turf(firer) : get_turf(primary))
	var/list/already_hit = list(primary)
	if(firer)
		already_hit += firer
	var/arc_damage = round(damage * ARC_BOLT_ARC_MULT)
	var/mob/living/current = primary
	for(var/i in 1 to ARC_BOLT_JUMPS)
		var/mob/living/next = pick_arc_target(current, origin, already_hit)
		if(!next)
			break
		already_hit += next
		current.Beam(next, icon_state = "lightning[rand(1, 12)]", time = 5)
		playsound(get_turf(next), 'sound/magic/lightning.ogg', 40)
		zap_arc_target(next, arc_damage)
		current = next

/obj/projectile/magic/arc_bolt/proc/pick_arc_target(mob/living/from, turf/origin, list/already_hit)
	var/from_dist = origin ? get_dist(origin, from) : 0
	var/mob/living/best
	var/best_dist = ARC_BOLT_JUMP_RANGE + 1
	for(var/mob/living/candidate in view(ARC_BOLT_JUMP_RANGE, from))
		if(candidate in already_hit)
			continue
		if(candidate.stat == DEAD)
			continue
		if(origin && get_dist(origin, candidate) < from_dist)
			continue
		var/candidate_dist = get_dist(from, candidate)
		if(candidate_dist < best_dist)
			best_dist = candidate_dist
			best = candidate
	return best

/obj/projectile/magic/arc_bolt/proc/zap_arc_target(mob/living/L, arc_damage)
	if(L.can_block_magic())
		L.visible_message(span_warning("The arc scatters around [L]!"))
		return
	var/actual_damage = arc_damage
	var/mob/living/carbon/human/caster = firer
	if(istype(caster) && ishuman(L))
		arcyne_strike(caster, L, null, actual_damage, def_zone, BCLASS_BURN, \
			spell_name = "Arc Bolt", damage_type = BURN,\
			skip_animation = TRUE)
	else
		L.electrocute_act(actual_damage, src, 1, SHOCK_NOSTUN)
	L.electrocute_act(0, src, 1, SHOCK_NOSTUN|SHOCK_VISUAL_ONLY)
	if(spell_impact_intensity > SPELL_IMPACT_NONE)
		var/impact_color = spell_impact_color || light_color || "#FFFFFF"
		new /obj/effect/temp_visual/spell_impact(get_turf(L), impact_color, spell_impact_intensity)

#undef ARC_BOLT_JUMPS
#undef ARC_BOLT_JUMP_RANGE
#undef ARC_BOLT_ARC_MULT
