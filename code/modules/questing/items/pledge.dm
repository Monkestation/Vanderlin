#define PLEDGE_BLANK "blank"
#define PLEDGE_FILLED "filled"
#define PLEDGE_SEALED "sealed"
#define PLEDGE_POSTED "posted"

/obj/item/paper/scroll/quest/pledge
	name = "blank quest pledge"
	desc = "A heavy parchment with an ornate guild seal at the top. Fill it out to commission a quest."
	icon_state = "scroll_blank"

	var/pledge_state = PLEDGE_BLANK

	var/pledge_reagent_type = null // type path
	var/pledge_reagent_name = ""
	var/pledge_reagent_volume = 10

	var/pledge_generic_count = 0

	var/pledge_title = ""
	var/pledge_objective = ""
	var/pledge_mode = "" // "item" or "freeform"
	var/pledge_item_type = null // /obj/item subtype, item mode only
	var/pledge_item_name = ""
	var/pledge_item_count = 1
	var/pledge_difficulty = QUEST_DIFFICULTY_EASY
	var/pledge_reward = 0 // mammons promised

	var/pledge_assassin_target = ""
	var/pledge_delivery_target = ""
	var/list/obj/item/packed_delivery_items = list()

	/// Mammons actually held inside the scroll after sealing.
	var/escrowed_mammons = 0

	/// Weakref to the live /datum/quest/custom once posted.
	var/datum/weakref/posted_quest_ref

/obj/item/paper/scroll/quest/pledge/examine(mob/user)
	. = ..()
	if(pledge_mode == "assassinate" && pledge_assassin_target)
		. += span_notice("Target: <b>[pledge_assassin_target]</b>")
	if(pledge_mode == "delivery" && pledge_delivery_target)
		. += span_notice("Recipient: <b>[pledge_delivery_target]</b>")
	if(pledge_mode == "delivery" && length(packed_delivery_items))
		. += span_notice("Packed items:")
		for(var/obj/item/I in packed_delivery_items)
			. += span_notice(" -- [I.name]")
	if(pledge_mode == "reagent" && pledge_reagent_name)
		. += span_notice("Reagent: <b>[pledge_reagent_name]</b> - [pledge_reagent_volume] ligulae required.")

	switch(pledge_state)
		if(PLEDGE_BLANK)
			. += span_notice("The parchment is blank. Use it in-hand to fill out a quest commission.")
		if(PLEDGE_FILLED)
			. += span_notice("Title: <b>[pledge_title]</b>")
			. += span_notice("Difficulty: [pledge_difficulty] | Reward offered: [pledge_reward] mammons")
			if(pledge_mode == "item")
				. += span_notice("Objective: Bring [pledge_item_count]x [pledge_item_name].")
			else
				. += span_notice("Objective: [pledge_objective]")
			. += span_warning("Not yet sealed. Coins have not been committed.")
		if(PLEDGE_SEALED)
			. += span_notice("Title: <b>[pledge_title]</b>")
			. += span_notice("Difficulty: [pledge_difficulty] | Reward escrowed: [escrowed_mammons] mammons")
			. += span_warning("SEALED. Hand to a steward to post, or activate to unseal and reclaim coins.")
		if(PLEDGE_POSTED)
			. += span_notice("This pledge has been posted to the guild board. The quest is now live.")

/obj/item/paper/scroll/quest/pledge/attack_self(mob/living/carbon/human/user)
	switch(pledge_state)
		if(PLEDGE_BLANK)
			do_fill_out(user)
		if(PLEDGE_FILLED)
			var/choice = tgui_input_list(user, "What would you like to do?", "Quest Pledge",
				list("Edit / Review", "Seal & Commit Coins", "Discard"))
			switch(choice)
				if("Edit / Review")
					do_fill_out(user)
				if("Seal & Commit Coins")
					do_seal(user)
				if("Discard")
					qdel(src)
		if(PLEDGE_SEALED)
			var/choice = tgui_input_list(user, "This pledge is sealed. Unseal to reclaim your coins?",
				"Quest Pledge", list("Unseal & Refund", "Cancel"))
			if(choice == "Unseal & Refund")
				do_unseal(user)
		if(PLEDGE_POSTED)
			to_chat(user, span_warning("This pledge has already been posted. It cannot be altered."))

