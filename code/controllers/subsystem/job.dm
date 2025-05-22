SUBSYSTEM_DEF(job)
	name = "Jobs"
	init_order = INIT_ORDER_JOBS
	flags = SS_NO_FIRE

	/// List of all jobs.
	var/list/all_occupations = list()
	/// List of jobs that can be joined through the starting menu.
	var/list/joinable_occupations = list()
	var/list/datum/job/name_occupations = list()	//Dict of all jobs, keys are titles
	var/list/type_occupations = list()	//Dict of all jobs, keys are types
	var/list/unassigned = list()		//Players who need jobs
	var/initial_players_to_assign = 0 	//used for checking against population caps

	var/list/prioritized_jobs = list()
	var/list/latejoin_trackers = list()

	var/list/level_order = list(JP_HIGH,JP_MEDIUM,JP_LOW)

/datum/controller/subsystem/job/Initialize(timeofday)
	if(!length(all_occupations))
		SetupOccupations()
	return ..()

/datum/controller/subsystem/job/proc/SetupOccupations()
	all_occupations = list()
	joinable_occupations = list()
	var/list/all_jobs = subtypesof(/datum/job)
	if(!length(all_jobs))
		to_chat(world, span_boldannounce("Error setting up jobs, no job datums found."))
		to_chat(world, span_boldannounce("You should start panicking."))
		return FALSE

	for(var/job_type in all_jobs)
		var/datum/job/job = new job_type()
		all_occupations += job
		name_occupations[job.title] = job
		type_occupations[job_type] = job
		if(job.job_flags & JOB_NEW_PLAYER_JOINABLE)
			joinable_occupations += job

	if(SSmapping.map_adjustment)
		SSmapping.map_adjustment.job_change()
	return TRUE

/datum/controller/subsystem/job/proc/GetJob(rank)
	if(!length(all_occupations))
		SetupOccupations()
	return name_occupations[rank]

/datum/controller/subsystem/job/proc/GetJobType(jobtype)
	if(!length(all_occupations))
		SetupOccupations()
	return type_occupations[jobtype]

/datum/controller/subsystem/job/proc/AssignRole(mob/dead/new_player/player, datum/job/job, latejoin = FALSE)
	JobDebug("Running AR, Player: [player], Rank: [job?.type || "null"], LJ: [latejoin]")
	if(!player || !player.mind || !job)
		JobDebug("AR has failed, Player: [player], Rank: [job.get_informed_title(player)]")
		return FALSE
	if(is_banned_from(player.ckey, job.title) || QDELETED(player))
		return FALSE
	if(!job.player_old_enough(player.client))
		return FALSE
	if(job.required_playtime_remaining(player.client))
		return FALSE
	var/position_limit = job.total_positions
	if(!latejoin)
		position_limit = job.spawn_positions
	JobDebug("Player: [player] is now Rank: [job.get_informed_title(player)], JCP:[job.current_positions], JPL:[position_limit]")
	player.mind.set_assigned_role(job)
	unassigned -= player
	job.adjust_current_positions(1)
	. = TRUE //V:

	if(!latejoin)
		if(player.client)
			if(job.bypass_lastclass)
				player.client.prefs.lastclass = null
			else
				player.client.prefs.lastclass = job.title
			player.client.prefs.save_preferences()
	else
		if(player.client)
			player.client.prefs.lastclass = null
			player.client.prefs.save_preferences()
	if(player.client && player.client.prefs)
		player.client.prefs.has_spawned = TRUE

