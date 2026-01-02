GLOBAL_LIST_EMPTY(player_profession_managers)

/datum/profession_manager
	var/ckey
	var/datum/save_manager/save_manager
	var/list/profession_data = list()
	var/list/active_professions = list() // Changed from single to list of 2
	var/mob/attached_mob = null // The mob this manager is attached to
	var/list/applied_passives = list() // List of currently applied passive datums

/datum/profession_manager/New(target_ckey, mob/target_mob = null)
	if(!target_ckey)
		qdel(src)
		return

	ckey = ckey(target_ckey)
	attached_mob = target_mob
	save_manager = get_save_manager(ckey)
	if(!save_manager)
		qdel(src)
		return

	load_profession_data()
	if(attached_mob)
		apply_all_passives()

/datum/profession_manager/Destroy()
	if(attached_mob)
		remove_all_passives()
	attached_mob = null
	return ..()

/datum/profession_manager/proc/attach_to_mob(mob/target_mob)
	if(attached_mob == target_mob)
		return

	// Remove passives from old mob
	if(attached_mob)
		remove_all_passives()

	// Attach to new mob
	attached_mob = target_mob
	if(attached_mob)
		apply_all_passives()

/datum/profession_manager/proc/detach_from_mob()
	if(attached_mob)
		remove_all_passives()
		attached_mob = null

/datum/profession_manager/proc/load_profession_data()
	profession_data = save_manager.get_data("professions", "data", list())
	active_professions = save_manager.get_data("professions", "active", list())

	// Ensure active_professions is a list and cap it at 2
	if(!islist(active_professions))
		active_professions = list()
	if(length(active_professions) > 2)
		active_professions.len = 2

/datum/profession_manager/proc/save_profession_data()
	save_manager.set_data("professions", "data", profession_data)
	save_manager.set_data("professions", "active", active_professions)

/datum/profession_manager/proc/get_profession_info(profession_name)
	if(!profession_name || !(profession_name in profession_data))
		return list(
			"level" = 1,
			"xp" = 0,
			"unlocked_recipes" = list(),
			"unlocked_passives" = list(),
			"unlocked_abilities" = list(),
			"total_xp_earned" = 0,
		"frozen" = FALSE  // Track if level progression is frozen
		)

	return profession_data[profession_name]

/datum/profession_manager/proc/get_true_profession_info(profession_name)
	// Internal method that returns actual data regardless of active status
	if(!profession_name || !(profession_name in profession_data))
		return list(
			"level" = 1,
			"xp" = 0,
			"unlocked_recipes" = list(),
			"unlocked_passives" = list(),
			"unlocked_abilities" = list(),
			"total_xp_earned" = 0,
			"frozen" = FALSE
		)

	return profession_data[profession_name]

/datum/profession_manager/proc/initialize_profession(profession_name)
	if(!profession_name)
		return FALSE

	if(profession_name in profession_data)
		return TRUE

	profession_data[profession_name] = list(
		"level" = 1,
		"xp" = 0,
		"unlocked_recipes" = list(),
		"unlocked_passives" = list(),
		"unlocked_abilities" = list(),
		"total_xp_earned" = 0
	)

	save_profession_data()
	return TRUE

/datum/profession_manager/proc/add_xp(profession_name, amount)
	if(!profession_name || amount <= 0)
		return FALSE

	// Check if profession is active - only active professions can gain XP
	if(!(profession_name in active_professions))
		return FALSE

	var/datum/profession/prof = get_profession_datum(profession_name)
	if(!prof)
		return FALSE

	initialize_profession(profession_name)

	var/list/prof_data = profession_data[profession_name]  // Use direct access for internal operations
	var/old_level = prof_data["level"]

	prof_data["xp"] += amount
	prof_data["total_xp_earned"] += amount

	var/new_level = prof.get_level_from_xp(prof_data["xp"])
	prof_data["level"] = new_level

	// Check for level ups and unlock new content
	if(new_level > old_level)
		handle_level_ups(profession_name, old_level, new_level, prof)

	save_profession_data()
	return new_level

