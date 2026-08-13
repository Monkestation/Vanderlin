
/*
	Stores several modifiers in a way that isn't cleared by changing species.
	Final stat values are computed by stacking every active /datum/physiology_modifier on
	physiology_modification: multiplicative stats multiply together, additive stats (see
	ADDITIVE_PHYSIOLOGY_STATS) sum together. Species defaults get written into {/datum/physiology_modifier/species},
	not baked directly into base_modifier, so re-applying/removing a species is non-destructive
	to anything else that's modifying you (chems, traumas, admin edits, etc).
*/
/datum/physiology
	/// Assoc list of id -> /datum/physiology_modifier, sorted by priority (highest first)
	var/list/physiology_modification
	/// Assoc list of id -> list of sources ignoring that modifier id
	var/list/physiology_mod_immunities

	/// The always-present variable modifier holding defaullts and direct edits
	var/datum/physiology_modifier/base/base_modifier

	/// Internal armor datum
	var/datum/armor/armor

/datum/physiology/New()
	. = ..()
	armor = new
	base_modifier = new
	add_physiology_modifier(base_modifier)

/// Add a physiology modifier to this holder. If a variable subtype is passed in as the first argument, it will make a new datum. If ID conflicts, it will overwrite the old ID.
/datum/physiology/proc/add_physiology_modifier(datum/physiology_modifier/type_or_datum)
	if(ispath(type_or_datum))
		if(!initial(type_or_datum.variable))
			type_or_datum = get_cached_physiology_modifier(type_or_datum)
		else
			type_or_datum = new type_or_datum
	var/datum/physiology_modifier/existing = LAZYACCESS(physiology_modification, type_or_datum.id)
	if(existing)
		if(existing == type_or_datum) //same thing don't need to touch
			return TRUE
		remove_physiology_modifier(existing)
	if(length(physiology_modification))
		BINARY_INSERT(type_or_datum.id, physiology_modification, /datum/physiology_modifier, type_or_datum, priority, COMPARE_VALUE)
	LAZYSET(physiology_modification, type_or_datum.id, type_or_datum)
	return TRUE

/// Remove a physiology modifier from a holder, whether static or variable.
/datum/physiology/proc/remove_physiology_modifier(datum/physiology_modifier/type_id_datum)
	var/key
	if(ispath(type_id_datum))
		key = initial(type_id_datum.id) || "[type_id_datum]"
	else if(!istext(type_id_datum))
		key = type_id_datum.id
	else
		key = type_id_datum
	if(!LAZYACCESS(physiology_modification, key))
		return FALSE
	LAZYREMOVE(physiology_modification, key)
	return TRUE

/// Used for variable modification like chems/traumas. Returns the modifier datum if successful.
/datum/physiology/proc/add_or_update_variable_physiology_modifier(datum/physiology_modifier/type_id_datum, list/new_values)
	var/inject = FALSE
	var/datum/physiology_modifier/final
	if(istext(type_id_datum))
		final = LAZYACCESS(physiology_modification, type_id_datum)
		if(!final)
			CRASH("Couldn't find existing modification when provided a text ID.")
	else if(ispath(type_id_datum))
		if(!initial(type_id_datum.variable))
			CRASH("Not a variable modifier")
		final = LAZYACCESS(physiology_modification, initial(type_id_datum.id) || "[type_id_datum]")
		if(!final)
			final = new type_id_datum
			inject = TRUE
	else
		if(!initial(type_id_datum.variable))
			CRASH("Not a variable modifier")
		final = type_id_datum
		if(!LAZYACCESS(physiology_modification, final.id))
			inject = TRUE
	if(islist(new_values))
		for(var/stat in new_values)
			final.vars[stat] = new_values[stat]
	if(inject)
		add_physiology_modifier(final)
	return final

/// Is there a physiology modifier with this id/type on this holder
/datum/physiology/proc/has_physiology_modifier(datum/physiology_modifier/datum_type_id)
	var/key
	if(ispath(datum_type_id))
		key = initial(datum_type_id.id) || "[datum_type_id]"
	else if(istext(datum_type_id))
		key = datum_type_id
	else
		key = datum_type_id.id
	return LAZYACCESS(physiology_modification, key)

