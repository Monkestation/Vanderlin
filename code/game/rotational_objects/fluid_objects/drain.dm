/obj/structure/fluid_drain
	name = "drain"
	desc = "A drain that sucks up liquids from the ground and feeds them into a pipe system."
	icon = 'icons/roguetown/misc/pipes.dmi'
	icon_state = "drain"
	density = FALSE
	layer = BELOW_OBJ_LAYER
	plane = GAME_PLANE
	damage_deflection = 3
	blade_dulling = DULLING_BASHCHOP
	attacked_sound = list('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg')
	smeltresult = /obj/item/ingot/bronze
	obj_flags = CAN_BE_HIT

	var/datum/reagents/collected_fluids
	var/max_storage = 1000 // Maximum fluid storage
	var/drain_rate = 10 // Base drain rate per process tick
	var/drain_range = 1 // Range to drain from (adjacent turfs)
	var/processes = 0
	var/processes_required = 3 // Ticks between drain attempts

	var/obj/structure/water_pipe/connected_pipe
	var/datum/reagent/current_providing_reagent
	var/providing_pressure = 0
	var/base_pressure = 5 // Base pressure when providing fluids
	var/active = FALSE

	var/mutable_appearance/drain_effect

/obj/structure/fluid_drain/Initialize()
	. = ..()
	collected_fluids = new/datum/reagents(max_storage)
	collected_fluids.my_atom = src

	// Look for nearby water pipes to connect to
	find_connected_pipe()

	if(connected_pipe)
		START_PROCESSING(SSobj, src)
		active = TRUE
		visible_message(span_notice("[src] connects to the pipe system and begins operation."))
	else
		visible_message(span_warning("[src] needs to be placed on or near a water pipe!"))

/obj/structure/fluid_drain/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(connected_pipe && current_providing_reagent)
		connected_pipe.remove_provider(current_providing_reagent, 0)
	QDEL_NULL(collected_fluids)
	return ..()

/obj/structure/fluid_drain/proc/find_connected_pipe()
	// Check our turf first
	var/turf/our_turf = get_turf(src)
	for(var/obj/structure/water_pipe/pipe in our_turf)
		connected_pipe = pipe
		return

	// Check adjacent turfs
	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(src, direction)
		for(var/obj/structure/water_pipe/pipe in adjacent_turf)
			connected_pipe = pipe
			return

/obj/structure/fluid_drain/process()
	if(!connected_pipe || !active)
		return

	// Always try to drain if we have space
	if(collected_fluids.total_volume < max_storage)
		drain_nearby_liquids()

	// Provide fluids to pipe system if we have any
	if(collected_fluids.total_volume > 0)
		provide_fluids_to_pipe()
	else
		// Stop providing if we're empty
		if(current_providing_reagent)
			connected_pipe.remove_provider(current_providing_reagent, 0)
			current_providing_reagent = null
			visible_message(span_notice("[src] runs out of fluid to provide."))

/obj/structure/fluid_drain/proc/drain_nearby_liquids()
	if(processes < processes_required)
		processes++
		return
	processes = 0

	var/turf/our_turf = get_turf(src)
	var/list/turfs_to_check = list(our_turf)

	for(var/i in 1 to drain_range)
		var/list/new_turfs = list()
		for(var/turf/T in turfs_to_check)
			for(var/direction in GLOB.cardinals)
				var/turf/adjacent = get_step(T, direction)
				if(adjacent && !(adjacent in turfs_to_check) && !(adjacent in new_turfs))
					new_turfs += adjacent
		turfs_to_check += new_turfs

	for(var/turf/T in turfs_to_check)
		if(!T.liquids || !T.liquids.liquid_group)
			continue

		var/free_space = max_storage - collected_fluids.total_volume
		if(free_space <= 0)
			break

		var/drain_amount = min(drain_rate, free_space)
		var/datum/liquid_group/targeted_group = T.liquids.liquid_group

		if(targeted_group.total_reagent_volume < drain_amount)
			drain_amount = targeted_group.total_reagent_volume

		if(drain_amount > 0)
			targeted_group.trans_to_seperate_group(collected_fluids, drain_amount)

			// Visual effect
			show_drain_effect(T)

			// Handle liquid group cleanup (simplified version)
			if(targeted_group.total_reagent_volume <= 0)
				for(var/turf/member_turf in targeted_group.members)
					if(member_turf.liquids)
						qdel(member_turf.liquids)

/obj/structure/fluid_drain/proc/provide_fluids_to_pipe()
	if(!connected_pipe)
		return

	// Find the reagent with the highest volume to provide
	var/datum/reagent/highest_reagent
	var/highest_volume = 0

	for(var/datum/reagent/R in collected_fluids.reagent_list)
		if(R.volume > highest_volume)
			highest_volume = R.volume
			highest_reagent = R

	if(!highest_reagent)
		return

	if(current_providing_reagent != highest_reagent.type)
		if(current_providing_reagent)
			connected_pipe.remove_provider(current_providing_reagent, 0)
		current_providing_reagent = highest_reagent.type
		visible_message(span_notice("[src] begins providing [initial(highest_reagent.name)] to the pipe system."))

	var/volume_factor = min(highest_volume / 100, 2)
	providing_pressure = base_pressure * volume_factor

	connected_pipe.make_provider(highest_reagent.type, providing_pressure, src)

/obj/structure/fluid_drain/use_water_pressure(pressure)
	var/datum/reagent/highest_reagent
	var/highest_volume = 0

	for(var/datum/reagent/R in collected_fluids.reagent_list)
		if(R.volume > highest_volume)
			highest_volume = R.volume
			highest_reagent = R

	if(highest_reagent)
		var/amount_to_remove = min(pressure, highest_reagent.volume)
		collected_fluids.remove_reagent(highest_reagent.type, amount_to_remove)
	provide_fluids_to_pipe()

/obj/structure/fluid_drain/proc/show_drain_effect(turf/T)
	if(!drain_effect)
		drain_effect = mutable_appearance('icons/effects/effects.dmi', "anom")
		drain_effect.alpha = 20

	var/obj/effect/temp_visual/drain_swirl/effect = new(T)
	effect.appearance = drain_effect

/obj/structure/fluid_drain/return_rotation_chat()
	var/primary_fluid = "None"
	var/primary_volume = 0
	for(var/datum/reagent/R in collected_fluids.reagent_list)
		if(R.volume > primary_volume)
			primary_volume = R.volume
			primary_fluid = initial(R.name)

	var/status = active ? "Active" : "Inactive"

	return "Status: [status]\n\
			Storage: [collected_fluids.total_volume]/[max_storage]\n\
			Primary: [primary_fluid] ([primary_volume])\n\
			Pressure: [providing_pressure]"

/obj/structure/fluid_drain/examine(mob/user)
	. = ..()

	if(connected_pipe)
		. += span_info("Connected to a water pipe system.")
		if(active && providing_pressure > 0)
			. += span_notice("Currently providing [providing_pressure] pressure to the pipe system.")
	else
		. += span_warning("Not connected to any water pipe!")

	if(active)
		. += span_notice("The drain is actively collecting liquids from the ground.")
	else
		. += span_warning("The drain is inactive - it needs a pipe connection to operate.")

/obj/effect/temp_visual/drain_swirl
	icon = 'icons/effects/effects.dmi'
	icon_state = "anom"
	duration = 0.1 SECONDS
	fade_time = 0.5 SECONDS
	alpha = 150
