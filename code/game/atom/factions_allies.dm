
/atom/movable
	/// The list of factions this atom belongs to (used for cacheable faction strings - these tend to not change very often)
	VAR_PROTECTED/list/faction
	/// The list of allies this atom has (used for anything too dynamic for string_list() - typically mob refs, each mob starts with themselves as an ally)
	var/list/allies

/*
 * Compare two lists of factions, returning true if any match
 *
 * If exact match is passed through we only return true if both faction lists match equally
 */
/proc/faction_check(list/faction_A, list/faction_B, list/allies_A, list/allies_B, exact_match)
	if(!exact_match)
		return LAZYLEN(faction_A & faction_B) || LAZYLEN(allies_A & allies_B)
	else
		if(LAZYLEN(faction_A&faction_B) != LAZYLEN(faction_A))
			return FALSE //if they're not the same len(gth) or we don't have a len, then this isn't an exact match.
		return LAZYLEN(allies_A & allies_B)

/**
 * Check if the other atom/movable has any factions the same as us. Defined at the atom/movable level so it can be defined for just about anything.
 *
 * If exact match is set, then all our factions must match exactly
 */
/atom/movable/proc/faction_check_atom(atom/movable/target, exact_match)
	if(exact_match)
		var/list/allies_src = LAZYCOPY(allies)
		var/list/allies_target = LAZYCOPY(target.allies)
		if(!("[REF(src)]" in allies_target)) //if they don't have our ref faction, remove it from our factions list.
			allies_src -= "[REF(src)]" //if we don't do this, we'll never have an exact match.
		if(!("[REF(target)]" in allies_src))
			allies_target -= "[REF(target)]" //same thing here.
		return FAST_FACTION_CHECK(faction, target.faction, allies, target.allies, TRUE)
	else
		return FAST_FACTION_CHECK(faction, target.faction, allies, target.allies, FALSE)

/*
 * Sets atom's allies list to be the provided list of faction strings. Returns TRUE if successful.
 */
/atom/movable/proc/set_allies(ally_list)
	if (!islist(ally_list) && !isnull(ally_list))
		stack_trace("Tried to call set_allies on [src] with a non-list arg. Use add_ally([ally_list]) instead.")
		return FALSE

	if (!LAZYLEN(ally_list) && !isnull(ally_list)) // empty list, should just null it in that case
		LAZYNULL(allies)
		return TRUE

	allies = ally_list

	return TRUE

/*
 * Adds an ally or list of allies to the allies list. Automatically converts target to ref if it is an atom.
 * Returns TRUE if something was actually added, false otherwise
 */
/atom/movable/proc/add_ally(ally_or_allies)
	var/old_length = LAZYLEN(allies)
	if(!isatom(ally_or_allies))
		LAZYOR(allies, ally_or_allies)
	else
		LAZYOR(allies, "[REF(ally_or_allies)]")

	return LAZYLEN(allies) != old_length

/*
 * Removes an ally or list of allies from the allies list. Automatically converts target to ref if it is an atom.
 * Returns TRUE if something was actually added, false otherwise
 */
/atom/movable/proc/remove_ally(atom/target)
	var/old_length = LAZYLEN(allies)
	if (!old_length)
		return FALSE

	if(!isatom(target))
		LAZYREMOVE(allies, target)
	else
		LAZYREMOVE(allies, "[REF(target)]")

	return old_length != LAZYLEN(allies)

/*
 * Returns TRUE if the ally or allies in list are in our allies list
 * If match_all is set, we have to match everything in the provided list arg.
 */
/atom/movable/proc/has_ally(ally_or_allies, match_all)
	if (!LAZYLEN(allies))
		return FALSE

	if (islist(ally_or_allies))
		if(match_all)
			var/match_count = FAST_FACTION_CHECK(null, null, allies, ally_or_allies, TRUE)
			return (match_count == LAZYLEN(ally_or_allies))
		else
			return FAST_FACTION_CHECK(null, null, allies, ally_or_allies, FALSE)

	else if(isatom(ally_or_allies))
		return "[REF(ally_or_allies)]" in allies
	else
		return ally_or_allies in allies
/**
 * Returns the faction list of this atom/movable
 */
/atom/movable/proc/get_faction()
	return faction

/**
 * Sets atom's faction list to be the provided list of faction strings. Returns TRUE if successful.
 */
