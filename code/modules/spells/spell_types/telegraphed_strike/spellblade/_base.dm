/datum/action/cooldown/spell/telegraphed_strike/spellblade
	abstract_type = /datum/action/cooldown/spell/telegraphed_strike/spellblade
	button_icon = 'icons/mob/actions/spells/spellblade.dmi'
	sound = 'sound/combat/ground_smash1.ogg'

	spell_cost = 10
	cooldown_time = 12 SECONDS

	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	requires_weapon = TRUE
	weapon_missing_message = "I need my bound weapon in hand!"
	telegraph_type = /obj/effect/temp_visual/trap/arcyne
	blade_class = BCLASS_BLUNT
	strike_sound = null
	committed_strike = FALSE

	required_form = FORM_ARCANE
	required_technique = TECHNIQUE_IMBUE

	var/momentum_cost = 3
	var/empowered_mult = 2
	var/blunt_penalty = 5
	var/momentum_on_hit = 0
	var/momentum_on_surge = 1
	var/push_dist = 0
	var/empowered = FALSE

/datum/action/cooldown/spell/telegraphed_strike/spellblade/get_strike_weapon(mob/living/carbon/human/H)
	return H.arcyne_get_weapon()

/datum/action/cooldown/spell/telegraphed_strike/spellblade/get_strike_damage()
	var/dmg = damage
	if(blade_class == BCLASS_BLUNT)
		dmg = max(0, dmg - blunt_penalty)
	return empowered ? dmg * empowered_mult : dmg

/datum/action/cooldown/spell/telegraphed_strike/spellblade/cast(atom/cast_on)
	empowered = FALSE
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = owner
	var/datum/intent/active = H.a_intent
	if(active && (active.blade_class == BCLASS_BLUNT || active.blade_class == BCLASS_SMASH))
		blade_class = BCLASS_BLUNT
	else
		blade_class = BCLASS_CUT
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released - empowered strike!"))

/datum/action/cooldown/spell/telegraphed_strike/spellblade/on_antimagic_block(mob/living/L)
	L.visible_message(span_warning("The arcyne force scatters as it nears [L]!"))
	playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)

/datum/action/cooldown/spell/telegraphed_strike/spellblade/on_hit_target(mob/living/carbon/human/H, mob/living/L, facing)
	if(!push_dist)
		return
	var/push_dir = get_dir(H, L) || facing || pick(GLOB.cardinals)
	L.safe_throw_at(get_ranged_target_turf(L, push_dir, push_dist), push_dist, 1, H, force = MOVE_FORCE_STRONG)

/datum/action/cooldown/spell/telegraphed_strike/spellblade/on_strike_complete(mob/living/carbon/human/H, hit_count, deflected)
	if(!hit_count)
		return
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M)
		return
	if(momentum_on_hit)
		M.add_stacks(momentum_on_hit)
	if(hit_count >= 2 && momentum_on_surge)
		M.add_stacks(momentum_on_surge)
		to_chat(H, span_notice("DOUBLE STRIKE! ARCYNE SURGE!"))

/datum/action/cooldown/spell/telegraphed_strike/spellblade/on_impact(mob/living/carbon/human/H, facing, atom/movable/visual)
	var/turf/center = get_turf(H)
	if(!center)
		return
	var/list/tiles = list()
	for(var/list/off in get_pattern_offsets())
		var/list/r = rotate_offset(off[1], off[2], facing)
		var/turf/T = locate(center.x + r[1], center.y + r[2], center.z)
		if(T && !path_blocked(center, T))
			tiles += T
	play_impact(center, facing, tiles)

/datum/action/cooldown/spell/telegraphed_strike/spellblade/proc/play_impact(turf/center, facing, list/tiles)
	if(blade_class == BCLASS_BLUNT)
		playsound(center, pick('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg'), 90, TRUE, 3)
		playsound(center, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 60, TRUE)
		for(var/mob/shaken in range(4, center))
			shake_camera(shaken, 1, 1)
		for(var/turf/T in tiles)
			new /obj/effect/temp_visual/kinetic_blast(T)
	else
		playsound(center, pick('sound/combat/hits/bladed/largeslash (1).ogg', 'sound/combat/hits/bladed/largeslash (2).ogg', 'sound/combat/hits/bladed/largeslash (3).ogg'), 90, TRUE, 3)
		for(var/turf/T in tiles)
			var/obj/effect/temp_visual/blade_cut/V = new(T)
			V.dir = get_dir(center, T) || facing

/obj/effect/temp_visual/trap/arcyne
	color = "#9932CC"
	light_color = "#9932CC"
	duration = 3 SECONDS

/obj/effect/temp_visual/blade_cut
	icon = 'icons/effects/effects.dmi'
	icon_state = "cut"
	dir = NORTH
	name = "arcyne slash"
	randomdir = FALSE
	duration = 1 SECONDS
