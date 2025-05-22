GLOBAL_LIST_EMPTY(personal_objective_minds)

/*	Note from Carnie:
		The way datum/mind stuff works has been changed a lot.
		Minds now represent IC characters rather than following a client around constantly.

	Guidelines for using minds properly:

	-	Never mind.transfer_to(ghost). The var/current and var/original of a mind must always be of type mob/living!
		ghost.mind is however used as a reference to the ghost's corpse

	-	When creating a new mob for an existing IC character (e.g. cloning a dead guy or borging a brain of a human)
		the existing mind of the old mob should be transfered to the new mob like so:

			mind.transfer_to(new_mob)

	-	You must not assign key= or ckey= after transfer_to() since the transfer_to transfers the client for you.
		By setting key or ckey explicitly after transferring the mind with transfer_to you will cause bugs like DCing
		the player.

	-	IMPORTANT NOTE 2, if you want a player to become a ghost, use mob.ghostize() It does all the hard work for you.

	-	When creating a new mob which will be a new IC character (e.g. putting a shade in a construct or randomly selecting
		a ghost to become a xeno during an event). Simply assign the key or ckey like you've always done.

			new_mob.key = key

		The Login proc will handle making a new mind for that mobtype (including setting up stuff like mind.name). Simple!
		However if you want that mind to have any special properties like being a traitor etc you will have to do that
		yourself.

*/

/**
 * The mind datum.
 *		Minds now represent IC characters rather than following a client around constantly.
 * Guidelines for using minds properly:
 ** Never mind.transfer_to(ghost). The var/current and var/original of a mind must always be of type mob/living!
	ghost.mind is however used as a reference to the ghost's corpse

 ** When creating a new mob for an existing IC character (e.g. cloning a dead guy or borging a brain of a human)
	the existing mind of the old mob should be transfered to the new mob like so:
 *** mind.transfer_to(new_mob)

 ** You must not assign key= or ckey= after transfer_to() since the transfer_to transfers the client for you.
	By setting key or ckey explicitly after transferring the mind with transfer_to you will cause bugs like DCing
	the player.

 ** IMPORTANT NOTE 2, if you want a player to become a ghost, use mob.ghostize() It does all the hard work for you.

 ** When creating a new mob which will be a new IC character (e.g. putting a shade in a construct or randomly selecting
	a ghost to become a xeno during an event). Simply assign the key or ckey like you've always done.
 *** new_mob.key = key

 ** The Login proc will handle making a new mind for that mobtype (including setting up stuff like mind.name). Simple!
	However if you want that mind to have any special properties like being a traitor etc you will have to do that
	yourself.
*/
/datum/mind
	/// ckey of the mind
	var/key
	/// original name of their mob
	var/name
	/// replaced name for observers name if set
	var/ghostname
	/// the current mob this mind is residing in
	var/mob/living/current
	///the ghost we currently have
	var/mob/dead/observer/current_ghost
	/// is this mind datum currently linked to a client?
	var/active = FALSE
	/// the memory of this mind
	var/memory
	/// Job datum indicating the mind's role. This should always exist after initialization, as a reference to a singleton.
	var/datum/job/assigned_role
	/// special role of this mind
	var/special_role
	/// list of roles this mind cannot roll
	var/list/restricted_roles = list()
	/// list of spells this mind has
	var/list/spell_list = list() // Wizard mode & "Give Spell" badmin button.
	/// amount of spell points this mind currently has
	var/spell_points
	/// amount of spell points this mind has used
	var/used_spell_points

	var/linglink
	var/datum/martial_art/martial_art
	var/static/default_martial_art = new/datum/martial_art
	var/miming = 0 // Mime's vow of silence
	/// all antag datumsa applied to this mind
	var/list/antag_datums
	/// the icon_state of the antag_hud
	var/antag_hud_icon_state = null
	/// this mind's antag hud
	var/datum/atom_hud/antag/antag_hud = null
	var/damnation_type = 0
	/// who owns the soul.  Under normal circumstances, this will point to src
	var/datum/mind/soulOwner
	/// If false, renders the character unable to sell their soul.
	var/hasSoul = TRUE
	/// is this person a chaplain or admin role allowed to use bibles
	var/isholy = FALSE
	/// If this mind's master is another mob (i.e. adamantine golems)
	var/mob/living/enslaved_to
	/// language holder datum
	var/datum/language_holder/language_holder
	/// boolean, is this mind unconvertable by conversion antags?
	var/unconvertable = FALSE
	/// did this mind use the late join button?
	var/late_joiner = FALSE
	/// time of the last death of the mob this mind controlled
	var/last_death = 0

	var/force_escaped = FALSE  // Set by Into The Sunset command of the shuttle manipulator

	///List of learned recipe TYPES.
	var/list/learned_recipes
	var/list/special_items = list()

	var/list/areas_entered = list()

	var/list/known_people = list() //contains person, their job, and their voice color

	var/list/notes = list() //RTD add notes button

	var/list/cached_frumentarii = list()

	var/datum/sleep_adv/sleep_adv = null

	/// List of personal objectives not tied to the antag roles
	var/list/personal_objectives = list()

	var/has_studied = FALSE
	/// Variable that lets the event picker see if someones getting chosen or not
	var/picking = FALSE
	///the bitflag our job applied
	var/job_bitflag = NONE


