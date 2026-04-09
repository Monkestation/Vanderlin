GLOBAL_LIST_EMPTY(quest_scrolls)

#define WHISPER_COOLDOWN 10 SECONDS
/obj/item/paper/scroll/quest
	name = "enchanted contract scroll"
	desc = "A scroll oft known as a \"whispering scroll\". Enchanted with magicks to make it whisper to its bearer when opened the location of its target.\n\
	The magical protections make it resistant to damage and tampering. It will only whisper when carried on the person of the contract bearer."
	icon = 'icons/obj/questing.dmi'
	icon_state = "scroll_quest"
	base_icon_state = "scroll_quest"
	var/datum/quest/assigned_quest
	var/last_compass_direction = ""
	var/last_z_level_hint = ""
	var/last_whisper = 0 // Last time the scroll whispered to the user
	resistance_flags = FIRE_PROOF | LAVA_PROOF | INDESTRUCTIBLE | UNACIDABLE
	max_integrity = 1000
	armor = list("blunt" = 100, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 100, "acid" = 100)

	COOLDOWN_DECLARE(next_compass_scan)

/obj/item/paper/scroll/quest/Initialize()
	. = ..()
	if(assigned_quest)
		assigned_quest.quest_scroll = src
	update_quest_text()
	START_PROCESSING(SSprocessing, src)
	GLOB.quest_scrolls += src

/obj/item/paper/scroll/quest/Destroy()
	GLOB.quest_scrolls -= src
	if(assigned_quest)
		// Return deposit if scroll is destroyed before completion
		if(!assigned_quest.complete)
			var/refund = assigned_quest.calculate_deposit()

			// First try to return to quest giver if available
			var/mob/giver = assigned_quest.quest_giver_reference?.resolve()
			if(giver && (giver in SStreasury.bank_accounts))
				SStreasury.bank_accounts[giver] += refund
				SStreasury.treasury_value -= refund
				SStreasury.log_entries += "-[refund] from treasury (contract scroll destroyed refund to giver [giver.real_name])"
			// Otherwise try quest receiver
			else if(assigned_quest.quest_receiver_reference)
				var/mob/receiver = assigned_quest.quest_receiver_reference.resolve()
				if(receiver && (receiver in SStreasury.bank_accounts))
					SStreasury.bank_accounts[receiver] += refund
					SStreasury.treasury_value -= refund
					SStreasury.log_entries += "-[refund] from treasury (contract scroll destroyed refund to receiver [receiver.real_name])"

		// Clean up the quest
		qdel(assigned_quest)
		assigned_quest = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/paper/scroll/quest/update_icon_state()
	. = ..()
	if(open)
		icon_state = info ? "[base_icon_state]_info" : "[base_icon_state]"
	else
		icon_state = "[base_icon_state]_closed"


/obj/item/paper/scroll/quest/process()
	if(world.time > last_whisper + WHISPER_COOLDOWN)
		last_whisper = world.time
		target_whisper()

/obj/item/paper/scroll/quest/proc/target_whisper()
	if(!assigned_quest || assigned_quest.complete || !assigned_quest.quest_receiver_reference)
		return
	var/obj/itemloc = src.loc
	var/mob/quest_bearer = assigned_quest.quest_receiver_reference?.resolve()
	// I should refactor this out at some point
	if(!istype(itemloc, /mob/living))
		while(!istype(itemloc, /mob/living))
			if(isnull(itemloc))
				return
			itemloc = itemloc.loc
			if(istype(itemloc, /turf))
				return
	if(itemloc != quest_bearer)
		return
	if(open && quest_bearer)
		update_compass(quest_bearer)
		var/message = ""
		message = "[last_compass_direction]"
		if(last_z_level_hint)
			message += " ([last_z_level_hint])"
		to_chat(quest_bearer, span_info("The scroll whispers to you, the target is [message]"))

/obj/item/paper/scroll/quest/examine(mob/user)
	. = ..()
	if(!assigned_quest)
		return
	if(!assigned_quest.quest_receiver_reference)
		. += span_notice("This contract hasn't been claimed yet. Open it to claim it for yourself!")
	else if(assigned_quest.complete)
		. += span_notice("\nThis contract is complete! Return it to the Notice Board to claim your reward.")
		. += span_info("\nPlace it on the marked area next to the book.")
	else
		. += span_notice("\nThis contract is still in progress.")

/obj/item/paper/scroll/quest/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(P.get_sharpness())
		to_chat(user, span_warning("The enchanted scroll resists your attempts to tear it."))
		return
	if(istype(P, /obj/item/paper)) // Prevent merging with other papers/scrolls
		to_chat(user, span_warning("The magical energies prevent you from combining this with other scrolls."))
		return
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!open)
			to_chat(user, span_warning("You need to open the scroll first."))
			return
		if(!assigned_quest)
			to_chat(user, span_warning("This contract scroll doesn't accept modifications."))
			return
	..()

