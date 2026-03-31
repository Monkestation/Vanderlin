GLOBAL_LIST_INIT(molten_recipes, list())

/datum/molten_recipe
	abstract_type = /datum/molten_recipe
	var/name = "Generic Molten Recipe"
	var/category = "Metallurgy"

	var/list/materials_required = list()
	var/list/output = list()

	var/temperature_required

/datum/molten_recipe/proc/try_create(list/reagent_data, temperature)
	if(temperature < temperature_required)
		return FALSE

	var/list/materials_copy = materials_required.Copy()

	var/list/cared_values = list()
	for(var/item in reagent_data)
		if(!(item in materials_copy))
			continue
		cared_values |= item
		cared_values[item] = reagent_data[item]

	if(!length(cared_values) == length(materials_required))
		return

	var/smallest_multiplier = 0
	for(var/datum/material/material as anything in materials_copy)
		if(cared_values[material] < materials_copy[material])
			return
		var/multiplier = FLOOR(cared_values[material] / materials_copy[material], 1)
		if(!smallest_multiplier || (multiplier < smallest_multiplier))
			smallest_multiplier = multiplier

	return smallest_multiplier


/datum/molten_recipe/bronze
	name = "Bronze"
	materials_required = list(
		/datum/material/copper = 9,
		/datum/material/tin = 1,
	)
	temperature_required = 1423.15
	output = list(
		/datum/material/bronze = 10,
	)

/datum/molten_recipe/blacksteel
	name = "Blacksteel"
	materials_required = list(
		/datum/material/steel = 6,
		/datum/material/silver = 4,
	)
	temperature_required = 1953.15
	output = list(
		/datum/material/blacksteel = 10,
	)
