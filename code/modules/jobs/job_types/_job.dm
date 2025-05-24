/datum/job
	/// The name of the job , used for preferences, bans and more. Make sure you know what you're doing before changing this.
	var/title = "NOPE"
	/// The title of this job given to female mobs. Fluff, not as important as [var/title].
	var/f_title = null
	/// When joining the round, this text will be shown to the player.
	var/tutorial = null

	/// Determines who can demote this position
	var/department_head = list()

	/// Tells the given channels that the given mob is the new department head. See communications.dm for valid channels.
	var/list/head_announce = null

	//Bitflags for the job
	var/flag = NONE
	var/department_flag = NONE
	var/auto_deadmin_role_flags = NONE

	//Players will be allowed to spawn in as jobs that are set to "Station"
	var/faction = FACTION_NONE

	/// How many players can be this job
	var/total_positions = 0

	/// How many players can spawn in as this job rondstart
	var/spawn_positions = 0

	/// How many players currently have this job
	var/current_positions = 0

	/// Whether this job clears a slot when you get a rename prompt.
	var/antag_job = FALSE

	/// Selection screen color
	var/selection_color = "#dbdce3"

	/// What kind of mob type joining players with this job as their assigned role are spawned as.
	var/spawn_type = /mob/living/carbon/human

	/// If this is set to TRUE, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify

	/// If you have the use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0

	var/outfit = null
	var/outfit_female = null

	var/exp_requirements = 0

	var/exp_type = ""
	var/exp_type_department = ""

	//The amount of good boy points playing this role will earn you towards a higher chance to roll antagonist next round
	//can be overridden by antag_rep.txt config
	var/antag_rep = 10

	var/paycheck = PAYCHECK_MINIMAL
	var/paycheck_department = ACCOUNT_CIV

	var/list/mind_traits // Traits added to the mind of the mob assigned this job

	var/display_order = JOB_DISPLAY_ORDER_CAPTAIN

	/// All values = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK)
	var/job_flags = NONE

	///Levels unlocked at roundstart in physiology
	var/list/roundstart_experience

	//allowed sex/race for picking
	var/list/allowed_sexes = list(MALE,FEMALE)
	var/list/allowed_races
	var/list/allowed_patrons
	var/list/allowed_ages = ALL_AGES_LIST

	/// Innate skill levels unlocked at roundstart. Format is list(/datum/skill/foo = SKILL_EXP_NOVICE) with exp as an integer or as per code/_DEFINES/skills.dm
	var/list/skills

	var/list/spells

	var/list/jobstats
	var/list/jobstats_f

	var/whitelist_req = FALSE //!

	var/banned_leprosy = TRUE
	var/banned_lunatic = TRUE

	var/bypass_lastclass = FALSE

	var/list/peopleiknow = list()
	var/list/peopleknowme = list()

	var/min_pq = -999

	var/give_bank_account = FALSE

	var/can_random = TRUE

	/// Some jobs have unique combat mode music, because why not?
	var/cmode_music

	/// This job always shows on latechoices
	var/always_show_on_latechoices = FALSE

	/// This job has a cooldown if you died in it and attempt to rejoin as it
	var/same_job_respawn_delay = FALSE

	/// This job re-opens slots if someone dies as it
	var/job_reopens_slots_on_death = FALSE

/*
	How this works, its CTAG_DEFINE = amount_to_attempt_to_role
	EX: advclass_cat_rolls = list(CTAG_PILGRIM = 5, CTAG_ADVENTURER = 5)
	You will still need to contact the subsystem though
*/
	var/list/advclass_cat_rolls

	var/is_foreigner = FALSE

	var/datum/charflaw/forced_flaw

	var/shows_in_list = TRUE

	///can we have apprentices?
	var/can_have_apprentices = TRUE
	///the skills and % of xp they should transfer over to apprentices as they are trained.
	var/list/trainable_skills = list()
	///the maximum amount of apprentices that the owner can have
	var/max_apprentices = 1
	///if this is set its the name bestowed to the new apprentice otherwise its just name the [job_name] apprentice.
	var/apprentice_name
	///do we magic?
	var/magic_user = FALSE
	///Do we get passive income every day from our noble estates?
	var/noble_income = FALSE

	var/static/list/actors_list_blacklist = list(
		/datum/job/adventurer,
		/datum/job/pilgrim,
	)

