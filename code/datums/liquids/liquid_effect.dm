/obj/effect/abstract/liquid_turf
	name = "liquid"
	icon = 'icons/effects/liquids.dmi'
	icon_state = "puddle"
	anchored = TRUE
	plane = FLOOR_PLANE
	color = "#DDF"
	alpha = 175
	//For being on fire
	light_outer_range = 0
	light_power = 1
	light_color = LIGHT_COLOR_FIRE

	mouse_opacity = FALSE
	shine = SHINE_REFLECTIVE

	var/datum/liquid_group/liquid_group
	var/turf/my_turf

	var/fire_state = LIQUID_FIRE_STATE_NONE
	var/liquid_state = LIQUID_STATE_PUDDLE
	var/no_effects = FALSE


	var/static/obj/effect/abstract/fire/small_fire/small_fire
	var/static/obj/effect/abstract/fire/medium_fire/medium_fire
	var/static/obj/effect/abstract/fire/big_fire/big_fire

	var/mutable_appearance/displayed_content
	/// State-specific message chunks for examine_turf()
	var/static/list/liquid_state_messages = list(
		"[LIQUID_STATE_PUDDLE]" = "a puddle of $",
		"[LIQUID_STATE_ANKLES]" = "$ going [span_warning("up to your ankles")]",
		"[LIQUID_STATE_WAIST]" = "$ going [span_warning("up to your waist")]",
		"[LIQUID_STATE_SHOULDERS]" = "$ going [span_warning("up to your shoulders")]",
		"[LIQUID_STATE_FULLTILE]" = "$ going [span_danger("over your head")]",
	)

	var/temporary_split_key

	var/list/connected = list("2" = 0, "1" = 0, "8" = 0, "4" = 0)
	flags_1 = CONDUCT_1

/obj/effect/abstract/liquid_turf/proc/set_connection(dir)
	connected["[dir]"] = 1
	update_appearance(UPDATE_ICON)

/obj/effect/abstract/liquid_turf/proc/unset_connection(dir)
	connected["[dir]"] = 0
	update_appearance(UPDATE_ICON)

/obj/effect/abstract/liquid_turf/update_icon_state()
	. = ..()
	make_unshiny()
	var/new_overlay = ""
	for(var/i in connected)
		if(connected[i])
			new_overlay += i
	icon_state = "[new_overlay]"
	if(!new_overlay)
		icon_state = "puddle"
	make_shiny(initial(shine))

/obj/effect/abstract/liquid_turf/update_overlays()
	. = ..()
	var/number = liquid_state - 1
	if(number != 0)
		. += mutable_appearance('icons/effects/liquid_overlays.dmi', "stage[number]_bottom", plane = GAME_PLANE_UPPER, layer = ABOVE_MOB_LAYER)
		. += mutable_appearance('icons/effects/liquid_overlays.dmi', "stage[number]_top", plane =GAME_PLANE, layer = BELOW_MOB_LAYER)
	if(liquid_group?.glows)
		. += mutable_appearance(icon, icon_state, plane = EMISSIVE_PLANE)

/obj/effect/abstract/liquid_turf/make_shiny(_shine = SHINE_REFLECTIVE)
	if(total_reflection_mask)
		if(shine != _shine)
			cut_overlay(total_reflection_mask)
		else
			return
	switch(_shine)
		if(SHINE_MATTE)
			return
	total_reflection_mask = mutable_appearance(icon, "[icon_state]-puddle-reflective", plane = REFLECTIVE_DISPLACEMENT_PLANE)
	add_overlay(total_reflection_mask)
	shine = _shine

/obj/effect/abstract/liquid_turf/Initialize(mapload, datum/liquid_group/group_to_add)
	. = ..()
	if(!small_fire)
		small_fire = new
	if(!medium_fire)
		medium_fire = new
	if(!big_fire)
		big_fire = new

	my_turf ||= loc
	my_turf.ImmediateCalculateAdjacentTurfs()

	if(QDELETED(my_turf.liquids))
		my_turf.liquids = src

	if(!QDELETED(group_to_add))
		group_to_add.add_to_group(my_turf)
		set_new_liquid_state(liquid_group.group_overlay_state)

	if(QDELETED(liquid_group) && QDELETED(group_to_add))
		liquid_group = new(1, src)

	if(!SSliquids)
		CRASH("Liquid Turf created with the liquids sybsystem not yet initialized!")
	RegisterSignal(my_turf, COMSIG_ATOM_ENTERED, PROC_REF(movable_entered))
	RegisterSignal(my_turf, COMSIG_PARENT_EXAMINE, PROC_REF(examine_turf))

	for(var/direction in GLOB.cardinals)
		var/turf/cardinal_turf = get_step(src, direction)
		for(var/obj/effect/abstract/liquid_turf/pipe in cardinal_turf)
			if(!istype(pipe))
				continue
			set_connection(get_dir(src, pipe))
			pipe.set_connection(get_dir(pipe, src))
	if(z)
		update_appearance(UPDATE_ICON)
		for(var/direction in GLOB.cardinals)
			var/turf/turf = get_step(src, direction)
			if(!turf.liquids)
				continue
			turf.liquids.update_appearance(UPDATE_ICON)

