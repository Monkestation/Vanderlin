/datum/carry_weight_modifier
	/// Text to show to the player on examining carry_weight button
	var/desc = span_danger("Something is fucked.")

	/// Whether or not this is a variable modifier. Variable modifiers can NOT be ever auto-cached. ONLY CHECKED VIA INITIAL(), EFFECTIVELY READ ONLY (and for very good reason)
	var/variable = FALSE

	/// Unique ID. You can never have different modifications with the same ID. By default, this SHOULD NOT be set. Only set it for cases where you're dynamically making modifiers/need to have two types overwrite each other. If unset, uses path (converted to text) as ID.
	var/id

	/// Higher ones override lower priorities. This is NOT used for ID, ID must be unique, if it isn't unique the newer one overwrites automatically if overriding.
	var/priority = 0
	var/flags = NONE

	/// How much we add/remove from maximum_carry_weight
	var/carry_weight_add = 0

	/// Other modification datums this conflicts with.
	var/conflicts_with

/datum/carry_weight_modifier/New()
	. = ..()
	if(!id)
		id = "[type]" //We turn the path into a string.

/// Grabs a STATIC MODIFIER datum from cache. YOU MUST NEVER EDIT THESE DATUMS, OR IT WILL AFFECT ANYTHING ELSE USING IT TOO!
/proc/get_cached_carry_weight_modifier(modtype)
	if(!ispath(modtype, /datum/carry_weight_modifier))
		CRASH("[modtype] is not a movespeed modification typepath.")
	var/datum/carry_weight_modifier/M = modtype
	if(initial(M.variable))
		CRASH("[modtype] is a variable modifier, and can never be cached.")
	M = GLOB.carry_weight_modification_cache[modtype]
	if(!M)
		M = GLOB.carry_weight_modification_cache[modtype] = new modtype
	return M

///Add a carry_weight modifier to a mob. If a variable subtype is passed in as the first argument, it will make a new datum. If ID conflicts, it will overwrite the old ID.
/mob/living/carbon/proc/add_carry_weight_modifier(datum/carry_weight_modifier/type_or_datum, update = TRUE)
	if(ispath(type_or_datum))
		if(!initial(type_or_datum.variable))
			type_or_datum = get_cached_carry_weight_modifier(type_or_datum)
		else
			type_or_datum = new type_or_datum
	var/datum/carry_weight_modifier/existing = LAZYACCESS(carry_weight_modification, type_or_datum.id)
	if(existing)
		if(existing == type_or_datum) //same thing don't need to touch
			return TRUE
		remove_carry_weight_modifier(existing, FALSE)
	if(length(carry_weight_modification))
		BINARY_INSERT(type_or_datum.id, carry_weight_modification, /datum/carry_weight_modifier, type_or_datum, priority, COMPARE_VALUE)
	LAZYSET(carry_weight_modification, type_or_datum.id, type_or_datum)
	if(update)
		update_maximum_carry_weight()
	return TRUE

/// Remove a move speed modifier from a mob, whether static or variable.
/mob/living/carbon/proc/remove_carry_weight_modifier(datum/carry_weight_modifier/type_id_datum, update = TRUE)
	var/key
	if(ispath(type_id_datum))
		key = initial(type_id_datum.id) || "[type_id_datum]" //id if set, path set to string if not.
	else if(!istext(type_id_datum)) //if it isn't text it has to be a datum, as it isn't a type.
		key = type_id_datum.id
	else //assume it's an id
		key = type_id_datum
	if(!LAZYACCESS(carry_weight_modification, key))
		return FALSE
	LAZYREMOVE(carry_weight_modification, key)
	if(update)
		update_maximum_carry_weight()
	return TRUE

/*! Used for variable slowdowns like hunger/health loss/etc, works somewhat like the old list-based modification adds. Returns the modifier datum if successful
	How this SHOULD work is:
	1. Ensures type_id_datum one way or another refers to a /variable datum. This makes sure it can't be cached. This includes if it's already in the modification list.
	2. Instantiate a new datum if type_id_datum isn't already instantiated + in the list, using the type. Obviously, wouldn't work for ID only.
	3. Add the datum if necessary using the regular add proc
	4. If any of the rest of the args are not null (see: multiplicative slowdown), modify the datum
	5. Update if necessary
*/
/mob/living/carbon/proc/add_or_update_variable_carry_weight_modifier(datum/carry_weight_modifier/type_id_datum, update = TRUE, carry_weight_add, desc)
	var/modified = FALSE
	var/inject = FALSE
	var/datum/carry_weight_modifier/final
	if(istext(type_id_datum))
		final = LAZYACCESS(carry_weight_modification, type_id_datum)
		if(!final)
			CRASH("Couldn't find existing modification when provided a text ID.")
	else if(ispath(type_id_datum))
		if(!initial(type_id_datum.variable))
			CRASH("Not a variable modifier")
		final = LAZYACCESS(carry_weight_modification, initial(type_id_datum.id) || "[type_id_datum]")
		if(!final)
			final = new type_id_datum()
			inject = TRUE
			modified = TRUE
	else
		if(!initial(type_id_datum.variable))
			CRASH("Not a variable modifier")
		final = type_id_datum
		if(!LAZYACCESS(carry_weight_modification, final.id))
			inject = TRUE
			modified = TRUE
	if(!isnull(carry_weight_add))
		final.carry_weight_add = carry_weight_add
		modified = TRUE
	if(!isnull(desc))
		final.desc = desc
		modified = TRUE
	if(inject)
		add_carry_weight_modifier(final, FALSE)
	if(update && modified)
		update_maximum_carry_weight()
	return final

///Is there a movespeed modifier for this mob
/mob/living/carbon/proc/has_carry_weight_modifier(datum/carry_weight_modifier/datum_type_id)
	var/key
	if(ispath(datum_type_id))
		key = initial(datum_type_id.id) || "[datum_type_id]"
	else if(istext(datum_type_id))
		key = datum_type_id
	else
		key = datum_type_id.id
	return LAZYACCESS(carry_weight_modification, key)

/// Get the carry_weight modifiers list of the mob
/mob/living/carbon/proc/get_carry_weight_modifiers()
	. = LAZYCOPY(carry_weight_modification)
	for(var/id in carry_weight_mod_immunities)
		. -= id

/// Calculate the total max_energy reduction of all carry_weight modifiers
/mob/living/carbon/proc/total_carry_weight_reduction()
	. = 0
	for(var/id in get_carry_weight_modifiers())
		var/datum/carry_weight_modifier/M = carry_weight_modification[id]
		. += M.carry_weight_add

/// Checks if a move speed modifier is valid and not missing any data
/proc/carry_weight_data_null_check(datum/carry_weight_modifier/M) //Determines if a data list is not meaningful and should be discarded.
	. = TRUE
	if(M.carry_weight_add)
		. = FALSE