/datum/profession_manager/proc/handle_level_ups(profession_name, old_level, new_level, datum/profession/prof)
	var/list/prof_data = profession_data[profession_name]  // Use direct access for internal operations
	var/list/new_recipes = list()
	var/list/new_passives = list()
	var/list/new_abilities = list()

	// Check each level between old and new for unlocks
	for(var/level = old_level + 1 to new_level)
		var/list/unlocks = prof.get_unlocks_at_level(level)

		for(var/recipe_type in unlocks[RECIPE_KEY])
			var/recipe_type_text = "[recipe_type]"
			if(!(recipe_type_text in prof_data["unlocked_recipes"]))
				prof_data["unlocked_recipes"] += recipe_type_text
				new_recipes += recipe_type

		for(var/passive_type in unlocks[PASSIVE_KEY])
			var/passive_type_text = "[passive_type]"
			if(!(passive_type_text in prof_data["unlocked_passives"]))
				prof_data["unlocked_passives"] += passive_type_text
				new_passives += passive_type

		for(var/ability_type in unlocks[ABILITY_KEY])
			var/ability_type_text = "[ability_type]"
			if(!(ability_type_text in prof_data["unlocked_abilities"]))
				prof_data["unlocked_abilities"] += ability_type_text
				new_abilities += ability_type

	// If this is one of the active professions and we have a mob, refresh passives
	if(attached_mob && (profession_name in active_professions))
		refresh_passives()

	// Notify player of unlocks
	notify_level_up(profession_name, old_level, new_level, new_recipes, new_passives, new_abilities)

/datum/profession_manager/proc/notify_level_up(profession_name, old_level, new_level, list/recipes, list/passives, list/abilities)
	// Override this or call it from your game's notification system
	return

/datum/profession_manager/proc/set_active_profession(profession_name, slot = 1)
	if(slot < 1 || slot > 2)
		return FALSE

	// Ensure we have enough slots
	while(length(active_professions) < 2)
		active_professions += null

	var/old_profession = active_professions[slot]

	if(!profession_name)
		active_professions[slot] = null
	else
		initialize_profession(profession_name)
		active_professions[slot] = profession_name

	// If we're changing professions, freeze the old one's level progression
	if(old_profession && old_profession != profession_name)
		freeze_profession_level(old_profession)

	// If we're activating a profession, unfreeze its level progression
	if(profession_name)
		unfreeze_profession_level(profession_name)

	save_profession_data()
	if(attached_mob)
		refresh_passives()
	return TRUE

/datum/profession_manager/proc/add_active_profession(profession_name)
	if(!profession_name)
		return FALSE

	// Don't add if already active
	if(profession_name in active_professions)
		return FALSE

	initialize_profession(profession_name)

	// Find first empty slot
	for(var/i = 1 to 2)
		if(i > length(active_professions) || !active_professions[i])
			return set_active_profession(profession_name, i)

	// If no empty slots, replace the first one
	return set_active_profession(profession_name, 1)

/datum/profession_manager/proc/remove_active_profession(profession_name)
	if(!profession_name || !(profession_name in active_professions))
		return FALSE

	for(var/i = 1 to length(active_professions))
		if(active_professions[i] == profession_name)
			active_professions[i] = null
			// Freeze the profession's level progression when deactivated
			freeze_profession_level(profession_name)
			save_profession_data()
			if(attached_mob)
				refresh_passives()
			return TRUE

	return FALSE

/datum/profession_manager/proc/get_active_profession_info(slot = 1)
	if(slot < 1 || slot > length(active_professions) || !active_professions[slot])
		return null

	return get_profession_info(active_professions[slot])

/datum/profession_manager/proc/get_all_active_profession_info()
	var/list/info = list()
	for(var/i = 1 to length(active_professions))
		if(active_professions[i])
			info += list(get_profession_info(active_professions[i]))
	return info

/datum/profession_manager/proc/learn_recipe(recipe_type, profession_name = null)
	if(!recipe_type)
		return FALSE

	if(!profession_name)
		return FALSE

	if(!profession_name || !(profession_name in active_professions))
		return FALSE // Can only learn recipes for active professions

	initialize_profession(profession_name)
	var/list/prof_data = profession_data[profession_name]
	var/recipe_type_text = "[recipe_type]"

	if(!(recipe_type_text in prof_data["unlocked_recipes"]))
		prof_data["unlocked_recipes"] += recipe_type_text
		save_profession_data()
		return TRUE

	return FALSE // Already known

