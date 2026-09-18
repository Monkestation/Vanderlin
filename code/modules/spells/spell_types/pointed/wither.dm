/datum/action/cooldown/spell/wither
	button_icon = 'icons/mob/actions/spells/mage_hex.dmi'
	name = "Wither"
	desc = "Lash out a delayed line of dark magic, sapping the physical prowess of all in its path.\n\
	The line telegraphs for a moment before striking every tile at once."
	button_icon_state = "wither"
	sound = 'sound/magic/shadowstep_destination.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	spell_cost = 60

	required_form = FORM_DEATH
	required_technique = TECHNIQUE_ALTERATION

	invocation = "Arescentem!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS

	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// Ticks of telegraph before the line strikes.
	var/strike_delay = 4

/datum/action/cooldown/spell/wither/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(!(target_turf in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	var/list/affected_turfs = list()
	for(var/turf/line_turf in getline(source_turf, target_turf))
		if(line_turf == source_turf)
			continue
		if(!(line_turf in get_hear(cast_range, source_turf)))
			continue
		affected_turfs += line_turf
		new /obj/effect/temp_visual/trap/wither_line(line_turf, strike_delay)

	if(!length(affected_turfs))
		return FALSE

	addtimer(CALLBACK(src, PROC_REF(strike_line), affected_turfs), strike_delay)
	return TRUE

/datum/action/cooldown/spell/wither/proc/strike_line(list/turfs)
	for(var/turf/damage_turf as anything in turfs)
		new /obj/effect/temp_visual/wither_strike(damage_turf)
		playsound(damage_turf, 'sound/magic/shadowstep_destination.ogg', 50)
		for(var/mob/living/L in damage_turf.contents)
			if(L.can_block_magic())
				L.visible_message(span_warning("The dark magic fades away around [L]!"))
				playsound(damage_turf, 'sound/magic/magic_nulled.ogg', 100)
				continue
			L.apply_status_effect(/datum/status_effect/debuff/witherd)

/obj/effect/temp_visual/trap/wither_line
	icon = 'icons/effects/effects.dmi'
	icon_state = "curse"
	color = "#800080"
	light_outer_range = 0
	duration = 1 SECONDS
	alpha = 70

/obj/effect/temp_visual/trap/wither_line/Initialize(mapload, duration_override)
	if(duration_override)
		duration = duration_override
	. = ..()

/obj/effect/temp_visual/wither_strike
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	light_outer_range = 2
	light_color = "#800080"
	duration = 1 SECONDS