/datum/job/New()
	. = ..()
	if(give_bank_account)
		for(var/X in GLOB.peasant_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.serf_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.company_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.church_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.garrison_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.noble_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.apprentices_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.youngfolk_positions)
			peopleiknow += X
			peopleknowme += X

/datum/job/proc/special_job_check(mob/dead/new_player/player)
	return TRUE

/// Executes after the mob has been spawned in the map.
/// Client might not be yet in the mob, and is thus a separate variable.
/datum/job/proc/after_spawn(mob/living/spawned, client/player_client)
	SHOULD_CALL_PARENT(TRUE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_JOB_AFTER_SPAWN, src, spawned, player_client)

	if(magic_user)
		spawned.mana_pool.set_intrinsic_recharge(MANA_ALL_LEYLINES)

	for(var/trait in mind_traits)
		ADD_TRAIT(spawned.mind, trait, JOB_TRAIT)

	if(!ishuman(spawned))
		return

	var/list/roundstart_experience

	roundstart_experience = skills

	if(roundstart_experience)
		var/mob/living/carbon/human/experiencer = spawned
		for(var/i in roundstart_experience)
			experiencer.adjust_experience(i, roundstart_experience[i], TRUE)

	/* V: PAST THIS POINT */

	if(is_foreigner)
		ADD_TRAIT(spawned, TRAIT_FOREIGNER, TRAIT_GENERIC)

	if(can_have_apprentices)
		spawned.set_apprentice_training_skills(trainable_skills.Copy())
		spawned.set_max_apprentices(max_apprentices)
		spawned.set_apprentice_name(apprentice_name)

	add_spells(spawned)

	var/list/used_stats = ((spawned.gender == FEMALE) && jobstats_f) ? jobstats_f : jobstats
	for(var/stat_key in used_stats)
		spawned.change_stat(stat_key, used_stats[stat_key])

	for(var/X in peopleknowme)
		for(var/datum/mind/MF in get_minds(X))
			spawned.mind.person_knows_me(MF)
	for(var/X in peopleiknow)
		for(var/datum/mind/MF in get_minds(X))
			spawned.mind.i_know_person(MF)

	if(spawned.islatejoin && (job_flags & JOB_ANNOUNCE_ARRIVAL)) //to be moved somewhere more appropriate
		var/used_title = get_informed_title(spawned)
		scom_announce("[spawned.real_name] the [used_title] arrives from [SSmapping.config.immigrant_origin].")

	if(give_bank_account)
		if(give_bank_account > 1)
			SStreasury.create_bank_account(spawned, give_bank_account)
		else
			SStreasury.create_bank_account(spawned)
		if(noble_income)
			SStreasury.noble_incomes[spawned] = noble_income

	if(job_flags & JOB_SHOW_IN_CREDITS)
		SScrediticons.processing += spawned

	if(cmode_music)
		DIRECT_OUTPUT(spawned, load_resource(cmode_music, -1)) //preload their combat mode music
		spawned.cmode_music = cmode_music

	if(!(type in actors_list_blacklist)) //don't show these.
		GLOB.actors_list[spawned.mobid] = "[spawned.real_name] as [spawned.mind.assigned_role.get_informed_title(spawned)]<BR>"

	var/mob/living/carbon/human/humanguy = spawned

	var/datum/job/target_job = humanguy?.mind?.assigned_role
	if(target_job?.forced_flaw)
		if(humanguy.charflaw)
			QDEL_NULL(humanguy.charflaw)
		humanguy.charflaw = new target_job.forced_flaw.type(humanguy)

	if(humanguy.charflaw)
		humanguy.charflaw.after_spawn(humanguy)

	if(length(advclass_cat_rolls))
		humanguy.advsetup = TRUE
		humanguy.invisibility = INVISIBILITY_MAXIMUM
		humanguy.become_blind("advsetup")

/datum/job/proc/announce_job(mob/living/joining_mob)
	if(head_announce)
		announce_head(joining_mob, head_announce)

/datum/job/proc/announce_head(mob/living/carbon/human/H, channels) //tells the given channel that the given mob is the new department head. See communications.dm for valid channels.
	//RT: UNIMPLEMENTED

