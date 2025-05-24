SUBSYSTEM_DEF(migrants)
	name = "Migrants"
	wait = 2 SECONDS
	runlevels = RUNLEVEL_GAME
	var/wave_number = 1
	var/current_wave = null
	var/time_until_next_wave = 30 MINUTES
	var/wave_timer = 0

	var/time_between_waves = 20 MINUTES
	var/time_between_fail_wave = 5 MINUTES
	var/wave_wait_time = 5 MINUTES

	var/list/spawned_waves = list()


/datum/controller/subsystem/migrants/Initialize()
	return ..()

/datum/controller/subsystem/migrants/fire(resumed)
	process_migrants(2 SECONDS)
	update_ui()

/datum/controller/subsystem/migrants/proc/set_current_wave(wave_type, time)
	current_wave = wave_type
	wave_timer = time

/datum/controller/subsystem/migrants/proc/process_migrants(dt)
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
	// Unset some values, increment wave number if success
	if(success)
		wave_number++
	var/datum/migrant_wave/wave = MIGRANT_WAVE(current_wave)
	set_current_wave(null, 0)
	if(success)
		time_until_next_wave = time_between_waves
	else
		if(wave.downgrade_wave)
			set_current_wave(wave.downgrade_wave, wave_wait_time)
		else
			time_until_next_wave = time_between_fail_wave

/datum/controller/subsystem/migrants/proc/try_spawn_wave()
	var/datum/migrant_wave/wave = MIGRANT_WAVE(current_wave)
	/// Create initial assignment list
	var/list/assignments = list()
	/// Populate it
	for(var/role_type in wave.roles)
		var/amount = wave.roles[role_type]
		for(var/i in 1 to amount)
			assignments += new /datum/migrant_assignment(role_type)
	/// Shuffle assignments so role rolling is not consistent
	assignments = shuffle(assignments)

	var/list/active_migrants = get_active_migrants()
	active_migrants = shuffle(active_migrants)

	var/list/picked_migrants = list()

	if(!length(active_migrants))
		return FALSE
	/// Try to assign priority players to positions
	for(var/datum/migrant_assignment/assignment as anything in assignments)
		if(!length(active_migrants))
			break // Out of migrants, we're screwed and will fail
		if(assignment.client)
			continue
		var/list/priority = get_priority_players(active_migrants, assignment.role_type)
		if(!length(priority))
			continue
		var/client/picked
		priority = shuffle(priority)
		for(var/client/client as anything in priority)
			if(!can_be_role(client, assignment.role_type))
				continue
			picked = client
			break
		if(!picked)
			continue

		active_migrants -= picked
		assignment.client = picked
		picked_migrants += picked

	/// Assign rest of the players to positions
	for(var/datum/migrant_assignment/assignment as anything in assignments)
		if(!length(active_migrants))
			break // Out of migrants, we're screwed and will fail
		if(assignment.client)
			continue

		var/client/picked
		for(var/client/client as anything in active_migrants)
			if(!can_be_role(client, assignment.role_type))
				continue
			picked = client
			break
		if(!picked)
			continue

		active_migrants -= picked
		assignment.client = picked
		picked_migrants += picked

	/// Find spawn points for the assignments
	var/turf/spawn_location = get_spawn_turf_for_job(wave.spawn_landmark)
	var/atom/fallback_location = spawn_location

	var/list/turfs = get_safe_turfs_around_location(spawn_location)
	for(var/i in 1 to turfs.len)
		var/turf/turf = turfs[i]
		if(assignments.len < i)
			break
		var/datum/migrant_assignment/assignment = assignments[i]
		assignment.spawn_location = turf

	/// See if anything went wrong and return FALSE if it did
	for(var/datum/migrant_assignment/assignment as anything in assignments)
		if(!assignment.client)
			return FALSE
		if(!assignment.spawn_location)
			assignment.spawn_location = fallback_location

	/// At this point everything is GOOD and SWELL, we want to spawn the wave

	/// Unset their pref so if they respawn they wont get yoinked into migrants immediately
	for(var/client/client as anything in picked_migrants)
		client.prefs.migrant.post_spawn()

	/// Spawn the migrants, hooray
	for(var/datum/migrant_assignment/assignment as anything in assignments)
		spawn_migrant(wave, assignment, wave.spawn_on_location)

	// Increment wave spawn counter
	var/used_wave_type = wave.type
	if(wave.shared_wave_type)
		used_wave_type = wave.shared_wave_type
	if(!spawned_waves[used_wave_type])
		spawned_waves[used_wave_type] = 0
	spawned_waves[used_wave_type] += 1

	message_admins("MIGRANTS: Spawned wave: [wave.name] (players: [assignments.len]) at [ADMIN_VERBOSEJMP(spawn_location)]")

	unset_all_active_migrants()

	return TRUE

/datum/controller/subsystem/migrants/proc/get_status_line()
	var/string = ""
	if(current_wave)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(current_wave)
		string = "[wave.name] ([get_active_migrant_amount()]/[wave.get_roles_amount()]) - [wave_timer / (1 SECONDS)]s"
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

