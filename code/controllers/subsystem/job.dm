SUBSYSTEM_DEF(job)
	name = "Jobs"
	init_order = INIT_ORDER_JOBS
	flags = SS_NO_FIRE

	/// List of all jobs.
	var/list/all_occupations = list()
	/// List of jobs that can be joined through the starting menu.
	var/list/joinable_occupations = list()
	/// assoc list of all jobs, keys are titles
	var/list/datum/job/name_occupations = list()
	/// assoc list of all jobs, keys are types
	var/list/type_occupations = list()
	/// list of players who need jobs
	var/list/unassigned = list()
	/// used for checking against population caps
	var/initial_players_to_assign = 0

	var/list/prioritized_jobs = list()
	var/list/latejoin_trackers = list()

	var/list/level_order = list(JP_HIGH,JP_MEDIUM,JP_LOW)
	/// Map of jobs indexed by the experience type they grant.
	var/list/experience_jobs_map = list()

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

		for(var/t in job.exp_types_granted)
			if(!(t in experience_jobs_map))
				experience_jobs_map[t] = list()
			experience_jobs_map[t] += job
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
	if(istype(player) && player?.client?.prefs.multi_char_ready)
		player.finalize_multi_ready_character()
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

/datum/controller/subsystem/job/proc/GiveRandomJob(mob/dead/new_player/player)
	JobDebug("GRJ Giving random job, Player: [player]")
	. = FALSE
	var/client/player_client = player.client
	var/datum/preferences/player_prefs = player_client.prefs

	for(var/datum/job/job as anything in shuffle(joinable_occupations))
		if(QDELETED(player))
			return

		if(job.title in GLOB.noble_positions) //If you want a command position, select it!
			continue

		if(is_role_banned(player.ckey, job.title))
			JobDebug("GRJ isbanned failed, Player: [player], Job: [job.title]")
			continue

		if(is_race_banned(player.ckey, player_prefs.pref_species.id))
			JobDebug("GRJ is_race_banned failed, Player: [player], Race: [player_prefs.pref_species.id]")
			continue

		if(!job.can_random)
			JobDebug("GRJ can't random into this job, Job: [job.title], Player: [player]")
			continue

		if(!job.player_old_enough(player_client))
			JobDebug("GRJ player not old enough, Player: [player]")
			continue

		if(job.required_playtime_remaining(player_client))
			JobDebug("GRJ player not enough playtime, Player: [player], Job: [job.title]")
			continue

		if(player.mind && (job.title in player.mind.restricted_roles))
			JobDebug("GRJ incompatible with antagonist role, Player: [player], Job: [job.title]")
			continue

		if(!job.prefs_species_check(player_prefs))
			JobDebug("GRJ incompatible with species, Player: [player], Job: [job.title], Species: [player_prefs.pref_species.name]")
			continue

		if(length(job.allowed_patrons) && !(player_prefs.selected_patron.type in job.allowed_patrons))
			JobDebug("GRJ incompatible with patron, Player: [player], Job: [job.title], Species: [player_prefs.pref_species.name]")
			continue

		if(length(job.allowed_ages) && !(player_prefs.age in job.allowed_ages))
			JobDebug("GRJ incompatible with age, Player: [player], Job: [job.title], Species: [player_prefs.pref_species.name]")
			continue

		if(length(job.allowed_sexes) && !(player_prefs.gender in job.allowed_sexes))
			JobDebug("GRJ incompatible with sex, Player: [player], Job: [job.title]")
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

		if(!job.enabled)
			JobDebug("GRJ player tried to play a disabled job, Player: [player], Job:[job.title]")
			continue

		if(CONFIG_GET(flag/usewhitelist))
			if(job.whitelist_req && (!player.client.whitelisted()))
				continue

		if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
			JobDebug("GRJ Random job given, Player: [player], Job: [job]")
			if(AssignRole(player, job))
				return TRUE

