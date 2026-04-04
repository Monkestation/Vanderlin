/datum/diceroll_modifier
	/// Whether or not this is a variable modifier. Variable modifiers can NOT be ever auto-cached. ONLY CHECKED VIA INITIAL(), EFFECTIVELY READ ONLY (and for very good reason)
	var/variable = FALSE

	/// Unique ID. You can never have different modifications with the same ID. By default, this SHOULD NOT be set. Only set it for cases where you're dynamically making modifiers/need to have two types overwrite each other. If unset, uses path (converted to text) as ID.
	var/id

	/// Higher ones override lower priorities. This is NOT used for ID, ID must be unique, if it isn't unique the newer one overwrites automatically if overriding.
	var/priority = 0
	var/flags = NONE

	/// How much we add to the REQUIREMENT of dicerolls, not the dice
	var/modification

	/// Diceroll contexts we should apply to
	var/list/applicable_contexts = list(
		DICE_CONTEXT_DEFAULT = TRUE,
	)

/datum/diceroll_modifier/New()
	. = ..()
	if(!id)
		id = "[type]" //We turn the path into a string.

/// Checks if we should actually apply our modification at this moment
/datum/diceroll_modifier/proc/applies_to(datum/attribute_holder/holder, context)
	return applicable_contexts[context]

/// Grabs a STATIC MODIFIER datum from cache. YOU MUST NEVER EDIT THESE DATUMS, OR IT WILL AFFECT ANYTHING ELSE USING IT TOO!
/proc/get_cached_diceroll_modifier(modtype)
	if(!ispath(modtype, /datum/diceroll_modifier))
		CRASH("[modtype] is not a attribute modification typepath.")
	var/datum/diceroll_modifier/diceroll_mod = modtype
	if(initial(diceroll_mod.variable))
		CRASH("[modtype] is a variable modifier, and can never be cached.")
	diceroll_mod = GLOB.diceroll_modification_cache[modtype]
	if(!diceroll_mod)
		diceroll_mod = GLOB.diceroll_modification_cache[modtype] = new modtype
	return diceroll_mod

///Add a action speed modifier to a holder. If a variable subtype is passed in as the first argument, it will make a new datum. If ID conflicts, it will overwrite the old ID.
/datum/attribute_holder/proc/add_diceroll_modifier(datum/diceroll_modifier/type_or_datum)
	if(ispath(type_or_datum))
		if(!initial(type_or_datum.variable))
			type_or_datum = get_cached_diceroll_modifier(type_or_datum)
		else
			type_or_datum = new type_or_datum
	var/datum/diceroll_modifier/existing = LAZYACCESS(diceroll_modification, type_or_datum.id)
	if(existing)
		if(existing == type_or_datum) //same thing don't need to touch
			return TRUE
		remove_diceroll_modifier(existing, FALSE)
	if(length(diceroll_modification))
		BINARY_INSERT(type_or_datum.id, diceroll_modification, /datum/diceroll_modifier, type_or_datum, priority, COMPARE_VALUE)
	LAZYSET(diceroll_modification, type_or_datum.id, type_or_datum)
	return TRUE

/// Remove an attribute modifier from a holder, whether static or variable.
/datum/attribute_holder/proc/remove_diceroll_modifier(datum/diceroll_modifier/type_id_datum)
	var/key
	if(ispath(type_id_datum))
		key = initial(type_id_datum.id) || "[type_id_datum]" //id if set, path set to string if not.
	else if(!istext(type_id_datum)) //if it isn't text it has to be a datum, as it isn't a type.
		key = type_id_datum.id
	else //assume it's an id
		key = type_id_datum
	if(!LAZYACCESS(diceroll_modification, key))
		return FALSE
	LAZYREMOVE(diceroll_modification, key)
	return TRUE