/datum/controller/subsystem/job/proc/FindOccupationCandidates(datum/job/job, level, flag)
	JobDebug("Running FOC, Job: [job], Level: [level], Flag: [flag]")
	var/list/candidates = list()
	for(var/mob/dead/new_player/player in unassigned)
		if(is_role_banned(player.ckey, job.title) || QDELETED(player))
			JobDebug("FOC isbanned failed, Player: [player]")
			continue
		if(!job.player_old_enough(player.client))
			JobDebug("FOC player not old enough, Player: [player]")
			continue
		if(job.required_playtime_remaining(player.client))
			JobDebug("FOC player not enough xp, Player: [player]")
			continue
		if(flag && (!(flag in player.client.prefs.be_special)))
			JobDebug("FOC flag failed, Player: [player], Flag: [flag], ")
			continue
		if(player.mind && (job.title in player.mind.restricted_roles))
			JobDebug("FOC incompatible with antagonist role, Player: [player]")
			continue
		if(length(job.allowed_races) && !(player.client.prefs.pref_species.name in job.allowed_races))
			if(!(player.client.triumph_ids.Find("race_all")))
				JobDebug("FOC incompatible with species, Player: [player], Job: [job.title], Race: [player.client.prefs.pref_species.name]")
				continue
		if(length(job.allowed_patrons) && !(player.client.prefs.selected_patron.type in job.allowed_patrons))
			JobDebug("FOC incompatible with patron, Player: [player], Job: [job.title], Race: [player.client.prefs.pref_species.name]")
			continue
		if(get_playerquality(player.ckey) < job.min_pq)
			continue
		if(length(job.allowed_sexes) && !(player.client.prefs.gender in job.allowed_sexes))
			JobDebug("FOC incompatible with sex, Player: [player], Job: [job.title]")
			continue
		if(length(job.allowed_ages) && !(player.client.prefs.age in job.allowed_ages))
			JobDebug("FOC incompatible with age, Player: [player], Job: [job.title], Age: [player.client.prefs.age]")
			continue
		if(job.banned_leprosy && is_misc_banned(player.client.ckey, BAN_MISC_LEPROSY))
			JobDebug("FOC incompatible with leprosy, Player: [player], Job: [job.title]")
			continue
		if(job.banned_lunatic && is_misc_banned(player.client.ckey, BAN_MISC_LUNATIC))
			JobDebug("FOC incompatible with lunatic, Player: [player], Job: [job.title]")
			continue
		if((player.client.prefs.lastclass == job.title) && !job.bypass_lastclass)
			JobDebug("FOC incompatible with lastclass, Player: [player], Job: [job.title]")
			continue
		if(!job.special_job_check(player))
			JobDebug("FOC player did not pass special check, Player: [player], Job:[job.title]")
			continue
		if(CONFIG_GET(flag/usewhitelist))
			if(job.whitelist_req && (!player.client.whitelisted()))
				continue
		if(player.client.prefs.job_preferences[job.title] == level)
			JobDebug("FOC pass, Player: [player], Level:[level]")
			candidates += player
	return candidates

/datum/controller/subsystem/job/proc/GiveRandomJob(mob/dead/new_player/player)
	JobDebug("GRJ Giving random job, Player: [player]")
	. = FALSE
	for(var/datum/job/job as anything in shuffle(joinable_occupations))
		if(job.title in GLOB.noble_positions) //If you want a command position, select it!
			continue

		if(is_role_banned(player.ckey, job.title) || QDELETED(player))
			if(QDELETED(player))
				JobDebug("GRJ isbanned failed, Player deleted")
				break
			JobDebug("GRJ isbanned failed, Player: [player], Job: [job.title]")
			continue

		if(!job.can_random)
			JobDebug("GRJ can't random into this job, Job: [job.title], Player: [player]")
			continue

		if(!job.player_old_enough(player.client))
			JobDebug("GRJ player not old enough, Player: [player]")
			continue

		if(job.required_playtime_remaining(player.client))
			JobDebug("GRJ player not enough xp, Player: [player]")
			continue

		if(player.mind && (job.title in player.mind.restricted_roles))
			JobDebug("GRJ incompatible with antagonist role, Player: [player], Job: [job.title]")
			continue

		if(length(job.allowed_races) && !(player.client.prefs.pref_species.name in job.allowed_races))
			JobDebug("GRJ incompatible with species, Player: [player], Job: [job.title], Race: [player.client.prefs.pref_species.name]")
			continue

		if(length(job.allowed_patrons) && !(player.client.prefs.selected_patron.type in job.allowed_patrons))
			JobDebug("GRJ incompatible with patron, Player: [player], Job: [job.title], Race: [player.client.prefs.pref_species.name]")
			continue

		if(get_playerquality(player.ckey) < job.min_pq)
			continue

		if(length(job.allowed_ages) && !(player.client.prefs.age in job.allowed_ages))
			JobDebug("GRJ incompatible with age, Player: [player], Job: [job.title], Race: [player.client.prefs.pref_species.name]")
			continue

		if(length(job.allowed_sexes) && !(player.client.prefs.gender in job.allowed_sexes))
			JobDebug("GRJ incompatible with sex, Player: [player], Job: [job.title]")
			continue

		if(get_playerquality(player.ckey) < job.min_pq)
			JobDebug("GRJ incompatible with minPQ, Player: [player], Job: [job.title]")
			continue

		if(job.banned_leprosy && is_misc_banned(player.client.ckey, BAN_MISC_LEPROSY))
			JobDebug("GRJ incompatible with leprosy, Player: [player], Job: [job.title]")
			continue

		if(job.banned_lunatic && is_misc_banned(player.client.ckey, BAN_MISC_LUNATIC))
			JobDebug("GRJ incompatible with lunatic, Player: [player], Job: [job.title]")
			continue

		if(!job.special_job_check(player))
			JobDebug("GRJ player did not pass special check, Player: [player], Job:[job.title]")
			continue

		if(CONFIG_GET(flag/usewhitelist))
			if(job.whitelist_req && (!player.client.whitelisted()))
				continue

		if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
			JobDebug("GRJ Random job given, Player: [player], Job: [job]")
			if(AssignRole(player, job))
				return TRUE

