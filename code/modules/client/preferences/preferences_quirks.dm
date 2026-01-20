/datum/preferences/proc/save_quirks(savefile/S)
	if(!S)
		return

	// Save as list of lists: list(list("type" = type, "value" = value), ...)
	var/list/quirk_data = list()
	for(var/quirk_type in quirks)
		var/custom_val = quirk_customizations[quirk_type]
		quirk_data += list(list("type" = quirk_type, "value" = custom_val))

	WRITE_FILE(S["quirks"], quirk_data)

/datum/preferences/proc/load_quirks(savefile/S)
	if(!S)
		return

	quirks = list()
	quirk_customizations = list()

	var/list/quirk_data
	S["quirks"] >> quirk_data

	if(!quirk_data || !islist(quirk_data))
		return

	for(var/entry in quirk_data)
		if(!islist(entry))
			continue
		var/quirk_type = entry["type"]
		var/custom_val = entry["value"]

		if(ispath(quirk_type, /datum/quirk))
			quirks += quirk_type
			if(custom_val)
				quirk_customizations[quirk_type] = custom_val

	validate_quirks()


/datum/preferences/proc/set_quirk_customization(quirk_type, value)
	if(quirk_type in quirks)
		quirk_customizations[quirk_type] = value
		save_character()
		return TRUE
	return FALSE

/datum/preferences/proc/get_quirk_customization(quirk_type)
	return quirk_customizations[quirk_type]

/datum/preferences/proc/validate_quirks()
	if(!quirks || !islist(quirks))
		quirks = list()
		return

	// Remove invalid quirk types
	var/list/valid_quirks = list()
	for(var/quirk_type in quirks)
		if(ispath(quirk_type, /datum/quirk))
			valid_quirks += quirk_type

	quirks = valid_quirks

	// Remove quirks that are no longer available due to character changes
	var/list/available_quirks = list()
	for(var/quirk_type in quirks)
		var/datum/quirk/Q = new quirk_type()
		if(Q.is_available(src))
			available_quirks += quirk_type
		qdel(Q)

	quirks = available_quirks

	// Check point balance
	var/balance = calculate_quirk_balance()
	if(balance < 0)
		// Can't afford all boons, remove some
		while(balance < 0 && length(quirks))
			var/datum/quirk/most_expensive = find_most_expensive_boon()
			if(most_expensive)
				quirks -= most_expensive
				balance = calculate_quirk_balance()
			else
				break

	// Check boon limit
	var/boon_count = count_boons_in_list()
	while(boon_count > MAX_BOONS)
		var/datum/quirk/first_boon = find_first_boon()
		if(first_boon)
			quirks -= first_boon
			boon_count = count_boons_in_list()
		else
			break

/datum/preferences/proc/calculate_quirk_balance()
	var/balance = STARTING_QUIRK_POINTS
	for(var/datum/quirk/quirk as anything in quirks)
		balance += initial(quirk.point_value)
	return balance

/datum/preferences/proc/count_boons_in_list()
	var/count = 0
	for(var/datum/quirk/quirk as anything in quirks)
		if(initial(quirk.quirk_category) == QUIRK_BOON)
			count++
	return count

/datum/preferences/proc/find_most_expensive_boon()
	var/most_expensive = null
	var/lowest_value = 0
	for(var/datum/quirk/quirk as anything in quirks)
		if(initial(quirk.quirk_category) == QUIRK_BOON)
			if(initial(quirk.point_value) < lowest_value)
				lowest_value = initial(quirk.point_value)
				most_expensive = quirk
	return most_expensive

/datum/preferences/proc/find_first_boon()
	for(var/datum/quirk/quirk in quirks)
		if(initial(quirk.quirk_category) == QUIRK_BOON)
			return quirk
	return null

