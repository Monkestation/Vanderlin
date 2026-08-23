/datum/action/cooldown/spell/geas
	button_icon = 'icons/mob/actions/spells/mage_geomancy.dmi'
	name = "Geas"
	desc = "Lay a geas upon a small patch of ground - roots of stone and arcyne force bind anyone caught there fast for 3 seconds. Can hit yourself."
	button_icon_state = "ensnare"
	sound = 'sound/magic/webspin.ogg'
	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	spell_cost = 50

	required_form = FORM_EARTH

	invocation = "Terra Teneat!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 25 SECONDS

	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/area_of_effect = 1
	var/hold_duration = 3 SECONDS
	var/delay = 0.8 SECONDS

/datum/action/cooldown/spell/geas/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/T = get_turf(cast_on)
	if(!T)
		return FALSE

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		if(affected_turf.density)
			continue
		new /obj/effect/temp_visual/geas(affected_turf)

	addtimer(CALLBACK(src, PROC_REF(apply_geas), T, H), delay)
	playsound(T, 'sound/magic/webspin.ogg', 50, TRUE)
	return TRUE

/datum/action/cooldown/spell/geas/proc/apply_geas(turf/T, mob/living/caster)
	for(var/mob/living/simple_animal/hostile/animal in range(area_of_effect, T))
		animal.Paralyze(hold_duration, ignore_canstun = TRUE)
	for(var/mob/living/L in range(area_of_effect, T))
		if(L.can_block_magic())
			L.visible_message(span_warning("The binding can't seem to latch onto [L]!"))
			playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
			continue
		L.Immobilize(hold_duration)
		L.OffBalance(hold_duration)
		L.visible_message(span_warning("[L] is bound fast to the earth!"))
		new /obj/effect/temp_visual/geas/long(get_turf(L))

/obj/effect/temp_visual/geas
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	duration = 1 SECONDS

/obj/effect/temp_visual/geas/long
	duration = 3 SECONDS
