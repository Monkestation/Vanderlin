#define POPCOUNT_SURVIVORS "survivors"					//Not dead at roundend
#define POPCOUNT_ESCAPEES "escapees"					//Not dead and on centcom/shuttles marked as escaped

/datum/controller/subsystem/ticker/proc/gather_roundend_feedback()
	gather_antag_data()
	var/json_file = file("[GLOB.log_directory]/round_end_data.json")
	var/list/file_data = list("escapees" = list("humans" = list(), "silicons" = list(), "others" = list(), "npcs" = list()), "abandoned" = list("humans" = list(), "silicons" = list(), "others" = list(), "npcs" = list()), "ghosts" = list(), "additional data" = list())
	var/num_survivors = 0
	var/num_escapees = 0
	for(var/mob/m in GLOB.mob_list)
		var/escaped
		var/category
		var/list/mob_data = list()
		if(isnewplayer(m))
			continue
		if(m.mind)
			if(m.stat != DEAD && !isbrain(m) && !iscameramob(m))
				num_survivors++
			mob_data += list("name" = m.name, "ckey" = ckey(m.mind.key))
			if(isobserver(m))
				escaped = "ghosts"
			else if(isliving(m))
				var/mob/living/L = m
				mob_data += list("location" = get_area(L), "health" = L.health)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					category = "humans"
					mob_data += list("job" = H.mind.assigned_role.title, "species" = H.dna.species.name)
			else
				category = "others"
				mob_data += list("typepath" = m.type)
		if(!m.mind && (!ishuman(m)))
			var/list/npc_nest = file_data["[escaped]"]["npcs"]
			if(npc_nest.Find(initial(m.name)))
				file_data["[escaped]"]["npcs"]["[initial(m.name)]"] += 1
			else
				file_data["[escaped]"]["npcs"]["[initial(m.name)]"] = 1
		else
			if(isobserver(m))
				var/pos = length(file_data["[escaped]"]) + 1
				file_data["[escaped]"]["[pos]"] = mob_data
			else
				if(!category)
					category = "others"
					mob_data += list("name" = m.name, "typepath" = m.type)
				var/pos = length(file_data["[escaped]"]["[category]"]) + 1
				file_data["[escaped]"]["[category]"]["[pos]"] = mob_data
	WRITE_FILE(json_file, json_encode(file_data))
	SSblackbox.record_feedback("nested tally", "round_end_stats", num_survivors, list("survivors", "total"))
	SSblackbox.record_feedback("nested tally", "round_end_stats", num_escapees, list("escapees", "total"))
	SSblackbox.record_feedback("nested tally", "round_end_stats", GLOB.joined_player_list.len, list("players", "total"))
	SSblackbox.record_feedback("nested tally", "round_end_stats", GLOB.joined_player_list.len - num_survivors, list("players", "dead"))
	. = list()
	.[POPCOUNT_SURVIVORS] = num_survivors
	.[POPCOUNT_ESCAPEES] = num_escapees

/datum/controller/subsystem/ticker/proc/gather_antag_data()
	var/team_gid = 1
	var/list/team_ids = list()

	for(var/datum/antagonist/A in GLOB.antagonists)
		if(!A.owner)
			continue

		var/list/antag_info = list()
		antag_info["key"] = A.owner.key
		antag_info["name"] = A.owner.name
		antag_info["antagonist_type"] = A.type
		antag_info["antagonist_name"] = A.name //For auto and custom roles
		antag_info["objectives"] = list()
		antag_info["team"] = list()
		var/datum/team/T = A.get_team()
		if(T)
			antag_info["team"]["type"] = T.type
			antag_info["team"]["name"] = T.name
			if(!team_ids[T])
				team_ids[T] = team_gid++
			antag_info["team"]["id"] = team_ids[T]

		if(A.objectives.len)
			for(var/datum/objective/O in A.objectives)
				var/result = O.check_completion() ? "SUCCESS" : "FAIL"
				antag_info["objectives"] += list(list("objective_type"=O.type,"text"=O.explanation_text,"result"=result))
		SSblackbox.record_feedback("associative", "antagonists", 1, antag_info)

/mob/proc/do_game_over()
	if(SSticker.current_state != GAME_STATE_FINISHED)
		return
	status_flags |= GODMODE
	ADD_TRAIT(src, TRAIT_NO_TRANSFORM, ROUNDSTART_TRAIT)
	ai_controller?.set_ai_status(AI_STATUS_OFF)
	if(client)
		add_verb(client, /client/proc/lobbyooc)
		add_verb(client, /client/proc/view_stats)
		client.show_game_over()