/datum/mind/New(key)
	src.key = key
	soulOwner = src
	martial_art = default_martial_art
	set_assigned_role(SSjob.GetJobType(/datum/job/unassigned))
	sleep_adv = new /datum/sleep_adv(src)

/datum/mind/Destroy()
	SSticker.minds -= src
	QDEL_NULL(sleep_adv)
	if(islist(antag_datums))
		QDEL_LIST(antag_datums)
	return ..()

/proc/get_minds(role)
	. = list()
	for(var/datum/mind/M in SSticker.minds)
		var/is_role = TRUE
		if(role)
			is_role = FALSE
			if(M.special_role == role)
				is_role = TRUE
			else
				if(M.assigned_role.title == role)
					is_role = TRUE
		if(is_role)
			. += M

/// proc that adds us to their lists, and they are added to ours
/datum/mind/proc/i_know_person(person)
	if(!person)
		return
	if(person == src)
		return
	var/datum/mind/M = person
	if(ishuman(M.current))
		var/mob/living/carbon/human/H = M.current
		if(!known_people[H.real_name])
			known_people[H.real_name] = list()
		known_people[H.real_name]["VCOLOR"] = H.voice_color
		var/used_title = H.get_role_title()
		if(!used_title)
			used_title = "Unknown"
		known_people[H.real_name]["FJOB"] = used_title
		known_people[H.real_name]["FGENDER"] = H.gender
		known_people[H.real_name]["FAGE"] = H.age

/// we are added to their lists, they are added to ours
/datum/mind/proc/person_knows_me(person)
	if(!person)
		return
	if(person == src)
		return
	var/datum/mind/M = person
	if(M.known_people)
		if(ishuman(current))
			var/mob/living/carbon/human/H = current
			if(!M.known_people[H.real_name])
				M.known_people[H.real_name] = list()
			M.known_people[H.real_name]["VCOLOR"] = H.voice_color
			var/used_title
			if(H.job)
				var/datum/job/job = SSjob.GetJob(H.job)
				used_title = job.get_informed_title(H)
			if(!used_title)
				used_title = "Unknown"
			M.known_people[H.real_name]["FJOB"] = used_title
			M.known_people[H.real_name]["FGENDER"] = H.gender
			M.known_people[H.real_name]["FAGE"] = H.age

/// check if this mind knows X
/datum/mind/proc/do_i_know(datum/mind/person, name)
	if(!person && !name)
		return
	if(person)
		var/mob/living/carbon/human/H = person.current
		if(!istype(H))
			return
		for(var/P in known_people)
			if(H.real_name == P)
				return TRUE
	if(name)
		for(var/P in known_people)
			if(name == P)
				return TRUE

/// we are removed from X's known people
/datum/mind/proc/become_unknown_to(person)
	if(!person)
		return
	if(person == src)
		return
	var/datum/mind/M = person
	var/mob/living/carbon/human/H = current
	if(M.known_people && istype(H))
		if(M.known_people[H.real_name])
			M.known_people[H.real_name] = null

/// removes all known people from your known_people list
/datum/mind/proc/unknow_all_people()
	known_people = list()

/// show known people to the player
/datum/mind/proc/display_known_people(mob/user)
	if(!user)
		return
	if(!known_people.len)
		return
	var/contents = "<center>People that [name] knows:</center><BR>"
	for(var/P in known_people)
		if(!length(known_people[P]))
			known_people -= P
			continue
		var/fcolor = known_people[P]["VCOLOR"]
		if(!fcolor)
			continue
		var/fjob = known_people[P]["FJOB"]
		var/fgender = known_people[P]["FGENDER"]
		var/fage = known_people[P]["FAGE"]
		if(fcolor && fjob)
			contents += "<B><font color=#[fcolor];text-shadow:0 0 10px #8d5958, 0 0 20px #8d5958, 0 0 30px #8d5958, 0 0 40px #8d5958, 0 0 50px #e60073, 0 0 60px #8d5958, 0 0 70px #8d5958;>[P]</font></B><BR>[fjob], [capitalize(fgender)], [fage]"
			contents += "<BR>"

	var/datum/browser/popup = new(user, "PEOPLEIKNOW", "", 260, 400)
	popup.set_content(contents)
	popup.open()

