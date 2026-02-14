SUBSYSTEM_DEF(migrants)
	name = "Migrants"
	wait = 2 SECONDS
	runlevels = RUNLEVEL_GAME

	/// Count of all waves
	var/wave_number = 1
	/// Current wave running
	var/current_wave = null
	/// Time until the next wave
	var/time_until_next_wave = 2 MINUTES
	/// Current wave timer
	var/wave_timer = 0

	/// Time between successful waves
	var/time_between_waves = 3 MINUTES
	/// Time between failing waves
	var/time_between_fail_wave = 90 SECONDS
	/// how long waves wait for players
	var/wave_wait_time = 30 SECONDS

	/// Track waves that have happened
	var/list/spawned_waves = list()
	/// Track triumph contributions across all waves
	var/list/global_triumph_contributions = list()
	/// Track parent wave for downgrades
	var/current_parent_wave = null
	/// All migrant waves are disabled
	var/admin_disabled = FALSE

/datum/controller/subsystem/migrants/Initialize()
	return ..()

/datum/controller/subsystem/migrants/fire(resumed)
	process_migrants(2 SECONDS)
	update_ui()

/datum/controller/subsystem/migrants/proc/toggle_admin_disabled()
	admin_disabled = !admin_disabled
	if(admin_disabled)
		unqueue_all_migrants()

/datum/controller/subsystem/migrants/proc/unqueue_all_migrants()
	for(var/client/client as anything in get_all_migrants())
		client.prefs.migrant.set_active(FALSE, TRUE)
		to_chat(client.mob, span_boldwarning("An admin has disabled migration and you are no longer in the migrant queue."))

/datum/controller/subsystem/migrants/proc/get_current_disabled_status()
	return admin_disabled ? "Disabled" : "Enabled"

/datum/controller/subsystem/migrants/proc/set_current_wave(wave_type, time, parent_wave = -1)
	current_wave = wave_type
	wave_timer = time
	if(parent_wave != -1)
		current_parent_wave = parent_wave

/datum/controller/subsystem/migrants/proc/process_migrants(dt)
	if(admin_disabled)
		return
	if(current_wave)
		process_current_wave(dt)
	else
		process_next_wave(dt)

/datum/controller/subsystem/migrants/proc/process_current_wave(dt)
	wave_timer -= dt
	if(wave_timer > 0)
		return
	// Try and spawn wave
	var/success = try_spawn_wave()
	if(success)
		log_game("Migrants: Successfully spawned wave: [current_wave]")
	else
		log_game("Migrants: FAILED to spawn wave: [current_wave]")

	// Handle downgrade logic
	var/datum/migrant_wave/wave = MIGRANT_WAVE(current_wave)
	var/parent_wave = current_parent_wave

	// Unset some values, increment wave number if success
	if(success)
		wave_number++
		// Reset parent wave triumph if this was a downgrade that succeeded
		if(parent_wave)
			reset_wave_contributions(MIGRANT_WAVE(parent_wave))

	set_current_wave(null, 0)

	if(success)
		time_until_next_wave = time_between_waves
		current_parent_wave = null
	else
		if(wave.downgrade_wave)
			// Apply triumph weighting to downgrade decision
			var/datum/migrant_wave/downgrade_wave = MIGRANT_WAVE(wave.downgrade_wave)
			var/downgrade_weight = calculate_triumph_weight(downgrade_wave)
			// Use parent wave if this was already a downgrade, otherwise use current wave as parent
			var/new_parent = parent_wave ? parent_wave : current_wave
			set_current_wave(wave.downgrade_wave, wave_wait_time, new_parent)
			log_game("Migrants: Downgrading to [wave.downgrade_wave] (parent: [new_parent]) with triumph weight [downgrade_weight]")
		else
			current_parent_wave = null
			time_until_next_wave = time_between_fail_wave

