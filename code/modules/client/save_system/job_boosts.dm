/datum/job_priority_boost
	var/name = "Job Priority Boost"
	var/desc = "Increases job assignment priority"
	var/boost_amount = 1 // How many "virtual" entries this creates in job selection
	var/list/applicable_jobs = list() // Specific jobs this boost applies to. Empty = all jobs
	var/expiry_time = 0 // World time when this boost expires. 0 = never expires
	var/uses_remaining = -1 // Number of times this can be used. -1 = infinite
	var/boost_type = BOOST_TYPE_GENERAL // Type of boost for categorization


/datum/job_priority_boost/timed
	name = "Temporary Job Boost"
	desc = "Job boost that expires after a set time"
	boost_amount = 3

/datum/job_priority_boost/timed/New(duration_hours = 24)
	..()
	expiry_time = world.time + (duration_hours * 36000) // SS13 time conversion

/datum/job_priority_boost/automaton_15
	name = "Automaton Vessel Boost"
	desc = "Increases your odds of rolling Automaton for a brief period"
	boost_amount = 10
	uses_remaining = 15
	applicable_jobs = list(WHITELIST_AUTOMATON)

/datum/job_priority_boost/minor
	name = "Minor Job Boost"
	desc = "Slightly increases job priority"
	boost_amount = 2

/datum/job_priority_boost/major
	name = "Major Job Boost"
	desc = "Significantly increases job priority"
	boost_amount = 5

/datum/job_priority_boost/premium
	name = "Premium Job Boost"
	desc = "Greatly increases job priority"
	boost_amount = 10

/datum/job_priority_boost/limited_use
	name = "Limited Job Boost"
	desc = "Job boost with limited uses"
	boost_amount = 5
	uses_remaining = 3

/datum/job_priority_boost/proc/is_valid()
	if(expiry_time > 0 && world.time > expiry_time)
		return FALSE
	if(uses_remaining == 0)
		return FALSE
	return TRUE

/datum/job_priority_boost/proc/can_boost_job(datum/job/job)
	if(!is_valid())
		return FALSE
	if(length(applicable_jobs) && !(job.title in applicable_jobs))
		return FALSE
	return TRUE

/datum/job_priority_boost/proc/can_boost_vessel(vessel_id)
    if(!is_valid())
        return FALSE
    if(length(applicable_jobs) && !(vessel_id in applicable_jobs))
        return FALSE
    return TRUE

/datum/job_priority_boost/proc/use_boost()
	if(uses_remaining > 0)
		uses_remaining--
		// Trigger save when boost is used
		spawn(1)
			var/client/C = get_boost_owner()
			if(C)
				SSjob.save_player_boosts(C.ckey)

/datum/job_priority_boost/proc/get_boost_owner()
	for(var/ckey in GLOB.directory)
		var/client/C = GLOB.directory[ckey]
		if(C && islist(C.job_priority_boosts) && (src in C.job_priority_boosts))
			return C
	return null

/client/proc/cmd_view_job_boosts(target_ckey as text)
	set category = "Debug"
	set name = "View Job Boosts"
	set desc = "View a player's active job boosts"

	if(!check_rights(R_DEBUG))
		return

	if(!target_ckey)
		target_ckey = input("Enter target ckey:", "View Boosts") as text|null
		if(!target_ckey)
			return

	target_ckey = ckey(target_ckey)
	var/client/target_client = GLOB.directory[target_ckey]

	if(!target_client)
		to_chat(src, "<span class='warning'>Client '[target_ckey]' not found.</span>")
		return

	if(!islist(target_client.job_priority_boosts) || !length(target_client.job_priority_boosts))
		to_chat(src, "<span class='notice'>[target_ckey] has no active job boosts.</span>")
		return

	to_chat(src, "<span class='notice'>Job Boosts for [target_ckey]:</span>")
	for(var/datum/job_priority_boost/boost in target_client.job_priority_boosts)
		var/validity = boost.is_valid() ? "VALID" : "EXPIRED"
		var/expiry_info = boost.expiry_time > 0 ? " (expires: [boost.expiry_time])" : ""
		var/uses_info = boost.uses_remaining >= 0 ? " (uses left: [boost.uses_remaining])" : " (unlimited uses)"
		to_chat(src, "<span class='notice'>- [boost.name]: Amount [boost.boost_amount][expiry_info][uses_info] - [validity]</span>")