/mob/living/do_game_over()
	..()
	adjustEarDamage(0, 6000)
	Stun(6000, 1, 1)
	ADD_TRAIT(src, TRAIT_MUTE, TRAIT_GENERIC)
	walk(src, 0) //stops them mid pathing even if they're stunimmune
	if(client)
		add_verb(client, /client/proc/commendsomeone)

/client/proc/show_game_over()
	var/atom/movable/screen/splash/credits/S = new(null, null, src, FALSE, FALSE)
	S.Fade(FALSE,FALSE)
	RollCredits()

/datum/controller/subsystem/ticker/proc/declare_completion()
	set waitfor = FALSE

	log_game("The round has ended.")

	INVOKE_ASYNC(world, TYPE_PROC_REF(/world, flush_byond_tracy))

	to_chat(world, "<BR><BR><BR><span class='reallybig'>So ends this tale of Vanderlin.</span>")
	get_end_reason()

	var/list/key_list = list()
	for(var/client/C in GLOB.clients)
		if(C.mob)
			C.mob.cancel_looping_ambience()
			C.mob.playsound_local(C.mob, 'sound/misc/roundend.ogg', 100, FALSE)
		if(isliving(C.mob) && C.ckey)
			key_list += C.ckey

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat != DEAD)
			if(H.get_triumphs() < 0)
				H.adjust_triumphs(1)

	add_roundplayed(key_list)

	update_god_rankings()

	for(var/mob/M in GLOB.mob_list)
		M.do_game_over()
		M.playsound_local(M, 'sound/music/credits.ogg', 100, FALSE)

	for(var/datum/callback/cb as anything in round_end_events)
		cb.InvokeAsync()
	LAZYCLEARLIST(round_end_events)

	to_chat(world, "Round ID: [GLOB.rogue_round_id]")

	sleep(5 SECONDS)

	//TODO: use build_roundend_report()

	gamemode_report()

	sleep(8 SECONDS)

	var/datum/triumph_buy/communal/psydon_retirement_fund/fund = locate() in SStriumphs.triumph_buy_datums
	if(fund && SStriumphs.communal_pools[fund.type] > 0)
		fund.on_activate()

	sleep(6 SECONDS)

	players_report()

	SSvote.initiate_vote("map", "Psydon")

	CHECK_TICK

	SSgamemode.store_roundend_data()

	CHECK_TICK

	//These need update to actually reflect the real antagonists
	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/antagonist/A in GLOB.antagonists)
		if(!A.owner)
			continue
		if(!(A.name in total_antagonists))
			total_antagonists[A.name] = list()
		total_antagonists[A.name] += "[key_name(A.owner)]"

	CHECK_TICK

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/antag_name in total_antagonists)
		var/list/L = total_antagonists[antag_name]
		log_game("[antag_name]s :[L.Join(", ")].")

	CHECK_TICK
	SSdbcore.SetRoundEnd()
	SSpersistence.CollectData()

	//stop collecting feedback during grifftime
	SSblackbox.Seal()

	sleep(10 SECONDS)
	ready_for_reboot = TRUE
	SSplexora.roundended()
	standard_reboot()

/datum/controller/subsystem/ticker/proc/get_end_reason()
	var/end_reason

	if(!check_for_lord(TRUE)) //TRUE forces the check, otherwise it will autofail.
		end_reason = pick("Without a Monarch, the forces of Zizo grew ever bolder.",
						"Without a Monarch, the settlement fell into turmoil.",
						"Without a Monarch, some jealous rival reigned in tyranny.")

	if(vampire_werewolf() == "vampire")
		end_reason = "When the Vampires finished sucking the town dry, they moved on to the next one."
	if(vampire_werewolf() == "werewolf")
		end_reason = "The Werevolves formed an unholy clan, marauding Rockhill until the end of its daes."

	if(SSmapping.retainer.cult_ascended)
		end_reason = "ZIZOZIZOZIZOZIZO"

	if(SSmapping.retainer.head_rebel_decree)
		end_reason = "The peasant rebels took control of the throne, hail the new community!"


	if(end_reason)
		to_chat(world, "<span class='big bold'>[end_reason].</span>")
	else
		to_chat(world, "<span class='big bold'>The town has managed to survive another week.</span>")

