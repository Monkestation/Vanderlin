GLOBAL_LIST_EMPTY(exp_to_update)
GLOBAL_PROTECT(exp_to_update)


// Procs
/datum/job/proc/required_playtime_remaining(client/C)
	if(!C)
		return 0
	if(!CONFIG_GET(flag/use_exp_tracking))
		return 0
	if(!SSdbcore.Connect())
		return 0
	if(!exp_requirements || !exp_type)
		return 0
	if(check_rights_for(C,R_ADMIN))
		return 0
	var/isexempt = C.prefs.db_flags & DB_FLAG_EXEMPT
	if(isexempt)
		return 0
	var/list/results = list()
	for(var/req_type in exp_type)
		var/my_exp = C.calc_exp_type(req_type)
		var/needed = exp_requirements[req_type]
		var/rem = max(needed - my_exp, 0)
		results[req_type] = rem
	var/max_remaining = 0
	for(var/t in results)
		if(results[t] > max_remaining)
			max_remaining = results[t]
	return max_remaining



/datum/job/proc/get_exp_req_amount()
	return exp_requirements

/datum/job/proc/get_exp_req_type()
	return exp_type


/client/proc/calc_exp_type(exptype)
	var/list/exp_map = prefs.exp.Copy()
	if(exptype == EXP_TYPE_LIVING)
		return text2num(exp_map[EXP_TYPE_LIVING])

	var/list/job_list = SSjob.experience_jobs_map[exptype]

	if(!job_list)
		return -1
	. = 0
	for(var/datum/job/job as anything in job_list)
		. += exp_map[job.title]

/client/proc/get_exp_report()
	if(!CONFIG_GET(flag/use_exp_tracking))
		return "Tracking is disabled in the server configuration file."

	var/list/play_records = prefs.exp
	if(!length(play_records))
		set_exp_from_db()
		play_records = prefs.exp

	var/has_playtime = FALSE
	for(var/k in play_records)
		if (text2num(play_records[k]) > 0)
			has_playtime = TRUE
			break
	if(!has_playtime)
		return "[key] has no records."

	var/list/return_text = list()
	return_text += "<ul>"

	if(play_records[EXP_TYPE_LIVING])
		return_text += "<li>Living time: [get_exp_format(text2num(play_records[EXP_TYPE_LIVING]))]</li>"
	if(play_records[EXP_TYPE_GHOST])
		return_text += "<li>Ghost time: [get_exp_format(text2num(play_records[EXP_TYPE_GHOST]))]</li>"

	var/list/job_playtimes = list()
	for (var/job_name in SSjob.name_occupations)
		var/playtime = play_records[job_name] ? text2num(play_records[job_name]) : 0
		if (playtime > 0)
			job_playtimes[job_name] = playtime

	var/list/sorted_jobs = list()
	for(var/i in 1 to length(job_playtimes))
		var/highest_key
		var/highest_value = -1
		for(var/job_name in job_playtimes)
			if(!(job_name in sorted_jobs))
				var/value = job_playtimes[job_name]
				if(value > highest_value)
					highest_value = value
					highest_key = job_name
		if(highest_key)
			sorted_jobs += highest_key

	for(var/job_name in sorted_jobs)
		var/playtime = job_playtimes[job_name]
		return_text += "<li>[job_name]: [get_exp_format(playtime)]</li>"

	return_text += "</ul>"
	return jointext(return_text, "")

/client/proc/get_exp_living()
	if(!prefs.exp)
		return "No data"
	var/exp_living = text2num(prefs.exp[EXP_TYPE_LIVING])
	return get_exp_format(exp_living)

/proc/get_exp_format(expnum)
	if(expnum <= 0)
		return "0h"

	var/hours = round(expnum / 60)
	if(hours > expnum / 60)
		hours--

	var/minutes = expnum - (hours * 60)

	if(hours > 0 && minutes > 0)
		return "[hours]h [minutes]m"
	else if(hours > 0)
		return "[hours]h"
	else
		return "[minutes]m"

/datum/controller/subsystem/blackbox/proc/update_exp(mins, ann = FALSE)
	if(!SSdbcore.Connect())
		return -1
	for(var/client/L in GLOB.clients)
		if(L.is_afk())
			continue
		L.update_exp_list(mins,ann)

/datum/controller/subsystem/blackbox/proc/update_exp_db()
	set waitfor = FALSE
	var/list/old_minutes = GLOB.exp_to_update
	GLOB.exp_to_update = null
	SSdbcore.MassInsert(format_table_name("role_time"), old_minutes, duplicate_key = "ON DUPLICATE KEY UPDATE minutes = minutes + VALUES(minutes)")

