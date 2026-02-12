/client/proc/Debug2()
	set category = "Debug.Debug"
	set name = "Debug-Game"
	if(!check_rights(R_DEBUG))
		return

	if(GLOB.Debug2)
		GLOB.Debug2 = 0
		message_admins("[key_name(src)] toggled debugging off.")
		log_admin("[key_name(src)] toggled debugging off.")
	else
		GLOB.Debug2 = 1
		message_admins("[key_name(src)] toggled debugging on.")
		log_admin("[key_name(src)] toggled debugging on.")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Debug Two") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/* 21st Sept 2010
Updated by Skie -- Still not perfect but better!
Stuff you can't do:
Call proc /mob/proc/Dizzy() for some player
Because if you select a player mob as owner it tries to do the proc for
/mob/living/carbon/human/ instead. And that gives a run-time error.
But you can call procs that are of type /mob/living/carbon/human/proc/ for that player.
*/

/client/proc/cmd_admin_animalize(mob/M in GLOB.mob_list)
	set category = "GameMaster.Equipping"
	set name = "Make Simple Animal"

	if(!SSticker.HasRoundStarted())
		alert("Wait until the game starts")
		return

	if(!M)
		alert("That mob doesn't seem to exist, close the panel and try again.")
		return

	if(isnewplayer(M))
		alert("The mob must not be a new_player.")
		return

	log_admin("[key_name(src)] has animalized [M.key].")
	INVOKE_ASYNC(M, TYPE_PROC_REF(/mob, Animalize))