/datum/controller/subsystem/job/proc/ResetOccupations()
	JobDebug("Occupations reset.")
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(!player?.mind)
			continue
		player.mind.set_assigned_role(/datum/job/unassigned)
		player.mind.special_role = null
		player.mind.job_bitflag = NONE
		SSpersistence.antag_rep_change[player.ckey] = 0
	SetupOccupations()
	unassigned = list()
	return


//This proc is called before the level loop of DivideOccupations() and will try to select a head, ignoring ALL non-head preferences for every level until
//it locates a head or runs out of levels to check
//This is basically to ensure that there's atleast a few heads in the round
/datum/controller/subsystem/job/proc/FillHeadPosition()
	for(var/level in level_order)
		for(var/noble_position in GLOB.noble_positions)
			var/datum/job/job = GetJob(noble_position)
			if(!job)
				continue
			if(job.current_positions >= job.spawn_positions)
				continue
			var/list/candidates = FindOccupationCandidates(job, level)
			if(!candidates.len)
				continue
			var/mob/dead/new_player/candidate = pick(candidates)
			if(AssignRole(candidate, job))
				return TRUE
	return FALSE


//This proc is called at the start of the level loop of DivideOccupations() and will cause head jobs to be checked before any other jobs of the same level
//This is also to ensure we get as many heads as possible
/datum/controller/subsystem/job/proc/CheckHeadPositions(level)
	for(var/noble_position in GLOB.noble_positions)
		var/datum/job/job = GetJob(noble_position)
		if(!job)
			continue
		if(job.current_positions >= job.spawn_positions)
			continue
		var/list/candidates = FindOccupationCandidates(job, level)
		if(!candidates.len)
			continue
		var/mob/dead/new_player/candidate = pick(candidates)
		AssignRole(candidate, job)

/datum/controller/subsystem/job/proc/sort_male_female(inputlist)
	if(!inputlist)
		return null
	var/list/putty = inputlist
	var/list/newlist = list()
	for(var/mob/dead/new_player/player in putty)
		if(player.client.prefs.gender == MALE)
			newlist += player
			putty -= player
	for(var/mob/dead/new_player/player in putty)
		if(player.client.prefs.gender == FEMALE)
			newlist += player
			putty -= player
	return newlist