/datum/controller/subsystem/ticker/proc/gamemode_report()
	//TODO: This is a copypaste of antag_report(), this should be deleted
	var/list/all_teams = list()
	var/list/all_antagonists = list()

	var/list/header_parts
	if(GLOB.antagonist_teams.len || GLOB.antagonists.len)
		header_parts += "<br>"
		header_parts += "<div style='text-align: center; font-size: 1.2em;'>VILLAINS:</div>"
		header_parts += "<hr class='paneldivider'>"
		to_chat(world, header_parts)

	for(var/datum/team/A in GLOB.antagonist_teams)
		all_teams |= A

	for(var/datum/antagonist/A in GLOB.antagonists)
		if(!A.owner)
			continue
		all_antagonists |= A

	for(var/datum/team/T in all_teams)
		//check if we should show the team
		if(!T.show_roundend_report)
			continue

		for(var/datum/mind/member_mind as anything in T.members)
			if(!isnull(member_mind.antag_datums))
				all_antagonists -= member_mind.antag_datums

		to_chat(world, T.roundend_report())
		CHECK_TICK

	var/currrent_category
	var/datum/antagonist/previous_category

	sortTim(all_antagonists, GLOBAL_PROC_REF(cmp_antag_category))

	for(var/datum/antagonist/A in all_antagonists)
		if(!A.show_in_roundend)
			continue
		if(A.roundend_category != currrent_category)
			if(previous_category)
				previous_category.roundend_report_footer()
			A.roundend_report_header()
			currrent_category = A.roundend_category
			previous_category = A
		A.roundend_report()

		CHECK_TICK

	if(all_antagonists.len)
		var/datum/antagonist/last = all_antagonists[all_antagonists.len]
		if(last.show_in_roundend)
			last.roundend_report_footer()

	to_chat(world, personal_objectives_report())

/datum/controller/subsystem/ticker/proc/standard_reboot()
	if(ready_for_reboot)
		Reboot("Round ended.", "proper completion")
	else
		CRASH("Attempted standard reboot without ticker roundend completion")

//Common part of the report
/datum/controller/subsystem/ticker/proc/build_roundend_report()
	var/list/parts = list()

	CHECK_TICK

	//Antagonists
	parts += antag_report()

	CHECK_TICK

	//Personal objectives
	parts += personal_objectives_report()

	CHECK_TICK
	//Medals
	parts += medal_report()

	listclearnulls(parts)

	return parts.Join()

/datum/controller/subsystem/ticker/proc/survivor_report(popcount)
	var/list/parts = list()

	if(GLOB.round_id)
		var/statspage = CONFIG_GET(string/roundstatsurl)
		var/info = statspage ? "<a href='?action=openLink&link=[url_encode(statspage)][GLOB.round_id]'>[GLOB.round_id]</a>" : GLOB.round_id
		parts += "[FOURSPACES]Round ID: <b>[info]</b>"
	parts += "[FOURSPACES]Shift Duration: <B>[DisplayTimeText(world.time - SSticker.round_start_time)]</B>"
	var/total_players = GLOB.joined_player_list.len
	if(total_players)
		parts+= "[FOURSPACES]Total Population: <B>[total_players]</B>"
		parts += "[FOURSPACES]Survival Rate: <B>[popcount[POPCOUNT_SURVIVORS]] ([PERCENT(popcount[POPCOUNT_SURVIVORS]/total_players)]%)</B>"
		if(SSblackbox.first_death)
			var/list/ded = SSblackbox.first_death
			if(ded.len)
				parts += "[FOURSPACES]First Death: <b>[ded["name"]], [ded["role"]], at [ded["area"]]. Damage taken: [ded["damage"]].[ded["last_words"] ? " Their last words were: \"[ded["last_words"]]\"" : ""]</b>"
			//ignore this comment, it fixes the broken sytax parsing caused by the " above
			else
				parts += "[FOURSPACES]<i>Nobody died this shift!</i>"
	return parts.Join("<br>")

/client/proc/roundend_report_file()
	return "data/roundend_reports/[ckey].html"

/datum/controller/subsystem/ticker/proc/show_roundend_report(client/C, previous = FALSE)
	var/datum/browser/roundend_report = new(C, "roundend")
	roundend_report.width = 800
	roundend_report.height = 600
	var/content
	var/filename = C.roundend_report_file()
	if(!previous)
		var/list/report_parts = list(personal_report(C), GLOB.common_report)
		content = report_parts.Join()
		remove_verb(C, /client/proc/show_previous_roundend_report)
		fdel(filename)
		text2file(content, filename)
	else
		content = file2text(filename)
	roundend_report.set_content(content)
