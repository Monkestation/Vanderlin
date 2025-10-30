/datum/job
	///If the job is disabled/enabled for preferences
	var/enabled = TRUE
	/// The name of the job , used for preferences, bans and more. Make sure you know what you're doing before changing this.
	var/title = "NOPE"
	/// Visual title override
	var/title_override = null
	/// The title of this job given to female mobs. Fluff, not as important as [var/title].
	var/f_title = null
	/// Used if the job gets switched later to something else.
	var/datum/job/parent_job
	/// When joining the round, this text will be shown to the player.
	var/tutorial = null

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

	///How many slots were open in this round. Used to prevent slots locking with decreasing amount of alive players
	var/total_positions_so_far = 0

	///If the roles will scale depending on the amount of players, example : adventurer, only for jobs that are not in the FACTION_TOWN
	var/scales = FALSE

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

	/// Traits added to the mind of the mob assigned this job
	var/list/mind_traits

	/// Traits added to the mob assigned to this job
	var/list/traits

	/// Languages granted to the mob assigned to this job
	var/list/languages

	var/display_order = JDO_DEFAULT

	/// All values = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK)
	var/job_flags = JOB_SHOW_IN_ACTOR_LIST

	// Pevent picking
	/// Sexes allowed to be this job
	var/list/allowed_sexes = list(MALE, FEMALE)
	/// Species allowed to be this job
	var/list/allowed_races = RACES_PLAYER_ALL
	/// Ages allowed to be this job
	var/list/allowed_ages = ALL_AGES_LIST

	// Change values
	/// Patrons allowed for this job, sets to a random one in this list if list has values
	var/list/allowed_patrons
	/// Default patron in case the patron is not allowed
	var/datum/patron/default_patron

	/// Voicepack to grant to males
	var/datum/voicepack/voicepack_m
	/// Voicepack to grant to females
	var/datum/voicepack/voicepack_f

	/// Stats given to the job in the form of list(STA_X = value)
	var/list/jobstats

	/// Skill levels granted at roundstart.
	/// Possibly modified by species.
	/// Basic format is list(/datum/skill/foo = value).
	/// Supports (/datum/skill/bar = list(value, clamp)).
	var/list/skills

	/// Innate spells that get removed when the job is removed
	var/list/spells

	/// Spell points to give/take to the mob
	var/spell_points

	/// Upper number of attunements to grant
	var/attunements_max

	/// Lower number of attunemnets to grant
	var/attunements_min

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

	/**
	 *	How this works, its CTAG_DEFINE = amount_to_attempt_to_role
	 *	EX: advclass_cat_rolls = list(CTAG_PILGRIM = 5, CTAG_ADVENTURER = 5)
	 *	You will still need to contact the subsystem though
	 */
	var/list/advclass_cat_rolls

	var/is_foreigner = FALSE

	var/is_recognized = FALSE // For foreigners who are recognized.

	var/datum/charflaw/forced_flaw

	var/shows_in_list = TRUE

	/// can we have apprentices?
	var/can_have_apprentices = TRUE
	/// the skills and % of xp they should transfer over to apprentices as they are trained.
	var/list/trainable_skills = list()
	/// the maximum amount of apprentices that the owner can have
	var/max_apprentices = 1
	/// if this is set its the name bestowed to the new apprentice otherwise its just name the [job_name] apprentice.
	var/apprentice_name
	/// do we magic?
	var/magic_user = FALSE
	/// Do we get passive income every day from our noble estates?
	var/noble_income = FALSE

	/// Antagonist role to grant with this job
	var/datum/antagonist/antag_role

	/// Job bitflag for storyteller
	var/job_bitflag = NONE

	/// Blacklisted from the actor

	var/static/list/actors_list_blacklist = list(
		/datum/job/adventurer,
		/datum/job/pilgrim,
	)

	///list of job packs we select from during job setup
	var/list/job_packs
	var/pack_title = "JOB PACKS"
	var/pack_message = "Choose a job pack"

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
		for(var/X in GLOB.inquisition_positions)
			peopleiknow += X
			peopleknowme += X

/datum/job/proc/special_job_check(mob/dead/new_player/player)
	return TRUE

