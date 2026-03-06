/obj/structure/fake_machine/contractledger
	name = "Grand Contract Ledger"
	desc = "A massive ledger book with gilded edges, sitting atop a pedestal with the Mercenary's Guild banner. Its myriad enchanted pages are filled with various contracts and bounties issued by Mercenary's Guild, with arcane scripts that appears and fades as contracts are issued and completed."
	icon = 'icons/obj/questing.dmi'
	icon_state = "contractledger"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER
	layer = GAME_PLANE_UPPER
	var/input_point

/obj/structure/fake_machine/contractledger/Initialize()
	. = ..()
	input_point = locate(x, y - 1, z)
	var/obj/effect/decal/marker_export/marker = new(get_turf(input_point))
	marker.desc = "Place completed contract scrolls here to turn them in."
	marker.layer = ABOVE_OBJ_LAYER

/obj/structure/fake_machine/contractledger/attackby(obj/item/P, mob/living/carbon/human/user, params)
	. = .. ()
	if(istype(P, /obj/item/paper/scroll/quest))
		turn_in_contract(user, P)
		return
	return

/obj/structure/fake_machine/contractledger/Topic(href, href_list)
	. = ..()
	if(href_list["consultcontracts"])
		consult_contracts(usr)
		return attack_hand(usr)
	if(href_list["turnincontract"])
		turn_in_contract(usr)
		return attack_hand(usr)
	if(href_list["abandoncontract"])
		abandon_contract(usr)
		return attack_hand(usr)
	if(href_list["printcontracts"])
		print_contracts(usr)
		return attack_hand(usr)
	return attack_hand(usr)

/obj/structure/fake_machine/contractledger/attack_hand(mob/living/carbon/human/user)
	if(!ishuman(user))
		return
	// Inshallah I'll make this TGUI one day.
	var/contents = "<center><h2>Grand Contract Ledger</h2>"
	contents += "<a href='?src=[REF(src)];consultcontracts=1'>Consult Contracts</a><br>"
	contents += "<a href='?src=[REF(src)];turnincontract=1'>Turn in Contract</a><br>"
	contents += "<a href='?src=[REF(src)];abandoncontract=1'>Abandon Contract</a><br>"
	var/datum/job/mob_job = user.job ? SSjob.GetJob(user.job) : null
	if(mob_job?.is_quest_giver)
		contents += "<a href='?src=[REF(src)];printcontracts=1'>Print Issued Contracts</a><br>"
	contents += "</center>"
	var/datum/browser/popup = new(user, "Grand Contract Ledger", "", 500, 300)
	popup.set_content(contents)
	popup.open()