//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all(object as text)
	set category = "Debug"
	set name = "Del-All"

	var/list/matches = get_fancy_list_of_atom_types()
	if (!isnull(object) && object!="")
		matches = filter_fancy_list(matches, object)

	if(matches.len==0)
		return
	var/hsbitem = input(usr, "Choose an object to delete.", "Delete:") as null|anything in sortList(matches)
	if(hsbitem)
		hsbitem = matches[hsbitem]
		var/counter = 0
		for(var/atom/O in world)
			if(istype(O, hsbitem))
				counter++
				qdel(O)
			CHECK_TICK
		log_admin("[key_name(src)] has deleted all ([counter]) instances of [hsbitem].")
		message_admins("[key_name_admin(src)] has deleted all ([counter]) instances of [hsbitem].")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Delete All") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_assume_direct_control(mob/M in GLOB.mob_list)
	set category = "Admin.Admin"
	set name = "Assume direct control"
	set desc = ""

	if(M.ckey)
		if(alert("This mob is being controlled by [M.key]. Are you sure you wish to assume control of it? [M.key] will be made a ghost.",,"Yes","No") != "Yes")
			return
		else
			var/mob/dead/observer/ghost = new/mob/dead/observer(M,1)
			ghost.ckey = M.ckey
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] assumed direct control of [M].</span>")
	log_admin("[key_name(usr)] assumed direct control of [M].")
	var/mob/adminmob = src.mob
	M.ckey = src.ckey
	if(isobserver(adminmob))
		qdel(adminmob)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Assume Direct Control") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_give_control_to_player(mob/M in GLOB.mob_list, client/player in GLOB.clients)
	set category = "Admin.Admin"
	set name = "Give Control To Player"
	set desc = ""

	if(M.ckey)
		if(alert("This mob is being controlled by [key_name(M)]. Are you sure you wish to give [key_name(player)] control of it? [key_name(M)] will be made a ghost.",,"Yes","No") != "Yes")
			return
		else
			var/mob/dead/observer/ghost = new/mob/dead/observer(M,1)
			ghost.ckey = M.ckey
	message_admins(span_adminnotice("[key_name_admin(usr)] gave control of [M] to [key_name(player)]."))
	log_admin("[key_name(usr)] gave control of [M] to [key_name(player)].")
	var/mob/playermob = player.mob
	M.ckey = player.ckey
	if(isobserver(playermob))
		qdel(playermob)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Give Control To Player") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_areatest(on_station)
	set category = "Debug.Mapping"
	set name = "Test Areas"

	var/list/dat = list()
	var/list/areas_all = list()
	var/list/areas_with_APC = list()
	var/list/areas_with_multiple_APCs = list()
	var/list/areas_with_air_alarm = list()
	var/list/areas_with_RC = list()
	var/list/areas_with_light = list()
	var/list/areas_with_LS = list()
	var/list/areas_with_intercom = list()
	var/list/areas_with_camera = list()
	var/list/station_areas_blacklist = typecacheof(list())

	if(SSticker.current_state == GAME_STATE_STARTUP)
		to_chat(usr, "Game still loading, please hold!")
		return

	var/log_message
	if(on_station)
		dat += "<b>Only checking areas on station z-levels.</b><br><br>"
		log_message = "station z-levels"
	else
		log_message = "all z-levels"

	message_admins("<span class='adminnotice'>[key_name_admin(usr)] used the Test Areas debug command checking [log_message].</span>")
	log_admin("[key_name(usr)] used the Test Areas debug command checking [log_message].")

	for(var/area/A as anything in GLOB.areas)
		if(on_station)
			var/turf/picked = safepick(get_area_turfs(A.type))
			if(picked && is_station_level(picked.z))
				if(!(A.type in areas_all) && !is_type_in_typecache(A, station_areas_blacklist))
					areas_all.Add(A.type)
		else if(!(A.type in areas_all))
			areas_all.Add(A.type)
		CHECK_TICK

	for(var/obj/machinery/light/L in GLOB.machines)
		var/area/A = get_area(L)
		if(!A)
			dat += "Skipped over [L] in invalid location, [L.loc].<br>"
			continue
		if(!(A.type in areas_with_light))
			areas_with_light.Add(A.type)
		CHECK_TICK

	var/list/areas_without_APC = areas_all - areas_with_APC
	var/list/areas_without_air_alarm = areas_all - areas_with_air_alarm
	var/list/areas_without_RC = areas_all - areas_with_RC
	var/list/areas_without_light = areas_all - areas_with_light
	var/list/areas_without_LS = areas_all - areas_with_LS
	var/list/areas_without_intercom = areas_all - areas_with_intercom
	var/list/areas_without_camera = areas_all - areas_with_camera

	if(areas_without_APC.len)
		dat += "<h1>AREAS WITHOUT AN APC:</h1>"
		for(var/areatype in areas_without_APC)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_with_multiple_APCs.len)
		dat += "<h1>AREAS WITH MULTIPLE APCS:</h1>"
		for(var/areatype in areas_with_multiple_APCs)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_air_alarm.len)
		dat += "<h1>AREAS WITHOUT AN AIR ALARM:</h1>"
		for(var/areatype in areas_without_air_alarm)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_RC.len)
		dat += "<h1>AREAS WITHOUT A REQUEST CONSOLE:</h1>"
		for(var/areatype in areas_without_RC)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_light.len)
		dat += "<h1>AREAS WITHOUT ANY LIGHTS:</h1>"
		for(var/areatype in areas_without_light)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_LS.len)
		dat += "<h1>AREAS WITHOUT A LIGHT SWITCH:</h1>"
		for(var/areatype in areas_without_LS)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_intercom.len)
		dat += "<h1>AREAS WITHOUT ANY INTERCOMS:</h1>"
		for(var/areatype in areas_without_intercom)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_camera.len)
		dat += "<h1>AREAS WITHOUT ANY CAMERAS:</h1>"
		for(var/areatype in areas_without_camera)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(!(areas_with_APC.len || areas_with_multiple_APCs.len || areas_with_air_alarm.len || areas_with_RC.len || areas_with_light.len || areas_with_LS.len || areas_with_intercom.len || areas_with_camera.len))
		dat += "<b>No problem areas!</b>"

	var/datum/browser/popup = new(usr, "testareas", "Test Areas", 500, 750)
	popup.set_content(dat.Join())
	popup.open()


