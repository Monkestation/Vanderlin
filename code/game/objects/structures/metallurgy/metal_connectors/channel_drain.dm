/obj/structure/channel_connector/drain
	name = "channel drain"
	desc = "A drain that connects to metal channels and automatically pours molten metal into moulds placed beneath it."

	icon = 'icons/roguetown/weapons/crucible.dmi'
	icon_state = "drain"

	anchored = TRUE
	density = FALSE


	var/obj/item/mould/target_mould
	var/last_check_time = 0
	var/check_interval = 3 SECONDS
	var/drain_rate = 8

/obj/structure/channel_connector/drain/Initialize()
	. = ..()
	connected_dirs = list(TEXT_NORTH) //hell non-constant
	main_material = pick(typesof(/datum/material/clay))
	set_material_information()
	START_PROCESSING(SSobj, src)

/obj/structure/channel_connector/drain/Destroy()
	STOP_PROCESSING(SSobj, src)
	target_mould = null
	return ..()

/obj/structure/channel_connector/drain/examine(mob/user)
	. = ..()
	if(target_mould)
		. += "There is \a [target_mould] positioned beneath the drain."
		var/fill_percent = round((target_mould.fufilled_metal / target_mould.required_metal) * 100, 1)
		. += "The mould is [fill_percent]% filled."
	else
		. += "There is no mould beneath the drain."

	var/obj/structure/metal_channel/input = connected_channels[TEXT_NORTH]
	if(input?.group_reagents?.total_volume)
		. += "The connected channel contains molten metal ready to drain."

/obj/structure/channel_connector/drain/process()
	// Check for moulds periodically
	if(world.time >= last_check_time + check_interval)
		find_target_mould()
		last_check_time = world.time

	// If we have a target mould and metal available, drain into it
	var/obj/structure/metal_channel/input = connected_channels[TEXT_NORTH]
	if(target_mould && input?.group_reagents?.total_volume > 0)
		drain_into_mould(input)

	update_appearance(UPDATE_OVERLAYS)

/obj/structure/channel_connector/drain/proc/find_target_mould()
	target_mould = null

	// Look for moulds in the turf below
	var/turf/below_turf = get_turf(src)
	for(var/obj/item/mould/mould in below_turf)
		if(mould.cooling)
			continue

		if(mould.fufilled_metal >= mould.required_metal)
			continue

		target_mould = mould
		break

/obj/structure/channel_connector/drain/proc/drain_into_mould(obj/structure/metal_channel/channel)
	if(!target_mould || !channel?.group_reagents)
		return
	var/datum/reagent/molten_metal/channel_metal = channel.group_reagents.get_reagent(/datum/reagent/molten_metal)
	if(!channel_metal)
		return
	// Determine what metal to drain
	var/datum/material/metal_to_drain
	if(!target_mould.filling_metal)
		// For automatic draining, use the most abundant metal
		var/highest_amount = 0
		for(var/datum/material/material as anything in channel_metal.data)
			if(!ispath(material))
				continue
			if(channel.group_reagents.chem_temp >= initial(material.melting_point))
				if(channel_metal.data[material] > highest_amount)
					highest_amount = channel_metal.data[material]
					metal_to_drain = material
		if(!metal_to_drain)
			return
		target_mould.filling_metal = metal_to_drain
	else
		if(!(target_mould.filling_metal in channel_metal.data))
			return
		if(channel.group_reagents.chem_temp < initial(target_mould.filling_metal.melting_point))
			return
		metal_to_drain = target_mould.filling_metal
	var/available_metal = channel_metal.data[metal_to_drain]
	var/needed_metal = target_mould.required_metal - target_mould.fufilled_metal
	var/amount_to_drain = min(drain_rate, available_metal, needed_metal)
	if(amount_to_drain <= 0)
		return

	var/drain_quality = channel_metal.recipe_quality

	if(target_mould.fufilled_metal > 0)
		target_mould.total_quality_points += amount_to_drain * drain_quality
		target_mould.average_quality = target_mould.total_quality_points / (target_mould.fufilled_metal + amount_to_drain)
	else
		target_mould.total_quality_points = amount_to_drain * drain_quality
		target_mould.average_quality = drain_quality

	channel_metal.data[metal_to_drain] -= amount_to_drain
	if(channel_metal.data[metal_to_drain] <= 0)
		channel_metal.data -= metal_to_drain
	channel.group_reagents.remove_reagent(/datum/reagent/molten_metal, amount_to_drain)
	if(!QDELETED(channel_metal))
		channel_metal.find_largest_metal()

	target_mould.fufilled_metal += amount_to_drain
	target_mould.update_appearance(UPDATE_OVERLAYS)
	if(target_mould.fufilled_metal >= target_mould.required_metal)
		target_mould.start_cooling()
		target_mould = null
	for(var/obj/structure/metal_channel/channel_update in channel.info?.channels)
		channel_update.update_appearance(UPDATE_OVERLAYS)
	if(prob(25))
		visible_message("<span class='notice'>Molten metal drips from [src] into the mould below.</span>")

/obj/structure/channel_connector/drain/update_overlays()
	. = ..()

	var/obj/structure/metal_channel/input = connected_channels[TEXT_NORTH]
	if(target_mould && input?.group_reagents?.total_volume > 0)
		var/datum/reagent/molten_metal/metal = input.group_reagents.get_reagent(/datum/reagent/molten_metal)
		var/datum/material/largest = metal?.largest_metal
		if(largest)
			. += mutable_appearance(
				icon,
				"drain_flow",
				color = initial(largest.color),
				appearance_flags = (RESET_COLOR | KEEP_APART),
			)

			if(initial(largest.red_hot) && input.group_reagents.chem_temp > initial(largest.melting_point))
				. += emissive_appearance(icon, "drain_flow", alpha = 100)
