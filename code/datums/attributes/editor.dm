/datum/attribute_editor
	var/datum/weakref/target

/datum/attribute_editor/New(datum/attribute_holder/target)
	src.target = WEAKREF(target)

/datum/attribute_editor/ui_state(mob/user)
	return GLOB.always_state

/datum/attribute_editor/ui_close(mob/user)
	qdel(src)

/datum/attribute_editor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AttributeEditor")
		ui.open()

/datum/attribute_editor/ui_data()
	var/list/data = list()

	var/datum/attribute_holder/attributes = target?.resolve()
	if(!attributes)
		return data

	data["parent"] = attributes.parent?.name
	data["attribute_min"] = attributes.attribute_min
	data["attribute_max"] = attributes.attribute_max
	data["attribute_default"] = attributes.attribute_default
	data["skill_min"] = attributes.skill_min
	data["skill_max"] = attributes.skill_max
	data["skill_default"] = attributes.skill_default
	data["cached_diceroll_modifier"] = attributes.cached_diceroll_modifier

	var/list/compiled_attributes = list()
	var/list/compiled_skills = list()
	for(var/datum/attribute/attribute as anything in GLOB.all_attributes)
		var/list/this_attribute = list()

		attribute = GLOB.all_attributes[attribute]
		this_attribute["name"] = attribute.name
		this_attribute["type"] = attribute.type
		this_attribute["value"] = attributes.attribute_list[attribute.type]
		this_attribute["raw_value"] = attributes.raw_attribute_list[attribute.type]

		if(istype(attribute, /datum/attribute/skill))
			compiled_skills += list(this_attribute)
		else
			compiled_attributes += list(this_attribute)
	data["attributes"] = compiled_attributes
	data["skills"] = compiled_skills
	return data

/datum/attribute_editor/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	var/datum/attribute_holder/attributes = target?.resolve()
	if(!attributes)
		to_chat(usr, "The target attribute holder is gone. Terrible job, supershit.")
		qdel(src)
		return
	switch(action)
		if("change_diceroll_modifier")
			var/new_value = params["new_value"]
			attributes.add_or_update_variable_diceroll_modifier(/datum/diceroll_modifier/attribute_editor, new_value)
		if("change_var")
			var/attribute_var_name = params["var_name"]
			var/attribute_var_value = params["var_value"]
			if(attributes.vv_edit_var(attribute_var_name, attribute_var_value) == FALSE)
				to_chat(usr, "Your edit was rejected by the object. This is a bug with the attribute editor, not your fault, so report it on github.")
				return
			attributes.update_attributes()
		if("change_attribute")
			var/attribute_type = text2path(params["attribute_type"])
			var/new_value = params["new_value"]
			var/datum/attribute_modifier/existing_modifier = attributes.has_attribute_modifier(/datum/attribute_modifier/attribute_editor)
			var/list/new_values
			if(existing_modifier)
				new_values = existing_modifier.attribute_list.Copy()
			else
				new_values = list()
			new_values[attribute_type] = new_value
			attributes.add_or_update_variable_attribute_modifier(/datum/attribute_modifier/attribute_editor, TRUE, new_values)
		if("change_raw_attribute")
			var/attribute_type = text2path(params["attribute_type"])
			var/new_value = params["new_value"]
			var/min_value = attributes.attribute_min
			var/max_value = attributes.attribute_max
			if(ispath(attribute_type, /datum/attribute/skill))
				min_value = attributes.skill_min
				max_value = attributes.skill_max
			attributes.raw_attribute_list[attribute_type] = clamp(new_value, min_value, max_value)
			attributes.update_attributes()
		if("null_var")
			var/attribute_var_name = params["var_name"]
			if(attributes.vv_edit_var(attribute_var_name, null) == FALSE)
				to_chat(usr, "Your edit was rejected by the object. This is a bug with the attribute editor, not your fault, so report it on github.")
				return
			attributes.update_attributes()
		if("null_attribute")
			var/attribute_type = text2path(params["attribute_type"])
			var/datum/attribute_modifier/existing_modifier = attributes.has_attribute_modifier(/datum/attribute_modifier/attribute_editor)
			var/list/new_values
			if(existing_modifier)
				new_values = existing_modifier.attribute_list.Copy()
			else
				new_values = list()
			new_values -= attribute_type
			attributes.add_or_update_variable_attribute_modifier(/datum/attribute_modifier/attribute_editor, TRUE, new_values)
		if("null_raw_attribute")
			var/attribute_type = text2path(params["attribute_type"])
			attributes.raw_attribute_list[attribute_type] = null
			attributes.update_attributes()

	return TRUE