/client/proc/cmd_admin_areatest_station()
	set category = "Debug.Mapping"
	set name = "Test Areas (STATION Z)"
	cmd_admin_areatest(TRUE)

/client/proc/cmd_admin_areatest_all()
	set category = "Debug.Mapping"
	set name = "Test Areas (ALL)"
	cmd_admin_areatest(FALSE)

/client/proc/cmd_admin_dress(mob/M in GLOB.mob_list)
	set category = "GameMaster.Equipping"
	set name = "Select Equipment"

	if(!(ishuman(M) || isobserver(M)))
		return

	var/answer = browser_alert(src, "Apply an outfit or a full job? (Does not consume slots or change job)", "Admin Dress", list("Outfit", "Job", "Cancel"))
	if(!answer || QDELETED(src))
		return
	switch(answer)
		if("Job")
			job_selector(M)
		if("Outfit")
			outfit_selector(M)
		if("Cancel")
			return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Admin Dress") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/outfit_selector(mob/to_dress)
	var/dresscode = robust_dress_shop()

	if(!dresscode)
		return

	var/mob/living/carbon/human/H
	if(!ishuman(to_dress))
		H = to_dress.change_mob_type(/mob/living/carbon/human, null, null, TRUE)
	else
		H = to_dress

	for(var/obj/item/I in H.get_all_gear())
		qdel(I)

	if(dresscode != "Naked")
		H.equipOutfit(dresscode)

	log_admin("[key_name(usr)] changed the outfit of [key_name(H)] to [dresscode].")
	message_admins(span_adminnotice("[key_name_admin(usr)] changed the outfit of [ADMIN_LOOKUPFLW(H)] to [dresscode]."))

/client/proc/job_selector(mob/to_dress)
	var/list/basejobs = list("Custom")
	var/list/jobs = subtypesof(/datum/job)
	var/list/selection = list()
	for(var/datum/job/job as anything in jobs)
		if(IS_ABSTRACT(job))
			continue
		selection[job.title] = job

	var/datum/job/selected = browser_input_list(src, "Select Job", "Job selection", basejobs + selection)
	if(!selected || QDELETED(src))
		return

	if(selected == "Custom")
		var/list/custom_jobs = list()
		for(var/id in GLOB.custom_jobs)
			var/datum/job/custom_job/J = GLOB.custom_jobs[id]
			custom_jobs[J.id] = J
		var/selected_name = browser_input_list(src, "Select Job", "Custom Job Selector", sortList(custom_jobs))
		if(!selected_name)
			return
		selected = GLOB.custom_jobs[selected_name]
	else
		selected = SSjob.GetJobType(selection[selected])
		if(!istype(selected))
			return

	var/mob/living/carbon/human/dressed_human
	if(!ishuman(to_dress))
		dressed_human = to_dress.change_mob_type(/mob/living/carbon/human, null, null, TRUE)
	else
		dressed_human = to_dress

	for(var/obj/item/I in dressed_human.get_all_gear())
		qdel(I)

	SSjob.EquipRank(dressed_human, selected, dressed_human.client)
	log_admin("[key_name(src)] changed the job of [key_name(dressed_human)] to [selected].")
	message_admins(span_adminnotice("[key_name_admin(src)] changed the job of [ADMIN_LOOKUPFLW(dressed_human)] to [selected]."))



/client/proc/robust_dress_shop()
	var/list/baseoutfits = list("Naked", "Custom")
	var/list/outfits = list()
	var/list/paths = subtypesof(/datum/outfit)

	for(var/datum/outfit/O as anything in paths) //not much to initalize here but whatever
		if(IS_ABSTRACT(O))
			continue
		if(initial(O.can_be_admin_equipped))
			outfits += O

	var/dresscode = browser_input_list(src, "Select outfit", "Robust quick dress shop", baseoutfits + sortList(outfits))
	if(isnull(dresscode))
		return

	if(outfits[dresscode])
		dresscode = outfits[dresscode]

	if(dresscode == "Custom")
		var/list/custom_names = list()
		for(var/id in GLOB.custom_outfits)
			var/datum/outfit/D = GLOB.custom_outfits[id]
			if(!D)
				continue
			custom_names[D.name] = D
		var/selected_name = browser_input_list(src, "Select outfit", "Robust quick dress shop", sortList(custom_names))
		dresscode = custom_names[selected_name]
		if(isnull(dresscode))
			return

	return dresscode

