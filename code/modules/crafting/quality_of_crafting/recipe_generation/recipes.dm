// Base return_recipe_data — returns null by default so unknown
// types are silently skipped.
/datum/proc/return_recipe_data()
	return null

/// Converts a typepath=count assoc list into a serialisable list of dicts.
/// "_path" is embedded so the book can discover linked recipe data from items.
/datum/proc/items_list(list/L, subtypes_ok = FALSE)
	var/list/out = list()
	for(var/atom/path as anything in L)
		var/count = L[path]
		out += list(list(
			"name" = initial(path.name),
			"icon" = "[initial(path.icon)]",
			"icon_state" = "[initial(path.icon_state)]",
			"count" = count,
			"any" = subtypes_ok,
			"_path" = "[path]",
		))
	return out

/datum/proc/tools_list(list/L, subtypes_ok = FALSE)
    var/list/out = list()
    for(var/atom/path as anything in L)
        out += list(list(
            "name" = initial(path.name),
            "icon" = "[initial(path.icon)]",
            "icon_state" = "[initial(path.icon_state)]",
            "any" = subtypes_ok,
            "_path" = "[path]",
        ))
    return out

/// Converts a reagent typepath=amount assoc list
/datum/proc/reagents_list(list/L)
	var/list/out = list()
	for(var/datum/reagent/path as anything in L)
		var/count = L[path]
		out += list(list(
			"name" = initial(path.name),
			"amount" = count,
		))
	return out


/datum/repeatable_crafting_recipe/return_recipe_data()
	var/list/data = list()
	data["type"] = "repeatable"
	data["name"] = name
	data["category"] = category

	data["requirements"] = items_list(requirements, subtypes_allowed)
	data["tools"] = tools_list(tool_usage, subtypes_allowed)
	data["reagents"] = reagents_list(reagent_requirements)

	if(craftdiff && skillcraft)
		data["skill_name"] = initial(skillcraft.name)
		data["skill_level"] = SSskills.level_names[min(craftdiff, length(SSskills.level_names))]
		data["skill_required"] = minimum_skill_level
	else if(skillcraft)
		data["skill_name"] = initial(skillcraft.name)
		data["skill_level"] = "None"
		data["skill_required"] = FALSE

	data["starting_name"] = initial(starting_atom.name)
	data["starting_icon"] = "[initial(starting_atom.icon)]"
	data["starting_state"] = "[initial(starting_atom.icon_state)]"
	data["_starting_path"] = "[starting_atom]"
	data["attacked_name"] = initial(attacked_atom.name)
	data["attacked_icon"] = "[initial(attacked_atom.icon)]"
	data["attacked_state"] = "[initial(attacked_atom.icon_state)]"
	data["_attacked_path"] = "[attacked_atom]"
	data["allow_inverse"] = allow_inverse_start

	if(output)
		data["output_name"] = initial(output.name)
		data["output_icon"] = "[initial(output.icon)]"
		data["output_state"] = "[initial(output.icon_state)]"
		data["output_count"] = output_amount
		data["_output_path"] = "[output]"

	return data


/datum/orderless_slapcraft/return_recipe_data()
	var/list/data = list()
	data["type"] = "orderless_slapcraft"
	data["name"] = name
	data["category"] = category

	if(related_skill)
		data["skill_name"] = initial(related_skill.name)

	data["starting_name"] = initial(starting_item.name)
	data["starting_icon"] = "[initial(starting_item.icon)]"
	data["starting_state"] = "[initial(starting_item.icon_state)]"

	var/list/reqs = list()
	for(var/atom/path as anything in requirements)
		var/count = requirements[path]
		if(islist(path))
			var/list/choices = list()
			for(var/atom/sub as anything in path)
				choices += list(list(
					"name" = initial(sub.name),
					"icon" = "[initial(sub.icon)]",
					"icon_state" = "[initial(sub.icon_state)]",
				))
			reqs += list(list("count" = count, "choices" = choices))
		else
			reqs += list(list(
				"name" = initial(path.name),
				"icon" = "[initial(path.icon)]",
				"icon_state" = "[initial(path.icon_state)]",
				"count" = count,
			))
	data["requirements"] = reqs

	if(finishing_item)
		data["finishing_name"] = initial(finishing_item.name)
		data["finishing_icon"] = "[initial(finishing_item.icon)]"
		data["finishing_state"] = "[initial(finishing_item.icon_state)]"

	return data


