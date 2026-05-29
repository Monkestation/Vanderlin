/datum/attribute_holder
	var/datum/attribute/closely_inspected_attribute = null
	var/show_bad_skills = FALSE
	var/datum/tgui/attribute_menu_ui = null

GLOBAL_LIST_EMPTY(attribute_menu_static_payload)
GLOBAL_LIST_EMPTY(attribute_menu_name_to_datum)
GLOBAL_LIST_EMPTY(attribute_menu_sanitized_css_cache)

/proc/cached_sanitize_attribute_css(class_name)
	if(isnull(class_name))
		return null
	var/cached = GLOB.attribute_menu_sanitized_css_cache[class_name]
	if(cached)
		return cached
	cached = sanitize_css_class_name(class_name)
	GLOB.attribute_menu_sanitized_css_cache[class_name] = cached
	return cached

/proc/attribute_menu_anchor_for(stat_name, stat_index)
	var/lower_name = lowertext(stat_name)
	if(findtext(lower_name, "strength"))
		return "strength"
	if(findtext(lower_name, "perception"))
		return "perception"
	if(findtext(lower_name, "intellect") || findtext(lower_name, "intelligence"))
		return "intellect"
	if(findtext(lower_name, "speed") || findtext(lower_name, "agility"))
		return "speed"
	if(findtext(lower_name, "constitution"))
		return "constitution"
	if(findtext(lower_name, "endurance"))
		return "endurance"
	if(findtext(lower_name, "fortune") || findtext(lower_name, "luck"))
		return "fortune"
	return "fallback[(stat_index - 1) % 7]"

/proc/attribute_menu_seal_label_for(datum/attribute/stat/stat)
	var/lower_name = lowertext(stat.name)
	if(findtext(lower_name, "strength"))
		return "Strength (STR)"
	if(findtext(lower_name, "perception"))
		return "Perception (PER)"
	if(findtext(lower_name, "endurance"))
		return "Endurance (END)"
	if(findtext(lower_name, "constitution"))
		return "Constitution (CON)"
	if(findtext(lower_name, "intellect") || findtext(lower_name, "intelligence"))
		return "Intellect (INT)"
	if(findtext(lower_name, "speed") || findtext(lower_name, "agility"))
		return "Speed (SPD)"
	if(findtext(lower_name, "fortune") || findtext(lower_name, "luck"))
		return "Fortune (FOR)"
	return stat.shorthand ? "[stat.name] ([stat.shorthand])" : stat.name

/proc/ensure_attribute_menu_static_payload()
	if(length(GLOB.attribute_menu_static_payload))
		return GLOB.attribute_menu_static_payload

	var/list/payload = list()
	var/list/name_to_datum = list()
	var/list/attribute_meta_by_name = list()

	var/list/stats_meta = list()
	var/stat_index = 1
	for(var/stat_type in GLOB.all_stats)
		var/datum/attribute/stat/stat = GET_ATTRIBUTE_DATUM(stat_type)
		var/icon_class = cached_sanitize_attribute_css(stat.icon_state)
		stats_meta += list(list(
			"name" = stat.name,
			"desc" = stat.desc,
			"icon" = icon_class,
			"shorthand" = stat.shorthand,
			"anchor" = attribute_menu_anchor_for(stat.name, stat_index),
			"seal_label" = attribute_menu_seal_label_for(stat),
		))
		name_to_datum[stat.name] = stat
		attribute_meta_by_name[stat.name] = list(
			"name" = stat.name,
			"desc" = stat.desc,
			"icon" = icon_class,
			"shorthand" = stat.shorthand,
			"kind" = "stat",
		)
		stat_index++

	var/list/skill_categories_meta = list()
	for(var/category in GLOB.all_skill_categories)
		var/list/this_category_skills = list()
		for(var/skill_type in GLOB.all_skill_categories[category])
			var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
			var/icon_class = cached_sanitize_attribute_css(skill.icon_state)
			this_category_skills += list(list(
				"name" = skill.name,
				"desc" = skill.desc,
				"icon" = icon_class,
				"difficulty" = skill.difficulty,
			))
			name_to_datum[skill.name] = skill

			var/list/skill_meta = list(
				"name" = skill.name,
				"desc" = skill.desc,
				"icon" = icon_class,
				"difficulty" = skill.difficulty,
				"kind" = "skill",
			)
			if(skill.governing_attribute)
				var/datum/attribute/governing = GET_ATTRIBUTE_DATUM(skill.governing_attribute)
				if(governing)
					skill_meta["governing_attribute"] = governing.name

			if(LAZYLEN(skill.default_attributes))
				var/list/defaults_meta = list()
				for(var/default_type in skill.default_attributes)
					var/datum/attribute/default_attr = GET_ATTRIBUTE_DATUM(default_type)
					if(!default_attr)
						continue
					defaults_meta += list(list(
						"name" = default_attr.name,
						"desc" = default_attr.desc,
						"icon" = cached_sanitize_attribute_css(default_attr.icon_state),
						"default_value" = skill.default_attributes[default_type],
					))
				skill_meta["defaults"] = defaults_meta

			attribute_meta_by_name[skill.name] = skill_meta

		skill_categories_meta += list(list(
			"name" = category,
			"skills" = this_category_skills,
		))

	payload["stats_meta"] = stats_meta
	payload["skills_by_category_meta"] = skill_categories_meta
	payload["attribute_meta_by_name"] = attribute_meta_by_name

	GLOB.attribute_menu_static_payload = payload
	GLOB.attribute_menu_name_to_datum = name_to_datum

	return payload