/client/proc/cmd_give_job_boost()
	set category = "Debug"
	set name = "Give Job Boost"
	set desc = "Give a job priority boost to a player"

	var/target_ckey
	var/boost_type
	var/boost_amount
	if(!check_rights(R_DEBUG))
		return

	if(!target_ckey)
		target_ckey = input("Enter target ckey:", "Job Boost") as text|null
		if(!target_ckey)
			return

	target_ckey = ckey(target_ckey)
	var/client/target_client = GLOB.directory[target_ckey]

	if(!target_client)
		to_chat(src, "<span class='warning'>Client '[target_ckey]' not found.</span>")
		return

	if(!boost_type)
		boost_type = input("Select boost type:", "Job Boost", "general") in list("general", "minor", "major", "premium", "timed", "limited")

	var/datum/job_priority_boost/boost

	switch(boost_type)
		if("general")
			boost = new /datum/job_priority_boost()
		if("minor")
			boost = new /datum/job_priority_boost/minor()
		if("major")
			boost = new /datum/job_priority_boost/major()
		if("premium")
			boost = new /datum/job_priority_boost/premium()
		if("timed")
			var/hours = input("Hours until expiry:", "Job Boost", 24) as num|null
			if(!hours)
				return
			boost = new /datum/job_priority_boost/timed(hours)
		if("limited")
			boost = new /datum/job_priority_boost/limited_use()
			var/uses = input("How many uses?:", "Job Boost", 1) as num|null
			if(uses)
				boost.uses_remaining = uses
		else
			to_chat(src, "<span class='warning'>Invalid boost type.</span>")
			return

	if(!boost)
		to_chat(src, "<span class='warning'>Failed to create boost.</span>")
		return

	// Allow customization of boost amount
	if(!boost_amount)
		boost_amount = input("Enter a boost amount") as num|null
	if(boost_amount != 0)
		boost.boost_amount = boost_amount

	if(SSjob.give_job_boost(target_client, boost))
		to_chat(src, "<span class='notice'>Successfully gave '[boost.name]' to '[target_ckey]'.</span>")
		log_admin("[key_name(src)] gave job boost '[boost.name]' (amount: [boost.boost_amount], uses: [boost.uses_remaining]) to [key_name(target_client)]")
	else
		to_chat(src, "<span class='warning'>Failed to give boost to '[target_ckey]'.</span>")
		qdel(boost)

/proc/give_player_job_boost(ckey, boost_type_path, boost_amount = 0, uses = -1, expiry_hours = 0, applicable_jobs = null)
	var/client/target_client = GLOB.directory[ckey(ckey)]
	if(!target_client)
		return FALSE

	var/datum/job_priority_boost/boost = new boost_type_path()
	if(!boost)
		return FALSE

	if(boost_amount > 0)
		boost.boost_amount = boost_amount
	if(uses >= 0)
		boost.uses_remaining = uses
	if(expiry_hours > 0)
		boost.expiry_time = world.time + (expiry_hours * 36000)
	if(applicable_jobs)
		boost.applicable_jobs = applicable_jobs

	return SSjob.give_job_boost(target_client, boost)

/datum/job_boost_panel
	var/datum/admins/holder
	var/selected_ckey = null

	var/selected_boost_type = "general"
	var/selected_boost_amount = 1
	var/selected_uses = -1
	var/selected_expiry_hours = 0
	var/list/selected_applicable = list()

/datum/job_boost_panel/New(datum/admins/passed_holder)
	holder = passed_holder
	return ..()

