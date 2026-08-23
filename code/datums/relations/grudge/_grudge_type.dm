/datum/grudge_type
	abstract_type = /datum/grudge_type
	///the name of our grudge
	var/grudge_name = "Generic Grudge"
	///the agressor's side of the grudge text
	var/aggressor_text = "Generic statement."
	///the victim's side of the grudge text
	var/victim_text = "Generic statement."
	///the bitflags we support for the grudge
	var/grudge_bitflags = NONE
	///the agressor's viable job titles
	var/list/aggressor_titles
	///the victim's viable job titles
	var/list/victim_titles

GLOBAL_LIST_EMPTY(grudge_pool_by_job)
GLOBAL_LIST_EMPTY(grudge_pool_by_dept)
GLOBAL_LIST_EMPTY(grudge_pool_generic)

/proc/build_grudge_pools()
	GLOB.grudge_pool_by_job = list()
	GLOB.grudge_pool_by_dept = list()
	GLOB.grudge_pool_generic = list()

	for(var/datum/grudge_type/grudge as anything in typesof(/datum/grudge_type))
		if(IS_ABSTRACT(grudge))
			continue

		var/datum/grudge_type/temp = new grudge

		var/list/atitles = temp.aggressor_titles
		var/list/vtitles = temp.victim_titles

		// Job-specific: index every aggressor+victim title combination.
		if(length(atitles) && length(vtitles))
			for(var/at in atitles)
				for(var/vt in vtitles)
					var/key = "[at]>[vt]"
					if(!GLOB.grudge_pool_by_job[key])
						GLOB.grudge_pool_by_job[key] = list()
					GLOB.grudge_pool_by_job[key] += grudge
			continue

		// Department-specific.
		if(grudge::grudge_bitflags != NONE)
			var/dept_key = dept_flag_to_key(grudge::grudge_bitflags)
			if(dept_key)
				if(!GLOB.grudge_pool_by_dept[dept_key])
					GLOB.grudge_pool_by_dept[dept_key] = list()
				GLOB.grudge_pool_by_dept[dept_key] += grudge
			continue

		GLOB.grudge_pool_generic += grudge