/datum/controller/subsystem/migrants/proc/spawn_migrant(datum/migrant_wave/wave, datum/migrant_assignment/assignment, spawn_on_location)
	//TODO
	var/rank = "Migrant"
	var/mob/dead/new_player/newplayer = assignment.client.mob

	/// copy pasta from AttemptLateSpawn(rank) further on TODO put it in a proc and use in both places

	var/datum/job/job = SSjob.GetJob(rank)

	SSjob.AssignRole(newplayer, job, 1)

	newplayer.mind.late_joiner = TRUE

	// var/atom/destination = newplayer.mind.assigned_role.get_latejoin_spawn_point()
	// if(!destination)
	// 	CRASH("Failed to find a latejoin spawn point.")
	var/mob/living/character = newplayer.create_character(assignment.spawn_location) //very naive, this is going to error
	character.islatejoin = TRUE
	if(!character)
		CRASH("Failed to create a character for migrants.")
	newplayer.transfer_character()

	SSjob.EquipRank(character, job, character.client)
	SSticker.minds += character.mind
	var/mob/living/carbon/human/humanc
	if(ishuman(character))
		humanc = character	//Let's retypecast the var to be human,

	if(humanc)
		var/fakekey = get_display_ckey(character.ckey)
		GLOB.character_list[character.mobid] = "[fakekey] was [character.real_name] ([job.title])<BR>"
		GLOB.character_ckey_list[character.real_name] = character.ckey
		log_character("[character.ckey] ([fakekey]) - [character.real_name] - [job.title]")

	GLOB.joined_player_list += character.ckey
	GLOB.respawncounts[character.ckey] += 1

	/// And back to non copy pasta code

	var/datum/migrant_role/role = MIGRANT_ROLE(assignment.role_type)
	character.migrant_type = assignment.role_type

	if(spawn_on_location)
		character.forceMove(assignment.spawn_location)

	to_chat(character, span_alertsyndie("I am a [role.name]!"))
	to_chat(character, span_notice(wave.greet_text))
	to_chat(character, span_notice(role.greet_text))

	if(role.outfit)
		var/datum/outfit/outfit = new role.outfit()
		outfit.equip(character)

	if(role.antag_datum)
		character.mind.add_antag_datum(role.antag_datum)

	// Adding antag datums can move your character to places, so here's a bandaid
	if(spawn_on_location)
		character.forceMove(assignment.spawn_location)

	if(role.grant_lit_torch)
		grant_lit_torch(character)

	role.after_spawn(character)

	if(role.advclass_cat_rolls)
		SSrole_class_handler.setup_class_handler(character, role.advclass_cat_rolls)
		hugboxify_for_class_selection(character)
	else
		if(GLOB.adventurer_hugbox_duration)
			addtimer(CALLBACK(character, TYPE_PROC_REF(/mob/living/carbon/human, adv_hugboxing_start)), 1)

/datum/controller/subsystem/migrants/proc/get_priority_players(list/players, role_type)
	var/list/priority = list()
	for(var/client/client as anything in players)
		if(!(role_type in client.prefs.migrant.role_preferences))
			continue
		priority += client
	return priority

/datum/controller/subsystem/migrants/proc/can_be_role(client/player, role_type)
	var/datum/migrant_role/role = MIGRANT_ROLE(role_type)
	if(!player)
		return FALSE
	if(!player.prefs)
		return FALSE
	var/datum/preferences/prefs = player.prefs
	if(role.banned_leprosy && is_misc_banned(player.ckey, BAN_MISC_LEPROSY))
		return FALSE
	if(role.banned_lunatic && is_misc_banned(player.ckey, BAN_MISC_LUNATIC))
		return FALSE
	if(!player.prefs.allowed_respawn())
		return FALSE
	if(is_migrant_banned(player.ckey, role.name))
		return FALSE
	if(role.allowed_races && !(prefs.pref_species.name in role.allowed_races))
		if(!(player.triumph_ids.Find("race_all")))
			return FALSE
	if(role.allowed_sexes && !(prefs.gender in role.allowed_sexes))
		return FALSE
	if(role.allowed_ages && !(prefs.age in role.allowed_ages))
		return FALSE
	return TRUE

/datum/controller/subsystem/migrants/proc/process_next_wave(dt)
	time_until_next_wave -= dt
	if(time_until_next_wave > 0)
		return
	var/wave_type = roll_wave()
	if(wave_type)
		log_game("Migrants: Rolled wave: [wave_type]")
		set_current_wave(wave_type, wave_wait_time)

	time_until_next_wave = time_between_fail_wave

/datum/controller/subsystem/migrants/proc/roll_wave()
	var/list/available_weighted_waves = list()

	var/active_migrants = get_active_migrant_amount()
	var/active_players = get_round_active_players()

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
		available_weighted_waves[wave_type] = wave.weight

	if(!length(available_weighted_waves))
		return null
	return pickweight(available_weighted_waves)

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

/// Returns a list of all newplayer clients with active migrant pref
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

/// Returns a list of all newplayer clients
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
	set category = "GameMaster"
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

/proc/hugboxify_for_class_selection(mob/living/carbon/human/character)
	character.advsetup = 1
	character.invisibility = INVISIBILITY_MAXIMUM
	character.become_blind("advsetup")

	if(GLOB.adventurer_hugbox_duration)
		///FOR SOME FUCKING REASON THIS REFUSED TO WORK WITHOUT A FUCKING TIMER IT JUST FUCKED SHIT UP
		addtimer(CALLBACK(character, TYPE_PROC_REF(/mob/living/carbon/human, adv_hugboxing_start)), 1)

/proc/grant_lit_torch(mob/living/carbon/human/character)
	var/obj/item/flashlight/flare/torch/torch = new()
	torch.spark_act()
	character.put_in_hands(torch, forced = TRUE)