/obj/item/paper/scroll/quest/pledge/proc/do_fill_out(mob/user)
	var/list/available = list()
	for(var/datum/quest/custom/t as anything in subtypesof(/datum/quest/custom))
		if(IS_ABSTRACT(t))
			continue
		var/label = initial(t.issue_label)
		if(!label)
			continue
		if(!(initial(t.custom_quest_flags) & CUSTOM_QUEST_PLEDGE))
			continue
		if(ispath(t, /datum/quest/custom/job_quest))
			var/datum/quest/custom/job_quest/job_quest = t
			var/required = initial(job_quest.required_job)
			if(required)
				var/datum/job/mob_job = user.job ? SSjob.GetJob(user.job) : null
				if(!istype(mob_job, required))
					continue
		available += label

	var/mode_choice = tgui_input_list(user, "What kind of quest are you commissioning?", "Quest Pledge", available)
	if(!mode_choice)
		return

	var/quest_path
	for(var/datum/quest/custom/t as anything in subtypesof(/datum/quest/custom))
		if(IS_ABSTRACT(t))
			continue
		if(initial(t.issue_label) == mode_choice)
			quest_path = t
			break

	var/datum/quest/custom/CQ = new quest_path()
	if(!CQ.build_from_user(user))
		qdel(CQ)
		return

	pledge_mode = mode_choice
	CQ.build_pledge(src)
	qdel(CQ)

	pledge_state = PLEDGE_FILLED
	name = "quest pledge: [pledge_title]"
	desc = "A filled quest pledge offering [pledge_reward] mammons. Seal it to commit the coins."
	to_chat(user, span_notice("Pledge filled out. Activate in hand again to seal and commit your coins."))

/obj/item/paper/scroll/quest/pledge/attackby(obj/item/I, mob/living/carbon/human/user, params)
	if(pledge_mode == "Item Delivery" && pledge_state == PLEDGE_FILLED)
		if(!(I in user))
			return ..()
		if(length(packed_delivery_items) >= 5)
			to_chat(user, span_warning("The pledge can hold at most 5 items."))
			return
		I.forceMove(src)
		packed_delivery_items += I
		to_chat(user, span_notice("You tuck [I.name] into the pledge. ([length(packed_delivery_items)]/5)"))
		return
	return ..()

/obj/item/paper/scroll/quest/pledge/proc/do_seal(mob/user)
	if(pledge_state != PLEDGE_FILLED)
		return

	if(!pledge_title || !pledge_mode || pledge_reward < 1)
		to_chat(user, span_warning("The pledge isn't fully filled out."))
		return

	var/balance = get_mammons_in_atom(user)
	if(balance < pledge_reward)
		to_chat(user, span_warning("You don't have enough mammons. You need [pledge_reward] but only have [balance]."))
		return

	if(!tgui_alert(user,
		"Sealing will take [pledge_reward] mammons from you and hold them in this scroll.\nYou can unseal it later to reclaim the coins if the quest hasn't been posted yet.",
		"Confirm Seal", list("Seal It", "Cancel")) == "Seal It")
		return

	if(!remove_mammons_from_atom(user, pledge_reward))
		to_chat(user, span_warning("Failed to deduct mammons. Make sure you have enough in your coin purse."))
		return

	escrowed_mammons = pledge_reward
	pledge_state = PLEDGE_SEALED
	name = "SEALED quest pledge: [pledge_title]"
	desc = "A sealed quest pledge. The [escrowed_mammons] mammon reward is held inside. Hand to a steward to post."
	to_chat(user, span_notice("Sealed! The scroll now holds [escrowed_mammons] mammons in escrow. Take it to a guild steward to have it posted."))

/obj/item/paper/scroll/quest/pledge/proc/do_unseal(mob/user)
	if(pledge_state != PLEDGE_SEALED)
		return

	var/refund = escrowed_mammons
	escrowed_mammons = 0
	add_mammons_to_atom(user, refund)

	pledge_state = PLEDGE_FILLED
	name = "quest pledge: [pledge_title]"
	desc = "A filled quest pledge offering [pledge_reward] mammons. Seal it to commit the coins."
	to_chat(user, span_notice("Unsealed. [refund] mammons returned to you."))

