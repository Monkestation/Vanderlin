SUBSYSTEM_DEF(questboard)
	name = "Quest Board"
	wait = 2 SECONDS
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	///singleton list of quests mapped to difficulty to save a super tiny amount of time
	var/list/quest_types_by_difficulty = list()

	/// Pool of /datum/quest that are generated and unclaimed. Keyed by difficulty.
	var/list/quest_pool = list(
		QUEST_DIFFICULTY_EASY = list(),
		QUEST_DIFFICULTY_MEDIUM = list(),
		QUEST_DIFFICULTY_HARD = list(),
	)

	/// Maximum quests sitting unclaimed per difficulty tier at once.
	var/list/pool_max = list(
		QUEST_DIFFICULTY_EASY = QUESTBOARD_POOL_MAX_EASY,
		QUEST_DIFFICULTY_MEDIUM = QUESTBOARD_POOL_MAX_MEDIUM,
		QUEST_DIFFICULTY_HARD = QUESTBOARD_POOL_MAX_HARD,
	)

	/// Total mammons in the communal quest fund (deposited by stewards / merchants).
	var/quest_fund = 300

	///stored list of transactions (currently admin stuff but like yummy paperwork)
	var/list/fund_log = list()

	var/list/generation_queue = list()
	COOLDOWN_DECLARE(generation_cooldown)

/datum/controller/subsystem/questboard/Initialize(start_timeofday)
	quest_pool = list(
		QUEST_DIFFICULTY_EASY = list(),
		QUEST_DIFFICULTY_MEDIUM = list(),
		QUEST_DIFFICULTY_HARD = list(),
	)
	return ..()

/datum/controller/subsystem/questboard/fire(resumed)
	if(!resumed)
		prune_stale_quests()
		if(COOLDOWN_FINISHED(src, generation_cooldown))
			build_generation_queue()
			COOLDOWN_START(src, generation_cooldown, 5 MINUTES)

	while(length(generation_queue))
		var/difficulty = generation_queue[1]
		generation_queue.Cut(1, 2)

		var/cost = get_generation_cost(difficulty)
		if(quest_fund >= cost)
			var/datum/quest/generated = try_generate_quest(difficulty)
			if(generated)
				quest_pool[difficulty] += generated
				quest_fund -= cost
				fund_log += "-[cost] (generated [difficulty] quest: [generated.title])"

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/questboard/proc/build_generation_queue()
	var/threat_bonus = get_threat_pool_bonus()
	for(var/difficulty in quest_pool)
		var/current = 0
		for(var/datum/quest/Q as anything in quest_pool[difficulty])
			if(!istype(Q, /datum/quest/custom) || !istype(Q, /datum/quest/objective))
				current++
		var/needed = (pool_max[difficulty] + threat_bonus) - current
		for(var/i in 1 to needed)
			generation_queue += difficulty


/datum/controller/subsystem/questboard/proc/get_threat_pool_bonus()
	var/highest = DANGER_LEVEL_SAFE
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		var/level = TR.get_danger_level()
		//we need to convert to ordinal to compare number to number
		if(danger_level_ordinal(level) > danger_level_ordinal(highest))
			highest = level

	switch(highest)
		if(DANGER_LEVEL_SAFE, DANGER_LEVEL_LOW)
			return 0
		if(DANGER_LEVEL_MODERATE)
			return 3
		if(DANGER_LEVEL_DANGEROUS)
			return 5
		if(DANGER_LEVEL_BLEAK)
			return 8
	return 0

/// Maps danger level strings to an integer for comparison.
/datum/controller/subsystem/questboard/proc/danger_level_ordinal(level)
	switch(level)
		if(DANGER_LEVEL_SAFE) return 0
		if(DANGER_LEVEL_LOW) return 1
		if(DANGER_LEVEL_MODERATE) return 2
		if(DANGER_LEVEL_DANGEROUS) return 3
		if(DANGER_LEVEL_BLEAK) return 4
	return 0