/obj/effect/abstract/liquid_turf/Destroy(force)
	UnregisterSignal(my_turf, list(COMSIG_ATOM_ENTERED, COMSIG_PARENT_EXAMINE))
	if(!isnull(my_turf))
		liquid_group?.remove_from_group(my_turf)
		SSliquids.evaporation_queue -= my_turf
		SSliquids.burning_turfs -= my_turf
		SSliquids.cached_exposures -= my_turf
		my_turf.liquids = null
	liquid_group = null
	my_turf = null

	for(var/direction in GLOB.cardinals)
		var/turf/cardinal_turf = get_step(src, direction)
		for(var/obj/effect/abstract/liquid_turf/pipe in cardinal_turf)
			if(!istype(pipe))
				return
			set_connection(get_dir(src, pipe))
			pipe.set_connection(get_dir(pipe, src))
			pipe.update_appearance(UPDATE_ICON)

	for(var/direction in GLOB.cardinals)
		var/turf/turf = get_step(src, direction)
		if(!turf.liquids)
			continue
		var/obj/effect/abstract/liquid_turf/liquid = turf.liquids
		liquid.unset_connection(get_dir(turf.liquids, src))
	return ..()

/obj/effect/abstract/liquid_turf/proc/process_evaporation()
	if(!liquid_group.always_evaporates && (liquid_group.expected_turf_height > LIQUID_ANKLES_LEVEL_HEIGHT))
		SSliquids.evaporation_queue -= my_turf
		return

	//See if any of our reagents evaporates
	var/any_change = FALSE
	var/always_evaporates = liquid_group.always_evaporates
	var/evaporation_multiplier = liquid_group.evaporation_multiplier
	var/datum/reagent/R //Faster declaration
	for(var/reagent_type in liquid_group.reagents.reagent_list)
		if(QDELETED(liquid_group))
			continue
		R = reagent_type
		//We evaporate. bye bye
		if(initial(R.evaporates) || always_evaporates)
			var/remove_amount = min((initial(R.evaporation_rate)) * evaporation_multiplier, R.volume, (liquid_group.reagents_per_turf / length(liquid_group.reagents.reagent_list)))
			liquid_group.remove_specific(src, remove_amount, R, TRUE)
			any_change = TRUE
			R.evaporate(src.loc, remove_amount)

	if(!any_change)
		SSliquids.evaporation_queue -= my_turf
		return

/obj/effect/abstract/liquid_turf/forceMove(atom/destination, no_tp = FALSE, harderforce = FALSE)
	if(harderforce)
		. = ..()

/obj/effect/abstract/liquid_turf/proc/set_new_liquid_state(new_state)
	if(no_effects)
		return
	liquid_state = new_state

	var/number = new_state - 1
	if(number != 0)
		icon_state = null
		update_appearance(UPDATE_OVERLAYS)
	else
		icon_state = initial(icon_state)
		update_appearance(UPDATE_OVERLAYS)
		for(var/direction in GLOB.cardinals)
			var/turf/turf = get_step(src, direction)
			if(!turf.liquids)
				continue
			turf.liquids.update_appearance(UPDATE_OVERLAYS)
		update_appearance(UPDATE_OVERLAYS)

/obj/effect/abstract/liquid_turf/proc/set_fire_effect()
	if(displayed_content)
		vis_contents -= displayed_content

	if(!liquid_group)
		return

	switch(liquid_group.group_fire_state)
		if(LIQUID_FIRE_STATE_SMALL)
			displayed_content = small_fire
		if(LIQUID_FIRE_STATE_MILD)
			displayed_content = small_fire
		if(LIQUID_FIRE_STATE_MEDIUM)
			displayed_content = medium_fire
		if(LIQUID_FIRE_STATE_HUGE)
			displayed_content = big_fire
		if(LIQUID_FIRE_STATE_INFERNO)
			displayed_content = big_fire
		else
			displayed_content = null

	if(displayed_content)
		vis_contents |= displayed_content

//Takes a flat of our reagents and returns it, possibly qdeling our liquids
/obj/effect/abstract/liquid_turf/proc/take_reagents_flat(flat_amount)
	liquid_group.remove_any(src, flat_amount)

