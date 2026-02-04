/datum/metal_channel_info //basically exists as a reference setter for lists to avoid tons of lists we need to manage
	var/list/channels = list()

/obj/structure/metal_channel
	name = "metal channel"

	icon = 'icons/roguetown/weapons/crucible.dmi'
	icon_state = "channel"

	var/datum/reagents/group_reagents
	var/list/connected = list("2" = 0, "1" = 0, "8" = 0, "4" = 0)

	var/datum/metal_channel_info/info

/obj/structure/metal_channel/Initialize()
	. = ..()
	main_material = pick(typesof(/datum/material/clay))
	set_material_information()

	try_find_group(TRUE)

	// Notify nearby channel connectors that a new channel was built
	for(var/direction in GLOB.cardinals)
		var/turf/cardinal_turf = get_step(src, direction)
		for(var/obj/structure/channel_connector/connector in cardinal_turf)
			if(direction in connector.connected_dirs)
				connector.on_channel_built_nearby()

/obj/structure/metal_channel/Destroy()
	var/turf/old_turf = get_turf(src)
	. = ..()
	reassess_group(old_turf)
	var/list/directional_pipes = list()
	for(var/direction in GLOB.cardinals)
		var/turf/cardinal_turf = get_step(old_turf, direction)
		for(var/obj/structure/metal_channel/pipe in cardinal_turf)
			if(!istype(pipe))
				continue
			pipe.unset_connection(get_dir(pipe, src))
			pipe.update_appearance(UPDATE_OVERLAYS)
			directional_pipes |= pipe

/obj/structure/metal_channel/update_overlays()
	. = ..()
	var/new_overlay = ""
	for(var/i in connected)
		if(connected[i])
			new_overlay += i
	icon_state = "[new_overlay]"
	if(!new_overlay)
		icon_state = "channel"

	var/datum/reagent/molten_metal/metal = group_reagents?.get_reagent(/datum/reagent/molten_metal)
	var/datum/material/largest = metal?.largest_metal
	if(!metal)
		return

	. += mutable_appearance(
		icon,
		"[icon_state]-c",
		color = initial(largest.color),
		appearance_flags = (RESET_COLOR | KEEP_APART),
	)
	if(initial(largest?.red_hot) && group_reagents.chem_temp > initial(largest.melting_point))
		. += emissive_appearance(icon, "[icon_state]-c", alpha = src.alpha)

/obj/structure/metal_channel/proc/set_connection(dir)
	connected["[dir]"] = 1
	update_appearance(UPDATE_OVERLAYS)
	try_find_group()

/obj/structure/metal_channel/proc/unset_connection(dir)
	connected["[dir]"] = 0
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/metal_channel/proc/set_connected()
	for(var/direction in GLOB.cardinals)
		var/turf/cardinal_turf = get_step(src, direction)
		for(var/obj/structure/metal_channel/pipe in cardinal_turf)
			if(!istype(pipe))
				return
			set_connection(get_dir(src, pipe))
			pipe.set_connection(get_dir(pipe, src))
			pipe.update_appearance(UPDATE_OVERLAYS)

/obj/structure/metal_channel/proc/try_find_group(find_group = FALSE)
	if(find_group)
		set_connected()

	var/list/reagents_found = list()
	var/list/channel_found = list()
	channel_found |= src

	var/true_value = 0
	for(var/list in connected)
		if(!connected[list])
			continue
		true_value++

	if(true_value == 1)
		for(var/direction in  GLOB.cardinals)
			var/turf/step = get_step(src, text2num(direction))
			var/obj/structure/metal_channel/channel = locate(/obj/structure/metal_channel) in step
			if(!channel)
				continue

			if(!channel.info)
				var/datum/metal_channel_info/new_info = new
				channel.info = new_info
				info = new_info
				new_info.channels |= src
				new_info.channels |= channel

				var/datum/reagents/new_reagents = new()
				new_reagents.maximum_volume = 1000000
				channel.group_reagents = new_reagents
				group_reagents = new_reagents

			else
				info = channel.info
				channel.info.channels |= src
				group_reagents = channel.group_reagents

			channel.update_appearance(UPDATE_OVERLAYS)
			update_appearance(UPDATE_OVERLAYS)
			return

	for(var/direction2 in GLOB.cardinals)
		var/list/nested_steps = list()
		var/turf/step2 = get_step(src, text2num(direction2))
		var/obj/structure/metal_channel/channel = locate(/obj/structure/metal_channel) in step2
		if(!channel)
			continue
		if(channel in channel_found)
			continue
		channel_found |= channel
		reagents_found |= channel.group_reagents
		nested_steps |= channel

		while(length(nested_steps))
			var/obj/structure/metal_channel/nest = nested_steps[1]
			nested_steps -= nest
			for(var/direction in GLOB.cardinals)
				var/turf/step = get_step(nest, text2num(direction))
				var/obj/structure/metal_channel/nest_channel = locate(/obj/structure/metal_channel) in step
				if(!nest_channel)
					continue
				if(nest_channel in channel_found)
					continue
				channel_found |= nest_channel
				reagents_found |= nest_channel.group_reagents
				nested_steps |= nest_channel

	var/datum/reagents/new_reagents
	if(!length(reagents_found))
		new_reagents = new()
		new_reagents.maximum_volume = 1000000

	if(length(reagents_found) == 1)
		new_reagents = reagents_found[1]

	if(length(reagents_found) > 1)
		new_reagents = new()
		new_reagents.maximum_volume = 1000000

		for(var/datum/reagents/reagents as anything in reagents_found)
			if(!istype(reagents))
				continue
			reagents.trans_to(new_reagents, reagents.total_volume, preserve_data = TRUE)

	var/datum/metal_channel_info/new_info = new
	new_info.channels = channel_found
	for(var/obj/structure/metal_channel/setter in channel_found)
		QDEL_NULL(setter.info)
		setter.group_reagents = new_reagents
		setter.update_appearance(UPDATE_OVERLAYS)
		setter.info = new_info

