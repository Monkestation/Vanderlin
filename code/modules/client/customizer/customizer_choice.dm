/datum/customizer_choice
	abstract_type = /datum/customizer_choice
	/// User facing name of the customizer choice.
	var/name = "Customizer"
	/// Type of the entry datum which is used for save/load of information.
	var/customizer_entry_type = /datum/customizer_entry
	/// List of sprite accessories this choice allows. Can be null
	var/list/sprite_accessories
	/// The default sprite accessory from `sprite_accessories`.
	var/default_accessory
	/// Whether this customizer choice allows to customize colors of sprite accessories.
	var/allows_accessory_color_customization = TRUE
	/// Whether to pick a random accessory from all possible ones in `sprite_accessories` rather than use the proc for randomization
	var/generic_random_pick = FALSE

/datum/customizer_choice/New()
	. = ..()
	if(length(sprite_accessories))
		if(!default_accessory)
			default_accessory = sprite_accessories[1]
		if(!(default_accessory in sprite_accessories))
			CRASH("Customizer choice [type] has a default accessory which is unavailable in its accessory list.")

//this exists because npcs don't have perfs so load based on carbon dna
/datum/customizer_choice/proc/return_species(datum/preferences/prefs)
	if(istype(prefs))
		return prefs.pref_species
	else
		var/mob/living/carbon/carbon = prefs
		return carbon?.dna?.species

/datum/customizer_choice/proc/apply_customizer_to_character(mob/living/carbon/human/human, datum/preferences/prefs, datum/customizer_entry/entry)
	return

/datum/customizer_choice/proc/make_default_customizer_entry(datum/preferences/prefs, customizer_type, changed_entry = TRUE)
	var/datum/customizer_entry/entry = new customizer_entry_type()
	entry.customizer_type = customizer_type
	entry.customizer_choice_type = type
	if(sprite_accessories)
		set_accessory_type(prefs, default_accessory, entry)
	return entry

/datum/customizer_choice/proc/randomize_entry(datum/customizer_entry/entry, datum/preferences/prefs, color = TRUE, accessory = TRUE)
	if(accessory)
		var/random_accessory
		if(generic_random_pick && sprite_accessories)
			random_accessory = pick(sprite_accessories)
		else
			random_accessory = get_random_accessory(entry, prefs)
		if(random_accessory)
			set_accessory_type(prefs, random_accessory, entry)
	if(color)
		var/random_color = get_random_color(entry, prefs, entry?.accessory_type)
		if(random_color)
			set_accessory_colors(prefs, entry, random_color)
	on_randomize_entry(entry, prefs)

/datum/customizer_choice/proc/on_randomize_entry(datum/customizer_entry/entry, datum/preferences/prefs)
	return

/datum/customizer_choice/proc/get_random_accessory(datum/customizer_entry/entry, datum/preferences/prefs)
	return

/datum/customizer_choice/proc/get_random_color(datum/customizer_entry/entry, datum/preferences/prefs, accessory_type)
	return