/atom/movable/proc/set_faction(factions)
	if (factions == faction) // Same list in memory - early return
		return TRUE
	if (!islist(factions) && !isnull(factions))
		stack_trace("Tried to call set_faction on [src] with a non-list arg. Use add_faction([factions]) instead.")
		return FALSE

	if (!LAZYLEN(factions)) // empty list, should just null it in that case
		LAZYNULL(faction)
		return TRUE

	faction = string_list(factions)
	return TRUE

/**
 * Adds a single faction string or list of faction strings to the atom's faction list. Returns TRUE if something was added.
 */
/atom/movable/proc/add_faction(faction_or_factions)
	var/list/faction_copy = LAZYLISTDUPLICATE(faction) // Copy so we are not mutating the cached list
	LAZYOR(faction_copy, faction_or_factions)

	// If OR didn't add anything, do nothing
	if (LAZYLEN(faction_copy) == LAZYLEN(faction))
		return FALSE

	faction = string_list(faction_copy)
	return TRUE

/**
 * Removes a single faction string or list of faction strings from the atom's faction list. Returns TRUE if something was removed.
 */
/atom/movable/proc/remove_faction(faction_or_factions)
	var/old_length = LAZYLEN(faction)
	if (!old_length)
		return FALSE

	var/list/faction_copy = LAZYLISTDUPLICATE(faction) // Copy so we are not mutating the cached list
	LAZYREMOVE(faction_copy, faction_or_factions)

	var/new_length = LAZYLEN(faction_copy)
	// If nothing remains in the copy, null the actual list too.
	if (!new_length)
		LAZYNULL(faction)
		return TRUE

	if (old_length == new_length) // Nothing was removed, do nothing
		return FALSE

	faction = string_list(faction_copy)

	return TRUE

/**
 * Returns TRUE if the faction or factions in list are in our faction list.
 * If match_all is set, we have to match everything in the provided list arg.
 */
/atom/movable/proc/has_faction(faction_or_factions, match_all)
	if (!LAZYLEN(faction))
		return FALSE

	if (islist(faction_or_factions))
		if(match_all)
			var/match_count = FAST_FACTION_CHECK(faction, faction_or_factions, null, null, TRUE)
			return (match_count == LAZYLEN(faction_or_factions))
		else
			return FAST_FACTION_CHECK(faction, faction_or_factions, null, null, FALSE)

	else
		return faction_or_factions in faction

/**
 * Returns TRUE if any of the factions or allies are in our faction list.
 * If match_all is set, we have to match everything in the provided list arg.
 */
/atom/movable/proc/has_faction_or_allies(faction_or_factions, allies_list, match_all)
	if (!LAZYLEN(faction_or_factions))
		return FALSE

	if (islist(faction_or_factions))
		if (match_all)
			var/match_count = FAST_FACTION_CHECK(faction, faction_or_factions, allies, allies_list, TRUE)
			return (match_count == LAZYLEN(faction_or_factions) + LAZYLEN(allies_list))
		else
			return FAST_FACTION_CHECK(faction, faction_or_factions, allies, allies_list, FALSE)

	else
		return (faction_or_factions in faction) && FAST_FACTION_CHECK(null, null, allies, allies_list, match_all)

/**
 * Opens the modify faction ui.
 */
/atom/movable/proc/edit_faction(mob/user)
	var/prompt = tgui_alert(usr, "Would you like to Add or Remove faction?", "Add/Remove?", list("Add", "Remove"))
	if (isnull(prompt))
		return FALSE

	if (prompt == "Add")
		var/faction_to_add = tgui_input_text(user, "Enter a faction name to add.", "Add Faction", max_length = MAX_NAME_LEN)
		if(isnull(faction_to_add))
			return FALSE

		return add_faction(faction_to_add)

	else if (prompt == "Remove")
		var/list/current_factions = LAZYLISTDUPLICATE(faction)
		if(!LAZYLEN(current_factions))
			to_chat(user, span_warning("[src] has no factions left to remove!"))
			return FALSE

		current_factions = sortList(current_factions, GLOBAL_PROC_REF(cmp_text_asc)) // sort alphabetically

		var/faction_to_remove = tgui_input_list(user, "Select a faction to remove.", "Remove faction", current_factions)
		if(isnull(faction_to_remove))
			return FALSE

		return remove_faction(faction_to_remove)

/**
 * Outputs the factions list as text
 */
/atom/movable/proc/faction_to_text()
	var/list/factions_printout = list()
	for(var/faction_string in get_faction())
		factions_printout += "\n[faction_string]"

	return jointext(factions_printout, "")