/client/proc/cmd_debug_mob_lists()
	set category = "Debug.Debug"
	set name = "Debug Mob Lists"
	set desc = ""

	switch(input("Which list?") in list("Players","Admins","Mobs","Living Mobs","Dead Mobs","Clients","Joined Clients"))
		if("Players")
			to_chat(usr, jointext(GLOB.player_list,","))
		if("Admins")
			to_chat(usr, jointext(GLOB.admins,","))
		if("Mobs")
			to_chat(usr, jointext(GLOB.mob_list,","))
		if("Living Mobs")
			to_chat(usr, jointext(GLOB.alive_mob_list,","))
		if("Dead Mobs")
			to_chat(usr, jointext(GLOB.dead_mob_list,","))
		if("Clients")
			to_chat(usr, jointext(GLOB.clients,","))
		if("Joined Clients")
			to_chat(usr, jointext(GLOB.joined_player_list,","))

/client/proc/cmd_display_del_log()
	set category = "Debug.Debug"
	set name = "Display del() Log"
	set desc = ""

	var/list/dellog = list("<B>List of things that have gone through qdel this round</B><BR><BR><ol>")
	sortTim(SSgarbage.items, cmp = GLOBAL_PROC_REF(cmp_qdel_item_time), associative = TRUE)
	for(var/path in SSgarbage.items)
		var/datum/qdel_item/I = SSgarbage.items[path]
		dellog += "<li><u>[path]</u><ul>"
		if(I.qdel_flags & QDEL_ITEM_SUSPENDED_FOR_LAG)

			dellog += "<li>SUSPENDED FOR LAG</li>"
		if(I.failures)
			dellog += "<li>Failures: [I.failures]</li>"
		dellog += "<li>qdel() Count: [I.qdels]</li>"
		dellog += "<li>Destroy() Cost: [I.destroy_time]ms</li>"
		if(I.hard_deletes)
			dellog += "<li>Total Hard Deletes [I.hard_deletes]</li>"
			dellog += "<li>Time Spent Hard Deleting: [I.hard_delete_time]ms</li>"
			dellog += "<li>Highest Time Spent Hard Deleting: [I.hard_delete_max]ms</li>"
			if (I.hard_deletes_over_threshold)
				dellog += "<li>Hard Deletes Over Threshold: [I.hard_deletes_over_threshold]</li>"
		if(I.slept_destroy)
			dellog += "<li>Sleeps: [I.slept_destroy]</li>"
		if(I.no_respect_force)
			dellog += "<li>Ignored force: [I.no_respect_force]</li>"
		if(I.no_hint)
			dellog += "<li>No hint: [I.no_hint]</li>"
		if(LAZYLEN(I.extra_details))
			var/details = I.extra_details.Join("</li><li>")
			dellog += "<li>Extra Info: <ul><li>[details]</li></ul>"
		dellog += "</ul></li>"

	dellog += "</ol>"

	usr << browse(dellog.Join(), "window=dellog")

/client/proc/cmd_display_overlay_log()
	set category = "Debug.Debug"
	set name = "Display overlay Log"
	set desc = ""

	render_stats(SSoverlays.stats, src)

/client/proc/cmd_display_init_log()
	set category = "Debug.Debug"
	set name = "Display Initialize() Log"
	set desc = ""

	usr << browse(replacetext(SSatoms.InitLog(), "\n", "<br>"), "window=initlog")