/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
/datum/controller/subsystem/job/proc/DivideOccupations(list/required_jobs)
	//Setup new player list and get the jobs list
	JobDebug("Running DO")

	//Get the players who are ready
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY && player.check_preferences() && player.mind && is_unassigned_job(player.mind.assigned_role))
			unassigned += player

	initial_players_to_assign = unassigned.len

	JobDebug("DO, Len: [unassigned.len]")
	if(unassigned.len == 0)
		return validate_required_jobs(required_jobs)

	//Jobs will have fewer access permissions if the number of players exceeds the threshold defined in game_options.txt
	var/mat = CONFIG_GET(number/minimal_access_threshold)
	if(mat)
		if(mat > unassigned.len)
			CONFIG_SET(flag/jobs_have_minimal_access, FALSE)
		else
			CONFIG_SET(flag/jobs_have_minimal_access, TRUE)

	//Shuffle players and jobs
	unassigned = shuffle(unassigned)

	HandleFeedbackGathering()


	//Select one head
	JobDebug("DO, Running Head Check")
	do_required_jobs()
	JobDebug("DO, Head Check end")

	//Other jobs are now checked
	JobDebug("DO, Running Standard Check")


	// New job giving system by Donkie
	// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
	// Hopefully this will add more randomness and fairness to job giving.

	// Loop through all levels from high to low
	var/list/shuffledoccupations = shuffle(joinable_occupations)
	for(var/level in level_order)
		//Check the head jobs first each level
		//CheckHeadPositions(level)

		// Loop through all unassigned players
		for(var/mob/dead/new_player/player in unassigned)
			if(PopcapReached())
				RejectPlayer(player)

			// Loop through all jobs
			for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
				if(!job)
					continue

				if(is_role_banned(player.ckey, job.title))
					JobDebug("DO isbanned failed, Player: [player], Job:[job.title]")
					continue

				if(QDELETED(player))
					JobDebug("DO player deleted during job ban check")
					break

				if(!job.player_old_enough(player.client))
					JobDebug("DO player not old enough, Player: [player], Job:[job.title]")
					continue

				if(job.required_playtime_remaining(player.client))
					JobDebug("DO player not enough xp, Player: [player], Job:[job.title]")
					continue

				if(player.mind && (job.title in player.mind.restricted_roles))
					JobDebug("DO incompatible with antagonist role, Player: [player], Job:[job.title]")
					continue

				if(length(job.allowed_races) && !(player.client.prefs.pref_species.name in job.allowed_races))
					if(!(player.client.triumph_ids.Find("race_all")))
						JobDebug("DO incompatible with species, Player: [player], Job: [job.title], Race: [player.client.prefs.pref_species.name]")
						continue

				if(length(job.allowed_patrons) && !(player.client.prefs.selected_patron.type in job.allowed_patrons))
					JobDebug("DO incompatible with patron, Player: [player], Job: [job.title], Race: [player.client.prefs.pref_species.name]")
					continue

				if(get_playerquality(player.ckey) < job.min_pq)
					JobDebug("DO player lacks Quality. Player: [player], Job: [job.title]")
					continue

				if((player.client.prefs.lastclass == job.title) && (!job.bypass_lastclass))
					JobDebug("DO player already played class, Player: [player], Job: [job.title]")
					continue

				if(job.banned_leprosy && is_misc_banned(player.client.ckey, BAN_MISC_LEPROSY))
					JobDebug("DO incompatible with leprosy, Player: [player], Job: [job.title]")
					continue

				if(job.banned_lunatic && is_misc_banned(player.client.ckey, BAN_MISC_LUNATIC))
					JobDebug("DO incompatible with lunatic, Player: [player], Job: [job.title]")
					continue

				if(CONFIG_GET(flag/usewhitelist))
					if(job.whitelist_req && (!player.client.whitelisted()))
						continue

				if(length(job.allowed_ages) && !(player.client.prefs.age in job.allowed_ages))
					JobDebug("DO incompatible with age, Player: [player], Job: [job.title]")
					continue

				if(length(job.allowed_sexes) && !(player.client.prefs.gender in job.allowed_sexes))
					JobDebug("DO incompatible with gender preference, Player: [player], Job: [job.title]")
					continue

				if(!job.special_job_check(player))
					JobDebug("DO player did not pass special check, Player: [player], Job:[job.title]")
					continue

				// If the player wants that job on this level, then try give it to him.
				if(player.client.prefs.job_preferences[job.title] == level)
					// If the job isn't filled
					if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
						AssignRole(player, job)
						unassigned -= player
						break


	JobDebug("DO, Handling unassigned.")
	// Hand out random jobs to the people who didn't get any in the last check
	// Also makes sure that they got their preference correct
	for(var/mob/dead/new_player/player in unassigned)
		HandleUnassigned(player)

	JobDebug("DO, Handling unrejectable unassigned")
	//Mop up people who can't leave.
	for(var/mob/dead/new_player/player in unassigned) //Players that wanted to back out but couldn't because they're antags (can you feel the edge case?)
		RejectPlayer(player)

	return validate_required_jobs(required_jobs)


