/datum/role_ban_instance
	var/apply_date
	var/round_id
	var/duration
	var/permanent
	var/applied_by
	var/reason
	var/list/roles
	var/list/migrants
	var/list/advclasses
	var/list/antags
	var/list/traits
	var/list/misc
	var/list/curses
	var/list/races

/datum/role_ban_instance/proc/get_ban_string_list()
	var/list/strings = list()
	strings += "Applied by [applied_by], on date: [time2text(apply_date, "DD,MM,YYYY")]; Duration: [permanent ? "Permanent" : "[duration / (24 HOURS)] days"]"
	strings += "Round ID: [round_id];Reason: [reason]"
	if(roles)
		var/role_string = "Roles: "
		for(var/role in roles)
			role_string += "[role] "
		strings += role_string
	if(migrants)
		var/migrant_string = "Migrants: "
		for(var/migrant in migrants)
			migrant_string += "[migrant] "
		strings += migrant_string
	if(advclasses)
		var/adv_string = "Adv. Classes: "
		for(var/advclass in advclasses)
			adv_string += "[advclass] "
		strings += adv_string
	if(antags)
		var/antag_string = "Antags: "
		for(var/antag in antags)
			antag_string += "[antag] "
		strings += antag_string
	if(traits)
		var/trait_string = "Traits: "
		for(var/trait in traits)
			trait_string += "[trait] "
		strings += trait_string
	if(misc)
		var/misc_string = "Misc: "
		for(var/misc_ban in misc)
			misc_string += "[misc_ban] "
		strings += misc_string
	if(curses)
		var/curse_string = "Curses: "
		for(var/curse_ban in curses)
			curse_string += "[curse_ban] "
		strings += curse_string
	if(races)
		var/races_string = "Species: "
		for(var/races_ban in races)
			races_string += "[races_ban] "
		strings += races_string

	return strings


/datum/role_ban_instance/proc/save_to_json_list()
	var/list/json = list()
	json["apply_date"] = apply_date
	json["round_id"] = round_id
	json["duration"] = duration
	json["permanent"] = permanent
	json["applied_by"] = applied_by
	json["reason"] = reason
	json["bans"] = list()
	var/list/ban_data = json["bans"]
	if(roles)
		ban_data["roles"] = roles.Copy()
	if(migrants)
		ban_data["migrants"] = migrants.Copy()
	if(advclasses)
		ban_data["advclasses"] = advclasses.Copy()
	if(antags)
		ban_data["antags"] = antags.Copy()
	if(traits)
		ban_data["traits"] = traits.Copy()
	if(misc)
		ban_data["misc"] = misc.Copy()
	if(curses)
		ban_data["curses"] = curses.Copy()
	if(races)
		ban_data["races"] = races.Copy()
	return json

/datum/role_ban_instance/proc/load_from_json_list(list/json)
	apply_date = json["apply_date"]
	round_id = json["round_id"]
	duration = json["duration"]
	permanent = json["permanent"]
	applied_by = json["applied_by"]
	reason = json["reason"]
	var/list/ban_data = json["bans"]
	if(ban_data["roles"])
		var/list/data_roles = ban_data["roles"]
		roles = data_roles.Copy()
	if(ban_data["migrants"])
		var/list/data_roles = ban_data["migrants"]
		migrants = data_roles.Copy()
	if(ban_data["advclasses"])
		var/list/data_roles = ban_data["advclasses"]
		advclasses = data_roles.Copy()
	if(ban_data["antags"])
		var/list/data_roles = ban_data["antags"]
		antags = data_roles.Copy()
	if(ban_data["traits"])
		var/list/data_roles = ban_data["traits"]
		traits = data_roles.Copy()
	if(ban_data["misc"])
		var/list/data_roles = ban_data["misc"]
		misc = data_roles.Copy()
	if(ban_data["curses"])
		var/list/data_roles = ban_data["curses"]
		curses = data_roles.Copy()
	if(ban_data["races"])
		var/list/data_roles = ban_data["races"]
		races = data_roles.Copy()
	return TRUE

/datum/role_ban_panel
	var/datum/admins/holder

	var/selected_ckey = null
	var/selected_duration = 0
	var/selected_reason = null
	var/selected_is_permanent = FALSE

	var/list/selected_roles = list()
	var/list/selected_migrants = list()
	var/list/selected_advclasses = list()
	var/list/selected_antags = list()
	var/list/selected_traits = list()
	var/list/selected_misc = list()
	var/list/selected_curses = list()
	var/list/selected_races = list()

/datum/role_ban_panel/New(datum/admins/passed_holder)
	holder = passed_holder
	return ..()

