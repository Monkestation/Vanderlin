///job subtype so i can implement stat and skill variance
/datum/attribute_holder/sheet/job
	attribute_default = 0
	skill_default = null
	var/list/attribute_variance = 0
	var/list/clamped_adjustment = 0

/datum/attribute_holder/sheet/job/New(mob/new_parent)
	. = ..()
	if(isnum(attribute_variance))
		var/og_variance = attribute_variance
		attribute_variance = list()
		for(var/thing in raw_attribute_list)
			if(!ispath(thing, STAT))
				continue
			attribute_variance[thing] = list(-og_variance, og_variance)
	else if(islist(attribute_variance) && (LAZYLEN(attribute_variance) == 2) && isnum(attribute_variance[1]) && isnum(attribute_variance[2]))
		var/list/og_variance = attribute_variance.Copy()
		attribute_variance = list()
		for(var/thing in raw_attribute_list)
			if(!ispath(thing, STAT))
				continue
			attribute_variance[thing] = list(og_variance[1], og_variance[2])

	if(isnum(clamped_adjustment))
		var/og_adj = clamped_adjustment
		clamped_adjustment = list()
		for(var/thing in raw_attribute_list)
			if(!ispath(thing, STAT))
				continue
			clamped_adjustment[thing] = list(og_adj, null) // null cap = use natural max
	else if(islist(clamped_adjustment) && (LAZYLEN(clamped_adjustment) == 2) && isnum(clamped_adjustment[1]))
		var/list/og_adj = clamped_adjustment.Copy()
		clamped_adjustment = list()
		for(var/thing in raw_attribute_list)
			if(!ispath(thing, STAT))
				continue
			clamped_adjustment[thing] = list(og_adj[1], og_adj[2])

/datum/attribute_holder/sheet/job/on_add(datum/attribute_holder/plagiarist)
	. = ..()
	if(attribute_variance)
		for(var/path in plagiarist.raw_attribute_list)
			if(LAZYLEN(attribute_variance[path]) < 2)
				continue
			var/random = rand(attribute_variance[path][1], attribute_variance[path][2])
			if(ispath(path, SKILL))
				plagiarist.raw_attribute_list[path] = clamp(plagiarist.raw_attribute_list[path] + random, plagiarist.skill_min, plagiarist.skill_max)
			else
				plagiarist.raw_attribute_list[path] = clamp(plagiarist.raw_attribute_list[path] + random, plagiarist.attribute_min, plagiarist.attribute_max)

	if(clamped_adjustment)
		for(var/path in plagiarist.raw_attribute_list)
			var/list/adj = clamped_adjustment[path]
			if(!adj || LAZYLEN(adj) < 1)
				continue
			var/current = plagiarist.raw_attribute_list[path]
			var/num = adj[1]
			var/cap = isnull(adj[2]) ? (ispath(path, SKILL) ? plagiarist.skill_max : plagiarist.attribute_max) : adj[2]
			if(current >= cap)
				continue
			plagiarist.raw_attribute_list[path] = clamp(current + num, 0, cap)
