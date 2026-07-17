/proc/job_group_list(group_key)
	switch(group_key)
		if("noble") return GLOB.noble_positions
		if("garrison") return GLOB.garrison_positions
		if("gallowband") return GLOB.gallowband_positions
		if("church") return GLOB.church_positions
		if("inquisition") return GLOB.inquisition_positions
		if("serf") return GLOB.serf_positions
		if("company") return GLOB.company_positions
		if("peasant") return GLOB.peasant_positions
		if("apprentice") return GLOB.apprentices_positions
		if("allmig") return GLOB.allmig_positions
		if("youngfolk") return GLOB.youngfolk_positions
	return list()

/proc/link_family(datum/mind/mind_a, datum/mind/mind_b, bond, rel_type = /datum/relation/family, adopted = FALSE, in_law = FALSE)
	if(!mind_a || !mind_b || mind_a == mind_b)
		return null

	for(var/datum/relation/family/existing in mind_a.relations)
		if(existing.other == mind_b && existing.bond_type == bond)
			return existing

	var/datum/relation/family/R = mind_a.add_relation(mind_b, rel_type)
	if(!R)
		return null

	R.bond_type = bond
	R.adopted = adopted
	R.in_law = in_law
	R.refresh_snapshot()
	R.update_text()
	return R
