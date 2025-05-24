GLOBAL_LIST_EMPTY(outlawed_players)
GLOBAL_LIST_EMPTY(lord_decrees)
GLOBAL_LIST_INIT(laws_of_the_land, initialize_laws_of_the_land())
GLOBAL_LIST_EMPTY(roundstart_court_agents)

#define MODE_NONE "none"
#define MODE_MAKE_ANNOUNCEMENT "make_announcement"
#define MODE_MAKE_LAW "make_law"
#define MODE_MAKE_DECREE "make_decree"
#define MODE_DECLARE_OUTLAW "declare_outlaw"

/proc/initialize_laws_of_the_land()
	var/list/laws = strings("laws_of_the_land.json", "lawsets")
	var/list/lawsets_weighted = list()
	for(var/lawset_name as anything in laws)
		var/list/lawset = laws[lawset_name]
		lawsets_weighted[lawset_name] = lawset["weight"]
	var/chosen_lawset = pickweight(lawsets_weighted)
	return laws[chosen_lawset]["laws"]

/obj/structure/fake_machine/titan
	name = "THROAT"
	desc = "He who wears the crown holds the key to this strange thing. If all else fails, yell \"Help!\""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = ""
	density = FALSE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.5
	max_integrity = 0
	anchored = TRUE
	var/mode = MODE_NONE
	var/static/list/command_list = list(
		"Help",
		"Summon Crown",
		"Summon Key",
		"Make Announcement",
		"Make Decree",
		"Make Law",
		"Remove Law",
		"Purge Laws",
		"Declare Outlaw",
		"Set Taxes",
		"Change Position",
		"Appoint regent",
		"Cancel",
	)

/// Destroys the current crown with a cool message and returns a new crown.
/obj/structure/fake_machine/titan/proc/recreate_crown()
	if(SSroguemachine.crown)
		var/obj/item/clothing/head/crown/serpcrown/old_crown = SSroguemachine.crown
		old_crown.anti_stall()

	say("The crown is summoned!")
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	src.visible_message(span_warning("Ashes circle around the THROAT and the crown rematerialises!"))
	return new /obj/item/clothing/head/crown/serpcrown(src.loc)

/// Destroys the current master key with a cool message and returns a new key.
/obj/structure/fake_machine/titan/proc/recreate_key()
	if(SSroguemachine.key)
		var/obj/item/key/lord/old_master_key = SSroguemachine.key
		old_master_key.anti_stall()

	say("The key is summoned!")
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	src.visible_message(span_warning("The key flies around the THROAT and gently falls down!"))

	return new /obj/item/key/lord

/// Returns all commands of the THROAT in a single string.
/obj/structure/fake_machine/titan/proc/get_commands()
	. += jointext(command_list, ", ")

/obj/structure/fake_machine/titan/proc/is_valid_mob(mob/living/carbon/human/checked_mob)
	if(!istype(checked_mob))
		say("Get off me vile creature!")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return FALSE
	return TRUE

/// Checks if the mob sitting on the throne is worthy, has to be monarch or regent
/obj/structure/fake_machine/titan/proc/is_worthy(mob/living/carbon/human/checked_mob)
	if(!(SSticker.rulermob == checked_mob || SSticker.regent_mob == checked_mob))
		say("You are not worthy!")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return FALSE
	return TRUE

/// Check if the mob has the crown
/obj/structure/fake_machine/titan/proc/has_crown(mob/living/carbon/human/checked_mob)
	if(!checked_mob.head || !istype(checked_mob.head, /obj/item/clothing/head/crown/serpcrown))
		say("You need the crown!")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return FALSE
	return TRUE

/// Check if we are ready to perform a command
/obj/structure/fake_machine/titan/proc/check_cooldown(mob/living/carbon/human/user)
	if(!SScommunications.can_announce(user))
		say("I must gather my strength!")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return FALSE
	return TRUE

/// perform checks on the mob if they can do the command, use has_to_be_worthy FALSE when the mob doesn't have to be regent or ruler
/obj/structure/fake_machine/titan/proc/perform_check(mob/checked_mob, has_to_be_worthy = TRUE)
	if(!is_valid_mob(checked_mob))
		return FALSE
	if(!has_crown(checked_mob))
		return FALSE
	if(!is_worthy(checked_mob) && has_to_be_worthy)
		return FALSE
	if(!check_cooldown(checked_mob))
		return FALSE
	return TRUE

