/datum/action/cooldown/spell/arcyne_burst
	button_icon = 'icons/mob/actions/spells/mage_telomancy.dmi'
	name = "Arcyne Burst"
	desc = "Mark a nearby area with arcyne force. It swells for a few seconds before bursting, striking everyone across the whole zone with a wave of kinetic force and hurling them outward."
	button_icon_state = "arcyne_burst"
	sound = 'sound/magic/vlightning.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	required_form = FORM_ARCANE
	required_technique = TECHNIQUE_DESTRUCTION

	invocation = "Erumpe!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS

	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/blast_radius = 1
	var/blast_delay = 2 SECONDS
	var/blast_damage = 75
	var/push_dist = 3

/datum/action/cooldown/spell/arcyne_burst/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE

	if(!(center in get_hear(cast_range, get_turf(H))))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	for(var/turf/T in range(blast_radius, center))
		if(T.density)
			continue
		new /obj/effect/temp_visual/pillar_warning/fadein(T, blast_delay)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(arcyne_burst_erupt), center, H, blast_radius, blast_damage, push_dist, src, name), blast_delay)

	return TRUE

/proc/arcyne_burst_erupt(turf/epicenter, mob/living/carbon/human/caster, radius = 1, damage = 50, push_dist = 3, datum/action/cooldown/spell/guard_source, spell_name = "Arcyne Burst")
	if(!epicenter)
		return
	playsound(epicenter, 'sound/magic/repulse.ogg', 90, TRUE, 4)
	for(var/turf/T in range(radius, epicenter))
		if(!(T in get_hear(radius, epicenter)))
			continue
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/obj/structure/S in T)
			S.take_damage(damage, BRUTE, "blunt", FALSE)
		for(var/mob/living/L in T.contents)
			if(L.can_block_magic())
				L.visible_message(span_warning("The arcyne force dissipates around [L]!"))
				playsound(T, 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(istype(caster) && !QDELETED(caster) && ishuman(L))
				arcyne_strike(caster, L, null, damage, caster.zone_selected, \
					BCLASS_BLUNT, spell_name = spell_name, \
					damage_type = BRUTE, npc_simple_damage_mult = 1, \
					skip_animation = TRUE)
			else
				L.adjustBruteLoss(damage * 1.5)
				SEND_SIGNAL(L, COMSIG_ATOM_WAS_ATTACKED, caster, damage)
			var/push_dir = get_dir(epicenter, L) || pick(GLOB.cardinals)
			L.safe_throw_at(get_ranged_target_turf(L, push_dir, push_dist), push_dist, 1, caster, force = MOVE_FORCE_STRONG)
			new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOB.form_colors[FORM_ARCANE], SPELL_IMPACT_MEDIUM)
