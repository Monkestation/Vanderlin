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
	/// Id for the Job.
	var/id
	//Bitflags for the job
	var/flag = NONE
	var/department_flag = NONE
	var/auto_deadmin_role_flags = NONE

	//Players will be allowed to spawn in as jobs that are set to "Station"
	var/faction = FACTION_NONE

	///Whether this job can be chosen if the player is already an antagonist
	var/antags_can_pick = TRUE

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

	/// Associated List of Exp Types and time required, 60 means 1 Hour.
	var/list/exp_requirements = list()

	/// Exp types required to UNLOCK this job
	var/list/exp_type = list()

	/// Exp types this job awards when played
	var/list/exp_types_granted = list()

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
	/// Species blacklisted from this job
	var/list/blacklisted_species = list()
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

	/// Associative list of skill - base multiplier to set for skill_holder
	var/list/skill_multipliers = list()

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

	var/datum/quirk/forced_flaw

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
/datum/job/proc/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats = TRUE)
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
		if(!spawned.has_language(to_learn))
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

	// When we have sourced skill mods (praying, add to this as well)
	if(clear_job_stats) // Reset for most non-advclasses
		spawned.remove_stat_modifier(STATMOD_JOB)

	spawned.adjust_stat_modifier_list(STATMOD_JOB, jobstats)

	for(var/datum/skill/skill as anything in skills)
		var/amount_or_list = skills[skill]
		if(islist(amount_or_list))
			spawned.clamped_adjust_skillrank(skill, amount_or_list[1], amount_or_list[2], TRUE)
		else
			spawned.adjust_skillrank(skill, amount_or_list, TRUE)

	for(var/skill_type in skill_multipliers)
		spawned.set_skill_exp_multiplier(skill_type, skill_multipliers[skill_type])

	for(var/X in peopleknowme)
		for(var/datum/mind/found_mind in get_minds(X))
			spawned.mind.give_source_identity(found_mind)

	for(var/X in peopleiknow)
		for(var/datum/mind/found_mind in get_minds(X))
			spawned.mind.learn_target_identity(found_mind)

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
		spawned.add_quirk(forced_flaw)

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

	if(spawned.culture)
		spawned.culture.on_after_spawn(spawned)

	if(length(advclass_cat_rolls))
		spawned.hugboxify_for_class_selection()

	if(spawned.culinary_preferences[CULINARY_RANDOM_PREFERENCES])
		var/obj/item/food_instance = spawned.culinary_preferences[CULINARY_FAVOURITE_FOOD]
		var/datum/reagent/consumable/drink_instance = spawned.culinary_preferences[CULINARY_FAVOURITE_DRINK]
		var/obj/item/hated_food_instance = spawned.culinary_preferences[CULINARY_HATED_FOOD]
		var/datum/reagent/consumable/hated_drink_instance = spawned.culinary_preferences[CULINARY_HATED_DRINK]

		bordered_message(spawned, list(
			"Your favourite food is <span style='color: green;'>[capitalize(initial(food_instance.name))]</span>",
			"Your favourite drink is <span style='color: green;'>[capitalize(initial(drink_instance.name))]</span>",
			"Your most hated food is <span style='color: red;'>[capitalize(initial(hated_food_instance.name))]</span>",
			"Your most hated drink is <span style='color: red;'>[capitalize(initial(hated_drink_instance.name))]</span>",
		))

	if(job_flags & JOB_SHOW_IN_CREDITS)
		START_PROCESSING(SScrediticons, player_client)