/obj/structure/fake_machine/contractledger/proc/consult_contracts(mob/user)
	if(!(user in SStreasury.bank_accounts))
		say("You have no bank account.")
		return

	var/list/difficulty_data = list(
		QUEST_DIFFICULTY_EASY = list(deposit = QUEST_DEPOSIT_EASY),
		QUEST_DIFFICULTY_MEDIUM = list(deposit = QUEST_DEPOSIT_MEDIUM),
		QUEST_DIFFICULTY_HARD = list(deposit = QUEST_DEPOSIT_HARD)
	)

	// Create a list with formatted difficulty choices showing deposits
	var/list/difficulty_choices = list()
	for(var/difficulty in difficulty_data)
		var/deposit = difficulty_data[difficulty]["deposit"]
		difficulty_choices["[difficulty] ([deposit] mammon deposit)"] = difficulty

	var/selection = tgui_input_list(user, "Select contract difficulty (deposit required)", "CONTRACTS", difficulty_choices)
	if(!selection)
		return

	// Get the actual difficulty key from our formatted choice
	var/actual_difficulty = difficulty_choices[selection]
	var/deposit = difficulty_data[actual_difficulty]["deposit"]

	if(SStreasury.bank_accounts[user] < deposit)
		say("Insufficient balance funds. You need [deposit] mammons in your meister.")
		return

	var/type_choices = GLOB.global_quest_types

	var/type_selection = tgui_input_list(user, "Select contract type", "CONTRACTS", type_choices[actual_difficulty])

	if(!type_selection)
		return

	var/datum/job/mob_job = user.job ? SSjob.GetJob(user.job) : null
	if(!mob_job?.is_quest_giver)
		var/quest_number = 0
		for(var/obj/item/paper/scroll/quest/quest_scroll in GLOB.quest_scrolls)
			var/datum/weakref/weakref_datum = WEAKREF(user)
			if(quest_scroll.assigned_quest && !quest_scroll.assigned_quest.complete && quest_scroll.assigned_quest.quest_receiver_reference == weakref_datum)
				quest_number++
		var/max_quests_for_job = mob_job?.max_active_quests || 3
		if(quest_number >= max_quests_for_job)
			say("You have reached the maximum number of active quests. You can take up to [max_quests_for_job] active quests at a time.")
			return

	// Instantiate appropriate quest subtype
	var/datum/quest/attached_quest
	switch(type_selection)
		if(QUEST_RETRIEVAL)
			attached_quest = new /datum/quest/retrieval()
		if(QUEST_KILL_EASY)
			attached_quest = new /datum/quest/kill/easy()
		if(QUEST_COURIER)
			attached_quest = new /datum/quest/courier()
		if(QUEST_CLEAR_OUT)
			attached_quest = new /datum/quest/kill/clearout()
		if(QUEST_RAID)
			attached_quest = new /datum/quest/kill/raid()
		if(QUEST_OUTLAW)
			attached_quest = new /datum/quest/kill/outlaw()

	if(!attached_quest)
		to_chat(user, span_warning("Invalid quest type selected!"))
		return

	// Configure quest
	attached_quest.quest_difficulty = actual_difficulty
	attached_quest.deposit_amount = attached_quest.calculate_deposit()

	// Set giver or receiver
	if(mob_job?.is_quest_giver)
		attached_quest.quest_giver_name = user.real_name
		attached_quest.quest_giver_reference = WEAKREF(user)
	else
		attached_quest.quest_receiver_reference = WEAKREF(user)
		attached_quest.quest_receiver_name = user.real_name

	// Find appropriate landmark
	var/obj/effect/landmark/quest_spawner/chosen_landmark = find_quest_landmark(actual_difficulty, type_selection)
	if(!chosen_landmark)
		to_chat(user, span_warning("No suitable location found for this contract!"))
		qdel(attached_quest)
		return

	// Generate quest content (spawns mobs/items)
	if(!attached_quest.generate(chosen_landmark))
		to_chat(user, span_warning("Failed to generate quest content!"))
		qdel(attached_quest)
		return

	// Create scroll
	var/obj/item/paper/scroll/quest/spawned_scroll = new(get_turf(src))
	user.put_in_hands(spawned_scroll)
	log_quest(user.ckey, user.mind, user, "Take [attached_quest.quest_type]")
	spawned_scroll.base_icon_state = attached_quest.get_scroll_icon()
	spawned_scroll.assigned_quest = attached_quest
	attached_quest.quest_scroll = spawned_scroll
	attached_quest.quest_scroll_ref = WEAKREF(spawned_scroll)

	// Reward calculation comes after generation & scroll creation to factor in distance for courier quests
	attached_quest.reward_amount = attached_quest.calculate_reward(get_turf(chosen_landmark))

	// Update scroll text
	spawned_scroll.update_quest_text()

	// Charge deposit
	SStreasury.bank_accounts[user] -= deposit
	SStreasury.treasury_value += deposit
	SStreasury.log_entries += "+[deposit] to treasury (quest deposit)"

