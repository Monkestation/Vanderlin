/datum/role_bans
	var/list/bans = list()

/datum/role_bans/proc/save_to_json_list()
	var/list/json = list()
	json["bans"] = list()
	var/list/ban_list = json["bans"]
	for(var/datum/role_ban_instance/instance as anything in bans)
		ban_list.len++
		ban_list[ban_list.len] = instance.save_to_json_list()
	return json

/datum/role_bans/proc/load_from_json_list(list/json)
	for(var/list/list as anything in json["bans"])
		var/datum/role_ban_instance/instance = new /datum/role_ban_instance()
		instance.load_from_json_list(list)
		bans += instance

/proc/get_role_bans_for_ckey(passed_ckey)
	if(IsAdminAdvancedProcCall())
		return
	passed_ckey = ckey(passed_ckey)
	if(!GLOB.ckey_role_bans[passed_ckey])
		load_role_bans_for_ckey(passed_ckey)
	return GLOB.ckey_role_bans[passed_ckey]

/proc/load_role_bans_for_ckey(passed_ckey)
	if(IsAdminAdvancedProcCall())
		return
	if(GLOB.ckey_role_bans[passed_ckey])
		return
	var/target_file = file("data/player_saves/[passed_ckey[1]]/[passed_ckey]/role_bans.json")
	var/datum/role_bans/bans = new /datum/role_bans()
	if(fexists(target_file))
		bans.load_from_json_list(json_decode(file2text(target_file)))
	GLOB.ckey_role_bans[passed_ckey] = bans

/proc/save_role_bans_for_ckey(passed_ckey)
	if(IsAdminAdvancedProcCall())
		return
	if(!GLOB.ckey_role_bans[passed_ckey])
		load_role_bans_for_ckey(passed_ckey)
	var/target_file = file("data/player_saves/[passed_ckey[1]]/[passed_ckey]/role_bans.json")
	if(fexists(target_file))
		fdel(target_file)
	var/datum/role_bans/bans = GLOB.ckey_role_bans[passed_ckey]
	WRITE_FILE(target_file, json_encode(bans.save_to_json_list()))

/proc/add_role_ban_for_ckey(passed_ckey, datum/role_ban_instance/instance)
	if(IsAdminAdvancedProcCall())
		return
	if(!GLOB.ckey_role_bans[passed_ckey])
		load_role_bans_for_ckey(passed_ckey)
	var/datum/role_bans/bans = GLOB.ckey_role_bans[passed_ckey]
	if(!bans)
		message_admins("Failed to add ROLE BAN to [passed_ckey] (unable to load datum)")
	bans.bans += instance
	save_role_bans_for_ckey(passed_ckey)

/proc/remove_role_ban_for_ckey(passed_ckey, datum/role_ban_instance/instance)
	if(IsAdminAdvancedProcCall())
		return
	if(!GLOB.ckey_role_bans[passed_ckey])
		load_role_bans_for_ckey(passed_ckey)
	var/datum/role_bans/bans = GLOB.ckey_role_bans[passed_ckey]
	if(!bans)
		message_admins("Failed to remove ROLE BAN to [passed_ckey] (unable to load datum)")
	bans.bans -= instance
	save_role_bans_for_ckey(passed_ckey)

/proc/get_valid_role_bans(ckey)
	var/passed_ckey = ckey(ckey)
	var/datum/role_bans/ban_datum = get_role_bans_for_ckey(passed_ckey)
	var/list/valid_list = list()
	for(var/datum/role_ban_instance/instance as anything in ban_datum.bans)
		if(!instance.permanent && world.realtime >= instance.apply_date + instance.duration)
			continue
		valid_list += instance
	return valid_list

/proc/is_role_banned(ckey, job_title)
	var/list/valid_bans = get_valid_role_bans(ckey)
	for(var/datum/role_ban_instance/instance as anything in valid_bans)
		if(job_title in instance.roles)
			return TRUE
	return FALSE

/proc/is_migrant_banned(ckey, migrant_name)
	var/list/valid_bans = get_valid_role_bans(ckey)
	for(var/datum/role_ban_instance/instance as anything in valid_bans)
		if(migrant_name in instance.migrants)
			return TRUE
	return FALSE

/proc/is_advclass_banned(ckey, advclass_name)
	var/list/valid_bans = get_valid_role_bans(ckey)
	for(var/datum/role_ban_instance/instance as anything in valid_bans)
		if(advclass_name in instance.advclasses)
			return TRUE
	return FALSE

/proc/is_antag_banned(ckey, antag_name)
	var/list/valid_bans = get_valid_role_bans(ckey)
	for(var/datum/role_ban_instance/instance as anything in valid_bans)
		if(antag_name in instance.antags)
			return TRUE
	return FALSE

/proc/is_misc_banned(ckey, misc_name)
	var/list/valid_bans = get_valid_role_bans(ckey)
	for(var/datum/role_ban_instance/instance as anything in valid_bans)
		if(misc_name in instance.misc)
			return TRUE
	return FALSE

/proc/is_race_banned(ckey, race_id)
	var/list/valid_bans = get_valid_role_bans(ckey)
	for(var/datum/role_ban_instance/instance as anything in valid_bans)
		if(race_id in instance.races)
			return TRUE
	return FALSE

/proc/get_trait_bans(ckey)
	var/list/trait_bans = list()
	var/list/valid_bans = get_valid_role_bans(ckey)
	for(var/datum/role_ban_instance/instance as anything in valid_bans)
		for(var/trait in instance.traits)
			trait_bans |= trait
	return trait_bans

/proc/apply_trait_bans(mob/living/carbon/human/character, ckey)
	for(var/trait in get_trait_bans(ckey))
		ADD_TRAIT(character, trait, TRAIT_BAN_PUNISHMENT)

/proc/is_total_antag_banned(ckey)
	if(is_misc_banned(ckey, BAN_MISC_LEPROSY))
		return TRUE
	if(is_misc_banned(ckey, BAN_MISC_LUNATIC))
		return TRUE
	if(is_misc_banned(ckey, BAN_MISC_PUNISHMENT_CURSE))
		return TRUE
	return FALSE
