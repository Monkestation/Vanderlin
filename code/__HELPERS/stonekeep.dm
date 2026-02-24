/proc/assemble_body_markings_from_set(datum/body_marking_set/BMS, list/features, datum/species/pref_species)
	return assemble_body_markings_from_list(BMS.body_marking_list, features, pref_species)

/proc/assemble_body_markings_from_list(list/passed_body_markings, list/features, datum/species/pref_species)
	var/list/body_markings = list()
	for(var/set_type in passed_body_markings)
		var/datum/body_marking/BM = GLOB.body_markings_by_type[set_type]
		var/set_name = BM.name
		for(var/zone in GLOB.body_markings_per_limb)
			var/list/marking_list = GLOB.body_markings_per_limb[zone]
			if(set_name in marking_list)
				if(!body_markings[zone])
					body_markings[zone] = list()
				body_markings[zone][set_name] = BM.get_default_color(features, pref_species)
	return body_markings

/proc/marking_list_of_zone_for_species(zone, datum/species/species)
	var/list/compiled_list = list()
	var/list/zone_list_cache = GLOB.body_markings_per_limb[zone]
	var/list/global_lookup_cache = GLOB.body_markings_by_type
	for(var/set_type in species.body_markings)
		var/datum/body_marking/body_marking = global_lookup_cache[set_type]
		if(!(body_marking.name in zone_list_cache))
			continue
		compiled_list[body_marking.name] = body_marking
	return compiled_list

/proc/marking_sets_for_species(datum/species/species)
	var/list/global_list_cache = GLOB.body_marking_sets_by_type
	var/list/compiled_list = list()
	for(var/set_type in species.body_marking_sets)
		var/datum/body_marking_set/marking_set = global_list_cache[set_type]
		compiled_list[marking_set.name] = marking_set
	return compiled_list

/proc/apply_markings_to_body_parts(list/list/markings, mob/living/carbon/human/human)
	for(var/obj/item/bodypart/bp as anything in human.bodyparts)
		var/zone = bp.body_zone
		var/aux_zone = bp.aux_zone
		if(markings[zone])
			bp.markings = markings[zone].Copy()
		else
			bp.markings = null
		if(markings[aux_zone])
			bp.aux_markings = markings[aux_zone].Copy()
		else
			bp.aux_markings = null
	human.update_body()
	human.update_body_parts()

/// Turns a color string such as "#FFFFFF#00FFFF" into a list of ("#FFFFFF", #00FFFF)
/proc/color_string_to_list(color_string)
	if(!color_string)
		return null
	. = list()
	var/list/split_colors = splittext(color_string, "#")
	for(var/color in 2 to length(split_colors))
		. += "#[split_colors[color]]"

/// Turns a list such as ("#FFFFFF", #00FFFF) into a color string of "#FFFFFF#00FFFF"
/proc/color_list_to_string(list/color_list)
	if(!islist(color_list))
		return null
	. = ""
	for(var/color in color_list)
		. += color

/proc/find_key_by_value(list/list, value)
	for(var/key in list)
		var/found_value = list[key]
		if(found_value == value)
			return key
	return null

/proc/is_human_part_visible(mob/living/carbon/human/human, flags_inv)
	if(!istype(human))
		return TRUE
	if(flags_inv == NONE)
		return TRUE
	var/list/worn_items = get_all_worn_items(human)
	for(var/obj/item/item as anything in worn_items)
		if(item.flags_inv & flags_inv)
			return FALSE
	return TRUE

/proc/get_all_worn_items(mob/living/carbon/human/human)
	var/list/worn_items = list()
	for(var/slot in DEFAULT_SLOT_PRIORITY)
		var/obj/item/item = human.get_item_by_slot(slot)
		if(!item)
			continue
		worn_items += item
	return worn_items