/datum/profession_manager/proc/has_recipe_unlocked(recipe_type, profession_name = null)
	var/list/professions_to_check = list()

	if(profession_name)
		professions_to_check += profession_name
	else
		// Check all active professions
		for(var/prof in active_professions)
			if(prof)
				professions_to_check += prof

	if(!length(professions_to_check))
		return FALSE

	for(var/prof in professions_to_check)
		var/list/prof_data = get_profession_info(prof)
		var/list/unlocked_recipe_types = prof_data["unlocked_recipes"]

		for(var/unlocked_type in unlocked_recipe_types)
			if(ispath(recipe_type, text2path(unlocked_type)))
				return TRUE

	return FALSE

/datum/profession_manager/proc/has_recipe_type_unlocked(recipe_type, profession_name = null)
	// Alternative method that checks by type path
	return has_recipe_unlocked(recipe_type, profession_name)

/datum/profession_manager/proc/get_unlocked_recipes_of_type(recipe_base_type, profession_name = null)
	var/list/professions_to_check = list()

	if(profession_name)
		professions_to_check += profession_name
	else
		// Check all active professions
		for(var/prof in active_professions)
			if(prof)
				professions_to_check += prof

	if(!length(professions_to_check))
		return list()

	var/list/matching_recipes = list()
	for(var/prof in professions_to_check)
		var/list/prof_data = get_profession_info(prof)
		for(var/recipe_text in prof_data["unlocked_recipes"])
			var/recipe_type = text2path(recipe_text)
			if(recipe_type && ispath(recipe_type, recipe_base_type))
				matching_recipes |= recipe_type // Use |= to avoid duplicates

	return matching_recipes

/datum/profession_manager/proc/get_all_unlocked_recipe_types(profession_name = null)
	var/list/professions_to_check = list()

	if(profession_name)
		professions_to_check += profession_name
	else
		// Check all active professions
		for(var/prof in active_professions)
			if(prof)
				professions_to_check += prof

	if(!length(professions_to_check))
		return list()

	var/list/recipe_types = list()
	for(var/prof in professions_to_check)
		var/list/prof_data = get_profession_info(prof)
		for(var/recipe_text in prof_data["unlocked_recipes"])
			var/recipe_type = text2path(recipe_text)
			if(recipe_type)
				recipe_types |= recipe_type // Use |= to avoid duplicates

	return recipe_types

/datum/profession_manager/proc/has_passive_unlocked(passive_type, profession_name = null)
	var/list/professions_to_check = list()

	if(profession_name)
		professions_to_check += profession_name
	else
		// Check all active professions
		for(var/prof in active_professions)
			if(prof)
				professions_to_check += prof

	if(!length(professions_to_check))
		return FALSE

	var/passive_type_text = "[passive_type]"
	for(var/prof in professions_to_check)
		var/list/prof_data = get_profession_info(prof)
		if(passive_type_text in prof_data["unlocked_passives"])
			return TRUE

	return FALSE

/datum/profession_manager/proc/get_highest_passive_level_of_type(passive_base_type, profession_name = null)
	var/list/professions_to_check = list()

	if(profession_name)
		professions_to_check += profession_name
	else
		// Check all active professions
		for(var/prof in active_professions)
			if(prof)
				professions_to_check += prof

	if(!length(professions_to_check))
		return 0

	var/highest_level = 0
	for(var/prof in professions_to_check)
		var/list/prof_data = get_profession_info(prof)
		for(var/passive_text in prof_data["unlocked_passives"])
			var/passive_type = text2path(passive_text)
			if(passive_type && ispath(passive_type, passive_base_type))
				// Create a temporary instance to check its level
				var/datum/passive/temp_passive = new passive_type()
				if(temp_passive.passive_level > highest_level)
					highest_level = temp_passive.passive_level
				qdel(temp_passive)

	return highest_level

