/datum/action/cooldown/spell/rending_grasp
	button_icon = 'icons/mob/actions/spells/spellfist.dmi'
	button_icon_state = "grasp_of_psydon"
	name = "Rending Grasp"
	desc = "Slam your open palm forward, sending forth tendrils of lightning to a target area up to 4 paces away on the same level. After a brief telegraph, all targets in the area are yanked toward you. \
		At 3+ momentum: consumes 3 to deal 40 blunt damage to the aimed bodypart on each yanked target."
	sound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')

	cast_range = 5

	required_form = FORM_LIGHTNING
	required_technique = TECHNIQUE_IMBUE
	spell_cost = 30

	invocation = "Iqbid!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 0.5 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS

	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/area_of_effect = 1
	var/pull_distance = 7
	var/telegraph_delay = 0.8 SECONDS
	var/base_damage = 15
	var/empowered_damage = 40
	var/momentum_cost = 3

/datum/action/cooldown/spell/rending_grasp/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/T = get_turf(cast_on)
	if(!T)
		return FALSE

	var/turf/caster_turf = get_turf(H)
	if(T.z != caster_turf.z)
		to_chat(H, span_warning("The tendrils can't reach across planes!"))
		return FALSE

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released - empowered grasp!"))

	H.emote("attack", forced = TRUE)

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		if(affected_turf.density)
			continue
		new /obj/effect/temp_visual/grasp_telegraph(affected_turf)

	playsound(T, 'sound/magic/webspin.ogg', 50, TRUE)

	addtimer(CALLBACK(src, PROC_REF(resolve_grasp), H, T, empowered), telegraph_delay)
	return TRUE

/datum/action/cooldown/spell/rending_grasp/proc/resolve_grasp(mob/living/carbon/human/H, turf/center, empowered = FALSE)
	if(QDELETED(H) || H.stat == DEAD)
		return

	var/turf/caster_turf = get_turf(H)
	playsound(center, 'sound/combat/grabbreak.ogg', 80, TRUE)

	var/hit_count = 0
	for(var/mob/living/victim in range(area_of_effect, center))
		if(victim == H || victim.stat == DEAD)
			continue
		if(victim.can_block_magic())
			victim.visible_message(span_warning("The tendrils of force can't seem to latch onto [victim]!"))
			playsound(get_turf(victim), 'sound/magic/magic_nulled.ogg', 100)
			continue
		var/def_zone = H.zone_selected || BODY_ZONE_CHEST
		arcyne_strike(H, victim, null, base_damage, def_zone, BCLASS_BLUNT, spell_name = "Rending Grasp")
		if(empowered)
			arcyne_strike(H, victim, null, empowered_damage, def_zone, BCLASS_BLUNT, spell_name = "Rending Grasp (Empowered)")
		victim.throw_at(caster_turf, pull_distance, 4)

		victim.visible_message(span_warning("[victim] is yanked toward [H] by tendrils of arcyne force!"))
		new /obj/effect/temp_visual/grasp_telegraph/long(get_turf(victim))
		hit_count++

	if(hit_count)
		H.visible_message(span_danger("[H] clenches [H.p_their()] fist, pulling [hit_count > 1 ? "enemies" : "an enemy"] toward [H.p_them()]!"))

	log_combat(H, null, "used Rending Grasp[empowered ? " (empowered)" : ""]")

/obj/effect/temp_visual/grasp_telegraph
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	duration = 1 SECONDS

/obj/effect/temp_visual/grasp_telegraph/long
	duration = 2 SECONDS
