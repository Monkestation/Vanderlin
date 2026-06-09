/obj/effect/landmark/quest_dropoff/counter
	name = "Quest Counter Drop-off"

/obj/structure/quest_counter
	name = "Guild Quest Counter"
	desc = "A solid oak counter staffed by the guild. Completed contracts are filed here, and the steward handles custom commissions from behind it."
	icon = 'icons/obj/questing.dmi'
	icon_state = "contractledger"
	density = TRUE
	anchored = TRUE
	max_integrity = 800
	layer = ABOVE_MOB_LAYER

	/// Turf in front of the counter used for scroll / item drop-off.
	var/turf/input_point
	/// Mapping id used to locate the matching quest_dropoff landmark.
	var/counter_id = ""

/obj/structure/quest_counter/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/quest_counter/LateInitialize()
	. = ..()
	if(counter_id)
		for(var/obj/effect/landmark/quest_dropoff/counter/M in GLOB.landmarks_list)
			if(M.board_id == counter_id)
				input_point = get_turf(M)
				break

	if(!input_point)
		input_point = locate(x, y - 1, z)

	var/obj/effect/decal/marker_export/marker = new(get_turf(input_point))
	marker.desc = "Place completed quest scrolls or items for validation here."
	marker.layer = ABOVE_OBJ_LAYER

/obj/structure/quest_counter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "QuestCounter", "Guild Quest Counter")
		ui.open()

/obj/structure/quest_counter/ui_state(mob/user)
	return GLOB.default_state

/obj/structure/quest_counter/ui_data(mob/user)
	var/datum/job/mob_job = user.job ? SSjob.GetJob(user.job) : null
	var/is_quest_giver = mob_job?.is_quest_giver || FALSE

	var/list/active_quests = list()
	if(is_quest_giver)
		for(var/obj/item/paper/scroll/quest/S in GLOB.quest_scrolls)
			if(!S.assigned_quest || S.assigned_quest.complete || !S.assigned_quest.quest_receiver_reference)
				continue
			var/datum/quest/Q = S.assigned_quest
			var/pledge_backed = FALSE
			if(istype(Q, /datum/quest/custom))
				var/datum/quest/custom/quest = Q
				var/atom/resolved = quest.pledge_ref?.resolve()
				pledge_backed = !QDELETED(resolved)
			active_quests += list(list(
				"ref" = REF(Q),
				"scroll_ref" = REF(S),
				"title" = Q.title,
				"difficulty" = Q.quest_difficulty,
				"type" = Q.quest_type,
				"receiver" = Q.quest_receiver_name,
				"region" = Q.threat_region_name,
				"progress" = Q.progress_current,
				"progress_max" = Q.progress_required,
				"reward" = Q.reward_amount,
				"reward_boosted" = Q.reward_boosted_by,
				"pledge_backed" = pledge_backed,
				"accepted_time" = Q.accepted_time,
				"is_custom" = istype(Q, /datum/quest/custom),
			))

	var/list/my_custom = list()
	if(is_quest_giver)
		for(var/difficulty in SSquestboard.quest_pool)
			for(var/datum/quest/custom/CQ as anything in SSquestboard.quest_pool[difficulty])
				if(!QDELETED(CQ) && istype(CQ) && CQ.quest_giver_reference?.resolve() == user)
					my_custom += list(list(
						"ref" = REF(CQ),
						"title" = CQ.title,
						"difficulty" = CQ.quest_difficulty,
						"mode" = CQ.issue_label,
						"receiver" = null,
						"claimed" = FALSE,
					))
		for(var/obj/item/paper/scroll/quest/S in GLOB.quest_scrolls)
			if(!istype(S.assigned_quest, /datum/quest/custom))
				continue
			var/datum/quest/custom/CQ = S.assigned_quest
			if(CQ.quest_giver_reference?.resolve() != user || CQ.complete)
				continue
			my_custom += list(list(
				"ref" = REF(CQ),
				"title" = CQ.title,
				"difficulty" = CQ.quest_difficulty,
				"mode" = CQ.issue_label,
				"receiver" = CQ.quest_receiver_name,
				"claimed" = TRUE,
			))

	var/steward_balance = is_quest_giver ? (SStreasury.bank_accounts[user] || 0) : 0

	return list(
		"is_quest_giver" = is_quest_giver,
		"quest_fund" = SSquestboard.quest_fund,
		"steward_balance" = steward_balance,
		"active_quests" = active_quests,
		"my_custom_quests" = my_custom,
		"counter_icon" = icon,
		"counter_icon_state" = icon_state,
		"world_time" = world.time,
	)