/datum/job_boost_panel/proc/show_ui(mob/user, forced_key)
	if(forced_key)
		selected_ckey = forced_key

	var/list/dat = list()
	dat += "<center><b>Job Boost Panel</b></center><HR>"
	dat += "<b>CKEY:</b> [selected_ckey ? selected_ckey : "None"] <a href='byond://?src=[REF(src)];task=ckey'>Change</a><BR><BR>"

	if(selected_ckey)
		var/client/target_client = GLOB.directory[selected_ckey]

		dat += "<b>Active Boosts for [selected_ckey]:</b>"
		if(!target_client)
			dat += " <font color='orange'>(offline -- boosts cannot be managed)</font>"
		dat += "<BR>"

		if(target_client && islist(target_client.job_priority_boosts) && length(target_client.job_priority_boosts))
			var/i = 1
			for(var/datum/job_priority_boost/boost in target_client.job_priority_boosts)
				var/validity = boost.is_valid() ? "<font color='green'>Valid</font>" : "<font color='red'>Expired</font>"
				var/expiry_info = boost.expiry_time > 0 ? "expires [time2text(boost.expiry_time, "DD/MM/YYYY")]" : "no expiry"
				var/uses_info = boost.uses_remaining >= 0 ? "[boost.uses_remaining] uses left" : "unlimited"
				var/applicable_info = length(boost.applicable_jobs) ? " <i>([boost.applicable_jobs.Join(", ")])</i>" : ""
				dat += "&nbsp;&nbsp;<b>[boost.name]</b>[applicable_info] - x[boost.boost_amount], [expiry_info], [uses_info]: [validity]"
				dat += " <a href='byond://?src=[REF(src)];task=remove_boost;boost_index=[i]'>Remove</a><BR>"
				i++
		else
			dat += "<i>&nbsp;&nbsp;No active boosts[!target_client ? " (player offline)" : ""].</i><BR>"

		dat += "<HR>"

		dat += "<b>Build New Boost:</b><BR>"

		var/list/boost_types = list("general", "minor", "major", "premium", "timed", "limited")
		dat += "&nbsp;&nbsp;<b>Type:</b> "
		for(var/bt in boost_types)
			if(bt == selected_boost_type)
				dat += "<b><font color='green'>[bt]</font></b> "
			else
				dat += "<a href='byond://?src=[REF(src)];task=set_type;boost_type=[bt]'>[bt]</a> "
		dat += "<BR>"

		dat += "&nbsp;&nbsp;<b>Amount:</b> [selected_boost_amount] "
		dat += "<a href='byond://?src=[REF(src)];task=set_amount;dir=up'>+</a> "
		dat += "<a href='byond://?src=[REF(src)];task=set_amount;dir=down'>-</a> "
		dat += "<a href='byond://?src=[REF(src)];task=set_amount_custom'>Custom</a><BR>"

		var/uses_display = selected_uses < 0 ? "Unlimited" : "[selected_uses]"
		dat += "&nbsp;&nbsp;<b>Uses:</b> [uses_display] "
		dat += "<a href='byond://?src=[REF(src)];task=set_uses;dir=up'>+</a> "
		dat += "<a href='byond://?src=[REF(src)];task=set_uses;dir=down'>-</a> "
		dat += "<a href='byond://?src=[REF(src)];task=set_uses_custom'>Custom</a> "
		dat += "<a href='byond://?src=[REF(src)];task=set_uses_unlimited'>Unlimited</a><BR>"

		// Expiry -- only shown for timed
		if(selected_boost_type == "timed")
			var/expiry_display = selected_expiry_hours > 0 ? "[selected_expiry_hours]h" : "Not set"
			dat += "&nbsp;&nbsp;<b>Expiry:</b> [expiry_display] "
			dat += "<a href='byond://?src=[REF(src)];task=set_expiry;dir=up'>+1h</a> "
			dat += "<a href='byond://?src=[REF(src)];task=set_expiry;dir=down'>-1h</a> "
			dat += "<a href='byond://?src=[REF(src)];task=set_expiry_custom'>Custom</a><BR>"

		dat += "&nbsp;&nbsp;<b>Applicable (empty = all):</b><BR>"
		for(var/entry in selected_applicable)
			dat += "&nbsp;&nbsp;&nbsp;&nbsp;- [entry] <a href='byond://?src=[REF(src)];task=remove_applicable;entry=[entry]'>Remove</a><BR>"
		dat += "&nbsp;&nbsp;&nbsp;&nbsp;<a href='byond://?src=[REF(src)];task=add_job'>+ Add Job</a> "
		dat += "<a href='byond://?src=[REF(src)];task=add_vessel'>+ Add Vessel</a> "
		if(length(selected_applicable))
			dat += "<a href='byond://?src=[REF(src)];task=clear_applicable'>Clear All</a>"
		dat += "<BR>"

		dat += "<BR>"
		if(target_client)
			dat += "<a href='byond://?src=[REF(src)];task=apply_boost'><b>\[ APPLY BOOST \]</b></a> "
		dat += "<a href='byond://?src=[REF(src)];task=reset_builder'>Reset Builder</a><BR>"

	var/datum/browser/popup = new(user, "job_boost_panel", "Job Boost Panel", 520, 520)
	popup.set_content(dat.Join())
	popup.open()