/datum/controller/subsystem/questboard/proc/try_generate_quest(difficulty)
	var/list/valid_types = GLOB.global_quest_types[difficulty]
	if(!length(valid_types))
		return null

	var/type_selection = pick(valid_types)

	var/datum/quest/Q = new type_selection()
	if(!Q)
		return null

	var/obj/effect/landmark/quest_spawner/landmark = find_landmark_for(
		difficulty,
		type_selection,
		Q.allowed_threat_regions,
		Q.denied_threat_regions,
	)
	if(!landmark)
		qdel(Q)
		return null

	if(!Q.generate(landmark))
		qdel(Q)
		return null

	Q.reward_amount = Q.calculate_reward(get_turf(landmark))
	switch(difficulty)
		if(QUEST_DIFFICULTY_EASY)
			Q.expiry_time = world.time + rand(20 MINUTES, 40 MINUTES)
		if(QUEST_DIFFICULTY_MEDIUM)
			Q.expiry_time = world.time + rand(35 MINUTES, 55 MINUTES)
		if(QUEST_DIFFICULTY_HARD)
			Q.expiry_time = world.time + rand(50 MINUTES, 80 MINUTES)
	return Q

/**
 * Find a landmark for the given difficulty + quest type.
 *
 * Candidates are weighted by the threat level of the region they sit in:
 * Safe/Low → weight 1 (still possible, just unlikely)
 * Moderate → weight 2
 * Dangerous → weight 4
 * Bleak → weight 8
 *
 * Each candidate is added to the pool that many times so prob(pick) scales
 * correctly. Player-occupied landmarks are always excluded.
 */
/datum/controller/subsystem/questboard/proc/find_landmark_for(difficulty, datum/quest/type, list/allowed_regions, list/denied_regions)
	var/list/weighted_candidates = list()

	for(var/obj/effect/landmark/quest_spawner/L in GLOB.quest_landmarks_list)
		if(L.quest_difficulty != difficulty)
			continue
		if(!(initial(type.quest_type) in L.quest_type)) // the shitcode we make for mappers ease :( (actually this might bite me in the ass in the future but eh)
			continue

		// Skip landmarks with players nearby
		var/occupied = FALSE
		for(var/mob/M in get_hearers_in_view(world.view, L))
			if(M.client)
				occupied = TRUE
				break
		if(occupied)
			continue

		var/datum/threat_region/TR = SSregionthreat.get_region_for_turf(get_turf(L))
		var/region_name = TR ? TR.region_name : null

		if(length(allowed_regions))
			if(!region_name || !(region_name in allowed_regions))
				continue

		if(length(denied_regions))
			if(region_name && (region_name in denied_regions))
				continue

		var/weight = TR ? danger_level_to_weight(TR.get_danger_level()) : 1

		for(var/i in 1 to weight)
			weighted_candidates += L

	return length(weighted_candidates) ? pickweight(weighted_candidates) : null

/// Converts a danger level string to a generation weight.
/datum/controller/subsystem/questboard/proc/danger_level_to_weight(level)
	switch(level)
		if(DANGER_LEVEL_SAFE) return 1
		if(DANGER_LEVEL_LOW) return 2
		if(DANGER_LEVEL_MODERATE) return 4
		if(DANGER_LEVEL_DANGEROUS) return 6
		if(DANGER_LEVEL_BLEAK) return 8
	return 1

/// Remove quests that somehow lost their scroll reference or have been sitting unclaimed too long.
/datum/controller/subsystem/questboard/proc/prune_stale_quests()
	for(var/difficulty in quest_pool)
		var/list/tier = quest_pool[difficulty]
		for(var/datum/quest/Q as anything in tier)
			if(QDELETED(Q))
				tier -= Q
				continue
			if(istype(Q, /datum/quest/custom))
				continue
			if(Q.expiry_time && world.time >= Q.expiry_time)
				tier -= Q
				log_game("Quest expired: [Q.title] ([Q.quest_difficulty])")
				qdel(Q)
				add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_QUEST_STALE, 1)


