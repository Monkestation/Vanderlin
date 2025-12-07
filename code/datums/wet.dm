/datum/wet
	var/atom/parent
	var/water_stacks = 0 // 0 = dry
	var/max_water_stacks = -20 // fully wet
	var/dirty_water = FALSE
	var/washed = FALSE

/datum/wet/New(atom/P)
	. = ..()
	parent = P

/datum/wet/Destroy()
	parent = null
	return ..()

/datum/wet/proc/get_examine_text()
	if(water_stacks < 0)
		var/list/msg = list()
		msg += span_warning("It's wet.")
		if(dirty_water)
			msg += span_warning("\n And smells very bad...")
		return msg

/// Using water (drying)
/datum/wet/proc/use_water(amount = 1)
	if(water_stacks == 0)
		if(washed)
			washed = FALSE
		return FALSE // Already fully dry

	// Stacks is how much water to remove (positive)
	water_stacks = min(0, water_stacks + amount)
	return TRUE

/// Adding water (getting wetter)
/datum/wet/proc/add_water(amount = 1, dirty = FALSE, washed_properly = FALSE)
	// If it is dirty, this can only be removed by drying properly on the structure.
	if(dirty)
		dirty_water = TRUE
	// If it it washed in a water/bin.
	if(washed_properly)
		washed = TRUE

	if(water_stacks <= max_water_stacks)
		return FALSE // Already fully soaked

	// Stacks is how much wetness to add (positive)
	water_stacks = max(max_water_stacks, water_stacks - amount)
	return TRUE