/// Consolidated job eligibility check
/datum/controller/subsystem/job/proc/check_job_eligibility(mob/dead/new_player/player, datum/job/job)
	if(QDELETED(player))
		return FALSE

	var/datum/preferences/player_prefs = player.client.prefs

	if(is_role_banned(player.ckey, job.title))
		JobDebug("Eligibility failed: role banned, Player: [player], Job: [job.title]")
		return FALSE

	if(is_race_banned(player.ckey, player_prefs.pref_species.id))
		JobDebug("Eligibility failed: race banned, Player: [player], Job: [job.title]")
		return FALSE

	if(!job.player_old_enough(player.client))
		JobDebug("Eligibility failed: not old enough, Player: [player], Job: [job.title]")
		return FALSE

	if(job.required_playtime_remaining(player.client))
		JobDebug("Eligibility failed: playtime, Player: [player], Job: [job.title]")
		return FALSE

	if(player.mind && (job.title in player.mind.restricted_roles))
		JobDebug("Eligibility failed: restricted role, Player: [player], Job: [job.title]")
		return FALSE

	var/dominated_species_check = FALSE
	var/player_species_id_job = player_prefs.pref_species.id_override ? player_prefs.pref_species.id_override : player_prefs.pref_species.id

	if(length(job.allowed_races) && !(player_species_id_job in job.allowed_races))
		if(player.client?.has_triumph_buy(TRIUMPH_BUY_RACE_ALL))
			dominated_species_check = TRUE
		else
			JobDebug("Eligibility failed: species not allowed, Player: [player], Job: [job.title]")
			return FALSE

	if(length(job.blacklisted_species) && (player_species_id_job in job.blacklisted_species))
		JobDebug("Eligibility failed: species blacklisted, Player: [player], Job: [job.title]")
		return FALSE

	if(length(job.allowed_patrons) && !(player_prefs.selected_patron.type in job.allowed_patrons))
		JobDebug("Eligibility failed: patron, Player: [player], Job: [job.title]")
		return FALSE

	if((player_prefs.lastclass == job.title) && (!job.bypass_lastclass))
		JobDebug("Eligibility failed: lastclass, Player: [player], Job: [job.title]")
		return FALSE

	if(job.banned_leprosy && is_misc_banned(player.client.ckey, BAN_MISC_LEPROSY))
		JobDebug("Eligibility failed: leprosy, Player: [player], Job: [job.title]")
		return FALSE

	if(job.banned_lunatic && is_misc_banned(player.client.ckey, BAN_MISC_LUNATIC))
		JobDebug("Eligibility failed: lunatic, Player: [player], Job: [job.title]")
		return FALSE

	if(CONFIG_GET(flag/usewhitelist))
		if(job.whitelist_req && (!player.client.whitelisted()))
			JobDebug("Eligibility failed: whitelist, Player: [player], Job: [job.title]")
			return FALSE

	if(length(job.allowed_ages) && !(player_prefs.age in job.allowed_ages))
		JobDebug("Eligibility failed: age, Player: [player], Job: [job.title]")
		return FALSE

	if(length(job.allowed_sexes) && !(player_prefs.gender in job.allowed_sexes))
		JobDebug("Eligibility failed: sex, Player: [player], Job: [job.title]")
		return FALSE

	if(!job.special_job_check(player))
		JobDebug("Eligibility failed: special check, Player: [player], Job: [job.title]")
		return FALSE

	if(!job.enabled)
		JobDebug("Eligibility failed: disabled, Player: [player], Job: [job.title]")
		return FALSE

	// Activate triumph if we passed with it
	if(dominated_species_check)
		player.client?.activate_triumph_buy(TRIUMPH_BUY_RACE_ALL)

	return TRUE

/// Get job preferences for a player, considering multi-char
/datum/controller/subsystem/job/proc/get_player_job_prefs(mob/dead/new_player/player, char_index = 0)
	if(char_index > 0 && length(player.multi_ready_characters) >= char_index)
		return player.multi_ready_characters[char_index]["job_preferences"]
	return player.client.prefs.job_preferences

/// Lock in the current character selection - call this after job assignment succeeds
/mob/dead/new_player/proc/finalize_multi_ready_character()
	if(!length(multi_ready_characters) || !client?.prefs)
		return

	var/list/char_data = multi_ready_characters[multi_ready_index]
	if(!char_data)
		return

	// Make sure we've loaded the correct slot
	var/target_slot = char_data["slot"]

	multi_ready_assigned_slot = target_slot

	if(client.prefs.default_slot != target_slot)
		client.prefs.load_character(target_slot)
		client.prefs.default_slot = target_slot