// I hate this codebase. Required due to patron handling needing patron to be set before outfits.
// If that stops being the case put this back in after_spawn()
/// Things that must be done before outfit is equipped in EquipRank()
/datum/job/proc/pre_outfit_equip(mob/living/carbon/human/spawned, client/player_client)
	SHOULD_CALL_PARENT(TRUE)

	adjust_patron(spawned)

/// Executes after the mob has been spawned in the map.
/// Client might not be yet in the mob, and is thus a separate variable.
/datum/job/proc/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	SHOULD_CALL_PARENT(TRUE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_JOB_AFTER_SPAWN, src, spawned, player_client)

	if(!ishuman(spawned))
		return

	if(magic_user)
		spawned.mana_pool.set_intrinsic_recharge(MANA_ALL_LEYLINES)

	for(var/trait in mind_traits)
		ADD_TRAIT(spawned.mind, trait, JOB_TRAIT)

	for(var/trait in traits)
		ADD_TRAIT(spawned, trait, JOB_TRAIT)

	for(var/datum/language/to_learn as anything in languages)
		spawned.grant_language(to_learn)

	if(is_foreigner)
		ADD_TRAIT(spawned, TRAIT_FOREIGNER, TRAIT_GENERIC)

	if(is_recognized)
		ADD_TRAIT(spawned, TRAIT_RECOGNIZED, TRAIT_GENERIC)

	if(can_have_apprentices)
		spawned.set_apprentice_training_skills(trainable_skills.Copy())
		spawned.set_max_apprentices(max_apprentices)
		spawned.set_apprentice_name(apprentice_name)

	add_spells(spawned)
	spawned.adjust_spell_points(spell_points)
	spawned.generate_random_attunements(rand(attunements_min, attunements_max))

	spawned.remove_stat_modifier("job_stats") // Reset so no inf stat
	spawned.adjust_stat_modifier_list("job_stats", jobstats)

	for(var/datum/skill/skill as anything in skills)
		var/amount_or_list = skills[skill]
		if(islist(amount_or_list))
			spawned.clamped_adjust_skillrank(skill, amount_or_list[1], amount_or_list[2], TRUE)
		else
			spawned.clamped_adjust_skillrank(skill, amount_or_list, amount_or_list, TRUE) //! This was changed because what the fuck.

	for(var/X in peopleknowme)
		for(var/datum/mind/MF in get_minds(X))
			spawned.mind.person_knows_me(MF)

	for(var/X in peopleiknow)
		for(var/datum/mind/MF in get_minds(X))
			spawned.mind.i_know_person(MF)

	// Ready up bonus
	if(!spawned.islatejoin)
		spawned.adjust_triumphs(1)
		spawned.apply_status_effect(/datum/status_effect/buff/foodbuff)
		spawned.hydration = 800 // Set higher hydration
		spawned.nutrition = 800
		to_chat(spawned, span_notice("Rising early, you made sure to eat a hearty meal before starting your dae. A true TRIUMPH!"))


	var/used_title = get_informed_title(spawned)
	if(spawned.islatejoin && (job_flags & JOB_ANNOUNCE_ARRIVAL)) //to be moved somewhere more appropriate
		scom_announce("[spawned.real_name] the [used_title] arrives from [SSmapping.config.immigrant_origin].")

	if(give_bank_account)
		if(give_bank_account > 1)
			SStreasury.create_bank_account(spawned, give_bank_account)
		else
			SStreasury.create_bank_account(spawned)
		if(noble_income)
			SStreasury.noble_incomes[spawned] = noble_income

	if(cmode_music)
		DIRECT_OUTPUT(spawned, load_resource(cmode_music, -1)) //preload their combat mode music
		spawned.cmode_music = cmode_music

	var/type_check
	if(parent_job)
		type_check = parent_job.type
		used_title = parent_job.get_informed_title(spawned)
	else
		type_check = type
	if(!(type_check in actors_list_blacklist)) //don't show these.
		GLOB.actors_list[spawned.mobid] = "[spawned.real_name] as [used_title]<BR>"

	if(forced_flaw)
		spawned.set_flaw(forced_flaw)

	if(spawned.charflaw)
		spawned.charflaw.after_spawn(spawned, player_client)

	if(antag_role && spawned.mind)
		spawned.mind.add_antag_datum(antag_role)

	if(voicepack_m)
		spawned.dna?.species.soundpack_m = new voicepack_m()

	if(voicepack_f)
		spawned.dna?.species.soundpack_f = new voicepack_f()

	/// WHY WAS THIS ON OUTFIT??? It shouldn't be HERE either
	if(spawned.familytree_pref != FAMILY_NONE && !spawned.family_datum)
		SSfamilytree.AddLocal(spawned, spawned.familytree_pref)

	var/list/owned_triumph_buys = LAZYACCESS(SStriumphs.triumph_buy_owners, player_client?.ckey)
	for(var/datum/triumph_buy/T in owned_triumph_buys)
		if(!T.activated)
			T.on_after_spawn(spawned)

	if(length(advclass_cat_rolls))
		spawned.hugboxify_for_class_selection()

	if(job_flags & JOB_SHOW_IN_CREDITS)
		SScrediticons.processing += spawned