/datum/preferences/proc/can_add_quirk(quirk_type)
	if(!ispath(quirk_type, /datum/quirk))
		return FALSE

	// Check if already have this quirk
	if(quirk_type in quirks)
		return FALSE

	var/datum/quirk/new_quirk = quirk_type

	// Check if quirk is available for this character
	var/datum/quirk/temp_quirk = new quirk_type()
	if(!temp_quirk.is_available(src))
		qdel(temp_quirk)
		return FALSE
	qdel(temp_quirk)

	// Check boon limit
	if(initial(new_quirk.quirk_category) == QUIRK_BOON)
		if(count_boons_in_list() >= MAX_BOONS)
			return FALSE

	// Check point balance
	var/balance = calculate_quirk_balance()
	if(initial(new_quirk.point_value) < 0) // Costs points
		if(balance + initial(new_quirk.point_value) < 0)
			return FALSE

	// Check incompatibilities
	var/datum/quirk/singleton = GLOB.quirk_singletons[new_quirk]
	var/list/incompatible = singleton.incompatible_quirks
	for(var/quirk_type_existing in quirks)
		if(quirk_type_existing in incompatible)
			return FALSE
		var/datum/quirk/existing_singleton = GLOB.quirk_singletons[quirk_type_existing]
		var/list/existing_incompatible = existing_singleton.incompatible_quirks
		if(quirk_type in existing_incompatible)
			return FALSE

	return TRUE

/datum/preferences/proc/add_quirk(quirk_type, custom_value = null)
	if(!can_add_quirk(quirk_type))
		return FALSE
	quirks += quirk_type
	if(custom_value)
		quirk_customizations[quirk_type] = custom_value
	save_character()
	return TRUE

/datum/preferences/proc/remove_quirk(quirk_type)
	if(quirk_type in quirks)
		quirks -= quirk_type
		quirk_customizations -= quirk_type

		// After removing a quirk, validate that the remaining quirks are still affordable
		var/balance = calculate_quirk_balance()

		// If balance is now negative, we need to remove some boons
		while(balance < 0 && length(quirks))
			var/datum/quirk/most_expensive = find_most_expensive_boon()
			if(most_expensive)
				quirks -= most_expensive
				quirk_customizations -= most_expensive
				balance = calculate_quirk_balance()
			else
				break

		save_character()
		return TRUE
	return FALSE

/datum/preferences/proc/clear_quirks()
	quirks = list()
	quirk_customizations = list()
	save_character()

/datum/preferences/proc/apply_quirks_to_character(mob/living/carbon/human/H)
	if(!H)
		return

	H.clear_quirks()

	// Revalidate and apply quirks
	var/list/valid_quirks = list()
	var/list/valid_customizations = list()

	for(var/quirk_type in quirks)
		var/datum/quirk/Q = new quirk_type()

		// Check if quirk is still available
		if(!Q.is_available(src))
			to_chat(H, span_warning("The '[initial(Q.name)]' quirk is no longer available for your character."))
			qdel(Q)
			continue

		// Special handling for backstory quirk
		if(istype(Q, /datum/quirk/boon/backstory))
			var/custom_val = quirk_customizations[quirk_type]
			if(custom_val && ispath(custom_val, /datum/backstory))
				var/datum/backstory/B = new custom_val()
				if(!B.is_available(src))
					to_chat(H, span_warning("The '[initial(B.name)]' background is no longer available for your character."))
					qdel(B)
					qdel(Q)
					continue
				qdel(B)

		valid_quirks += quirk_type
		if(quirk_customizations[quirk_type])
			valid_customizations[quirk_type] = quirk_customizations[quirk_type]

		qdel(Q)

	// Update the quirk lists to only valid quirks
	quirks = valid_quirks
	quirk_customizations = valid_customizations

	quirks = sort_quirks(quirks)

	// Apply valid quirks to character
	for(var/quirk_type in quirks)
		var/custom_val = quirk_customizations[quirk_type]
		H.add_quirk(quirk_type, custom_val)

	// Save if anything changed
	if(length(quirks) != length(valid_quirks))
		save_character()

/datum/preferences/proc/open_quirk_menu(mob/user)
	var/datum/browser/popup = new(user, "quirk_menu", "Quirk Selection", 1000, 650, src)

	popup.add_stylesheet("quirk_menu", 'html/browser/quirk_menu.css')
	popup.add_script("quirk_menu", 'html/browser/quirk_menu.js')

	popup.set_content(get_quirk_menu_content())
	popup.open()