/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
/datum/controller/subsystem/job/proc/DivideOccupations(list/required_jobs)
	JobDebug("Running DO")

	//Get the players who are ready
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(player.ready == PLAYER_READY_TO_PLAY && player.check_preferences() && player.mind && is_unassigned_job(player.mind.assigned_role))
			unassigned += player
			// Cache multi-ready characters if enabled
			player.cache_multi_ready_characters()

	initial_players_to_assign = unassigned.len

	JobDebug("DO, Len: [unassigned.len]")
	if(unassigned.len == 0)
		return validate_required_jobs(required_jobs)

	// Jobs will have fewer access permissions if the number of players exceeds the threshold
	var/mat = CONFIG_GET(number/minimal_access_threshold)
	if(mat)
		if(mat > unassigned.len)
			CONFIG_SET(flag/jobs_have_minimal_access, FALSE)
		else
			CONFIG_SET(flag/jobs_have_minimal_access, TRUE)

	// Shuffle players and jobs
	unassigned = shuffle(unassigned)

	HandleFeedbackGathering()

	// Select required jobs (lord, merchant)
	JobDebug("DO, Running Head Check")
	do_required_jobs()
	JobDebug("DO, Head Check end")

	JobDebug("DO, Running Standard Check")

	var/list/shuffledoccupations = shuffle(joinable_occupations)

	// Loop through all priority levels from high to low
	for(var/level in level_order)
		// Create a weighted list of players based on their boosts
		var/list/weighted_players = list()

		for(var/mob/dead/new_player/player in unassigned)
			if(PopcapReached())
				RejectPlayer(player)
				continue

			// Calculate player's boost weight
			var/player_weight = 1
			var/list/player_boosts = get_player_boosts(player)

			for(var/datum/job_priority_boost/boost in player_boosts)
				if(boost.is_valid())
					player_weight += boost.boost_amount

			weighted_players[player] = player_weight

		// Shuffle the weighted player list
		weighted_players = shuffle(weighted_players)

		// Loop through weighted players
		for(var/i = 1 to length(weighted_players))
			var/mob/dead/new_player/player = pickweight(weighted_players)
			weighted_players -= player
			if(!player)
				continue
			if(!(player in unassigned))
				continue
			if(QDELETED(player))
				JobDebug("DO player deleted during assignment")
				continue

			// Loop through characters FIRST (in priority order), then their preferred jobs
			var/assigned = FALSE

			if(length(player.multi_ready_characters))
				for(var/char_idx in 1 to length(player.multi_ready_characters))
					if(assigned)
						break

					var/list/char_data = player.multi_ready_characters[char_idx]
					var/list/char_job_prefs = char_data["job_preferences"]

					// Apply this character temporarily for eligibility checks
					player.apply_multi_ready_character(char_idx)

					// Now check all jobs this character wants at this priority level
					for(var/datum/job/job in shuffledoccupations)
						if(!job)
							continue

						// Does this character want this job at this priority level?
						if(char_job_prefs[job.title] != level)
							continue

						// Is the job available?
						if(!((job.current_positions < job.spawn_positions) || job.spawn_positions == -1))
							continue

						// Is this character eligible?
						if(!check_job_eligibility(player, job))
							continue

						// Success! Assign the job
						JobDebug("Multi-char DO: Player [player], Char [char_idx] (Slot [char_data["slot"]]), Job [job.title]")
						if(AssignRole(player, job))

							// Handle boosts
							var/list/player_boosts = get_player_boosts(player)
							for(var/datum/job_priority_boost/boost in player_boosts)
								if(boost.can_boost_job(job))
									boost.use_boost()
									JobDebug("DO boost used, Player: [player], Job: [job.title]")

							assigned = TRUE
							break
			else
				// Single character mode: just loop through jobs normally
				for(var/datum/job/job in shuffledoccupations)
					if(!job)
						continue

					if(player.client.prefs.job_preferences[job.title] != level)
						continue

					if(!((job.current_positions < job.spawn_positions) || job.spawn_positions == -1))
						continue

					if(!check_job_eligibility(player, job))
						continue

					JobDebug("Single-char DO: Player [player], Job [job.title]")
					if(AssignRole(player, job))
						var/list/player_boosts = get_player_boosts(player)
						for(var/datum/job_priority_boost/boost in player_boosts)
							if(boost.can_boost_job(job))
								boost.use_boost()
								JobDebug("DO boost used, Player: [player], Job: [job.title]")
						assigned = TRUE
						break

			if(assigned)
				unassigned -= player

	JobDebug("DO, Handling unassigned.")
	// Hand out random jobs to the people who didn't get any
	for(var/mob/dead/new_player/player in unassigned)
		HandleUnassigned(player)

	JobDebug("DO, Handling unrejectable unassigned")
	// Mop up people who can't leave
	for(var/mob/dead/new_player/player in unassigned)
		RejectPlayer(player)

	return validate_required_jobs(required_jobs)

