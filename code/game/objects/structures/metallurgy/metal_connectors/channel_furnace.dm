/obj/structure/channel_connector/furnace
	name = "channel furnace"
	desc = "A large furnace that connects to metal channels, acting like a crucible to melt items and output molten metal. The storage can be opened and closed with RMB."

	icon = 'icons/roguetown/weapons/crucible.dmi'
	icon_state = "furnace"

	anchored = TRUE
	density = TRUE

	var/datum/reagents/internal_reagents
	var/on = FALSE
	var/fuel_left = 0
	var/max_fuel = 500
	var/furnace_temperature = 300
	var/max_temperature = 2000
	var/opened = FALSE

	var/list/melting_pot = list()
	var/output_rate = 15 // How much molten metal to output per tick

/obj/structure/channel_connector/furnace/Initialize()
	. = ..()
	connected_dirs = list(TEXT_SOUTH) //hell non-constant
	main_material = pick(typesof(/datum/material/clay))
	set_material_information()

	internal_reagents = new()
	internal_reagents.maximum_volume = 1000
	internal_reagents.my_atom = src

	AddComponent(/datum/component/storage/concrete/grid/crucible)

	START_PROCESSING(SSobj, src)

/obj/structure/channel_connector/furnace/Destroy()
	STOP_PROCESSING(SSobj, src)
	qdel(internal_reagents)
	for(var/obj/item/item in melting_pot)
		item.forceMove(get_turf(src))
		melting_pot -= item
	return ..()

/obj/structure/channel_connector/furnace/update_icon_state()
	. = ..()
	if(opened)
		icon_state = "furnace_open"
	else
		icon_state = initial(icon_state)

/obj/structure/channel_connector/furnace/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	user.visible_message(span_danger("[user] starts to [opened ? "close" : "open"] [src]."), span_danger("You start to [opened ? "close" : "open"] [src]."))
	if(!do_after(user, 2.5 SECONDS, src))
		return
	opened = !opened
	update_appearance(UPDATE_ICON_STATE)
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_HIDE_ALL)

/obj/structure/channel_connector/furnace/examine(mob/user)
	. = ..()
	if(furnace_temperature)
		. += "The furnace is around [furnace_temperature - 271.3]°C"

	if(length(melting_pot))
		. += "Items melting inside:"
		for(var/obj/item/atom in melting_pot)
			var/datum/material/material = atom.melting_material
			. += "<font color=[initial(material.color)]> [atom.name] </font> - [FLOOR((melting_pot[atom] / atom.melt_amount) * 100, 1)]% Melted"

	if(internal_reagents?.total_volume)
		var/datum/reagent/molten_metal/metal = internal_reagents.get_reagent(/datum/reagent/molten_metal)
		if(metal)
			for(var/datum/material/material as anything in metal.data)
				if(!ispath(material))
					continue
				var/tag = "Molten"
				if(internal_reagents.chem_temp < material.melting_point)
					tag = "Hardened"
				var/total_volume = metal.data[material]
				var/reagent_color = initial(material.color)
				. += "It contains [UNIT_FORM_STRING(total_volume)] of <font color=[reagent_color]> [tag] [initial(material.name)].</font>"

/obj/structure/channel_connector/furnace/attackby(obj/item/I, mob/living/user, list/modifiers)
	// Fuel the furnace
	if(I.firefuel > 0)
		if(fuel_left >= max_fuel)
			to_chat(user, "<span class='warning'>[src] is already fully fueled.</span>")
			return

		var/fuel_to_add = min(I.firefuel, max_fuel - fuel_left)
		fuel_left += fuel_to_add

		qdel(I)

		user.visible_message("[user] fuels [src].", "You fuel [src].")
		return

	// Light the furnace
	if(istype(I, /obj/item/flint) || istype(I, /obj/item/flashlight/flare/torch))
		if(!fuel_left)
			to_chat(user, "<span class='warning'>[src] needs fuel before it can be lit.</span>")
			return

		if(on)
			to_chat(user, "<span class='warning'>[src] is already running.</span>")
			return

		on = TRUE
		user.visible_message("[user] lights [src].", "You light [src].")
		update_appearance(UPDATE_OVERLAYS)
		return

	// Let the storage component handle item insertion
	return ..()