/obj/structure/quest_counter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/user = ui.user

	switch(action)

		if("turnin")
			turn_in_quest(user)
			return TRUE

		if("abandon")
			abandon_quest(user)
			return TRUE

		if("deposit_fund")
			if(!is_quest_giver(user))
				return FALSE
			var/balance = SStreasury.bank_accounts[user] || 0
			var/amount = tgui_input_number(user, \
				"How much would you like to deposit?\nYour balance: [balance] mammons | Fund: [SSquestboard.quest_fund] mammons", \
				"Deposit to Quest Fund", 0, balance, 0)
			if(!amount || amount <= 0)
				return FALSE
			SSquestboard.deposit_quest_funds(user, amount)
			return TRUE

		if("issue_custom")
			if(!is_quest_giver(user))
				return FALSE
			issue_custom_quest(user)
			return TRUE

		if("validate_custom")
			if(!is_quest_giver(user))
				return FALSE
			var/datum/quest/custom/CQ = locate(params["ref"]) in \
				SSquestboard.quest_pool[QUEST_DIFFICULTY_EASY] + \
				SSquestboard.quest_pool[QUEST_DIFFICULTY_MEDIUM] + \
				SSquestboard.quest_pool[QUEST_DIFFICULTY_HARD]
			if(!CQ)
				for(var/obj/item/paper/scroll/quest/S in GLOB.quest_scrolls)
					if(REF(S.assigned_quest) == params["ref"])
						CQ = S.assigned_quest
						break
			if(!CQ || QDELETED(CQ))
				return FALSE
			do_validate_custom(user, CQ)
			return TRUE

		if("boost_reward")
			if(!is_quest_giver(user))
				return FALSE
			var/datum/quest/CQ

			for(var/obj/item/paper/scroll/quest/S in GLOB.quest_scrolls)
				if(REF(S.assigned_quest) == params["ref"])
					CQ = S.assigned_quest
					break

			if(!CQ)
				for(var/difficulty in SSquestboard.quest_pool)
					for(var/datum/quest/Q as anything in SSquestboard.quest_pool[difficulty])
						if(REF(Q) == params["ref"])
							CQ = Q
							break
					if(CQ)
						break

			if(!CQ || QDELETED(CQ) || CQ.complete)
				return FALSE

			var/fund = SSquestboard.quest_fund
			if(fund < 1)
				say("The quest fund is empty. Deposit more mammons before boosting rewards.")
				return FALSE
			var/amount = tgui_input_number(user, \
				"How much to add to \"[CQ.title]\" from the quest fund?\nFund available: [fund]m | Current reward: [CQ.reward_amount]m", \
				"Boost Reward", 0, fund, 1)
			if(!amount || amount < 1)
				return FALSE
			if(CQ.increase_reward(user, amount))
				say("The reward for \"[CQ.title]\" has been raised to [CQ.reward_amount] mammons.")
			return TRUE

		if("revoke_quest")
			if(!is_quest_giver(user))
				return FALSE
			var/obj/item/paper/scroll/quest/target_scroll
			var/datum/quest/target_quest
			for(var/obj/item/paper/scroll/quest/S in GLOB.quest_scrolls)
				if(REF(S.assigned_quest) == params["ref"])
					target_scroll = S
					target_quest = S.assigned_quest
					break
			if(!target_scroll || !target_quest || QDELETED(target_quest))
				return FALSE

			var/receiver = target_quest.quest_receiver_name

			log_quest(user.ckey, user.mind, user, \
				"Revoked active scroll for quest \"[target_quest.title]\" from [receiver], quest returned to pool")

			target_quest.accepted_time = 0
			target_quest.quest_receiver_reference = null
			target_quest.quest_receiver_name = ""

			target_scroll.assigned_quest = null
			target_quest.quest_scroll = null
			target_quest.quest_scroll_ref = null

			var/tier = target_quest.quest_difficulty
			switch(target_quest.quest_difficulty)
				if(QUEST_DIFFICULTY_EASY)
					target_quest.expiry_time = world.time + rand(20 MINUTES, 40 MINUTES)
				if(QUEST_DIFFICULTY_MEDIUM)
					target_quest.expiry_time = world.time + rand(35 MINUTES, 55 MINUTES)
				if(QUEST_DIFFICULTY_HARD)
					target_quest.expiry_time = world.time + rand(50 MINUTES, 80 MINUTES)
			if(!(target_quest in SSquestboard.quest_pool[tier]))
				SSquestboard.quest_pool[tier] += target_quest
			say("The contract held by [receiver] has been recalled. It is available on the notice board again.")

			qdel(target_scroll)
			return TRUE

	return FALSE

