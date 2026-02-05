/obj/item/servant_bell
	name = "servant bell"
	desc = "An enchanted bell whose chime resonates in the minds of those bound to it."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "servantbell"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_MOUTH
	w_class = WEIGHT_CLASS_SMALL
	dyeable = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_MAGE_BLUE
	sellprice = VALUE_SILVER_TINY_ITEM

	dropshrink = 0.7
	grid_height = 32
	grid_width = 32

	/// associative list of the names of servants to a weakref to their brain
	var/alist/bound_servants = list()
	var/max_servants = 6
	/// used for adding roundstart individuals to the bell. This will actively update the targets if they cryo or latejoin.
	var/list/job_targets
	/// jobs who can use/configure this bell without needing to be a noble
	var/list/noble_exemptions = list(/datum/job/butler)

	COOLDOWN_DECLARE(ring_bell)
	var/cooldown = 3 MINUTES
	var/noble_cooldown = 1 MINUTES
	COOLDOWN_DECLARE(nearby_ring_bell)
	var/nearby_cooldown = 5 SECONDS
	var/hear_distance = 40 // just a little shorter than Vanderlin's manor

/obj/item/servant_bell/Initialize(mapload)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_new_jobber))
	RegisterSignal(SSdcs, COMSIG_GLOB_HUMAN_ENTER_CRYO, PROC_REF(remove_servant)) // cryo'd people can just get removed, qol.
	// somehow we've been created after setup with job targets, maybe we're in a latejoin butler's satchel?
	if(job_targets && SSticker.current_state > GAME_STATE_PREGAME)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(is_type_in_list(H.mind?.assigned_role, job_targets) || is_type_in_list(SSjob.GetJob(H.job), job_targets))
				add_servant(H)

/obj/item/servant_bell/Destroy()
	UnregisterSignal(SSdcs, list(COMSIG_GLOB_JOB_AFTER_SPAWN, COMSIG_GLOB_HUMAN_ENTER_CRYO))
	bound_servants = null
	. = ..()

/obj/item/servant_bell/examine(mob/user)
	. = ..()
	if((is_bell_proficient(user) && get_dist(src, user) <= 1) || isdead(user))
		var/len = length(bound_servants)
		. += span_info("It has [len] servant[len == 1 ? "" : "s"] bound to it.")
		. += span_notice("Use on a commoner to bind their mind to the bell.")
		. += span_notice("Right click with an open hand to relinquish servants.")

/obj/item/servant_bell/afterattack(atom/target, mob/living/user, proximity_flag, list/modifiers)
	. = ..()
	if(!COOLDOWN_FINISHED(src, nearby_ring_bell) || !is_bell_proficient(user) || !ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(!H.mind)
		return
	if(length(bound_servants) >= max_servants)
		to_chat(user, span_warning("It can hold no more minds without relinquishing another."))
	playsound(src, 'sound/items/servant_bell.ogg', 80, TRUE)
	user.visible_message(span_noticesmall("[user] rings [src] in front of [user == H ? "[user.p_them()]self" : H] like a pendulum..."))
	if(do_after(user, 6 SECONDS, H))
		if((H.real_name in bound_servants) && H.name == H.real_name)
			to_chat(user, span_warning("[src] is already bound to this bell."))
		else if(H.is_dead())
			to_chat(user, span_warning("What good is a dead servant?"))
		else if(H.mind?.has_antag_datum(/datum/antagonist/zombie))
			to_chat(user, span_warning("The deadite curse resists the bell's charm."))
		else if(HAS_TRAIT(H, TRAIT_NOBLE) || H.can_block_magic(MAGIC_RESISTANCE_MIND, 0) || H.job == "Faceless One") // this'll screw over a noble blood butler, thems the breaks
			to_chat(user, span_warning("The enchantment seems to fail."))
		else
			add_servant(H)
			to_chat(user, span_noticesmall("I bind [H] to [src]."))
	COOLDOWN_START(src, nearby_ring_bell, nearby_cooldown)

/obj/item/servant_bell/attack_hand_secondary(mob/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!user.client)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!is_bell_proficient(user))
		to_chat(user, span_warning("I lack the noble blood to modify [src]."))
		return
	if(!length(bound_servants))
		to_chat(user, span_warning("There are no servants bound to [src]."))
		return
	var/list/servants = get_servants()
	var/list/all_servants = length(servants) > 1 ? list("Relinquish all" = null) + servants : servants
	var/remove = browser_input_list(user, "Who will be relinquished of service?","Service Bell", all_servants)
	if(remove)
		if(remove == "Relinquish all")
			var/choice = input(user,"Are you sure you want to clear the servant list?","Service Bell",null) as null|anything in list("Yes", "No")
			if(choice != "Yes")
				return
			for(var/s_name in servants)
				remove_servant(servant = s_name)
			to_chat(user, span_noticesmall("All servants have been relinquished."))
		else
			remove_servant(servant = remove)
			to_chat(user, span_noticesmall("[remove] has been relinquished."))