/datum/customizer_choice/proc/show_pref_choices(datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	var/list/dat = list()
	generate_pref_choices(dat, prefs, entry, customizer_type)
	return dat

/datum/customizer_choice/proc/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	var/datum/sprite_accessory/accessory
	if(sprite_accessories && entry?.accessory_type)
		accessory = SPRITE_ACCESSORY(entry?.accessory_type)

	if(accessory)
		var/accessory_link
		var/arrows_string
		var/dropdown_button

		if(length(sprite_accessories) > 1)
			accessory_link = "href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=choose_acc'"
			arrows_string = "<a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=rotate;rotate=prev' style='font-size:16px; padding:0 5px;'><</a><a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=rotate;rotate=next' style='font-size:16px; padding:0 5px;'>></a>"
			dropdown_button = "<a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=toggle_dropdown' style='font-size:12px; padding:0 5px;'>View All</a>"
		else
			accessory_link = "class='linkOff'"
			arrows_string = "<a class='linkOff' style='font-size:16px; padding:0 5px;'><</a><a class='linkOff' style='font-size:16px; padding:0 5px;'>></a>"
			dropdown_button = ""

		dat += "<div style='text-align:center; margin:10px 0;'>"
		dat += "<div style='background-color:#0a0a0a; padding:10px; border-radius:5px; display:inline-block;'>"

		dat += "<div style='margin-bottom:5px;'>"
		dat += "<img id='accessory_preview' src='\ref[initial(accessory.icon)]?state=[initial(accessory.icon_state)]'/>"
		dat += "</div>"

		dat += "<div style='margin:5px 0;'>"
		dat += "[arrows_string] <a [accessory_link]>[accessory.name]</a> [dropdown_button]"
		dat += "</div>"

		dat += "</div>"
		dat += "</div>"

		// Dropdown grid (hidden by default, toggled via href)
		if(entry.show_dropdown && length(sprite_accessories) > 1)
			dat += "<div style='background-color:#1a1a1a; padding:10px; border-radius:5px; margin:10px 0;'>"
			dat += "<div style='display:grid; grid-template-columns:repeat(auto-fill, minmax(80px, 1fr)); gap:8px; max-height:300px; overflow-y:auto;'>"

			var/grid_index = 0
			for(var/acc_type in sprite_accessories)
				var/datum/sprite_accessory/acc = SPRITE_ACCESSORY(acc_type)
				var/is_selected = (acc_type == entry.accessory_type)
				var/border_style = is_selected ? "border:2px solid #4a9eff;" : "border:1px solid #333;"
				grid_index++

				dat += "<a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=select_acc;acc_type=[acc_type]' style='text-decoration:none;'>"
				dat += "<div id='grid_container_[grid_index]' style='background-color:#0a0a0a; padding:5px; border-radius:3px; [border_style] text-align:center; cursor:pointer;'>"
				dat += "<img id='grid_preview_[grid_index]' src='\ref[initial(acc.icon)]?state=[initial(acc.icon_state)]' style='display:block; margin:0 auto;'/>"
				dat += "<div style='font-size:10px; margin-top:3px; color:[is_selected ? "#4a9eff" : "#ffffff"];'>[acc.name]</div>"
				dat += "<script>"
				dat += "(function() {"
				dat += "  var container = document.getElementById('grid_container_[grid_index]');"
				dat += "  var img = document.getElementById('grid_preview_[grid_index]');"
				dat += "  var baseUrl = '\ref[initial(acc.icon)]';"
				dat += "  var directions = \['', '&dir=4', '&dir=8', '&dir=1'\];"
				dat += "  var currentDir = 0;"
				dat += "  var animInterval;"
				dat += "  container.addEventListener('mouseenter', function() {"
				dat += "    animInterval = setInterval(function() {"
				dat += "      currentDir = (currentDir + 1) % directions.length;"
				dat += "      img.src = baseUrl + '?state=[initial(acc.icon_state)]' + directions\[currentDir\];"
				dat += "    }, 200);"
				dat += "  });"
				dat += "  container.addEventListener('mouseleave', function() {"
				dat += "    clearInterval(animInterval);"
				dat += "    currentDir = 0;"
				dat += "    img.src = baseUrl + '?state=[initial(acc.icon_state)]';"
				dat += "  });"
				dat += "})();"
				dat += "</script>"
				dat += "</div>"
				dat += "</a>"

			dat += "</div>"
			dat += "</div>"

		if(allows_accessory_color_customization)
			dat += "<br><a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=reset_colors'>Reset colors</a>"
			var/list/color_list = color_string_to_list(entry.accessory_colors)
			for(var/index in 1 to accessory.color_keys)
				var/named_index = (accessory.color_keys == 1) ? accessory.color_key_name : accessory.color_key_names[index]
				dat += "<br>[named_index]: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=acc_color;color_index=[index]''><span class='color_holder_box' style='background-color:[color_list[index]]'></span></a>"

/datum/customizer_choice/proc/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	switch(href_list["customizer_task"])
		if("toggle_dropdown")
			if(!sprite_accessories)
				return
			entry.show_dropdown = !entry.show_dropdown

		if("select_acc")
			if(!sprite_accessories)
				return
			var/acc_type = text2path(href_list["acc_type"])
			if(!(acc_type in sprite_accessories))
				return
			set_accessory_type(prefs, acc_type, entry)
			entry.show_dropdown = FALSE // Close dropdown after selection

		if("choose_acc")
			if(!sprite_accessories)
				return
			var/list/choice_list = list()
			for(var/choice_type in sprite_accessories)
				var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(choice_type)
				choice_list[accessory.name] = choice_type
			var/chosen_input = browser_input_list(user, "Choose your [lowertext(name)] appearance:", "Character Preference", choice_list)
			if(!chosen_input)
				return
			var/choice_type = choice_list[chosen_input]
			set_accessory_type(prefs, choice_type, entry)

		if("rotate")
			if(!sprite_accessories)
				return
			var/current_index
			var/i = 0
			for(var/accessory_type in sprite_accessories)
				i++
				if(entry?.accessory_type != accessory_type)
					continue
				current_index = i
				break
			var/target_index = current_index

			switch(href_list["rotate"])
				if("next")
					target_index++
				if("prev")
					target_index--
			if(target_index > sprite_accessories.len)
				target_index = 1
			else if (target_index <= 0)
				target_index = sprite_accessories.len
			var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
			customizer_choice.set_accessory_type(prefs, sprite_accessories[target_index], entry)

		if("acc_color")
			if(!sprite_accessories || !allows_accessory_color_customization)
				return
			var/index = text2num(href_list["color_index"])
			var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry?.accessory_type)
			if(index > accessory.color_keys)
				return
			var/list/color_list = color_string_to_list(entry.accessory_colors)
			var/new_color = color_pick_sanitized_lumi(user, "Choose your accessory color:", "Character Preference","[color_list[index]]")
			if(!new_color)
				return
			color_list[index] = sanitize_hexcolor(new_color, 6, TRUE)
			entry.accessory_colors = color_list_to_string(color_list)
		if("reset_colors")
			if(!sprite_accessories || !allows_accessory_color_customization)
				return
			reset_accessory_colors(prefs, entry)