/*! Used for variable modification like hunger/health loss/etc, works somewhat like the old list-based modification adds. Returns the modifier datum if successful
	How this SHOULD work is:
	1. Ensures type_id_datum one way or another refers to a /variable datum. This makes sure it can't be cached. This includes if it's already in the modification list.
	2. Instantiate a new datum if type_id_datum isn't already instantiated + in the list, using the type. Obviously, wouldn't work for ID only.
	3. Add the datum if necessary using the regular add proc
	4. If any of the rest of the args are not null (see: multiplicative slowdown), modify the datum
	5. Update if necessary
*/
/datum/attribute_holder/proc/add_or_update_variable_diceroll_modifier(datum/diceroll_modifier/type_id_datum, new_modification)
	var/inject = FALSE
	var/datum/diceroll_modifier/final
	if(istext(type_id_datum))
		final = LAZYACCESS(diceroll_modification, type_id_datum)
		if(!final)
			CRASH("Couldn't find existing modification when provided a text ID.")
	else if(ispath(type_id_datum))
		if(!initial(type_id_datum.variable))
			CRASH("Not a variable modifier")
		final = LAZYACCESS(diceroll_modification, initial(type_id_datum.id) || "[type_id_datum]")
		if(!final)
			final = new type_id_datum
			inject = TRUE
	else
		if(!initial(type_id_datum.variable))
			CRASH("Not a variable modifier")
		final = type_id_datum
		if(!LAZYACCESS(diceroll_modification, final.id))
			inject = TRUE
	if(isnum(new_modification))
		final.modification = new_modification
	if(inject)
		add_diceroll_modifier(final, FALSE)
	return final

///Is there an attribute modifier for this holder
/datum/attribute_holder/proc/has_diceroll_modifier(datum/diceroll_modifier/datum_type_id)
	var/key
	if(ispath(datum_type_id))
		key = initial(datum_type_id.id) || "[datum_type_id]"
	else if(istext(datum_type_id))
		key = datum_type_id
	else
		key = datum_type_id.id
	return LAZYACCESS(diceroll_modification, key)

/// Go through the list of diceroll modifiers and calculate a final diceroll modifier.
/datum/attribute_holder/proc/get_diceroll_modifier(context)
	. = 0
	for(var/key in get_diceroll_modification())
		var/datum/diceroll_modifier/modifier = diceroll_modification[key]
		if(!modifier.applies_to(src, context))
			continue
		. += modifier.modification

/// Get the attribute modifiers list of the holder
/datum/attribute_holder/proc/get_diceroll_modification()
	. = LAZYCOPY(diceroll_modification)
	for(var/id in diceroll_mod_immunities)
		. -= id

/// Checks if an attribute modifier is valid and not missing any data
/proc/diceroll_mod_data_null_check(datum/diceroll_modifier/M) //Determines if a data list is not meaningful and should be discarded.
	. = TRUE
	if(M.modification)
		return FALSE

/// Ignores specific attribute mods - Accepts a list of attribute mods
/datum/attribute_holder/proc/add_diceroll_mod_immunities(source, mod_type)
	if(islist(mod_type))
		for(var/listed_type in mod_type)
			if(ispath(listed_type))
				listed_type = "[mod_type]" //Path2String
			LAZYADDASSOCLIST(diceroll_mod_immunities, listed_type, source)
	else
		if(ispath(mod_type))
			mod_type = "[mod_type]" //Path2String
		LAZYADDASSOCLIST(diceroll_mod_immunities, mod_type, source)

///Unignores specific attribute mods - Accepts a list of attribute mods
/datum/attribute_holder/proc/remove_diceroll_mod_immunities(source, mod_type)
	if(islist(mod_type))
		for(var/listed_type in mod_type)
			if(ispath(listed_type))
				listed_type = "[listed_type]" //Path2String
			LAZYREMOVEASSOC(diceroll_mod_immunities, listed_type, source)
	else
		if(ispath(mod_type))
			mod_type = "[mod_type]" //Path2String
		LAZYREMOVEASSOC(diceroll_mod_immunities, mod_type, source)

/datum/diceroll_modifier/attribute_editor
	modification = 0
	variable = TRUE

// this special snowflake ALWAYS applies, we care not for context
/datum/diceroll_modifier/attribute_editor/applies_to(datum/attribute_holder/holder, context)
	return TRUE
