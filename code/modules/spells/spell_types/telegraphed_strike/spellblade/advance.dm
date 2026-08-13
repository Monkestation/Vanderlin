/datum/action/cooldown/spell/advance
	name = "Advance!"
	desc = "Leap forward up to 4 tiles, passing through enemies, then stab ahead on landing. \
		At 3+ momentum: consumes 3 to double damage. \
		Strikes your aimed bodypart."
	button_icon = 'icons/mob/actions/spells/spellblade.dmi'
	button_icon_state = "advance"
	sound = 'sound/combat/wooshes/bladed/wooshsmall (1).ogg'

	cast_range = 15

	spell_color = 20

	required_form = FORM_ARCANE
	required_technique = TECHNIQUE_IMBUE

	invocation = null
	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 15 SECONDS

	spell_impact_intensity = SPELL_IMPACT_LOW
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/leap_range = 4
	var/base_damage = 30
	var/empowered_mult = 2
	var/momentum_cost = 3
	var/step_delay = 1

/datum/action/cooldown/spell/advance/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/held_weapon = H.arcyne_get_weapon()
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		return FALSE

	H.say("Procede!", forced = "spell", language = /datum/language/common)

	var/turf/target_turf = get_turf(cast_on)
	var/turf/start = get_turf(H)
	var/facing = get_dir(start, target_turf) || H.dir
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST

	var/turf/first_step = get_step(start, facing)
	if(!first_step || first_step.density)
		to_chat(H, span_warning("There's no room to leap!"))
		return FALSE

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released - empowered advance!"))

	var/damage = empowered ? (base_damage * empowered_mult) : base_damage

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)

	H.visible_message(
		span_warning("[H] lowers [H.p_their()] [held_weapon.name] and leaps forward!"),
		span_notice("I advance!"))
	playsound(start, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 60, TRUE)

	// Leap phase - pass through mobs with jump arc animation
	var/old_pass = H.pass_flags
	var/old_throwing = H.throwing
	H.pass_flags |= PASSMOB
	H.throwing = TRUE
	var/prev_pixel_z = H.pixel_z
	var/prev_transform = H.transform

	animate(H, pixel_z = prev_pixel_z + 18, time = 1, easing = EASE_OUT)

	var/steps_taken = 0
	for(var/i in 1 to leap_range)
		if(H.stat != CONSCIOUS || H.IsParalyzed() || H.IsStun() || QDELETED(H))
			break
		var/turf/next = get_step(get_turf(H), facing)
		if(!next || next.density)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in next.contents)
			if(S.density && !S.climbable)
				blocked = TRUE
				break
		if(blocked)
			break
		if(!step(H, facing))
			break
		steps_taken++

		if(i < leap_range)
			sleep(step_delay)

	// Slam down - fast drop with impact tilt
	var/land_angle = pick(-20, -15, 15, 20)
	animate(H, pixel_z = prev_pixel_z, transform = turn(prev_transform, land_angle), time = 1, easing = EASE_IN)
	animate(transform = prev_transform, time = 2)

	H.pass_flags = old_pass
	H.throwing = old_throwing

	var/turf/landing_turf = get_turf(H)
	if(landing_turf?.zFall(H))
		return TRUE

	if(steps_taken == 0)
		to_chat(H, span_warning("My leap is blocked!"))
		return TRUE

	// Strike phase - stab 1 tile ahead of landing
	var/turf/jab_turf = get_step(get_turf(H), facing)
	if(!jab_turf)
		H.visible_message(span_notice("[H] lands with a thrust at the air."))
		return TRUE

	var/hit_count = 0
	for(var/mob/living/victim in jab_turf)
		if(victim == H || victim.stat == DEAD)
			continue
		arcyne_strike(H, victim, held_weapon, damage, def_zone, BCLASS_STAB, spell_name = "Advance!")
		hit_count++

	if(!hit_count)
		// Also check landing tile for targets standing on top of caster
		var/turf/landing = get_turf(H)
		for(var/mob/living/victim in landing)
			if(victim == H || victim.stat == DEAD)
				continue
			arcyne_strike(H, victim, held_weapon, damage, def_zone, BCLASS_STAB, spell_name = "Advance!")
			hit_count++

	if(!hit_count)
		H.visible_message(span_notice("[H] lands with a thrust at the air."))
	else
		H.visible_message(span_danger("[H] lands and drives [H.p_their()] [held_weapon.name] forward!"))

	log_combat(H, null, "used Advance! ([hit_count] hits)")
	return TRUE