/datum/preferences/proc/get_quirk_menu_content()
	var/balance = calculate_quirk_balance()
	var/boon_count = count_boons_in_list()

	var/dat = ""

	// Header with point balance
	dat += "<div class='quirk-header'>"
	dat += "<div class='quirk-stats'>"
	dat += "<span class='stat-label'>Point Balance:</span> <span class='stat-value [balance < 0 ? "negative" : ""]'>[balance]</span>"
	dat += "<span class='stat-separator'>|</span>"
	dat += "<span class='stat-label'>Boons:</span> <span class='stat-value [boon_count >= MAX_BOONS ? "at-limit" : ""]'>[boon_count]/[MAX_BOONS]</span>"
	dat += "</div>"
	dat += "<div class='quirk-actions'>"
	dat += "<a href='?src=\ref[src];quirk_clear=1' class='action-button clear-button'>Clear All</a>"
	dat += "</div>"
	dat += "</div>"

	// Two column layout
	dat += "<div class='quirk-container'>"

	// Left column - Available quirks with tabs
	dat += "<div class='quirk-left'>"
	dat += "<div class='panel-header'>Available Quirks</div>"

	// Tab navigation
	dat += "<div class='quirk-tabs'>"
	dat += "<button class='tab-button active' data-tab='boons'>Boons</button>"
	dat += "<button class='tab-button' data-tab='vices'>Vices</button>"
	dat += "<button class='tab-button' data-tab='peculiarities'>Peculiarities</button>"
	dat += "</div>"

	// Tab content
	dat += "<div class='tab-panels'>"

	// Boons tab
	dat += "<div class='tab-panel active' id='tab-boons'>"
	dat += get_quirk_category_content(QUIRK_BOON, "boon")
	dat += "</div>"

	// Vices tab
	dat += "<div class='tab-panel' id='tab-vices'>"
	dat += get_quirk_category_content(QUIRK_VICE, "vice")
	dat += "</div>"

	// Peculiarities tab
	dat += "<div class='tab-panel' id='tab-peculiarities'>"
	dat += get_quirk_category_content(QUIRK_PECULIARITY, "peculiarity")
	dat += "</div>"

	dat += "</div>" // tab-panels
	dat += "</div>" // quirk-left

	// Right column - Selected quirks
	dat += "<div class='quirk-right'>"
	dat += "<div class='panel-header'>Selected Quirks ([length(quirks)])</div>"
	dat += "<div class='selected-panel' id='selected-panel'>"
	dat += get_selected_quirks_content()
	dat += "</div>"
	dat += "</div>" // quirk-right

	dat += "</div>" // quirk-container

	return dat

/datum/preferences/proc/get_quirk_category_content(category, category_class)
	var/dat = "<div class='quirk-list'>"

	for(var/quirk_data in GLOB.quirk_points_by_type[category])
		var/quirk_type = quirk_data["type"]
		var/is_selected = FALSE
		if(quirk_type in quirks)
			is_selected = TRUE
		var/can_add = can_add_quirk(quirk_type)

		var/card_classes = "quirk-card [category_class]"
		if(is_selected)
			card_classes += " selected"
		else if(!can_add)
			card_classes += " disabled"

		dat += "<div class='[card_classes]' data-quirk='\ref[quirk_type]'>"
		dat += "<div class='quirk-card-header'>"
		dat += "<span class='quirk-name'>[quirk_data["name"]]</span>"
		dat += "<span class='quirk-points'>[quirk_data["value"]] pts</span>"
		dat += "</div>"
		dat += "<div class='quirk-desc'>[quirk_data["desc"]]</div>"

		if(is_selected)
			dat += "<div class='quirk-status'>Selected</div>"
		else if(!can_add)
			dat += "<div class='quirk-status disabled-text'>Cannot add</div>"
		dat += "</div>"

	dat += "</div>"
	return dat

