/datum/action/cooldown/spell/caedo
	name = "Caedo"
	desc = "In the old tongue, caedo - to strike or to cut down. Dash forward at blinding speed, \
		leaving afterimages that strike every enemy in your path. \
		Empowered (3 Momentum): Consumes 3 stacks to strike twice. \
		If any of them defend against the strike, you will be left exposed and slowed!"
	button_icon = 'icons/mob/actions/spells/spellblade.dmi'
	button_icon_state = "caedo"
	sound = 'sound/magic/blink.ogg'

	cast_range = 7

	required_form = FORM_LIGHTNING
	required_technique = TECHNIQUE_IMBUE

	spell_cost = 10

	invocation = "Caedo!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 12 SECONDS

	spell_impact_intensity = SPELL_IMPACT_LOW
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/max_range = 5
	var/strike_damage = 40
	var/empower_cost = 3

/datum/action/cooldown/spell/caedo/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/held_weapon = H.arcyne_get_weapon()
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
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

	// Soft clamp: if too far or path blocked, dash as far as possible toward target
	dest = find_max_walk_dest(H, dest, max_range)
	if(!dest)
		to_chat(H, span_warning("I can't dash there!"))
		return FALSE

	var/distance = get_dist(start, dest)
	if(distance < 1)
		to_chat(H, span_warning("I need somewhere to dash to!"))
		return FALSE

	var/list/full_path = getline(start, dest)

	var/list/mobs_in_path = list()
	for(var/turf/path_turf in full_path)
		if(path_turf == start)
			continue
		for(var/mob/living/M in path_turf)
			if(M != H && M.stat != DEAD)
				mobs_in_path += M

	INVOKE_ASYNC(src, PROC_REF(create_afterimage_trail), H, full_path)

	playsound(start, 'sound/magic/blink.ogg', 40, TRUE)
	H.visible_message(
		span_warning("[H] vanishes in a blur of motion!"),
		span_notice("I dash!"))

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)
	do_teleport(H, dest, channel = TELEPORT_CHANNEL_MAGIC)
	playsound(dest, 'sound/magic/blink.ogg', 25, TRUE)

	log_combat(H, cast_on, "used Caedo on")

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/momentum = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum && momentum.stacks >= empower_cost)
		momentum.consume_stacks(empower_cost)
		empowered = TRUE
		to_chat(H, span_notice("Momentum surges - twin strikes!"))

	var/locked_zone = H.zone_selected || BODY_ZONE_CHEST

	if(length(mobs_in_path))
		addtimer(CALLBACK(src, PROC_REF(execute_path_strikes), H, mobs_in_path, held_weapon, locked_zone, empowered), 5)

	return TRUE

/datum/action/cooldown/spell/caedo/proc/find_landing_turf(mob/living/user, mob/living/target_mob)
	var/approach_dir = get_dir(user, target_mob)
	var/turf/far_side = get_step(target_mob, approach_dir)
	if(far_side && !far_side.density && !istransparentturf(far_side) && isfloorturf(far_side))
		return far_side
	return get_turf(target_mob)

/datum/action/cooldown/spell/caedo/proc/execute_path_strikes(mob/living/carbon/human/user, list/victims, obj/item/weapon, def_zone, empowered = FALSE)
	if(!user || QDELETED(user))
		return
	var/hit_count = 0
	for(var/mob/living/victim in victims)
		if(QDELETED(victim) || victim.stat == DEAD)
			continue
		var/total_damage = strike_damage
		arcyne_strike(user, victim, weapon, total_damage, def_zone, spell_name = "Caedo", skip_animation = TRUE)
		hit_count++
		var/turf/victim_turf = get_turf(victim)
		if(victim_turf)
			var/slash_dir = get_dir(user, victim)
			var/obj/effect/temp_visual/blade_cut/V = new(victim_turf)
			V.dir = slash_dir
		if(empowered)
			addtimer(CALLBACK(src, PROC_REF(second_strike), user, victim, weapon, def_zone), 3)
	if(hit_count >= 2)
		var/datum/status_effect/buff/arcyne_momentum/surge = user.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
		if(surge)
			surge.add_stacks(1)
			to_chat(user, span_notice("DOUBLE STRIKE! ARCYNE SURGE!"))

/datum/action/cooldown/spell/caedo/proc/second_strike(mob/living/carbon/human/user, mob/living/victim, obj/item/weapon, def_zone)
	if(!user || QDELETED(user) || !victim || QDELETED(victim) || victim.stat == DEAD)
		return
	var/total_damage = strike_damage
	arcyne_strike(user, victim, weapon, total_damage, def_zone, spell_name = "Caedo", skip_animation = TRUE)
	var/turf/victim_turf = get_turf(victim)
	if(victim_turf)
		var/slash_dir = get_dir(user, victim)
		var/obj/effect/temp_visual/blade_cut/V = new(victim_turf)
		V.dir = slash_dir

/datum/action/cooldown/spell/caedo/proc/create_afterimage_trail(mob/living/carbon/human/user, list/path_turfs)
	set waitfor = FALSE
	var/list/images = list()
	var/path_len = length(path_turfs)
	if(path_len < 2)
		return
	var/travel_dir = get_dir(path_turfs[1], path_turfs[path_len])

	var/front_px = 0
	var/front_py = 0
	var/back_px = 0
	var/back_py = 0
	switch(travel_dir)
		if(NORTH)
			front_py = 10
			back_py = -10
		if(SOUTH)
			front_py = -10
			back_py = 10
		if(EAST)
			front_px = 10
			back_px = -10
		if(WEST)
			front_px = -10
			back_px = 10
		if(NORTHEAST)
			front_px = 8
			front_py = 8
			back_px = -8
			back_py = -8
		if(NORTHWEST)
			front_px = -8
			front_py = 8
			back_px = 8
			back_py = -8
		if(SOUTHEAST)
			front_px = 8
			front_py = -8
			back_px = -8
			back_py = 8
		if(SOUTHWEST)
			front_px = -8
			front_py = -8
			back_px = 8
			back_py = 8

	for(var/i in 1 to path_len)
		var/turf/T = path_turfs[i]
		var/base_alpha = round(40 + 80 * (i - 1) / max(path_len - 1, 1))
		for(var/side in 1 to 2)
			var/obj/effect/after_image/img = new(T, 0, 0, 0, 0, 0.5 SECONDS, 3 SECONDS, 0)
			images += img
			img.name = user.name
			img.appearance = user.appearance
			img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
			img.dir = travel_dir
			img.alpha = base_alpha
			if(side == 1)
				img.pixel_x = front_px
				img.pixel_y = front_py
			else
				img.pixel_x = back_px
				img.pixel_y = back_py
	QDEL_LIST_IN(images, 2 SECONDS)
