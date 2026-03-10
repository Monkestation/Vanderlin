/datum/preferences/proc/validate_customizer_entries()
	customizer_entries = SANITIZE_LIST(customizer_entries)
	listclearnulls(customizer_entries)
	var/datum/species/species = pref_species
	var/list/customizers = species.customizers
	/// Check if we have any customizer entries that don't match.
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/validated = FALSE
		for(var/customizer_type as anything in customizers)
			if(customizer_type != entry.customizer_type)
				continue
			var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
			if(!(entry.customizer_choice_type in customizer.customizer_choices))
				continue
			var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
			if(entry.type != customizer_choice.customizer_entry_type)
				continue
			validated = TRUE
			break

		if(!validated)
			customizer_entries -= entry

	/// Check if we have any missing customizer entries
	for(var/customizer_type as anything in customizers)
		var/found = FALSE
		for(var/datum/customizer_entry/entry as anything in customizer_entries)
			if(entry.customizer_type != customizer_type)
				continue
			found = TRUE
			break
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!found)
			customizer_entries += customizer.make_default_customizer_entry(src, FALSE)

	/// Validate the variables within customizer entries
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		customizer_choice.validate_entry(src, entry)

/datum/preferences/proc/print_customizers_page()
	var/list/dat = list()
	. = dat
	if(!pref_species)
		return
	var/list/customizers = pref_species.customizers
	if(!customizers)
		return
	dat += "<table width='100%'>"
	dat += "<td valign='top' width='33%'>"
	var/iterated_customizers = 0
	for(var/customizer_type in customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer.is_allowed(src))
			continue
		var/datum/customizer_entry/entry = get_customizer_entry_for_customizer_type(customizer_type)
		if(!entry)
			stack_trace("Missing customizer entry in preferences for customizer [customizer_type]")
			continue
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)

		var/customizer_link

		if(entry.disabled)
			customizer_link = "href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=toggle_missing'"
		else
			if(customizer.allows_disabling)
				customizer_link = "href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=toggle_missing' class='linkOn'"
			else
				customizer_link = ""

		dat += "<table align='center'; width='100%'; height='100px'; style='background-color:#1c1313'><td width=100%>"
		dat += "<a [customizer_link]>[customizer.name]</a>"
		if(!entry.disabled)
			var/choice_link
			if(length(customizer.customizer_choices) > 1)
				choice_link = "href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=change_choice'"
			else
				choice_link = "class='linkOff'"
			if(length(customizer.customizer_choices) > 1)
				dat += "<br><a [choice_link]>[choice.name]</a>"

			var/list/choice_list = choice.show_pref_choices(src, entry, customizer_type)
			if(choice_list)
				dat += choice_list

		dat += "</td></table><br>"
		iterated_customizers += 1
		if(iterated_customizers >= 5)
			dat += "</td><td valign='top' width='33%'>"
			iterated_customizers = 0
	dat += "</td></table>"
	return

/// We dont associate the entries just to be safer for save/load, so we can't lookup easily and we do this.
/datum/preferences/proc/get_customizer_entry_for_customizer_type(customizer_type)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		if(entry.customizer_type == customizer_type)
			return entry

/// Gets an associative list of organ slots to organ dna created from organ customization
/datum/preferences/proc/get_organ_dna_list()
	var/list/organ_list = list()
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/datum/customizer/customizer = CUSTOMIZER(entry.customizer_type)
		if(!customizer.is_allowed(src))
			continue
		if(entry.disabled)
			continue
		var/datum/organ_dna/dna = customizer_choice.create_organ_dna(entry, src)
		if(!dna)
			continue
		organ_list[customizer_choice.get_organ_slot()] = dna

	return organ_list

/datum/preferences/proc/customize_organ(obj/item/organ/organ)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/datum/customizer/customizer = CUSTOMIZER(entry.customizer_type)
		if(!customizer.is_allowed(src))
			continue
		if(entry.disabled)
			continue
		if(!(customizer_choice.get_organ_slot() == organ.slot))
			continue
		customizer_choice.customize_organ(organ, entry)

/datum/preferences/proc/apply_customizers_to_character(mob/living/carbon/human/human)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/datum/customizer/customizer = CUSTOMIZER(entry.customizer_type)
		if(!customizer.is_allowed(src))
			continue
		if(entry.disabled)
			continue
		customizer_choice.apply_customizer_to_character(human, src, entry)

/datum/preferences/proc/handle_customizer_topic(mob/user, href_list)
	//needs_update = TRUE
	var/customizer_type = text2path(href_list["customizer"])
	var/datum/customizer_entry/entry = get_customizer_entry_for_customizer_type(customizer_type)
	if(!entry)
		return
	var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
	var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
	switch(href_list["customizer_task"])
		if("toggle_missing")
			if(customizer.allows_disabling)
				entry.disabled = !entry.disabled
		if("change_choice")
			var/list/choice_list = list()
			for(var/choice_type in customizer.customizer_choices)
				var/datum/customizer_choice/iter_choice = CUSTOMIZER_CHOICE(choice_type)
				choice_list[iter_choice.name] = choice_type
			var/chosen_input = input(user, "Choose your [lowertext(customizer.name)]:", "Character Preference")  as null|anything in choice_list
			if(!chosen_input)
				return
			var/choice_type = choice_list[chosen_input]
			if(choice_type == choice.type)
				return
			customizer_entries -= entry
			customizer_entries += customizer.create_customizer_entry(src, choice_type)
		else
			choice.handle_topic(user, href_list, src, entry, customizer_type)

/datum/preferences/proc/reset_all_customizer_accessory_colors()
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		choice.reset_accessory_colors(src, entry)

/datum/preferences/proc/randomize_all_customizer_accessories()
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		choice.randomize_entry(entry, src)

/datum/preferences/proc/ShowCustomizers(mob/user)
	var/list/dat = list()
	dat += "<style>span.color_holder_box{display: inline-block; width: 20px; height: 8px; border:1px solid #000; padding: 0px;}</style>"
	dat += print_customizers_page()
	var/datum/browser/popup = new(user, "customization", "<div align='center'>Customization</div>", 630, 730)
	popup.set_content(dat.Join())
	popup.open(use_onclose = FALSE)

/datum/preferences/proc/get_hair_color()
	var/datum/customizer_entry/hair/entry = get_customizer_entry_of_type(/datum/customizer_entry/hair/head)
	if(entry)
		return entry.hair_color
	else
		return "FFFFFF"

/datum/preferences/proc/get_facial_hair_color()
	var/datum/customizer_entry/hair/entry = get_customizer_entry_of_type(/datum/customizer_entry/hair/facial)
	if(entry)
		return entry.hair_color
	else
		return "FFFFFF"

/datum/preferences/proc/get_eye_color()
	var/datum/customizer_entry/organ/eyes/entry = get_customizer_entry_of_type(/datum/customizer_entry/organ/eyes)
	if(entry)
		return entry.eye_color
	else
		return "FFFFFF"

/datum/preferences/proc/get_chest_color()
	var/list/zone_list = body_markings[BODY_ZONE_CHEST]
	if(!zone_list)
		return null
	for(var/marking_name in zone_list)
		var/datum/body_marking/marking = GLOB.body_markings[marking_name]
		if(!marking.covers_chest)
			continue
		var/marking_color = zone_list[marking_name]
		return marking_color
	return null

/datum/preferences/proc/get_customizer_entry_of_type(entry_type)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		if(entry.type == entry_type)
			return entry
	return null