/datum/attribute_holder/proc/return_raw_calculated_skill_cached(attribute_type, list/raw_cache)
	if(attribute_type in raw_cache)
		var/list/cached = raw_cache[attribute_type]
		return cached["value"]

	var/skill_value = raw_attribute_list[attribute_type]
	var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(attribute_type)
	if(istype(skill) && !isnull(skill_value) && skill.governing_attribute)
		var/governing_value = return_raw_calculated_skill_cached(skill.governing_attribute, raw_cache)
		var/governing_multiplier = (governing_value >= 0) ? SKILL_GOVERNING_MULTIPLIER_POSITIVE : SKILL_GOVERNING_MULTIPLIER_NEGATIVE
		skill_value += floor(governing_value * governing_multiplier)

	raw_cache[attribute_type] = list("value" = skill_value)
	return skill_value

/datum/attribute_holder/proc/return_calculated_skill_cached(attribute_type, list/raw_cache, list/effective_cache)
	if(attribute_type in effective_cache)
		var/list/cached = effective_cache[attribute_type]
		return cached["value"]

	var/skill_value = attribute_list[attribute_type]
	var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(attribute_type)
	if(istype(skill) && !isnull(skill_value) && skill.governing_attribute)
		skill_value = max(skill.default_attributes[skill.governing_attribute], skill_value)
		if(skill.default_attributes[skill.governing_attribute] \
			&& (skill_value <= skill.default_attributes[skill.governing_attribute] * SKILL_GOVERNING_MULTIPLIER_POSITIVE))
			effective_cache[attribute_type] = list("value" = null)
			return
		var/governing_raw = return_raw_calculated_skill_cached(skill.governing_attribute, raw_cache)
		var/governing_effective = return_calculated_skill_cached(skill.governing_attribute, raw_cache, effective_cache)
		var/governing_delta = governing_effective - governing_raw
		if(governing_delta < 0)
			skill_value += floor((governing_raw * SKILL_GOVERNING_MULTIPLIER_POSITIVE) + (governing_delta * SKILL_GOVERNING_MULTIPLIER_NEGATIVE))
		else
			skill_value += floor(governing_effective * SKILL_GOVERNING_MULTIPLIER_POSITIVE)

	effective_cache[attribute_type] = list("value" = skill_value)
	return skill_value

/datum/attribute_holder/proc/get_attribute_ui_values(attribute_type, list/raw_cache, list/effective_cache)
	var/list/values = list()
	values["raw"] = return_raw_calculated_skill_cached(attribute_type, raw_cache)
	values["effective"] = return_calculated_skill_cached(attribute_type, raw_cache, effective_cache)
	return values

/datum/attribute_holder/proc/find_active_attribute_menu_ui(mob/user)
	if(!user)
		return null
	if(attribute_menu_ui && !QDELETED(attribute_menu_ui) && attribute_menu_ui.user == user && !attribute_menu_ui.closing)
		attribute_menu_ui.process_status()
		if(attribute_menu_ui.status > UI_CLOSE)
			return attribute_menu_ui
		attribute_menu_ui = null
	var/datum/tgui/found_ui = null
	var/list/open_ui_list = user.tgui_open_uis ? user.tgui_open_uis.Copy() : null
	for(var/datum/tgui/open_ui as anything in open_ui_list)
		if(QDELETED(open_ui) || open_ui.closing || open_ui.interface != "AttributeMenu")
			continue
		open_ui.process_status()
		if(open_ui.status <= UI_CLOSE || open_ui.src_object != src)
			open_ui.close()
			continue
		if(found_ui)
			open_ui.close()
			continue
		found_ui = open_ui
	attribute_menu_ui = found_ui
	return found_ui

