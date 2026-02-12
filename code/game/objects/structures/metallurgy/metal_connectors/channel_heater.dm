/obj/structure/channel_connector/heater
	name = "channel heater"
	desc = "A furnace-like device that connects to metal channels to reheat molten metal as it flows through."

	icon = 'icons/roguetown/weapons/crucible.dmi'
	icon_state = "heater"

	anchored = TRUE
	density = TRUE

	var/datum/reagents/internal_reagents
	var/on = FALSE
	var/fuel_left = 0
	var/max_fuel = 300
	var/target_temperature = 1800
	var/current_temperature = 300
	var/heating_rate = 50
	var/transfer_amount = 10

/obj/structure/channel_connector/heater/Initialize()
	. = ..()
	connected_dirs = list(TEXT_WEST, TEXT_EAST)
	main_material = pick(typesof(/datum/material/clay))
	set_material_information()

	internal_reagents = new()
	internal_reagents.maximum_volume = 200
	START_PROCESSING(SSobj, src)

/obj/structure/channel_connector/heater/Destroy()
	STOP_PROCESSING(SSobj, src)
	qdel(internal_reagents)
	return ..()

/obj/structure/channel_connector/heater/examine(mob/user)
	. = ..()
	if(on)
		. += "The heater is currently [on ? "running" : "off"]."
		. += "Temperature: [current_temperature - 271.3]°C"
		. += "Fuel remaining: [fuel_left] units"
	else
		. += "The heater is off and cold."

	if(internal_reagents?.total_volume)
		var/datum/reagent/molten_metal/metal = internal_reagents.get_reagent(/datum/reagent/molten_metal)
		if(metal)
			for(var/datum/material/material as anything in metal.data)
				if(!ispath(material))
					continue
				var/total_volume = metal.data[material]
				var/reagent_color = initial(material.color)
				var/tag = internal_reagents.chem_temp >= initial(material.melting_point) ? "Molten" : "Hardened"
				. += "Contains [total_volume] units of <font color=[reagent_color]>[tag] [initial(material.name)]</font>"

/obj/structure/channel_connector/heater/attackby(obj/item/I, mob/living/user, list/modifiers)
	// Fuel the heater
	if(I.firefuel > 0)
		if(fuel_left >= max_fuel)
			to_chat(user, "<span class='warning'>[src] is already fully fueled.</span>")
			return

		var/fuel_to_add = min(I.firefuel, max_fuel - fuel_left)
		fuel_left += fuel_to_add

		qdel(I)

		user.visible_message("[user] fuels [src].", "You fuel [src].")
		return

	// Light the heater
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

	return ..()

/obj/structure/channel_connector/heater/process()
	if(!on || !fuel_left)
		if(on)
			on = FALSE
			update_appearance(UPDATE_OVERLAYS)
		current_temperature = max(300, current_temperature - 10)
		internal_reagents?.expose_temperature(current_temperature, 1)
		return

	fuel_left = max(0, fuel_left - 1)
	if(current_temperature < target_temperature)
		current_temperature = min(target_temperature, current_temperature + heating_rate)
	internal_reagents.expose_temperature(current_temperature, 1)

	var/obj/structure/metal_channel/input = connected_channels[TEXT_WEST]
	if(input?.group_reagents?.total_volume > 0)
		var/datum/reagent/molten_metal/input_metal = input.group_reagents.get_reagent(/datum/reagent/molten_metal)
		if(input_metal && internal_reagents.total_volume + transfer_amount <= internal_reagents.maximum_volume)
			var/transferred = min(transfer_amount, input_metal.volume)
			input.group_reagents.trans_to(internal_reagents, transferred, preserve_data = TRUE)

			for(var/obj/structure/metal_channel/channel in input.info?.channels)
				channel.update_appearance(UPDATE_OVERLAYS)

	var/obj/structure/metal_channel/output = connected_channels[TEXT_EAST]
	if(output && internal_reagents.total_volume > 0)
		var/datum/reagent/molten_metal/internal_metal = internal_reagents.get_reagent(/datum/reagent/molten_metal)
		if(internal_metal)
			var/to_transfer = min(transfer_amount, internal_metal.volume)
			internal_reagents.trans_to(output.group_reagents, to_transfer, preserve_data = TRUE)
			for(var/obj/structure/metal_channel/channel in output.info?.channels)
				channel.update_appearance(UPDATE_OVERLAYS)

	update_appearance(UPDATE_OVERLAYS)

/obj/structure/channel_connector/heater/update_overlays()
	. = ..()

	if(on)
		. += mutable_appearance(icon, "heater_flame")
		. += emissive_appearance(icon, "heater_flame", alpha = 200)

	if(internal_reagents?.total_volume > 0)
		var/datum/reagent/molten_metal/metal = internal_reagents.get_reagent(/datum/reagent/molten_metal)
		var/datum/material/largest = metal?.largest_metal
		if(largest)
			. += mutable_appearance(
				icon,
				"heater_metal",
				color = initial(largest.color),
				alpha = 255 * (internal_reagents.total_volume / internal_reagents.maximum_volume),
				appearance_flags = (RESET_COLOR | KEEP_APART),
			)

			if(initial(largest.red_hot) && internal_reagents.chem_temp > initial(largest.melting_point))
				. += emissive_appearance(icon, "heater_metal", alpha = 150)
