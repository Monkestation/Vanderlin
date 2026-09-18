/datum/action/cooldown/spell/levinstroke
	button_icon = 'icons/mob/actions/spells/mage_fulgurmancy.dmi'
	name = "Levinstroke"
	desc = "Transform yourself briefly into a bolt of lightning toward a target location, inflicting 60 burn damage to any living things in your path."
	button_icon_state = "levinstroke"
	sound = 'sound/magic/lightning.ogg'

	cast_range = SPELL_RANGE_GROUND

	spell_cost = 40

	required_form = FORM_LIGHTNING
	required_technique = TECHNIQUE_ALTERATION

	invocation = "Fio Fulmen!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_MINOR
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS

	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/max_range = 5
	var/strike_damage = 60

/datum/action/cooldown/spell/levinstroke/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/start = get_turf(H)
	var/turf/dest

	if(isliving(cast_on))
		dest = find_landing_turf(H, cast_on)
	else
		dest = get_turf(cast_on)

	if(!dest || dest.z != start.z)
		to_chat(H, span_warning("Invalid target!"))
		return FALSE

	dest = find_max_walk_dest(H, dest, max_range)
	if(!dest)
		to_chat(H, span_warning("I can't surge there!"))
		return FALSE

	var/distance = get_dist(start, dest)
	if(distance < 1)
		to_chat(H, span_warning("I need somewhere to surge to!"))
		return FALSE

	var/list/full_path = getline(start, dest)

	var/list/mobs_in_path = list()
	for(var/turf/path_turf in full_path)
		if(path_turf == start)
			continue
		for(var/mob/living/M in path_turf)
			if(M != H && M.stat != DEAD)
				mobs_in_path += M

	create_levin_visual(H, start, dest)

	playsound(start, 'sound/magic/lightning.ogg', 40, TRUE)
	H.visible_message(
		span_warning("[H] becomes a bolt of thunder!"),
		span_notice("I surge forward as living lightning!"))

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)
	do_teleport(H, dest, channel = TELEPORT_CHANNEL_MAGIC)
	playsound(dest, 'sound/magic/lightning.ogg', 25, TRUE)

	log_combat(H, cast_on, "used Levinstroke on")

	var/locked_zone = H.zone_selected || BODY_ZONE_CHEST

	if(length(mobs_in_path))
		addtimer(CALLBACK(src, PROC_REF(execute_path_strikes), H, mobs_in_path, locked_zone), 5)

	return TRUE

/datum/action/cooldown/spell/levinstroke/proc/find_landing_turf(mob/living/user, mob/living/target_mob)
	var/approach_dir = get_dir(user, target_mob)
	var/turf/far_side = get_step(target_mob, approach_dir)
	if(far_side && !far_side.density && !istransparentturf(far_side) && isfloorturf(far_side))
		return far_side
	return get_turf(target_mob)

/datum/action/cooldown/spell/levinstroke/proc/execute_path_strikes(mob/living/carbon/human/user, list/victims, def_zone)
	if(!user || QDELETED(user))
		return
	for(var/mob/living/victim in victims)
		if(QDELETED(victim) || victim.stat == DEAD)
			continue
		if(victim.can_block_magic())
			victim.visible_message(span_warning("The lightning fades away around [victim]!"))
			playsound(get_turf(victim), 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(ishuman(victim))
			arcyne_strike(user, victim, null, strike_damage, def_zone, BCLASS_BURN, \
				spell_name = "Levinstroke", damage_type = BURN, npc_simple_damage_mult = 1, \
				skip_animation = TRUE)
		else
			victim.electrocute_act(strike_damage, src, 1, SHOCK_NOSTUN)
		victim.electrocute_act(0, src, 1, SHOCK_NOSTUN|SHOCK_VISUAL_ONLY)
		new /obj/effect/temp_visual/spell_impact(get_turf(victim), spell_color, spell_impact_intensity)

/datum/action/cooldown/spell/levinstroke/proc/create_levin_visual(mob/living/carbon/human/user, turf/start, turf/dest)
	var/obj/effect/after_image/start_shadow = new(start, 0, 0, 0, 0, 0.5 SECONDS, 2 SECONDS, 0)
	start_shadow.name = user.name
	start_shadow.appearance = user.appearance
	start_shadow.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	start_shadow.dir = user.dir
	start_shadow.alpha = 120
	animate(start_shadow, alpha = 0, time = 1.5 SECONDS, easing = LINEAR_EASING)

	var/obj/effect/after_image/end_shadow = new(dest, 0, 0, 0, 0, 0.5 SECONDS, 2 SECONDS, 0)
	end_shadow.name = user.name
	end_shadow.appearance = user.appearance
	end_shadow.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	end_shadow.dir = user.dir
	end_shadow.alpha = 120
	animate(end_shadow, alpha = 0, time = 1.5 SECONDS, easing = LINEAR_EASING)

	start_shadow.Beam(end_shadow, icon_state = "lightning[rand(1, 12)]", time = 5)