/datum/attribute_holder/proc/update_attribute_menu_ui()
	if(!attribute_menu_ui && !LAZYLEN(open_uis))
		return
	var/datum/tgui/ui = find_active_attribute_menu_ui(parent)
	if(ui)
		ui.send_update()

/datum/attribute_holder/ui_interact(mob/user, datum/tgui/ui)
	if(isnull(ui))
		var/datum/tgui/existing_ui = find_active_attribute_menu_ui(user)
		if(existing_ui)
			return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AttributeMenu")
		attribute_menu_ui = ui
		ui.set_autoupdate(FALSE)
		if(!ui.open())
			if(attribute_menu_ui == ui)
				attribute_menu_ui = null
	else
		attribute_menu_ui = ui

/datum/attribute_holder/ui_close(mob/user)
	. = ..()
	if(attribute_menu_ui?.user == user)
		attribute_menu_ui = null

/datum/attribute_holder/ui_state(mob/user)
	return GLOB.always_state

/datum/attribute_holder/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/attributes_big),
		get_asset_datum(/datum/asset/spritesheet/attributes_small),
		get_asset_datum(/datum/asset/simple/attribute_menu),
	)

/datum/attribute_holder/ui_static_data(mob/user)
	return ensure_attribute_menu_static_payload()

/datum/attribute_holder/ui_data(mob/user)
	var/list/data = list()
	var/list/raw_value_cache = list()
	var/list/effective_value_cache = list()

	data["show_bad_skills"] = show_bad_skills
	data["parent"] = parent?.name

	var/list/stats_values = list()
	for(var/stat_type in GLOB.all_stats)
		var/datum/attribute/stat/stat = GET_ATTRIBUTE_DATUM(stat_type)
		stats_values[stat.name] = list(
			"raw_value" = nulltozero(raw_attribute_list[stat_type]),
			"value" = nulltozero(attribute_list[stat_type]),
		)
	data["stats_values"] = stats_values

	var/list/skills_values = list()
	for(var/category in GLOB.all_skill_categories)
		for(var/skill_type in GLOB.all_skill_categories[category])
			var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
			var/list/values = get_attribute_ui_values(skill_type, raw_value_cache, effective_value_cache)
			skills_values[skill.name] = list(
				"raw_value" = values["raw"],
				"value" = values["effective"],
			)
	data["skills_values"] = skills_values

	if(istype(closely_inspected_attribute))
		var/list/closely_inspected_dynamic = list()
		closely_inspected_dynamic["name"] = closely_inspected_attribute.name
		closely_inspected_dynamic["desc_from_level"] = capitalize_like_old_man(closely_inspected_attribute.description_from_level(attribute_list[closely_inspected_attribute.type]))

		if(istype(closely_inspected_attribute, STAT))
			closely_inspected_dynamic["raw_value"] = nulltozero(raw_attribute_list[closely_inspected_attribute.type])
			closely_inspected_dynamic["value"] = nulltozero(attribute_list[closely_inspected_attribute.type])
		else if(istype(closely_inspected_attribute, SKILL))
			var/list/values = get_attribute_ui_values(closely_inspected_attribute.type, raw_value_cache, effective_value_cache)
			closely_inspected_dynamic["raw_value"] = values["raw"]
			closely_inspected_dynamic["value"] = values["effective"]

		var/list/modifiers = list()
		for(var/key in get_attribute_modification())
			var/datum/attribute_modifier/mod = attribute_modification[key]
			if(!(closely_inspected_attribute.type in mod.attribute_list))
				continue
			var/mod_val = mod.attribute_list[closely_inspected_attribute.type]
			if(isnull(mod_val) || mod_val == 0)
				continue
			modifiers += list(list(
				"id" = mod.id,
				"value" = mod_val,
			))
		closely_inspected_dynamic["modifiers"] = modifiers

		data["closely_inspected"] = closely_inspected_dynamic
	else
		data["closely_inspected"] = null

	return data

/datum/attribute_holder/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("enable_bad_skills")
			show_bad_skills = TRUE
			return TRUE
		if("disable_bad_skills")
			show_bad_skills = FALSE
			return TRUE
		if("inspect_closely")
			var/attribute_name = params["attribute_name"]
			if(attribute_name)
				ensure_attribute_menu_static_payload()
				closely_inspected_attribute = GLOB.attribute_menu_name_to_datum[attribute_name]
			else
				closely_inspected_attribute = null
			return TRUE
		if("clear_inspection")
			closely_inspected_attribute = null
			return TRUE
