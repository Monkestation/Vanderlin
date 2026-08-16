/datum/job/admin
	title = "ADMIN SPECIAL JOB"

	department_flag = ADMIN_SPECIAL
	total_positions = 0
	spawn_positions = 0
	enabled = FALSE
	bypass_lastclass = TRUE
	selection_color = "#f700ff"
	can_have_apprentices = FALSE
	whitelisted_ckeys = list("ADMINLOCK")

/datum/job/admin/New()
	. = ..()
	reset_whitelists()
	RegisterSignal(SSdcs, COMSIG_GLOB_ADMINS_RELOADED, PROC_REF(reset_whitelists))

/datum/job/admin/proc/reset_whitelists()
	whitelisted_ckeys.Cut()
	for(var/ckey in GLOB.admin_datums)
		whitelisted_ckeys += ckey
	if(!length(whitelisted_ckeys))
		whitelisted_ckeys += "ADMINLOCK"