/datum/job/proc/adjust_patron(mob/living/carbon/human/spawned)
	if(!length(allowed_patrons))
		return

	var/datum/patron/old_patron = spawned.patron
	if(old_patron?.type in allowed_patrons)
		return

	var/list/datum/patron/all_gods = list()
	var/list/datum/patron/pantheon_gods = list()
	for(var/god in GLOB.patron_list)
		if(!(god in allowed_patrons))
			continue
		all_gods |= god
		var/datum/patron/P = GLOB.patron_list[god]
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

		var/list/reals = list()
		for(var/pack as anything in job_packs)
			var/datum/job_pack/real_pack = GLOB.job_pack_singletons[pack]
			if(!real_pack.can_pick_pack(src, previous_picked_types))
				continue
			reals |= real_pack
		if(!length(reals))
			message_admins("ERROR: [key_name_admin(src)] failed job pack selection.")
			return

		var/datum/job_pack/picked_pack
		if(client)
			picked_pack = browser_input_list(src, equipping.pack_title, equipping.pack_message, reals, timeout = 40 SECONDS)
			if(QDELETED(src))
				return
		if(!picked_pack)
			picked_pack = pick(reals)

		if(picked_pack.type)
			previous_picked_types |= picked_pack.type

		picked_pack.pick_pack(src)

/mob/living/proc/dress_up_as_job(datum/job/equipping, visual_only = FALSE)
	return

/mob/living/carbon/human/dress_up_as_job(datum/job/equipping, visual_only = FALSE)
	dna.species.pre_equip_species_outfit(equipping, src, visual_only)

	var/datum/outfit/chosen_outfit
	var/datum/outfit/outfit_check = (gender == FEMALE && equipping.outfit_female) ? equipping.outfit_female : equipping.outfit
	if(ispath(outfit_check, /datum/outfit))
		chosen_outfit = outfit_check
	else
		chosen_outfit = GLOB.custom_outfits[outfit_check]

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
/datum/job/proc/get_spawn_mob(client/player_client, atom/spawn_point, latejoining)
	var/mob/living/spawn_instance

	spawn_instance = new spawn_type(player_client.mob.loc)
	spawn_point.JoinPlayerHere(spawn_instance, TRUE)
	spawn_instance.apply_prefs_job(player_client, src, latejoining)
	if(!player_client)
		qdel(spawn_instance)
		return // Disconnected while checking for the appearance ban.
	return spawn_instance

/mob/dead/new_player/proc/ensure_multi_ready_character_loaded()
	if(!multi_ready_assigned_slot || !client?.prefs)
		return FALSE

	// Force reload the assigned character slot
	client.prefs.load_character(multi_ready_assigned_slot)
	client.prefs.default_slot = multi_ready_assigned_slot

	return TRUE

/// Applies the preference options to the spawning mob, taking the job into account. Assumes the client has the proper mind.
/mob/living/proc/apply_prefs_job(client/player_client, datum/job/job, latejoining = FALSE)
	return

/mob/living/carbon/human/apply_prefs_job(client/player_client, datum/job/job, latejoining = FALSE)
	var/fully_randomize = is_banned_from(player_client.ckey, "Appearance")
	var/mob/dead/new_player/np = player_client?.mob
	if(istype(np) && player_client?.prefs?.multi_char_ready && !latejoining)
		np.ensure_multi_ready_character_loaded()
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

/datum/job/proc/get_informed_title(mob/mob, ignore_pronouns = FALSE)
	if(mob.admin_title)
		return mob.admin_title

	if(title_override)
		return title_override

	if(f_title)
		if(ignore_pronouns && mob.gender == FEMALE || !ignore_pronouns && mob.pronouns == SHE_HER)
			return f_title

	return title

/datum/job/proc/set_spawn_and_total_positions(count)
	return spawn_positions

/datum/job/proc/get_total_positions(latejoin)
	return latejoin ? total_positions : spawn_positions