/datum/slapcraft_recipe/return_recipe_data()
	var/list/data = list()
	data["type"] = "slapcraft"
	data["name"] = name
	data["category"] = category

	var/list/steps_out = list()
	var/count = 0
	for(var/step_type in steps)
		count++
		var/datum/slapcraft_step/S = SLAPCRAFT_STEP(step_type)
		var/obj/item/item_path = S.item_types[1]
		var/list/step_entry = list(
			"name" = initial(item_path.name),
			"icon" = "[initial(item_path.icon)]",
			"icon_state" = "[initial(item_path.icon_state)]",
			"_path" = "[item_path]",
			"desc" = S.desc,
			"optional" = S.optional,
			"verb" = S.start_verb,
			"index" = count,
		)
		if(S.recipe_link)
			step_entry["recipe_link"] = "[S.recipe_link]"
		steps_out += list(step_entry)
	data["steps"] = steps_out

	if(result_type)
		data["output_name"] = initial(result_type.name)
		data["output_icon"] = "[initial(result_type.icon)]"
		data["output_state"] = "[initial(result_type.icon_state)]"
		data["_output_path"] = "[result_type]"

	return data


/datum/blueprint_recipe/return_recipe_data()
	var/list/data = list()
	data["type"] = "blueprint"
	data["name"] = name
	data["category"] = category
	data["desc"] = desc

	data["materials"] = items_list(required_materials)

	if(construct_tool)
		data["tool_name"] = initial(construct_tool.name)
		data["tool_icon"] = "[initial(construct_tool.icon)]"
		data["tool_state"] = "[initial(construct_tool.icon_state)]"
	else
		data["tool_name"] = "Hands"

	if(skillcraft)
		data["skill_name"] = initial(skillcraft.name)
		if(craftdiff > 0)
			data["skill_diff"] = craftdiff

	data["build_time"] = build_time * 0.1
	data["supports_directions"] = supports_directions
	data["floor_object"] = floor_object

	if(result_type)
		data["output_name"] = initial(result_type.name)
		data["output_icon"] = "[initial(result_type.icon)]"
		data["output_state"] = "[initial(result_type.icon_state)]"
		data["_output_path"] = "[result_type]"

	return data


/datum/container_craft/return_recipe_data()
	var/list/data = list()
	data["type"] = "container_craft"
	data["name"] = name
	data["category"] = category
	data["craft_verb"] = craft_verb
	data["crafting_time"] = crafting_time * 0.1

	data["requirements"] = items_list(requirements)
	data["reagents"] = reagents_list(reagent_requirements)

	if(length(wildcard_requirements))
		var/list/wc = list()
		for(var/atom/wt as anything in wildcard_requirements)
			wc += list(list("name" = wt.name, "count" = wildcard_requirements[wt]))
		data["wildcards"] = wc

	if(max_optionals > 0)
		data["max_optionals"] = max_optionals
		data["opt_items"] = items_list(optional_requirements)
		var/list/owc = list()
		for(var/atom/owt as anything in optional_wildcard_requirements)
			owc += list(list("name" = owt.name, "count" = optional_wildcard_requirements[owt]))
		data["opt_wildcards"] = owc

	if(required_container)
		data["container_name"] = initial(required_container.name)
		data["container_icon"] = "[initial(required_container.icon)]"
		data["container_state"] = "[initial(required_container.icon_state)]"
		data["_container_path"] = "[required_container]"

	if(output)
		data["output_name"] = output.name
		data["output_count"] = output_amount

	data["extra_html"] = extra_html()

	return data


/datum/molten_recipe/return_recipe_data()
	var/list/data = list()
	data["type"] = "molten"
	data["name"] = name
	data["category"] = category

	var/list/mats = list()
	for(var/atom/path as anything in materials_required)
		mats += list(list("name" = initial(path.name), "count" = materials_required[path]))
	data["materials"] = mats
	data["temperature_c"] = temperature_required - 273.15

	var/list/outs = list()
	for(var/atom/path as anything in output)
		outs += list(list("name" = initial(path.name), "count" = output[path]))
	data["outputs"] = outs

	return data


/datum/anvil_recipe/return_recipe_data()
	var/list/data = list()
	data["type"] = "anvil"
	data["name"] = name
	data["category"] = category

	data["bar_name"] = initial(req_bar.name)
	data["bar_icon"] = "[initial(req_bar.icon)]"
	data["bar_state"] = "[initial(req_bar.icon_state)]"
	data["_bar_path"] = "[req_bar]"
	data["extras"] = items_list(additional_items)

	data["output_name"] = initial(created_item.name)
	data["output_icon"] = "[initial(created_item.icon)]"
	data["output_state"] = "[initial(created_item.icon_state)]"
	data["output_count"] = createditem_extra + 1
	data["_output_path"] = "[created_item]"

	return data