/obj/structure/metal_channel/proc/reassess_group(turf/old_turf)
	var/datum/metal_channel_info/listed_info = info
	info.channels -= src
	var/pre_total = group_reagents.total_volume

	var/true_value = 0
	for(var/list in connected)
		if(!connected[list])
			continue
		true_value++

	if(true_value == 1) //we are connected with 1 junction so we just need to remove this and thats it
		return

	var/list/assumed_channels = list()
	for(var/direction2 in GLOB.cardinals)
		var/list/channel_found = list()
		var/list/nested_steps = list()
		var/turf/step2 = get_step(old_turf, text2num(direction2))
		var/obj/structure/metal_channel/channel = locate(/obj/structure/metal_channel) in step2
		if(!channel)
			continue
		if(channel == src)
			continue
		if((channel in assumed_channels) || (channel in channel_found))
			continue
		channel_found |= channel
		nested_steps |= channel

		while(length(nested_steps))
			var/obj/structure/metal_channel/nest = nested_steps[1]
			nested_steps -= nest
			for(var/direction in GLOB.cardinals)
				var/turf/step = get_step(nest, text2num(direction))
				var/obj/structure/metal_channel/nest_channel = locate(/obj/structure/metal_channel) in step
				if(!nest_channel)
					continue
				if(nest_channel == src)
					continue
				if((nest_channel in assumed_channels) || (nest_channel in channel_found))
					continue
				channel_found |= nest_channel
				nested_steps |= nest_channel

		if(length(channel_found) == length(listed_info.channels))
			return

		var/datum/metal_channel_info/new_info = new
		new_info.channels = channel_found
		var/datum/reagents/new_group_reagents = new
		new_group_reagents.maximum_volume = 1000000

		var/per_item = FLOOR(pre_total /length(listed_info.channels),1)
		group_reagents.trans_to(new_group_reagents, per_item * length(channel_found), preserve_data = TRUE)
		for(var/obj/structure/metal_channel/listed_channel as anything in channel_found)
			listed_channel.group_reagents = new_group_reagents
			listed_channel.info = new_info
			listed_channel.update_appearance(UPDATE_OVERLAYS)

	info = null
	group_reagents =null

/obj/structure/metal_channel/attackby(obj/item/I, mob/user, list/modifiers)
	. = ..()
	if(!istype(I, /obj/item/reagent_containers) && !istype(I, /obj/item/storage/crucible))
		return
	var/datum/reagent/molten_metal/metal = I.reagents.get_reagent(/datum/reagent/molten_metal)
	if(!metal)
		return

	user.visible_message("[user] starts pouring molten metal into [src].", "You start pouring molten metal into [src]")
	if(!do_after(user, 2 SECONDS, src))
		return
	group_reagents.add_reagent(/datum/reagent/molten_metal, metal.volume, data = metal.data, reagtemp = I.reagents.chem_temp)
	I.reagents.remove_reagent(/datum/reagent/molten_metal, metal.volume)
	I.update_appearance(UPDATE_OVERLAYS)

	for(var/obj/structure/metal_channel/setter in info?.channels)
		setter.update_appearance(UPDATE_OVERLAYS)