/obj/structure/fake_machine/titan/proc/recognize_command(mob/living/carbon/human/user, message)
	// message is already sanitized
	if(findtext(message, "make announcement") && perform_check(user, FALSE))
		say("All will hear your word.")
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		mode = MODE_MAKE_ANNOUNCEMENT
	if(findtext(message, "make decree") && perform_check(user))
		say("Speak and they will obey.")
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		mode = MODE_MAKE_DECREE
	if(findtext(message, "make law") && perform_check(user))
		say("Speak and they will obey.")
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		mode = MODE_MAKE_LAW
	if(findtext(message, "declare outlaw") && perform_check(user))
		say("Who should be outlawed?")
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		mode = MODE_DECLARE_OUTLAW
	if(findtext(message, "help") && is_valid_mob(user))
		help()
	if(findtext(message, "summon crown") && is_valid_mob(user))
		summon_crown(user)
	if(findtext(message, "summon key") && perform_check(user, FALSE))
		summon_key(user)
	if(findtext(message, "remove law") && perform_check(user))
		remove_law(message)
	if(findtext(message, "purge laws") && perform_check(user))
		purge_laws()
	if(findtext(message, "set taxes") && perform_check(user))
		set_taxes(user)
	if(findtext(message, "change position") && perform_check(user))
		change_position(user)
	if(findtext(message, "appoint regent") && perform_check(user))
		appoint_regent(user)

/obj/structure/fake_machine/titan/Initialize()
	. = ..()
	become_hearing_sensitive()

/obj/structure/fake_machine/titan/obj_break(damage_flag, silent)
	..()
	cut_overlays()
//	icon_state = "[icon_state]-br"
	set_light(0)
	return

/obj/structure/fake_machine/titan/Destroy()
	set_light(0)
	..()

/obj/structure/fake_machine/titan/Initialize()
	. = ..()
	icon_state = null
//	var/mutable_appearance/eye_lights = mutable_appearance(icon, "titan-eyes")
//	eye_lights.plane = ABOVE_LIGHTING_PLANE //glowy eyes
//	eye_lights.layer = ABOVE_LIGHTING_LAYER
//	add_overlay(eye_lights)
	set_light(5)

// COMMANDS BELOW

/// States all commands
/obj/structure/fake_machine/titan/proc/help()
	var/commands = get_commands()
	say("My commands are: [commands]")
	playsound(src, 'sound/misc/machinelong.ogg', 100, FALSE, -1)

/// Tries summoning the crown to the user's hand
/obj/structure/fake_machine/titan/proc/summon_crown(mob/living/carbon/human/user)
	var/obj/item/clothing/head/crown/serpcrown/crown = SSroguemachine.crown

	if(!crown || !ismob(crown.loc)) //You MUST MUST MUST keep the Crown on a person to prevent it from being summoned (magical interference)
		var/new_crown = recreate_crown()
		user.put_in_hands(new_crown)
		return

	if(ishuman(crown.loc))
		var/mob/living/carbon/human/crown_holder = crown.loc
		if(crown_holder.stat != DEAD)
			if(crown in crown_holder.held_items)
				say("[crown_holder.real_name] holds the crown!")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				return
			if(crown_holder.head == crown)
				say("[crown_holder.real_name] wears the crown!")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				return
		else
			crown_holder.dropItemToGround(crown, TRUE) //If you're dead, forcedrop it, then kill it for the kool message..

	var/new_crown = recreate_crown()
	user.put_in_hands(new_crown)

/// Tries summoning the master key to the user's hand
/obj/structure/fake_machine/titan/proc/summon_key(mob/living/carbon/human/user)
	var/obj/item/key/lord/master_key = SSroguemachine.key

	if(!master_key || !ismob(master_key.loc))
		var/new_key = recreate_key()
		user.put_in_hands(new_key)
		return

	if(ishuman(master_key.loc))
		var/mob/living/carbon/human/key_holder = master_key.loc
		if(key_holder.stat != DEAD)
			say("[key_holder.real_name] holds the key!")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return
		else
			key_holder.dropItemToGround(master_key, TRUE) //If you're dead, forcedrop it, then move it.
		var/new_key = recreate_key()
		user.put_in_hands(new_key)