/datum/artificer_recipe/return_recipe_data()
	var/list/data = list()
	data["type"] = "artificer"
	data["name"] = name
	data["category"] = category

	data["base_name"] = initial(required_item.name)
	data["base_icon"] = "[initial(required_item.icon)]"
	data["base_state"] = "[initial(required_item.icon_state)]"
	data["_base_path"] = "[required_item]"
	data["extras"] = items_list(additional_items)

	data["output_name"] = initial(created_item.name)
	data["output_icon"] = "[initial(created_item.icon)]"
	data["output_state"] = "[initial(created_item.icon_state)]"
	data["_output_path"] = "[created_item]"

	return data


/datum/pottery_recipe/return_recipe_data()
	var/list/data = list()
	data["type"] = "pottery"
	data["name"] = name
	data["category"] = category
	data["speed_sweetspot"] = speed_sweetspot

	var/list/steps = list()
	var/n = 0
	for(var/atom/path as anything in recipe_steps)
		n++
		steps += list(list(
			"name" = initial(path.name),
			"icon" = "[initial(path.icon)]",
			"icon_state" = "[initial(path.icon_state)]",
			"time_s" = step_to_time[n] / 10,
		))
	data["steps"] = steps

	data["output_name"] = initial(created_item.name)
	data["output_icon"] = "[initial(created_item.icon)]"
	data["output_state"] = "[initial(created_item.icon_state)]"
	data["_output_path"] = "[created_item]"

	return data


/datum/brewing_recipe/return_recipe_data()
	var/list/data = list()
	data["type"] = "brewing"
	data["name"] = name
	data["category"] = category
	data["brew_time_s"] = brew_time / 10

	if(helpful_hints)
		data["hints"] = helpful_hints
	if(heat_required)
		data["heat_c"] = heat_required - 273.1
	if(pre_reqs)
		data["prereq_name"] = initial(pre_reqs.name)
	if(length(age_times))
		data["ages"] = TRUE

	data["crops"] = items_list(needed_crops)
	data["items"] = items_list(needed_items)
	data["reagents"] = reagents_list(needed_reagents)

	if(brewed_amount)
		data["output_liquid"] = name
		data["output_volume"] = per_brew_amount * brewed_amount

	if(brewed_item)
		data["output_item_name"] = initial(brewed_item.name)
		data["output_item_icon"] = "[initial(brewed_item.icon)]"
		data["output_item_state"] = "[initial(brewed_item.icon_state)]"
		data["output_item_count"] = brewed_item_count
		data["_output_path"] = "[brewed_item]"

	if(length(age_times))
		var/list/ages = list()
		for(var/datum/reagent/path as anything in age_times)
			ages += list(list("name" = initial(path.name), "time_s" = age_times[path] * 0.1))
		data["age_stages"] = ages

	return data

/datum/runerituals/return_recipe_data()
	var/list/data = list()
	data["type"] = "runeritual"
	data["name"] = name
	data["category"] = category
	data["tier"] = tier
	data["items"] = items_list(required_atoms)
	return data


/datum/book_entry/return_recipe_data()
	var/list/data = list()
	data["type"] = "book_entry"
	data["name"] = name
	data["category"] = category
	data["html"] = inner_book_html(null)
	return data

/datum/alch_cauldron_recipe/return_recipe_data()
	var/list/data = list()
	data["type"] = "alch_cauldron"
	data["name"] = recipe_name
	data["category"] = category

	var/list/essences = list()
	for(var/datum/thaumaturgical_essence/path as anything in required_essences)
		essences += list(list("name" = path.name, "amount" = required_essences[path]))
	data["essences"] = essences

	var/list/r_out = list()
	for(var/datum/reagent/rpath in output_reagents)
		r_out += list(list("name" = initial(rpath.name), "amount" = output_reagents[rpath]))
	data["output_reagents"] = r_out

	var/list/i_out = list()
	for(var/atom/ipath as anything in output_items)
		i_out += list(list(
			"name" = initial(ipath.name),
			"icon" = "[initial(ipath.icon)]",
			"icon_state" = "[initial(ipath.icon_state)]",
			"count" = output_items[ipath],
		))
	data["output_items"] = i_out

	if(smells_like && smells_like != "nothing")
		data["smells_like"] = smells_like

	return data