/obj/structure/channel_connector/furnace/process()
	if(!on || !fuel_left)
		if(on)
			on = FALSE
			update_appearance(UPDATE_OVERLAYS)
		furnace_temperature = max(300, furnace_temperature - 15)
		internal_reagents?.expose_temperature(furnace_temperature, 1)
		return

	// Consume fuel
	fuel_left = max(0, fuel_left - 2)

	// Heat up - similar to crucible heating logic
	if(furnace_temperature < max_temperature)
		furnace_temperature = min(max_temperature, furnace_temperature + 100)

	// Heat internal reagents
	internal_reagents.expose_temperature(furnace_temperature, 1)

	// Process items for melting - exactly like crucible
	for(var/obj/item/item in contents)
		if(!item.melting_material)
			continue

		var/datum/material/material = item.melting_material
		if(furnace_temperature < initial(material.melting_point))
			melting_pot -= item // Remove from melting pot if too cold
			continue

		melting_pot |= item // Add to melting pot if hot enough
		melting_pot[item] += 5 // Same melting rate as crucible

		if(melting_pot[item] >= item.melt_amount)
			melt_item(item)

	// Output molten metal to connected channel
	var/obj/structure/metal_channel/output = connected_channels[TEXT_SOUTH]
	if(output && internal_reagents.total_volume > 0)
		var/datum/reagent/molten_metal/internal_metal = internal_reagents.get_reagent(/datum/reagent/molten_metal)
		if(internal_metal)
			var/to_transfer = min(output_rate, internal_metal.volume)
			internal_reagents.trans_to(output.group_reagents, to_transfer, preserve_data = TRUE)

			// Update output channel group
			for(var/obj/structure/metal_channel/channel in output.info?.channels)
				channel.update_appearance(UPDATE_OVERLAYS)

	update_appearance(UPDATE_OVERLAYS)

/obj/structure/channel_connector/furnace/proc/melt_item(obj/item/item)
	// Use the same logic as crucible for removing from storage
	SEND_SIGNAL(item.loc, COMSIG_TRY_STORAGE_TAKE, item, get_turf(src), TRUE)

	var/list/data = list()
	data |= item.melting_material
	data[item.melting_material] = item.melt_amount

	// Get quality from the item - same logic as crucible
	var/item_quality = 1
	if(istype(item, /obj/item/ore))
		var/obj/item/ore/ore_item = item
		item_quality = ore_item.recipe_quality
	else if(istype(item, /obj/item/natural/rock))
		var/obj/item/natural/rock/rock_item = item
		item_quality = rock_item.recipe_quality
	else if(item.recipe_quality)
		item_quality = item.recipe_quality

	// Set quality in the data for the reagent system
	data["quality"] = item_quality

	internal_reagents.add_reagent(/datum/reagent/molten_metal, item.melt_amount, data, furnace_temperature)
	melting_pot -= item
	qdel(item)

/obj/structure/channel_connector/furnace/update_overlays()
	. = ..()

	if(on)
		. += mutable_appearance(icon, "furnace_flame")
		. += emissive_appearance(icon, "furnace_flame", alpha = 255)

	if(internal_reagents?.total_volume > 0)
		var/used_alpha = mix_alpha_from_reagents(internal_reagents.reagent_list)
		. += mutable_appearance(
			icon,
			"furnace_metal",
			color = mix_color_from_reagents(internal_reagents.reagent_list),
			alpha = used_alpha,
			appearance_flags = (RESET_COLOR | KEEP_APART),
		)

		var/datum/reagent/molten_metal/metal = internal_reagents.get_reagent(/datum/reagent/molten_metal)
		var/datum/material/largest = metal?.largest_metal

		if(initial(largest?.red_hot) && internal_reagents.chem_temp > initial(largest.melting_point))
			. += emissive_appearance(icon, "furnace_metal", alpha = used_alpha)
