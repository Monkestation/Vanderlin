/datum/action/cooldown/spell/cataclysm
	name = "Cataclysm"
	desc = "Let the mountain fall. Conjure a hammer of pure earthen force and hurl it at a target area. \
		On impact it explodes, crushing everyone in a 5x5 area for 75 blunt damage and leaving them Vulnerable. \
		Requires 7 momentum. Overcharged at 10 momentum: 135 damage. \
		Same level only."
	button_icon = 'icons/mob/actions/spells/spellblade.dmi'
	button_icon_state = "cataclysm"
	sound = 'sound/combat/ground_smash1.ogg'
	cast_range = 7

	spell_cost = 60
	required_form = FORM_EARTH
	required_technique = TECHNIQUE_IMBUE

	invocation = null
	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_slowdown = 1
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/delay = 10
	var/damage = 75
	var/bonus_damage = 60
	var/area_of_effect = 2
	var/min_momentum = 7
	var/empowered_momentum = 10
	var/vulnerable_duration = 6 SECONDS

/datum/action/cooldown/spell/cataclysm/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/cataclysm/cast(atom/cast_on)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/held_weapon = H.arcyne_get_weapon()
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		return FALSE

	var/turf/T = get_turf(cast_on)
	var/turf/start = get_turf(H)

	if(!T)
		to_chat(H, span_warning("Invalid target!"))
		return FALSE

	if(T.density)
		to_chat(H, span_warning("I cannot hurl a hammer into solid ground!"))
		return FALSE

	if(T.z != start.z)
		to_chat(H, span_warning("Too far - I need to be on the same level!"))
		return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		to_chat(H, span_warning("Not enough momentum! I need at least [min_momentum] stacks!"))
		return FALSE

	var/stacks = M.stacks
	var/empowered = stacks >= empowered_momentum
	var/final_damage = damage + (empowered ? bonus_damage : 0)
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST
	M.consume_all_stacks()
	to_chat(H, span_notice("All [stacks] momentum released - cataclysm [empowered ? "fully empowered" : "unleashed"]!"))

	H.say("RUINA CAELI!", forced = "spell", language = /datum/language/common)

	playsound(start, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 100, TRUE)
	H.visible_message(span_boldwarning("[H] conjures a massive hammer out of arcyne force!"))

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		new /obj/effect/temp_visual/blade_storm_telegraph(affected_turf)

	log_combat(H, cast_on, "used Cataclysm on")

	addtimer(CALLBACK(src, PROC_REF(do_hammer_throw), H, held_weapon, T, final_damage, def_zone, empowered), delay)
	. = ..()

/datum/action/cooldown/spell/cataclysm/proc/do_hammer_throw(mob/living/carbon/human/user, obj/item/weapon, turf/dest, final_damage, def_zone, empowered)
	if(QDELETED(user) || user.stat == DEAD)
		return

	user.visible_message(span_warning("[user] hurls the hammer, aimed at the [span_warning(parse_zone(def_zone))]!"))
	playsound(get_turf(user), 'sound/combat/shieldraise.ogg', 100)
	var/obj/effect/temp_visual/cataclysm_boulder/boulder = new(get_turf(user))
	var/dx = (dest.x - user.x) * 32
	var/dy = (dest.y - user.y) * 32
	animate(boulder, pixel_x = dx, pixel_y = dy, time = 4)
	var/matrix/q1 = matrix()
	q1.Turn(90)
	animate(boulder, transform = q1, time = 1, flags = ANIMATION_PARALLEL)
	var/matrix/q2 = matrix()
	q2.Turn(180)
	animate(transform = q2, time = 1)
	var/matrix/q3 = matrix()
	q3.Turn(270)
	animate(transform = q3, time = 1)
	animate(transform = matrix(), time = 1)

	addtimer(CALLBACK(src, PROC_REF(do_hammer_impact), user, weapon, dest, final_damage, def_zone, empowered, boulder), 4)

/datum/action/cooldown/spell/cataclysm/proc/do_hammer_impact(mob/living/carbon/human/user, obj/item/weapon, turf/dest, final_damage, def_zone, empowered, obj/effect/temp_visual/cataclysm_boulder/boulder)
	if(!QDELETED(boulder))
		qdel(boulder)

	playsound(dest, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 100, TRUE)

	for(var/turf/affected_turf in get_hear(area_of_effect, dest))
		new /obj/effect/temp_visual/kinetic_blast(affected_turf)
		for(var/mob/living/L in affected_turf.contents)
			if(L == user || L.stat == DEAD)
				continue
			if(L.can_block_magic())
				L.visible_message(span_warning("The hammer shatters around [L]!"))
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(empowered)
				arcyne_strike(user, L, weapon, round(final_damage / 2), def_zone, BCLASS_BLUNT, spell_name = "Cataclysm", skip_message = TRUE)
				arcyne_strike(user, L, weapon, round(final_damage / 2), def_zone, BCLASS_BLUNT, spell_name = "Cataclysm")
			else
				arcyne_strike(user, L, weapon, final_damage, def_zone, BCLASS_BLUNT, spell_name = "Cataclysm")
			L.apply_status_effect(/datum/status_effect/debuff/vulnerable, vulnerable_duration)
			playsound(affected_turf, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 60, TRUE)

/obj/effect/temp_visual/cataclysm_boulder
	icon = 'icons/roguetown/weapons/32/clubs.dmi'
	icon_state = "iwarhammer"
	name = "arcyne hammer"
	desc = "A hammer of pure arcyne force."
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
	duration = 8