/datum/essence_combination/return_recipe_data()
	var/list/data = list()
	data["type"] = "essence_combination"
	data["name"] = name
	data["category"] = category

	var/list/ins = list()
	for(var/datum/thaumaturgical_essence/path as anything in inputs)
		ins += list(list("name" = path.name, "amount" = inputs[path]))
	data["inputs"] = ins

	if(output_type)
		data["output_name"] = initial(output_type.name)
		data["output_amount"] = output_amount

	if(skill_required)
		data["skill_required"] = skill_required

	return data

/datum/essence_infusion_recipe/return_recipe_data()
	var/list/data = list()
	data["type"] = "essence_infusion"
	data["name"] = name
	data["category"] = category
	data["target_name"] = initial(target_type.name)
	data["target_icon"] = "[initial(target_type.icon)]"
	data["target_state"] = "[initial(target_type.icon_state)]"
	data["_target_path"] = "[target_type]"
	data["result_name"] = initial(result_type.name)
	data["result_icon"] = "[initial(result_type.icon)]"
	data["result_state"] = "[initial(result_type.icon_state)]"
	data["_result_path"] = "[result_type]"
	data["infusion_time"] = infusion_time * 0.1

	var/list/essences = list()
	for(var/datum/thaumaturgical_essence/path in required_essences)
		essences += list(list("name" = initial(path.name), "amount" = required_essences[path]))
	data["essences"] = essences

	return data

/datum/natural_precursor/return_recipe_data()
	var/list/data = list()
	data["type"] = "natural_precursor"
	data["name"] = name
	data["category"] = category

	var/list/yields = list()
	var/list/yield_names = list()
	for(var/datum/thaumaturgical_essence/path as anything in essence_yields)
		yields += list(list("name" = path.name, "amount" = essence_yields[path]))
		yield_names += path.name
	data["yields"] = yields
	data["yield_names"] = yield_names  // flat list for essence picker indexing
	data["search_data"] = yield_names.Join(",")

	var/list/splits = list()
	var/list/split_paths = list()
	for(var/atom/path as anything in init_types)
		splits += initial(path.name)
		split_paths += "[path]"
	data["splits_from"] = splits
	data["splits_from_paths"] = split_paths

	// Register under every init_type path so crop lookups find this precursor.
	// Use the first path as _output_path for the main lookup key.
	if(length(split_paths))
		data["_output_path"] = split_paths[1]
		data["_extra_output_paths"] = split_paths  // all paths for multi-registration

	return data

/datum/plant_def/return_recipe_data()
	var/list/data = list()
	data["type"] = "plant_def"
	data["name"] = name
	data["category"] = get_family_name()
	data["maturation_min"] = maturation_time / (1 MINUTES)
	data["produce_min"] = produce_time / (1 MINUTES)
	data["yield_min"] = produce_amount_min
	data["yield_max"] = produce_amount_max
	data["perennial"] = perennial
	data["water_drain"] = water_drain_rate * (1 MINUTES)
	data["weed_immune"] = weed_immune
	data["underground"] = can_grow_underground
	data["family"] = get_family_name()
	data["nitrogen_req"] = nitrogen_requirement
	data["phosphorus_req"] = phosphorus_requirement
	data["potassium_req"] = potassium_requirement
	data["nitrogen_prod"] = nitrogen_production
	data["phosphorus_prod"] = phosphorus_production
	data["potassium_prod"] = potassium_production
	// Register under the crop item path so ingredient lookups find this entry
	if(produce_type)
		data["_output_path"] = "[produce_type]"
		data["output_name"] = initial(produce_type.name)
		data["output_icon"] = "[initial(produce_type.icon)]"
		data["output_state"] = "[initial(produce_type.icon_state)]"
	return data