/// returns the language holder of this mind
/datum/mind/proc/get_language_holder()
	if(!language_holder)
		var/datum/language_holder/L = current.get_language_holder(shadow=FALSE)
		language_holder = L.copy(src)

	return language_holder

/// transfers this mind's control to a new mob
/datum/mind/proc/transfer_to(mob/new_character, force_key_move = 0)
	if(current)	// remove ourself from our old body's mind variable
		current.mind = null
		UnregisterSignal(current, COMSIG_MOB_DEATH)
		SStgui.on_transfer(current, new_character)

	if(!language_holder)
		var/datum/language_holder/mob_holder = new_character.get_language_holder(shadow = FALSE)
		language_holder = mob_holder.copy(src)

	if(key)
		if(new_character.key != key)					//if we're transferring into a body with a key associated which is not ours
			if(new_character.key)
				new_character.ghostize(1)						//we'll need to ghostize so that key isn't mobless.
	else
		key = new_character.key

	if(new_character.mind)								//disassociate any mind currently in our new body's mind variable
		new_character.mind.current = null

	var/datum/atom_hud/antag/hud_to_transfer = antag_hud//we need this because leave_hud() will clear this list
	var/mob/living/old_current = current
	if(current)
		current.transfer_observers_to(new_character)	//transfer anyone observing the old character to the new one
	current = new_character								//associate ourself with our new body
	new_character.mind = src							//and associate our new body with ourself
	for(var/datum/antagonist/antag_datum_ref in antag_datums)	//Makes sure all antag datums effects are applied in the new body
		antag_datum_ref.on_body_transfer(old_current, current)
	if(iscarbon(new_character))
		var/mob/living/carbon/C = new_character
		C.last_mind = src
	transfer_antag_huds(hud_to_transfer)				//inherit the antag HUD
	transfer_actions(new_character)
	transfer_martial_arts(new_character)
	RegisterSignal(new_character, COMSIG_MOB_DEATH, PROC_REF(set_death_time))
	if(active || force_key_move)
		new_character.key = key		//now transfer the key to link the client to our new body
	new_character.update_fov_angles()
	SEND_SIGNAL(old_current, COMSIG_MIND_TRANSFER, new_character)

/**
 * purges all spells known by the mind
 * Vars:
 ** return_skill_points - do we return the skillpoints for the spells?
 ** silent - do we notify the player of this change?
*/
/datum/mind/proc/purge_all_spells(return_skill_points, silent = TRUE)
	for(var/obj/effect/proc_holder/spell_to_purge in spell_list)
		RemoveSpell(spell_to_purge, return_skill_points ? TRUE : FALSE)
	if(!silent)
		to_chat(current, span_boldwarning("I forget all my spells!"))

/datum/mind/proc/purge_all_spellpoints(silent = TRUE)
	spell_points = 0
	used_spell_points = 0
	if(!silent)
		to_chat(current, span_boldwarning("I lose all my spellpoints!"))

/**
 * adjusts the amount of available spellpoints
 * Vars:
 ** points - amount of points to grant or reduce
*/
/datum/mind/proc/adjust_spellpoints(points)
	spell_points += points
	check_learnspell() //check if we need to add or remove the learning spell


/// set the last_death time of a mind to the current world time
/datum/mind/proc/set_death_time()
	last_death = world.time

/**
 * add a new memory to a mind
 * Vars:
 ** new_text - text to add
*/
/datum/mind/proc/store_memory(new_text)
	var/newlength = length(memory) + length(new_text)
	if (newlength > MAX_MESSAGE_LEN * 100)
		memory = copytext(memory, -newlength-MAX_MESSAGE_LEN * 100)
	memory += "[new_text]<BR>"

/// wipes the memory of a mind
/datum/mind/proc/wipe_memory()
	memory = null

/**
 * purges all spells and skills
 * Vars:
 ** silent - do we notify the player of this change?
*/
/datum/mind/proc/purge_combat_knowledge(silent)
	current.purge_all_skills(TRUE)
	purge_all_spells()
	purge_all_spellpoints(TRUE)

// Datum antag mind procs