/obj/structure/quest_counter/proc/process_turnin(mob/user, obj/item/paper/scroll/quest/scroll)
	if(!scroll.assigned_quest?.complete)
		say("This contract isn't complete yet, [user.real_name].")
		return

	var/datum/quest/Q = scroll.assigned_quest
	var/base_reward = Q.reward_amount
	var/reward = base_reward

	var/datum/job/mob_job = user.job ? SSjob.GetJob(user.job) : null
	if(mob_job?.is_quest_giver)
		reward = round(base_reward * QUEST_HANDLER_REWARD_MULTIPLIER)

	var/tax_rate = SStreasury.tax_value
	var/tax_amt = round(tax_rate * reward)
	if(tax_amt > 0)
		reward -= tax_amt
		SStreasury.give_money_treasury(tax_amt, "quest completion tax - [src.name]")
		record_featured_stat(FEATURED_STATS_TAX_PAYERS, user, tax_amt)
		record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
		add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_TAXES_COLLECTED, tax_amt)
		add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_QUEST_TAXES, tax_amt)

	add_mammons_to_atom(user, round(reward))
	add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_QUEST_PROFIT, round(reward))
	log_quest(user.ckey, user.mind, user, "Turn in [Q.quest_type] for [reward] mammon")
	SSquestboard.deposit_quest_funds(null, CEILING(reward * 0.1, 1))

	if(istype(Q, /datum/quest/custom))
		var/datum/quest/custom/CQ = Q
		if(CQ.pledge_ref)
			var/obj/item/paper/scroll/quest/pledge/PL = CQ.pledge_ref.resolve()
			var/patron = (!QDELETED(PL) && PL.pledge_title) ? PL.pledge_title : "an anonymous patron"
			say("The commission \"[Q.title]\", pledged by [patron], has been fulfilled. " + \
				"Your reward of [reward] mammons has been dispensed. ([tax_amt] mammons taxed.)")
		else
			say(reward > base_reward ? \
				"Excellently handled! Your bonus reward of [reward] mammons has been dispensed. ([tax_amt] mammons taxed.)" : \
				"Well done, [user.real_name]! Your reward of [reward] mammons has been dispensed. ([tax_amt] mammons taxed.)")
	else
		say(reward > base_reward ? \
			"Excellently handled! Your bonus reward of [reward] mammons has been dispensed. ([tax_amt] mammons taxed.)" : \
			"Well done, [user.real_name]! Your reward of [reward] mammons has been dispensed. ([tax_amt] mammons taxed.)")

	qdel(Q)
	qdel(scroll)