/datum/surgery/return_recipe_data()
	var/list/data = list()
	data["type"] = "surgery"
	data["name"] = name
	data["category"] = category
	data["desc"] = desc
	data["heretical"] = heretical
	data["req_bodypart"] = requires_bodypart
	data["req_missing_bodypart"] = requires_missing_bodypart
	data["req_real_bodypart"] = requires_real_bodypart

	var/list/steps_out = list()
	for(var/datum/surgery_step/step_type as anything in steps)
		var/datum/surgery_step/S = new step_type()

		var/list/tools = list()
		for(var/atom/tool as anything in S.implements)
			var/tool_name = ispath(tool) ? initial(tool.name) : "any [tool]"
			tools += list(list("name" = tool_name, "chance" = S.implements[tool]))

		var/list/step_e = list(
			"name" = initial(S.name),
			"desc" = S.desc,
			"tools" = tools,
			"accept_hand" = S.accept_hand,
			"accept_any" = S.accept_any_item,
			"self_operable" = S.self_operable,
			"lying_required" = S.lying_required,
			"repeating" = S.repeating,
			"ignore_clothes" = S.ignore_clothes,
		)

		if(S.skill_used && S.skill_min)
			step_e["skill_name"] = initial(S.skill_used.name)
			step_e["skill_min"] = SSskills.level_names[S.skill_min]
			step_e["skill_median"] = SSskills.level_names[S.skill_median]

		if(length(S.chems_needed))
			step_e["chems"] = S.get_chem_string()

		if(length(S.required_organs))
			step_e["organs"] = S.required_organs.Copy()

		var/list/flags = list()
		if(S.surgery_flags & SURGERY_INCISED)
			flags += "Requires incision"
		if(S.surgery_flags & SURGERY_RETRACTED)
			flags += "Requires retraction"
		if(S.surgery_flags & SURGERY_CLAMPED)
			flags += "Requires clamping"
		if(S.surgery_flags & SURGERY_DISLOCATED)
			flags += "Requires dislocation"
		if(S.surgery_flags & SURGERY_BROKEN)
			flags += "Requires broken bodypart"
		step_e["flags"] = flags

		steps_out += list(step_e)
		qdel(S)

	data["steps"] = steps_out
	return data

/datum/wound/return_recipe_data()
	var/list/data = list()
	data["type"] = "wound"
	data["name"] = name
	data["category"] = category
	data["desc"] = desc

	var/sev_text = "Unknown"
	var/sev_color = "white"
	switch(severity)
		if(WOUND_SEVERITY_LIGHT)
			sev_text = "Light"
			sev_color = "green"
		if(WOUND_SEVERITY_MODERATE)
			sev_text = "Moderate"
			sev_color = "yellow"
		if(WOUND_SEVERITY_SEVERE)
			sev_text = "Severe"
			sev_color = "orange"
		if(WOUND_SEVERITY_CRITICAL)
			sev_text = "Critical"
			sev_color = "red"
		if(WOUND_SEVERITY_BIOHAZARD)
			sev_text = "BIOHAZARD"
			sev_color = "purple"

	data["severity_text"] = sev_text
	data["severity_color"] = sev_color
	data["critical"] = critical
	data["mortal"] = mortal
	data["disabling"] = disabling
	data["whp"] = whp
	data["can_sew"] = can_sew
	data["can_cauterize"] = can_cauterize

	if(can_sew)
		data["sew_threshold"] = sew_threshold
		data["sewn_whp"] = sewn_whp

	if(!isnull(bleed_rate))
		data["bleed_rate"] = bleed_rate
		if(can_sew)
			data["sewn_bleed_rate"] = sewn_bleed_rate
		if(clotting_rate)
			data["clotting_rate"] = clotting_rate
			data["clotting_threshold"] = clotting_threshold
		if(can_sew && sewn_clotting_rate)
			data["sewn_clotting_rate"] = sewn_clotting_rate
			data["sewn_clotting_threshold"] = sewn_clotting_threshold

	if(passive_healing)
		data["passive_healing"] = passive_healing
	if(sleep_healing)
		data["sleep_healing"] = sleep_healing
	if(woundpain)
		data["woundpain"] = woundpain
		if(can_sew && sewn_woundpain != woundpain)
			data["sewn_woundpain"] = sewn_woundpain

	var/list/specials = list()
	if(embed_chance)
		specials += "Can embed weapons ([embed_chance]% chance)"
	if(werewolf_infection_probability)
		specials += "Can cause werewolf infection ([werewolf_infection_probability]% chance)"
	if(qdel_on_droplimb)
		specials += "Removed when limb is severed"
	data["special_props"] = specials

	if(check_name)
		data["check_name"] = check_name

	return data

/datum/chimeric_node/return_recipe_data()
	var/list/data = list()
	data["type"] = "chimeric_node"
	data["name"] = name
	data["category"] = "Humors"
	data["desc"] = desc

	var/slot_name = "Unknown"
	var/slot_color = "white"
	switch(slot)
		if(INPUT_NODE)
			slot_name = "Input Node"
			slot_color = "cyan"
		if(OUTPUT_NODE)
			slot_name = "Output Node"
			slot_color = "orange"
		if(SPECIAL_NODE)
			slot_name = "Special Node"
			slot_color = "purple"

	data["slot_name"] = slot_name
	data["slot_color"] = slot_color
	data["is_special"] = is_special
	data["allowed_slots"] = allowed_organ_slots.Copy()
	data["forbidden_slots"] = forbidden_organ_slots.Copy()

	return data