/**
 * adds an antag datum to a mind
 * Vars:
 ** datum_type_or_instance - antag datum type to add
 ** team - which team this antag datum is linked to
*/
/datum/mind/proc/add_antag_datum(datum_type_or_instance, team)
	if(!datum_type_or_instance)
		CRASH("add_antag_datum was called without an antag datum type!")
	var/datum/antagonist/antag_datum_ref
	if(!ispath(datum_type_or_instance))
		antag_datum_ref = datum_type_or_instance
		if(!istype(antag_datum_ref))
			CRASH("add_antag_datum was passed an invalid antag datum!")
	else
		antag_datum_ref = new datum_type_or_instance()
	//Choose snowflake variation if antagonist handles it
	var/datum/antagonist/antag_datum = antag_datum_ref.specialization(src)
	if(antag_datum && antag_datum != antag_datum_ref)
		qdel(antag_datum_ref)
		antag_datum_ref = antag_datum
	if(!antag_datum_ref.can_be_owned(src))
		qdel(antag_datum_ref)
		return
	antag_datum_ref.owner = src
	LAZYADD(antag_datums, antag_datum_ref)
	antag_datum_ref.create_team(team)
	var/datum/team/antag_team = antag_datum_ref.get_team()
	if(antag_team)
		antag_team.add_member(src)
	INVOKE_ASYNC(antag_datum_ref, TYPE_PROC_REF(/datum/antagonist, on_gain))
	log_game("[key_name(src)] has gained antag datum [antag_datum_ref.name]([antag_datum_ref.type])")
	var/client/picked_client = src.current?.client
	picked_client?.mob?.mind.picking = FALSE
	return antag_datum_ref

/**
 * remove an antag datum from a mind
 * Vars:
 ** datum_type - the type of antag datum to remove
*/
/datum/mind/proc/remove_antag_datum(datum_type)
	if(!datum_type)
		return
	var/datum/antagonist/antag_datum_ref = has_antag_datum(datum_type)
	if(antag_datum_ref)
		antag_datum_ref.on_removal()
		return TRUE

/// removes all antag datums from a mind
/datum/mind/proc/remove_all_antag_datums() //For the Lazy amongst us.
	for(var/a in antag_datums)
		var/datum/antagonist/antag_datum_ref = a
		antag_datum_ref.on_removal()

/**
 * remove an antag datum from a mind
 * Vars:
 ** datum_type - the type of antag datum to remove
 ** check_subtypes - boolean, check if we count subtypes of the antag datum as TRUE
*/
/datum/mind/proc/has_antag_datum(datum_type, check_subtypes = TRUE)
	if(!datum_type)
		CRASH("has_antag_datum was called without an antag datum specified!")
	for(var/a in antag_datums)
		var/datum/antagonist/antag_datum_ref = a
		if(check_subtypes && istype(antag_datum_ref, datum_type))
			return antag_datum_ref
		else
			if(istype(antag_datum_ref))
				if(antag_datum_ref.type == datum_type)
					return antag_datum_ref

/// Boolean. Returns true if all antag datums are actually "good", false otherwise.
/datum/mind/proc/isactuallygood()
	var/is_good_guy = TRUE
	for(var/datum/antagonist/GG in antag_datums)
		is_good_guy &&= GG.isgoodguy
	return is_good_guy

/**
 * Link a new mobs mind to the creator of said mob. They will join any team they are currently on, and will only switch teams when their creator does.
 * Vars:
 ** creator - who to enslave to
*/
/datum/mind/proc/enslave_mind_to_creator(mob/living/creator)
	enslaved_to = creator

	current.faction |= creator.faction
	creator.faction |= current.faction

	if(creator.mind.special_role)
		message_admins("[ADMIN_LOOKUPFLW(current)] has been created by [ADMIN_LOOKUPFLW(creator)], an antagonist.")
		to_chat(current, span_danger("Despite my creators current allegiances, my true master remains [creator.real_name]. If their loyalties change, so do yours. This will never change unless my creator's body is destroyed."))