/datum/job/proc/get_json_data()
	var/list/data = list()

	data["job_type"] = type
	data["title"] = title
	data["f_title"] = f_title
	data["enabled"] = enabled
	data["spawn_positions"] = spawn_positions
	data["cmode_music"] = cmode_music
	data["antag_role"] = antag_role
	data["faction"] = faction
	data["total_positions"] = total_positions
	data["tutorial"] = tutorial
	data["selection_color"] = selection_color
	data["minimal_player_age"] = minimal_player_age
	data["exp_requirements"] = exp_requirements
	data["exp_type"] = exp_type
	data["paycheck"] = paycheck
	data["paycheck_department"] = paycheck_department
	data["display_order"] = display_order
	data["job_flags"] = job_flags
	data["allowed_sexes"] = allowed_sexes
	data["allowed_races"] = allowed_races
	data["give_bank_account"] = give_bank_account
	data["can_random"] = can_random
	data["always_show_on_latechoices"] = always_show_on_latechoices
	data["same_job_respawn_delay"] = same_job_respawn_delay
	data["job_reopens_slots_on_death"] = job_reopens_slots_on_death
	data["is_foreigner"] = is_foreigner
	data["is_recognized"] = is_recognized
	data["shows_in_list"] = shows_in_list
	data["can_have_apprentices"] = can_have_apprentices
	data["max_apprentices"] = max_apprentices
	data["apprentice_name"] = apprentice_name
	data["magic_user"] = magic_user
	data["noble_income"] = noble_income
	data["job_bitflag"] = job_bitflag
	data["id"] = id

	if(length(skills))
		var/list/skill_map = list()
		for(var/skill_path in skills)
			var/level = skills[skill_path]
			skill_map[skill_path] = level
		data["skills"] = skill_map
	if(length(trainable_skills))
		data["trainable_skills"] = trainable_skills.Copy()
	if(length(advclass_cat_rolls))
		data["advclass_cat_rolls"] = advclass_cat_rolls.Copy()
	if(length(mind_traits))
		data["mind_traits"] = mind_traits.Copy()
	if(length(traits))
		data["traits"] = traits.Copy()
	if(length(languages))
		data["languages"] = languages.Copy()
	if(length(jobstats))
		data["jobstats"] = jobstats.Copy()
	if(length(spells))
		data["spells"] = spells.Copy()
	if(length(allowed_ages))
		data["allowed_ages"] = allowed_ages.Copy()
	if(length(allowed_patrons))
		data["allowed_patrons"] = allowed_patrons.Copy()


	if(outfit)
		var/outfit_key = outfit
		var/list/outfit_data

		// If this is a custom outfit, include its full JSON
		if(istext(outfit_key) && (outfit_key in GLOB.custom_outfits))
			var/datum/outfit/O = GLOB.custom_outfits[outfit_key]
			if(O)
				outfit_data = O.get_json_data()
				outfit_data["id"] = outfit_key

		data["outfit"] = outfit_data

	return data

