/datum/quest/custom/assassinate
	issue_label = "Player Assassination"
	custom_quest_flags = CUSTOM_QUEST_NOTICEBOARD | CUSTOM_QUEST_PLEDGE
	quest_type = QUEST_CUSTOM
	/// real_name of the player to eliminate.
	var/target_player_name = ""

/datum/quest/custom/assassinate/build_from_user(mob/user)
	var/list/player_names = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.real_name)
			player_names += H.real_name
	player_names = sortList(player_names)
	if(!length(player_names))
		return FALSE // caller displays "no valid targets"

	var/target_name = tgui_input_list(user, "Select the assassination target:", "Target", player_names)
	if(!target_name)
		return FALSE
	if(!fill_common_fields(user))
		return FALSE

	target_player_name = target_name
	quest_giver_reference = WEAKREF(user)
	quest_giver_name = user.real_name

	var/auto_title = get_title()
	var/custom_title = tgui_input_text(user, "Give this quest a title (blank = auto):", "Quest Title", "", 80)
	title = custom_title ? custom_title : auto_title
	return TRUE

/datum/quest/custom/assassinate/build_from_pledge(obj/item/paper/scroll/quest/pledge/PL, mob/steward)
	if(!..()) // writes difficulty, reward, title, giver
		return FALSE
	target_player_name = PL.pledge_assassin_target
	if(!target_player_name)
		return FALSE
	return TRUE

/datum/quest/custom/assassinate/build_pledge(obj/item/paper/scroll/quest/pledge/PL)
	..()
	PL.pledge_assassin_target = target_player_name

/datum/quest/custom/assassinate/get_title()
	if(title)
		return title
	return target_player_name ? "Eliminate [target_player_name]" : "Assassination Contract"

/datum/quest/custom/assassinate/get_objective_text()
	return "Find and eliminate [target_player_name ? target_player_name : "your target"]. " \
		+ "Return your contract scroll to the Notice Board for payment."

/datum/quest/custom/assassinate/get_location_text()
	return "Locate [target_player_name ? target_player_name : "your target"] yourself."

/datum/quest/custom/assassinate/generate(obj/effect/landmark/quest_spawner/landmark)
	add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_QUEST_CREATED, 1)
	if(!title)
		title = get_title()
	progress_required = 1
	register_death_signals()
	return TRUE

/datum/quest/custom/assassinate/proc/register_death_signals()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.real_name == target_player_name)
			RegisterSignal(H, COMSIG_LIVING_DEATH, PROC_REF(on_target_death))
			add_tracked_atom(H)

/datum/quest/custom/assassinate/proc/on_target_death(mob/living/dead_mob, gibbed)
	SIGNAL_HANDLER
	if(complete)
		return
	var/mob/receiver = quest_receiver_reference?.resolve()
	if(!receiver)
		return
	if(dead_mob.lastattacker != receiver)
		return
	progress_current = progress_required
	mark_complete()

/datum/quest/custom/assassinate/Destroy()
	for(var/datum/weakref/ref in tracked_atoms)
		var/mob/living/M = ref.resolve()
		if(M)
			UnregisterSignal(M, COMSIG_LIVING_DEATH)
	return ..()
