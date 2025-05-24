GLOBAL_LIST_INIT(slur_groups, generate_slur_groups())
GLOBAL_LIST_INIT(slurs_all, generate_slurs_all())

/proc/generate_slur_groups()
	RETURN_TYPE(/list)
	var/list/slur_groups = strings("slurs.json", "slurs")
	var/list/slurs = list()
	for(var/group as anything in slur_groups)
		slurs[group] = slur_groups[group]
	return slurs

/proc/generate_slurs_all()
	RETURN_TYPE(/list)
	var/list/slurs = list()
	for(var/group as anything in GLOB.slur_groups)
		slurs |= GLOB.slur_groups[group]
	return slurs