/// output all memories of a mind
/datum/mind/proc/show_memory(mob/recipient, window=1)
	if(!recipient)
		recipient = current
	var/output = "<B>[current.real_name]'s Memories:</B><br>"
	output += memory

	if(personal_objectives.len)
		output += "<B>Personal Objectives:</B>"
		var/personal_count = 1
		for(var/datum/objective/objective in personal_objectives)
			output += "<br><B>Personal Goal #[personal_count]</B>: [objective.explanation_text][objective.completed ? " (COMPLETED)" : ""]"
			personal_count++
		output += "<br>"

	var/list/all_objectives = list()
	for(var/datum/antagonist/antag_datum_ref in antag_datums)
		output += antag_datum_ref.antag_memory
		all_objectives |= antag_datum_ref.objectives

	if(all_objectives.len)
		output += "<B>Objectives:</B>"
		var/antag_obj_count = 1
		for(var/datum/objective/objective in all_objectives)
			output += "<br><B>[objective.flavor] #[antag_obj_count]</B>: [objective.explanation_text][objective.completed ? " (COMPLETED)" : ""]"
			antag_obj_count++

	if(window)
		recipient << browse(output,"window=memory")
	else if(all_objectives.len || memory || personal_objectives.len)
		to_chat(recipient, "<i>[output]</i>")

/// output current targets to the player
/datum/mind/proc/recall_targets(mob/recipient, window=1)
	var/output = "<B>[recipient.real_name]'s Hitlist:</B><br>"
	for (var/mob/living/carbon in GLOB.mob_living_list) // Iterate through all mobs in the world
		if ((carbon.real_name != recipient.real_name) && ((carbon.has_flaw(/datum/charflaw/hunted) || HAS_TRAIT(carbon, TRAIT_ZIZOID_HUNTED)) && (!istype(carbon, /mob/living/carbon/human/dummy))))//To be on the list they must be hunted, not be the user and not be a dummy (There is a dummy that has all vices for some reason)
			output += "<br>[carbon.real_name]"
			if (carbon.job)
				output += " - [carbon.job]"
	output += "<br>Your creed is blood, your faith is steel. You will not rest until these souls are yours. Use the profane dagger to trap their souls for Graggar."

	if(window)
		recipient << browse(output,"window=memory")

/datum/mind/proc/recall_culling(mob/recipient, window=1)
	var/output = "<B>[recipient.real_name]'s Rival:</B><br>"
	for(var/datum/culling_duel/D in GLOB.graggar_cullings)
		var/mob/living/carbon/human/challenger = D.challenger.resolve()
		var/mob/living/carbon/human/target = D.target.resolve()
		var/obj/item/organ/heart/target_heart = D.target_heart.resolve()
		var/obj/item/organ/heart/challenger_heart = D.challenger_heart.resolve()
		var/target_heart_location
		var/challenger_heart_location

		if(target_heart)
			target_heart_location = target_heart.owner ? target_heart.owner.prepare_deathsight_message() : lowertext(get_area_name(target_heart))

		if(challenger_heart)
			challenger_heart_location = challenger_heart.owner ? challenger_heart.owner.prepare_deathsight_message() : lowertext(get_area_name(challenger_heart))

		if(recipient == challenger)
			if(target)
				if(target_heart && target_heart.owner && target_heart.owner != target) // Rival is not gone but their heart is in someone else
					output += "<br>[target.real_name], the [target.job]"
					output += "<br>Your rival's heart beats in [target_heart.owner.real_name]'s chest in [target_heart_location]"
					output += "<br>Retrieve and consume it to claim victory! Graggar will not forgive failure."
				else
					output += "<br>[target.real_name], the [target.job]"
					output += "<br>Eat your rival's heart before they eat YOURS! Graggar will not forgive failure."
			else if(target_heart)
				if(target_heart.owner && target_heart.owner != recipient)
					output += "<br>Rival's Heart"
					output += "<br>It's currently inside [target_heart.owner.real_name]'s chest in [target_heart_location]"
					output += "<br>Your rival's heart beats in another's chest. Retrieve and consume it to claim victory!"
				else
					output += "<br>Rival's Heart"
					output += "<br>It's somewhere in the [target_heart_location]"
					output += "<br>Your rival's heart is exposed bare! Consume it to claim victory!"
			else
				continue

		else if(recipient == target)
			if(challenger)
				if(challenger_heart && challenger_heart.owner && challenger_heart.owner != challenger) // Rival is not gone but their heart is in someone else
					output += "<br>[challenger.real_name], the [challenger.job]"
					output += "<br>Your rival's heart beats in [challenger_heart.owner.real_name]'s chest in [challenger_heart_location]"
					output += "<br>Retrieve and consume it to claim victory! Graggar will not forgive failure."
				else
					output += "<br>[challenger.real_name], the [challenger.job]"
					output += "<br>Eat your rival's heart before he eat YOURS! Graggar will not forgive failure."
			else if(challenger_heart)
				if(challenger_heart.owner && challenger_heart.owner != recipient)
					output += "<br>Rival's Heart"
					output += "<br>It's currently inside [challenger_heart.owner.real_name]'s chest in [challenger_heart_location]"
					output += "<br>Your rival's heart beats in another's chest. Retrieve and consume it to claim victory!"
				else
					output += "<br>Rival's Heart"
					output += "<br>It's somewhere in the [challenger_heart_location]"
					output += "<br>Your rival's heart is exposed bare! Consume it to claim victory!"
			else
				continue

	if(window)
		recipient << browse(output,"window=memory")

