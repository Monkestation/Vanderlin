/datum/attribute_holder
	var/datum/attribute/closely_inspected_attribute = null
	var/show_bad_skills = FALSE
	var/preview_image_b64

GLOBAL_LIST_EMPTY(attribute_menu_static_payload)
GLOBAL_LIST_EMPTY(attribute_menu_name_to_datum)

/proc/ensure_attribute_menu_static_payload()
	if(length(GLOB.attribute_menu_static_payload))
		return GLOB.attribute_menu_static_payload

	var/list/payload = list()
	var/list/name_to_datum = list()
	var/list/attribute_meta_by_name = list()

	var/list/stats_meta = list()
	for(var/stat_type in GLOB.all_stats)
		var/datum/attribute/stat/stat = GET_ATTRIBUTE_DATUM(stat_type)
		var/icon_class = sanitize_css_class_name(stat.icon_state)
		stats_meta += list(list(
			"name" = stat.name,
			"desc" = stat.desc,
			"icon" = icon_class,
			"shorthand" = stat.shorthand,
		))
		name_to_datum[stat.name] = stat
		attribute_meta_by_name[stat.name] = list(
			"name" = stat.name,
			"desc" = stat.desc,
			"icon" = icon_class,
			"shorthand" = stat.shorthand,
			"kind" = "stat",
		)

	var/list/skill_categories_meta = list()
	for(var/category in GLOB.all_skill_categories)
		var/list/this_category_skills = list()
		for(var/skill_type in GLOB.all_skill_categories[category])
			var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
			var/icon_class = sanitize_css_class_name(skill.icon_state)
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
						"icon" = sanitize_css_class_name(default_attr.icon_state),
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

/datum/attribute_holder/proc/get_attribute_ui_values(attribute_type)
	var/list/values = list()
	var/list/breakdown = get_skill_value_breakdown(attribute_type)
	values["base"] = breakdown["base"]
	values["value"] = breakdown["value"]
	values["net_modifier"] = isnull(breakdown["value"]) ? null : (breakdown["value"] - nulltozero(breakdown["base"]))
	values["trained"] = !isnull(return_calculated_skill(attribute_type))
	return values

/datum/attribute_holder/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		preview_image_b64 = build_character_preview()
		ui = new(user, src, "AttributeMenu")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/attribute_holder/proc/build_character_preview()
	if(!parent)
		return null
	var/image/snapshot = image(null)
	snapshot.appearance = parent.appearance
	snapshot.dir = SOUTH
	var/list/base_dimensions = get_icon_dimensions(snapshot.icon)
	var/base_width = base_dimensions["width"]
	var/base_height = base_dimensions["height"]
	var/list/kept_overlays = list()
	for(var/image/overlay as anything in snapshot.overlays)
		if(overlay.pixel_x < 0 && overlay.pixel_y < 0)
			var/list/overlay_dimensions = get_icon_dimensions(overlay.icon || snapshot.icon)
			if(overlay.pixel_x + overlay_dimensions["width"] > base_width && overlay.pixel_y + overlay_dimensions["height"] > base_height)
				continue
		kept_overlays += overlay
	snapshot.overlays = kept_overlays
	var/icon/flat = getFlatIcon(snapshot, SOUTH, no_anim = TRUE)
	if(!flat)
		return null
	var/left = 0
	var/right = 0
	var/bottom = 0
	var/top = 0
	for(var/x in 1 to flat.Width())
		for(var/y in 1 to flat.Height())
			if(!flat.GetPixel(x, y))
				continue
			if(!left || x < left)
				left = x
			if(x > right)
				right = x
			if(!bottom || y < bottom)
				bottom = y
			if(y > top)
				top = y
	if(!left)
		return null
	flat.Crop(left, bottom, right, top)
	var/flat_w = flat.Width()
	var/flat_h = flat.Height()
	if(flat_w % 2 || flat_h % 2)
		flat.Crop(1, 1, flat_w + (flat_w % 2), flat_h + (flat_h % 2))
	return "data:image/png;base64,[icon2base64(flat)]"