/datum/controller/subsystem/migrants/proc/try_spawn_wave()
	var/datum/migrant_wave/wave = MIGRANT_WAVE(current_wave)
	/// Create indexed assignment slots and role map
	var/list/assignments = list()  // indexed list of clients (null = empty slot)
	var/list/assignment_roles = list()  // indexed list of role types per slot
	/// Populate it
	for(var/role_type in wave.roles)
		var/amount = wave.roles[role_type]
		for(var/i in 1 to amount)
			assignments += null
			assignment_roles += role_type

	/// Shuffle assignments so role rolling is not consistent
	var/list/slot_order = list()
	for(var/i in 1 to assignments.len)
		slot_order += i
	slot_order = shuffle(slot_order)

	var/list/shuffled_assignments = list()
	var/list/shuffled_assignment_roles = list()
	for(var/idx in slot_order)
		shuffled_assignments += assignments[idx]
		shuffled_assignment_roles += assignment_roles[idx]

	assignments = shuffled_assignments
	assignment_roles = shuffled_assignment_roles

	///Get active migrants and shuffle them
	var/list/active_migrants = get_active_migrants()
	active_migrants = shuffle(active_migrants)

	var/list/picked_migrants = list()

	if(!length(active_migrants))
		return FALSE

	/// Try to assign priority players to positions
	for(var/i in 1 to assignments.len)
		if(!length(active_migrants))
			break
		if(!isnull(assignments[i]))
			continue

		var/role_type = assignment_roles[i]
		var/list/priority = get_priority_players(active_migrants, role_type, current_wave)
		if(!length(priority))
			continue

		var/client/picked
		for(var/client/client as anything in priority)
			if(!can_be_role(client, role_type))
				continue
			picked = client
			break
		if(!picked)
			continue

		active_migrants -= picked
		assignments[i] = picked
		picked_migrants += picked

	/// Assign rest of the players to positions
	for(var/i in 1 to assignments.len)
		if(!length(active_migrants))
			break // Out of migrants, we're screwed and will fail
		if(!isnull(assignments[i]))
			continue

		var/role_type = assignment_roles[i]
		var/client/picked
		for(var/client/client as anything in active_migrants)
			if(!can_be_role(client, role_type))
				continue
			picked = client
			break
		if(!picked)
			continue

		active_migrants -= picked
		assignments[i] = picked
		picked_migrants += picked

	/// Find spawn points for the assignments
	var/turf/spawn_location = get_spawn_turf_for_job(wave.spawn_landmark)
	var/atom/fallback_location = spawn_location
	var/list/turfs = get_safe_turfs_around_location(spawn_location)

	/// At this point everything is GOOD and SWELL, we want to spawn the wave

	/// Unset their pref so if they respawn they wont get yoinked into migrants immediately
	for(var/client/client as anything in picked_migrants)
		client.prefs.migrant.post_spawn()

	/// Spawn the migrants, hooray
	for(var/i in 1 to assignments.len)
		var/client/client = assignments[i]
		if(!client)
			continue
		var/role_type = assignment_roles[i]
		var/turf/spawn_turf = pick_n_take(turfs)
		if(!spawn_turf)
			spawn_turf = fallback_location
		spawn_migrant(wave, role_type, client, spawn_turf)

	// Increment wave spawn counter
	var/used_wave_type = wave.type
	if(wave.shared_wave_type)
		used_wave_type = wave.shared_wave_type
	if(!spawned_waves[used_wave_type])
		spawned_waves[used_wave_type] = 0
	spawned_waves[used_wave_type] += 1

	reset_wave_contributions(wave)
	message_admins("MIGRANTS: Spawned wave: [wave.name] (players: [picked_migrants.len]) at [ADMIN_VERBOSEJMP(spawn_location)]")

	unset_all_active_migrants()

	return TRUE