/datum/controller/subsystem/job/proc/get_player_boosts(mob/dead/new_player/player)
	var/list/boosts = list()
	if(player.client && islist(player.client.job_priority_boosts))
		boosts = player.client.job_priority_boosts
	return boosts

/datum/controller/subsystem/job/proc/save_player_boosts(ckey)
	var/datum/save_manager/SM = get_save_manager(ckey)
	if(!SM)
		return FALSE

	var/client/C = GLOB.directory[ckey]
	if(!C || !islist(C.job_priority_boosts))
		return FALSE

	var/list/boost_data = list()
	for(var/datum/job_priority_boost/boost in C.job_priority_boosts)
		if(!boost.is_valid())
			continue

		var/list/boost_save = list(
			"type" = boost.type,
			"name" = boost.name,
			"desc" = boost.desc,
			"boost_amount" = boost.boost_amount,
			"applicable_jobs" = boost.applicable_jobs?.Copy(),
			"expiry_time" = boost.expiry_time,
			"uses_remaining" = boost.uses_remaining,
			"boost_type" = boost.boost_type
		)
		boost_data += list(boost_save)

	SM.set_data("job_boosts", "active_boosts", boost_data)
	return TRUE

/datum/controller/subsystem/job/proc/load_player_boosts(ckey)
	var/datum/save_manager/SM = get_save_manager(ckey)
	if(!SM)
		return FALSE

	var/client/C = GLOB.directory[ckey]
	if(!C)
		return FALSE

	var/list/boost_data = SM.get_data("job_boosts", "active_boosts", list())
	if(!islist(boost_data) || !length(boost_data))
		return FALSE

	C.job_priority_boosts = list()

	for(var/list/boost_info in boost_data)
		if(!islist(boost_info))
			continue

		var/boost_type = boost_info["type"]
		if(!boost_type)
			continue

		var/datum/job_priority_boost/boost = new boost_type()
		if(!boost)
			continue

		// Restore saved properties
		if(boost_info["name"])
			boost.name = boost_info["name"]
		if(boost_info["desc"])
			boost.desc = boost_info["desc"]
		if(boost_info["boost_amount"])
			boost.boost_amount = boost_info["boost_amount"]
		if(boost_info["applicable_jobs"])
			boost.applicable_jobs = boost_info["applicable_jobs"]
		if(boost_info["expiry_time"])
			boost.expiry_time = boost_info["expiry_time"]
		if(boost_info["uses_remaining"])
			boost.uses_remaining = boost_info["uses_remaining"]
		if(boost_info["boost_type"])
			boost.boost_type = boost_info["boost_type"]

		// Only add valid boosts
		if(boost.is_valid())
			C.job_priority_boosts += boost
		else
			qdel(boost)

	return TRUE

/datum/controller/subsystem/job/proc/give_job_boost(client/target_client, datum/job_priority_boost/boost)
	if(!target_client || !boost)
		return FALSE

	if(!islist(target_client.job_priority_boosts))
		target_client.job_priority_boosts = list()

	target_client.job_priority_boosts += boost
	to_chat(target_client, "<span class='notice'>You have received a job priority boost: [boost.name] - [boost.desc]</span>")

	save_player_boosts(target_client.ckey)

	return TRUE

/datum/controller/subsystem/job/proc/remove_expired_boosts(client/target_client)
	if(!target_client || !islist(target_client.job_priority_boosts))
		return

	var/removed_any = FALSE
	for(var/datum/job_priority_boost/boost in target_client.job_priority_boosts)
		if(!boost.is_valid())
			target_client.job_priority_boosts -= boost
			qdel(boost)
			removed_any = TRUE

	// Update save file if we removed any boosts
	if(removed_any)
		save_player_boosts(target_client.ckey)