//	roundend_report.add_stylesheet("roundend", 'html/browser/roundend.css')
//	roundend_report.add_stylesheet("font-awesome", 'html/font-awesome/css/all.min.css')
	roundend_report.open(FALSE)

/datum/controller/subsystem/ticker/proc/personal_report(client/C, popcount)
	var/list/parts = list()
	var/mob/M = C.mob
	if(M.mind && !isnewplayer(M))
		if(M.stat != DEAD && !isbrain(M))
			parts += "<div class='panel greenborder'>"
			parts += "<span class='greentext'>I managed to survive the events on [station_name()] as [M.real_name].</span>"

		else
			parts += "<div class='panel redborder'>"
			parts += "<span class='redtext'>I did not survive the events on [station_name()]...</span>"
	else
		parts += "<div class='panel stationborder'>"
	parts += "<br>"
	parts += GLOB.survivor_report
	parts += "</div>"

	return parts.Join()

/datum/controller/subsystem/ticker/proc/players_report()
	reward_notables()
	for(var/client/C in GLOB.clients)
		give_show_playerlist_button(C)

/datum/controller/subsystem/ticker/proc/reward_notables()
	var/list/notable_minds = list()

	for(var/stat_type in SSgamemode.chosen_chronicle_stats)
		var/list/stat_data = GLOB.chronicle_stats[stat_type]
		if(!stat_data)
			continue

		var/datum/weakref/holder_ref = stat_data["holder"]
		var/mob/living/carbon/human/notable = holder_ref?.resolve()
		if(!notable.client || !notable.mind || notable.stat == DEAD)
			continue

		if(!notable_minds[notable.mind])
			notable_minds[notable.mind] = list()

		notable_minds[notable.mind] += stat_data["title"]

	if(length(notable_minds) > 0)
		var/list/shuffled_minds = shuffle(notable_minds)
		var/recipients_given = 0

		for(var/datum/mind/selected_mind as anything in shuffled_minds)
			if(recipients_given >= MAX_CHRONICLE_STATS)
				break

			var/list/titles = notable_minds[selected_mind]
			var/reason = "Being a notable person ([english_list(titles)])"
			selected_mind.adjust_triumphs(1, TRUE, reason)
			to_chat(selected_mind, "<br>")
			recipients_given++

/datum/controller/subsystem/ticker/proc/display_report(popcount)
	GLOB.common_report = build_roundend_report()
	GLOB.survivor_report = survivor_report(popcount)
	for(var/client/C in GLOB.clients)
		show_roundend_report(C, FALSE)
		give_show_report_button(C)
		CHECK_TICK

/datum/controller/subsystem/ticker/proc/medal_report()
	if(GLOB.commendations.len)
		var/list/parts = list()
		parts += "<span class='header'>Medal Commendations:</span>"
		for (var/com in GLOB.commendations)
			parts += com
		return "<div class='panel stationborder'>[parts.Join("<br>")]</div>"
	return ""

/datum/controller/subsystem/ticker/proc/personal_objectives_report()
	var/list/parts = list()
	var/failed_chosen = 0
	var/has_any_objectives = FALSE
	var/showed_any_champions = FALSE

	// Header
	parts += "<div class='panel stationborder'>"
	if(GLOB.personal_objective_minds.len)
		parts += "<div style='text-align: center; font-size: 1.2em;'>HEROES:</div>"
		parts += "<hr class='paneldivider'>"

	var/list/successful_champions = list()
	for(var/datum/mind/mind as anything in GLOB.personal_objective_minds)
		if(!mind.personal_objectives || !mind.personal_objectives.len)
			continue

		has_any_objectives = TRUE
		var/any_success = FALSE
		for(var/datum/objective/personal/objective as anything in mind.personal_objectives)
			if(objective.check_completion())
				any_success = TRUE
				break

		if(any_success)
			successful_champions += mind
		else
			failed_chosen++

	var/last_index = length(successful_champions)
	var/current_index = 0
	for(var/datum/mind/mind as anything in successful_champions)
		current_index++
		showed_any_champions = TRUE
		var/name_with_title = mind.current ? printplayer(mind) : "<b>Unknown Hero</b>"
		parts += name_with_title

		var/obj_count = 1
		for(var/datum/objective/personal/objective as anything in mind.personal_objectives)
			var/result = objective.check_completion() ? span_greentext("TRIUMPH!") : span_redtext("FAIL")
			parts += "<B>Goal #[obj_count]</B>: [objective.explanation_text] - [result]"
			obj_count++

		if(current_index < last_index)
			parts += "<br>"
		CHECK_TICK

	if(!has_any_objectives)
		parts += "<div style='text-align: center;'>No heroes were chosen this round</div>"
	else if(failed_chosen > 0)
		if(showed_any_champions)
			parts += "<br>"
		parts += "<div style='text-align: center;'>[failed_chosen] [failed_chosen == 1 ? "hero" : "heroes"] [failed_chosen == 1 ? "has" : "have"] failed to complete their calling.</div>"

	parts += "</div>"
	return parts.Join("<br>")