/datum/customizer_choice/proc/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	/// Validate chosen accessory
	if(entry?.accessory_type && !sprite_accessories)
		entry?.accessory_type = null
		entry.accessory_colors = null
	else if (sprite_accessories && !(entry?.accessory_type in sprite_accessories))
		set_accessory_type(prefs, default_accessory, entry)
	/// Validate colors
	if(entry?.accessory_type)
		var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry?.accessory_type)
		if(accessory.color_keys != 0)
			var/reset_colors = FALSE
			if(!entry.accessory_colors)
				reset_colors = TRUE
			else
				var/list/color_list = color_string_to_list(entry.accessory_colors)
				if(color_list.len != accessory.color_keys)
					reset_colors = TRUE
			if(reset_colors)
				entry.accessory_colors = accessory.get_default_colors(color_key_source_list_from_prefs(prefs))

/datum/customizer_choice/proc/set_accessory_type(datum/preferences/prefs, new_accessory_type, datum/customizer_entry/entry)
	if(entry?.accessory_type == new_accessory_type)
		return
	if(!entry.customizer_choice_type)
		CRASH("Tried to set a customizer entry accessory without a customizer choice.")
	if(!(new_accessory_type in sprite_accessories))
		CRASH("Tried to set an customizer entry accessory that isn't allowed for the customizer choice.")

	entry?.accessory_type = new_accessory_type
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry?.accessory_type)
	entry.accessory_colors = accessory.get_default_colors(color_key_source_list_from_prefs(prefs))

/datum/customizer_choice/proc/set_accessory_colors(datum/preferences/prefs, datum/customizer_entry/entry, color)
	entry.accessory_colors = color

/datum/customizer_choice/proc/reset_accessory_colors(datum/preferences/prefs, datum/customizer_entry/entry)
	if(!entry?.accessory_type)
		return
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry?.accessory_type)
	entry.accessory_colors = accessory.get_default_colors(color_key_source_list_from_prefs(prefs))

/// When you want to customize an organ but not through DNA (hair dye for example)
/datum/customizer_choice/proc/get_organ_slot(obj/item/organ/organ, datum/customizer_entry/entry)
	return FALSE

/datum/customizer_choice/proc/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	return

/datum/customizer_choice/proc/create_organ_dna(datum/customizer_entry/entry, datum/preferences/prefs)
	return

/datum/customizer_choice/proc/customize_organ(obj/item/organ/organ, datum/customizer_entry/entry)
	return