/client/proc/debug_huds(i as num)
	set category = "Debug.Debug"
	set name = "Debug HUDs"
	set desc = ""

	if(!holder)
		return
	debug_variables(GLOB.huds[i])

/client/proc/jump_to_ruin()
	set category = "Debug"
	set name = "Jump to Ruin"
	set desc = ""
	if(!holder)
		return
	var/list/names = list()
	for(var/obj/effect/landmark/ruin/ruin_landmark as anything in GLOB.ruin_landmarks)
		var/datum/map_template/ruin/template = ruin_landmark.ruin_template

		var/count = 1
		var/name = template.name
		var/original_name = name

		while(name in names)
			count++
			name = "[original_name] ([count])"

		names[name] = ruin_landmark

	var/ruinname = input("Select ruin", "Jump to Ruin") as null|anything in sortList(names)


	var/obj/effect/landmark/ruin/landmark = names[ruinname]

	if(istype(landmark))
		var/datum/map_template/ruin/template = landmark.ruin_template
		usr.forceMove(get_turf(landmark))
		to_chat(usr, "<span class='name'>[template.name]</span>")
		to_chat(usr, "<span class='italics'>[template.description]</span>")
		//this goes after it's logged, incase something horrible happens.

/client/proc/toggle_medal_disable()
	set category = "Debug"
	set name = "Toggle Medal Disable"
	set desc = ""

	if(!check_rights(R_DEBUG))
		return

	SSachievements.hub_enabled = !SSachievements.hub_enabled

	message_admins("<span class='adminnotice'>[key_name_admin(src)] [SSachievements.hub_enabled ? "disabled" : "enabled"] the medal hub lockout.</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Medal Disable") // If...
	log_admin("[key_name(src)] [SSachievements.hub_enabled ? "disabled" : "enabled"] the medal hub lockout.")

/client/proc/view_runtimes()
	set category = "Debug.Core"
	set name = "View Runtimes"
	set desc = ""

	if(!holder)
		return

	GLOB.error_cache.show_to(src)

/client/proc/pump_random_event()
	set category = "Debug"
	set name = "Pump Random Event"
	set desc = ""
	if(!holder)
		return

	SSevents.scheduled = world.time

	message_admins("<span class='adminnotice'>[key_name_admin(src)] pumped a random event.</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Pump Random Event")
	log_admin("[key_name(src)] pumped a random event.")

/client/proc/start_line_profiling()
	set category = "Debug.Profiler"
	set name = "Start Line Profiling"
	set desc = ""

	LINE_PROFILE_START

	message_admins("<span class='adminnotice'>[key_name_admin(src)] started line by line profiling.</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Start Line Profiling")
	log_admin("[key_name(src)] started line by line profiling.")

/client/proc/stop_line_profiling()
	set category = "Debug.Profiler"
	set name = "Stops Line Profiling"
	set desc = ""

	LINE_PROFILE_STOP

	message_admins("<span class='adminnotice'>[key_name_admin(src)] stopped line by line profiling.</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Stop Line Profiling")
	log_admin("[key_name(src)] stopped line by line profiling.")

/client/proc/show_line_profiling()
	set category = "Debug.Profiler"
	set name = "Show Line Profiling"
	set desc = ""

	var/sortlist = list(
		"Avg time"		=	GLOBAL_PROC_REF(cmp_profile_avg_time_dsc),
		"Total Time"	=	GLOBAL_PROC_REF(cmp_profile_time_dsc),
		"Call Count"	=	GLOBAL_PROC_REF(cmp_profile_count_dsc)
	)
	var/sort = input(src, "Sort type?", "Sort Type", "Avg time") as null|anything in sortlist
	if (!sort)
		return
	sort = sortlist[sort]
	profile_show(src, sort)

/client/proc/reload_configuration()
	set category = "Debug"
	set name = "Reload Configuration"
	set desc = ""
	if(!check_rights(R_DEBUG))
		return
	if(alert(usr, "Are you absolutely sure you want to reload the configuration from the default path on the disk, wiping any in-round modificatoins?", "Really reset?", "No", "Yes") == "Yes")
		config.admin_reload()