/datum/mind/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return

	var/self_antagging = usr == current

	if(href_list["add_antag"])
		add_antag_wrapper(text2path(href_list["add_antag"]),usr)
	if(href_list["remove_antag"])
		var/datum/antagonist/antag_datum_ref = locate(href_list["remove_antag"]) in antag_datums
		if(!istype(antag_datum_ref))
			to_chat(usr, span_warning("Invalid antagonist ref to be removed."))
			return
		antag_datum_ref.admin_remove(usr)

	else if (href_list["memory_edit"])
		var/new_memo = copytext(sanitize(input("Write new memory", "Memory", memory) as null|message),1,MAX_MESSAGE_LEN)
		if (isnull(new_memo))
			return
		memory = new_memo

	else if (href_list["obj_edit"] || href_list["obj_add"])
		var/objective_pos //Edited objectives need to keep same order in antag objective list
		var/def_value
		var/datum/antagonist/target_antag
		var/datum/objective/old_objective //The old objective we're replacing/editing
		var/datum/objective/new_objective //New objective we're be adding

		if(href_list["obj_edit"])
			for(var/datum/antagonist/antag_datum_ref in antag_datums)
				old_objective = locate(href_list["obj_edit"]) in antag_datum_ref.objectives
				if(old_objective)
					target_antag = antag_datum_ref
					objective_pos = antag_datum_ref.objectives.Find(old_objective)
					break
			if(!old_objective)
				to_chat(usr,"Invalid objective.")
				return
		else
			if(href_list["target_antag"])
				var/datum/antagonist/X = locate(href_list["target_antag"]) in antag_datums
				if(X)
					target_antag = X
			if(!target_antag)
				switch(antag_datums.len)
					if(0)
						target_antag = add_antag_datum(/datum/antagonist/custom)
					if(1)
						target_antag = antag_datums[1]
					else
						var/datum/antagonist/target = input("Which antagonist gets the objective:", "Antagonist", "(new custom antag)") as null|anything in sortList(antag_datums) + "(new custom antag)"
						if (QDELETED(target))
							return
						else if(target == "(new custom antag)")
							target_antag = add_antag_datum(/datum/antagonist/custom)
						else
							target_antag = target

		if(!GLOB.admin_objective_list)
			generate_admin_objective_list()

		if(old_objective)
			if(old_objective.name in GLOB.admin_objective_list)
				def_value = old_objective.name

		var/selected_type = input("Select objective type:", "Objective type", def_value) as null|anything in GLOB.admin_objective_list
		selected_type = GLOB.admin_objective_list[selected_type]
		if (!selected_type)
			return

		if(!old_objective)
			//Add new one
			new_objective = new selected_type
			new_objective.owner = src
			new_objective.admin_edit(usr)
			target_antag.objectives += new_objective
			message_admins("[key_name_admin(usr)] added a new objective for [current]: [new_objective.explanation_text]")
			log_admin("[key_name(usr)] added a new objective for [current]: [new_objective.explanation_text]")
		else
			if(old_objective.type == selected_type)
				//Edit the old
				old_objective.admin_edit(usr)
				new_objective = old_objective
			else
				//Replace the old
				new_objective = new selected_type
				new_objective.owner = src
				new_objective.admin_edit(usr)
				target_antag.objectives -= old_objective
				target_antag.objectives.Insert(objective_pos, new_objective)
			message_admins("[key_name_admin(usr)] edited [current]'s objective to [new_objective.explanation_text]")
			log_admin("[key_name(usr)] edited [current]'s objective to [new_objective.explanation_text]")

	else if (href_list["obj_delete"])
		var/datum/objective/objective
		for(var/datum/antagonist/antag_datum_ref in antag_datums)
			objective = locate(href_list["obj_delete"]) in antag_datum_ref.objectives
			if(istype(objective))
				antag_datum_ref.objectives -= objective
				break
		if(!objective)
			to_chat(usr,"Invalid objective.")
			return
		//qdel(objective) Needs cleaning objective destroys
		message_admins("[key_name_admin(usr)] removed an objective for [current]: [objective.explanation_text]")
		log_admin("[key_name(usr)] removed an objective for [current]: [objective.explanation_text]")

	else if(href_list["obj_completed"])
		var/datum/objective/objective
		for(var/datum/antagonist/antag_datum_ref in antag_datums)
			objective = locate(href_list["obj_completed"]) in antag_datum_ref.objectives
			if(istype(objective))
				objective = objective
				break
		if(!objective)
			to_chat(usr,"Invalid objective.")
			return
		objective.completed = !objective.completed
		log_admin("[key_name(usr)] toggled the win state for [current]'s objective: [objective.explanation_text]")
	else if (href_list["common"])
		switch(href_list["common"])
			if("undress")
				for(var/obj/item/W in current)
					current.dropItemToGround(W, TRUE) //The 1 forces all items to drop, since this is an admin undress.
	else if (href_list["obj_announce"])
		announce_objectives()

	//Something in here might have changed my mob
	if(self_antagging && (!usr || !usr.client) && current.client)
		usr = current
	traitor_panel()