/datum/job/proc/load_from_json(list/data, mob/admin)
	if(!islist(data))
		return

	title = data["title"]
	f_title = data["f_title"]
	enabled = data["enabled"]
	spawn_positions = data["spawn_positions"]
	cmode_music = data["cmode_music"]
	outfit = data["outfit"]
	antag_role = text2path(data["antag_role"])
	faction = data["faction"]
	total_positions = data["total_positions"]
	tutorial = data["tutorial"]
	selection_color = data["selection_color"]
	minimal_player_age = data["minimal_player_age"]
	exp_requirements = data["exp_requirements"]
	exp_type = data["exp_type"]
	paycheck = data["paycheck"]
	paycheck_department = data["paycheck_department"]
	display_order = data["display_order"]
	job_flags = data["job_flags"]
	allowed_sexes = data["allowed_sexes"]
	allowed_races = data["allowed_races"]
	give_bank_account = data["give_bank_account"]
	can_random = data["can_random"]
	always_show_on_latechoices = data["always_show_on_latechoices"]
	same_job_respawn_delay = data["same_job_respawn_delay"]
	job_reopens_slots_on_death = data["job_reopens_slots_on_death"]
	is_foreigner = data["is_foreigner"]
	is_recognized = data["is_recognized"]
	shows_in_list = data["shows_in_list"]
	can_have_apprentices = data["can_have_apprentices"]
	max_apprentices = data["max_apprentices"]
	apprentice_name = data["apprentice_name"]
	magic_user = data["magic_user"]
	noble_income = data["noble_income"]
	job_bitflag = data["job_bitflag"]
	id = data["id"]


	if(data["skills"])
		skills = list()
		for(var/skill_path_text in data["skills"])
			var/skill_path = text2path(skill_path_text)
			if(skill_path)
				var/level = data["skills"][skill_path_text]
				skills[skill_path] = level
	if(data["allowed_ages"])
		var/list/tmp = data["allowed_ages"]
		allowed_ages = tmp.Copy()
	if(data["allowed_patrons"])
		allowed_patrons = list()
		for(var/allowed_patrons_text in data["allowed_patrons"])
			var/allowed_patrons_path = text2path(allowed_patrons_text)
			if(allowed_patrons_path) // valid path
				allowed_patrons += allowed_patrons_path
	if(data["trainable_skills"])
		var/list/tmp = data["trainable_skills"]
		trainable_skills = tmp.Copy()
	if(data["advclass_cat_rolls"])
		var/list/tmp = data["advclass_cat_rolls"]
		advclass_cat_rolls = tmp.Copy()
	if(data["mind_traits"])
		var/list/tmp = data["mind_traits"]
		mind_traits = tmp.Copy()
	if(data["traits"])
		var/list/tmp = data["traits"]
		traits = tmp.Copy()
	if(data["languages"])
		languages = list()
		for(var/lang_path_text in data["languages"])
			var/lang_path = text2path(lang_path_text)
			if(lang_path)
				languages += lang_path
	if(data["jobstats"])
		var/list/tmp = data["jobstats"]
		jobstats = tmp.Copy()
	if(data["spells"])
		var/list/tmp = data["spells"]
		spells = tmp.Copy()


	if(data["outfit"])
		var/list/outfit_data = data["outfit"]

		// Check if it's the OLD wrapper structure (with duplicate IDs)
		if(islist(outfit_data) && outfit_data["custom_outfit_data"])
			var/list/custom_outfit_data = outfit_data["custom_outfit_data"]
			if(islist(custom_outfit_data))
				var/datum/outfit/O = new
				O.load_from(custom_outfit_data)

				if(!(O.id in GLOB.custom_outfits))
					GLOB.custom_outfits[O.id] = O
					message_admins("[key_name(usr)] from the job [title] loaded a custom outfit (old format): [O.name]")
					to_chat(admin, span_notice("Successfully loaded outfit [O.name] from old format."))

				outfit = O.id

		// Check if it's the NEW direct outfit data structure
		else if(islist(outfit_data) && outfit_data["outfit_type"])
			var/datum/outfit/O = new
			O.load_from(outfit_data)

			if(!(O.id in GLOB.custom_outfits))
				GLOB.custom_outfits[O.id] = O
				message_admins("[key_name(usr)] from the job [title] loaded a custom outfit: [O.name]")
				to_chat(admin, span_notice("Successfully loaded outfit [O.name]."))

			outfit = O.id
		else
			outfit = data["outfit"]


	return TRUE

/// Multi check using prefs for reuse, remove when datum/preference is a thing
/datum/job/proc/prefs_species_check(datum/preferences/prefs)
	if(!prefs)
		return FALSE

	var/datum/species/species = prefs.pref_species

	var/job_used_id = species.id_override ? species.id_override : species.id

	if(length(allowed_races) && !(job_used_id in allowed_races))
		return FALSE

	if(length(blacklisted_species) && (job_used_id in blacklisted_species))
		return FALSE

	// Subterran dwarves can only be outsiders if they follow the wurm
	if(species.id == SPEC_ID_DWARF_SUBTERRAN && istype(prefs.selected_patron, /datum/patron/alternate/wurm))
		var/datum/job/tested = parent_job ? SSjob.GetJobType(parent_job) : src // FUCK ADVCLASSES!
		if(!(tested.department_flag & OUTSIDERS))
			return FALSE

	return TRUE