/obj/item/paper/scroll/quest/proc/get_quest_assignees(var/mob/user, var/include_giver = FALSE)
	var/list/assignees = list()

	var/mob/quest_receiver = assigned_quest?.quest_receiver_reference?.resolve()
	if(quest_receiver)
		assignees += quest_receiver

	if(include_giver)
		var/mob/quest_giver = assigned_quest?.quest_giver_reference?.resolve()
		if(quest_giver)
			assignees += quest_giver

	return assignees

/obj/item/paper/scroll/quest/fire_act(exposed_temperature, exposed_volume)
	return // Immune to fire

/obj/item/paper/scroll/quest/extinguish()
	return // No fire to extinguish

/obj/item/paper/scroll/quest/read(mob/user)
	refresh_compass(user)
	return ..()

/obj/item/paper/scroll/quest/attack_self(mob/user)
	. = ..()
	if(.)
		return

	// Only do claim logic if unclaimed
	if(!assigned_quest || assigned_quest.quest_receiver_reference)
		refresh_compass(user) // Refresh compass when opened by claimed user
		update_quest_text()
		return

	// Claim the quest
	assigned_quest.quest_receiver_reference = WEAKREF(user)
	assigned_quest.quest_receiver_name = user.real_name

	to_chat(user, span_notice("You claim this contract for yourself!"))
	update_quest_text()
	refresh_compass(user) // Update compass after claiming

