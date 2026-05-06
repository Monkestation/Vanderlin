/obj/item/storage/crucible
	name = "crucible"
	desc = "A large crucible in which metal items can be molten down."
	layer = ABOVE_ALL_MOB_LAYER

	icon = 'icons/roguetown/weapons/crucible.dmi'
	icon_state = "crucible"
	component_type = /datum/component/storage/concrete/grid/crucible
	grid_width = 64
	grid_height = 96

	item_weight = 2 KILOGRAMS
	w_class = WEIGHT_CLASS_BULKY

	var/crucible_temperature = 300

	var/list/melting_pot = list()

/obj/item/storage/crucible/set_material_information()
	. = ..()
	name = "[lowertext(initial(main_material.name))] crucible"

/obj/item/storage/crucible/Initialize()
	. = ..()
	create_reagents(5000)
	color = pick("#766f8c", "#565c5c", "#8d3a2d", "#4f3524")
	START_PROCESSING(SSobj, src)

/obj/item/storage/crucible/create_reagents(max_vol, flags)
	. = ..()
	RegisterSignal(reagents, COMSIG_REAGENTS_HOLDER_UPDATED, PROC_REF(on_reagent_change))

/obj/item/storage/crucible/examine(mob/user)
	. = ..()
	if(crucible_temperature)
		. += "The crucible is around [crucible_temperature - T0C]C"
	if(length(melting_pot))
		for(var/obj/item/atom in melting_pot)
			var/datum/material/material = atom.melting_material
			var/total_amount = atom.melt_amount || 100
			. += "<font color=[initial(material.color)]> [atom.name] </font> - [FLOOR((melting_pot[atom] / total_amount) * 100, 1)]% Melted"
	var/datum/reagent/molten_metal/metal = reagents.get_reagent(/datum/reagent/molten_metal)
	if(!metal)
		return
	for(var/datum/material/material as anything in metal.data)
		if(!ispath(material))
			continue
		var/tag = "Molten"
		if(reagents.chem_temp < material.melting_point)
			tag = "Hardened"
		var/total_volume = metal.data[material]
		var/reagent_color = initial(material.color)
		. += "It contains [UNIT_FORM_STRING(total_volume)] of <font color=[reagent_color]> [tag] [initial(material.name)].</font>"

/obj/item/storage/crucible/process(delta_time)
	var/obj/machinery/light/fueled/smelter/smelter = loc
	var/obj/machinery/light/fueled/light = locate(/obj/machinery/light/fueled) in get_turf(src)
	if(istype(smelter) && smelter?.on)
		crucible_temperature = max(300, min(smelter.max_crucible_temperature, crucible_temperature + 100))
	else if(light?.on)
		if(crucible_temperature > 1300)
			crucible_temperature = max(300, crucible_temperature - 1)
		else
			crucible_temperature = max(300, min(1300, crucible_temperature + 100))
	else
		crucible_temperature = max(300, crucible_temperature - 10)

	reagents.expose_temperature(crucible_temperature, 1)

	for(var/obj/item/item in contents)
		var/datum/material/material = item.melting_material
		var/melty = item.melt_amount
		if(!material)
			var/obj/item/ingot/ingot = item.smeltresult
			if(!ispath(ingot))
				continue
			material = initial(ingot.melting_material)
			melty = 100
			if(!material)
				continue

		if(crucible_temperature < initial(material.melting_point))
			melting_pot -= item
			continue
		melting_pot[item] += 5 * delta_time
		if(melting_pot[item] >= melty)
			melt_item(item)

/obj/item/storage/crucible/get_temperature()
	return crucible_temperature

/obj/item/storage/crucible/tong_interaction(atom/target, mob/user)
	if(istype(target, /obj/item/mould))
		target.attackby(src, user)
		return TRUE

/obj/item/storage/crucible/update_overlays()
	. = ..()

	if(!reagents.total_volume)
		return
	var/used_alpha = mix_alpha_from_reagents(reagents.reagent_list)
	. += mutable_appearance(
		icon,
		"filling",
		color = mix_color_from_reagents(reagents.reagent_list),
		alpha = used_alpha,
		appearance_flags = (RESET_COLOR | KEEP_APART),
	)
	var/datum/reagent/molten_metal/metal = reagents.get_reagent(/datum/reagent/molten_metal)
	var/datum/material/largest = metal?.largest_metal

	if(initial(largest?.show_as_filling) && reagents.chem_temp > initial(largest.melting_point))
		. += emissive_appearance(icon, "filling", alpha = used_alpha)

/obj/item/storage/crucible/proc/melt_item(obj/item/item)
	SEND_SIGNAL(item.loc, COMSIG_TRY_STORAGE_TAKE, item, get_turf(src), TRUE)
	var/list/data = list()
	var/datum/material/material = item.melting_material
	var/melty = item.melt_amount
	if(!material)
		var/obj/item/ingot = item.smeltresult
		material = initial(ingot.melting_material)
		melty = 100
	if(!material)
		return

	data[material] = melty

	// Get quality from the item
	var/item_quality = SMELTERY_QUALITY_NORMAL
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

	reagents.add_reagent(/datum/reagent/molten_metal, melty, data, crucible_temperature)
	melting_pot -= item
	qdel(item)

/obj/item/storage/crucible/proc/on_reagent_change(datum/reagents/holder, ...)
	SIGNAL_HANDLER
	update_appearance(UPDATE_OVERLAYS)

/obj/item/storage/crucible/random/Initialize()
	. = ..()
	main_material = pick(typesof(/datum/material/clay))
	set_material_information()

/obj/item/storage/crucible/test_crucible
	var/list/material_data_to_add = list(
		/datum/material/copper = 18,
		/datum/material/tin = 2
	)
	crucible_temperature = 1500

/obj/item/storage/crucible/test_crucible/Initialize()
	. = ..()
	var/total_volume = 0
	for(var/i in material_data_to_add)
		total_volume += material_data_to_add[i]
	reagents.add_reagent(/datum/reagent/molten_metal, total_volume, data = material_data_to_add, reagtemp = 4000)

/obj/item/storage/crucible/test_crucible/bar
	material_data_to_add = list(
		/datum/material/copper = 90,
		/datum/material/tin = 10,
	)

/obj/item/storage/crucible/test_crucible/copper
	material_data_to_add = list(
		/datum/material/copper = 100,
	)

/obj/item/storage/crucible/test_crucible/tin
	material_data_to_add = list(
		/datum/material/tin = 100,
	)

/obj/item/storage/crucible/test_crucible/gold
	material_data_to_add = list(
		/datum/material/gold = 100,
	)

/obj/item/storage/crucible/test_crucible/silver
	material_data_to_add = list(
		/datum/material/silver = 100,
	)

/obj/item/storage/crucible/test_crucible/steel
	material_data_to_add = list(
		/datum/material/steel = 100,
	)

/obj/item/storage/crucible/test_crucible/blacksteel
	material_data_to_add = list(
		/datum/material/blacksteel = 100,
	)

/obj/item/storage/crucible/test_crucible/everything
	material_data_to_add = list(
		/datum/material/blacksteel = 1,
		/datum/material/copper = 1,
		/datum/material/iron = 1,
		/datum/material/steel = 1,
		/datum/material/gold = 2,
		/datum/material/bronze = 1,
		/datum/material/silver = 1,
	)
