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
	var/mob/living/carbon/human/H = owner?.current
	if(!H)
		return

	var/list/available_types = list()
	for(var/datum/quest/custom/harlequinn_objective/T as anything in subtypesof(/datum/quest/custom/harlequinn_objective))
		if(IS_ABSTRACT(T))
			continue
		available_types += T

	if(!length(available_types))
		var/datum/objective/survive/surv = new()
		surv.owner = owner
		objectives += surv
		return

	available_types = shuffle(available_types)
	var/assigned = 0
	for(var/quest_type as anything in available_types)
		if(assigned >= 3)
			break

		var/datum/quest/custom/harlequinn_objective/OQ = new quest_type()
		OQ.owning_harlequinn = WEAKREF(src)
		OQ.generate(null)

		if(!OQ.setup_for_harlequinn(src))
			qdel(OQ)
			continue

		// Set giver to the harlequinn themselves so scroll text makes sense
		OQ.quest_giver_reference = WEAKREF(H)
		OQ.quest_giver_name = "The Theatre"

		// Create the quest scroll
		var/obj/item/paper/scroll/quest/scroll = new(get_turf(H))
		scroll.base_icon_state = OQ.get_scroll_icon()
		scroll.assigned_quest = OQ
		OQ.quest_scroll = scroll
		OQ.quest_scroll_ref = WEAKREF(scroll)
		OQ.quest_receiver_reference = WEAKREF(H)
		OQ.quest_receiver_name = H.real_name
		OQ.accepted_time = world.time
		scroll.update_quest_text()

		// Try belt first, then hands, then just leave it on the turf
		var/stored = FALSE
		var/obj/item/belt = H.get_item_by_slot(ITEM_SLOT_BELT)
		if(belt)
			SEND_SIGNAL(belt, COMSIG_TRY_STORAGE_INSERT, scroll, null, null, TRUE, TRUE)
			stored = scroll.loc == belt // check it actually went in
		if(!stored)
			H.put_in_hands(scroll)

		// Wrap in a standard objective for the antag panel
		var/datum/objective/harlequinn_contract/obj = new()
		obj.owner = owner
		obj.explanation_text = OQ.get_objective_text()
		obj.linked_quest = WEAKREF(OQ)
		objectives += obj

		active_contracts += OQ
		assigned++

	if(!assigned)
		var/datum/objective/survive/surv = new()
		surv.owner = owner
		objectives += surv

/datum/objective/harlequinn_contract
	var/datum/weakref/linked_quest // weakref to /datum/quest/custom/harlequinn_objective

/datum/objective/harlequinn_contract/check_completion()
	var/datum/quest/custom/harlequinn_objective/OQ = linked_quest?.resolve()
	if(OQ && !QDELETED(OQ))
		return OQ.check_completion()
	return TRUE

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