/// Called by the notice board / contract ledger UI to let a steward deposit funds.
/datum/controller/subsystem/questboard/proc/deposit_quest_funds(mob/steward, amount)
	if(amount <= 0)
		return FALSE
	if(steward)
		if(!(steward in SStreasury.bank_accounts))
			return FALSE
		if(SStreasury.bank_accounts[steward] < amount)
			return FALSE

		SStreasury.bank_accounts[steward] -= amount
	SStreasury.treasury_value += amount
	quest_fund += amount
	if(steward)
		fund_log += "+[amount] deposited by [steward.real_name]"
		to_chat(steward, span_notice("You deposit [amount] mammons into the quest fund. Fund total: [quest_fund]."))
		log_quest(steward.ckey, steward.mind, steward, "Deposit [amount] to quest fund")
	return TRUE

/// How much it costs from the fund to auto-generate one quest of a given difficulty.
/datum/controller/subsystem/questboard/proc/get_generation_cost(difficulty)
	switch(difficulty)
		if(QUEST_DIFFICULTY_EASY)
			return QUESTBOARD_COST_EASY
		if(QUEST_DIFFICULTY_MEDIUM)
			return QUESTBOARD_COST_MEDIUM
		if(QUEST_DIFFICULTY_HARD)
			return QUESTBOARD_COST_HARD
	return QUESTBOARD_COST_EASY

/**
 * Attempt to claim a specific pre-generated quest for a mob.
 * Returns the quest scroll on success, null on failure.
 */
/datum/controller/subsystem/questboard/proc/claim_quest(datum/quest/Q, mob/claimant)
	if(!Q || QDELETED(Q) || Q.quest_receiver_reference)
		return null

	// Remove from pool
	for(var/difficulty in quest_pool)
		quest_pool[difficulty] -= Q

	// Assign receiver
	Q.on_claim(claimant)

	// Create and hand out the scroll
	var/obj/item/paper/scroll/quest/scroll = new(get_turf(claimant))
	claimant.put_in_hands(scroll)
	scroll.base_icon_state = Q.get_scroll_icon()
	scroll.assigned_quest = Q
	Q.quest_scroll = scroll
	Q.quest_scroll_ref = WEAKREF(scroll)
	scroll.update_quest_text()

	log_quest(claimant.ckey, claimant.mind, claimant, "Claim pool quest [Q.quest_type] ([Q.quest_difficulty])")
	return scroll

/**
 * Steward issues a custom quest.
 * Custom quests don't auto-complete, the steward validates them manually
 * at the notice board by inspecting the adventurer's inventory / verifying
 * items in the input zone.
 */
/datum/controller/subsystem/questboard/proc/issue_custom_quest(mob/steward, datum/quest/custom/custom_quest)
	if(!custom_quest || QDELETED(custom_quest))
		return FALSE
	add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_QUEST_CREATED, 1)

	var/cost = custom_quest.reward_amount + QUESTBOARD_CUSTOM_ISSUE_FEE
	if(quest_fund < cost && !(SStreasury.bank_accounts[steward] >= cost))
		to_chat(steward, span_warning("Insufficient funds to issue this custom quest. Either top up the quest fund or your personal account."))
		return FALSE

	// Prefer quest fund, fall back to steward personal
	if(quest_fund >= cost)
		quest_fund -= cost
		fund_log += "-[cost] (custom quest issued by [steward.real_name]: [custom_quest.title])"
	else
		SStreasury.bank_accounts[steward] -= cost
		SStreasury.treasury_value += cost
		fund_log += "-[cost] (custom quest personal-funded by [steward.real_name]: [custom_quest.title])"

	custom_quest.quest_giver_reference = WEAKREF(steward)
	custom_quest.quest_giver_name = steward.real_name

	// Custom quests sit in the pool unclaimed until someone takes it
	quest_pool[custom_quest.quest_difficulty] += custom_quest
	log_quest(steward.ckey, steward.mind, steward, "Issue custom quest: [custom_quest.title]")
	to_chat(steward, span_notice("Custom quest \"[custom_quest.title]\" posted to the notice board."))
	return TRUE

/datum/controller/subsystem/questboard/proc/issue_custom_quest_funded(mob/steward, datum/quest/custom/CQ, amount)
	// Validate
	if(!CQ || QDELETED(CQ))
		return FALSE
	if(amount < 1)
		return FALSE

	// Credit the quest fund with the escrowed coins
	quest_fund += amount

	// Then post via the normal path (which draws from the fund)
	return issue_custom_quest(steward, CQ)