/obj/structure/fake_machine/contractledger/proc/find_quest_landmark(difficulty, type)
	// First try to find landmarks that match both difficulty AND type
	var/list/correctest_landmarks = list()
	GLOB.quest_landmarks_list = shuffle(GLOB.quest_landmarks_list)
	for(var/obj/effect/landmark/quest_spawner/landmark in GLOB.quest_landmarks_list)
		if(landmark.quest_difficulty != difficulty || !(type in landmark.quest_type))
			continue

		var/has_clients_around = FALSE
		for(var/mob/M in get_hearers_in_view(world.view, landmark))
			if(!M.client)
				continue

			has_clients_around = TRUE

		if(has_clients_around)
			continue

		correctest_landmarks += landmark

	if(length(correctest_landmarks))
		return pick(correctest_landmarks)

	// If none found, try landmarks that match just the difficulty
	var/list/correcter_landmarks = list()
	for(var/obj/effect/landmark/quest_spawner/landmark in GLOB.quest_landmarks_list)
		if(landmark.quest_difficulty != difficulty)
			continue

		var/has_clients_around = FALSE
		for(var/mob/M in get_hearers_in_view(world.view, landmark))
			if(!M.client)
				continue

			has_clients_around = TRUE

		if(has_clients_around)
			continue

		correcter_landmarks += landmark

	if(length(correcter_landmarks))
		return pick(correcter_landmarks)

	return null

/obj/structure/fake_machine/contractledger/proc/turn_in_contract(mob/user, obj/item/paper/scroll/quest/scroll_in_hand)
	if(scroll_in_hand)
		var/list/mob/quest_assignees = scroll_in_hand.get_quest_assignees(user, TRUE)
		if(!(user in quest_assignees))
			to_chat(user, span_warning("You are not the assigned quest receiver for this contract!"))
			return
		turn_in_scroll(user, scroll_in_hand)
	else
		for(var/obj/item/paper/scroll/quest/floor_scroll in input_point)
			var/list/mob/quest_assignees = floor_scroll.get_quest_assignees(user, TRUE)
			if(!(user in quest_assignees))
				continue
			turn_in_scroll(user, floor_scroll)


/obj/structure/fake_machine/contractledger/proc/turn_in_scroll(mob/user, obj/item/paper/scroll/quest/scroll)
	var/reward = 0
	var/original_reward = 0
	var/total_deposit_return = 0
	var/tax_rate = SStreasury.tax_value
	var/tax_amt = 0

	if(scroll.assigned_quest?.complete)
		// Calculate base reward
		var/base_reward = scroll.assigned_quest.reward_amount
		original_reward += base_reward

		// Calculate deposit return
		var/deposit_return = scroll.assigned_quest.calculate_deposit()
		total_deposit_return += deposit_return

		// Apply Steward/Mechant bonus if applicable (only to the base reward)
		var/datum/job/mob_job = user.job ? SSjob.GetJob(user.job) : null
		if(mob_job?.is_quest_giver)
			reward += base_reward * QUEST_HANDLER_REWARD_MULTIPLIER
		else
			reward += base_reward

		// Add deposit return to both reward totals
		reward += deposit_return
		original_reward += deposit_return

		qdel(scroll.assigned_quest)
		qdel(scroll)

		// Tax payment
		tax_amt = round(tax_rate * reward)
		if(tax_amt > 0)
			reward -= tax_amt
			SStreasury.give_money_treasury(tax_amt, "quest completion tax - [src.name]")
			record_featured_stat(FEATURED_STATS_TAX_PAYERS, user, tax_amt)
			record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)

	cash_in(user, round(reward), original_reward, tax_amt)

/obj/structure/fake_machine/contractledger/proc/cash_in(mob/user, reward, original_reward, tax_amt)
	add_mammons_to_atom(user, reward)

	if(reward > 0)
		say(reward > original_reward ? \
			"Your handler assistance-increased reward of [reward] mammons has been dispensed! The difference is [reward - original_reward] mammons. ([tax_amt] mammons taxed.)" : \
			"Your reward of [reward] mammons has been dispensed. ([tax_amt] mammons taxed.)")