/datum/preferences/proc/get_selected_quirks_content()
	if(!length(quirks))
		return "<div class='empty-state'>No quirks selected.<br><br>Click on quirks from the left panel to add them.</div>"

	var/dat = "<div class='quirk-list'>"

	for(var/quirk_type in quirks)
		var/datum/quirk/quirk = GLOB.quirk_singletons[quirk_type]
		var/category = quirk.quirk_category
		var/category_class = ""

		switch(category)
			if(QUIRK_BOON)
				category_class = "boon"
			if(QUIRK_VICE)
				category_class = "vice"
			if(QUIRK_PECULIARITY)
				category_class = "peculiarity"

		dat += "<div class='quirk-card [category_class] selected' data-quirk='\ref[quirk_type]'>"
		dat += "<div class='quirk-card-header'>"
		dat += "<span class='quirk-name'>[quirk.name]</span>"
		dat += "<span class='quirk-points'>[quirk.point_value] pts</span>"
		dat += "</div>"
		dat += "<div class='quirk-desc'>[quirk.get_desc(src)]</div>"

		var/custom_type = quirk.customization_type
		var/list/options = quirk?.return_customization(src)

		if(custom_type == QUIRK_TEXT)
			// Text input customization
			var/label = quirk.customization_label
			var/placeholder = quirk.customization_placeholder
			var/current_value = quirk_customizations[quirk_type]

			dat += "<div class='quirk-customization'>"
			dat += "<label>[label]:</label>"
			dat += "<input type='text' class='quirk-text-input' data-quirk='\ref[quirk_type]' "
			dat += "placeholder='[placeholder]' value='[current_value ? current_value : ""]' "
			dat += "onchange='updateQuirkText(this)' onclick='event.stopPropagation()' />"
			dat += "</div>"

		else if(length(options))
			// Dropdown customization
			var/label = quirk.customization_label
			var/current_value = quirk_customizations[quirk_type]

			dat += "<div class='quirk-customization'>"
			dat += "<label>[label]:</label>"
			dat += "<select class='quirk-select' data-quirk='\ref[quirk_type]' onchange='updateQuirkCustomization(this)'>"

			if(!current_value)
				dat += "<option value='' selected>-- Select --</option>"

			for(var/option in options)
				var/option_name = quirk.get_option_name(option)
				var/selected = (current_value == option) ? "selected" : ""
				dat += "<option value='\ref[option]' [selected]>[option_name]</option>"

			dat += "</select>"
			dat += "</div>"

		dat += "<div class='quirk-status'>Click to remove</div>"
		dat += "</div>"

	dat += "</div>"
	return dat

/mob/living/carbon/human/proc/apply_character_quirks()
	if(client?.prefs)
		client.prefs.apply_quirks_to_character(src)

/client/Topic(href, href_list)
	. = ..()
	if(href_list["quirk_add"])
		var/quirk_ref = locate(href_list["quirk_add"])
		if(quirk_ref && ispath(quirk_ref, /datum/quirk))
			prefs.add_quirk(quirk_ref)
			prefs.open_quirk_menu(usr)
		return TRUE

	if(href_list["quirk_remove"])
		var/quirk_ref = locate(href_list["quirk_remove"])
		if(quirk_ref)
			prefs.remove_quirk(quirk_ref)
			prefs.open_quirk_menu(usr)
		return TRUE

	if(href_list["quirk_customize"])
		var/quirk_ref = locate(href_list["quirk_customize"])
		var/value_ref = href_list["value"] // Can be a reference or plain text now

		if(quirk_ref)
			// Try to locate the value (for dropdown options)
			var/actual_value = locate(value_ref)
			if(!actual_value)
				// If locate fails, it's plain text (for text inputs)
				actual_value = value_ref

			prefs.set_quirk_customization(quirk_ref, actual_value)
			prefs.open_quirk_menu(usr)
		return TRUE

	if(href_list["quirk_text_update"])
		var/quirk_ref = locate(href_list["quirk_text_update"])
		var/text_value = href_list["text"]

		if(quirk_ref)
			prefs.set_quirk_customization(quirk_ref, text_value)
		return TRUE

	if(href_list["quirk_clear"])
		prefs.clear_quirks()
		prefs.open_quirk_menu(usr)
		return TRUE

	if(href_list["quirk_close"])
		var/mob/user = usr
		user << browse(null, "window=quirk_menu")
		return TRUE
