/proc/dept_flag_to_key(department_flag)
	if(department_flag & GARRISON)
		return "garrison"
	if(department_flag & CHURCHMEN)
		return "church"
	if(department_flag & NOBLEMEN)
		return "noble"
	if(department_flag & SERFS)
		return "serf"
	if(department_flag & PEASANTS)
		return "peasants"
	if(department_flag & APPRENTICES)
		return "apprentices"
	if(department_flag & YOUNGFOLK)
		return "youngfolk"
	if(department_flag & OUTSIDERS)
		return "outsider"
	if(department_flag & COMPANY)
		return "company"
	if(department_flag & INQUISITION)
		return "inquisition"
	return null