/obj/structure/quest_counter/proc/turn_in_quest(mob/user)
	var/obj/item/paper/scroll/quest/scroll = locate() in user
	if(!scroll)
		scroll = locate() in input_point
	if(!scroll)
		say("I don't see a completed quest scroll. Hold it in your hands or place it on the marked area.")
		return

	var/list/assignees = scroll.get_quest_assignees(user, TRUE)
	if(!(user in assignees))
		to_chat(user, span_warning("You are not assigned to this contract."))
		return

	process_turnin(user, scroll)

/obj/structure/quest_counter/proc/abandon_quest(mob/user)
	var/obj/item/paper/scroll/quest/scroll
	for(var/obj/item/paper/scroll/quest/S in input_point)
		var/list/assignees = S.get_quest_assignees(user, TRUE)
		if(user in assignees)
			scroll = S
			break

	if(!scroll)
		say("Place your quest scroll on the marked area first if you wish to abandon it.")
		return

	var/datum/quest/Q = scroll.assigned_quest
	if(!Q)
		qdel(scroll)
		return

	if(Q.complete)
		process_turnin(user, scroll)
		return

	log_quest(user.ckey, user.mind, user, "Abandon [Q.quest_type]")
	say("Contract abandoned. The quest slot will be refilled on the notice board shortly.")
	qdel(Q)
	qdel(scroll)

/obj/structure/quest_counter/proc/issue_custom_quest(mob/user)
	var/list/available = list()
	for(var/datum/quest/custom/quest_type as anything in subtypesof(/datum/quest/custom))
		if(IS_ABSTRACT(quest_type))
			continue
		var/label = initial(quest_type.issue_label)
		if(!label)
			continue
		var/flags = initial(quest_type.custom_quest_flags)
		if(!(flags & CUSTOM_QUEST_NOTICEBOARD))
			continue
		available[label] = quest_type

	var/mode_choice = tgui_input_list(user, "What kind of custom quest?", "Custom Quest", available)
	if(!mode_choice)
		return

	var/quest_path = available[mode_choice]
	var/datum/quest/custom/CQ = new quest_path()

	if(!CQ.build_from_user(user))
		qdel(CQ)
		return

	if(!SSquestboard.issue_custom_quest(user, CQ))
		say("Failed to post the custom quest. Check the fund balance.")
		qdel(CQ)
		return

	CQ.generate(null)

/obj/structure/quest_counter/proc/do_validate_custom(mob/user, datum/quest/custom/target)
	if(target.validate(user, input_point))
		say("Quest \"[target.title]\" validated and marked complete. The adventurer may claim their reward.")
	else
		target.on_validate_fail(user, input_point, src)

/obj/structure/quest_counter/proc/is_quest_giver(mob/user)
	var/datum/job/mob_job = user.job ? SSjob.GetJob(user.job) : null
	if(!mob_job?.is_quest_giver)
		to_chat(user, span_warning("Only quest-issuing roles can use this function."))
		return FALSE
	return TRUE

/obj/structure/quest_counter/attackby(obj/item/P, mob/living/carbon/human/user, params)
	. = ..()
	if(istype(P, /obj/item/paper/scroll/quest/pledge))
		var/obj/item/paper/scroll/quest/pledge/PL = P
		if(!is_quest_giver(user))
			to_chat(user, span_warning("Only a guild steward can post a pledge here."))
			return
		if(PL.pledge_state != "sealed")
			say("This pledge isn't sealed yet! The issuer must seal it and commit their coins first.")
			return
		var/datum/quest/custom/CQ = PL.post_to_board(user, src)
		if(CQ)
			say("The pledge from [PL.pledge_title] has been accepted and posted to the notice board.")
		return

	if(istype(P, /obj/item/paper/scroll/quest))
		var/obj/item/paper/scroll/quest/scroll = P
		var/list/assignees = scroll.get_quest_assignees(user, TRUE)
		if(!(user in assignees))
			to_chat(user, span_warning("You are not the assigned quest receiver for this contract!"))
			return
		process_turnin(user, scroll)

/obj/structure/quest_counter/attack_hand(mob/living/carbon/human/user)
	if(!ishuman(user))
		return
	ui_interact(user)