//Used for a special check of whether to allow a client to latejoin as this job.
/datum/job/proc/special_check_latejoin(client/C)
	return TRUE

/datum/job/proc/GetAntagRep()
	. = CONFIG_GET(keyed_list/antag_rep)[lowertext(title)]
	if(. == null)
		return antag_rep

/mob/living/proc/on_job_equipping(datum/job/equipping)
	return

/mob/living/carbon/human/on_job_equipping(datum/job/equipping)
	//could be a deprecated system? it was here before the refactor too, so
	var/datum/bank_account/bank_account = new(real_name, equipping)
	bank_account.payday(STARTING_PAYCHECKS, TRUE)
	account_id = bank_account.account_id

	dress_up_as_job(equipping)

/mob/living/proc/dress_up_as_job(datum/job/equipping, visual_only = FALSE)
	return

/mob/living/carbon/human/dress_up_as_job(datum/job/equipping, visual_only = FALSE)
	dna.species.pre_equip_species_outfit(equipping, src, visual_only)
	var/datum/outfit/chosen_outfit = (gender == FEMALE && equipping.outfit_female) ? equipping.outfit_female : equipping.outfit
	equipOutfit(chosen_outfit, visual_only)

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	if(available_in_days(C) == 0)
		return TRUE	//Available in 0 days = available right now = player is old enough to play.
	return FALSE


/datum/job/proc/available_in_days(client/C)
	if(!C)
		return 0
	if(!CONFIG_GET(flag/use_age_restriction_for_jobs))
		return 0
	if(!SSdbcore.Connect())
		return 0 //Without a database connection we can't get a player's age so we'll assume they're old enough for all jobs
	if(!isnum(minimal_player_age))
		return 0

	return max(0, minimal_player_age - C.player_age)

//Unused as of now
/datum/job/proc/config_check()
	return TRUE

/datum/outfit/job
	name = "Standard Gear"
	var/jobtype = null

	/// List of patrons we are allowed to use
	var/list/allowed_patrons
	/// Default patron in case the patron is not allowed
	var/datum/patron/default_patron
	///this is our bitflag
	var/job_bitflag = NONE

/datum/outfit/job/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	var/datum/patron/old_patron = H.patron // Store the initial patron selected before spawning on this var
	if(length(allowed_patrons) && (!old_patron || !(old_patron.type in allowed_patrons)))
		var/list/datum/patron/possiblegods = list()
		var/list/datum/patron/godlist = list()
		for(var/god in GLOB.patronlist)
			if(!(god in allowed_patrons))
				continue
			possiblegods |= god
			var/datum/patron/P = GLOB.patronlist[god]
			if(P.associated_faith == old_patron.associated_faith) //Prioritize choosing a possible patron within our pantheon
				godlist |= god
		if(length(godlist))
			H.set_patron(default_patron || pick(godlist))
		else
			H.set_patron(default_patron || pick(possiblegods))
		if(old_patron != H.patron) // If the patron we selected first does not match the patron we end up with, display the message.
			to_chat(H, "<span class='warning'>I've followed the word of [old_patron.display_name ? old_patron.display_name : old_patron] in my younger years, but the path I tread todae has accustomed me to [H.patron.display_name? H.patron.display_name : H.patron].")

	if(H.mind)
		if(H.dna)
			H.dna.species.random_underwear(H.gender)
			if(H.dna.species)
				if(H.dna.species.id == "elf")
					H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
				if(H.dna.species.id == "dwarf")
					H.adjust_skillrank(/datum/skill/labor/mining, 1, TRUE)
	H.underwear_color = null
	H.update_body()

/datum/outfit/job/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/datum/job/J = SSjob.GetJobType(jobtype)
	if(!J)
		J = SSjob.GetJob(H.job)

	if(H.mind)
		H.mind?.job_bitflag = job_bitflag
		if(H.familytree_pref != FAMILY_NONE && !visualsOnly && !H.family_datum)
			SSfamilytree.AddLocal(H, H.familytree_pref)
			H.ShowFamilyUI(TRUE)
		if(H.ckey)
			if(check_crownlist(H.ckey))
				H.mind.special_items["Champion Circlet"] = /obj/item/clothing/head/crown/sparrowcrown
			give_special_items(H)
	for(var/list_key in SStriumphs.post_equip_calls)
		var/datum/triumph_buy/thing = SStriumphs.post_equip_calls[list_key]
		thing.on_activate(H)
	return