/datum/profession_manager/proc/has_ability_unlocked(ability_type, profession_name = null)
	var/list/professions_to_check = list()

	if(profession_name)
		professions_to_check += profession_name
	else
		// Check all active professions
		for(var/prof in active_professions)
			if(prof)
				professions_to_check += prof

	if(!length(professions_to_check))
		return FALSE

	var/ability_type_text = "[ability_type]"
	for(var/prof in professions_to_check)
		var/list/prof_data = get_profession_info(prof)
		if(ability_type_text in prof_data["unlocked_abilities"])
			return TRUE

	return FALSE

/datum/profession_manager/proc/get_unlocked_passives_of_type(passive_base_type, profession_name = null)
	var/list/professions_to_check = list()

	if(profession_name)
		professions_to_check += profession_name
	else
		// Check all active professions
		for(var/prof in active_professions)
			if(prof)
				professions_to_check += prof

	if(!length(professions_to_check))
		return list()

	var/list/matching_passives = list()
	for(var/prof in professions_to_check)
		var/list/prof_data = get_profession_info(prof)
		for(var/passive_text in prof_data["unlocked_passives"])
			var/passive_type = text2path(passive_text)
			if(passive_type && ispath(passive_type, passive_base_type))
				matching_passives |= passive_type // Use |= to avoid duplicates

	return matching_passives

/datum/profession_manager/proc/get_unlocked_abilities_of_type(ability_base_type, profession_name = null)
	var/list/professions_to_check = list()

	if(profession_name)
		professions_to_check += profession_name
	else
		// Check all active professions
		for(var/prof in active_professions)
			if(prof)
				professions_to_check += prof

	if(!length(professions_to_check))
		return list()

	var/list/matching_abilities = list()
	for(var/prof in professions_to_check)
		var/list/prof_data = get_profession_info(prof)
		for(var/ability_text in prof_data["unlocked_abilities"])
			var/ability_type = text2path(ability_text)
			if(ability_type && ispath(ability_type, ability_base_type))
				matching_abilities |= ability_type // Use |= to avoid duplicates

	return matching_abilities

/datum/profession_manager/proc/get_all_unlocked_passive_types(profession_name = null)
	var/list/professions_to_check = list()

	if(profession_name)
		professions_to_check += profession_name
	else
		// Check all active professions
		for(var/prof in active_professions)
			if(prof)
				professions_to_check += prof

	if(!length(professions_to_check))
		return list()

	var/list/passive_types = list()
	for(var/prof in professions_to_check)
		var/list/prof_data = get_profession_info(prof)
		for(var/passive_text in prof_data["unlocked_passives"])
			var/passive_type = text2path(passive_text)
			if(passive_type)
				passive_types |= passive_type // Use |= to avoid duplicates

	return passive_types

/datum/profession_manager/proc/get_all_unlocked_ability_types(profession_name = null)
	var/list/professions_to_check = list()

	if(profession_name)
		professions_to_check += profession_name
	else
		// Check all active professions
		for(var/prof in active_professions)
			if(prof)
				professions_to_check += prof

	if(!length(professions_to_check))
		return list()

	var/list/ability_types = list()
	for(var/prof in professions_to_check)
		var/list/prof_data = get_profession_info(prof)
		for(var/ability_text in prof_data["unlocked_abilities"])
			var/ability_type = text2path(ability_text)
			if(ability_type)
				ability_types |= ability_type // Use |= to avoid duplicates

	return ability_types

// Helper procs for level freezing
/datum/profession_manager/proc/freeze_profession_level(profession_name)
	if(!profession_name || !(profession_name in profession_data))
		return

	var/list/prof_data = profession_data[profession_name]
	if(!("frozen" in prof_data))
		prof_data["frozen"] = TRUE

/datum/profession_manager/proc/unfreeze_profession_level(profession_name)
	if(!profession_name || !(profession_name in profession_data))
		return

	var/list/prof_data = profession_data[profession_name]
	if("frozen" in prof_data)
		prof_data["frozen"] = FALSE

	// When unfreezing, check if the profession should level up based on current XP
	check_profession_level_up(profession_name)