/datum/controller/subsystem/ticker/proc/antag_report()
	var/list/result = list()
	var/list/all_teams = list()
	var/list/all_antagonists = list()

	for(var/datum/team/team as anything in GLOB.antagonist_teams)
		all_teams |= team

	for(var/datum/antagonist/antagonist as anything in GLOB.antagonists)
		if(!antagonist.owner)
			continue
		all_antagonists |= antagonist

	for(var/datum/team/active_team as anything in all_teams)
		//check if we should show the team
		if(!active_team.show_roundend_report)
			continue

		for(var/datum/mind/member_mind as anything in active_team.members)
			if(!isnull(member_mind.antag_datums))
				all_antagonists -= member_mind.antag_datums

		result += active_team.roundend_report()
		result += " "//newline between teams
		CHECK_TICK

	var/currrent_category
	var/datum/antagonist/previous_category

	sortTim(all_antagonists, GLOBAL_PROC_REF(cmp_antag_category))

	for(var/datum/antagonist/antagonist as anything in all_antagonists)
		if(antagonist.show_in_roundend)
			continue
		if(antagonist.roundend_category != currrent_category)
			if(previous_category)
				result += previous_category.roundend_report_footer()
				result += "</div>"
			result += "<div class='panel redborder'>"
			result += antagonist.roundend_report_header()
			currrent_category = antagonist.roundend_category
			previous_category = antagonist
		result += antagonist.roundend_report()
		result += "<br>"
		CHECK_TICK

	if(all_antagonists.len)
		var/datum/antagonist/last = all_antagonists[all_antagonists.len]
		result += last.roundend_report_footer()
		result += "</div>"

	return result.Join()

/proc/cmp_antag_category(datum/antagonist/A,datum/antagonist/B)
	return sorttext(B.roundend_category,A.roundend_category)

/datum/controller/subsystem/ticker/proc/give_show_report_button(client/C)
	var/datum/action/report/R = new
	C.player_details.player_actions += R
	R.Grant(C.mob)
	to_chat(C,"<a href='byond://?src=[REF(R)];report=1'>Show roundend report again</a>")

/datum/controller/subsystem/ticker/proc/give_show_playerlist_button(client/C)
	set waitfor = 0
	to_chat(C,"<a href='byond://?src=[C];playerlist=1'>* SHOW PLAYER LIST *</a>")
	to_chat(C,"<a href='byond://?src=[C];commendsomeone=1'>* Commend a Character *</a>")
	to_chat(C,"<a href='byond://?src=[C];viewstats=1'>* View Statistics *</a>")
	C.show_round_stats(pick_assoc(GLOB.featured_stats))
	C.commendation_popup()

/datum/action/report
	name = "Show roundend report"
	button_icon_state = "round_end"

/datum/action/report/Trigger(trigger_flags)
	if(owner && GLOB.common_report && SSticker.current_state == GAME_STATE_FINISHED)
		SSticker.show_roundend_report(owner.client, FALSE)

/datum/action/report/IsAvailable()
	return 1

/datum/action/report/Topic(href,href_list)
	if(usr != owner)
		return
	if(href_list["report"])
		Trigger()
		return

/proc/printplayer(datum/mind/ply, fleecheck)
	var/jobtext = ""
	if(ply.special_role)
		jobtext = " the <b>[ply.special_role]</b>"
	else if(ply.assigned_role && ply.current)
		jobtext = " the <b>[ply.assigned_role.get_informed_title(ply.current)]</b>"
	var/usede = get_display_ckey(ply.key)
	var/text = "<b>[usede]</b> was <b>[ply.name]</b>[jobtext] and"
	if(ply.current)
		if(ply.current.stat == DEAD)
			text += span_redtext(" died.")
		else
			text += span_greentext(" survived.")
	else
		text += span_redtext(" died.")
	return text

