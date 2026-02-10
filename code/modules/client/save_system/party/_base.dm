/proc/get_player_rank(ckey)
	var/datum/save_manager/SM = get_save_manager(ckey)
	if(SM)
		return SM.get_data("player_data", "rank", "Copper Adventurer")
	return "Copper Adventurer"

/proc/set_player_rank(ckey, rank)
	var/datum/save_manager/SM = get_save_manager(ckey)
	if(SM)
		return SM.set_data("player_data", "rank", rank)
	return FALSE

GLOBAL_LIST_EMPTY(active_parties)
GLOBAL_LIST_EMPTY(pending_party_invites) // Format: invitee_ckey = list(party, inviter, expire_time)


/proc/send_party_invite(mob/living/carbon/invitee, datum/party/party, mob/living/carbon/inviter)
	if(!invitee || !invitee.ckey || !party || !inviter)
		return FALSE

	var/invitee_ckey = ckey(invitee.ckey)

	// Check if there's already a pending invite
	if(invitee_ckey in GLOB.pending_party_invites)
		to_chat(inviter, "<span class='warning'>[invitee.real_name] already has a pending party invitation!</span>")
		return FALSE

	// Store the pending invite (expires in 30 seconds)
	GLOB.pending_party_invites[invitee_ckey] = list(
		"party" = party,
		"inviter" = inviter,
		"expire_time" = world.time + 300 // 30 seconds
	)

	// Show invitation popup to invitee
	var/response = alert(invitee, "[inviter.real_name] has invited you to join the party '[party.party_name]'. Do you accept?",
						"Party Invitation", "Accept", "Decline")

	// Clean up the pending invite
	GLOB.pending_party_invites -= invitee_ckey

	if(response == "Accept")
		// Double-check everything is still valid
		if(!invitee.current_party && party && (inviter.ckey in party.members) && party.is_leader(inviter.ckey))
			if(join_party(invitee, party))
				to_chat(inviter, "<span class='notice'>[invitee.real_name] has joined your party!</span>")
				to_chat(invitee, "<span class='notice'>You have joined '[party.party_name]'!</span>")
				return TRUE
			else
				to_chat(invitee, "<span class='warning'>Failed to join the party!</span>")
				to_chat(inviter, "<span class='warning'>Failed to add [invitee.real_name] to the party!</span>")
		else
			to_chat(invitee, "<span class='warning'>The party invitation is no longer valid!</span>")
			to_chat(inviter, "<span class='warning'>Unable to add [invitee.real_name] - invitation expired or party changed!</span>")
	else
		to_chat(inviter, "<span class='notice'>[invitee.real_name] declined your party invitation.</span>")
		to_chat(invitee, "<span class='notice'>You declined the party invitation from [inviter.real_name].</span>")

	return FALSE

/proc/create_party(mob/living/carbon/leader, party_name = "New Party")
	if(!leader || !leader.ckey)
		return null

	if(leader.current_party)
		to_chat(leader, "<span class='warning'>You are already in a party!</span>")
		return null

	var/datum/party/new_party = new /datum/party(leader.ckey, party_name)
	GLOB.active_parties[new_party.party_id] = new_party

	new_party.add_member(leader)

	return new_party

/proc/join_party(mob/living/carbon/joiner, datum/party/target_party)
	if(!joiner || !joiner.ckey || !target_party)
		return FALSE

	if(joiner.current_party)
		to_chat(joiner, "<span class='warning'>You are already in a party!</span>")
		return FALSE

	return target_party.add_member(joiner)

/proc/leave_party(mob/living/carbon/leaver)
	if(!leaver || !leaver.ckey || !leaver.current_party)
		return FALSE

	var/datum/party/party = leaver.current_party
	return party.remove_member(leaver.ckey)