/datum/profession_manager/proc/is_profession_frozen(profession_name)
	if(!profession_name || !(profession_name in profession_data))
		return TRUE // Treat non-existent professions as frozen

	var/list/prof_data = profession_data[profession_name]
	return prof_data["frozen"]

/datum/profession_manager/proc/check_profession_level_up(profession_name)
	if(!profession_name || !(profession_name in profession_data))
		return

	var/datum/profession/prof = get_profession_datum(profession_name)
	if(!prof)
		return

	var/list/prof_data = profession_data[profession_name]  // Use direct access for internal operations
	var/current_level = prof_data["level"]
	var/current_xp = prof_data["xp"]
	var/calculated_level = prof.get_level_from_xp(current_xp)

	if(calculated_level > current_level)
		handle_level_ups(profession_name, current_level, calculated_level, prof)
		prof_data["level"] = calculated_level
		save_profession_data()

// Passive management procs
/datum/profession_manager/proc/apply_all_passives()
	if(!attached_mob || !length(active_professions))
		return

	// Get all passive types from all active professions
	var/list/all_passive_types = list()
	for(var/prof in active_professions)
		if(prof)
			var/list/passive_types = get_all_unlocked_passive_types(prof)
			all_passive_types |= passive_types // Use |= to avoid duplicates

	for(var/passive_type in all_passive_types)
		apply_passive(passive_type)

/datum/profession_manager/proc/remove_all_passives()
	for(var/datum/passive/passive in applied_passives)
		passive.unapply(attached_mob)
		qdel(passive)
	applied_passives.Cut()

/datum/profession_manager/proc/refresh_passives()
	remove_all_passives()
	apply_all_passives()

/datum/profession_manager/proc/apply_passive(passive_type)
	if(!attached_mob || !passive_type)
		return FALSE

	// Check if we already have this passive applied
	for(var/datum/passive/existing in applied_passives)
		if(existing.type == passive_type)
			return FALSE

	// Create and apply new passive
	var/datum/passive/new_passive = new passive_type()
	if(new_passive.apply(attached_mob))
		applied_passives += new_passive
		return TRUE
	else
		qdel(new_passive)
		return FALSE

/datum/profession_manager/proc/remove_passive(passive_type)
	if(!attached_mob || !passive_type)
		return FALSE

	for(var/datum/passive/existing in applied_passives)
		if(existing.type == passive_type)
			existing.unapply(attached_mob)
			applied_passives -= existing
			qdel(existing)
			return TRUE

	return FALSE

/datum/profession_manager/proc/has_passive_applied(passive_type)
	for(var/datum/passive/existing in applied_passives)
		if(existing.type == passive_type)
			return TRUE
	return FALSE

/datum/profession_manager/proc/get_all_unlocked_content(profession_name = null)
	var/list/professions_to_check = list()

	if(profession_name)
		professions_to_check += profession_name
	else
		// Check all active professions
		for(var/prof in active_professions)
			if(prof)
				professions_to_check += prof

	if(!length(professions_to_check))
		return list(RECIPE_KEY = list(), PASSIVE_KEY = list(), ABILITY_KEY = list())

	var/list/recipe_types = list()
	var/list/passive_types = list()
	var/list/ability_types = list()

	for(var/prof in professions_to_check)
		var/list/prof_data = get_profession_info(prof)

		// Convert recipe text back to types
		for(var/recipe_text in prof_data["unlocked_recipes"])
			var/recipe_type = text2path(recipe_text)
			if(recipe_type)
				recipe_types |= recipe_type

		// Convert passive text back to types
		for(var/passive_text in prof_data["unlocked_passives"])
			var/passive_type = text2path(passive_text)
			if(passive_type)
				passive_types |= passive_type

		// Convert ability text back to types
		for(var/ability_text in prof_data["unlocked_abilities"])
			var/ability_type = text2path(ability_text)
			if(ability_type)
				ability_types |= ability_type

	return list(
		RECIPE_KEY = recipe_types,
		PASSIVE_KEY = passive_types,
		ABILITY_KEY = ability_types
	)

