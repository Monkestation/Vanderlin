/datum/antagonist/harlequinn
	name = "Harlequinn"
	roundend_category = "Harlequinn"
	antagpanel_category = "Harlequinn"
	job_rank = ROLE_HARLEQUINN
	antag_hud_name = "harlequinn"
	confess_lines = list(
		"I was just fulfilling contracts!",
		"The bounties called to me!",
		"I only take what jobs pay well!",
	)
	var/list/available_contracts = list()
	var/list/active_contracts = list()
	var/list/completed_contracts = list()
	var/reputation = 0
	var/total_earnings = 0

/datum/antagonist/harlequinn/on_gain()
	. = ..()
	if(owner?.current)
		equip_harlequinn()
		give_objectives()

/datum/antagonist/harlequinn/proc/equip_harlequinn()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return

	H.unequip_everything()
	H.equipOutfit(/datum/outfit/harlequin)

/datum/antagonist/harlequinn/proc/give_objectives()
	var/list/contract_choices = list()
	for(var/datum/bounty_contract/contract in available_contracts)
		if(!contract.assigned_to_harlequinn && !contract.completed && !contract.failed)
			contract_choices[contract.get_description()] = contract

	if(!length(contract_choices))
		var/datum/objective/survive/surv = new()
		surv.owner = owner
		objectives += surv
		return

	var/contracts_selected = 0
	while(contracts_selected < 3 && length(contract_choices))
		var/choice = input(owner.current, "Select a contract (you can choose up to 3):", "Contract Selection") as null|anything in contract_choices + list("Finish Selection")

		if(choice == "Finish Selection" || !choice)
			break

		var/datum/bounty_contract/selected = contract_choices[choice]
		selected.assigned_to_harlequinn = TRUE
		active_contracts += selected
		contract_choices -= choice
		contracts_selected++

		var/datum/objective/harlequinn_contract/obj = new()
		obj.owner = owner
		obj.contract = selected
		obj.explanation_text = "Complete the contract: [selected.get_description()]"
		objectives += obj

/datum/bounty_contract/proc/get_description()
	switch(contract_type)
		if("theft")
			return "Steal [target_name] for [payment] coins"
		if("kidnapping")
			return "Kidnap [target_name] and bring them to [delivery_location] for [payment] coins"
		if("assassination")
			return "Eliminate [target_name] for [payment] coins"
		if("smuggling")
			return "Transport contraband to [delivery_location] for [payment] coins"
		if("sabotage")
			return "Sabotage [target_name] for [payment] coins"
		if("impersonation")
			return "Impersonate [target_name] for [payment] coins"
		if("burial")
			return "Bury item at [delivery_location] for [payment] coins"
	return "Unknown contract type"


/datum/objective/harlequinn_contract
	var/datum/bounty_contract/contract

/datum/objective/harlequinn_contract/check_completion()
	return contract?.completed || FALSE


/obj/item/harlequinn_disguise_kit
	name = "professional disguise kit"
	desc = "A collection of makeup, prosthetics, and costume pieces for mundane disguises."
	//icon = 'icons/obj/items.dmi'
	icon_state = "disguise_kit"
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 32
	grid_height = 32

/obj/item/harlequinn_disguise_kit/attack_self(mob/user, list/modifiers)
	var/list/options = list(
		"Quick Disguise" = "quick",
		"Detailed Disguise" = "detailed",
		"Remove Disguise" = "remove"
	)

	var/choice = input(user, "What would you like to do?", "Disguise Kit") as null|anything in options
	if(!choice)
		return

	switch(options[choice])
		if("quick")
			quick_disguise(user)
		if("detailed")
			detailed_disguise(user)
		if("remove")
			remove_disguise(user)

/obj/item/harlequinn_disguise_kit/proc/quick_disguise(mob/user)
	to_chat(user, span_notice("You quickly apply a basic disguise..."))
	if(do_after(user, 30 SECONDS, target = user))
		user.name = "Unknown"
		to_chat(user, span_notice("You look like a different person, though the disguise won't fool close inspection."))

/obj/item/harlequinn_disguise_kit/proc/detailed_disguise(mob/user)
	var/new_name = browser_input_text(user, "What name should you appear as?", "DISGUISE", max_length = MAX_NAME_LEN)
	if(!new_name)
		return

	to_chat(user, span_notice("You carefully apply an elaborate disguise..."))
	if(do_after(user, 120 SECONDS, target = user))
		user.name = new_name
		to_chat(user, span_notice("Your disguise is convincing and should fool most observers."))

/obj/item/harlequinn_disguise_kit/proc/remove_disguise(mob/user)
	to_chat(user, span_notice("You remove your disguise..."))
	if(do_after(user, 15 SECONDS, target = user))
		user.name = user.real_name
		to_chat(user, span_notice("You return to your normal appearance."))

/obj/structure/buried_cache
	name = "buried cache"
	desc = "Something has been buried here."
	icon = 'icons/turf/floors.dmi'
	icon_state = "dirt_cache"
	anchored = TRUE
	density = FALSE
	var/list/cached_items = list()
	var/cache_id
	var/buried_by

/obj/structure/buried_cache/Initialize(mapload, id, buried_by_name)
	. = ..()
	cache_id = id
	buried_by = buried_by_name

	if(cache_id && GLOB.persistent_caches[cache_id])
		cached_items = GLOB.persistent_caches[cache_id]

/obj/structure/buried_cache/attack_hand(mob/user)
	if(!length(cached_items))
		to_chat(user, span_notice("You dig around but find nothing."))
		return

	to_chat(user, span_notice("You begin digging up the buried cache..."))
	if(do_after(user, 30 SECONDS, target = src))
		for(var/obj/item/I in cached_items)
			I.forceMove(get_turf(src))
		cached_items = list()
		to_chat(user, span_notice("You unearth the buried items!"))
		qdel(src)

/obj/structure/buried_cache/proc/bury_item(obj/item/I, mob/user)
	I.forceMove(src)
	cached_items += I

	if(!GLOB.persistent_caches)
		GLOB.persistent_caches = list()
	GLOB.persistent_caches[cache_id] = cached_items

	to_chat(user, span_notice("You bury [I] in the cache."))

GLOBAL_LIST_EMPTY(persistent_caches)