/datum/chimeric_table/return_recipe_data()
	var/list/data = list()
	data["type"] = "chimeric_table"
	data["name"] = name
	data["category"] = "Humor Dossier"
	data["node_tier"] = node_tier
	data["purity_min"] = node_purity_min
	data["purity_max"] = node_purity_max
	data["base_blood_cost"] = base_blood_cost
	data["pref_bonus"] = preferred_blood_bonus
	data["incompat_penalty"] = incompatible_blood_penalty

	var/list/pref = list()
	for(var/datum/blood_type/BT as anything in preferred_blood_types)
		pref += initial(BT.name)
	var/list/comp = list()
	for(var/datum/blood_type/BT as anything in compatible_blood_types)
		comp += initial(BT.name)
	var/list/inco = list()
	for(var/datum/blood_type/BT as anything in incompatible_blood_types)
		inco += initial(BT.name)
	data["preferred_blood"] = pref
	data["compatible_blood"] = comp
	data["incompatible_blood"] = inco

	data["input_nodes"] = return_node_pool(input_nodes + generic_inputs)
	data["output_nodes"] = return_node_pool(output_nodes + generic_outputs)
	data["special_nodes"] = return_node_pool(special_nodes + generic_specials)

	var/list/mob_sources = GLOB.chimeric_mob_sources["[type]"]
	data["source_mobs"] = mob_sources?.Copy() || list()

	return data

/datum/chimeric_table/proc/return_node_pool(list/pool)
	var/list/out = list()
	for(var/datum/chimeric_node/path as anything in pool)
		var/w = pool[path]
		var/likelihood
		if(w <= 0)
			likelihood = "Very Unlikely"
		else if(w < 5)  likelihood = "Unlikely"
		else if(w < 10) likelihood = "Less Likely"
		else if(w < 15) likelihood = "Likely"
		else if(w < 25) likelihood = "More Likely"
		else            likelihood = "Very Likely"
		out += list(list("name" = initial(path.name), "likelihood" = likelihood))
	return out


/obj/item/organ/return_recipe_data()
	var/list/data = list()
	data["type"] = "organ"
	data["name"] = name
	data["category"] = "Organs"
	data["_output_path"] = "[type]"
	data["output_icon"] = "[icon]"
	data["output_state"] = "[icon_state]"
	data["zone"] = parse_zone(zone)

	// Thresholds
	data["threshold_low"] = low_threshold
	data["threshold_high"] = high_threshold
	data["threshold_max"] = maxHealth

	// Threshold messages, strip span tags for display
	if(low_threshold_passed)
		data["msg_bruised"] = low_threshold_passed
	if(high_threshold_passed)
		data["msg_broken"] = high_threshold_passed
	if(low_threshold_cleared)
		data["msg_bruised_healed"] = low_threshold_cleared
	if(high_threshold_cleared)
		data["msg_broken_healed"] = high_threshold_cleared
	if(now_failing)
		data["msg_failing"] = now_failing
	if(now_fixed)
		data["msg_fixed"] = now_fixed

	// Healing
	data["healing_factor"] = healing_factor
	if(length(healing_items))
		var/list/hitems = list()
		for(var/atom/path as anything in healing_items)
			hitems += list(list(
				"name" = initial(path.name),
				"icon" = "[initial(path.icon)]",
				"icon_state" = "[initial(path.icon_state)]",
				"_path" = "[path]",
			))
		data["healing_items"] = hitems
	if(length(healing_tools))
		data["healing_tools"] = healing_tools.Copy()

	// Reattachment
	if(length(attaching_items))
		var/list/aitems = list()
		for(var/atom/path as anything in attaching_items)
			aitems += list(list(
				"name" = initial(path.name),
				"icon" = "[initial(path.icon)]",
				"icon_state" = "[initial(path.icon_state)]",
				"_path" = "[path]",
			))
		data["attaching_items"] = aitems

	// Body requirements
	if(blood_req)
		data["blood_req"] = blood_req
	if(oxygen_req)
		data["oxygen_req"] = oxygen_req
	if(nutriment_req)
		data["nutriment_req"] = nutriment_req
	if(hydration_req)
		data["hydration_req"] = hydration_req

	return data