/proc/attach_profession_manager_to_mob(mob/target_mob)
	if(!target_mob || !target_mob.ckey)
		return null

	return get_profession_manager(target_mob.ckey, target_mob)

/proc/detach_profession_manager_from_mob(mob/target_mob)
	if(!target_mob || !target_mob.ckey)
		return

	var/datum/profession_manager/PM = get_profession_manager(target_mob.ckey)
	if(PM)
		PM.detach_from_mob()

/proc/add_profession_xp(ckey, profession_name, amount)
	var/datum/profession_manager/PM = get_profession_manager(ckey)
	if(PM)
		return PM.add_xp(profession_name, amount)
	return FALSE

/proc/get_profession_level(ckey, datum/profession/profession_type)
	var/datum/profession_manager/PM = get_profession_manager(ckey)
	if(PM)
		// Only return actual level if profession is active
		if(!(initial(profession_type.name) in PM.active_professions))
			return 1  // Inactive professions appear as level 1
		var/list/info = PM.get_profession_info(initial(profession_type.name))
		return info["level"]
	return 1

/proc/has_recipe_unlocked(ckey, recipe_type, datum/profession/profession_type)
	var/datum/profession_manager/PM = get_profession_manager(ckey)
	if(PM)
		return PM.has_recipe_unlocked(recipe_type, initial(profession_type.name))
	return FALSE

/proc/has_passive_unlocked(ckey, passive_type, profession_name = null)
	var/datum/profession_manager/PM = get_profession_manager(ckey)
	if(PM)
		return PM.has_passive_unlocked(passive_type, profession_name)
	return FALSE

/proc/has_ability_unlocked(ckey, ability_type, profession_name = null)
	var/datum/profession_manager/PM = get_profession_manager(ckey)
	if(PM)
		return PM.has_ability_unlocked(ability_type, profession_name)
	return FALSE

/proc/get_unlocked_recipes_of_type(ckey, recipe_base_type, profession_name = null)
	var/datum/profession_manager/PM = get_profession_manager(ckey)
	if(PM)
		return PM.get_unlocked_recipes_of_type(recipe_base_type, profession_name)
	return list()

/proc/get_unlocked_passives_of_type(ckey, passive_base_type, datum/profession/profession_type)
	var/datum/profession_manager/PM = get_profession_manager(ckey)
	if(PM)
		return PM.get_unlocked_passives_of_type(passive_base_type, initial(profession_type.name))
	return list()

/proc/get_unlocked_abilities_of_type(ckey, ability_base_type, profession_name = null)
	var/datum/profession_manager/PM = get_profession_manager(ckey)
	if(PM)
		return PM.get_unlocked_abilities_of_type(ability_base_type, profession_name)
	return list()

/proc/learn_recipe(ckey, recipe_type, datum/profession/profession_type)
	var/datum/profession_manager/PM = get_profession_manager(ckey)
	if(PM)
		return PM.learn_recipe(recipe_type, initial(profession_type.name))
	return FALSE

/proc/get_profession_manager(ckey, mob/target_mob = null)
	if(!ckey)
		return null

	ckey = ckey(ckey)

	if(ckey in GLOB.player_profession_managers)
		var/datum/profession_manager/existing = GLOB.player_profession_managers[ckey]
		if(target_mob)
			existing.attach_to_mob(target_mob)
		return existing

	var/datum/profession_manager/PM = new /datum/profession_manager(ckey, target_mob)
	if(PM)
		GLOB.player_profession_managers[ckey] = PM
		return PM

	return null

/proc/get_mob_highest_passive_level(mob/target_mob, passive_base_type, profession_name = null)
	if(!target_mob || !target_mob.ckey || !passive_base_type)
		return 0

	var/datum/profession_manager/PM = get_profession_manager(target_mob.ckey)
	if(!PM)
		return 0

	return PM.get_highest_passive_level_of_type(passive_base_type, profession_name)

/proc/add_active_profession(ckey, datum/profession/profession_type)
	var/datum/profession_manager/PM = get_profession_manager(ckey)
	if(PM)
		return PM.add_active_profession(initial(profession_type.name))
	return FALSE