/// Get the physiology modifiers list, minus anything we're immune to
/datum/physiology/proc/get_physiology_modification()
	. = LAZYCOPY(physiology_modification)
	for(var/id in physiology_mod_immunities)
		. -= id

/// Ignore specific physiology mods - accepts a single id/type or a list of them
/datum/physiology/proc/add_physiology_mod_immunities(source, mod_type)
	if(islist(mod_type))
		for(var/listed_type in mod_type)
			if(ispath(listed_type))
				listed_type = "[listed_type]"
			LAZYADDASSOCLIST(physiology_mod_immunities, listed_type, source)
	else
		if(ispath(mod_type))
			mod_type = "[mod_type]"
		LAZYADDASSOCLIST(physiology_mod_immunities, mod_type, source)

/// Unignore specific physiology mods - accepts a single id/type or a list of them
/datum/physiology/proc/remove_physiology_mod_immunities(source, mod_type)
	if(islist(mod_type))
		for(var/listed_type in mod_type)
			if(ispath(listed_type))
				listed_type = "[listed_type]"
			LAZYREMOVEASSOC(physiology_mod_immunities, listed_type, source)
	else
		if(ispath(mod_type))
			mod_type = "[mod_type]"
		LAZYREMOVEASSOC(physiology_mod_immunities, mod_type, source)

/// Stats that stack additively (baseline 0) instead of multiplicatively (baseline 1)
#define ADDITIVE_PHYSIOLOGY_STATS list("damage_resistance")

/// Combines every active modifier's value for one stat into a final number
/datum/physiology/proc/get_stat_modifier(stat)
	var/static/list/additive_stats = ADDITIVE_PHYSIOLOGY_STATS
	. = (stat in additive_stats) ? 0 : 1
	for(var/key in get_physiology_modification())
		var/datum/physiology_modifier/modifier = physiology_modification[key]
		if(!modifier.applies_to(src))
			continue
		var/mod_value = modifier.vars[stat] //this is really wonky but far far better then the alternative
		if(isnull(mod_value))
			continue
		if(stat in additive_stats)
			. += mod_value
		else
			. *= mod_value

/// Actual hell but like idk man
/datum/physiology/proc/get_brute_mod()
	return get_stat_modifier("brute_mod")
	
/datum/physiology/proc/get_burn_mod()
	return get_stat_modifier("burn_mod")
	
/datum/physiology/proc/get_tox_mod()
	return get_stat_modifier("tox_mod")
	
/datum/physiology/proc/get_oxy_mod()
	return get_stat_modifier("oxy_mod")
	
/datum/physiology/proc/get_clone_mod()
	return get_stat_modifier("clone_mod")
	
/datum/physiology/proc/get_stamina_mod()
	return get_stat_modifier("stamina_mod")
	
/datum/physiology/proc/get_brain_mod()
	return get_stat_modifier("brain_mod")
	
/datum/physiology/proc/get_heat_mod()
	return get_stat_modifier("heat_mod")
	
/datum/physiology/proc/get_cold_mod()
	return get_stat_modifier("cold_mod")
	
/datum/physiology/proc/get_damage_resistance()
	return get_stat_modifier("damage_resistance")
	
/datum/physiology/proc/get_siemens_coeff()
	return get_stat_modifier("siemens_coeff")
	
/datum/physiology/proc/get_stun_mod()
	return get_stat_modifier("stun_mod")
	
/datum/physiology/proc/get_bleed_mod()
	return get_stat_modifier("bleed_mod")
	
/datum/physiology/proc/get_pain_mod()
	return get_stat_modifier("pain_mod")
	
/datum/physiology/proc/get_hygiene_mod()
	return get_stat_modifier("hygiene_mod")
	
/datum/physiology/proc/get_hunger_mod()
	return get_stat_modifier("hunger_mod")
	
/datum/physiology/proc/get_do_after_speed()
	return get_stat_modifier("do_after_speed")
	
/datum/physiology/proc/get_mana_regen_mod()
	return get_stat_modifier("mana_regen_mod")

#undef ADDITIVE_PHYSIOLOGY_STATS
