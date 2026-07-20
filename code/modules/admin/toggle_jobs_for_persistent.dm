/client/proc/toggle_jobs_for_persistent()
	set category = "Admin.Jobs"
	set name = "Toggle all jobs for persistent"

	if(!check_rights(R_ADMIN))
		return FALSE

	var/list/options = list("DISABLE ALL JOBS, ENABLE PERSISTENT JOBS", "ENABLE ALL JOBS, DISABLE PERSISTENT JOBS", "DO NOTHING")

	var/toggle_jobs = browser_input_list(usr, "Which choice?", "Toggle all jobs for persistent", options, "DO NOTHING")
	switch(toggle_jobs)
		if("DO NOTHING")
			return
		if("DISABLE ALL JOBS, ENABLE PERSISTENT JOBS")
			var/slots_amount = input(usr, "How many slots for each job should be open? Default is 8", "Toggle all jobs for persistent", 8) as num
			for(var/datum/job/job_to_toggle in SSjob.joinable_occupations)
				if(istype(job_to_toggle, /datum/job/persistence))
					job_to_toggle.enabled = TRUE
					job_to_toggle.total_positions = slots_amount
					job_to_toggle.spawn_positions = slots_amount
				else
					job_to_toggle.enabled = FALSE
					job_to_toggle.total_positions = 0
			message_admins("[key_name_admin(usr)] disabled all jobs and enabled all persistent jobs.")
		if("ENABLE ALL JOBS, DISABLE PERSISTENT JOBS")
			for(var/datum/job/job_to_toggle in SSjob.joinable_occupations)
				if(istype(job_to_toggle, /datum/job/persistence))
					job_to_toggle.enabled = FALSE
					job_to_toggle.total_positions = initial(job_to_toggle.total_positions)
					job_to_toggle.spawn_positions = initial(job_to_toggle.spawn_positions)
				else
					job_to_toggle.enabled = TRUE
					job_to_toggle.total_positions = initial(job_to_toggle.total_positions)
			message_admins("[key_name_admin(usr)] enabled all jobs and disabled all persistent jobs.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle all jobs for persistent")
