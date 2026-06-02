/datum/reagent/molten_metal
	name = "Molten "

	metabolization_rate = REAGENTS_METABOLISM * 4
	base_recipe_quality = SMELTERY_QUALITY_NORMAL

	var/datum/material/largest_metal

/datum/reagent/molten_metal/on_new(list/incoming_data)
	. = ..()
	RegisterSignal(holder, COMSIG_REAGENTS_TEMP_CHANGE, PROC_REF(on_temp_change))

/datum/reagent/molten_metal/Destroy()
	UnregisterSignal(holder, COMSIG_REAGENTS_TEMP_CHANGE)
	return ..()

/datum/reagent/molten_metal/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(methods & INGEST)
		for(var/datum/material_trait/trait as anything in initial(largest_metal.traits))
			var/datum/material_trait/new_trait = GLOB.material_traits[trait]
			new_trait.on_consume(exposed_mob, reac_volume)

/datum/reagent/molten_metal/on_mob_life(mob/living/carbon/M, efficiency)
	. = ..()
	M.adjustFireLoss(5)
	to_chat(M, span_danger("[src] is burning up insides!"))
	for(var/datum/material_trait/trait as anything in initial(largest_metal.traits))
		var/datum/material_trait/new_trait = GLOB.material_traits[trait]
		new_trait.on_life(M)

/datum/reagent/molten_metal/on_new(list/incoming_data)
	. = ..()
	if(!length(incoming_data))
		return

	try_metal_merge()

/datum/reagent/molten_metal/on_merge(list/incoming_data)
	. = ..()
	if(!length(incoming_data))
		return

	for(var/datum/material/material as anything in incoming_data)
		if(!ispath(material))
			continue
		data |= material
		data[material] += incoming_data[material]

	try_metal_merge()

/datum/reagent/molten_metal/proc/on_temp_change(datum/source, new_temp, old_temp)
	SIGNAL_HANDLER
	if(new_temp < old_temp)
		return

	try_metal_merge()

/datum/reagent/molten_metal/proc/try_metal_merge()
	for(var/datum/molten_recipe/recipe as anything in GLOB.molten_recipes)
		var/multiplier = recipe.try_create(data, holder.chem_temp)
		if(!multiplier)
			continue

		for(var/datum/material/material as anything in recipe.materials_required)
			data[material] -= recipe.materials_required[material] * multiplier
			if(!data[material])
				data -= material

		for(var/datum/material/material as anything in recipe.output)
			data |= material
			data[material] += recipe.output[material] * multiplier

	find_largest_metal()

/datum/reagent/molten_metal/proc/find_largest_metal()
	var/largest
	var/name_found = FALSE
	var/total_volume = 0
	for(var/datum/material/material_type as anything in data)
		if(!ispath(material_type))
			continue

		total_volume += data[material_type]

		if(!name_found)
			name = "Molten [initial(material_type.name)]"
			name_found = TRUE
		else
			name = "Molten Metals"

		if(!largest)
			largest = material_type
			continue
		if(data[material_type] > data[largest])
			largest = material_type

	largest_metal = largest
	color = initial(largest_metal.color)

	volume = total_volume
	holder.update_total()