/obj/effect/abstract/liquid_turf/proc/movable_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(!liquid_group)
		qdel(src)
		return

	var/turf/T = source
	if(isobserver(AM))
		return //ghosts, camera eyes, etc. don't make water splashy splashy
	if(liquid_group.group_overlay_state >= LIQUID_STATE_ANKLES)
		if(prob(30))
			var/sound_to_play = pick(list(
				'sound/misc/water_wade1.ogg',
				'sound/misc/water_wade2.ogg',
				'sound/misc/water_wade3.ogg',
				'sound/misc/water_wade4.ogg'
				))
			playsound(T, sound_to_play, 50, 0)
		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			C.apply_status_effect(/datum/status_effect/water_affected)
		if(isliving(AM))
			var/mob/living/carbon/human/stepped_human = AM
			liquid_group.expose_atom(stepped_human, 1, TOUCH)
	else if (isliving(AM))
		var/mob/living/L = AM
		if(liquid_group.slippery)
			if(prob(7) && !(L.movement_type & FLYING) && L.body_position != LYING_DOWN)
				L.slip(30, T, NO_SLIP_WHEN_WALKING, 0, TRUE)

	if(fire_state)
		AM.fire_act((T20C+50) + (50*fire_state), 125)

/obj/effect/abstract/liquid_turf/proc/mob_fall(datum/source, mob/M)
	SIGNAL_HANDLER
	if(liquid_group.group_overlay_state >= LIQUID_STATE_ANKLES)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(C.wear_mask && C.wear_mask.flags_cover & MASKCOVERSMOUTH)
				to_chat(C, span_userdanger("You fall in the water!"))
			else
				liquid_group.transfer_to_atom(src, CHOKE_REAGENTS_INGEST_ON_FALL_AMOUNT, C)
				C.adjustOxyLoss(5)
				//C.emote("cough")
				INVOKE_ASYNC(C, TYPE_PROC_REF(/mob, emote), "cough")
				to_chat(C, span_userdanger("You fall in and swallow some water!"))
		else
			to_chat(M, span_userdanger("You fall in the water!"))

/obj/effect/abstract/liquid_turf/proc/ChangeToNewTurf(turf/NewT)
	if(NewT.liquids)
		stack_trace("Liquids tried to change to a new turf, that already had liquids on it!")

	if(SSliquids.evaporation_queue[my_turf])
		SSliquids.evaporation_queue -= my_turf
		SSliquids.evaporation_queue[NewT] = TRUE
	my_turf.liquids = null
	my_turf = NewT
	liquid_group.move_liquid_group(src)
	NewT.liquids = src
	loc = NewT
	RegisterSignal(my_turf, COMSIG_ATOM_ENTERED, PROC_REF(movable_entered))

/**
 * Handles COMSIG_PARENT_EXAMINE for the turf.
 *
 * Adds reagent info to examine text.
 * Arguments:
 * * source - the turf we're peekin at
 * * examiner - the user
 * * examine_text - the examine list
 *  */
/obj/effect/abstract/liquid_turf/proc/examine_turf(turf/source, mob/examiner, list/examine_list)
	SIGNAL_HANDLER

	if(!liquid_group)
		qdel(src)
		return

	// This should always have reagents if this effect object exists, but as a sanity check...
	if(!length(liquid_group.reagents.reagent_list))
		return

	var/liquid_state_template = liquid_state_messages["[liquid_group.group_overlay_state]"]

	examine_list +=  "<hr>"

	if(examiner.can_see_reagents())
		examine_list +=  "<hr>"

		if(length(liquid_group.reagents.reagent_list) == 1)
			// Single reagent text.
			var/datum/reagent/reagent_type = liquid_group.reagents.reagent_list[1]
			var/reagent_name = initial(reagent_type.name)
			var/volume = round(reagent_type.volume / length(liquid_group.members), 0.01)
			examine_list += span_notice("There is [replacetext(liquid_state_template, "$", "[UNIT_FORM_STRING(volume)] of [reagent_name]")] here.")
		else
			// Show each individual reagent
			examine_list += "There is [replacetext(liquid_state_template, "$", "the following")] here:"

			for(var/datum/reagent/reagent_type as anything in liquid_group.reagents.reagent_list)
				var/reagent_name = initial(reagent_type.name)
				var/volume = round(reagent_type.volume / length(liquid_group.members), 0.01)
				examine_list += "&bull; [UNIT_FORM_STRING(volume)] of [reagent_name]"

		examine_list +=  "<hr>"
		return

	// Otherwise, just show the total volume
	examine_list += span_notice("There is [replacetext(liquid_state_template, "$", "liquid")] here.")

/obj/effect/temp_visual/liquid_splash
	icon = 'icons/effects/splash.dmi'
	icon_state = "splash"
	layer = FLY_LAYER
	randomdir = FALSE

/obj/effect/abstract/fire
	icon = 'icons/effects/fire.dmi'
	plane = FLOOR_PLANE
	layer = BELOW_MOB_LAYER
	mouse_opacity = FALSE
	appearance_flags = RESET_COLOR | RESET_ALPHA

/obj/effect/abstract/fire/small_fire
	icon_state = "1"

/obj/effect/abstract/fire/medium_fire
	icon_state = "2"

/obj/effect/abstract/fire/big_fire
	icon_state = "3"