/mob/living/carbon/verb/create_party_verb()
	set name = "Create Party"
	set category = "IC.Party"
	set desc = "Create a new party"

	if(!src.ckey)
		return

	if(src.current_party)
		to_chat(src, "<span class='warning'>You are already in a party!</span>")
		return

	var/party_name = browser_input_text(src, "Enter party name", "Create Party", max_length = MAX_CHARTER_LEN)
	if(!party_name)
		return

	var/datum/party/new_party = create_party(src, party_name)
	if(new_party)
		to_chat(src, "<span class='notice'>Party '[party_name]' created successfully!</span>")

/mob/living/carbon/verb/leave_party_verb()
	set name = "Leave Party"
	set category = "IC.Party"
	set desc = "Leave your current party"

	if(!current_party)
		to_chat(src, "<span class='warning'>You are not in a party!</span>")
		return

	if(leave_party(src))
		to_chat(src, "<span class='notice'>You have left the party.</span>")

/mob/living/carbon/verb/invite_to_party()
	set name = "Invite to Party"
	set category = "IC.Party"
	set desc = "Invite someone to your party"

	var/mob/living/carbon/inviter = usr
	var/list/mobs = view(7, inviter)
	var/mob/living/carbon/invitee = browser_input_list(inviter, "Choose a target to invite.", "Party Invite", mobs)
	if(!invitee)
		return
	if(!inviter.current_party)
		to_chat(inviter, "<span class='warning'>You are not in a party!</span>")
		return

	if(!inviter.current_party.is_leader(inviter.ckey))
		to_chat(inviter, "<span class='warning'>Only the party leader can invite members!</span>")
		return

	if(!invitee.ckey)
		to_chat(inviter, "<span class='warning'>This person cannot join parties!</span>")
		return

	if(invitee.current_party)
		to_chat(inviter, "<span class='warning'>[invitee.real_name] is already in a party!</span>")
		return

	send_party_invite(invitee, inviter.current_party, inviter)

/datum/party
	var/party_id
	var/party_name = "New Party"
	var/list/members = list() // List of ckeys
	var/party_leader_ckey
	var/max_members = 6
	var/created_time
	var/last_activity_time

/datum/party/New(leader_ckey, name = "New Party")
	party_id = "[world.realtime]_[rand(1000, 9999)]"
	party_name = name
	party_leader_ckey = ckey(leader_ckey)
	created_time = world.realtime
	last_activity_time = world.realtime

/datum/party/Destroy()
	// Clear all member HUDs
	for(var/member_ckey in members)
		var/mob/living/carbon/member_mob = get_mob_by_ckey(member_ckey)
		if(istype(member_mob))
			member_mob.clear_party_huds()
			member_mob.current_party = null

	// Remove from global list
	GLOB.active_parties -= party_id
	return ..()

/datum/party/proc/add_member(mob/living/carbon/target_mob)
	if(!target_mob || !target_mob.ckey)
		return FALSE

	var/target_ckey = ckey(target_mob.ckey)

	if(length(members) >= max_members)
		return FALSE

	if(target_ckey in members)
		return FALSE // Already in party

	members += target_ckey
	target_mob.current_party = src

	// Update all member HUDs
	update_party_huds()

	// Notify party
	notify_party("[target_mob.real_name] has joined the party!", target_mob)

	return TRUE

/datum/party/proc/remove_member(target_ckey)
	target_ckey = ckey(target_ckey)

	if(!(target_ckey in members))
		return FALSE

	var/mob/living/carbon/leaving_mob = get_mob_by_ckey(target_ckey)
	if(!istype(leaving_mob))
		return
	var/leaving_name = leaving_mob ? (leaving_mob.real_name || leaving_mob.name) : target_ckey

	members -= target_ckey

	if(leaving_mob)
		leaving_mob.clear_party_huds()
		leaving_mob.current_party = null

	// If leader left, promote someone else
	if(target_ckey == party_leader_ckey && length(members) > 0)
		party_leader_ckey = members[1]
		var/mob/new_leader = get_mob_by_ckey(party_leader_ckey)
		if(new_leader)
			notify_party("[new_leader.real_name] is now the party leader!")

	// Update remaining member HUDs
	update_party_huds()

	// Notify remaining members
	notify_party("[leaving_name] has left the party.")

	// Disband if empty
	if(length(members) == 0)
		qdel(src)
		return TRUE

	return TRUE

