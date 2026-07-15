/datum/fatigue_modifier
	/// Text to show to the player on examining fatigue button
	var/desc = span_danger("Something is fucked.")

	/// Whether or not this is a variable modifier. Variable modifiers can NOT be ever auto-cached. ONLY CHECKED VIA INITIAL(), EFFECTIVELY READ ONLY (and for very good reason)
	var/variable = FALSE

	/// Unique ID. You can never have different modifications with the same ID. By default, this SHOULD NOT be set. Only set it for cases where you're dynamically making modifiers/need to have two types overwrite each other. If unset, uses path (converted to text) as ID.
	var/id

	/// Higher ones override lower priorities. This is NOT used for ID, ID must be unique, if it isn't unique the newer one overwrites automatically if overriding.
	var/priority = 0
	var/flags = NONE

	/// How much we add/remove from max_energy
	var/fatigue_add = 0

	/// Other modification datums this conflicts with.
	var/conflicts_with

/datum/fatigue_modifier/New()
	. = ..()
	if(!id)
		id = "[type]" //We turn the path into a string.

/// Grabs a STATIC MODIFIER datum from cache. YOU MUST NEVER EDIT THESE DATUMS, OR IT WILL AFFECT ANYTHING ELSE USING IT TOO!
/proc/get_cached_fatigue_modifier(modtype)
	if(!ispath(modtype, /datum/fatigue_modifier))
		CRASH("[modtype] is not a movespeed modification typepath.")
	var/datum/fatigue_modifier/M = modtype
	if(initial(M.variable))
		CRASH("[modtype] is a variable modifier, and can never be cached.")
	M = GLOB.fatigue_modification_cache[modtype]
	if(!M)
		M = GLOB.fatigue_modification_cache[modtype] = new modtype
	return M

///Add a fatigue modifier to a mob. If a variable subtype is passed in as the first argument, it will make a new datum. If ID conflicts, it will overwrite the old ID.
/mob/living/proc/add_fatigue_modifier(datum/fatigue_modifier/type_or_datum, update = TRUE)
	if(ispath(type_or_datum))
		if(!initial(type_or_datum.variable))
			type_or_datum = get_cached_fatigue_modifier(type_or_datum)
		else
			type_or_datum = new type_or_datum
	var/datum/fatigue_modifier/existing = LAZYACCESS(fatigue_modification, type_or_datum.id)
	if(existing)
		if(existing == type_or_datum) //same thing don't need to touch
			return TRUE
		remove_fatigue_modifier(existing, FALSE)
	if(length(fatigue_modification))
		BINARY_INSERT(type_or_datum.id, fatigue_modification, /datum/fatigue_modifier, type_or_datum, priority, COMPARE_VALUE)
	LAZYSET(fatigue_modification, type_or_datum.id, type_or_datum)
	if(update)
		update_energy_modifiers()
	return TRUE

/// Remove a move speed modifier from a mob, whether static or variable.
/mob/living/proc/remove_fatigue_modifier(datum/fatigue_modifier/type_id_datum, update = TRUE)
	var/key
	if(ispath(type_id_datum))
		key = initial(type_id_datum.id) || "[type_id_datum]" //id if set, path set to string if not.
	else if(!istext(type_id_datum)) //if it isn't text it has to be a datum, as it isn't a type.
		key = type_id_datum.id
	else //assume it's an id
		key = type_id_datum
	if(!LAZYACCESS(fatigue_modification, key))
		return FALSE
	LAZYREMOVE(fatigue_modification, key)
	if(update)
		update_energy_modifiers()
	return TRUE

/*! Used for variable slowdowns like hunger/health loss/etc, works somewhat like the old list-based modification adds. Returns the modifier datum if successful
	How this SHOULD work is:
	1. Ensures type_id_datum one way or another refers to a /variable datum. This makes sure it can't be cached. This includes if it's already in the modification list.
	2. Instantiate a new datum if type_id_datum isn't already instantiated + in the list, using the type. Obviously, wouldn't work for ID only.
	3. Add the datum if necessary using the regular add proc
	4. If any of the rest of the args are not null (see: multiplicative slowdown), modify the datum
	5. Update if necessary
*/
/mob/living/proc/add_or_update_variable_fatigue_modifier(datum/fatigue_modifier/type_id_datum, update = TRUE, fatigue_add, desc)
	var/modified = FALSE
	var/inject = FALSE
	var/datum/fatigue_modifier/final
	if(istext(type_id_datum))
		final = LAZYACCESS(fatigue_modification, type_id_datum)
		if(!final)
			CRASH("Couldn't find existing modification when provided a text ID.")
	else if(ispath(type_id_datum))
		if(!initial(type_id_datum.variable))
			CRASH("Not a variable modifier")
		final = LAZYACCESS(fatigue_modification, initial(type_id_datum.id) || "[type_id_datum]")
		if(!final)
			final = new type_id_datum()
			inject = TRUE
			modified = TRUE
	else
		if(!initial(type_id_datum.variable))
			CRASH("Not a variable modifier")
		final = type_id_datum
		if(!LAZYACCESS(fatigue_modification, final.id))
			inject = TRUE
			modified = TRUE
	if(!isnull(fatigue_add))
		final.fatigue_add = fatigue_add
		modified = TRUE
	if(!isnull(desc))
		final.desc = desc
		modified = TRUE
	if(inject)
		add_fatigue_modifier(final, FALSE)
	if(update && modified)
		update_energy_modifiers()
	return final

///Is there a movespeed modifier for this mob
/mob/living/proc/has_fatigue_modifier(datum/fatigue_modifier/datum_type_id)
	var/key
	if(ispath(datum_type_id))
		key = initial(datum_type_id.id) || "[datum_type_id]"
	else if(istext(datum_type_id))
		key = datum_type_id
	else
		key = datum_type_id.id
	return LAZYACCESS(fatigue_modification, key)

/// Get the fatigue modifiers list of the mob
/mob/living/proc/get_fatigue_modifiers()
	. = LAZYCOPY(fatigue_modification)
	for(var/id in fatigue_mod_immunities)
		. -= id

/// Calculate the total max_energy reduction of all fatigue modifiers
/mob/living/proc/total_fatigue_reduction()
	. = 0
	for(var/id in get_fatigue_modifiers())
		var/datum/fatigue_modifier/M = fatigue_modification[id]
		. += M.fatigue_add

/// Checks if a move speed modifier is valid and not missing any data
/proc/fatigue_data_null_check(datum/fatigue_modifier/M) //Determines if a data list is not meaningful and should be discarded.
	. = TRUE
	if(M.fatigue_add)
		. = FALSE
