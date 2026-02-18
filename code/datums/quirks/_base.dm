GLOBAL_LIST_INIT(quirk_registry, list())
GLOBAL_LIST_EMPTY(quirk_singletons)
GLOBAL_LIST_EMPTY(quirk_points_by_type)

/proc/init_quirk_registry()
	GLOB.quirk_registry = list()
	GLOB.quirk_points_by_type = list(
		QUIRK_BOON = list(),
		QUIRK_VICE = list(),
		QUIRK_PECULIARITY = list()
	)

	for(var/datum/quirk/quirk_type as anything in subtypesof(/datum/quirk))
		if(IS_ABSTRACT(quirk_type))
			continue

		var/category = initial(quirk_type.quirk_category)
		GLOB.quirk_registry[initial(quirk_type.name)] = quirk_type
		GLOB.quirk_points_by_type[category] += list(list(
			"name" = initial(quirk_type.name),
			"type" = quirk_type,
			"desc" = initial(quirk_type.desc),
			"value" = initial(quirk_type.point_value)
		))
		LAZYADDASSOC(GLOB.quirk_singletons, quirk_type, new quirk_type)

/proc/sort_quirks(list/quirk_types)
	// Sort by apply_order (descending), then alphabetically by name
	var/list/sorted = quirk_types.Copy()

	for(var/i = 1 to length(sorted))
		for(var/j = 1 to length(sorted) - 1)
			var/datum/quirk/current = sorted[j]
			var/datum/quirk/next = sorted[j + 1]

			var/current_order = initial(current.apply_order)
			var/next_order = initial(next.apply_order)
			var/current_name = initial(current.name)
			var/next_name = initial(next.name)

			if(current_order < next_order)
				sorted[j] = next
				sorted[j + 1] = current
			else if(current_order == next_order && sorttext(current_name, next_name) > 0)
				sorted[j] = next
				sorted[j + 1] = current

	return sorted

/datum/quirk
	abstract_type = /datum/quirk
	///this is basically our apply order, if 0 we don't care, higher is better
	var/apply_order = 0

	/// The quirk's name shown to players
	var/name = "Quirk"
	/// Description of what this quirk does
	var/desc = "A quirk."
	/// Category: QUIRK_BOON, QUIRK_VICE, or QUIRK_PECULIARITY
	var/quirk_category = QUIRK_PECULIARITY
	/// Point value (negative = costs points, positive = gives points)
	var/point_value = 0
	/// List of quirk types incompatible with this one
	var/list/incompatible_quirks = list()
	/// The mob this quirk is attached to
	var/mob/living/owner
	/// Can this be randomly selected?
	var/random_exempt = FALSE
	/// Does this render in the preview?
	var/preview_render = TRUE

	/// List of options the player can select from (can be paths or strings)
	var/list/customization_options = list()
	/// The selected customization value
	var/customization_value = null
	/// Label for the customization dropdown
	var/customization_label = "Select Option"

	/// Type of customization: "select" for dropdown, "text" for text input
	var/customization_type = QUIRK_SELECT
	/// Placeholder text for text inputs
	var/customization_placeholder = "Enter text..."

	/// List of allowed ages (empty = all allowed)
	var/list/allowed_ages = list()
	/// List of blocked ages
	var/list/blocked_ages = list()
	/// List of allowed species (empty = all allowed)
	var/list/allowed_species = list()
	/// List of blocked species
	var/list/blocked_species = list()

/datum/quirk/New(mob/living/new_owner, custom_value = null)
	. = ..()
	if(new_owner)
		owner = new_owner
		if(custom_value)
			customization_value = custom_value
		if(!preview_render && istype(owner, /mob/living/carbon/human/dummy))
			return
		on_spawn()

/datum/quirk/Destroy()
	on_remove()
	owner = null
	return ..()

/datum/quirk/proc/get_desc(datum/preferences/prefs)
	return desc

/datum/quirk/proc/after_job_spawn(datum/job/job)
	return

/datum/quirk/proc/get_option_name(option)
	if(ispath(option))
		// Try to get the name from the type
		var/atom/A = option
		return initial(A.name)
	return "[option]"