/obj/item/servant_bell/attack_self(mob/living/user, params)
	. = ..()
	if(!istype(user)) // ???
		return
	if(COOLDOWN_FINISHED(src, nearby_ring_bell))
		COOLDOWN_START(src, nearby_ring_bell, nearby_cooldown)
		var/end_time = is_bell_proficient(user) ? cooldown - noble_cooldown : 0
		if(COOLDOWN_TIMELEFT(src, ring_bell) <= end_time)
			ring_bell(user)
			COOLDOWN_START(src, ring_bell, cooldown)
		else
			playsound(src, 'sound/items/servant_bell.ogg', 80, TRUE)

/obj/item/servant_bell/proc/ring_bell(mob/living/user)
	user.visible_message("[user] rings [src].")
	playsound(src, 'sound/items/servant_bell.ogg', 100, TRUE)
	var/turf/origin_turf = get_turf(src)
	for(var/servant in get_servants())
		var/datum/weakref/wr = bound_servants[servant]
		if(!istype(wr))
			continue
		var/obj/item/organ/brain/B = wr.resolve()
		if(!B || !B.owner)
			continue
		var/mob/living/carbon/player = B.owner
		if(!player.client)
			continue
		if(player.stat >= DEAD)
			continue
		if(!player.can_hear())
			continue
		if(player.can_block_magic(MAGIC_RESISTANCE_MIND, 0))
			continue
		if(!is_in_zweb(player.z, origin_turf.z))
			continue
		var/distance = get_dist(player, origin_turf)
		if(distance > hear_distance)
			continue
		player.apply_status_effect(/datum/status_effect/signal_horn/servant_bell, null, origin_turf)
		var/dirText = ""
		var/z_dist = origin_turf.z - player.z
		if(z_dist != 0)
			var/abs_z = abs(z_dist) // we can tell which floor it's on if it's only 2 away
			switch(abs_z)
				if(1)
					dirText += " one story"
				if(2)
					dirText += " two stories"
				else
					dirText += " far"
			dirText += z_dist > 0 ? " above me" : " below me"
		to_chat(player, span_warning("I hear a service bell being rung[dirText]."))
		if(distance <= 7)
			continue
		//sound played for other players, by fem_tanyl !!!1!!
		player.playsound_local(get_turf(player), 'sound/items/servant_bell.ogg', 35, FALSE, pressure_affected = FALSE)

/obj/item/servant_bell/proc/add_servant(mob/living/carbon/human/H)
	if(length(bound_servants) >= max_servants)
		return
	var/obj/item/organ/brain/B = H.getorgan(/obj/item/organ/brain)
	if(!istype(B))
		return
	bound_servants[H.real_name] = WEAKREF(B)

/// used as both a signal register and a general proc. ambiguous servant arg, takes mob/living/carbon/human or text
/obj/item/servant_bell/proc/remove_servant(datum/source, servant)
	var/s_name
	if(ishuman(servant))
		var/mob/living/carbon/human/H = servant
		s_name = H.real_name
	else if(istext(servant))
		s_name = servant
	else
		return
	if(bound_servants[s_name])
		bound_servants[s_name] = null
	bound_servants -= s_name

/// cleans up weakrefs, returns brains instead
/obj/item/servant_bell/proc/get_servants()
	var/list/servants = list()
	for(var/servant in bound_servants)
		var/obj/item/organ/brain/B
		if(bound_servants[servant])
			var/datum/weakref/brain_ref = bound_servants[servant]
			B = brain_ref.resolve()
			if(!B)
				//we're not gonna remove the name, it'd tell them that they died
				bound_servants[servant] = null
		servants[servant] = B
	return servants

/obj/item/servant_bell/proc/on_new_jobber(source, datum/job/job, mob/living/spawned, client/player_client)
	if(!(spawned && player_client && job))
		return
	if(ishuman(spawned) && is_type_in_list(job, job_targets))
		add_servant(spawned)

/obj/item/servant_bell/proc/is_bell_proficient(mob/living/user)
	return HAS_TRAIT(user, TRAIT_NOBLE) || is_type_in_list(user.mind?.assigned_role, noble_exemptions) || is_type_in_list(SSjob.GetJob(user.job), noble_exemptions)

/// Keep Bell
/obj/item/servant_bell/lord
	job_targets = list(/datum/job/servant, /datum/job/butler)
	uses_lord_coloring = LORD_PRIMARY

/obj/item/servant_bell/lord/Initialize(mapload)
	uses_lord_coloring = pick(LORD_PRIMARY, LORD_SECONDARY)
	. = ..()


/datum/status_effect/signal_horn/servant_bell
	id = "servant bell indicator"
	duration = 25 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/servant_bell

/atom/movable/screen/alert/status_effect/servant_bell
	name = "Servant Bell"
	desc = "I've been summoned by the bell."
	icon_state = "servant_bell"