/// Gets only antagonist objectives
/datum/mind/proc/get_antag_objectives()
	var/list/antag_objectives = list()
	for(var/datum/antagonist/antag_datum_ref in antag_datums)
		antag_objectives |= antag_datum_ref.objectives
	return antag_objectives

/// Gets only personal objectives
/datum/mind/proc/get_personal_objectives()
	return personal_objectives?.Copy() || list()

/// Gets all objectives (both types)
/datum/mind/proc/get_all_objectives()
	return get_personal_objectives() + get_antag_objectives()

/// Announces only antagonist objectives
/datum/mind/proc/announce_antagonist_objectives()
	var/obj_count = 1
	for(var/datum/antagonist/antag_datum_ref in antag_datums)
		if(length(antag_datum_ref.objectives))
			to_chat(current, span_notice("Your [antag_datum_ref.name] objectives:"))
			for(var/datum/objective/O in antag_datum_ref.objectives)
				O.update_explanation_text()
				to_chat(current, "<B>[O.flavor] #[obj_count]</B>: [O.explanation_text]")
				obj_count++

/// Announces only personal objectives
/datum/mind/proc/announce_personal_objectives()
	if(length(personal_objectives))
		var/personal_count = 1
		for(var/datum/objective/O in personal_objectives)
			O.update_explanation_text()
			to_chat(current, "<B>Personal Goal #[personal_count]</B>: [O.explanation_text]")
			personal_count++

/// Announce all objectives (both types)
/datum/mind/proc/announce_objectives()
	announce_personal_objectives()
	announce_antagonist_objectives()

/**
 * add a spell to a mind
 * Vars:
 ** spell_type - the type of spell to give
 ** silent - is the player notified of the spell gain?
*/
/datum/mind/proc/AddSpell(obj/effect/proc_holder/spell/spell_type, silent = TRUE)
	if(!spell_type)
		CRASH("AddSpell was called without a specified spell type")
	if(has_spell(spell_type))
		return
	spell_list += spell_type
	if(!silent)
		to_chat(current, "<span class='boldnotice'>I have learned a new spell: [spell_type]</span>")
	spell_type.action.Grant(current)

/**
 * check if we have a learnspell, give them a learnspell spell if they have excess spell points, remove it if we don't have excess spell points
 * Vars:
 ** spell_type - spell type to check
*/
/datum/mind/proc/check_learnspell(obj/effect/proc_holder/spell/spell_type)
	if(!has_spell(/obj/effect/proc_holder/spell/self/learnspell)) //are we missing the learning spell?
		if((spell_points - used_spell_points) > 0) //do we have points?
			AddSpell(new /obj/effect/proc_holder/spell/self/learnspell(null)) //put it in
			return

	if((spell_points - used_spell_points) <= 0) //are we out of points?
		RemoveSpell(spell_type) //bye bye spell
		return
	return

/**
 * check if we have a spell
 * Vars:
 ** spell_type - spell type to check
 ** specific - boolean, if TRUE we check the specific type, if FALSE we check for subtypes too
*/
/datum/mind/proc/has_spell(spell_type, specific = FALSE)
	if(istype(spell_type, /obj/effect/proc_holder))
		var/obj/instanced_spell = spell_type
		spell_type = instanced_spell.type
	for(var/obj/effect/proc_holder/spell as anything in spell_list)
		if((specific && spell.type == spell_type) || istype(spell, spell_type))
			return TRUE
	return FALSE

