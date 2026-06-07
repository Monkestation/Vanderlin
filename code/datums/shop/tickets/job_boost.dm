/datum/ticket/job_boost
	ticket_type = TICKET_TYPE_JOB_BOOST
	var/job_boost_job
	var/boost_typepath = /datum/job_priority_boost/minor

/datum/ticket/job_boost/to_list()
	var/list/L = ..()
	L["job_boost_job"] = job_boost_job
	L["boost_typepath"] = ispath(boost_typepath) ? "[boost_typepath]" : null
	return L

/datum/ticket/job_boost/details()
	var/datum/job_priority_boost/boost = boost_typepath
	return ", [job_boost_job] - [initial(boost.name)]"

/datum/ticket/job_boost/from_list(list/L)
	..()
	job_boost_job = L["job_boost_job"]
	if(L["boost_typepath"])
		var/path = text2path(L["boost_typepath"])
		if(ispath(path, /datum/job_priority_boost))
			boost_typepath = path

/datum/ticket/job_boost/enrich_ui_entry(list/entry)
	entry["ui_fa_icon"] = "briefcase"
	entry["ui_color"] = "#ff9800"
	entry["ui_type_label"] = "Job Boost"
	var/datum/job_priority_boost/preview = new boost_typepath()
	var/target = job_boost_job ? job_boost_job : "all jobs"
	entry["ui_grant_summary"] = "Job boost ([preview.boost_amount]x): [target]"
	qdel(preview)

/datum/ticket/job_boost/use(client/user)
	if(!ispath(boost_typepath, /datum/job_priority_boost))
		return FALSE

	var/datum/job_priority_boost/boost = new boost_typepath()
	// Only set applicable_jobs if this is a targeted boost
	// If job_boost_job is null and the subtype has no applicable_jobs, it's a global boost
	if(job_boost_job && !length(boost.applicable_jobs))
		boost.applicable_jobs = list(job_boost_job)

	if(!islist(user.job_priority_boosts))
		user.job_priority_boosts = list()
	user.job_priority_boosts += boost

	spawn(1)
		SSjob.save_player_boosts(user.ckey)

	var/boost_target = job_boost_job ? " for <b>[job_boost_job]</b>" : " (all jobs)"
	to_chat(user, span_notice("Ticket used! Job boost applied: <b>[boost.name]</b>[boost_target]!"))
	return TRUE