/datum/controller/subsystem/migrants/proc/get_influenceable_waves()
	var/list/waves = list()
	for(var/wave_type in GLOB.migrant_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		if(!wave.can_roll)
			continue
		// Only show waves that haven't hit max spawns
		if(!isnull(wave.max_spawns))
			var/used_wave_type = wave.type
			if(wave.shared_wave_type)
				used_wave_type = wave.shared_wave_type
			if(spawned_waves[used_wave_type] && spawned_waves[used_wave_type] >= wave.max_spawns)
				continue
		waves += wave_type
	return waves

/datum/controller/subsystem/migrants/proc/get_status_line()
	var/string = ""
	if(current_wave)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(current_wave)
		var/parent_info = ""
		if(current_parent_wave)
			var/datum/migrant_wave/parent = MIGRANT_WAVE(current_parent_wave)
			parent_info = " (downgrade from [parent.name])"
		string = "[wave.name][parent_info] ([get_active_migrant_amount()]/[wave.get_roles_amount()]) - [wave_timer / (1 SECONDS)]s"
	else
		string = "Mist - [time_until_next_wave / (1 SECONDS)]s"
	return "Migrants: [string]"

/datum/controller/subsystem/migrants/proc/unset_all_active_migrants()
	var/list/active_migrants = get_active_migrants()
	if(active_migrants)
		for(var/client/client as anything in active_migrants)
			client.prefs.migrant.set_active(FALSE)

/datum/controller/subsystem/migrants/proc/get_safe_turfs_around_location(atom/location)
	var/list/turfs = list()
	var/turf/turfloc = get_turf(location)
	for(var/turf/turf as anything in RANGE_TURFS(2, turfloc))
		if(!isfloorturf(turf))
			continue
		if(islava(turf))
			continue
		if(is_blocked_turf(turf))
			continue
		turfs += turf
	turfs = shuffle(turfs)
	return turfs

/datum/controller/subsystem/migrants/proc/spawn_migrant(datum/migrant_wave/wave, datum/migrant_role/role, client/client, spawn_on_location)
	if(!wave || !role)
		CRASH("spawn_migrant called without specificing wave or role!")
	if(!client)
		CRASH("spawn_migrant called without a client!")
	if(!spawn_on_location)
		CRASH("spawn_migrant called without a valid spawn location!")

	var/mob/dead/new_player/new_player = client.mob
	if(!new_player)
		return

	/// copy pasta from AttemptLateSpawn(rank) further on TODO put it in a proc and use in both places

	var/datum/migrant_role/role_instance = MIGRANT_ROLE(role)

	var/datum/job/migrant_job = SSjob.GetJobType(role_instance.migrant_job)

	SSjob.AssignRole(new_player, migrant_job, 1)

	new_player.mind.late_joiner = TRUE

	var/mob/living/character = new_player.create_character(spawn_on_location) //very naive, this is going to error
	if(!character)
		CRASH("Failed to create a character for migrants.")

	character.islatejoin = TRUE
	new_player.transfer_character()

	SSjob.EquipRank(character, migrant_job, character.client)
	apply_loadouts(character, character.client)
	SSticker.minds += character.mind

	GLOB.joined_player_list += character.ckey
	GLOB.respawncounts[character.ckey] += 1

	/// And back to non copy pasta code

	to_chat(character, span_alertsyndie("I am a [role_instance.name]!"))
	to_chat(character, span_notice(wave.greet_text))
	to_chat(character, span_notice(role_instance.greet_text))

	var/datum/antagonist/antag_role = migrant_job?.antag_role || role_instance?.antag_datum
	if(antag_role)
		character.mind.add_antag_datum(antag_role)
		character.forceMove(spawn_on_location)

	if(!ishuman(character))
		return

	var/mob/living/carbon/human/human_character = character

	var/fakekey = get_display_ckey(human_character.ckey)
	GLOB.character_list[human_character.mobid] = "[fakekey] was [human_character.real_name] ([migrant_job.title])<BR>"
	GLOB.character_ckey_list[human_character.real_name] = human_character.ckey
	log_character("[human_character.ckey] ([fakekey]) - [human_character.real_name] - [migrant_job.title]")

	var/datum/migrant_role/advclass/adv_migrant = role_instance
	if(istype(adv_migrant))
		if(adv_migrant.advclass_cat_rolls)
			SSrole_class_handler.setup_class_handler(human_character, adv_migrant.advclass_cat_rolls)
			human_character.hugboxify_for_class_selection()
		else if(GLOB.adventurer_hugbox_duration)
			addtimer(CALLBACK(human_character, TYPE_PROC_REF(/mob/living/carbon/human, adv_hugboxing_start)), 1)

/datum/controller/subsystem/migrants/proc/get_priority_players(list/players, role_type, wave_type)
	var/list/priority = list()
	var/list/triumph_weighted = list()

	for(var/client/client as anything in players)
		var/base_priority = 0
		var/triumph_bonus = 0
		//Standard role preference priority
		if(role_type in client.prefs.migrant.role_preferences)
			base_priority = 1
			triumph_bonus = get_triumph_selection_bonus(client, wave_type) //Only gains the Triumph Bonus if they want that role.

		var/final_priority = base_priority + triumph_bonus

		if(final_priority > 0)
			triumph_weighted[client] = final_priority

	//Check if all triumph_weighted values are equal
	var/all_equal = TRUE
	var/first_val = -1

	if(length(triumph_weighted))
		first_val = triumph_weighted[1]
		for(var/client/client in triumph_weighted)
			// Check if anything is not equal to the first value in the list
			if(triumph_weighted[client] != first_val)
				all_equal = FALSE
				break

	//Convert weighted list to prioritized list
	while(length(triumph_weighted))
		var/client/highest = null
		var/highest_priority = 0

		for(var/client/client in triumph_weighted)
			if(triumph_weighted[client] > highest_priority)
				highest_priority = triumph_weighted[client]
				highest = client

		if(highest)
			priority += highest
			triumph_weighted -= highest

	//Shuffle only if all have equal priority
	if(all_equal)
		priority = shuffle(priority)

	return priority


/datum/controller/subsystem/migrants/proc/can_be_role(client/player, role_type)
	if(!player || !player.prefs)
		return FALSE
	var/datum/migrant_role/role = MIGRANT_ROLE(role_type)
	if(!role || is_migrant_banned(player.ckey, role.name) || is_race_banned(player.ckey, player.prefs.pref_species.id))
		return FALSE

	var/datum/job/migrant_job = SSjob.GetJobType(role.migrant_job)
	if(!migrant_job)
		return FALSE
	if(migrant_job.banned_leprosy && is_misc_banned(player.ckey, BAN_MISC_LEPROSY))
		return FALSE
	if(migrant_job.banned_lunatic && is_misc_banned(player.ckey, BAN_MISC_LUNATIC))
		return FALSE

	var/datum/preferences/prefs = player.prefs
	if(!player.prefs.allowed_respawn())
		return FALSE

	var/player_species_id_job = prefs.pref_species.id_override ? prefs.pref_species.id_override : prefs.pref_species.id

	var/can_join = TRUE
	if(length(migrant_job.allowed_races) && !(player_species_id_job in migrant_job.allowed_races))
		if(!(player.has_triumph_buy(TRIUMPH_BUY_RACE_ALL)))
			to_chat(player, span_warning("Wrong species. Your prioritized role only allows [migrant_job.allowed_races.Join(", ")]."))
			can_join = FALSE

	if(length(migrant_job.blacklisted_species) && (player_species_id_job in migrant_job.blacklisted_species))
		if(!(player.has_triumph_buy(TRIUMPH_BUY_RACE_ALL)))
			to_chat(player, span_warning("Wrong species. Your prioritized role disallows [migrant_job.blacklisted_species.Join(", ")]."))
			can_join = FALSE

	if(length(migrant_job.allowed_sexes) && !(prefs.gender in migrant_job.allowed_sexes))
		to_chat(player, span_warning("Wrong gender. Your prioritized role only allows [migrant_job.allowed_sexes.Join(", ")]."))
		can_join = FALSE
	if(length(migrant_job.allowed_ages) && !(prefs.age in migrant_job.allowed_ages))
		to_chat(player, span_warning("Wrong age. Your prioritized role only allows [migrant_job.allowed_ages.Join(", ")]."))
		can_join = FALSE

	return can_join

/datum/controller/subsystem/migrants/proc/process_next_wave(dt)
	time_until_next_wave -= dt
	if(time_until_next_wave > 0)
		return
	var/wave_type = roll_wave()
	if(wave_type)
		log_game("Migrants: Rolled wave: [wave_type]")
		set_current_wave(wave_type, wave_wait_time, wave_type)

	time_until_next_wave = time_between_fail_wave

/datum/controller/subsystem/migrants/proc/roll_wave()
	var/list/available_weighted_waves = list()
	var/active_migrants = get_active_migrant_amount()
	var/active_players = get_round_active_players()

	// Check for auto-triggered waves first
	var/auto_wave = check_triumph_threshold_waves()
	if(auto_wave)
		return auto_wave

	// Build available waves with triumph-modified weights
	for(var/wave_type in GLOB.migrant_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		if(!wave.can_roll)
			continue
		if(!isnull(wave.min_active) && active_migrants < wave.min_active)
			continue
		if(!isnull(wave.max_active) && active_migrants > wave.max_active)
			continue
		if(!isnull(wave.min_pop) && active_players < wave.min_pop)
			continue
		if(!isnull(wave.max_pop) && active_players > wave.max_pop)
			continue
		if(!isnull(wave.max_spawns))
			var/used_wave_type = wave.type
			if(wave.shared_wave_type)
				used_wave_type = wave.shared_wave_type
			if(spawned_waves[used_wave_type] && spawned_waves[used_wave_type] >= wave.max_spawns)
				continue

		// Calculate triumph-modified weight
		var/final_weight = calculate_triumph_weight(wave)
		available_weighted_waves[wave_type] = final_weight

	if(!length(available_weighted_waves))
		return null
	return pickweight(available_weighted_waves)


/datum/controller/subsystem/migrants/proc/check_triumph_threshold_waves()
	// Find waves that have hit their triumph threshold
	var/list/threshold_waves = list()

	for(var/wave_type in GLOB.migrant_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		if(!wave.can_roll)
			continue
		if(wave.triumph_total >= wave.triumph_threshold)
			// Still need to check population/active requirements
			var/active_migrants = get_active_migrant_amount()
			var/active_players = get_round_active_players()

			if(!isnull(wave.min_active) && active_migrants < wave.min_active)
				continue
			if(!isnull(wave.max_active) && active_migrants > wave.max_active)
				continue
			if(!isnull(wave.min_pop) && active_players < wave.min_pop)
				continue
			if(!isnull(wave.max_pop) && active_players > wave.max_pop)
				continue
			if(!isnull(wave.max_spawns))
				var/used_wave_type = wave.type
				if(wave.shared_wave_type)
					used_wave_type = wave.shared_wave_type
				if(spawned_waves[used_wave_type] && spawned_waves[used_wave_type] >= wave.max_spawns)
					continue

			threshold_waves[wave_type] = wave.triumph_total

	if(!length(threshold_waves))
		return null

	// Return the wave with highest triumph investment if multiple hit threshold
	var/chosen_wave = null
	var/highest_triumph = 0
	for(var/wave_type in threshold_waves)
		if(threshold_waves[wave_type] > highest_triumph)
			highest_triumph = threshold_waves[wave_type]
			chosen_wave = wave_type

	return chosen_wave

/datum/controller/subsystem/migrants/proc/calculate_triumph_weight(datum/migrant_wave/wave)
	var/base_weight = wave.weight
	var/triumph_bonus = wave.triumph_total

	// Triumph provides a linear bonus to weight (configurable multiplier)
	var/triumph_multiplier = 2 // Each triumph point adds 2x weight
	var/final_weight = base_weight + (triumph_bonus * triumph_multiplier)

	return max(final_weight, 1) // Ensure minimum weight of 1


/datum/controller/subsystem/migrants/proc/contribute_triumph_to_wave(client/player, wave_type, amount)
	if(!player || !player.ckey)
		return FALSE

	var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
	if(!wave)
		return FALSE

	// Check if player has enough triumph
	var/current_triumph = SStriumphs.get_triumphs(player.ckey)
	if(current_triumph < amount)
		to_chat(player, span_warning("You don't have enough triumph! You have [current_triumph], need [amount]."))
		return FALSE

	// Deduct triumph from player
	player.adjust_triumphs(-amount, TRUE, "Wave influence: [wave.name]")

	// Add to wave contributions
	if(!wave.triumph_contributions[player.ckey])
		wave.triumph_contributions[player.ckey] = 0
	wave.triumph_contributions[player.ckey] += amount
	wave.triumph_total += amount

	// Track globally for selection chances
	if(!global_triumph_contributions[player.ckey])
		global_triumph_contributions[player.ckey] = list()
	if(!global_triumph_contributions[player.ckey][wave_type])
		global_triumph_contributions[player.ckey][wave_type] = 0
	global_triumph_contributions[player.ckey][wave_type] += amount

	to_chat(player, span_notice("You've contributed [amount] triumph to '[wave.name]'. Total: [wave.triumph_total]/[wave.triumph_threshold]"))

	// Announce if threshold reached
	if(wave.triumph_total >= wave.triumph_threshold)
		message_admins("TRIUMPH: Wave '[wave.name]' has reached its triumph threshold ([wave.triumph_total]/[wave.triumph_threshold]) and will be prioritized!")
		log_game("TRIUMPH: Wave '[wave.name]' reached triumph threshold via player contributions")

	return TRUE

/datum/controller/subsystem/migrants/proc/get_triumph_selection_bonus(client/player, wave_type)
	if(current_parent_wave)
		wave_type = current_parent_wave
	if(!player?.ckey)
		return 0

	if(!global_triumph_contributions[player.ckey])
		return 0

	if(!global_triumph_contributions[player.ckey][wave_type])
		return 0

	return global_triumph_contributions[player.ckey][wave_type]

/datum/controller/subsystem/migrants/proc/reset_wave_contributions(datum/migrant_wave/wave)
	if(!wave.reset_contributions_on_spawn)
		return

	// Clear contributions for this wave
	wave.triumph_contributions.Cut()
	wave.triumph_total = 0

	// Clear from global tracking
	for(var/ckey in global_triumph_contributions)
		if(global_triumph_contributions[ckey][wave.type])
			global_triumph_contributions[ckey] -= wave.type

/datum/controller/subsystem/migrants/proc/update_ui()
	for(var/client/client as anything in get_all_migrants())
		client.prefs.migrant.show_ui()

/datum/controller/subsystem/migrants/proc/get_active_migrant_amount()
	var/list/migrants = get_active_migrants()
	if(migrants)
		return migrants.len
	return 0

/datum/controller/subsystem/migrants/proc/get_stars_on_role(role_type)
	var/stars = 0
	var/list/active_migrants = get_active_migrants()
	if(active_migrants)
		for(var/client/client as anything in active_migrants)
			if(!(role_type in client.prefs.migrant.role_preferences))
				continue
			stars++
	return stars

/datum/controller/subsystem/migrants/proc/get_round_active_players()
	var/active = 0
	for(var/mob/player_mob as anything in GLOB.player_list)
		if(!player_mob.client)
			continue
		if(player_mob.stat == DEAD) //If not alive
			continue
		if(player_mob.client.is_afk()) //If afk
			continue
		if(!ishuman(player_mob))
			continue
		active++
	return active

/// Returns a list of all new_player clients with active migrant pref
/datum/controller/subsystem/migrants/proc/get_active_migrants()
	var/list/migrants = list()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(!player.client)
			continue
		if(!player.client.prefs)
			continue
		if(!player.client.prefs.migrant.active)
			continue
		migrants += player.client
	return migrants

/// Returns a list of all new_player clients
/datum/controller/subsystem/migrants/proc/get_all_migrants()
	var/list/migrants = list()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(!player.client)
			continue
		if(!player.client.prefs)
			continue
		if(!player.client.prefs.migrant?.viewer)
			continue
		migrants += player.client
	return migrants

/client/proc/admin_force_next_migrant_wave()
	set category = "GameMaster.Interactions"
	set name = "Force Migrant Wave"
	if(!holder)
		return
	. = TRUE
	var/mob/user = usr
	message_admins("Admin [key_name_admin(user)] is forcing the next migrant wave.")
	var/picked_wave_type = input(user, "Choose migrant wave to force:", "Migrants")  as null|anything in GLOB.migrant_waves
	if(!picked_wave_type)
		return
	message_admins("Admin [key_name_admin(user)] forced next migrant wave: [picked_wave_type] (Arrival: 1 Minute)")
	log_game("Admin [key_name_admin(user)] forced next migrant wave: [picked_wave_type] (Arrival: 1 Minute)")
	SSmigrants.set_current_wave(picked_wave_type, (1 MINUTES))

/proc/get_spawn_turf_for_job(jobname)
	var/list/landmarks = list()
	for(var/obj/effect/landmark/start/sloc as anything in GLOB.start_landmarks_list)
		if(!(jobname in sloc.jobspawn_override))
			continue
		landmarks += sloc
	if(!length(landmarks))
		return null
	landmarks = shuffle(landmarks)
	return get_turf(pick(landmarks))

/mob/living/carbon/human/proc/hugboxify_for_class_selection()
	advsetup = TRUE
	density = FALSE
	invisibility = INVISIBILITY_MAXIMUM
	become_blind("advsetup")
	if(GLOB.adventurer_hugbox_duration)
		adv_hugboxing_start()

/mob/living/carbon/human/proc/finish_class_hugbox()
	advsetup = FALSE
	density = initial(density)
	invisibility = initial(invisibility)
	cure_blind("advsetup")

	var/atom/movable/screen/advsetup/GET_IT_OUT = locate() in hud_used?.static_inventory //locate() still iterates over contents
	if(GET_IT_OUT)
		qdel(GET_IT_OUT)

/mob/living/carbon/human/proc/grant_lit_torch()
	var/obj/item/flashlight/flare/torch/torch = new()
	torch.spark_act()
	put_in_hands(torch, forced = TRUE)
