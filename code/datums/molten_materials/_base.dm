/datum/reagent/molten_metal
	name = "Molten "

	metabolization_rate = REAGENTS_METABOLISM * 4

	var/datum/material/largest_metal

/datum/reagent/molten_metal/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1, touch_protection = 0)
	. = ..()
	if(method & INGEST)
		for(var/datum/material_trait/trait as anything in initial(largest_metal.traits))
			var/datum/material_trait/new_trait = GLOB.material_traits[trait]
			new_trait.on_consume(M, reac_volume)

/datum/reagent/molten_metal/on_mob_life(mob/living/carbon/M)
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

	var/list/materials = list()
	for(var/datum/material/material as anything in incoming_data)
		if(!ispath(material))
			continue
		materials |= material

	if(length(materials) == 1)
		var/datum/material/material_type = materials[1]
		name = "Molten [initial(material_type.name)]"
	else
		name = "Molten Metals"

	data = incoming_data
	try_metal_merge()
	find_largest_metal()

/datum/reagent/molten_metal/on_merge(list/incoming_data)
	. = ..()
	if(!length(incoming_data))
		return
	name = "Molten Metals"

	for(var/datum/material/material as anything in incoming_data)
		if(!ispath(material))
			continue
		data |= material
		data[material] += incoming_data[material]

	try_metal_merge()
	find_largest_metal()

/datum/reagent/molten_metal/on_temp_change(chem_temp)
	. = ..()
	if(!chem_temp)
		return
	try_metal_merge()
	find_largest_metal()


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

	if(length(data) == 1)
		var/datum/material/material_type = data[1]
		name = "Molten [initial(material_type.name)]"

	find_largest_metal()

/datum/reagent/molten_metal/proc/find_largest_metal()

	var/largest
	for(var/datum/material/material as anything in data)
		if(!ispath(material))
			continue
		if(!largest)
			largest = material
			continue
		if(data[material] > data[largest])
			largest = material

	largest_metal = largest
	color = initial(largest_metal.color)