/obj/item/paper/scroll/quest/attack_self_secondary(mob/user)
	if(!assigned_quest || assigned_quest.complete)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!COOLDOWN_FINISHED(src, next_compass_scan))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	COOLDOWN_START(src, next_compass_scan, 2 SECONDS)

	var/turf/target_turf = assigned_quest.get_target_location()
	if(!target_turf)
		to_chat(user, span_warning("The scroll cannot sense its target."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/turf/user_turf = get_turf(user)
	if(!user_turf)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/turf/compass_target = target_turf
	var/portal_hint

	if(target_turf.z != user_turf.z)
		if(!is_in_zweb(target_turf.z, user_turf.z))
			var/area/target_area = get_area(target_turf)
			var/obj/structure/fluff/traveltile/portal = find_portal_to_area(target_area, user_turf)
			if(portal)
				compass_target = get_turf(portal)
				portal_hint = "traverse to [target_area.name]"
			else
				to_chat(user, span_info("The scroll pulses faintly - the target is in [target_area.name], but you sense no path from here."))
				return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		else
			to_chat(user, span_info("The scroll pulses faintly - the target is on a different level."))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/dir = get_dir(user_turf, compass_target)
	if(!dir)
		if(portal_hint)
			to_chat(user, span_info("The scroll pulses warmly - the [portal_hint] is nearby."))
		else
			to_chat(user, span_info("The scroll pulses warmly - you are nearby."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/distance = get_dist(user_turf, compass_target)
	var/arrow_color
	switch(distance)
		if(1 to 15)
			arrow_color = COLOR_GREEN
		if(16 to 40)
			arrow_color = COLOR_YELLOW
		if(41 to 100)
			arrow_color = COLOR_ORANGE
		else
			arrow_color = COLOR_RED

	var/datum/hud/user_hud = user.hud_used
	if(!user_hud || !istype(user_hud, /datum/hud) || !islist(user_hud.infodisplay))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/atom/movable/screen/multitool_arrow/arrow = new(null, user_hud)
	arrow.color = arrow_color
	arrow.screen_loc = "CENTER-1,CENTER-1"
	arrow.transform = matrix(dir2angle(dir), MATRIX_ROTATE)

	user_hud.infodisplay += arrow
	user_hud.show_hud(user_hud.hud_version)

	if(portal_hint)
		to_chat(user, span_info("The scroll points toward the [portal_hint]."))

	QDEL_IN(arrow, 1.5 SECONDS)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/paper/scroll/quest/proc/update_quest_text()
	if(!assigned_quest)
		return

	var/scroll_text = "<center>HELP NEEDED</center><br>"
	scroll_text += "<center><b>[assigned_quest.get_title()]</b></center><br>"
	scroll_text += "<b>Issued by:</b> [assigned_quest.quest_giver_name ? "[assigned_quest.quest_giver_name]" : "The Mercenary's Guild"].<br>"
	scroll_text += "<b>Issued to:</b> [assigned_quest.quest_receiver_name ? assigned_quest.quest_receiver_name : "whoever it may concern"].<br>"
	scroll_text += "<b>Type:</b> [assigned_quest.quest_type] contract.<br>"
	scroll_text += "<b>Difficulty:</b> [assigned_quest.quest_difficulty].<br><br>"

	if(last_compass_direction)
		scroll_text += "<b>Direction:</b> The target is [last_compass_direction]. "
		if(last_z_level_hint)
			scroll_text += " ([last_z_level_hint])"
		scroll_text += "<br>"

	scroll_text += "<b>Objective:</b> [assigned_quest.get_objective_text()]<br>"

	// Show progress if applicable
	if(assigned_quest.progress_required > 1)
		scroll_text += "<b>Progress:</b> [assigned_quest.progress_current]/[assigned_quest.progress_required]<br>"

	scroll_text += "<b>Location:</b> [assigned_quest.get_location_text()]<br>"
	scroll_text += "<br><b>Reward:</b> [assigned_quest.reward_amount] mammon upon completion<br>"

	if(assigned_quest.complete)
		scroll_text += "<br><center><b>CONTRACT COMPLETE</b></center>"
		scroll_text += "<br><b>Return this scroll to the Notice Board to claim your reward!</b>"
		scroll_text += "<br><i>Place it on the marked area next to the book.</i>"
		if(assigned_quest.quest_giver_reference)
			scroll_text += "<br><br><i>Return this to [assigned_quest.quest_giver_name] for increased pay!</i>"
		else
			scroll_text += "<br><br><i>Consider getting in touch with a Merchant or a Steward for your next quest for increased pay!</i>"
	else
		scroll_text += "<br><i>The magic in this scroll will update as you progress.</i>"
		if(assigned_quest.quest_giver_reference)
			scroll_text += "<br><br><i>Returning this to [assigned_quest.quest_giver_name] upon completion will yield increased pay!</i>"
		else
			scroll_text += "<br><br><i>Consider getting in touch with a Merchant or a Steward for your next quest for increased pay!</i>"

	info = scroll_text
	update_icon()

/obj/item/paper/scroll/quest/proc/refresh_compass(mob/user)
	if(!assigned_quest || assigned_quest.complete)
		return FALSE

	// Update compass with precise directions
	update_compass(user)

	// Only update text if we have a valid direction
	if(last_compass_direction)
		update_quest_text()
		return TRUE

	return FALSE

/obj/item/paper/scroll/quest/proc/update_compass(mob/user)
	if(!assigned_quest || assigned_quest.complete)
		return

	var/turf/user_turf = user ? get_turf(user) : get_turf(src)
	if(!user_turf)
		last_compass_direction = "No signal detected"
		last_z_level_hint = ""
		return

	// Reset compass values
	last_compass_direction = "Searching for target..."
	last_z_level_hint = ""

	var/turf/target_turf = assigned_quest.get_target_location()
	if(!target_turf)
		last_compass_direction = "location unknown"
		last_z_level_hint = ""
		return

	var/turf/compass_target = target_turf // may be overridden to a portal

	if(target_turf.z != user_turf.z)
		if(!is_in_zweb(target_turf.z, user_turf.z))
			var/area/target_area = get_area(target_turf)
			var/obj/structure/fluff/traveltile/portal = find_portal_to_area(target_area, user_turf)
			if(portal)
				compass_target = get_turf(portal)
				last_z_level_hint = "traverse to [target_area.name]"
			else
				last_z_level_hint = "in [target_area.name]"
		else
			var/z_diff = abs(target_turf.z - user_turf.z)
			last_z_level_hint = target_turf.z > user_turf.z ? \
				"[z_diff] level\s above you" : \
				"[z_diff] level\s below you"

	// Use compass_target (portal or actual target) for all direction math below
	var/dx = compass_target.x - user_turf.x
	var/dy = compass_target.y - user_turf.y
	var/distance = sqrt(dx*dx + dy*dy)

	// If very close, don't show direction
	if(distance <= 7)
		last_compass_direction = "is nearby"
		last_z_level_hint = ""
		return

	// Get precise direction text
	var/direction_text = get_precise_direction_between(user_turf, compass_target)
	if(!direction_text)
		direction_text = "unknown direction"

	// Determine distance description
	var/distance_text
	switch(distance)
		if(0 to 14)
			distance_text = "very close"
		if(15 to 40)
			distance_text = "close"
		if(41 to 100)
			distance_text = ""
		if(101 to INFINITY)
			distance_text = "far away"

	last_compass_direction = "[distance_text] to the [direction_text]"
	if(!last_z_level_hint)
		last_z_level_hint = "on this level"

#undef WHISPER_COOLDOWN

/obj/item/paper/scroll/quest/proc/find_portal_to_area(area/target_area, turf/from_turf)
	var/obj/structure/fluff/traveltile/best
	var/best_dist = INFINITY

	for(var/obj/structure/fluff/traveltile/tile in GLOB.traveltiles)
		var/turf/get_turf = get_turf(tile)
		if(!is_in_zweb(get_turf.z, from_turf.z))
			continue
		if(tile.cached_destination_area == target_area)
			var/d = get_dist(from_turf, get_turf(tile))
			if(d < best_dist)
				best_dist = d
				best = tile

	return best