/obj/item/paper/scroll/quest/pledge/proc/post_to_board(mob/steward, obj/structure/notice_board/board)
	if(pledge_state != PLEDGE_SEALED)
		to_chat(steward, span_warning("This pledge isn't sealed yet."))
		return null
	if(!escrowed_mammons || escrowed_mammons < 1)
		to_chat(steward, span_warning("No coins are escrowed in this pledge."))
		return null

	// Find the subtype whose issue_label matches pledge_mode.
	// Pledge mode strings still correspond to issue_label values set on each subtype,
	// so no string table is needed — we iterate subtypes exactly once.
	var/quest_path
	for(var/datum/quest/custom/t as anything in subtypesof(/datum/quest/custom))
		if(IS_ABSTRACT(t))
			continue
		// Match on the pledge_mode field; pledge_mode is set from the issue_label
		// when do_fill_out() runs (see bottom of this proc's notes).
		if(initial(t.issue_label) == pledge_mode)
			quest_path = t
			break

	if(!quest_path)
		to_chat(steward, span_warning("Unrecognised quest mode \"[pledge_mode]\" in this pledge."))
		return null

	var/datum/quest/custom/CQ = new quest_path()
	if(!CQ.build_from_pledge(src, steward))
		to_chat(steward, span_warning("Could not build the quest from this pledge. Check all required fields are filled."))
		qdel(CQ)
		return null

	if(!SSquestboard.issue_custom_quest_funded(steward, CQ, escrowed_mammons))
		to_chat(steward, span_warning("The board couldn't accept this pledge right now."))
		// Return packed items to the turf if it was a delivery quest
		if(istype(CQ, /datum/quest/custom/delivery))
			var/datum/quest/custom/delivery/DQ = CQ
			for(var/obj/item/I in DQ.pending_items)
				I.forceMove(get_turf(steward))
		qdel(CQ)
		return null

	escrowed_mammons = 0
	pledge_state = PLEDGE_POSTED
	posted_quest_ref = WEAKREF(CQ)
	name = "posted quest pledge: [pledge_title]"
	desc = "This pledge has been accepted by the guild. The quest is now live on the board."

	CQ.generate(null)
	CQ.pledge_ref = WEAKREF(src)
	return CQ

/obj/item/paper/scroll/quest/pledge/proc/generate_pledge_title()
	switch(pledge_mode)
		if("item")
			return "Bring [pledge_item_count]x [pledge_item_name]"
		if("assassinate")
			return "Eliminate [pledge_assassin_target ? pledge_assassin_target : "unknown target"]"
		if("delivery")
			return "Deliver parcel to [pledge_delivery_target ? pledge_delivery_target : "unknown recipient"]"
		if("reagent")
			return "Provide [pledge_reagent_volume] ligulae [pledge_reagent_name ? pledge_reagent_name : "reagent"]"
	return "Commission: [pledge_objective ? copytext(pledge_objective, 1, 40) : "Unknown"]"

/obj/item/paper/scroll/quest/pledge/proc/get_min_reward(diff)
	switch(diff)
		if(QUEST_DIFFICULTY_EASY)
			return 50
		if(QUEST_DIFFICULTY_MEDIUM)
			return 150
		if(QUEST_DIFFICULTY_HARD)
			return 300
	return 50

/// Standalone item search used by pledge (mirrors notice_board's proc).
/proc/search_item_types_global(query) //I coulda sworn we had this type of code before but I couldn't find it
	var/list/results = list()
	query = LOWER_TEXT(query)
	for(var/obj/item/item_type as anything in subtypesof(/obj/item))
		if(IS_ABSTRACT(item_type))
			continue
		var/iname = LOWER_TEXT(initial(item_type.name))
		if(findtext(iname, query))
			var/display = "[initial(item_type.name)] ([item_type])"
			results[display] = item_type
			if(length(results) >= 20)
				break
	return results

/proc/search_reagent_types_global(query)
	var/list/results = list()
	query = LOWER_TEXT(query)
	for(var/datum/reagent/reagent_type as anything in subtypesof(/datum/reagent))
		if(IS_ABSTRACT(reagent_type))
			continue
		var/rname = LOWER_TEXT(initial(reagent_type.name))
		if(findtext(rname, query))
			results[initial(reagent_type.name)] = reagent_type // type path as value
			if(length(results) >= 20)
				break
	return results

#undef PLEDGE_BLANK
#undef PLEDGE_FILLED
#undef PLEDGE_SEALED
#undef PLEDGE_POSTED
