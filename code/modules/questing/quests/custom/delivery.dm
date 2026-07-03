/datum/quest/custom/delivery
	issue_label = "Item Delivery"
	/// Delivery quests are pledge-only, they cannot be issued directly from the board
	/// because the items must be physically packed into the pledge scroll first.
	custom_quest_flags = CUSTOM_QUEST_PLEDGE
	quest_type = QUEST_CUSTOM

	var/delivery_target_name = ""
	var/list/obj/item/pending_items = list()
	var/datum/weakref/parcel_ref

/datum/quest/custom/delivery/build_from_user(mob/user)
	var/list/player_names = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.real_name)
			player_names += H.real_name
	player_names = sortList(player_names)
	if(!length(player_names))
		return FALSE

	var/chosen = tgui_input_list(user, "Who should receive the parcel?", "Delivery Recipient", player_names)
	if(!chosen)
		return FALSE

	if(!fill_common_fields(user))
		return FALSE

	delivery_target_name = chosen
	quest_giver_reference = WEAKREF(user)
	quest_giver_name = user.real_name

	var/auto_title = get_title()
	var/custom_title = tgui_input_text(user, "Give this quest a title (blank = auto):", "Quest Title", "", 80)
	title = custom_title ? custom_title : auto_title
	return TRUE

/datum/quest/custom/delivery/build_pledge(obj/item/paper/scroll/quest/pledge/PL)
	..()
	PL.pledge_delivery_target = delivery_target_name

/datum/quest/custom/delivery/build_from_pledge(obj/item/paper/scroll/quest/pledge/PL, mob/steward)
	if(!..())
		return FALSE
	delivery_target_name = PL.pledge_delivery_target
	if(!delivery_target_name)
		return FALSE
	for(var/obj/item/I in PL.packed_delivery_items)
		if(!QDELETED(I))
			pending_items += I
			I.forceMove(src)
	PL.packed_delivery_items.Cut()
	return TRUE

/datum/quest/custom/delivery/get_title()
	if(title)
		return title
	return delivery_target_name ? "Deliver Parcel to [delivery_target_name]" : "Delivery Contract"

/datum/quest/custom/delivery/get_objective_text()
	return "Deliver the parcel to [delivery_target_name ? delivery_target_name : "the recipient"]. " \
		+ "Hand it to them directly, place it at their feet, or use the offer action."

/datum/quest/custom/delivery/get_location_text()
	return "Locate [delivery_target_name ? delivery_target_name : "the recipient"] and make the delivery."

/datum/quest/custom/delivery/generate(obj/effect/landmark/quest_spawner/landmark)
	add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_QUEST_CREATED, 1)
	if(!title)
		title = get_title()
	progress_required = 1
	return TRUE

/datum/quest/custom/delivery/check_completion()
	return progress_current >= progress_required

/datum/quest/custom/delivery/on_claim(mob/user)
	. = ..()
	var/spawn_turf = get_turf(quest_scroll) || get_turf(user)
	var/obj/item/quest_package/parcel = new(spawn_turf)
	parcel.name = "delivery parcel ([delivery_target_name])"
	parcel.quest_title = title
	parcel.pledge_ref = pledge_ref
	parcel.delivery_target_name = delivery_target_name

	for(var/obj/item/I in pending_items)
		if(!QDELETED(I))
			I.forceMove(parcel)
	pending_items.Cut()

	parcel_ref = WEAKREF(parcel)

	RegisterSignal(parcel, COMSIG_OBJ_HANDED_OVER, PROC_REF(on_parcel_handed_over))
	RegisterSignal(parcel, COMSIG_MOVABLE_MOVED, PROC_REF(on_parcel_moved))

	user.put_in_hands(parcel)

/datum/quest/custom/delivery/proc/on_parcel_handed_over(obj/item/quest_package/parcel, mob/offerer, mob/target)
	SIGNAL_HANDLER
	try_complete(parcel, offerer, target)

/datum/quest/custom/delivery/proc/on_parcel_moved(obj/item/quest_package/parcel, turf/old_turf, turf/new_turf)
	SIGNAL_HANDLER
	if(!isturf(parcel.loc))
		return
	for(var/mob/living/carbon/human/H in parcel.loc)
		if(H.real_name == delivery_target_name)
			try_complete(parcel, null, H)
			return

/datum/quest/custom/delivery/proc/on_parcel_used_on(obj/item/quest_package/parcel, atom/target, mob/user)
	SIGNAL_HANDLER
	if(!istype(target, /mob/living/carbon/human))
		return
	try_complete(parcel, user, target)

/datum/quest/custom/delivery/proc/try_complete(obj/item/quest_package/parcel, mob/deliverer, mob/recipient)
	if(complete)
		return
	if(!recipient || recipient.real_name != delivery_target_name)
		if(deliverer)
			to_chat(deliverer, span_warning("That's not the right recipient for this parcel."))
		return
	UnregisterSignal(parcel, list(COMSIG_OBJ_HANDED_OVER, COMSIG_MOVABLE_MOVED))
	progress_current = progress_required
	mark_complete()
	if(deliverer)
		to_chat(deliverer, span_notice("Delivery confirmed! Return your contract scroll to the Notice Board for payment."))
	to_chat(recipient, span_notice("You have received a parcel: [parcel.name]."))

/datum/quest/custom/delivery/Destroy()
	var/obj/item/quest_package/parcel = parcel_ref?.resolve()
	if(parcel && !QDELETED(parcel))
		UnregisterSignal(parcel, list(COMSIG_OBJ_HANDED_OVER, COMSIG_MOVABLE_MOVED))
	for(var/obj/item/I in pending_items)
		if(!QDELETED(I))
			I.forceMove(locate(1, 1, 1))
	pending_items.Cut()
	return ..()