/// Returns an atom where the mob should spawn in.
/datum/job/proc/get_roundstart_spawn_point()
	if(length(GLOB.jobspawn_overrides[title]))
		return pick(GLOB.jobspawn_overrides[title])
	var/obj/effect/landmark/start/spawn_point = get_default_roundstart_spawn_point()
	if(!spawn_point) //if there isn't a spawnpoint send them to latejoin, if there's no latejoin go yell at your mapper
		return get_latejoin_spawn_point()
	return spawn_point

/// Handles finding and picking a valid roundstart effect landmark spawn point, in case no uncommon different spawning events occur.
/datum/job/proc/get_default_roundstart_spawn_point()
	for(var/obj/effect/landmark/start/spawn_point as anything in GLOB.start_landmarks_list)
		if(spawn_point.name != title)
			continue
		. = spawn_point
		if(spawn_point.used) //so we can revert to spawning them on top of eachother if something goes wrong
			continue
		spawn_point.used = TRUE
		break
	if(!.)
		log_world("Couldn't find a round start spawn point for [title]")

/// Finds a valid latejoin spawn point, checking for events and special conditions.
/datum/job/proc/get_latejoin_spawn_point()
	if(length(GLOB.jobspawn_overrides[title]))
		return pick(GLOB.jobspawn_overrides[title])
	if(length(SSjob.latejoin_trackers))
		return pick(SSjob.latejoin_trackers)
	return SSjob.get_last_resort_spawn_points()


/// Called after a successful latejoin spawn.
/datum/job/proc/after_latejoin_spawn(mob/living/spawning)
	SHOULD_CALL_PARENT(TRUE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_JOB_AFTER_LATEJOIN_SPAWN, src, spawning)

/// Spawns the mob to be played as, taking into account preferences and the desired spawn point.
/datum/job/proc/get_spawn_mob(client/player_client, atom/spawn_point)
	var/mob/living/spawn_instance

	spawn_instance = new spawn_type(player_client.mob.loc)
	spawn_point.JoinPlayerHere(spawn_instance, TRUE)
	spawn_instance.apply_prefs_job(player_client, src)
	if(!player_client)
		qdel(spawn_instance)
		return // Disconnected while checking for the appearance ban.
	return spawn_instance


/// Applies the preference options to the spawning mob, taking the job into account. Assumes the client has the proper mind.
/mob/living/proc/apply_prefs_job(client/player_client, datum/job/job)

/mob/living/carbon/human/apply_prefs_job(client/player_client, datum/job/job)
	var/fully_randomize = is_banned_from(player_client.ckey, "Appearance")
	if(!player_client)
		return // Disconnected while checking for the appearance ban.
	if(fully_randomize)
		player_client.prefs.randomise_appearance_prefs()
		player_client.prefs.apply_prefs_to(src)
		//V: port anonymous themes?
	else
		var/is_antag = (player_client.mob.mind in GLOB.pre_setup_antags)
		player_client.prefs.safe_transfer_prefs_to(src, TRUE, is_antag)
		if(CONFIG_GET(flag/force_random_names))
			player_client.prefs.real_name = player_client.prefs.pref_species.random_name(player_client.prefs.gender, TRUE)
	dna.update_dna_identity()

/* ROGUETOWN */

/datum/job/proc/adjust_current_positions(offset)
	if((current_positions + offset) < 0)
		message_admins("Something was about to set current_positions for [title] to less than zero! Please send the stack trace to a developer")
		stack_trace("tried to adjust current positions to less-than-zero")

	current_positions = max(current_positions + offset, 0)

/datum/job/proc/add_spells(mob/living/H)
	if(spells && H.mind)
		for(var/S in spells)
			if(H.mind.has_spell(S))
				continue
			H.mind.AddSpell(new S)

/datum/job/proc/remove_spells(mob/living/H)
	if(spells && H.mind)
		for(var/S in spells)
			if(!H.mind.has_spell(S))
				continue
			H.mind.RemoveSpell(S)

/datum/job/proc/get_informed_title(mob/mob)
	if(mob.gender == FEMALE && f_title)
		return f_title

	return title