/datum/attribute_holder/proc/on_parent_appearance_changed()
	SIGNAL_HANDLER
	if(!LAZYLEN(open_uis))
		return
	addtimer(CALLBACK(src, PROC_REF(refresh_preview_now)), 0, TIMER_UNIQUE)

/datum/attribute_holder/proc/refresh_preview_now()
	if(!LAZYLEN(open_uis))
		return
	preview_image_b64 = build_character_preview()
	SStgui.update_uis(src)

/datum/attribute_holder/ui_state(mob/user)
	return GLOB.always_state

/datum/attribute_holder/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/attributes_big),
		get_asset_datum(/datum/asset/spritesheet/attributes_small),
		get_asset_datum(/datum/asset/spritesheet/attribute_seals),
	)

/datum/attribute_holder/ui_static_data(mob/user)
	return ensure_attribute_menu_static_payload()

/datum/attribute_holder/ui_data(mob/user)
	var/list/data = list()

	data["show_bad_skills"] = show_bad_skills
	data["parent"] = parent?.name
	data["preview_image"] = preview_image_b64

	var/list/stats_values = list()
	for(var/stat_type in GLOB.all_stats)
		var/datum/attribute/stat/stat = GET_ATTRIBUTE_DATUM(stat_type)
		var/base = nulltozero(raw_attribute_list[stat_type])
		var/final_value = nulltozero(attribute_list[stat_type])
		stats_values[stat.name] = list(
			"base" = base,
			"net_modifier" = final_value - base,
		)
	data["stats_values"] = stats_values

	var/list/skills_values = list()
	for(var/category in GLOB.all_skill_categories)
		for(var/skill_type in GLOB.all_skill_categories[category])
			var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
			var/list/values = get_attribute_ui_values(skill_type)
			skills_values[skill.name] = list(
				"base" = values["base"],
				"net_modifier" = values["net_modifier"],
				"trained" = values["trained"],
			)
	data["skills_values"] = skills_values

	if(istype(closely_inspected_attribute))
		var/list/closely_inspected_dynamic = list()
		closely_inspected_dynamic["name"] = closely_inspected_attribute.name
		closely_inspected_dynamic["desc_from_level"] = capitalize_like_old_man(closely_inspected_attribute.description_from_level(attribute_list[closely_inspected_attribute.type]))

		var/list/modifiers = list()
		for(var/key in get_attribute_modification())
			var/datum/attribute_modifier/mod = attribute_modification[key]
			if(!(closely_inspected_attribute.type in mod.attribute_list))
				continue
			var/mod_val = mod.attribute_list[closely_inspected_attribute.type]
			if(isnull(mod_val) || mod_val == 0)
				continue
			modifiers += list(list("id" = mod.id, "value" = mod_val))

		if(istype(closely_inspected_attribute, STAT))
			var/base = nulltozero(raw_attribute_list[closely_inspected_attribute.type])
			var/final_value = nulltozero(attribute_list[closely_inspected_attribute.type])
			closely_inspected_dynamic["base"] = base
			closely_inspected_dynamic["net_modifier"] = final_value - base

		else if(istype(closely_inspected_attribute, SKILL))
			var/datum/attribute/skill/inspected_skill = closely_inspected_attribute
			var/list/breakdown = get_skill_value_breakdown(inspected_skill.type)
			closely_inspected_dynamic["base"] = breakdown["base"]
			closely_inspected_dynamic["net_modifier"] = isnull(breakdown["value"]) ? null : (breakdown["value"] - nulltozero(breakdown["base"]))

			if(breakdown["governing_contribution"] && inspected_skill.governing_attribute)
				var/datum/attribute/governing_datum = GET_ATTRIBUTE_DATUM(inspected_skill.governing_attribute)
				modifiers += list(list("id" = "Governing: [governing_datum.name]", "value" = breakdown["governing_contribution"]))

			if(breakdown["defaults_contribution"])
				modifiers += list(list("id" = "Defaulted", "value" = breakdown["defaults_contribution"]))

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