/datum/party/proc/update_party_huds()
	for(var/member_ckey in members)
		var/mob/living/carbon/member_mob = get_mob_by_ckey(member_ckey)
		if(istype(member_mob) && member_mob.client)
			member_mob.update_party_hud()

/datum/party/proc/notify_party(message, exclude_mob = null)
	last_activity_time = world.realtime
	for(var/member_ckey in members)
		var/mob/member_mob = get_mob_by_ckey(member_ckey)
		if(member_mob && member_mob != exclude_mob)
			to_chat(member_mob, "<span class='notice'>[message]</span>")

/datum/party/proc/get_member_rank(member_ckey)
	return get_player_rank(member_ckey)

/datum/party/proc/is_leader(check_ckey)
	return ckey(check_ckey) == party_leader_ckey


/mob/living/carbon/proc/update_party_hud()
	if(!client || !current_party)
		clear_party_huds()
		return

	clear_party_huds()

	var/hud_index = 0
	for(var/member_ckey in current_party.members)
		if(ckey(member_ckey) == ckey(src.ckey))
			continue // Don't show self

		var/mob/member_mob = get_mob_by_ckey(member_ckey)
		if(!member_mob)
			continue

		var/member_rank = current_party.get_member_rank(member_ckey)

		// Create health HUD
		var/atom/movable/screen/party_member_health/health_hud = new()
		health_hud.screen_loc = "EAST-1:28,CENTER+[2-hud_index]:15"
		health_hud.set_party_member(member_mob, current_party)

		// Create name HUD
		var/atom/movable/screen/party_member_name/name_hud = new()
		name_hud.screen_loc = "EAST-1,CENTER+[2-hud_index]:15"
		name_hud.set_party_member(member_mob, current_party, member_rank)

		// Add to screen
		client.screen += health_hud
		client.screen += name_hud

		// Store for cleanup
		party_hud_elements += health_hud
		party_hud_elements += name_hud

		hud_index++
		if(hud_index >= 5) // Limit display
			break

/mob/living/carbon/proc/clear_party_huds()
	if(!client)
		return

	for(var/atom/movable/screen/element in party_hud_elements)
		client.screen -= element
		qdel(element)

	party_hud_elements = list()


// Not really sure where is best to put this, so it can go in here for now.
/mob/living/carbon/proc/make_acquaintance()
	var/mob/living/carbon/inviter = usr
	var/list/mobs = list()
	for(var/mob/living/carbon/person in view(2, inviter))
		if(!person.mind || mind.do_i_know(person.mind))
			continue
		if(person == inviter)
			continue
		mobs += person

	if(!LAZYLEN(mobs))
		return FALSE

	var/mob/living/carbon/invitee = browser_input_list(inviter, "Choose a target to add.", "Acquaintance", mobs)
	if(!invitee)
		return FALSE

	if(!invitee.ckey || !invitee.mind)
		to_chat(inviter, "<span class='warning'>This person is unable to become your acquaintance!</span>")
		return FALSE

	if(cmode)
		to_chat(inviter, "<span class='warning'>You cannot do this during combat!</span>")
		return FALSE
	if(invitee.cmode)
		to_chat(inviter, "<span class='warning'>This person is too busy at this time. Try again later.</span>")
		return FALSE

	var/invitee_choice = alert(invitee, "[src.real_name] wishes to make become an acquaintance, do you agree?", "Become Acquaintances", "Yes", "No")
	if(!(invitee_choice == "Yes"))
		return FALSE

	// Sanity check
	if(!mind)
		return FALSE

	to_chat(inviter, "<span class='notice'>You are now acquaintances with [invitee.real_name]!</span>")
	to_chat(invitee, "<span class='notice'>You are now acquaintances with [inviter.real_name]!</span>")
	mind.share_identities(invitee.mind)
	return TRUE