/datum/controller/subsystem/job/proc/do_required_jobs()
	var/amt_picked = 0
	var/list/require = list(/datum/job/lord, /datum/job/merchant)

	for(var/job_type in require)
		var/datum/job/job = GetJobType(job_type)

		for(var/mob/dead/new_player/player in unassigned)
			if(QDELETED(player))
				break

			// MULTI-CHARACTER MODE
			if(length(player.multi_ready_characters))
				var/found_eligible_char = FALSE

				for(var/char_idx in 1 to length(player.multi_ready_characters))
					var/list/char_data = player.multi_ready_characters[char_idx]
					var/list/char_job_prefs = char_data["job_preferences"]

					// Does this character want this job at HIGH priority?
					if(char_job_prefs[job.title] != JP_HIGH)
						continue

					// Apply this character for eligibility check
					player.apply_multi_ready_character(char_idx)

					// Check eligibility
					if(!check_job_eligibility(player, job))
						continue

					// Check if job has room
					if(!((job.current_positions < job.spawn_positions) || job.spawn_positions == -1))
						continue

					// Success!
					JobDebug("Required job multi-char: Player [player], Char [char_idx], Slot [char_data["slot"]], Job [job.title]")
					if(AssignRole(player, job))
						player.finalize_multi_ready_character()
						unassigned -= player
						amt_picked++
						found_eligible_char = TRUE
						break

				if(found_eligible_char)
					continue // Move to next player

			// SINGLE CHARACTER MODE (original logic but using check_job_eligibility)
			else
				if(player.client.prefs.job_preferences[job.title] != JP_HIGH)
					continue

				if(!check_job_eligibility(player, job))
					continue

				if(!((job.current_positions < job.spawn_positions) || job.spawn_positions == -1))
					continue

				JobDebug("Required job single-char: Player [player], Job [job.title]")
				if(AssignRole(player, job))
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
/datum/controller/subsystem/job/proc/EquipRank(mob/living/equipping, datum/job/job, client/player_client, reset_job_stats = TRUE)
	equipping.job = job.title
	equipping.job_type = job.type
	if(job.parent_job)
		equipping.job_type = job.parent_job.type

	SEND_SIGNAL(equipping, COMSIG_JOB_RECEIVED, job)

	equipping.mind?.set_assigned_role(job)
	job.pre_outfit_equip(equipping, player_client) // sigh
	equipping.on_job_equipping(job)
	addtimer(CALLBACK(job, TYPE_PROC_REF(/datum/job, greet), equipping), 5 SECONDS) //TODO: REFACTOR OUT

	if(player_client?.holder)
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

	job.after_spawn(equipping, player_client, reset_job_stats)

	if(length(job.advclass_cat_rolls) || !ishuman(equipping))
		return

	var/mob/living/carbon/human/equipping_human = equipping
	for(var/datum/quirk/quirk in equipping_human.quirks)
		quirk.after_job_spawn(job)

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
		for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
			if(!(player.ready == PLAYER_READY_TO_PLAY && player.mind && !player.mind.assigned_role))
				continue //This player is not ready
			if(is_role_banned(player.ckey, job.title) || QDELETED(player))
				banned++
				continue
			if(is_race_banned(player.ckey, player.client.prefs.pref_species.id))
				banned++
				continue
			if(!job.player_old_enough(player.client))
				young++
				continue
			if(job.required_playtime_remaining(player.client))
				never++
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
	to_chat(player, span_danger("<b>I couldn't find a job to be..</b>"))

	var/list/client_triumphs = SStriumphs.triumph_buy_owners[player.ckey]
	if(islist(client_triumphs))
		for(var/datum/triumph_buy/race_all_jobs/R in client_triumphs)
			SStriumphs.attempt_to_unbuy_triumph_condition(player.client, R, reason = "FAILING TO GET A JOB", force = TRUE)

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
	if(QDELETED(player))
		return

	. = FALSE

	var/datum/preferences/player_prefs = player.client.prefs

	if(is_role_banned(player.ckey, job.title))
		return

	if(is_race_banned(player.ckey, player_prefs.pref_species.id))
		return

	if(!job.player_old_enough(player.client))
		return

	if(job.required_playtime_remaining(player.client))
		return

	if(player.mind && (job.title in player.mind.restricted_roles))
		return

	if(!job.prefs_species_check(player_prefs))
		return

	if((player_prefs.lastclass == job.title) && (!job.bypass_lastclass))
		return

	if(job.banned_leprosy && is_misc_banned(player.client.ckey, BAN_MISC_LEPROSY))
		return

	if(job.banned_lunatic && is_misc_banned(player.client.ckey, BAN_MISC_LUNATIC))
		return

	if(CONFIG_GET(flag/usewhitelist))
		if(job.whitelist_req && (!player.client.whitelisted()))
			return

	if(length(job.allowed_ages) && !(player_prefs.age in job.allowed_ages))
		return

	if(length(job.allowed_sexes) && !(player_prefs.gender in job.allowed_sexes))
		return

	if(!job.special_job_check(player))
		return

	return TRUE

/datum/controller/subsystem/job/proc/JobDebug(message)
	log_job_debug(message)
