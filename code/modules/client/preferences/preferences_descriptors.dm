/datum/preferences/proc/validate_descriptors()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
		if(entry)
			continue
		entry = new /datum/descriptor_entry()
		if(choice.default_descriptor)
			entry.set_values(choice_type, choice.default_descriptor)
		else
			entry.set_values(choice_type, pick(choice.descriptors))
		descriptor_entries += entry

	for(var/datum/descriptor_entry/entry as anything in descriptor_entries)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(entry.descriptor_choice_type)
		if(entry.descriptor_type == null || !(entry.descriptor_type in choice.descriptors))
			if(choice.default_descriptor)
				entry.descriptor_type = choice.default_descriptor
			else
				entry.descriptor_type = pick(choice.descriptors)
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		if(length(custom_descriptors) >= i)
			continue
		var/datum/custom_descriptor_entry/custom_entry = new /datum/custom_descriptor_entry()
		custom_descriptors += custom_entry
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[i]
		custom_entry.prefix_type = sanitize_integer(custom_entry.prefix_type, 1, CUSTOM_PREFIX_AMOUNT, CUSTOM_PREFIX_HAS_A)
		custom_entry.content_text = STRIP_HTML_SIMPLE(lowertext(custom_entry.content_text), CUSTOM_DESCRIPTOR_TEXT_LENGTH)

/datum/preferences/proc/reset_descriptors()
	descriptor_entries = list()
	custom_descriptors = list()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		var/datum/descriptor_entry/entry = new /datum/descriptor_entry()
		if(choice.default_descriptor)
			entry.set_values(choice_type, choice.default_descriptor)
		else
			entry.set_values(choice_type, pick(choice.descriptors))
		descriptor_entries += entry
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		var/datum/custom_descriptor_entry/custom_entry = new /datum/custom_descriptor_entry()
		custom_descriptors += custom_entry

/datum/preferences/proc/handle_descriptors_topic(mob/user, href_list)
	switch(href_list["preference"])
		if("choose_descriptor")
			var/choice_type = text2path(href_list["descriptor_choice"])
			if(!(choice_type in pref_species.descriptor_choices))
				return
			var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
			if(!choice)
				return
			var/list/picklist = list()
			for(var/desc_type in choice.descriptors)
				var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(desc_type)
				picklist[descriptor.name] = desc_type
			var/picked_descriptor_name = browser_input_list(user, "DESCRIBE YOUR HERO'S [uppertext(choice.name)]", "THE SELF", picklist, FALSE)

			if(!picked_descriptor_name)
				return
			var/picked_type = picklist[picked_descriptor_name]
			var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
			entry.descriptor_type = picked_type
		if("custom_descriptor_prefix")
			var/static/list/translation = CUSTOM_PREFIX_TRANSLATION_LIST
			var/static/list/input_list = CUSTOM_PREFIX_INPUT_LIST
			var/index = text2num(href_list["index"])
			var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[index]
			var/current_prefix_text = translation["[custom_entry.prefix_type ]"]
			var/new_prefix_text = browser_input_list(user, "CHOOSE A DESCRIPTOR PREFIX", "THE SELF", input_list, current_prefix_text)
			if(!new_prefix_text)
				return
			var/new_prefix_type = input_list[new_prefix_text]
			custom_entry.prefix_type = new_prefix_type
		if("custom_descriptor_content")
			var/index = text2num(href_list["index"])
			var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[index]
			var/new_content = browser_input_text(user, "DESCRIBE THE FEATURE", "THE SELF", custom_entry.content_text, CUSTOM_DESCRIPTOR_TEXT_LENGTH)
			if(!new_content)
				return
			new_content = STRIP_HTML_SIMPLE(lowertext(new_content), CUSTOM_DESCRIPTOR_TEXT_LENGTH)
			custom_entry.content_text = new_content

/datum/preferences/proc/print_descriptors_page()
	var/list/dat = list()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
		if(!entry)
			continue
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(entry.descriptor_type)
		dat += "<b>[choice.name]:</b> <a href='byond://?_src_=prefs;descriptor_choice=[choice_type];preference=choose_descriptor;task=change_descriptor'>[descriptor.name]</a><br>"

	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		// Ugly, I know
		if(i == 1)
			if(!has_descriptor_type_in_entries(/datum/mob_descriptor/prominent/custom/one))
				continue
		else if(i == 2)
			if(!has_descriptor_type_in_entries(/datum/mob_descriptor/prominent/custom/two))
				continue
		else
			continue
		var/list/custom_data = print_custom_descriptor_customization(i)
		if(custom_data)
			dat += custom_data

	dat += "<br><br><center>Descriptors can vary based on gender<br>Some don't appear if you don't match a requirement<center>"
	return dat

/datum/preferences/proc/print_custom_descriptor_customization(index)
	var/static/list/translation = CUSTOM_PREFIX_TRANSLATION_LIST
	var/list/dat = list()
	var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[index]
	dat += "<br><b>Custom #[index]:</b> <a href='?_src_=prefs;index=[index];preference=custom_descriptor_prefix;task=change_descriptor'>[translation["[custom_entry.prefix_type]"]]</a><a href='?_src_=prefs;index=[index];preference=custom_descriptor_content;task=change_descriptor'>[custom_entry.content_text]</a>"
	return dat

/datum/preferences/proc/show_descriptors_ui(mob/user)
	var/list/dat = list()
	dat += print_descriptors_page()
	var/datum/browser/popup = new(user, "descriptors_customization", "<div align='center'>Describe myself</div>", 350, 510)
	popup.set_content(dat.Join())
	popup.open(use_onclose = FALSE)

/datum/preferences/proc/has_descriptor_type_in_entries(descriptor_type)
	for(var/datum/descriptor_entry/entry as anything in descriptor_entries)
		if(entry.descriptor_type != descriptor_type)
			continue
		return TRUE
	return FALSE

/datum/preferences/proc/get_descriptor_entry_for_choice(choice_type)
	for(var/datum/descriptor_entry/entry as anything in descriptor_entries)
		if(entry.descriptor_choice_type != choice_type)
			continue
		return entry
	return null

/datum/preferences/proc/apply_descriptors(mob/living/character)
	character.clear_mob_descriptors()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
		if(entry)
			character.add_mob_descriptor(entry.descriptor_type)
	character.custom_descriptors = list()
	for(var/datum/custom_descriptor_entry/entry as anything in custom_descriptors)
		var/datum/custom_descriptor_entry/new_entry = new /datum/custom_descriptor_entry()
		new_entry.prefix_type = entry.prefix_type
		new_entry.content_text = entry.content_text
		character.custom_descriptors += new_entry