//resets a client's exp to what was in the db.
/client/proc/set_exp_from_db()
	if(!CONFIG_GET(flag/use_exp_tracking))
		return -1
	if(!SSdbcore.Connect())
		return -1

	// compensate for DB storing quoted ckeys like `'john_vanderlin'`
	var/quoted_ckey = "'[ckey]'"

	var/datum/DBQuery/exp_read = SSdbcore.NewQuery(
		"SELECT job, minutes FROM [format_table_name("role_time")] WHERE ckey = :ckey",
		list("ckey" = quoted_ckey)
	)
	if(!exp_read.Execute(async = TRUE))
		qdel(exp_read)
		return -1

	var/list/play_records = list()
	while(exp_read.NextRow())
		var/raw_key = exp_read.item[1]
		var/mins = text2num(exp_read.item[2])

		var/str_key = "[raw_key]"
		if(copytext(str_key, 1, 2) == "'")
			str_key = copytext(str_key, 2)
		if(copytext(str_key, length(str_key)) == "'")
			str_key = copytext(str_key, 1, length(str_key))

		play_records[str_key] = mins

	qdel(exp_read)

	for(var/rtype in SSjob.name_occupations)
		if(!play_records[rtype])
			play_records[rtype] = 0
	for(var/rtype in GLOB.exp_specialmap)
		if(!play_records[rtype])
			play_records[rtype] = 0

	prefs.exp = play_records


//updates player db flags
/client/proc/update_flag_db(newflag, state = FALSE)

	if(!SSdbcore.Connect())
		return -1

	if(!set_db_player_flags())
		return -1

	if((prefs.db_flags & newflag) && !state)
		prefs.db_flags &= ~newflag
	else
		prefs.db_flags |= newflag

	var/datum/DBQuery/flag_update = SSdbcore.NewQuery(
		"UPDATE [format_table_name("player")] SET flags=:flags WHERE ckey=:ckey",
		list("flags" = "[prefs.db_flags]", "ckey" = ckey)
	)

	if(!flag_update.Execute())
		qdel(flag_update)
		return -1
	qdel(flag_update)


/client/proc/update_exp_list(minutes, announce_changes = FALSE)
	if(!CONFIG_GET(flag/use_exp_tracking))
		return -1
	if(!SSdbcore.Connect())
		return -1
	if (!isnum(minutes))
		return -1
	var/list/play_records = list()

	if(isliving(mob))
		if(mob.stat != DEAD)
			var/rolefound = FALSE
			play_records[EXP_TYPE_LIVING] += minutes
			if(announce_changes)
				to_chat(src,"<span class='notice'>I got: [minutes] Living EXP!</span>")
			if(!is_unassigned_job(mob.mind.assigned_role))
				for(var/job in SSjob.name_occupations)
					if(mob.mind.assigned_role.title == job)
						rolefound = TRUE
						play_records[job] += minutes
						if(announce_changes)
							to_chat(src,"<span class='notice'>I got: [minutes] [job] EXP!</span>")
				if(mob.mind.special_role && !(mob.mind.datum_flags & DF_VAR_EDITED))
					var/trackedrole = mob.mind.special_role
					play_records[trackedrole] += minutes
					if(announce_changes)
						to_chat(src,"<span class='notice'>I got: [minutes] [trackedrole] EXP!</span>")
			if(!rolefound)
				play_records["Unknown"] += minutes
		else
			if(holder && !holder.deadmined)
				play_records[EXP_TYPE_ADMIN] += minutes
				if(announce_changes)
					to_chat(src,"<span class='notice'>I got: [minutes] Admin EXP!</span>")
			else
				play_records[EXP_TYPE_GHOST] += minutes
				if(announce_changes)
					to_chat(src,"<span class='notice'>I got: [minutes] Ghost EXP!</span>")
	else if(isobserver(mob))
		play_records[EXP_TYPE_GHOST] += minutes
		if(announce_changes)
			to_chat(src,"<span class='notice'>I got: [minutes] Ghost EXP!</span>")
	else if(minutes)	//Let "refresh" checks go through
		return

	for(var/jtype in play_records)
		var/jvalue = play_records[jtype]
		if (!jvalue)
			continue
		if (!isnum(jvalue))
			CRASH("invalid job value [jtype]:[jvalue]")
		LAZYINITLIST(GLOB.exp_to_update)
		GLOB.exp_to_update.Add(list(list(
			"job" = "'[jtype]'",
			"ckey" = "'[ckey]'",
			"minutes" = jvalue)))
		prefs.exp[jtype] += jvalue
	addtimer(CALLBACK(SSblackbox,TYPE_PROC_REF(/datum/controller/subsystem/blackbox, update_exp_db)),20,TIMER_OVERRIDE|TIMER_UNIQUE)


//ALWAYS call this at beginning to any proc touching player flags, or your database admin will probably be mad
/client/proc/set_db_player_flags()
	if(!SSdbcore.Connect())
		return FALSE

	var/datum/DBQuery/flags_read = SSdbcore.NewQuery(
		"SELECT flags FROM [format_table_name("player")] WHERE ckey=:ckey",
		list("ckey" = ckey)
	)

	if(!flags_read.Execute(async = TRUE))
		qdel(flags_read)
		return FALSE

	if(flags_read.NextRow())
		prefs.db_flags = text2num(flags_read.item[1])
	else if(isnull(prefs.db_flags))
		prefs.db_flags = 0	//This PROBABLY won't happen, but better safe than sorry.
	qdel(flags_read)
	return TRUE