/datum/controller/subsystem/job/proc/do_required_jobs()
	var/amt_picked = 0
	var/list/require = list(/datum/job/lord, /datum/job/merchant)
	for(var/job_type in require)
		var/datum/job/job = GetJobType(job_type)
		for(var/mob/dead/new_player/player in unassigned)
			if(is_role_banned(player.ckey, job.title))
				continue

			if(QDELETED(player))
				break

			if(!job.player_old_enough(player.client))
				continue

			if(job.required_playtime_remaining(player.client))
				continue

			if(player.mind && (job.title in player.mind.restricted_roles))
				continue

			if(length(job.allowed_races) && !(player.client.prefs.pref_species.name in job.allowed_races))
				continue

			if(length(job.allowed_patrons) && !(player.client.prefs.selected_patron.type in job.allowed_patrons))
				continue

			if(get_playerquality(player.ckey) < job.min_pq)
				continue

			if((player.client.prefs.lastclass == job.title) && (!job.bypass_lastclass))
				continue

			if(job.banned_leprosy && is_misc_banned(player.client.ckey, BAN_MISC_LEPROSY))
				continue

			if(job.banned_lunatic && is_misc_banned(player.client.ckey, BAN_MISC_LUNATIC))
				continue

			if(CONFIG_GET(flag/usewhitelist))
				if(job.whitelist_req && (!player.client.whitelisted()))
					continue

			if(length(job.allowed_ages) && !(player.client.prefs.age in job.allowed_ages))
				continue

			if(length(job.allowed_sexes) && !(player.client.prefs.gender in job.allowed_sexes))
				continue

			if(!job.special_job_check(player))
				continue

			// If the player wants that job on this level, then try give it to him.
			if(player.client.prefs.job_preferences[job.title] == JP_HIGH)
				// If the job isn't filled
				if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
					AssignRole(player, job)
					unassigned -= player
					amt_picked++
	return amt_picked

/datum/controller/subsystem/job/proc/validate_required_jobs(list/required_jobs)
	if(!required_jobs.len || SSticker.start_immediately == TRUE) //start_immediately triggers when the world is doing a test run or an admin hits start now, we don't need to check for king
		return TRUE
	for(var/required_group in required_jobs)
		var/group_ok = TRUE
		for(var/rank in required_group)
			var/datum/job/J = GetJob(rank)
			if(!J)
				return FALSE
			if(J.current_positions < required_group[rank])
				group_ok = FALSE
				break
		if(group_ok)
			return TRUE
	return FALSE

//We couldn't find a job from prefs for this guy.
/datum/controller/subsystem/job/proc/HandleUnassigned(mob/dead/new_player/player)
	if(PopcapReached())
		RejectPlayer(player)
		return

	switch(player.client.prefs.joblessrole)
		if(BERANDOMJOB)
			if(!GiveRandomJob(player))
				RejectPlayer(player)

		if(RETURNTOLOBBY)
			RejectPlayer(player)

		else //Something gone wrong if we got here.
			var/message = "DO: [player] fell through handling unassigned"
			JobDebug(message)
			log_game(message)
			message_admins(message)
			RejectPlayer(player)