/**
 * Remove a specific spell from a mind
 * Vars:
 ** spell_type - spell type to check
*/
/datum/mind/proc/RemoveSpell(obj/effect/proc_holder/spell/spell, restore_spell_points = FALSE)
	if(!spell)
		return
	for(var/X in spell_list)
		var/obj/effect/proc_holder/spell/spell_type = X
		if(istype(spell_type, spell))
			spell_list -= spell_type
			qdel(spell_type)
			if(restore_spell_points)
				spell_points = max(spell_points + spell_type.cost, 0)
				used_spell_points = max(used_spell_points - spell_type.cost, 0)

/datum/mind/proc/transfer_martial_arts(mob/living/new_character)
	if(!ishuman(new_character))
		return
	if(martial_art)
		if(martial_art.base) //Is the martial art temporary?
			martial_art.remove(new_character)
		else
			martial_art.teach(new_character)

/datum/mind/proc/transfer_actions(mob/living/new_character)
	if(current && current.actions)
		for(var/datum/action/antag_datum_ref in current.actions)
			antag_datum_ref.Grant(new_character)
	transfer_mindbound_actions(new_character)

/datum/mind/proc/transfer_mindbound_actions(mob/living/new_character)
	for(var/X in spell_list)
		var/obj/effect/proc_holder/spell/spell_type = X
		spell_type.action.Grant(new_character)

/**
 * delay usage of all spells except the ones passed into the exceptions list
 * Vars:
 ** delay - how long is the disrupt duration
 ** exceptions - a list of spells to ignore when disrupting
*/
/datum/mind/proc/disrupt_spells(delay, list/exceptions = list())
	for(var/X in spell_list)
		var/obj/effect/proc_holder/spell/spell_type = X
		for(var/type in exceptions)
			if(istype(spell_type, type))
				continue
		spell_type.charge_counter = delay
		spell_type.updateButtonIcon()
		INVOKE_ASYNC(spell_type, TYPE_PROC_REF(/obj/effect/proc_holder/spell, start_recharge))

/datum/mind/proc/get_ghost(even_if_they_cant_reenter, ghosts_with_clients)
	for(var/mob/dead/observer/G in (ghosts_with_clients ? GLOB.player_list : GLOB.dead_mob_list))
		if(G.mind == src)
			if(G.can_reenter_corpse || even_if_they_cant_reenter)
				return G
			break

/datum/mind/proc/grab_ghost(force)
	var/mob/dead/observer/G = get_ghost(even_if_they_cant_reenter = force)
	. = G
	if(G)
		G.reenter_corpse(force)


/datum/mind/proc/has_objective(objective_type)
	for(var/datum/antagonist/antag_datum_ref in antag_datums)
		for(var/O in antag_datum_ref.objectives)
			if(istype(O,objective_type))
				return TRUE

/// Setter for the assigned_role job datum.
/datum/mind/proc/set_assigned_role(datum/job/new_role)
	if(!istype(new_role))
		new_role = ispath(new_role) ? SSjob.GetJobType(new_role) : SSjob.GetJob(new_role)
	if(assigned_role == new_role)
		return assigned_role
	. = assigned_role
	assigned_role = new_role

/mob/proc/sync_mind()
	mind_initialize()	//updates the mind (or creates and initializes one if one doesn't exist)
	mind.active = TRUE	//indicates that the mind is currently synced with a client

/mob/dead/new_player/sync_mind()
	return

/mob/dead/observer/sync_mind()
	return

//Initialisation procs
/mob/proc/mind_initialize()
	if(mind)
		mind.key = key

	else
		mind = new /datum/mind(key)
		SSticker.minds += mind
	if(!mind.name)
		mind.name = real_name
	mind.current = src

/mob/living/carbon/mind_initialize()
	..()
	last_mind = mind

/**
 * Gives experience to a skill during sleep
 * Vars:
 ** skill - associated skill
 ** amt - amount of experience to give
 ** silent - is the player notified of their skill change?
 ** check_apprentice - do apprentices recieve skill experience too?
*/
/datum/mind/proc/add_sleep_experience(skill, amt, silent = FALSE, check_apprentice = TRUE)
	if(check_apprentice)
		current.adjust_apprentice_exp(skill, amt, silent)
	if(sleep_adv.add_sleep_experience(skill, amt, silent))
		return TRUE

/datum/mind/proc/add_personal_objective(datum/objective/O)
	if(!istype(O))
		return FALSE
	personal_objectives += O
	O.owner = src
	return TRUE

/datum/mind/proc/remove_personal_objective(datum/objective/O)
	personal_objectives -= O
	qdel(O)

/datum/mind/proc/clear_personal_objectives()
	for(var/O in personal_objectives)
		qdel(O)
	personal_objectives.Cut()