/// Called when the quirk is applied to a character runs before everything (you probably want a real good rason to use this)
/datum/quirk/proc/on_pre_spawn()
	return

/// Called when the quirk is applied to a character
/datum/quirk/proc/on_spawn()
	return

/// Called when the quirk is removed
/datum/quirk/proc/on_remove()
	return

/// Called every life tick if implemented
/datum/quirk/proc/on_life(mob/living/user)
	return

/// Check if this quirk is compatible with a list of existing quirks
/datum/quirk/proc/is_compatible_with(list/datum/quirk/existing_quirks)
	for(var/datum/quirk/Q in existing_quirks)
		if(Q.type in incompatible_quirks)
			return FALSE
		if(type in Q.incompatible_quirks)
			return FALSE
	return TRUE

/datum/quirk/proc/return_customization(datum/preferences/prefs)
	return customization_options.Copy()

/// Check if this quirk is available for the given preferences
/datum/quirk/proc/is_available(datum/preferences/prefs)
	if(!prefs)
		return TRUE

	// Check age restrictions
	if(length(allowed_ages) && !(prefs.age in allowed_ages))
		return FALSE
	if(prefs.age in blocked_ages)
		return FALSE

	// Check species restrictions
	if(length(allowed_species) && !(prefs.pref_species.type in allowed_species))
		return FALSE
	if(prefs.pref_species.type in blocked_species)
		return FALSE

	return TRUE

/mob/living/proc/add_quirk(quirk_type)
	return

/mob/living/carbon/human/add_quirk(quirk_type, custom_value = null)
	if(!ispath(quirk_type, /datum/quirk))
		return FALSE

	for(var/datum/quirk/Q in quirks)
		if(Q.type == quirk_type)
			return FALSE

	var/datum/quirk/new_quirk = new quirk_type(src, custom_value)
	quirks += new_quirk
	return TRUE

/mob/living/proc/remove_quirk(quirk_type)
	return

/mob/living/carbon/human/remove_quirk(quirk_type)
	for(var/datum/quirk/Q in quirks)
		if(Q.type == quirk_type)
			quirks -= Q
			qdel(Q)
			return TRUE
	return FALSE

/mob/living/proc/has_quirk(quirk_type)
	return

/mob/living/carbon/human/has_quirk(quirk_type)
	for(var/datum/quirk/Q in quirks)
		if(istype(Q, quirk_type))
			return TRUE
	return FALSE

/mob/living/proc/get_quirk(quirk_type)
	return

/mob/living/carbon/human/get_quirk(quirk_type)
	for(var/datum/quirk/Q in quirks)
		if(istype(Q, quirk_type))
			return Q
	return null

/mob/living/carbon/human/proc/clear_quirks()
	for(var/datum/quirk/Q in quirks)
		qdel(Q)
	quirks = list()

// Calculate total point balance from quirks
/mob/living/carbon/human/proc/get_quirk_balance()
	var/balance = STARTING_QUIRK_POINTS
	for(var/datum/quirk/Q in quirks)
		balance += Q.point_value
	return balance

// Count boons (negative point quirks)
/mob/living/carbon/human/proc/count_boons()
	var/count = 0
	for(var/datum/quirk/Q in quirks)
		if(Q.quirk_category == QUIRK_BOON)
			count++
	return count

// Validate quirk selection
/mob/living/carbon/human/proc/can_add_quirk(quirk_type)
	if(!ispath(quirk_type, /datum/quirk))
		return FALSE

	var/datum/quirk/temp_quirk = quirk_type

	// Check boon limit
	if(initial(temp_quirk.quirk_category) == QUIRK_BOON)
		if(count_boons() >= MAX_BOONS)
			return FALSE

	// Check point balance
	var/balance = get_quirk_balance()
	if(initial(temp_quirk.point_value) < 0) // Costs points
		if(balance + initial(temp_quirk.point_value) < 0)
			return FALSE

	// Check compatibility
	var/datum/quirk/test_quirk = new quirk_type()
	var/compatible = test_quirk.is_compatible_with(quirks)
	qdel(test_quirk)

	return compatible
