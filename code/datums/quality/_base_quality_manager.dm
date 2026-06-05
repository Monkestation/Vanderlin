/proc/create_quality_item(obj/item/base_item, datum/quality_calculator/calculator)
	if(!calculator || !base_item)
		return base_item

	calculator.apply_quality_to_item(base_item)
	return base_item

/datum/quality_calculator
	var/name = "Generic Quality"
	var/material_quality = 0
	var/skill_quality = 0
	var/num_components = 1
	var/reagent_quality = 0

	/// AList of Quality descriptors - generalized now so we can give them better modifiers
	var/alist/quality_descriptors = alist()

/datum/quality_calculator/New(mat_qual = 0, skill_qual = 0, components = 1, reagent_qual = 0)
	material_quality = mat_qual
	skill_quality = skill_qual
	num_components = max(1, components)
	reagent_quality = reagent_qual

/datum/quality_calculator/proc/calculate_final_quality()
	return

/datum/quality_calculator/proc/get_quality_tier(quality_value)
	var/best_tier
	for(var/tier in quality_descriptors)
		if(quality_value >= tier && (isnull(best_tier) || tier > best_tier))
			best_tier = tier
	return best_tier

/datum/quality_calculator/proc/get_quality_data(quality_value = null)
	if(isnull(quality_value))
		quality_value = calculate_final_quality()

	var/tier = get_quality_tier(quality_value)
	return quality_descriptors[tier]

/datum/quality_calculator/proc/apply_quality_to_item(obj/item/target, track_creation = FALSE, quality_override)
	if(!target)
		return FALSE

	var/final_quality = quality_override ? quality_override : calculate_final_quality()
	var/list/quality_data = get_quality_data(final_quality)
	if(!quality_data)
		return FALSE

	// Apply name prefix
	var/name_prefix = quality_data["name_prefix"]
	if(islist(name_prefix))
		name_prefix = pick(name_prefix)
	if(name_prefix && name_prefix != "")
		target.name = "[name_prefix] [target.name]"

	// Apply description prefix
	var/description_prefix = quality_data["description"]
	if(islist(description_prefix))
		description_prefix = pick(description_prefix)
	if(description_prefix && description_prefix != "")
		target.desc += "\n[description_prefix]"

	// Apply sellprice modifier
	var/modifier = quality_data["price_modifier"]
	if(target.sellprice)
		target.sellprice *= modifier

	if(track_creation)
		track_item_creation(target, final_quality)

	return quality_data // cheeky way to send quality_data list to child proc calls

/datum/quality_calculator/proc/track_item_creation(obj/item/target, final_quality)
	return