/proc/printplayerlist(list/datum/mind/players,fleecheck)
	var/list/parts = list()

	//parts += "<ul class='playerlist'>"
	for(var/datum/mind/M in players)
		parts += printplayer(M,fleecheck)//"<li>[printplayer(M,fleecheck)]</li>"
	//parts += "</ul>"
	return parts.Join()


/proc/printobjectives(list/objectives)
	if(!objectives || !objectives.len)
		return
	var/list/objective_parts = list()
	var/count = 1
	for(var/datum/objective/objective in objectives)
		if(objective.check_completion())
			objective_parts += "<b>[objective.flavor] #[count]</b>: [objective.explanation_text] <span class='greentext'>Success!</span>"
		else
			objective_parts += "<b>[objective.flavor] #[count]</b>: [objective.explanation_text] <span class='redtext'>Fail.</span>"
		count++
	return objective_parts.Join("<br>")

/datum/controller/subsystem/ticker/proc/save_admin_data()
	if(IsAdminAdvancedProcCall())
		to_chat(usr, "<span class='admin prefix'>Admin rank DB Sync blocked: Advanced ProcCall detected.</span>")
		return
	if(CONFIG_GET(flag/admin_legacy_system)) //we're already using legacy system so there's nothing to save
		return
	else if(load_admins(TRUE)) //returns true if there was a database failure and the backup was loaded from
		return
	sync_ranks_with_db()
	var/list/sql_admins = list()
	for(var/i in GLOB.protected_admins)
		var/datum/admins/A = GLOB.protected_admins[i]
		sql_admins += list(list("ckey" = A.target, "rank" = A.rank.name))
	SSdbcore.MassInsert(format_table_name("admin"), sql_admins, duplicate_key = TRUE)
	var/datum/DBQuery/query_admin_rank_update = SSdbcore.NewQuery("UPDATE [format_table_name("player")] p INNER JOIN [format_table_name("admin")] a ON p.ckey = a.ckey SET p.lastadminrank = a.rank")
	query_admin_rank_update.Execute()
	qdel(query_admin_rank_update)

	//json format backup file generation stored per server
	var/json_file = file("data/admins_backup.json")
	var/list/file_data = list("ranks" = list(), "admins" = list())
	for(var/datum/admin_rank/R in GLOB.admin_ranks)
		file_data["ranks"]["[R.name]"] = list()
		file_data["ranks"]["[R.name]"]["include rights"] = R.include_rights
		file_data["ranks"]["[R.name]"]["exclude rights"] = R.exclude_rights
		file_data["ranks"]["[R.name]"]["can edit rights"] = R.can_edit_rights
	for(var/i in GLOB.admin_datums+GLOB.deadmins)
		var/datum/admins/A = GLOB.admin_datums[i]
		if(!A)
			A = GLOB.deadmins[i]
			if (!A)
				continue
		file_data["admins"]["[i]"] = A.rank.name
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/ticker/proc/update_everything_flag_in_db()
	for(var/datum/admin_rank/R in GLOB.admin_ranks)
		var/list/flags = list()
		if(R.include_rights == R_EVERYTHING)
			flags += "flags"
		if(R.exclude_rights == R_EVERYTHING)
			flags += "exclude_flags"
		if(R.can_edit_rights == R_EVERYTHING)
			flags += "can_edit_flags"
		if(!flags.len)
			continue
		var/flags_to_check = flags.Join(" != [R_EVERYTHING] AND ") + " != [R_EVERYTHING]"
		var/datum/DBQuery/query_check_everything_ranks = SSdbcore.NewQuery(
			"SELECT flags, exclude_flags, can_edit_flags FROM [format_table_name("admin_ranks")] WHERE rank = :rank AND ([flags_to_check])",
			list("rank" = R.name)
		)
		if(!query_check_everything_ranks.Execute())
			qdel(query_check_everything_ranks)
			return
		if(query_check_everything_ranks.NextRow()) //no row is returned if the rank already has the correct flag value
			var/flags_to_update = flags.Join(" = [R_EVERYTHING], ") + " = [R_EVERYTHING]"
			var/datum/DBQuery/query_update_everything_ranks = SSdbcore.NewQuery(
				"UPDATE [format_table_name("admin_ranks")] SET [flags_to_update] WHERE rank = :rank",
				list("rank" = R.name)
			)
			if(!query_update_everything_ranks.Execute())
				qdel(query_update_everything_ranks)
				return
			qdel(query_update_everything_ranks)
		qdel(query_check_everything_ranks)