/obj/structure/fake_machine/contractledger/proc/abandon_contract(mob/user)
	var/obj/item/paper/scroll/quest/abandoned_scroll = locate() in input_point
	if(!abandoned_scroll)
		to_chat(user, span_warning("No contract scroll found in the input area!"))
		return

	var/datum/quest/quest = abandoned_scroll.assigned_quest
	if(!quest)
		to_chat(user, span_warning("This scroll doesn't have an assigned contract!"))
		return

	if(quest.complete)
		turn_in_contract(user)
		return

	var/refund = quest.calculate_deposit()

	// First try to return to quest giver
	var/mob/giver = quest.quest_giver_reference?.resolve()
	if(giver && (giver in SStreasury.bank_accounts))
		SStreasury.bank_accounts[giver] += refund
		SStreasury.treasury_value -= refund
		SStreasury.log_entries += "-[refund] from treasury (contract refund to handler)"
		to_chat(user, span_notice("The deposit has been returned to the contract giver."))
	// Otherwise try quest receiver
	else if(quest.quest_receiver_reference)
		var/mob/receiver = quest.quest_receiver_reference.resolve()
		if(receiver && (receiver in SStreasury.bank_accounts))
			SStreasury.bank_accounts[receiver] += refund
			SStreasury.treasury_value -= refund
			SStreasury.log_entries += "-[refund] from treasury (contract refund to volunteer)"
			to_chat(user, span_notice("You receive a [refund] mammon refund for abandoning the contract."))
		else
			cash_in(user, refund)
			SStreasury.treasury_value -= refund
			SStreasury.log_entries += "-[refund] from treasury (contract refund)"
			to_chat(user, span_notice("Your refund of [refund] mammon has been dispensed."))

	// Clean up quest items
	if(quest.quest_type == QUEST_COURIER && quest.target_delivery_item)
		quest.target_delivery_item = null
		for(var/obj/item/I in world)
			if(istype(I, quest.target_delivery_item))
				var/datum/component/quest_object/Q = I.GetComponent(/datum/component/quest_object)
				if(Q && Q.quest_ref == WEAKREF(quest))
					I.remove_filter("quest_item_outline")
					qdel(Q)
					qdel(I)

	log_quest(user.ckey, user.mind, user, "Abandon [abandoned_scroll.assigned_quest.quest_type]")
	abandoned_scroll.assigned_quest = null
	qdel(quest)
	qdel(abandoned_scroll)

/obj/structure/fake_machine/contractledger/proc/print_contracts(mob/user)
	var/list/active_quests = list()
	for(var/obj/item/paper/scroll/quest/quest_scroll in GLOB.quest_scrolls)
		if(quest_scroll.assigned_quest && !quest_scroll.assigned_quest.complete)
			active_quests += quest_scroll

	if(!length(active_quests))
		say("No active contracts found.")
		return

	var/obj/item/paper/scroll/report = new(get_turf(src))
	report.name = "Guild Contract Report"
	report.desc = "A list of currently active contracts issued by the Mercenary's Guild."

	var/report_text = "<center><b>MERCENARY'S GUILD - ACTIVE CONTRACTS</b></center><br><br>"
	report_text += "<i>Generated on [station_time_timestamp()]</i><br><br>"

	for(var/obj/item/paper/scroll/quest/quest_scroll in active_quests)
		var/datum/quest/quest = quest_scroll.assigned_quest
		var/area/quest_area = get_area(quest_scroll)
		report_text += "<b>Title:</b> [quest.title].<br>"
		report_text += "<b>Issuer:</b> [quest.quest_giver_name ? quest.quest_giver_name : "Mercenary's Guild"].<br>"
		report_text += "<b>Recipient:</b> [quest.quest_receiver_name ? quest.quest_receiver_name : "Unclaimed"].<br>"
		report_text += "<b>Type:</b> [quest.quest_type].<br>"
		report_text += "<b>Difficulty:</b> [quest.quest_difficulty].<br>"
		report_text += "<b>Last Known Location:</b> [quest_area ? quest_area.name : "Unknown Location"].<br>"
		report_text += "<b>Reward:</b> [quest.reward_amount] mammons.<br><br>"

	report.info = report_text
	say("Contract report printed.")
