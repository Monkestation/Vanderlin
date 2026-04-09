/datum/unit_test/container_craft_recipe_collisions
/datum/unit_test/container_craft_recipe_collisions/Run()
	var/list/recipes = list()
	for(var/datum/container_craft/craft as anything in subtypesof(/datum/container_craft))
		if(IS_ABSTRACT(craft))
			continue
		recipes += new craft

	for(var/i in 1 to (recipes.len-1))
		for(var/i2 in (i+1) to recipes.len)
			var/datum/container_craft/r1 = recipes[i]
			var/datum/container_craft/r2 = recipes[i2]
			if(container_craft_recipes_do_conflict(r1, r2))
				TEST_FAIL("Container craft recipe conflict between [r1.type] and [r2.type]")

/proc/container_craft_recipes_do_conflict(datum/container_craft/r1, datum/container_craft/r2)
	// Check if they require different containers - no conflict if so
	if(r1.required_container != r2.required_container)
		return FALSE

	// Check isolation craft requirements - if both are isolation crafts, they could conflict
	if(r1.isolation_craft != r2.isolation_craft)
		return FALSE

	if(r1.craft_priority != r2.craft_priority)
		return FALSE

	// Find the recipe with shorter and longer requirements lists
	var/datum/container_craft/long_req
	var/datum/container_craft/short_req
	var/long_total_reqs = (r1.requirements?.len || 0) + (r1.wildcard_requirements?.len || 0) + (r1.reagent_requirements?.len || 0)
	var/short_total_reqs = (r2.requirements?.len || 0) + (r2.wildcard_requirements?.len || 0) + (r2.reagent_requirements?.len || 0)

	if(long_total_reqs > short_total_reqs)
		long_req = r1
		short_req = r2
	else if(long_total_reqs < short_total_reqs)
		long_req = r2
		short_req = r1
	else
		// Same length, check optional requirements to break tie
		var/r1_optionals = (r1.optional_requirements?.len || 0) + (r1.optional_wildcard_requirements?.len || 0) + (r1.optional_reagent_requirements?.len || 0)
		var/r2_optionals = (r2.optional_requirements?.len || 0) + (r2.optional_wildcard_requirements?.len || 0) + (r2.optional_reagent_requirements?.len || 0)
		if(r1_optionals >= r2_optionals)
			long_req = r1
			short_req = r2
		else
			long_req = r2
			short_req = r1

	// Check if shorter recipe's requirements are a subset of the longer recipe's requirements

	// Check regular requirements
	if(short_req.requirements && long_req.requirements)
		for(var/req_type in short_req.requirements)
			if(!(req_type in long_req.requirements))
				return FALSE
			if(long_req.requirements[req_type] < short_req.requirements[req_type])
				return FALSE
	else if(short_req.requirements?.len && !long_req.requirements?.len)
		return FALSE

	// Check reagent requirements
	if(short_req.reagent_requirements && long_req.reagent_requirements)
		for(var/reagent_type in short_req.reagent_requirements)
			var/found_reagent = FALSE
			for(var/long_reagent_type in long_req.reagent_requirements)
				if(reagent_type == long_reagent_type || (short_req.subtype_reagents_allowed && long_req.subtype_reagents_allowed && ispath(reagent_type, long_reagent_type)))
					if(long_req.reagent_requirements[long_reagent_type] >= short_req.reagent_requirements[reagent_type])
						found_reagent = TRUE
						break
			if(!found_reagent)
				return FALSE
	else if(short_req.reagent_requirements?.len && !long_req.reagent_requirements?.len)
		return FALSE

	// Check wildcard requirements - this needs to properly handle the wildcard matching
	if(short_req.wildcard_requirements)
		for(var/short_wildcard in short_req.wildcard_requirements)
			var/short_amount = short_req.wildcard_requirements[short_wildcard]
			var/satisfied_amount = 0

			// Check if long_req has exact requirements that could satisfy this wildcard
			if(long_req.requirements)
				for(var/long_req_type in long_req.requirements)
					if(ispath(long_req_type, short_wildcard))
						satisfied_amount += long_req.requirements[long_req_type]

			// Check if long_req has wildcards that could compete with this wildcard
			if(long_req.wildcard_requirements)
				for(var/long_wildcard in long_req.wildcard_requirements)
					if(wildcards_could_compete(short_wildcard, long_wildcard))
						satisfied_amount += long_req.wildcard_requirements[long_wildcard]

			if(satisfied_amount < short_amount)
				return FALSE
	else if(short_req.wildcard_requirements?.len && !long_req.wildcard_requirements?.len && !long_req.requirements?.len)
		return FALSE

	// Check if both are isolation crafts with identical requirements - this would be a definite conflict
	if(short_req.isolation_craft && long_req.isolation_craft)
		// If we got this far, the shorter recipe's requirements are a subset of the longer one's
		// For isolation crafts, this means they would conflict
		return TRUE

	// If we got this far, the shorter recipe's requirements are a subset of the longer recipe's requirements
	// This means the shorter recipe could trigger when trying to make the longer recipe
	return TRUE

// Helper proc to determine if two wildcard paths could compete for the same items
/proc/wildcards_could_compete(wildcard1, wildcard2)
	// If they're identical, they definitely compete
	if(wildcard1 == wildcard2)
		return TRUE

	// If one is a subtype of the other, they could compete
	if(ispath(wildcard1, wildcard2) || ispath(wildcard2, wildcard1))
		return TRUE

	// Check if they have any common subtypes by examining the type hierarchy
	// This is a simplified check - in practice, you might need more sophisticated logic
	// depending on your specific type hierarchy
	var/list/subtypes1 = subtypesof(wildcard1)
	var/list/subtypes2 = subtypesof(wildcard2)

	// Check if any subtypes overlap
	for(var/type1 in subtypes1)
		if(type1 in subtypes2)
			return TRUE

	return FALSE