/datum/role_ban_panel/proc/show_ui(mob/user, forced_key)
	if(forced_key)
		selected_ckey = forced_key
	var/list/dat = list()
	dat += "<center><a href='byond://?src=[REF(src)];task=apply'>APPLY BAN TO CKEY</a> - <a href='byond://?src=[REF(src)];task=reset'>Reset</a> - <a href='byond://?src=[REF(src)];task=check_bans'>Check Role Bans</a> </center>"
	dat += "<BR><b>CKEY:</b> [selected_ckey] <a href='byond://?src=[REF(src)];task=ckey'>Change</a>"
	dat += "<BR><b>Permanent:</b> <a href='byond://?src=[REF(src)];task=permanent'>[selected_is_permanent ? "Yes": "No"]</a>"
	if(!selected_is_permanent)
		dat += "<BR><b>Duration:</b> [selected_duration / (24 HOURS)] days <a href='byond://?src=[REF(src)];task=duration'>Change</a>"
	dat += "<BR><b>Reason:</b> [selected_reason] <a href='byond://?src=[REF(src)];task=reason'>Change</a>"
	dat += "<HR>"
	dat += "<b>Banned Roles:</b> <a href='byond://?src=[REF(src)];task=add_role'>Add</a>"
	for(var/role_name in selected_roles)
		dat += "<BR> - [role_name] <a href='byond://?src=[REF(src)];task=remove_role;role_name=[role_name]'>Remove</a>"

	dat += "<BR><BR><b>Banned Migrants:</b> <a href='byond://?src=[REF(src)];task=add_migrant'>Add</a>"
	for(var/migrant_name in selected_migrants)
		dat += "<BR> - [migrant_name] <a href='byond://?src=[REF(src)];task=remove_migrant;migrant_name=[migrant_name]'>Remove</a>"

	dat += "<BR><BR><b>Banned Adv Classes:</b> <a href='byond://?src=[REF(src)];task=add_advclass'>Add</a>"
	for(var/adv_name in selected_advclasses)
		dat += "<BR> - [adv_name] <a href='byond://?src=[REF(src)];task=remove_advclass;advclass_name=[adv_name]'>Remove</a>"

	dat += "<BR><BR><b>Banned Antags:</b> <a href='byond://?src=[REF(src)];task=add_antag'>Add</a>"
	for(var/antag_name in selected_antags)
		dat += "<BR> - [antag_name] <a href='byond://?src=[REF(src)];task=remove_antag;antag_name=[antag_name]'>Remove</a>"

	dat += "<BR><BR><b>Applied Ban Traits:</b> <a href='byond://?src=[REF(src)];task=add_trait'>Add From Preset</a> <a href='byond://?src=[REF(src)];task=add_trait_any'>Add Any</a>"
	for(var/trait_name in selected_traits)
		dat += "<BR> - [trait_name] <a href='byond://?src=[REF(src)];task=remove_trait;trait_name=[trait_name]'>Remove</a>"

	dat += "<BR><BR><b>Applied Misc Bans:</b> <a href='byond://?src=[REF(src)];task=add_misc'>Add</a>"
	for(var/misc_ban in selected_misc)
		dat += "<BR> - [misc_ban] <a href='byond://?src=[REF(src)];task=remove_misc;misc_ban=[misc_ban]'>Remove</a>"

	dat += "<BR><BR><b>Applied Curses:</b> <a href='byond://?src=[REF(src)];task=add_curse'>Add</a>"
	for(var/curse_ban in selected_curses)
		dat += "<BR> - [curse_ban] <a href='byond://?src=[REF(src)];task=remove_curse;curse_ban=[curse_ban]'>Remove</a>"
	dat += "<BR><BR><b>Applied Species:</b> <a href='byond://?src=[REF(src)];task=add_race'>Add</a>"
	for(var/race_ban in selected_races)
		dat += "<BR> - [race_ban] <a href='byond://?src=[REF(src)];task=remove_race;race_ban=[race_ban]'>Remove</a>"

	var/datum/browser/popup = new(user, "role_ban_panel", "Role Ban Panel", 550, 500)
	popup.set_content(dat.Join())
	popup.open()