/datum/job_boost_panel/Topic(href, list/href_list)
	. = ..()
	if(!holder)
		return
	var/mob/user = usr
	if(holder.owner != user.client)
		return
	if(!check_rights_for(user.client, R_ADMIN))
		to_chat(user, span_boldwarning("No admin permission."))
		return

	switch(href_list["task"])
		if("ckey")
			var/chosen_ckey = input(user, "Enter ckey", "CKEY", selected_ckey) as text|null
			if(!chosen_ckey)
				return
			selected_ckey = ckey(chosen_ckey)
			reset_builder()

		if("set_type")
			selected_boost_type = href_list["boost_type"]
			if(selected_boost_type != "timed")
				selected_expiry_hours = 0
			switch(selected_boost_type)
				if("general")
					selected_boost_amount = 1
					selected_uses = -1
				if("minor")
					selected_boost_amount = 2
					selected_uses = -1
				if("major")
					selected_boost_amount = 5
					selected_uses = -1
				if("premium")
					selected_boost_amount = 10
					selected_uses = -1
				if("timed")
					selected_boost_amount = 3
					selected_uses = -1
					selected_expiry_hours = 24
				if("limited")
					selected_boost_amount = 5
					selected_uses = 3

		if("set_amount")
			if(href_list["dir"] == "up")
				selected_boost_amount++
			else
				selected_boost_amount = max(1, selected_boost_amount - 1)

		if("set_amount_custom")
			var/val = input(user, "Enter boost amount", "Boost Amount", selected_boost_amount) as num|null
			if(isnull(val))
				return
			selected_boost_amount = max(1, round(val))

		if("set_uses")
			if(selected_uses < 0)
				selected_uses = 1
			else if(href_list["dir"] == "up")
				selected_uses++
			else
				selected_uses = max(1, selected_uses - 1)

		if("set_uses_custom")
			var/val = input(user, "Enter number of uses (-1 for unlimited)", "Uses", selected_uses) as num|null
			if(isnull(val))
				return
			selected_uses = round(val)

		if("set_uses_unlimited")
			selected_uses = -1

		if("set_expiry")
			if(href_list["dir"] == "up")
				selected_expiry_hours++
			else
				selected_expiry_hours = max(1, selected_expiry_hours - 1)

		if("set_expiry_custom")
			var/val = input(user, "Enter expiry in hours", "Expiry Hours", selected_expiry_hours) as num|null
			if(isnull(val))
				return
			selected_expiry_hours = max(1, round(val))

		if("add_job")
			var/chosen_job = input(user, "Select job", "Add Job", null) as null|anything in SSjob.name_occupations
			if(!chosen_job)
				return
			selected_applicable |= chosen_job

		if("add_vessel")
			var/chosen_vessel = input(user, "Select vessel", "Add Vessel", null) as null|anything in GLOB.vessel_ids
			if(!chosen_vessel)
				return
			selected_applicable |= chosen_vessel

		if("remove_applicable")
			selected_applicable -= href_list["entry"]

		if("clear_applicable")
			selected_applicable.Cut()

		if("reset_builder")
			reset_builder()

		if("remove_boost")
			var/client/target_client = GLOB.directory[selected_ckey]
			if(!target_client)
				return
			var/boost_index = text2num(href_list["boost_index"])
			if(!boost_index || boost_index > length(target_client.job_priority_boosts))
				return
			var/datum/job_priority_boost/boost = target_client.job_priority_boosts[boost_index]
			target_client.job_priority_boosts -= boost
			var/msg = "[key_name_admin(user)] removed boost '[boost.name]' from [selected_ckey]"
			message_admins(msg)
			log_admin(msg)
			qdel(boost)

		if("apply_boost")
			if(!selected_ckey)
				to_chat(user, span_boldwarning("No ckey selected."))
				return
			var/client/target_client = GLOB.directory[selected_ckey]
			if(!target_client)
				to_chat(user, span_boldwarning("[selected_ckey] must be online."))
				return

			var/datum/job_priority_boost/boost
			switch(selected_boost_type)
				if("general")
					boost = new /datum/job_priority_boost()
				if("minor")
					boost = new /datum/job_priority_boost/minor()
				if("major")
					boost = new /datum/job_priority_boost/major()
				if("premium")
					boost = new /datum/job_priority_boost/premium()
				if("timed")
					boost = new /datum/job_priority_boost/timed(selected_expiry_hours)
				if("limited")
					boost = new /datum/job_priority_boost/limited_use()

			if(!boost)
				return

			boost.boost_amount = selected_boost_amount
			boost.uses_remaining = selected_uses
			if(selected_expiry_hours > 0 && selected_boost_type == "timed")
				boost.expiry_time = world.time + (selected_expiry_hours * 36000)
			if(length(selected_applicable))
				boost.applicable_jobs = selected_applicable.Copy()

			var/auto_name = "[capitalize(selected_boost_type)] Boost"
			if(length(selected_applicable))
				auto_name = "[selected_applicable.Join("/") ] [capitalize(selected_boost_type)] Boost"
			boost.name = auto_name

			if(SSjob.give_job_boost(target_client, boost))
				var/msg = "[key_name_admin(user)] gave boost '[boost.name]' (x[boost.boost_amount], uses: [selected_uses < 0 ? "unlimited" : "[selected_uses]"][length(boost.applicable_jobs) ? ", restricted to: [boost.applicable_jobs.Join(", ")]" : ""]) to [selected_ckey]"
				message_admins(msg)
				log_admin(msg)
				reset_builder()
			else
				qdel(boost)
				to_chat(user, span_boldwarning("Failed to apply boost."))

	show_ui(user)

/datum/job_boost_panel/proc/reset_builder()
	selected_boost_type = "general"
	selected_boost_amount = 1
	selected_uses = -1
	selected_expiry_hours = 0
	selected_applicable.Cut()
