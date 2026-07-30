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

/proc/get_job_category(title)
	if(!title)
		return "Unknown"
	if(title in GLOB.noble_courthand_positions)
		return "Court"
	if(title in GLOB.garrison_positions)
		return "Garrison"
	if(title in GLOB.gallowband_positions)
		return "Gallowband"
	if(title in GLOB.church_positions)
		return "Church"
	if(title in GLOB.inquisition_positions)
		return "Inquisition"
	if(title in GLOB.serf_positions)
		return "Serfs"
	if(title in GLOB.company_positions)
		return "Company"
	if(title in GLOB.peasant_positions)
		return "Peasants"
	if(title in GLOB.apprentices_positions)
		return "Apprentices"
	if(title in GLOB.youngfolk_positions)
		return "Youth"
	if(title in GLOB.allmig_positions)
		return "Wanderers"
	return "Other"

/proc/get_job_sort_index(title)
	if(!GLOB.job_assignment_order.len)
		GLOB.job_assignment_order = get_job_assignment_order()
	var/idx = GLOB.job_assignment_order.Find(title)
	return idx ? idx : 9999

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