/datum/role_ban_panel/Topic(href, list/href_list)
	. = ..()
	if(!holder)
		return
	var/mob/user = usr
	if(holder.owner != user.client)
		return
	if(!check_rights_for(user.client, R_BAN))
		to_chat(user, span_boldwarning("No +BAN permission"))
		return
	switch(href_list["task"])
		if("apply")
			var/alert = alert(user, "Apply the ban?", "BAN", "Yes", "No")
			if(alert != "Yes")
				return
			apply_ban(user)
		if("reset")
			var/alert = alert(user, "Reset the panel and clear all of the values?", "Reset", "Yes", "No")
			if(alert != "Yes")
				return
			reset_panel(user)
		if("check_bans")
			check_bans(user)
			return
		if("ckey")
			var/chosen_ckey = input(user, "Choose ckey", "CKEY", selected_ckey) as text|null
			if(!chosen_ckey)
				return
			chosen_ckey = ckey(chosen_ckey)
			selected_ckey = chosen_ckey
		if("permanent")
			selected_is_permanent = !selected_is_permanent
		if("duration")
			var/duration_type = input(user, "Choose duration type", "Duration", null) as null|anything in list("Minutes", "Hours", "Days", "Weeks")
			if(!duration_type)
				return
			var/chosen_amount = input(user, "Choose amount (in [duration_type])", "Duration", 0) as num|null
			if(!chosen_amount)
				return
			switch(duration_type)
				if("Minutes")
					chosen_amount = chosen_amount * (1 MINUTES)
				if("Hours")
					chosen_amount = chosen_amount * (1 HOURS)
				if("Days")
					chosen_amount = chosen_amount * (24 HOURS)
				if("Weeks")
					chosen_amount = chosen_amount * (24 HOURS) * 7

			selected_duration = chosen_amount
		if("reason")
			var/chosen_reason = input(user, "Input reason", "Reason", selected_reason) as message|null
			if(!chosen_reason)
				return
			selected_reason = chosen_reason

		if("add_role")
			var/selected_role = input(user, "Choose Role", "Role", null) as null|anything in SSjob.name_occupations
			if(!selected_role)
				return
			selected_roles |= selected_role
		if("remove_role")
			var/to_remove = href_list["role_name"]
			selected_roles -= to_remove

		if("add_migrant")
			var/selected_migrant = input(user, "Choose Migrant", "Migrant", null) as null|anything in get_all_migrant_role_names()
			if(!selected_migrant)
				return
			selected_migrants |= selected_migrant
		if("remove_migrant")
			var/to_remove = href_list["migrant_name"]
			selected_migrants -= to_remove

		if("add_advclass")
			var/selected_advclass = input(user, "Choose Adv Class", "Adv Class", null) as null|anything in SSrole_class_handler.get_all_advclass_names()
			if(!selected_advclass)
				return
			selected_advclasses |= selected_advclass
		if("remove_advclass")
			var/to_remove = href_list["advclass_name"]
			selected_advclasses -= to_remove

		if("add_antag")
			var/selected_antag = input(user, "Choose antag", "Antags", null) as null|anything in ALL_ANTAG_BANS
			if(!selected_antag)
				return
			selected_antags |= selected_antag
		if("remove_antag")
			var/to_remove = href_list["antag_name"]
			selected_antags -= to_remove

		if("add_trait")
			var/selected_trait = input(user, "Choose trait", "Traits", null) as null|anything in ALL_PRESET_TRAIT_BANS
			if(!selected_trait)
				return
			selected_traits |= selected_trait
		if("add_trait_any")
			var/input_trait = input(user, "Input custom trait \nMake sure it matches its name precisely!", "Traits", "") as text|null
			if(!input_trait)
				return
			selected_traits |= input_trait
		if("remove_trait")
			var/to_remove = href_list["trait_name"]
			selected_traits -= to_remove

		if("add_misc")
			var/selected_misc_thing = input(user, "Choose a Misc Ban", "Misc Bans", null) as null|anything in ALL_MISC_BANS
			if(!selected_misc_thing)
				return
			selected_misc |= selected_misc_thing
		if("remove_misc")
			var/to_remove = href_list["misc_ban"]
			selected_misc -= to_remove

		if("add_curse")
			var/selected_curse_thing = input(user, "Choose a Curse", "Curses", null) as null|anything in GLOB.curse_names
			if(!selected_curse_thing)
				return
			selected_curses |= selected_curse_thing
		if("remove_curse")
			var/to_remove = href_list["curse_ban"]
			selected_curses -= to_remove
		if("add_race")
			var/selected_race_thing = browser_input_list(user, "Choose a Race", "Races", RACES_PLAYER_ALL)
			if(!selected_race_thing)
				return
			selected_races |= selected_race_thing
		if("remove_race")
			var/to_remove = href_list["race_ban"]
			selected_races -= to_remove

		if("remove_ckey_role_ban")
			var/ckey = href_list["ckey"]
			var/ban_index = text2num(href_list["ban_index"])
			var/alert = alert(user, "You sure you want to remove the ban?", "Remove Role Ban", "Yes", "No")
			if(alert != "Yes")
				return
			var/datum/role_bans/bans = get_role_bans_for_ckey(ckey)
			if(!bans)
				return
			if(length(bans.bans) < ban_index)
				return
			var/datum/role_ban_instance/instance = bans.bans[ban_index]
			var/list/ban_string = instance.get_ban_string_list()
			var/msg = "[key_name_admin(user)] REMOVED a ROLE BAN from ckey: [selected_ckey] \n[ban_string.Join("\n")]"
			message_admins(msg)
			log_admin(msg)
			log_game(msg)
			remove_role_ban_for_ckey(ckey, instance)
			show_ckey_role_bans_ui(user, ckey)
			return

	show_ui(user)

