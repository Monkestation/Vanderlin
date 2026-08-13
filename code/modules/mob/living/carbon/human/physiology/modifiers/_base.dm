GLOBAL_LIST_EMPTY(physiology_modification_cache)

/datum/physiology_modifier
	/// Whether or not this is a variable modifier. Variable modifiers can NOT be ever auto-cached. ONLY CHECKED VIA INITIAL(), EFFECTIVELY READ ONLY (and for very good reason)
	var/variable = FALSE

	/// Unique ID. You can never have different modifications with the same ID. By default, this SHOULD NOT be set. Only set it for cases where you're dynamically making modifiers/need to have two types overwrite each other. If unset, uses path (converted to text) as ID.
	var/id

	/// Higher ones override lower priorities. This is NOT used for ID, ID must be unique, if it isn't unique the newer one overwrites automatically if overriding.
	var/priority = 0
	var/flags = NONE

	/// % of brute damage taken from all sources
	var/brute_mod = 1
	/// % of burn damage taken from all sources
	var/burn_mod = 1
	/// % of toxin damage taken from all sources
	var/tox_mod = 1
	/// % of oxygen damage taken from all sources
	var/oxy_mod = 1
	/// % of clone damage taken from all sources
	var/clone_mod = 1
	/// % of stamina damage taken from all sources
	var/stamina_mod = 1
	/// % of brain damage taken from all sources
	var/brain_mod = 1
	/// multiplier applied to mana regen
	var/mana_regen_mod = 1

	/// % of burn damage taken from heat (stacks with burn_mod)
	var/heat_mod = 1
	/// % of burn damage taken from cold (stacks with burn_mod)
	var/cold_mod = 1

	/// % damage reduction from all sources. Additive, not multiplicative - see ADDITIVE_PHYSIOLOGY_STATS
	var/damage_resistance = 0

	/// Resistance to shocks
	var/siemens_coeff = 1

	/// % stun modifier
	var/stun_mod = 1
	/// % bleeding modifier
	var/bleed_mod = 1
	/// % pain modifier
	var/pain_mod = 1

	/// % of hygiene rate taken per tick
	var/hygiene_mod = 1
	/// % of hunger rate taken per tick
	var/hunger_mod = 1

	/// Speed mod for do_after. Lower is better. If temporarily adjusting, please only modify using *= and /=, so you don't interrupt other calculations.
	var/do_after_speed = 1

/datum/physiology_modifier/New()
	. = ..()
	if(!id)
		id = "[type]" //We turn the path into a string.

/// Checks if we should actually apply our modification at this moment
/datum/physiology_modifier/proc/applies_to(datum/physiology/holder)
	return TRUE

/// Grabs a STATIC MODIFIER datum from cache. YOU MUST NEVER EDIT THESE DATUMS, OR IT WILL AFFECT ANYTHING ELSE USING IT TOO!
/proc/get_cached_physiology_modifier(modtype)
	if(!ispath(modtype, /datum/physiology_modifier))
		CRASH("[modtype] is not a physiology modifier typepath.")
	var/datum/physiology_modifier/phys_mod = modtype
	if(initial(phys_mod.variable))
		CRASH("[modtype] is a variable modifier, and can never be cached.")
	phys_mod = GLOB.physiology_modification_cache[modtype]
	if(!phys_mod)
		phys_mod = GLOB.physiology_modification_cache[modtype] = new modtype
	return phys_mod

/// The "always on" variable modifier every physiology gets on creation. This is what direct/admin edits get written to.
/datum/physiology_modifier/base
	id = "base"
	variable = TRUE
	priority = 0

/datum/physiology_modifier/base/applies_to(datum/physiology/holder)
	return TRUE //this special snowflake ALWAYS applies