/// Gives the player the stuff they should have with their rank
/datum/controller/subsystem/job/proc/EquipRank(mob/living/equipping, datum/job/job, client/player_client)
	equipping.job = job.title

	SEND_SIGNAL(equipping, COMSIG_JOB_RECEIVED, job)

	equipping.mind?.set_assigned_role(job)
	equipping.on_job_equipping(job)
	addtimer(CALLBACK(job, TYPE_PROC_REF(/datum/job, greet), equipping), 5 SECONDS) //TODO: REFACTOR OUT
	job.announce_job(equipping)

	if(player_client.holder)
		if(CONFIG_GET(flag/auto_deadmin_players) || (player_client.prefs?.toggles & DEADMIN_ALWAYS))
			player_client.holder.auto_deadmin()
		else
			handle_auto_deadmin_roles(player_client, job.title)

	if(player_client)
		if(job.req_admin_notify)
			to_chat(player_client, "<span class='infoplain'><b>You are playing a job that is important for Game Progression. If you have to disconnect, please notify the admins via adminhelp.</b></span>")
		SSpersistence.antag_rep_change[player_client.ckey] += job.GetAntagRep()
		var/related_policy = get_policy(job.title)
		if(related_policy)
			to_chat(player_client, related_policy)

	job.after_spawn(equipping, player_client)

/datum/job/proc/greet(mob/player)
	//! TODO: Refactor this out... Look at how TG handles job greetings or implement our own method
	if(player.mind?.assigned_role.title != title)
		return
	to_chat(player, span_notice("You are the <b>[get_informed_title(player)].</b>"))
	if(tutorial)
		to_chat(player, span_notice("*-----------------*"))
		to_chat(player, span_notice(tutorial))

/datum/controller/subsystem/job/proc/handle_auto_deadmin_roles(client/C, rank)
	if(!C?.holder)
		return TRUE
	var/datum/job/job = GetJob(rank)
	if(!job)
		return
	if((job.auto_deadmin_role_flags & DEADMIN_POSITION_HEAD) && (CONFIG_GET(flag/auto_deadmin_heads) || (C.prefs?.toggles & DEADMIN_POSITION_HEAD)))
		return C.holder.auto_deadmin()
	else if((job.auto_deadmin_role_flags & DEADMIN_POSITION_SECURITY) && (CONFIG_GET(flag/auto_deadmin_security) || (C.prefs?.toggles & DEADMIN_POSITION_SECURITY)))
		return C.holder.auto_deadmin()
	else if((job.auto_deadmin_role_flags & DEADMIN_POSITION_SILICON) && (CONFIG_GET(flag/auto_deadmin_silicons) || (C.prefs?.toggles & DEADMIN_POSITION_SILICON))) //in the event there's ever psuedo-silicon roles added, ie synths.
		return C.holder.auto_deadmin()

/datum/controller/subsystem/job/proc/HandleFeedbackGathering()
	for(var/datum/job/job as anything in joinable_occupations)
		var/high = 0 //high
		var/medium = 0 //medium
		var/low = 0 //low
		var/never = 0 //never
		var/banned = 0 //banned
		var/young = 0 //account too young
		for(var/i in GLOB.new_player_list)
			var/mob/dead/new_player/player = i
			if(!(player.ready == PLAYER_READY_TO_PLAY && player.mind && !player.mind.assigned_role))
				continue //This player is not ready
			if(is_role_banned(player.ckey, job.title) || QDELETED(player))
				banned++
				continue
			if(!job.player_old_enough(player.client))
				young++
				continue
			if(job.required_playtime_remaining(player.client))
				young++
				continue
			switch(player.client.prefs.job_preferences[job.title])
				if(JP_HIGH)
					high++
				if(JP_MEDIUM)
					medium++
				if(JP_LOW)
					low++
				else
					never++
		SSblackbox.record_feedback("nested tally", "job_preferences", high, list("[job.title]", "high"))
		SSblackbox.record_feedback("nested tally", "job_preferences", medium, list("[job.title]", "medium"))
		SSblackbox.record_feedback("nested tally", "job_preferences", low, list("[job.title]", "low"))
		SSblackbox.record_feedback("nested tally", "job_preferences", never, list("[job.title]", "never"))
		SSblackbox.record_feedback("nested tally", "job_preferences", banned, list("[job.title]", "banned"))
		SSblackbox.record_feedback("nested tally", "job_preferences", young, list("[job.title]", "young"))