/datum/role_ban_panel/proc/check_bans(mob/user)
	var/chosen_ckey = input(user, "Choose ckey to check role bans", "Check Role Bans", "") as text|null
	if(!chosen_ckey)
		return
	show_ckey_role_bans_ui(user, chosen_ckey)

/datum/role_ban_panel/proc/show_ckey_role_bans_ui(mob/user, chosen_ckey)
	chosen_ckey = ckey(chosen_ckey)
	var/datum/role_bans/bans = get_role_bans_for_ckey(chosen_ckey)
	var/list/dat = list()
	dat += "<center><b>Role bans for [chosen_ckey]</b></center><HR>"
	var/i = 0
	for(var/datum/role_ban_instance/instance as anything in bans.bans)
		var/list/ban_string = instance.get_ban_string_list()
		i++
		dat += "Actions: <a href='byond://?src=[REF(src)];task=remove_ckey_role_ban;ckey=[chosen_ckey];ban_index=[i];ban_apply_date=[instance.apply_date]'>Remove</a><BR>"
		if(!instance.permanent && world.realtime >= instance.apply_date + instance.duration)
			dat += "<b>EXPIRED</b><BR>"
		dat += ban_string.Join("<BR>")
		dat += "<HR>"
	var/datum/browser/popup = new(user, "ckey_role_ban_panel", "[chosen_ckey] Role Ban Panel", 550, 500)
	popup.set_content(dat.Join())
	popup.open()

/datum/role_ban_panel/proc/apply_ban(mob/user)
	if(holder.owner != user.client)
		return
	if(!check_rights_for(user.client, R_BAN))
		to_chat(user, span_boldwarning("No +BAN permission"))
		return
	if(!selected_ckey)
		to_chat(user, span_boldwarning("Missing CKEY"))
		return
	if(!selected_reason)
		to_chat(user, span_boldwarning("Missing reason"))
		return
	if(!selected_is_permanent && selected_duration == 0)
		to_chat(user, span_boldwarning("Missing duration"))
		return
	var/datum/role_ban_instance/instance = new /datum/role_ban_instance()
	instance.applied_by = ckey(user.ckey)
	instance.apply_date = world.realtime
	instance.round_id = GLOB.rogue_round_id
	instance.duration = selected_duration
	instance.permanent = selected_is_permanent
	instance.reason = selected_reason
	if(length(selected_roles))
		instance.roles = selected_roles.Copy()
	if(length(selected_migrants))
		instance.migrants = selected_migrants.Copy()
	if(length(selected_advclasses))
		instance.advclasses = selected_advclasses.Copy()
	if(length(selected_antags))
		instance.antags = selected_antags.Copy()
	if(length(selected_traits))
		instance.traits = selected_traits.Copy()
	if(length(selected_misc))
		instance.misc = selected_misc.Copy()
	if(length(selected_curses))
		instance.curses = selected_curses.Copy()
	if(length(selected_races))
		instance.races = selected_races.Copy()
	var/list/ban_string = instance.get_ban_string_list()
	var/msg = "[key_name_admin(user)] applied a ROLE BAN for ckey: [selected_ckey] \n[ban_string.Join("\n")]"
	message_admins(msg)
	log_admin(msg)
	log_game(msg)
	add_role_ban_for_ckey(selected_ckey, instance)
	reset_panel(user)

/datum/role_ban_panel/proc/reset_panel(mob/user)
	selected_ckey = null
	selected_reason = null
	selected_duration = 0
	selected_is_permanent = FALSE
	selected_roles.Cut()
	selected_migrants.Cut()
	selected_advclasses.Cut()
	selected_antags.Cut()
	selected_traits.Cut()
	selected_misc.Cut()
	selected_curses.Cut()
	selected_races.Cut()

/proc/get_all_migrant_role_names()
	var/list/compiled = list()
	for(var/migrant_type in GLOB.migrant_roles)
		var/datum/migrant_role/role = MIGRANT_ROLE(migrant_type)
		compiled += role.name
	return compiled