/datum/job/proc/adjust_patron(mob/living/carbon/human/spawned)
	if(!length(allowed_patrons))
		return

	var/datum/patron/old_patron = spawned.patron
	if(old_patron?.type in allowed_patrons)
		return

	var/list/datum/patron/all_gods = list()
	var/list/datum/patron/pantheon_gods = list()
	for(var/god in GLOB.patronlist)
		if(!(god in allowed_patrons))
			continue
		all_gods |= god
		var/datum/patron/P = GLOB.patronlist[god]
		if(P.associated_faith == old_patron.associated_faith) //Prioritize choosing a possible patron within our pantheon
			pantheon_gods |= god

	if(length(pantheon_gods))
		spawned.set_patron(default_patron || pick(pantheon_gods), TRUE)
	else
		spawned.set_patron(default_patron || pick(all_gods), TRUE)

	var/datum/patron/new_patron = spawned.patron
	if(old_patron != new_patron) // If the patron we selected first does not match the patron we end up with, display the message.
		to_chat(spawned, span_warning("I've followed the word of [old_patron.display_name ? old_patron.display_name : old_patron] in my younger years, \
		but the path I tread todae has accustomed me to [new_patron.display_name ? new_patron.display_name : new_patron]."))

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
	dress_up_as_job(equipping)
	pick_job_packs(equipping)

/mob/living/carbon/human/proc/pick_job_packs(datum/job/equipping)
	if(!length(equipping.job_packs))
		return
	var/for_length = 1
	if(islist(equipping.job_packs[1]))
		for_length = length(equipping.job_packs)

	var/list/previous_picked_types = list()

	for(var/i = 1 to for_length)
		var/list/job_packs = equipping.job_packs
		if(islist(equipping.job_packs[i]))
			job_packs = equipping.job_packs[i]
		var/datum/job_pack/picked_pack
		var/list/reals = list()
		for(var/pack as anything in job_packs)
			var/datum/job_pack/real_pack = GLOB.job_pack_singletons[pack]
			if(!real_pack.can_pick_pack(src, previous_picked_types))
				continue
			reals |= real_pack
		if(!length(reals))
			return
		if(!client)
			picked_pack = GLOB.job_pack_singletons[pick(reals)]
		else
			picked_pack = browser_input_list(src, equipping.pack_title, equipping.pack_message, reals, timeout = 20 SECONDS)
		previous_picked_types |= picked_pack.type
		picked_pack.pick_pack(src)

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
	return

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

/datum/job/proc/adjust_current_positions(offset)
	if((current_positions + offset) < 0)
		message_admins("Something was about to set current_positions for [title] to less than zero! Please send the stack trace to a developer")
		stack_trace("tried to adjust current positions to less-than-zero")

	current_positions = max(current_positions + offset, 0)

/datum/job/proc/add_spells(mob/living/equipped_human)
	for(var/datum/action/cooldown/spell/spell as anything in spells)
		equipped_human.add_spell(spell, source = src)

/datum/job/proc/remove_spells(mob/living/equipped_human)
	equipped_human.remove_spells(source = src)

/datum/job/proc/get_informed_title(mob/mob)
	if(mob.admin_title)
		return mob.admin_title

	if(title_override)
		return title_override

	if(mob.gender == FEMALE && f_title)
		return f_title

	return title

/datum/job/proc/set_spawn_and_total_positions(count)
	return spawn_positions

/datum/job/proc/get_total_positions(latejoin)
	return latejoin ? total_positions : spawn_positions