/datum/controller/subsystem/job/proc/PopcapReached()
	var/hpc = CONFIG_GET(number/hard_popcap)
	var/epc = CONFIG_GET(number/extreme_popcap)
	if(hpc || epc)
		var/relevent_cap = max(hpc, epc)
		if((initial_players_to_assign - unassigned.len) >= relevent_cap)
			return 1
	return 0

/datum/controller/subsystem/job/proc/RejectPlayer(mob/dead/new_player/player)
	if(player.mind && player.mind.special_role)
		return
	if(PopcapReached())
		JobDebug("Popcap overflow Check observer located, Player: [player]")
	JobDebug("Player rejected :[player]")
	to_chat(player, "<b>I couldn't find a job to be..</b>")
	unassigned -= player
	player.ready = PLAYER_NOT_READY


/datum/controller/subsystem/job/Recover()
	set waitfor = FALSE
	var/oldjobs = SSjob.all_occupations
	sleep(20)
	for (var/datum/job/J in oldjobs)
		INVOKE_ASYNC(src, PROC_REF(RecoverJob), J)

/datum/controller/subsystem/job/proc/RecoverJob(datum/job/J)
	var/datum/job/newjob = GetJob(J.title)
	if (!istype(newjob))
		return
	newjob.total_positions = J.total_positions
	newjob.spawn_positions = J.spawn_positions
	newjob.current_positions = J.current_positions

/atom/proc/JoinPlayerHere(mob/M, buckle)
	// By default, just place the mob on the same turf as the marker or whatever.
	M.forceMove(get_turf(src))
	M.dir = dir

/obj/structure/chair/JoinPlayerHere(mob/M, buckle)
	// Placing a mob in a chair will attempt to buckle it, or else fall back to default.
	if (buckle && isliving(M) && buckle_mob(M, FALSE, FALSE))
		return
	..()

/datum/controller/subsystem/job/proc/SendToLateJoin(mob/M, buckle = TRUE)
	var/atom/destination
	if(M.mind && !is_unassigned_job(M.mind.assigned_role) && length(GLOB.jobspawn_overrides[M.mind.assigned_role.title])) //We're doing something special today.
		destination = pick(GLOB.jobspawn_overrides[M.mind.assigned_role.title])
		destination.JoinPlayerHere(M, FALSE)
		return

	if(!length(latejoin_trackers))
		destination = pick(latejoin_trackers)
		destination.JoinPlayerHere(M, buckle)
		return

	destination = get_last_resort_spawn_points()
	destination.JoinPlayerHere(M, buckle)

/datum/controller/subsystem/proc/get_last_resort_spawn_points()
	//bad mojo

	stack_trace("Unable to find last resort spawn point.")
	//fuck you
	return pick(world.contents)
	//return GET_ERROR_ROOM

/datum/controller/subsystem/job/proc/CanPickJob(mob/living/player, datum/job/job)
	. = FALSE

	if(is_role_banned(player.ckey, job.title))
		return

	if(QDELETED(player))
		return

	if(!job.player_old_enough(player.client))
		return

	if(job.required_playtime_remaining(player.client))
		return

	if(player.mind && (job.title in player.mind.restricted_roles))
		return

	if(length(job.allowed_races) && !(player.client.prefs.pref_species.name in job.allowed_races))
		return

	if(length(job.allowed_patrons) && !(player.client.prefs.selected_patron.type in job.allowed_patrons))
		return

	if(get_playerquality(player.ckey) < job.min_pq)
		return

	if((player.client.prefs.lastclass == job.title) && (!job.bypass_lastclass))
		return

	if(job.banned_leprosy && is_misc_banned(player.client.ckey, BAN_MISC_LEPROSY))
		return

	if(job.banned_lunatic && is_misc_banned(player.client.ckey, BAN_MISC_LUNATIC))
		return

	if(CONFIG_GET(flag/usewhitelist))
		if(job.whitelist_req && (!player.client.whitelisted()))
			return

	if(length(job.allowed_ages) && !(player.client.prefs.age in job.allowed_ages))
		return

	if(length(job.allowed_sexes) && !(player.client.prefs.gender in job.allowed_sexes))
		return

	if(!job.special_job_check(player))
		return

	return TRUE

/datum/controller/subsystem/job/proc/JobDebug(message)
	log_job_debug(message)