/// Makes an announcement
/obj/structure/fake_machine/titan/proc/make_announcement(mob/living/carbon/human/user, message)
	if(!perform_check(user, FALSE))
		reset_mode()
		return FALSE
	priority_announce(html_decode(user.treat_message(message)), "[user.real_name], The [user.get_role_title()] Speaks", 'sound/misc/alert.ogg', "Captain")
	reset_mode()
	return TRUE

/// Makes a decree
/obj/structure/fake_machine/titan/proc/make_decree(mob/living/carbon/human/user, message)
	var/datum/antagonist/prebel/rebel_datum = user.mind?.has_antag_datum(/datum/antagonist/prebel)
	if(rebel_datum)
		if(rebel_datum.rev_team?.members.len < 3)
			to_chat(user, "<span class='warning'>I need more folk on my side to declare victory.</span>")
		else
			for(var/datum/objective/prebel/obj in user.mind.get_all_objectives())
				obj.completed = TRUE
			if(!SSmapping.retainer.head_rebel_decree)
				user.mind.adjust_triumphs(1)
			SSmapping.retainer.head_rebel_decree = TRUE
	GLOB.lord_decrees += message
	GLOB.vanderlin_round_stats[STATS_LAWS_AND_DECREES_MADE]++
	SScommunications.make_announcement(user, TRUE, message)
	reset_mode()

/obj/structure/fake_machine/titan/proc/make_law(mob/living/carbon/human/user, message)
	if(!SScommunications.can_announce(user))
		return
	GLOB.laws_of_the_land += message
	GLOB.vanderlin_round_stats[STATS_LAWS_AND_DECREES_MADE]++
	priority_announce("[length(GLOB.laws_of_the_land)]. [message]", "A LAW IS DECLARED", 'sound/misc/lawdeclaration.ogg', "Captain")
	reset_mode()

/// Removes a law
/obj/structure/fake_machine/titan/proc/remove_law(message)
	var/clean_message = replacetext(message, "remove law", "")
	var/law_index = text2num(clean_message) || 0
	if(!law_index || !GLOB.laws_of_the_land[law_index])
		say("That law doesn't exist!")
		reset_mode()
		return FALSE
	say("That law shall be gone!")
	playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
	var/law_text = GLOB.laws_of_the_land[law_index]
	GLOB.laws_of_the_land -= law_text
	priority_announce("[law_index]. [law_text]", "A LAW IS ABOLISHED", 'sound/misc/lawdeclaration.ogg', "Captain")
	reset_mode()
	return TRUE

/// Removes all laws
/obj/structure/fake_machine/titan/proc/purge_laws()
	say("All laws shall be purged!")
	playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
	GLOB.laws_of_the_land = list()
	priority_announce("All laws of the land have been purged!", "LAWS PURGED", 'sound/misc/lawspurged.ogg', "Captain")

/// Declares someone an outlaw
/obj/structure/fake_machine/titan/proc/declare_outlaw(mob/living/carbon/human/user, message)
	if(message in GLOB.outlawed_players)
		GLOB.outlawed_players -= message
		priority_announce("[message] is no longer an outlaw in Vanderlin lands.", "[user.real_name], The [user.get_role_title()] Decrees", 'sound/misc/alert.ogg', "Captain")
		reset_mode()
		return
	var/found = FALSE
	for(var/mob/living/carbon/human/to_be_outlawed in GLOB.player_list)
		if(to_be_outlawed.real_name == message)
			found = TRUE
	if(!found)
		say("That person doesn't exist!")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		reset_mode()
		return FALSE
	GLOB.outlawed_players += message
	priority_announce("[message] has been declared an outlaw and must be captured or slain.", "[user.real_name], The [user.get_role_title()] Decrees", 'sound/misc/alert.ogg', "Captain")
	reset_mode()
	return TRUE