/// A debug verb to check the sources of currently running timers
/client/proc/check_timer_sources()
	set category = "Debug"
	set name = "Check Timer Sources"
	set desc = "Checks the sources of the running timers"
	if (!check_rights(R_DEBUG))
		return

	var/bucket_list_output = generate_timer_source_output(SStimer.bucket_list)
	var/second_queue = generate_timer_source_output(SStimer.second_queue)
	var/datum/browser/browser = new(usr, "check_timer_sources", "Timer Sources", 700, 700)
	browser.set_content({"
		<h3>bucket_list</h3>
		[bucket_list_output]

		<h3>second_queue</h3>
		[second_queue]
	"})
	browser.open()

/proc/generate_timer_source_output(list/datum/timedevent/events)
	var/list/per_source = list()

	// Collate all events and figure out what sources are creating the most
	for (var/_event in events)
		if (!_event)
			continue
		var/datum/timedevent/event = _event

		do
			if (event.source)
				if (per_source[event.source] == null)
					per_source[event.source] = 1
				else
					per_source[event.source] += 1
			event = event.next
		while (event && event != _event)

	// Now, sort them in order
	var/list/sorted = list()
	for (var/source in per_source)
		sorted += list(list("source" = source, "count" = per_source[source]))
	sortTim(sorted, GLOBAL_PROC_REF(cmp_timer_data))

	// Now that everything is sorted, compile them into an HTML output
	var/output = "<table border='1'>"

	for (var/_timer_data in sorted)
		var/list/timer_data = _timer_data
		output += {"<tr>
			<td><b>[timer_data["source"]]</b></td>
			<td>[timer_data["count"]]</td>
		</tr>"}

	output += "</table>"

	return output

/proc/cmp_timer_data(list/a, list/b)
	return b["count"] - a["count"]

/client/proc/cmd_regenerate_asset_cache()
	set category = "Debug"
	set name = "Regenerate Asset Cache"
	set desc = "Clears the asset cache and regenerates it immediately."
	if(!CONFIG_GET(flag/cache_assets))
		to_chat(usr, "<span class='warning'>Asset caching is disabled in the config!</span>")
		return
	var/regenerated = 0
	for(var/datum/asset/A as anything in subtypesof(/datum/asset))
		if(!initial(A.cross_round_cachable))
			continue
		if(IS_ABSTRACT(A))
			continue
		var/datum/asset/asset_datum = GLOB.asset_datums[A]
		asset_datum.regenerate()
		regenerated++
	to_chat(usr, "<span class='notice'>Regenerated [regenerated] asset\s.</span>")

/client/proc/cmd_clear_smart_asset_cache()
	set category = "Debug"
	set name = "Clear Smart Asset Cache"
	set desc = "Clears the smart asset cache."
	if(!CONFIG_GET(flag/smart_cache_assets))
		to_chat(usr, "<span class='warning'>Smart asset caching is disabled in the config!</span>")
		return
	var/cleared = 0
	for(var/datum/asset/spritesheet_batched/A as anything in subtypesof(/datum/asset/spritesheet_batched))
		if(IS_ABSTRACT(A))
			continue
		fdel("[ASSET_CROSS_ROUND_SMART_CACHE_DIRECTORY]/spritesheet_cache.[initial(A.name)].json")
		cleared++
	to_chat(usr, "<span class='notice'>Cleared [cleared] asset\s.</span>")

/client/proc/select_job_pack_debug()
	set category = "Debug"
	set name = "Select Jobpack"

	if(!check_rights(R_DEBUG))
		return

	var/pack = browser_input_list(usr, "Select a pack", "Job Packs", GLOB.job_pack_singletons)
	if(!pack)
		return

	var/datum/job_pack/real_pack = GLOB.job_pack_singletons[pack]

	real_pack.pick_pack(usr)