/// Sets the taxes of the realm
/obj/structure/fake_machine/titan/proc/set_taxes(mob/living/carbon/human/user)
	if(!Adjacent(user))
		reset_mode()
		return
	var/newtax = input(user, "Set a new tax percentage (1-99)", src, SStreasury.tax_value*100) as null|num
	if(newtax)
		if(!Adjacent(user))
			reset_mode()
			return
		if(findtext(num2text(newtax), "."))
			reset_mode()
			return
		newtax = CLAMP(newtax, 1, 99)
		SStreasury.tax_value = newtax / 100
		priority_announce("The new tax in Vanderlin shall be [newtax] percent.", "[user.real_name], The Generous [user.get_role_title()] Decrees", 'sound/misc/alert.ogg', "Captain")
	reset_mode()

/// Changes the job of a nearby mob
/obj/structure/fake_machine/titan/proc/change_position(mob/living/carbon/human/user)
	if(!Adjacent(user))
		return
	var/list/mob/possible_mobs = orange(2, src)
	if(!possible_mobs)
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		say("No one around!")
		return

	say("Who should change their post?")
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)

	var/mob/victim = input(user, "Who should change their post?", src, null) as null|mob in possible_mobs - user
	if(isnull(victim) || !Adjacent(user))
		return

	say("Select their new position.")
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	var/list/possible_positions = list()
	possible_positions += GLOB.noble_positions
	possible_positions += GLOB.garrison_positions
	possible_positions += GLOB.church_positions
	possible_positions += GLOB.serf_positions
	possible_positions += GLOB.company_positions
	possible_positions += GLOB.peasant_positions
	possible_positions += GLOB.apprentices_positions
	possible_positions += GLOB.allmig_positions
	possible_positions -= "Monarch"
	var/new_pos = input(user, "Select their new position", src, null) as anything in possible_positions
	if(isnull(victim))
		return

	victim.job = new_pos
	victim.migrant_type = null
	if(ishuman(victim))
		var/mob/living/carbon/human/human = victim
		human.advjob = new_pos
	if(!SScommunications.can_announce(user))
		return

	priority_announce("Henceforth, the vassal known as [victim.real_name] shall have the title of [new_pos].", "[user.real_name], The [user.get_role_title()] Decrees", 'sound/misc/alert.ogg', "Captain")

/// Appoints a regent to the throne
/obj/structure/fake_machine/titan/proc/appoint_regent(mob/living/carbon/human/user)
	if(user != SSticker.rulermob)
		say("You are not the true ruler!")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return FALSE
	if(SSticker.regent_mob)
		var/mob/living/carbon/human/regent = SSticker.regent_mob
		priority_announce("[regent.real_name] is no longer regent.", "[user.real_name], The [user.get_role_title()] Decrees", 'sound/misc/alert.ogg', "Captain")
		return TRUE
	var/list/mob/living/carbon/possible_mobs = orange(2, src)
	if(!possible_mobs)
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		say("No one around!")
		return
	var/mob/living/carbon/new_regent = input(user, "Who will rule when you sleep?", src, null) as null|mob in possible_mobs - user
	if(isnull(new_regent) || !Adjacent(user))
		return
	priority_announce("[new_regent.real_name] has been appointed regent.", "[user.real_name], The [user.get_role_title()] Decrees", 'sound/misc/alert.ogg', "Captain")
	SSticker.regent_mob = new_regent

/// Return mode to NONE
/obj/structure/fake_machine/titan/proc/reset_mode()
	mode = MODE_NONE

/obj/structure/fake_machine/titan/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	. = ..()
	if(speaker == src)
		return
	if(speaker.loc != loc)
		return
	if(obj_broken)
		return

	var/sanitized_message = sanitize_hear_message(original_message)

	if(findtext(sanitized_message, "nevermind") || findtext(sanitized_message, "cancel"))
		reset_mode()
		return
	switch(mode)
		if(MODE_NONE)
			recognize_command(speaker, sanitized_message)
		if(MODE_MAKE_ANNOUNCEMENT)
			make_announcement(speaker, raw_message)
		if(MODE_MAKE_LAW)
			make_law(speaker, raw_message)
		if(MODE_DECLARE_OUTLAW)
			declare_outlaw(speaker, raw_message)
		if(MODE_MAKE_DECREE)
			make_decree(speaker, raw_message)

#undef MODE_NONE
#undef MODE_MAKE_ANNOUNCEMENT
#undef MODE_MAKE_LAW
#undef MODE_MAKE_DECREE
#undef MODE_DECLARE_OUTLAW
