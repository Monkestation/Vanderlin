GLOBAL_LIST_EMPTY(custom_jobs) // Admin created jobs
GLOBAL_LIST_EMPTY(custom_waves) // Created waves
GLOBAL_LIST_EMPTY(custom_outfits) //Admin created outfits


// Minimal custom job datum
/datum/job/custom_job
	title = "Unnamed Job"
	tutorial = "No description provided."
	enabled = FALSE
	can_random = FALSE
	can_have_apprentices = FALSE
	job_flags = (JOB_EQUIP_RANK)

/datum/create_wave
	var/datum/admins/admin_holder = null

	var/list/already_added_custom_jobs = list()
	var/list/already_added_custom_outfits = list()
	var/potential_custom_outfits_options = ""


	// Lists for the real time add/removal of those vars for Job
	var/list/pending_skills = list()
	var/list/pending_traits = list()
	var/list/pending_stats = list()

	// Lists for the real time add/removal of those vars for Wave
	var/list/pending_jobs = list()

	// Lists used on the Custom Job HTML
	var/list/factions_list = ALL_FACTIONS
	var/list/outfits_list = list()
	var/list/sexes_list = list(MALE,FEMALE)
	var/list/races_list = RACES_PLAYER_ALL
	var/list/ages_list = list(AGE_CHILD,AGE_ADULT,AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	var/list/stats_list = list(STATKEY_INT,STATKEY_STR,STATKEY_PER,STATKEY_SPD,STATKEY_CON,STATKEY_LCK)
	var/list/skills_list = list()
	var/list/languages_list = list()
	var/list/traits_list = list()
	var/list/antag_list = list()
	var/list/patrons_list = list()

	// Lists used on the Custom Wave HTML

	var/list/potential_jobs = list()
	var/potential_jobs_options = ""
	var/potential_custom_jobs_options = ""

	// Create HTML options for skills dropdown
	var/skills_options = ""
	var/trait_options = ""
	var/stat_options = ""

	// Temps vars to recreate the job browser
	var/temp_job_title
	var/temp_job_tutorial
	var/temp_faction
	var/temp_outfit
	var/temp_antag
	var/temp_custom_combat_song
	var/temp_allowed_sexes
	var/temp_allowed_races
	var/temp_allowed_ages
	var/temp_languages
	var/temp_patrons

	// Temp booleans
	var/temp_antag_bool
	var/temp_foreigner_bool
	var/temp_recognized_bool
	var/temp_custom_combat_song_bool
	var/temp_magick_user_bool

	// Temps vars to recreate the wave browser
	var/temp_wave_title
	var/temp_wave_greeting_text
	var/temp_min_pop

	// Outfit lists to be init

	var/init_outfit = FALSE

	var/list/o_belt = list()
	var/o_belt_options = ""
	var/list/o_gloves = list()
	var/o_gloves_options = ""
	var/list/o_shoes = list()
	var/o_shoes_options = ""
	var/list/o_head = list()
	var/o_head_options = ""
	var/list/o_mask = list()
	var/o_mask_options = ""
	var/list/o_neck = list()
	var/o_neck_options = ""
	var/list/o_wrists = list()
	var/o_wrists_options = ""
	var/list/o_cloak = list()
	var/o_cloak_options = ""
	var/list/o_shirt = list()
	var/o_shirt_options = ""
	var/list/o_pants = list()
	var/o_pants_options = ""
	var/list/o_armor = list()
	var/o_armor_options = ""
	var/list/o_ring = list()
	var/o_ring_options = ""
	var/list/o_scabbards = list()
	var/o_scabbards_options = ""
	var/list/o_items = list()
	var/o_items_options = ""


/datum/custom_wave
	abstract_type = /datum/custom_wave
	var/name = "Custom Wave"
	var/greeting_text = "Hello Hello"

	var/min_pop = 1
	var/max_pop = 0


	var/timer
	var/spawn_landmark

	var/list/candidates = list()
	var/list/wave_jobs = list()

/datum/create_wave/New()

	for(var/datum/skill/skill as anything in subtypesof(/datum/skill))
		if(IS_ABSTRACT(skill))
			continue
		skills_list += skill

	for(var/trait in GLOB.traits_by_type)
		traits_list += GLOB.traits_by_type[trait]

	for(var/trait in traits_list)
		trait_options += "<option value='[trait]'>[trait]</option>"

	for(var/datum/skill/skill_instance in skills_list)
		skills_options += "<option value='[initial(skill_instance.type)]'>[initial(skill_instance.name)]</option>"

	for(var/stat in stats_list)
		stat_options += "<option value='[(stat)]'>[stat]</option>"

	for(var/datum/patron as anything in subtypesof(/datum/patron))
		var/datum/patron/i = new patron
		if(!i.name)
			continue
		qdel(i)
		patrons_list += patron

	for(var/datum/antagonist as anything in subtypesof(/datum/antagonist))
		antag_list += antagonist

	for(var/datum/language/language as anything in subtypesof(/datum/language))
		if(language == /datum/language/aphasia)
			continue
		languages_list += language



/datum/create_wave/proc/update_temp_job_fields(href_list)
	temp_job_title = href_list["title"]
	temp_job_tutorial = href_list["tutorial"]
	temp_faction = href_list["faction"]
	temp_outfit = text2path(href_list["outfit"])
	var/sexes_string = href_list["allowed_sexes"]
	var/list/sexes_list = splittext(sexes_string, ",")
	temp_allowed_sexes = sexes_list
	var/races_string = href_list["allowed_races"]
	var/list/races_list = splittext(races_string, ",")
	temp_allowed_races = races_list
	var/allowed_ages_string = href_list["allowed_ages"]
	var/list/allowed_ages_list = splittext(allowed_ages_string, ",")
	temp_allowed_ages = allowed_ages_list
	var/languages_string = href_list["languages"]
	var/list/languages_list = list()
	for(var/entry in splittext(languages_string, ","))
		var/path = text2path(entry)
		if(path)
			languages_list += path
	temp_languages = languages_list

	var/patrons_string = href_list["patrons"]
	var/list/patrons_list = list()
	for(var/entry in splittext(patrons_string, ","))
		var/path = text2path(entry)
		if(path)
			patrons_list += path
	temp_patrons = patrons_list

	temp_antag_bool = text2num(href_list["antag_bool"])
	if(temp_antag_bool && temp_antag_bool == 1)
		temp_antag = text2path(href_list["antag"])
	temp_foreigner_bool = text2num(href_list["foreigner_bool"])
	temp_recognized_bool = text2num(href_list["recognized_bool"])
	temp_custom_combat_song_bool = text2num(href_list["combat_song_bool"])
	if(temp_custom_combat_song_bool && temp_custom_combat_song_bool == 1)
		temp_custom_combat_song = href_list["combat_song"]
	temp_magick_user_bool = text2num(href_list["magick_user_bool"])

/datum/create_wave/Topic(href, href_list)
	..()
	var/client/C = usr?.client
	if(!C)
		return
	if(href_list["join_wave"])
		var/datum/custom_wave/CW = locate(href_list["chosen_wave"]) in GLOB.custom_waves
		if(!CW)
			return
		if(!CW.can_be_roles(C))
			return
		if(length(CW.candidates) >= CW.max_pop)
			to_chat(usr, span_notice("The [CW.name] has reached their maximum capacity."))
			return
		if(!(C in CW.candidates))
			CW.candidates += C
			to_chat(usr, span_notice("You have joined the [CW.name]."))
			var/datum/browser/B = locate(href_list["popup"])
			if(B)
				B.close()
			return

	if(href_list["decline_wave"])
		var/datum/browser/B = locate(href_list["popup"])
		if(B)
			B.close()
		to_chat(usr, span_warning("You ignored the wave call."))
		return

	if(usr.client != admin_holder.owner || !check_rights(0))
		message_admins("[usr.key] has attempted to override the admin panel!")
		log_admin("[key_name_admin(usr)] tried to use the admin panel without authorization.")
		return

	if(href == "close=1")
		pending_skills = list()
		pending_traits = list()
		pending_stats = list()
		temp_job_title = null
		temp_job_tutorial = null
		temp_faction = null
		temp_outfit = null
		temp_antag = null
		temp_allowed_sexes = null
		temp_allowed_races = null
		temp_allowed_ages = null
		temp_languages = null
		temp_patrons = null
		temp_custom_combat_song = null
		temp_custom_combat_song_bool = null
		temp_antag_bool = null
		temp_foreigner_bool = null
		temp_recognized_bool = null
		temp_magick_user_bool = null
		return

	var/edit_job_see = href_list["chosen_job_edit"]
	var/editing_job = FALSE
	if(edit_job_see)
		editing_job = TRUE

	// Menu Related Topic
	if(href_list["job_manager_menu"])
		if(!check_rights(R_ADMIN))
			return
		custom_job_manager(usr)
	else if(href_list["wave_manager_menu"])
		if(!check_rights(R_ADMIN))
			return
		custom_wave_manager(usr)
	else if(href_list["outfit_manager_menu"])
		if(!check_rights(R_ADMIN))
			return
		outfit_manager(usr)
	// Job related Topic
	else if(href_list["create_job_finalize"])
		if(!check_rights(R_ADMIN))
			return
		create_job_finalize(usr, href_list)
		create_job(usr)
	else if(href_list["create_job_menu"])
		if(!check_rights(R_ADMIN))
			return
		create_job(usr)
	else if(href_list["delete_job"])
		if(!check_rights(R_ADMIN))
			return
		var/id = href_list["chosen_job"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		delete_job(usr, J)
	else if(href_list["edit_job"])
		if(!check_rights(R_ADMIN))
			return
		var/id = href_list["chosen_job"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		edit_job(usr, J)
	else if(href_list["view_job"])
		if(!check_rights(R_ADMIN))
			return
		var/id = href_list["chosen_job"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		view_job(usr, J)
	else if(href_list["add_skill"])
		if(!check_rights(R_ADMIN))
			return
		var/skill = text2path(href_list["skill"])
		var/datum/skill/S = new skill
		var/level = text2num(href_list["level"])

		if(level && level > 0 && level < 7)
			// Store as list of lists: [skill_path, level]
			if(editing_job)
				var/id = href_list["chosen_job_edit"]
				var/datum/job/custom_job/J =  GLOB.custom_jobs[id]
				if(skill in J.skills)
					to_chat(usr, span_warning("[S.name] is already in the [J.title] skill list!"))
					return
				J.skills[skill] = level
				to_chat(usr, span_notice("Added [S.name] at level [level] for the [J.title]."))
				edit_job(usr, J)
			else
				update_temp_job_fields(href_list)
				if(skill in pending_skills)
					to_chat(usr, span_warning("[S.name] is already in the job skill list!"))
					return
				pending_skills[skill] = level
				to_chat(usr, span_notice("Added [S.name] at level [level]."))
				create_job(usr, href_list)
		else
			to_chat(usr, span_notice("Failed to add [S.name], invalid level inserted [level]."))
		qdel(S)
	else if(href_list["remove_skill"])
		if(!check_rights(R_ADMIN))
			return
		var/skill_to_remove = text2path(href_list["skill"])
		var/datum/skill/S_R = new skill_to_remove

		if(editing_job)
			var/id = href_list["chosen_job_edit"]
			var/datum/job/custom_job/J =  GLOB.custom_jobs[id]
			if(skill_to_remove in J.skills)
				to_chat(usr, span_warning("[S_R.name] not found in skill list of the [J.title]."))
				return
			if(skill_to_remove)
				J.skills = skill_to_remove
				to_chat(usr, span_notice("Removed [S_R.name] from the skill list of the [J.title]."))
				edit_job(usr, J)
		else
			update_temp_job_fields(href_list)
			if(skill_to_remove in pending_skills)
				pending_skills -= skill_to_remove
				to_chat(usr, span_notice("Removed [S_R.name] from the skill list."))
				create_job(usr)
			else
				to_chat(usr, span_warning("[S_R.name] not found in skill list."))
		qdel(S_R)

	else if(href_list["add_trait"])
		if(!check_rights(R_ADMIN))
			return
		var/trait = href_list["trait"]

		if(editing_job)
			var/id = href_list["chosen_job_edit"]
			var/datum/job/custom_job/J =  GLOB.custom_jobs[id]
			if(trait in J.traits)
				to_chat(usr, span_warning("[trait] is already in the [J.title] trait list!"))
				return
			if(trait)
				J.traits += trait
				to_chat(usr, span_notice("Added the trait: [trait] to the [J.title]."))
				edit_job(usr, J)
		else
			update_temp_job_fields(href_list)
			if(trait in pending_traits)
				to_chat(usr, span_warning("[trait] is already in the job trait list!"))
				return
			if(trait)
				pending_traits += trait
				to_chat(usr, span_notice("Added the trait: [trait]."))
				create_job(usr, href_list)
	else if(href_list["remove_trait"])
		if(!check_rights(R_ADMIN))
			return
		var/trait_to_remove = href_list["trait"]
		if(editing_job)
			var/id = href_list["chosen_job_edit"]
			var/datum/job/custom_job/J =  GLOB.custom_jobs[id]
			if(trait_to_remove in J.traits)
				J.traits -= trait_to_remove
				to_chat(usr, span_notice("Removed the trait: [trait_to_remove] from the [J.title]."))
				edit_job(usr, J)
			else
				to_chat(usr, span_notice("[trait_to_remove] not found in the [J.title] trait list."))
		else
			update_temp_job_fields(href_list)
			if(trait_to_remove in pending_traits)
				pending_traits -= trait_to_remove
				to_chat(usr, span_notice("Removed [trait_to_remove] from the trait list."))
				create_job(usr)
			else
				to_chat(usr, span_warning("[trait_to_remove] not found in trait list."))
	else if(href_list["add_stat"])
		if(!check_rights(R_ADMIN))
			return
		var/stat = href_list["stat"]
		var/modifier = href_list["modifier"]
		if(editing_job)
			var/id = href_list["chosen_job_edit"]
			var/datum/job/custom_job/J =  GLOB.custom_jobs[id]
			if(stat in J.jobstats)
				to_chat(usr, span_warning("[stat] is already in the [J.title] stat list!"))
				return
			if(stat)
				J.jobstats[stat] = text2num(modifier)
				to_chat(usr, span_notice("Added [stat] with a modifier of [modifier] to the [J.title]."))
				edit_job(usr, J)
		else
			update_temp_job_fields(href_list)
			if(stat in pending_stats)
				to_chat(usr, span_warning("[stat] is already in the job stat list!"))
				return
			if(stat)
				pending_stats[stat] = text2num(modifier)
				to_chat(usr, span_notice("Added [stat] with a modifier of [modifier]"))
				create_job(usr)
	else if(href_list["remove_stat"])
		if(!check_rights(R_ADMIN))
			return
		var/stat_to_remove = href_list["stat"]
		if(editing_job)
			var/id = href_list["chosen_job_edit"]
			var/datum/job/custom_job/J =  GLOB.custom_jobs[id]
			if(stat_to_remove in J.jobstats)
				J.jobstats -= stat_to_remove
				to_chat(usr, span_notice("Removed [stat_to_remove] from the [J.title] stat list."))
				edit_job(usr, J)
			else
				to_chat(usr, span_warning("[stat_to_remove] not found in the [J.title] stat list."))
		else
			update_temp_job_fields(href_list)
			if(stat_to_remove in pending_stats)
				pending_stats -= stat_to_remove
				to_chat(usr, span_notice("Removed [stat_to_remove] from the stat list."))
				create_job(usr)
			else
				to_chat(usr, span_warning("[stat_to_remove] not found in stat list."))

	// Export a single job as JSON
	else if(href_list["export_job"])
		if(!check_rights(R_ADMIN))
			return
		var/id = href_list["chosen_job"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			var/list/json_data = list()
			json_data += J.get_json_data()
			J.export_to_file(usr)
	// Import jobs
	else if(href_list["import_jobs"])
		if(!check_rights(R_ADMIN))
			return
		load_job(usr)
		custom_job_manager(usr)
	else if(href_list["update_job_title"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			J.title = href_list["new_title"]
		custom_job_manager(usr)
	else if(href_list["update_job_tutorial"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			J.tutorial = href_list["new_tutorial"]
	else if(href_list["update_job_song"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			J.cmode_music = href_list["new_song"]
	else if(href_list["update_job_faction"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			J.faction = href_list["new_faction"]
			edit_job(usr, J)
	else if(href_list["update_job_outfit"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			var/new_out = href_list["new_outfit"]
			if(new_out)
				J.outfit = new_out
			edit_job(usr, J)
	else if(href_list["update_job_antag"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			var/new_path = text2path(href_list["new_antag"])
			if(new_path)
				J.antag_role = new_path
			edit_job(usr, J)
	else if(href_list["update_job_race"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			J.allowed_races = splittext(href_list["new_races"], ",")
			edit_job(usr, J)
	else if(href_list["update_job_age"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			J.allowed_ages = splittext(href_list["new_ages"], ",")
			edit_job(usr, J)
	else if(href_list["update_job_patron"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			var/list/patron_list = splittext(href_list["new_patrons"], ",")
			J.allowed_patrons = list()
			for(var/patron in patron_list)
				var/path = text2path(patron)
				if(path)
					J.allowed_patrons += path
			edit_job(usr, J)
	else if(href_list["update_job_languages"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			var/list/lang_list = splittext(href_list["new_languages"], ",")
			J.languages = list()
			for(var/lang_path in lang_list)
				var/path = text2path(lang_path)
				if(path)
					J.languages += path
			edit_job(usr, J)
	else if(href_list["update_job_allowed_sexes"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			J.allowed_sexes = splittext(href_list["new_allowed_sexes"], ",")
			edit_job(usr, J)
	else if(href_list["update_job_foreigner"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			J.is_foreigner = text2num(href_list["new_foreigner"])
			edit_job(usr, J)
	else if(href_list["update_job_recognized"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			J.is_recognized = text2num(href_list["new_recognized"])
			edit_job(usr, J)
	else if(href_list["update_job_magick_user"])
		var/id = href_list["chosen_job_edit"]
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		if(J)
			J.magic_user = text2num(href_list["new_magick_user"])
			edit_job(usr, J)

	// Wave related Topic
	if(href_list["create_wave_finalize"])
		if(!check_rights(R_ADMIN))
			return
		create_wave_finalize(usr, href_list)
		create_wave(usr)
	else if(href_list["create_wave_menu"])
		if(!check_rights(R_ADMIN))
			return
		pending_jobs = list()
		temp_wave_title = null
		temp_wave_greeting_text = null
		temp_min_pop = null
		create_wave(usr)
	else if(href_list["delete_wave"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/custom_wave/CW = locate(href_list["chosen_wave"]) in GLOB.custom_waves
		delete_wave(usr, CW)
	else if(href_list["edit_wave"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/custom_wave/CW = locate(href_list["chosen_wave"]) in GLOB.custom_waves
		edit_wave(usr, CW)
	else if(href_list["view_wave"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/custom_wave/CW = locate(href_list["chosen_wave"]) in GLOB.custom_waves
		view_wave(usr, CW)
	else if(href_list["announce_wave"])
		if(!check_rights(R_ADMIN))
			return
		var/message = browser_input_text(usr, "Only those at the lobby or dead will see this:", "Wave Announcement")
		if(message)
			var/admin_name = span_adminannounce_big("[usr.client.holder.fakekey ? "Administrator" : usr.key] Wave Announces:")
			var/message_to_announce = ("[span_adminannounce(message)]")
			for(var/client/GC in GLOB.clients)
				if(!GC)
					continue
				var/mob/dead_mob = GC.mob
				if(!dead_mob || !isdead(dead_mob))
					continue
				to_chat(GC, announcement_block("[admin_name] \n \n [message_to_announce]"))
			log_admin("Wave Announce: [key_name(usr)] : [message]")
			message_admins("Wave Announce : [key_name(usr)] : [message]")
			SSblackbox.record_feedback("tally", "admin_verb_announce_wave", 1, "Announce")
	else if(href_list["add_jobs"])
		if(!check_rights(R_ADMIN))
			return
		var/edit_see = locate(href_list["wave_ref"])
		var/edit = FALSE
		var/datum/custom_wave/CW
		if(edit_see)
			edit = TRUE
			CW = locate(href_list["wave_ref"])
		var/job = href_list["job"]
		var/slots = text2num(href_list["slots"])
		var/datum/job/J
		if(ispath(text2path(job), /datum/job))
			J = new job
		else
			J = GLOB.custom_jobs[job]

		temp_wave_title = href_list["name"]
		temp_wave_greeting_text = href_list["name_g"]
		temp_min_pop = href_list["name_mc"]

		if(!slots || slots <= 0)
			to_chat(usr, span_warning("The valid amount of slots are one or higher!."))
			return
		if(edit)
			if(job in CW.wave_jobs)
				to_chat(usr, span_warning("[J.title] is already in the [CW.name] job list!"))
				return
			CW.wave_jobs[job] = slots
			to_chat(usr, span_notice("Added [slots] slot(s) for [job] in the [CW.name]."))
			CW.max_pop = 0
			for(var/job_count in CW.wave_jobs)
				var/slots_count = CW.wave_jobs[job_count]
				if(slots_count)
					CW.max_pop += text2num(slots_count)
			edit_wave(usr, CW)
		else
			if(job in pending_jobs)
				to_chat(usr, span_warning("[J.title] is already in the job list!"))
				return
			pending_jobs[job] = slots
			to_chat(usr, span_notice("Added [slots] slot(s) for [job]."))
			create_wave(usr)
	else if(href_list["remove_job"])
		if(!check_rights(R_ADMIN))
			return
		var/job_to_remove = href_list["job"]
		var/edit_see = locate(href_list["wave_ref"])
		var/edit = FALSE
		var/datum/custom_wave/CW
		if(edit_see)
			edit = TRUE
			CW = locate(href_list["wave_ref"])

		temp_wave_title = href_list["name"]
		temp_wave_greeting_text = href_list["name_g"]
		temp_min_pop = href_list["name_mc"]

		if(edit)
			if(job_to_remove in CW.wave_jobs)
				CW.wave_jobs -= job_to_remove
				to_chat(usr, span_notice("Removed [job_to_remove] from the [CW.name] job list."))
				CW.max_pop = 0
				for(var/job in CW.wave_jobs)
					var/slots = CW.wave_jobs[job]
					if(slots)
						CW.max_pop += text2num(slots)
				edit_wave(usr, CW)
			else
				to_chat(usr, span_warning("[job_to_remove] not found in [CW.name] job list."))
		else
			if(job_to_remove in pending_jobs)
				pending_jobs -= job_to_remove
				to_chat(usr, span_notice("Removed [job_to_remove] from the job list."))
				create_wave(usr)
			else
				to_chat(usr, span_warning("[job_to_remove] not found in job list."))

	else if(href_list["update_wave_name"])
		var/datum/custom_wave/CW = locate(href_list["wave_ref"])
		if(CW)
			CW.name = href_list["new_name"]
		custom_wave_manager(usr)
	else if(href_list["update_wave_greeting"])
		var/datum/custom_wave/CW = locate(href_list["wave_ref"])
		if(CW)
			CW.greeting_text = href_list["new_g"]
	else if(href_list["update_wave_min_pop"])
		var/datum/custom_wave/CW = locate(href_list["wave_ref"])
		if(CW)
			CW.min_pop = text2num(href_list["new_mc"])
	else if(href_list["export_wave"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/custom_wave/CW = locate(href_list["chosen_wave"]) in GLOB.custom_waves
		if(CW)
			var/list/json_data = list()
			json_data += CW.get_json_data()
			CW.export_to_file(usr)
	else if(href_list["import_wave"])
		if(!check_rights(R_ADMIN))
			return
		load_wave(usr)
		custom_wave_manager(usr)

	else if(href_list["start_wave"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/custom_wave/CW = locate(href_list["chosen_wave"]) in GLOB.custom_waves
		start_wave(usr, CW)

	// Outfit Manage code
	else if(href_list["create_outfit_finalize"])
		if(!check_rights(R_ADMIN))
			return
		create_outfit_finalize(usr,href_list)
	else if(href_list["load_outfit"])
		if(!check_rights(R_ADMIN))
			return
		load_outfit(usr)
	else if(href_list["create_outfit_menu"])
		if(!check_rights(R_ADMIN))
			return
		create_outfit(usr)
	else if(href_list["delete_outfit"])
		if(!check_rights(R_ADMIN))
			return
		var/id = href_list["chosen_outfit"]
		var/datum/outfit/O =  GLOB.custom_outfits[id]
		delete_outfit(usr,O)
	else if(href_list["save_outfit"])
		if(!check_rights(R_ADMIN))
			return
		var/id = href_list["chosen_outfit"]
		var/datum/outfit/O =  GLOB.custom_outfits[id]
		save_outfit(usr,O)
	else if(href_list["view_outfit"])
		if(!check_rights(R_ADMIN))
			return
		var/id = href_list["chosen_outfit"]
		var/datum/outfit/O =  GLOB.custom_outfits[id]
		view_outfit(usr, O)

/client/proc/wave_creation_tools()
	set category = "Debug"
	set name = "Wave Creation Tools"

	if(!check_rights(R_DEBUG))
		return
	holder.create_wave.menu(usr)

/datum/create_wave/proc/menu(mob/admin)
	if(SSticker.current_state == GAME_STATE_STARTUP)
		to_chat(admin, span_notice("Wait until the game set up is completed!"))
		return

	var/list/dat = list()
	dat += "<a href='byond://?src=[REF(src)];[HrefToken()];job_manager_menu=1'>Job Manager Menu </a><br>"
	dat += "<a href='byond://?src=[REF(src)];[HrefToken()];wave_manager_menu=1'>Wave Manager Menu</a><br>"
	dat += "<a href='byond://?src=[REF(src)];[HrefToken()];outfit_manager_menu=1'>Outfit Manager Menu</a><br>"

	var/datum/browser/popup = new(admin, "menu", "Menu", 500, 500, src)
	popup.set_content(dat.Join())
	popup.open(FALSE)

// Admin-side proc to show the manager
/datum/create_wave/proc/custom_job_manager(mob/admin)

	if(length(GLOB.custom_outfits))
		for(var/id in GLOB.custom_outfits)
			var/datum/outfit/O = GLOB.custom_outfits[id]

			if(!O ||!O.id)
				continue
			if(O.id in already_added_custom_outfits)
				continue

			outfits_list += O.id
			already_added_custom_outfits += O.id


	var/list/dat = list("<ul>")
	for(var/id in GLOB.custom_jobs)
		var/datum/job/custom_job/J = GLOB.custom_jobs[id]
		var/vv = FALSE
		dat += "<li><a href='byond://?src=[REF(src)];[HrefToken()];view_job=1;chosen_job=[J.id]'>[J.title]</a>[vv ? " (Custom Fields)" : ""]</li>"
		dat += "<a href='byond://?src=[REF(src)];[HrefToken()];delete_job=1;chosen_job=[J.id]'>Delete</a>"
		dat += "<a href='byond://?src=[REF(src)];[HrefToken()];edit_job=1;chosen_job=[J.id]'>Edit</a>"
		dat += "<a href='byond://?src=[REF(src)];[HrefToken()];export_job=1;chosen_job=[J.id]'>Export</a>"
		dat += "</li>"
	dat += "</ul>"
	dat += "<a href='byond://?src=[REF(src)];[HrefToken()];create_job_menu=1'>Create Job</a><br>"
	dat += "<a href='byond://?src=[REF(src)];[HrefToken()];import_jobs=1'>Import Job</a><br>"

	var/datum/browser/popup = new(admin, "customjobmanager", "Custom Job Manager", 670, 650, src)
	popup.set_content(dat.Join())
	popup.open(FALSE)


// Admin-side proc to show the manager
/datum/create_wave/proc/custom_wave_manager(mob/admin)

	if(!length(potential_jobs))
		for(var/datum/job/job as anything in SSjob.joinable_occupations)
			potential_jobs += job
		for(var/datum/job/migrant as anything in subtypesof(/datum/job/migrant))
			if(IS_ABSTRACT(migrant))
				continue
			potential_jobs += new migrant

	if(potential_jobs_options == "")
		for(var/datum/job/job in potential_jobs)
			potential_jobs_options += "<option value='[(job)]'>[job.title]</option>"

	if(length(GLOB.custom_jobs))
		for(var/id in GLOB.custom_jobs)
			var/datum/job/custom_job/J = GLOB.custom_jobs[id]

			if(!J ||!J.id)
				continue
			if(J.id in already_added_custom_jobs)
				continue

			potential_custom_jobs_options += "<option value='[(J.id)]'>[J.title]</option>"
			already_added_custom_jobs += J.id


	var/list/dat = list("<ul>")
	for(var/datum/custom_wave/CW in GLOB.custom_waves)
		var/vv = FALSE
		dat += "<li><a href='byond://?src=[REF(src)];[HrefToken()];view_wave=1;chosen_wave=[REF(CW)]'>[CW.name]</a>[vv ? " (Custom Fields)" : ""]</li>"
		dat += "<a href='byond://?src=[REF(src)];[HrefToken()];delete_wave=1;chosen_wave=[REF(CW)]'>Delete</a>"
		dat += "<a href='byond://?src=[REF(src)];[HrefToken()];edit_wave=1;chosen_wave=[REF(CW)]'>Edit</a>"
		dat += "<a href='byond://?src=[REF(src)];[HrefToken()];start_wave=1;chosen_wave=[REF(CW)]'>Start Wave</a>"
		dat += "<a href='byond://?src=[REF(src)];[HrefToken()];export_wave=1;chosen_wave=[REF(CW)]'>Export Wave</a>"
		dat += "</li>"
	dat += "</ul>"
	dat += "<a href='byond://?src=[REF(src)];[HrefToken()];create_wave_menu=1'>Create Wave</a><br>"
	dat += "<a href='byond://?src=[REF(src)];[HrefToken()];import_wave=1'>Import Wave</a><br>"
	dat += "<a href='byond://?src=[REF(src)];[HrefToken()];announce_wave=1'>Announce Wave</a>"

	var/datum/browser/popup = new(admin, "customwavemanager", "Custom Wave Manager", 670, 650, src)
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/create_wave/proc/outfit_manager(mob/admin)
	var/list/dat = list("<ul>")
	for(var/id in GLOB.custom_outfits)
		var/vv = FALSE
		var/datum/outfit/varedit/VO = GLOB.custom_outfits[id]
		var/datum/outfit/O = GLOB.custom_outfits[id]
		if(istype(VO))
			vv = length(VO.vv_values)
		dat += "<li><a href='byond://?src=[REF(src)];[HrefToken()];view_outfit=1;chosen_outfit=[O.id]'>[O.name]</a>[vv ? "(VV)" : ""]</li> <a href='byond://?src=[REF(src)];[HrefToken()];save_outfit=1;chosen_outfit=[O.id]'>Save</a> <a href='byond://?src=[REF(src)];[HrefToken()];delete_outfit=1;chosen_outfit=[O.id]'>Delete</a>"
	dat += "</ul>"
	dat += "<a href='byond://?src=[REF(src)];[HrefToken()];create_outfit_menu=1'>Create</a><br>"
	dat += "<a href='byond://?src=[REF(src)];[HrefToken()];load_outfit=1'>Load from file</a>"
	var/datum/browser/popup = new(admin, "outfitmanager", "Outfit Manager", 670, 650)
	popup.set_content(dat.Join())
	popup.open()



// View Job
/datum/create_wave/proc/view_job(mob/admin, datum/job/custom_job/J)
	if(!J)
		return

	var/list/dat = list("<html><body>")
	dat += "<h2>Job Title: [J.title]</h2>"
	dat += "<b>Tutorial</b><br><pre style='white-space:pre-wrap;'>[J.tutorial]</pre>"
	dat += "<h3>Faction:</h3> [J.faction]<br>"
	dat += "<h3>Outfit:</h3> [J.outfit]<br>"
	dat += "<h3>Custom Combat Song:</h3>"
	if(J.cmode_music)
		dat += "[J.cmode_music]<br>"
	else
		dat += "No custom combat song.<br>"
	dat += "<h3>Antag role:</h3>"
	if(J.antag_role)
		dat += "[J.antag_role]<br>"
	else
		dat += "Not an antag.<br>"
	dat += "<h3>Foreigner:</h3>"
	if(J.is_foreigner)
		dat += "Yes.<br>"
	else
		dat += "No.<br>"
	dat += "<h3>Recognized:</h3>"
	if(J.is_recognized)
		dat += "Yes.<br>"
	else
		dat += "No.<br>"
	dat += "<h3>Magick User:</h3>"
	if(J.magic_user)
		dat += "Yes.<br>"
	else
		dat += "No.<br>"
	dat += "<h3>Allowed sexes:</h3> "
	for(var/sex in J.allowed_sexes)
		dat += "[sex] "
	dat += "<h3>Allowed ages:</h3> "
	for(var/age in J.allowed_ages)
		dat += "[age] "
	dat += "<br>"
	dat += "<h3>Allowed races:</h3> "
	for(var/race in J.allowed_races)
		dat += "[race] "
	dat += "<h3>Languages:</h3> "
	if(length(J.languages))
		for(var/datum/language/L as anything in J.languages)
			dat += "[initial(L.name)] "
	else
		dat += "Imperial (Default)"
	dat += "<h3>Allowed Patrons:</h3><br>"
	if(length(J.allowed_patrons))
		for(var/datum/patron/P as anything in J.allowed_patrons)
			dat += "<li>[initial(P.name)]</li>"
	else
		dat += "<li>All Patrons are Allowed.</li>"
	dat += "<h3>Skills:</h3><ul>"
	if(length(J.skills))
		for(var/datum/skill/S as anything in J.skills)
			var/level = J.skills[S]
			dat += "<li>[initial(S.name)] (Level [level])</li>"
	else
		dat += "None"
	dat += "</ul>"
	dat += "<h3>Traits:</h3><ul>"
	if(length(J.traits))
		for(var/trait in J.traits)
			dat += "<li>[trait]</li>"
		dat += "</ul>"
	else
		dat += "None"
	dat += "<h3>Stats:</h3><ul>"
	if(length(J.jobstats))
		for(var/stats_path in J.jobstats)
			var/modifier = J.jobstats[stats_path]
			dat += "<li>[stats_path] Modifier [modifier]</li>"
	else
		dat += "None"
	dat += "</ul>"
	dat += "<br>"
	dat += "<br>"
//	dat += "<br><a href='byond://?src=[REF(src)];[HrefToken()];'>Close</a>"
	dat += "</body></html>"

	var/datum/browser/popup = new(admin, "customjob_view", "Custom Job Preview", 600, 520, src)
	popup.set_content(dat.Join())
	popup.open(FALSE)

// Delete a job
/datum/create_wave/proc/delete_job(mob/admin, datum/job/custom_job/J)
	if(!J)
		return
	if(J.id in GLOB.custom_jobs)
		GLOB.custom_jobs -= J.id
	if(J.id in already_added_custom_jobs)
		already_added_custom_jobs -= J.id
		potential_custom_jobs_options = ""
		already_added_custom_jobs = list()
	to_chat(admin, span_notice("Custom job [J.title] deleted."))
	message_admins("[key_name(usr)] deleted the custom job: '[J.title]' with the id of [J.id]")

	qdel(J)
	custom_job_manager(admin)

// Helper function to generate <option> HTML for a true/false (boolean) selector
/datum/create_wave/proc/generate_boolean_option(current_value, temp_bool)
	var/html = ""
	var/list/bool_options = list("TRUE" = TRUE, "FALSE" = FALSE)
	for(var/label in bool_options)
		var/value = bool_options[label]
		html += "<option value='[value]'[(temp_bool ? (value == TRUE) : (value == FALSE)) ? " selected" : ""]>[label]</option>"

	return html

// Helper function to generate <option> HTML for a single select
/datum/create_wave/proc/generate_options(list/options, text_selected = "")
	var/opts = ""
	for(var/opt in options)
		opts += "<option value='[opt]'[opt == text_selected ? " selected" : ""]>[opt]</option>"
	return opts

// Helper function to generate checkboxes for multi-select
/datum/create_wave/proc/generate_checkboxes(list/options, name, list/list_selected)
	var/html = ""
	for(var/opt in options)
		var/v_display_name = ""
		if(ispath(opt, /datum)) // any datum path
			var/datum/D = new opt
			if("name" in D.vars)
				v_display_name = D.vars["name"] || "[opt]"
				if("display_name" in D.vars)
					v_display_name = D.vars["display_name"] || D.vars["name"]
			else
				v_display_name = "[opt]"
			qdel(D)
		else
			v_display_name = "[opt]"

		var/unique_id = "[name]_[opt]"

		html += "<label for='[unique_id]'>"
		html += "<input type='checkbox' id='[unique_id]' name='[name]' value='[opt]'[(opt in list_selected) ? " checked" : ""]>"
		html += " [v_display_name]</label><br>"
	return html


/datum/create_wave/proc/create_job(mob/admin)

    // Generate HTML form
	var/dat = {"
	<html><head><title>Create Custom Job</title></head><body>
	<form name='job' action='byond://?src=[REF(src)];[HrefToken()]' method='get'>
	<input type='hidden' name='src' value='[REF(src)]'>
	[HrefTokenFormField()]
	<input type='hidden' name='create_job_finalize' value='1'>
	<table>
		<script>
			function collectJobData(extra) {
				var params = \[\];
				function add(name, value) { params.push(name + \"=\" + encodeURIComponent(value)); }

				add(\"title\", document.getElementById(\"job_title\").value);
				add(\"tutorial\", document.getElementById(\"job_tutorial\").value);
				add(\"faction\", document.getElementById(\"job_faction\").value);
				add(\"outfit\", document.getElementById(\"job_outfit\").value);
				add(\"antag\", document.getElementById(\"job_antag\").value);
				add(\"antag_bool\", document.getElementById(\"job_enabled_antag\").value);
				add(\"combat_song\", document.getElementById(\"music_path\").value);
				add(\"combat_song_bool\", document.getElementById(\"job_custom_music\").value);
				add(\"magick_user_bool\", document.getElementById(\"job_magick_user\").value);
				add(\"foreigner_bool\", document.getElementById(\"job_foreigner\").value);
				add(\"recognized_bool\", document.getElementById(\"job_recognized\").value);

				function collectChecked(name) {
					var vals = \[\];
					document.querySelectorAll(\"input\[name=\" + name + \"\]:checked\").forEach(function(cb) {
						vals.push(cb.value);
					});
					return vals.join(\",\");
				}

				add(\"allowed_sexes\", collectChecked(\"job_allowed_sexes\"));
				add(\"allowed_races\", collectChecked(\"job_allowed_races\"));
				add(\"allowed_ages\", collectChecked(\"job_allowed_ages\"));
				add(\"languages\", collectChecked(\"job_languages\"));
				add(\"patrons\", collectChecked(\"job_allowed_patrons\"));

				if(extra)
					for(var k in extra)
						add(k, extra\[k\]);

				return params.join(\";&\");
			}

			function addTrait() {
				var trait = document.getElementById(\"traits_dropdown\").value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];add_trait=1;&\" + collectJobData({trait: trait});
			}

			function removeTrait(trait) {
				window.location.href = \"?src=[REF(src)];[HrefToken()];remove_trait=1;&\" + collectJobData({trait: trait});
			}

			function addSkill() {
				var skill = document.getElementById(\"skills_dropdown\").value;
				var level = document.getElementById(\"skills_level\").value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];add_skill=1;&\" + collectJobData({skill: skill, level: level});
			}

			function removeSkill(skill) {
				window.location.href = \"?src=[REF(src)];[HrefToken()];remove_skill=1;&\" + collectJobData({skill: skill});
			}

			function addStat() {
				var stat = document.getElementById(\"stats_dropdown\").value;
				var modifier = document.getElementById(\"stats_level\").value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];add_stat=1;&\" + collectJobData({stat: stat,  modifier: modifier});
			}

			function removeStat(stat) {
				window.location.href = \"?src=[REF(src)];[HrefToken()];remove_stat=1;&\" + collectJobData({stat: stat});
			}
		</script>
		<tr><th>Name:</th><td><input type='text' name='job_title'  id='job_title' value='[temp_job_title ? temp_job_title : "Custom Job"]'></td></tr>
		<tr><th>Tutorial:</th><td><textarea name='job_tutorial' id='job_tutorial' style='width:400px'>[temp_job_tutorial ? temp_job_tutorial : "Describe the job here..."]</textarea></td></tr>
		<tr><th>Faction:</th><td>
			<select name='job_faction' id='job_faction'>
				[generate_options(factions_list, temp_faction)]
			</select>
		</td></tr>
		<tr><th>Outfit:</th><td>
			<select name='job_outfit' id='job_outfit'>
				[generate_options(outfits_list, temp_outfit)]
			</select>
		</td></tr>
		<tr><th>Custom Combat Music</th><td>
			<select name='job_custom_music' id='job_custom_music' onchange='
				document.getElementById("music_row").style.display = (this.value == "1") ? "table-row" : "none";
			'>
				[generate_boolean_option(FALSE, temp_custom_combat_song_bool)]
			</select>
			<br>
		</td></tr>
		<tr id='music_row' style='display:[temp_custom_combat_song_bool ? "block" : "none"];'>
			<th>Music Path (Example: sound/music/cmode/church/CombatInquisitor.ogg)</th>
			<td><input id='music_path' type='text' name='job_song' id='job_song' value='[temp_custom_combat_song ? temp_custom_combat_song : "Write here"]'></td>
		</tr>
		<tr><th>Antag</th><td>
			<select name='job_enabled_antag' id='job_enabled_antag' onchange='
				document.getElementById("antag_options").style.display = (this.value == "1") ? "block" : "none";
			'>
				[generate_boolean_option(FALSE, temp_antag_bool)]
			</select>
			<br>
			<div id='antag_options'  style='display:[temp_antag_bool ? "block" : "none"];'>
				<select id='job_antag' name='job_antag'>
					[generate_options(antag_list, temp_antag)]
				</select>
			</div>
		</td></tr>
		<tr><th>Foreigner</th><td>
			<select name='job_foreigner' id='job_foreigner' onchange='
				document.getElementById("recognized_row").style.display = (this.value == "1") ? "table-row" : "none";
			'>
				[generate_boolean_option(FALSE, temp_foreigner_bool)]
			</select>
		</td></tr>
		<tr id='recognized_row' style='display:[temp_recognized_bool ? "block" : "none"];'><th>Recognized</th><td>
			<select id='job_recognized' name='job_recognized'>
				[generate_boolean_option(FALSE, temp_recognized_bool)]
			</select>
		</td></tr>
		<tr ><th>Magick User</th><td>
			<select name='job_magick_user' id='job_magick_user'>
				[generate_boolean_option(FALSE, temp_magick_user_bool)]
			</select>
		</td></tr>
		<tr><th>Allowed Sexes (Leave everything unchecked to allow all sexes):</th><td>
			[generate_checkboxes(sexes_list,"job_allowed_sexes",temp_allowed_sexes)]
		</td></tr>
		<tr><th>Allowed Races (Leave everything unchecked to allow all races):</th><td>
			[generate_checkboxes(races_list,"job_allowed_races", temp_allowed_races)]
		</td></tr>
		<tr><th>Allowed Ages (Leave everything unchecked to allow all besides youngling):</th><td>
			[generate_checkboxes(ages_list,"job_allowed_ages", temp_allowed_ages)]
		</td></tr>
		<br>
		<tr><th>Languages:</th><td>
			[generate_checkboxes(languages_list,"job_languages", temp_languages)]
		</td></tr>
		<tr><th>Patrons (Leave everything unchecked to allow all patrons):</th><td>
			[generate_checkboxes(patrons_list,"job_allowed_patrons", temp_patrons )]
		</td></tr>
		<tr><th>Skills:</th>
		<td>
			<select id='skills_dropdown'>
				[skills_options]
			</select>

			<input type='number' id='skills_level' value='0' style='width:50px'>
	"}
	if(length(pending_skills))
		dat += "<h4>Added Skills:</h4><ul>"
		for(var/skill_path in pending_skills)
			var/level = pending_skills[skill_path]
			var/datum/skill/S = new skill_path
			dat += "<li>[S.name] (Level [level]) <button type='button' onclick='removeSkill(\"[skill_path]\")'>Remove</button></li>"
			qdel(S)

		dat += "</ul>"
	else
		dat += "<i>No skills added yet.</i>"
	dat += "<button type='button' onclick='addSkill()'>Add Skill</button>"
	dat+= "</td></tr>"
	dat += {"
	<tr><th>Traits:</th>
	<td>
		<select id='traits_dropdown'>
			[trait_options]
		</select>
	"}
	if(length(pending_traits))
		dat += "<br><h4>Added Traits:</h4><ul>"
		for(var/trait in pending_traits)
			dat += "<li>[trait] <button type='button' onclick='removeTrait(\"[trait]\")'>Remove</button></li>"
		dat += "</ul>"
	else
		dat += "<i>No traits added yet.</i>"
	dat += "<button type='button' onclick='addTrait()'>Add Trait</button>"
	dat+= "</td></tr>"
	dat += {"
		<tr><th>Stats:</th>
		<td>
			<select id='stats_dropdown'>
				[stat_options]
			</select>
			<input type='number' id='stats_level' value='0' style='width:50px'>
	"}
	if(length(pending_stats))
		dat += "<h4>Stats Modifiers:</h4><ul>"
		for(var/stats in pending_stats)
			var/modifier = pending_stats[stats]
			dat += "<li>[stats] Modifier: [modifier] <button type='button' onclick='removeStat(\"[stats]\")'>Remove</button></li>"

		dat += "</ul>"
	else
		dat += "<i>No Stats Modifiers added yet.</i>"
	dat += "<button type='button' onclick='addStat()'>Add Stat</button>"

	dat+= "</td></tr>"
	dat += {"
	</table>
	<br><input type='submit' value='Save'>
	</form></body></html>
	"}


	var/datum/browser/popup = new(admin, "customjob_create", "Create Custom Job", 600, 700, src)
	popup.set_content(dat)
	popup.open(TRUE)


// Finalize job creation from HTML form


/datum/create_wave/proc/create_job_finalize(mob/admin, list/href_list)
	var/datum/job/custom_job/J = new

	J.title = href_list["job_title"]
	J.tutorial = href_list["job_tutorial"]
	J.faction = href_list["job_faction"]


	var/antag_enabled = text2num(href_list["job_enabled_antag"])
	var/custom_song_enabled = text2num(href_list["job_custom_music"])
	var/recognized = text2num(href_list["job_recognized"])
	var/foreigner = text2num(href_list["job_foreigner"])
	var/magick_user = text2num(href_list["job_magick_user"])

	if(antag_enabled == 1)
		J.antag_role = text2path(href_list["job_antag"])
	if(custom_song_enabled ==1)
		J.cmode_music = href_list["job_song"]
	if(recognized == 1)
		J.is_recognized = TRUE
	if(foreigner == 1)
		J.is_foreigner = TRUE
	if(magick_user == 1)
		J.magic_user = TRUE

	J.outfit = href_list["job_outfit"]

	var/sexes = href_list["job_allowed_sexes"]
	if(sexes)
		J.allowed_sexes = list()
		if(!istype(sexes, /list))
			sexes = list(sexes)
		for(var/sex in sexes)
			J.allowed_sexes += sex

	var/races = href_list["job_allowed_races"]
	if(races)
		J.allowed_races = list()
		if(!istype(races, /list))
			races = list(races)
		for(var/r in races)
			J.allowed_races += r


	var/ages = href_list["job_allowed_ages"]
	if(ages)
		J.allowed_ages = list()
		if(!istype(ages, /list))
			ages = list(ages)
		for(var/a in ages)
			J.allowed_ages += a

	J.languages = list()
	var/languages = href_list["job_languages"]
	if(languages)
		if(!istype(languages, /list))
			languages = list(languages)
		for(var/L in languages)
			J.languages += L

	J.allowed_patrons = list()
	var/patrons = href_list["job_allowed_patrons"]
	if(patrons)
		if(!istype(patrons, /list))
			patrons = list(patrons)
		for(var/P in patrons)
			J.allowed_patrons += text2path(P)


	J.skills = list()
	if(pending_skills)
		J.skills = pending_skills.Copy()

	J.traits = list()
	if(pending_traits)
		J.traits = pending_traits.Copy()

	J.jobstats = list()
	if(pending_stats)
		J.jobstats = pending_stats.Copy()

	J.id = "[J.title]_[world.time]"

	pending_skills = list()
	pending_traits = list()
	pending_stats = list()
	temp_job_title = null
	temp_job_tutorial = null
	temp_faction = null
	temp_outfit = null
	temp_antag = null
	temp_allowed_sexes = null
	temp_allowed_races = null
	temp_allowed_ages = null
	temp_languages = null
	temp_patrons = null
	temp_custom_combat_song = null
	temp_custom_combat_song_bool = null
	temp_antag_bool = null
	temp_foreigner_bool = null
	temp_recognized_bool = null
	temp_custom_combat_song_bool = null
	temp_magick_user_bool = null

	GLOB.custom_jobs[J.id] = J


	message_admins("[key_name(usr)] created custom job: '[J.title]' with the id of [J.id]")
	custom_job_manager(admin)

/datum/create_wave/proc/edit_job(mob/admin, datum/job/custom_job/J)
	if(!J)
		return

    // Generate HTML form
	var/dat = {"
	<html><head><title>Edit Custom Wave</title></head><body>
	<form name='wave' action='byond://?src=[REF(src)];[HrefToken()]' method='get'>
	<input type='hidden' name='src' value='[REF(src)]'>
	[HrefTokenFormField()]
	<input type='hidden' name='edit_wave_finalize' value='1'>
	<input type="hidden" id='chosen_job_edit' name='chosen_job_edit' value="[J.id]">
	<table>
		<tr><th>Title:</th>
		<td>
			<input type='text' id='job_title' value='[J.title]'
				oninput='
					var new_title = this.value;
					window.location.href = "?src=[REF(src)];[HrefToken()];update_job_title=1;chosen_job_edit=[J.id];new_title=" + encodeURIComponent(new_title);
				'>
		</td></tr>
		<tr>
			<th>Tutorial:</th>
			<td>
				<textarea id='job_tutorial' style='width:400px'
					oninput='
						var new_tutorial = this.value;
						window.location.href = "?src=[REF(src)];[HrefToken()];update_job_tutorial=1;chosen_job_edit=[J.id];new_tutorial=" + encodeURIComponent(new_tutorial);
					'>[J.tutorial]</textarea>
			</td>
		</tr>
		<tr><th>Faction:</th>
		<td>
			<select id='job_faction' onchange='
				var new_faction = this.value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];update_job_faction=1;chosen_job_edit=[J.id];new_faction=\" + encodeURIComponent(new_faction);
			'>
				[generate_options(factions_list, J.faction)]
			</select>
		</td></tr>
		<tr><th>Outfit:</th>
		<td>
			<select id='job_outfit' onchange='
				var new_outfit = this.value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];update_job_outfit=1;chosen_job_edit=[J.id];new_outfit=\" + encodeURIComponent(new_outfit);
			'>
				[generate_options(outfits_list, J.outfit)]
			</select>
		</td></tr>
		<tr>
			<th>Combat Song:</th>
			<td>
				<input type='text' id='job_combat_song' value='[J.cmode_music]'
					oninput='
						var new_song = this.value;
						window.location.href = "?src=[REF(src)];[HrefToken()];update_job_song=1;chosen_job_edit=[J.id];new_song=" + encodeURIComponent(new_song);
					'>
			</td>
		</tr>
		<tr><th>Antagonist:</th>
		<td>
			<select id='job_antag' onchange='
				var new_faction = this.value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];update_job_antag=1;chosen_job_edit=[J.id];new_antag=\" + encodeURIComponent(new_faction);
			'>
				[generate_options(antag_list, J.antag_role)]
			</select>
		</td></tr>
		<tr><th>Foreigner:</th>
		<td>
			<select id='job_foreigner' onchange='
				var new_value = this.value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];update_job_foreigner=1;chosen_job_edit=[J.id];new_foreigner=\" + encodeURIComponent(new_value);
			'>
				[generate_boolean_option(FALSE, J.is_foreigner)]
			</select>
		</td></tr>
		<tr><th>Recognized:</th>
		<td>
			<select id='job_recognized' onchange='
				var new_value = this.value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];update_job_recognized=1;chosen_job_edit=[J.id];new_recognized=\" + encodeURIComponent(new_value);
			'>
				[generate_boolean_option(FALSE, J.is_recognized)]
			</select>
		</td></tr>
		<tr><th>Magick User:</th>
		<td>
			<select id='job_magick_user' onchange='
				var new_value = this.value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];update_job_magick_user=1;chosen_job_edit=[J.id];new_magick_user=\" + encodeURIComponent(new_value);
			'>
				[generate_boolean_option(FALSE, J.magic_user)]
			</select>
		</td></tr>
	"}
	dat += {"
	<tr><th>Allowed Sexes:</th>
	<td>
		[generate_checkboxes(sexes_list, "job_allowed_sexes", J.allowed_sexes)]
		<script>
			document.querySelectorAll(\"input\[name=job_allowed_sexes\]\").forEach(function(cb) {
				cb.addEventListener(\"change\", function() {
					var selected = \[\];
					document.querySelectorAll(\"input\[name=job_allowed_sexes\]:checked\").forEach(function(cb) {
						selected.push(cb.value);
					});
					window.location.href = \"?src=[REF(src)];[HrefToken()];update_job_allowed_sexes=1;chosen_job_edit=[J.id];new_allowed_sexes=\" + encodeURIComponent(selected.join(\",\"));
				});
			});
		</script>
	</td></tr>
	<tr><th>Races:</th>
	<td>
		[generate_checkboxes(races_list, "job_allowed_races", J.allowed_races)]
		<script>
			document.querySelectorAll(\"input\[name=job_allowed_races\]\").forEach(function(cb) {
				cb.addEventListener(\"change\", function() {
					var selected = \[\];
					document.querySelectorAll(\"input\[name=job_allowed_races\]:checked\").forEach(function(cb) {
						selected.push(cb.value);
					});
					window.location.href = \"?src=[REF(src)];[HrefToken()];update_job_race=1;chosen_job_edit=[J.id];new_races=\" + encodeURIComponent(selected.join(\",\"));
				});
			});
		</script>
	</td></tr>
	<tr><th>Ages:</th>
	<td>
		[generate_checkboxes(ages_list, "job_allowed_ages", J.allowed_ages)]
		<script>
			document.querySelectorAll(\"input\[name=job_allowed_ages\]\").forEach(function(cb) {
				cb.addEventListener(\"change\", function() {
					var selected = \[\];
					document.querySelectorAll(\"input\[name=job_allowed_ages\]:checked\").forEach(function(cb) {
						selected.push(cb.value);
					});
					window.location.href = \"?src=[REF(src)];[HrefToken()];update_job_age=1;chosen_job_edit=[J.id];new_ages=\" + encodeURIComponent(selected.join(\",\"));
				});
			});
		</script>
	</td></tr>
	<tr><th>Languages:</th>
	<td>
		[generate_checkboxes(languages_list, "job_languages", J.languages)]
		<script>
			document.querySelectorAll(\"input\[name=job_languages\]\").forEach(function(cb) {
				cb.addEventListener(\"change\", function() {
					var selected = \[\];
					document.querySelectorAll(\"input\[name=job_languages\]:checked\").forEach(function(cb) {
						selected.push(cb.value);
					});
					window.location.href = \"?src=[REF(src)];[HrefToken()];update_job_languages=1;chosen_job_edit=[J.id];new_languages=\" + encodeURIComponent(selected.join(\",\"));
				});
			});
		</script>
	</td></tr>
	<tr><th>Patrons(0 patrons checked means all patrons are allowed):</th>
	<td>
		[generate_checkboxes(patrons_list, "job_allowed_patrons", J.allowed_patrons)]
		<script>
			document.querySelectorAll(\"input\[name=job_allowed_patrons\]\").forEach(function(cb) {
				cb.addEventListener(\"change\", function() {
					var selected = \[\];
					document.querySelectorAll(\"input\[name=job_allowed_patrons\]:checked\").forEach(function(cb) {
						selected.push(cb.value);
					});
					window.location.href = \"?src=[REF(src)];[HrefToken()];update_job_patron=1;chosen_job_edit=[J.id];new_patrons=\" + encodeURIComponent(selected.join(\",\"));
				});
			});
		</script>
	</td></tr>
	"}
	dat+= "</td></tr>"
	dat += {"
		<tr><th>Skills:</th>
		<td>
			<select id='skills_dropdown'>
				[skills_options]
			</select>
			<input type='number' id='skills_level' value='0' style='width:50px'>
	"}
	if(length(J.skills))
		dat += "<h4>Added Skills:</h4><ul>"
		for(var/skill_path in J.skills)
			var/level = J.skills[skill_path]
			var/datum/skill/S = new skill_path
			dat += "<li>[S.name] (Level [level])"
			qdel(S)
			dat += {"<button type='button' onclick='
				var chosen_job_edit = document.getElementById(\"chosen_job_edit\").value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];remove_skill=1;skill=" + encodeURIComponent(\"[skill_path]\") +
					\";chosen_job_edit=\" + encodeURIComponent(chosen_job_edit);' '>
				Remove</button></li>
			"}
		dat += "</ul>"
	else
		dat += "<i>No skills added yet.</i>"
	dat += {"
	<button type='button' onclick='
		var skill = document.getElementById(\"skills_dropdown\").value;
		var level = document.getElementById(\"skills_level\").value;
		var chosen_job_edit = document.getElementById(\"chosen_job_edit\").value;

		window.location.href = \"?src=[REF(src)];[HrefToken()];add_skill=1;\" +
			\";skill=\" + encodeURIComponent(skill) +
			\";level=\" + encodeURIComponent(level) +
			\";chosen_job_edit=\" + encodeURIComponent(chosen_job_edit);' '>
		Add Skill</button>
	"}
	dat+= "</td></tr>"
	dat+= "</td></tr>"
	dat += {"
		<tr><th>Traits:</th>
		<td>
			<select id='traits_dropdown'>
				[trait_options]
			</select>
	"}
	if(length(J.traits))
		dat+= "<br>"
		dat += "<h4>Added Traits:</h4><ul>"
		for(var/trait in J.traits)
			dat += "<li>[trait] "
			dat += {"<button type='button' onclick='
				var chosen_job_edit = document.getElementById(\"chosen_job_edit\").value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];remove_trait=1;trait=" + encodeURIComponent(\"[trait]\") +
					\";chosen_job_edit=\" + encodeURIComponent(chosen_job_edit);' '>

				Remove</button></li>
			"}
		dat += "</ul>"
	else
		dat += "<i>No traits added yet.</i>"
	dat += {"
	<button type='button' onclick='
		var trait = document.getElementById(\"traits_dropdown\").value;
		var chosen_job_edit = document.getElementById(\"chosen_job_edit\").value;

		window.location.href = \"?src=[REF(src)];[HrefToken()];add_trait=1;\" +
			\";trait=\" + encodeURIComponent(trait) +
			\";chosen_job_edit=\" + encodeURIComponent(chosen_job_edit);' '>

		Add Trait</button>
	"}
	dat+= "</td></tr>"
	dat += {"
		<tr><th>Stats:</th>
		<td>
			<select id='stats_dropdown'>
				[stat_options]
			</select>
			<input type='number' id='stats_level' value='0' style='width:50px'>
	"}
	if(length(J.jobstats))
		dat += "<h4>Stats Modifiers:</h4><ul>"
		for(var/stats in J.jobstats)
			var/modifier = J.jobstats[stats]
			dat += "<li>[stats] Modifier: [modifier]"
			dat += {"<button type='button' onclick='
				var chosen_job_edit = document.getElementById(\"chosen_job_edit\").value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];remove_stat=1;stats=" + encodeURIComponent(\"[stats]\") +
					\";chosen_job_edit=\" + encodeURIComponent(chosen_job_edit);' '>
				Remove</button></li>
			"}
		dat += "</ul>"
	else
		dat += "<i>No Stats Modifiers added yet.</i>"
	dat += {"
	<button type='button' onclick='
		var stat = document.getElementById("stats_dropdown").value;
		var modifier = document.getElementById("stats_level").value;
		var chosen_job_edit = document.getElementById(\"chosen_job_edit\").value;
		window.location.href = \"?src=[REF(src)];[HrefToken()];add_stat=1;\" +
			\";stat=\" + encodeURIComponent(stat) +
			\";modifier=\" + encodeURIComponent(modifier) +
			\";chosen_job_edit=\" + encodeURIComponent(chosen_job_edit);' '>
		Add Stat</button>
	"}
	dat+= "</td></tr>"
	dat += "</td></tr>"
	dat += "</table>"
	dat += "</form></body></html>"

	var/datum/browser/popup = new(admin, "customwave_edit", "Edit Custom Job", 600, 700, src)
	popup.set_content(dat)
	popup.open(FALSE)



/datum/job/custom_job/proc/export_to_file(mob/admin)
	var/stored_data = get_json_data()
	var/json = json_encode(stored_data)
	var/f = file("data/TempJobExport")
	fdel(f)
	WRITE_FILE(f,json)
	admin << ftp(f,"[title].json")

/datum/create_wave/proc/load_job(mob/admin)
	// Ask admin to select a file
	var/job_file = input("Pick job JSON file:", "File") as null|file
	if(!job_file)
		return

	// Read JSON contents
	var/filedata = file2text(job_file)
	var/json = json_decode(filedata)
	if(!json)
		to_chat(admin, span_warning("JSON decode error."))
		return

	var/j_type = text2path(json["job_type"])
	if(!ispath(j_type,/datum/job/custom_job))
		to_chat(admin, span_warning("Malformed/Outdated file, the files does not have a job type."))
		return
	// Ensure this is a single JSON object
	if(!islist(json))
		to_chat(admin, span_warning("Invalid file format (expected a single JSON job object)."))
		return

	// Create the job
	var/datum/job/custom_job/J = new

	// Let loader handle the fields
	if(!J.load_from_json(json, admin))
		to_chat(admin, span_warning("Malformed/Outdated file, failed to load from json."))
		return

	// Add it to the global job list
	GLOB.custom_jobs[J.id] = J

	message_admins("[key_name(admin)] loaded a custom job! Name: \"[J.title]\"")
	to_chat(admin, span_notice("Successfully loaded job '[J.title]'."))

/datum/create_wave/proc/create_wave(mob/admin)

    // Generate HTML form
	var/dat = {"
	<html><head><title>Create Custom Wave</title></head><body>
	<form name='wave' action='byond://?src=[REF(src)];[HrefToken()]' method='get'>
	<input type='hidden' name='src' value='[REF(src)]'>
	[HrefTokenFormField()]
	<input type='hidden' name='create_wave_finalize' value='1'>
	<table>
		<tr><th>Name:</th><td><input type='text' name='wave_title'  id='wave_t' value='[temp_wave_title ? temp_wave_title : "Custom Wave"]'></td></tr>
		<tr><th>Greeting Text:</th><td><textarea name='wave_greeting_text' id='wave_g' style='width:400px'>[temp_wave_greeting_text ? temp_wave_greeting_text : "Wave Tutorial here..."]</textarea></td></tr>
		<tr><th>Minimum Of Candidates:</th><td><input type='number' id='wave_mc'name='wave_min_pop' style='width:40px' value='[temp_min_pop ? temp_min_pop : "1"]'></td></tr>
		"}
	dat+= "</td></tr>"
	dat += {"
		<tr><th>Jobs:</th>
		<td>
			<select id='jobs_dropdown'>
				[potential_custom_jobs_options + potential_jobs_options]
			</select>
	"}
	if(length(pending_jobs))
		dat += "<br><h4>Added Jobs:</h4><ul>"
		for(var/job in pending_jobs)
			var/slots = pending_jobs[job]
			dat += "<li>[job] ([slots] slots) "
			dat += {"<button type='button' onclick='
				var name = document.getElementById(\"wave_t\").value;
				var name_g = document.getElementById(\"wave_g\").value;
				var name_mc = document.getElementById(\"wave_mc\").value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];remove_job=1;job=" + encodeURIComponent(\"[job]\") +
					\";name=\" + encodeURIComponent(name) +
					\";name_g=\" + encodeURIComponent(name_g) +
					\";name_mc=\" + encodeURIComponent(name_mc);
			'>Remove</button></li>
			"}

		dat += "</ul>"
	else
		dat += "<i>No jobs added yet.</i>"
	dat += "Slots: <input type='number' id='job_slots' value='1' min='1' style='width:50px;'> "
	dat+= {"
			<button type='button' onclick='
				var job = document.getElementById("jobs_dropdown").value;
				var slots=document.getElementById("job_slots").value;
				var name = document.getElementById("wave_t").value;
				var name_g = document.getElementById("wave_g").value;
				var name_mc = document.getElementById("wave_mc").value;
				window.location.href = "?src=[REF(src)];[HrefToken()];add_jobs=1;job=" + encodeURIComponent(job) + ";name=" + encodeURIComponent(name) + ";name_g=" + encodeURIComponent(name_g) + ";name_mc=" + encodeURIComponent(name_mc) + ";slots=" + encodeURIComponent(slots);
			'>Add Job</button>
	"}
	dat+= "</td></tr>"
	dat += {"
	</table>
	<br><input type='submit' value='Save'>
	</form></body></html>
	"}
	var/datum/browser/popup = new(admin, "customwave_create", "Create Wave Job", 600, 700, src)
	popup.set_content(dat)
	popup.open(FALSE)



// View Wave
/datum/create_wave/proc/view_wave(mob/admin, datum/custom_wave/CW)
	if(!CW)
		return

	var/list/dat = list("<html><body>")
	dat += "<h2>Wave Preview: [CW.name]</h2>"
	dat += "<b>Tutorial</b><br><pre style='white-space:pre-wrap;'>[CW.greeting_text]</pre>"
	dat += "<h3>Jobs:</h3><ul>"
	if(length(CW.wave_jobs))
		for (var/job in CW.wave_jobs)
			var/datum/job/J
			if(ispath(text2path(job), /datum/job))
				J = new job
			else
				J = GLOB.custom_jobs[job]
			var/slots = CW.wave_jobs[job]
			dat += "<li>[J.title] ([slots] slots)</li>"
		dat += "</ul>"
	else
		dat += "<li><i>No jobs added.</i></li>"
	dat += "</ul>"
	dat += "<h3>Minimum Of Candidates: [CW.min_pop]</h3><ul>"
	dat += "</ul>"
	dat += "<h3>Maximum Candidates: [CW.max_pop]</h3><ul>"
	dat += "</ul>"
	dat += "</body></html>"

	var/datum/browser/popup = new(admin, "customwave_view", "Custom Wave Preview", 600, 520, src)
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/create_wave/proc/create_wave_finalize(mob/admin, list/href_list)
	var/datum/custom_wave/CW = new

	CW.name = href_list["wave_title"]
	CW.greeting_text = href_list["wave_greeting_text"]
	CW.min_pop = text2num(href_list["wave_min_pop"])

	CW.wave_jobs = list()
	if(pending_jobs)
		CW.wave_jobs = pending_jobs.Copy()

	for(var/job in CW.wave_jobs)
		var/slots = CW.wave_jobs[job]
		if(slots)
			CW.max_pop += text2num(slots)


	pending_jobs = list()
	temp_wave_title = null
	temp_wave_greeting_text = null
	temp_min_pop = null
	GLOB.custom_waves += CW
	message_admins("[key_name(usr)] created custom job: '[CW.name]'")
	custom_wave_manager(admin)


// Delete a Wave
/datum/create_wave/proc/delete_wave(mob/admin, datum/custom_wave/CW)
	if(!CW)
		return
	GLOB.custom_waves -= CW
	to_chat(admin, span_notice("The custom wave [CW.name] was deleted."))
	message_admins("[key_name(usr)] deleted custom wave: '[CW.name]'")
	custom_wave_manager(admin)

/datum/create_wave/proc/edit_wave(mob/admin, datum/custom_wave/CW)
	if(!CW)
		return

	if(CW.spawn_landmark)
		to_chat(admin, span_warning("You can't edit the wave while it is deploying!"))
		return

    // Generate HTML form (mostly like create_wave)
	var/dat = {"
	<html><head><title>Edit Custom Wave</title></head><body>
	<form name='wave' action='byond://?src=[REF(src)];[HrefToken()]' method='get'>
	<input type='hidden' name='src' value='[REF(src)]'>
	[HrefTokenFormField()]
	<input type='hidden' name='edit_wave_finalize' value='1'>
	<input type="hidden" id='wave_ref' name='wave_ref' value="[REF(CW)]">
	<table>
		<tr><th>Name:</th>
		<td>
			<input type='text' id='wave_t' value='[CW.name]'
				oninput='
					var new_name = this.value;
					window.location.href = "?src=[REF(src)];[HrefToken()];update_wave_name=1;wave_ref=[REF(CW)];new_name=" + encodeURIComponent(new_name);
				'>
		</td></tr>
		<tr>
			<th>Greeting Text:</th>
			<td>
				<textarea id='wave_g' style='width:400px'
					oninput='
						var new_g = this.value;
						window.location.href = "?src=[REF(src)];[HrefToken()];update_wave_greeting=1;wave_ref=[REF(CW)];new_g=" + encodeURIComponent(new_g);
					'>[CW.greeting_text]</textarea>
			</td>
		</tr>
		<tr>
			<th>Minimum Of Candidates:</th>
			<td>
				<input type='number' id='wave_mc' style='width:40px' value='[CW.min_pop]'
					oninput='
						var new_mc = this.value;
						window.location.href = "?src=[REF(src)];[HrefToken()];update_wave_min_pop=1;wave_ref=[REF(CW)];new_mc=" + encodeURIComponent(new_mc);
					'>
			</td>
		</tr>
	"}
	dat+= "</td></tr>"

	dat += {"
		<tr><th>Jobs:</th>
		<td>
			<select id='jobs_dropdown'>
				[potential_custom_jobs_options + potential_jobs_options]
			</select>
	"}
	// Existing jobs
	if(length(CW.wave_jobs))
		dat += "<br><h4>Added Jobs:</h4><ul>"
		for(var/job in CW.wave_jobs)
			var/slots = CW.wave_jobs[job]
			dat += "<li>[job] ([slots] slots) "
			dat += {"<button type='button' onclick='
				var name = document.getElementById(\"wave_t\").value;
				var name_g = document.getElementById(\"wave_g\").value;
				var name_mc = document.getElementById(\"wave_mc\").value;
				var wave_ref = document.getElementById(\"wave_ref\").value;
				window.location.href = \"?src=[REF(src)];[HrefToken()];remove_job=1;job=" + encodeURIComponent(\"[job]\") +
					\";name=\" + encodeURIComponent(name) +
					\";name_g=\" + encodeURIComponent(name_g) +
					\";wave_ref=\" + encodeURIComponent(wave_ref) +
					\";name_mc=\" + encodeURIComponent(name_mc);
				'>Remove</button></li>
			"}
		dat += "</ul>"
	else
		dat += "<i>No jobs added yet.</i>"

	// Add job input
	dat += "Slots: <input type='number' id='job_slots' value='1' min='1' style='width:50px;'> "
	dat += {"<button type='button' onclick='
		var job = document.getElementById(\"jobs_dropdown\").value;
		var slots = document.getElementById(\"job_slots\").value;
		var name = document.getElementById(\"wave_t\").value;
		var name_g = document.getElementById(\"wave_g\").value;
		var name_mc = document.getElementById(\"wave_mc\").value;
		var wave_ref = document.getElementById(\"wave_ref\").value;
		window.location.href = \"?src=[REF(src)];[HrefToken()];add_jobs=1;job=\" + encodeURIComponent(job) +
			\";name=\" + encodeURIComponent(name) +
			\";name_g=\" + encodeURIComponent(name_g) +
			\";wave_ref=\" + encodeURIComponent(wave_ref) +
			\";name_mc=\" + encodeURIComponent(name_mc) +
			\";slots=\" + encodeURIComponent(slots);
		'>Add Job</button>
	"}

	dat += "</td></tr>"
	dat += "</table>"
	dat += "</form></body></html>"

	var/datum/browser/popup = new(admin, "customwave_edit", "Edit Custom Wave", 600, 700, src)
	popup.set_content(dat)
	popup.open(FALSE)


/datum/create_wave/proc/start_wave(mob/admin, datum/custom_wave/CW)
	if(!CW)
		return

	if(!length(CW.wave_jobs))
		to_chat(admin, span_warning("You can't start a wave that has no jobs!"))
		return

	if(CW.spawn_landmark)
		to_chat(admin, span_warning("The wave already started!"))
		return

	CW.candidates = list()
	CW.spawn_landmark = admin.loc


	// Prepare the list of jobs for the popup
	var/job_list_html = "<ul>"
	for (var/job in CW.wave_jobs)
		var/slots = CW.wave_jobs[job]
		var/datum/job/J

		if(ispath(text2path(job), /datum/job))
			J = new job
		else
			J = GLOB.custom_jobs[job]

		if(J)
			job_list_html += "<li>[J.title] ([slots])</li>"
		else
			job_list_html += "<li>[J.title] ([slots])</li>"

	job_list_html += "</ul>"


	for(var/client/C in GLOB.clients)
		if(!C)
			continue
		var/mob/dead_mob = C.mob
		if(!dead_mob || !isdead(dead_mob))
			continue

		// Send ghost/lobby popup
		var/datum/browser/popup = new(dead_mob, "wave_call", "Join Custom Wave", 400, 300)
		var/list/dat = list("<html><body>")
		dat += "<center><b>An admin is forming a custom wave named: [CW.name].</b><br>Join it?</b><br><br>"
		dat += "<b>Available roles in this wave:</b>" + job_list_html + "<br>"
		dat += "<a href='byond://?src=[REF(src)];join_wave=1;chosen_wave=[REF(CW)];popup=[REF(popup)]'>Join</a> "
		dat += "<a href='byond://?src=[REF(src)];decline_wave=1;popup=[REF(popup)]'>Decline</a>"
		dat += "</body></html>"

		popup.set_content(dat.Join())
		popup.open(FALSE)

	to_chat(admin, span_notice("Wave call sent to ghosts and players at the lobby."))
	message_admins("The [CW.name] was started by [ADMIN_FLW(admin)] [key_name_admin(admin)]  at [admin.loc] and it is going to finalize the deployment in 60 seconds.")

	CW.timer = addtimer(CALLBACK(src, PROC_REF(finalize_wave), admin, CW), 60 SECONDS)


/datum/create_wave/proc/finalize_wave(mob/admin, datum/custom_wave/CW)
	if(!CW)
		return

	if(!length(CW.candidates))
		message_admins("No one accepted the call for the [CW.name] wave.")
		CW.candidates = list()
		CW.spawn_landmark = null
		return

	if(length(CW.candidates) < CW.min_pop)
		message_admins("Only [length(CW.candidates)] player(s) accepted the [CW.name] wave call. Minimum required: [CW.min_pop]")
		for(var/client/C in CW.candidates)
			if(!C || !C.mob || !isdead(C.mob))
				continue
				to_chat(C, span_notice("The amount of player(s) didn't reach the minimum amount needed to deploy the wave."))
		CW.candidates = list()
		CW.spawn_landmark = null
		return

	message_admins("Deploying [length(CW.candidates)] participants from the [CW.name] wave.")

	var/list/job_order = CW.wave_jobs.Copy() // keep order and slot counts

	// Track how many slots remain for each job
	var/list/remaining_slots = list()
	for (var/job in job_order)
		remaining_slots[job] = CW.wave_jobs[job]

	for(var/client/C in CW.candidates)
		if(!C || !C.mob || !isdead(C.mob))
			continue

		var/mob/dead/dead_mob = C.mob
		if(!dead_mob)
			continue

		var/spawn_loc = CW.spawn_landmark

		var/datum/preferences/prefs = C.prefs
		var/datum/job/assigned_job

		// Try to find the next available job in order
		for(var/job_key in job_order)
			if(remaining_slots[job_key] <= 0)
				continue // No more slots for this job
			var/datum/job/job_check
			if(ispath(text2path(job_key), /datum/job))
				job_check = new job_key
			else
				job_check = GLOB.custom_jobs[job_key]

			if(!job_check)
				continue

			if(is_role_banned(C.ckey, job_check.title))
				continue

			if(job_check.banned_leprosy && is_misc_banned(C.ckey, BAN_MISC_LEPROSY))
				continue

			if(job_check.banned_lunatic && is_misc_banned(C.ckey, BAN_MISC_LUNATIC))
				continue

			if(!job_check.prefs_species_check(prefs))
				continue

			if(length(job_check.allowed_sexes) && !(prefs.gender in job_check.allowed_sexes))
				continue

			if(length(job_check.allowed_ages) && !(prefs.age in job_check.allowed_ages))
				continue

			// Valid assign this job
			assigned_job = job_check
			remaining_slots[job_key]--
			break

		if(!assigned_job)
			to_chat(C, span_notice("You didn't manage to join the wave..."))
			continue

		var/mob/living/character = dead_mob.create_character(spawn_loc)
		if(!character)
			CRASH("Failed to create a character for the custom wave.")

		character.islatejoin = TRUE
		dead_mob.transfer_character()
		character.purge_combat_knowledge()

		// Equip and finalize
		SSjob.EquipRank(character, assigned_job, character.client)
		apply_loadouts(character, character.client)
		SSticker.minds += character.mind

		GLOB.joined_player_list += character.ckey
		GLOB.respawncounts[character.ckey] += 1

		var/datum/antagonist/antag_role = assigned_job?.antag_role
		if(antag_role)
			character.mind.add_antag_datum(antag_role)


		var/mob/living/carbon/human/human_character = character
		var/fakekey = get_display_ckey(human_character.ckey)
		GLOB.character_list[human_character.mobid] = "[fakekey] was [human_character.real_name] ([assigned_job.title])<BR>"
		GLOB.character_ckey_list[human_character.real_name] = human_character.ckey
		log_character("[human_character.ckey] ([fakekey]) - [human_character.real_name] - [assigned_job.title]")
		to_chat(character, span_notice("You are part of the [CW.name]."))
		to_chat(character, span_notice("*-----------------*"))
		to_chat(character, span_notice("[CW.greeting_text]"))

	message_admins("The [CW.name] was deployed successfully with [length(CW.candidates)] participants!")

	if(CW.timer)
		//deltimer(CW.timer)
		CW.timer = null
	CW.spawn_landmark = null
	CW.candidates = list()

/datum/custom_wave/proc/can_be_roles(client/player)
	if(!player || !player.prefs)
		return FALSE

	if(is_race_banned(player.ckey, player.prefs.pref_species.id))
		return FALSE

	var/datum/preferences/prefs = player.prefs

	var/can_join_any = FALSE
	var/list/failed_reasons = list()

	for(var/job in wave_jobs)
		var/datum/job/job_check
		if(ispath(text2path(job), /datum/job))
			job_check = new job
		else
			job_check = GLOB.custom_jobs[job]
		var/list/job_fail = list()

		// Check role bans
		if(is_role_banned(player.ckey, job_check.title))
			job_fail += "You are banned from this role"

		if(job_check.banned_leprosy && is_misc_banned(player.ckey, BAN_MISC_LEPROSY))
			job_fail += "Leprosy restriction"

		if(job_check.banned_lunatic && is_misc_banned(player.ckey, BAN_MISC_LUNATIC))
			job_fail += "Lunatic restriction"

		// Check allowed races
		var/player_species_id_job = prefs.pref_species.id_override ? prefs.pref_species.id_override : prefs.pref_species.id
		if(length(job_check.allowed_races) && !(player_species_id_job in job_check.allowed_races))
			job_fail += "Wrong species (allowed: [job_check.allowed_races.Join(", ")])"

		if(length(job_check.blacklisted_species) && (player_species_id_job in job_check.blacklisted_species))
			job_fail += "Wrong species (disallowed: [job_check.blacklisted_species.Join(", ")])"

		// Check allowed sexes
		if(length(job_check.allowed_sexes) && !(prefs.gender in job_check.allowed_sexes))
			job_fail += "Wrong sex (allowed: [job_check.allowed_sexes.Join(", ")])"

		// Check allowed ages
		if(length(job_check.allowed_ages) && !(prefs.age in job_check.allowed_ages))
			job_fail += "Wrong age (allowed: [job_check.allowed_ages.Join(", ")])"

		// If no fails, player can join this wave
		if(!length(job_fail))
			can_join_any = TRUE
		else
			failed_reasons[job_check.title] = job_fail

	for(var/job_title in failed_reasons)
		var/list/reasons = failed_reasons[job_title]
		to_chat(player, span_warning("Cannot be [job_title]: [reasons.Join(", ")]"))

	return can_join_any


/datum/custom_wave/proc/export_to_file(mob/admin)
	var/stored_data = get_json_data()
	var/json = json_encode(stored_data)
	var/f = file("data/TempJobExport")
	fdel(f)
	WRITE_FILE(f,json)
	admin << ftp(f,"[name].json")

/datum/create_wave/proc/load_wave(mob/admin)
	// Ask admin to select a file
	var/wave_file = input("Pick wave JSON file:", "File") as null|file
	if(!wave_file)
		return

	// Read JSON contents
	var/filedata = file2text(wave_file)
	var/json = json_decode(filedata)
	if(!json)
		to_chat(admin, span_warning("JSON decode error."))
		return

	// Ensure this is a single JSON object
	if(!islist(json))
		to_chat(admin, span_warning("Invalid file format (expected a single JSON job object)."))
		return

	var/wave_type = text2path(json["custom_wave_type"])
	if(!ispath(wave_type, /datum/custom_wave))
		to_chat(admin, span_warning("Malformed/Outdated file, the files does not have a wave type."))
		return

	// Create the wave
	var/datum/custom_wave/CW = new

	// Let loader handle the fields
	if(!CW.load_from_json(json))
		to_chat(admin, span_warning("Malformed/Outdated file, failed to load from json."))
		return

	// Add it to the global wave list
	GLOB.custom_waves += CW

	message_admins("[key_name(admin)] loaded a custom wave! Name: [CW.name]")
	to_chat(admin, span_notice("Successfully loaded wave '[CW.name]'."))


/datum/custom_wave/proc/get_json_data()
	var/list/data = list()

	data["custom_wave_type"] = type
	data["name"] = name
	data["greeting_text"] = greeting_text
	data["min_pop"] = min_pop
	data["max_pop"] = max_pop

	if(length(wave_jobs))
		var/list/wave_jobs_map = list()
		for(var/job in wave_jobs)
			var/slots = wave_jobs[job]
			var/job_key = job

			// If this is a custom job, embed its data
			if(istext(job) && (job in GLOB.custom_jobs))
				var/datum/job/custom_job/J = GLOB.custom_jobs[job]
				var/list/job_data = J.get_json_data()
				wave_jobs_map[job_key] = list(
					"slots" = slots,
					"custom_job_data" = job_data
				)
			else
				// Standard typepath jobs stay simple
				wave_jobs_map[job_key] = slots

		data["wave_jobs"] = wave_jobs_map

	return data

/datum/custom_wave/proc/load_from_json(list/data, mob/admin)
	if(!islist(data))
		return

	name = data["name"]
	greeting_text = data["greeting_text"]
	min_pop = text2num(data["min_pop"])
	max_pop = text2num(data["max_pop"])

	if(data["wave_jobs"])
		wave_jobs = list()
		for(var/job_text in data["wave_jobs"])
			var/job_entry = data["wave_jobs"][job_text]

			// If it’s a list, it means it’s a custom job
			if(islist(job_entry))
				var/slots = job_entry["slots"] || 1
				var/custom_job_data = job_entry["custom_job_data"]

				if(custom_job_data)
					var/datum/job/custom_job/J = new
					J.load_from_json(custom_job_data)
					if(J.id in GLOB.custom_jobs)
						wave_jobs[J.id] = slots
						continue
					GLOB.custom_jobs[J.id] = J
					wave_jobs[J.id] = slots
					message_admins("[key_name(usr)] loaded a custom job through the [name] wave! Name: [J.title] ")
					to_chat(admin, span_notice("Successfully loaded job [J.title]."))
				else
					wave_jobs[job_text] = slots
			else
				// Regular typepath job
				wave_jobs[job_text] = job_entry
	return TRUE

// Outfit Procs

/datum/create_wave/proc/save_outfit(mob/admin, datum/outfit/O)
	O.save_to_file(admin)
	outfit_manager(admin)

/datum/create_wave/proc/delete_outfit(mob/admin, datum/outfit/O)
	if(!O)
		return

	if(O.id in GLOB.custom_outfits)
		GLOB.custom_outfits -= O.id
	if(O.id in already_added_custom_outfits)
		already_added_custom_outfits -= O.id
		outfits_list = list()

	qdel(O)
	to_chat(admin,span_notice("The [O.name] outfit was deleted."))
	outfit_manager(admin)

/datum/create_wave/proc/load_outfit(mob/admin)
	var/outfit_file = input("Pick outfit json file:", "File") as null|file
	if(!outfit_file)
		return
	var/filedata = file2text(outfit_file)
	var/json = json_decode(filedata)
	if(!json)
		to_chat(admin, span_warning("JSON decode error."))
		return
	var/otype = text2path(json["outfit_type"])
	if(!ispath(otype,/datum/outfit))
		to_chat(admin,span_warning("Malformed/Outdated file, this file does not have the outfit type."))
		return
	var/datum/outfit/O = new otype
	if(!O.load_from(json))
		to_chat(admin, span_warning("Malformed/Outdated file, failed to load from json."))
		return

	GLOB.custom_outfits[O.id] = O
	message_admins("[key_name(usr)] loaded an outfit! Name: \"[O.name]\"")
	outfit_manager(admin)

/datum/create_wave/proc/export_outfit(mob/admin, datum/outfit/O)
	if(!O)
		to_chat(admin, span_warning("No outfit selected for export."))
		return

	var/json_data = O.get_json_data()
	if(!islist(json_data))
		to_chat(admin, span_warning("Failed to get outfit data."))
		return

	var/json = json_encode(json_data)
	var/f = file("data/exported_outfit_[SANITIZE_FILENAME(O.name)].json")

	fdel(f) // remove any existing temp file
	WRITE_FILE(f, json)

	admin << ftp(f, "[O.name].json")
	to_chat(admin, span_notice("Exported outfit: [O.name]"))

	outfit_manager(admin)


/datum/create_wave/proc/add_none_option(option_string)
	// Adds a "None" (empty) option at the top and makes it selected by default
	return "<option value='' selected>None</option>" + option_string

/datum/create_wave/proc/create_outfit(mob/admin)

	if(!init_outfit)
		for(var/obj/item/storage/belt/belt as anything in subtypesof(/obj/item/storage/belt))
			if(IS_ABSTRACT(belt))
				continue
			o_belt_options += "<option value='[belt]'>[belt::name]</option>"

		for(var/obj/item/clothing/gloves/gloves as anything in subtypesof(/obj/item/clothing/gloves))
			if(IS_ABSTRACT(gloves))
				continue
			o_gloves_options += "<option value='[gloves]'>[gloves::name]</option>"

		for(var/obj/item/clothing/shoes/shoes as anything in subtypesof(/obj/item/clothing/shoes))
			if(IS_ABSTRACT(shoes))
				continue
			o_shoes_options += "<option value='[shoes]'>[shoes::name]</option>"

		for(var/obj/item/clothing/head/head as anything in subtypesof(/obj/item/clothing/head))
			if(IS_ABSTRACT(head))
				continue
			o_head_options += "<option value='[head]'>[head::name]</option>"

		for(var/obj/item/clothing/face/face as anything in subtypesof(/obj/item/clothing/face))
			if(IS_ABSTRACT(face))
				continue
			o_mask_options += "<option value='[face]'>[face::name]</option>"

		for(var/obj/item/clothing/neck/neck as anything in subtypesof(/obj/item/clothing/neck))
			if(IS_ABSTRACT(neck))
				continue
			o_neck_options += "<option value='[neck]'>[neck::name]</option>"

		for(var/obj/item/clothing/wrists/wrists as anything in subtypesof(/obj/item/clothing/wrists))
			if(IS_ABSTRACT(wrists))
				continue
			o_wrists_options += "<option value='[wrists]'>[wrists::name]</option>"

		for(var/obj/item/clothing/shirt as anything in subtypesof(/obj/item/clothing/shirt) + subtypesof(/obj/item/clothing/armor))
			if(IS_ABSTRACT(shirt))
				continue
			o_shirt_options += "<option value='[shirt]'>[shirt::name]</option>"

		for(var/obj/item/clothing/pants/pants as anything in subtypesof(/obj/item/clothing/pants))
			if(IS_ABSTRACT(pants))
				continue
			o_pants_options += "<option value='[pants]'>[pants::name]</option>"

		for(var/obj/item/clothing/armor/armor as anything in subtypesof(/obj/item/clothing/armor))
			if(IS_ABSTRACT(armor))
				continue
			o_armor_options += "<option value='[armor]'>[armor::name]</option>"

		for(var/obj/item/clothing/ring/ring as anything in subtypesof(/obj/item/clothing/ring))
			if(IS_ABSTRACT(ring))
				continue
			o_ring_options += "<option value='[ring]'>[ring.name]</option>"

		for(var/obj/item/weapon/scabbard/scabbard as anything in subtypesof(/obj/item/weapon/scabbard))
			if(IS_ABSTRACT(scabbard))
				continue
			o_scabbards_options += "<option value='[scabbard]'>[scabbard::name]</option>"

		for(var/obj/item/clothing/cloak/cloak as anything in subtypesof(/obj/item/clothing/cloak))
			if(IS_ABSTRACT(cloak))
				continue
			o_cloak_options += "<option value='[cloak]'>[cloak::name]</option>"

		var/list/excluded_item_types = list(
			/obj/item/storage/belt,
			/obj/item/clothing,
			/obj/item/weapon/scabbard
		)

		for(var/obj/item/I as anything in subtypesof(/obj/item))
			if(IS_ABSTRACT(I))
				continue
			if(is_path_in_list(I, excluded_item_types))
				continue
			o_items_options += "<option value='[(I)]'>[I::name]</option>"


	var/dat = {"
	<html><head><title>Create Outfit</title></head><body>
	<form name="outfit" action="byond://?src=[REF(src)];[HrefToken()]" method="get">
	<input type="hidden" name="src" value="[REF(src)]">
	[HrefTokenFormField()]
	<input type="hidden" name="create_outfit_finalize" value="1">
	<table>
		<tr>
			<th>Name:</th>
			<td>
				<input type="text" name="outfit_name" value="Custom Outfit">
			</td>
		</tr>
		<tr>
			<th>Head:</th>
			<td>
			<select name='outfit_head'>
				[add_none_option(o_head_options)]
			</select>
			</td>
		</tr>
		<tr>
			<th>Mask:</th>
			<td>
			<select name='outfit_mask'>
				[add_none_option(o_mask_options)]
			</select>
			</td>
		</tr>
		<tr>
			<th>Neck:</th>
			<td>
			<select name='outfit_neck'>
				[add_none_option(o_neck_options)]
			</select>
			</td>
		</tr>
		<tr>
			<th>Cloak:</th>
			<td>
			<select name='outfit_cloak'>
				[add_none_option(o_cloak_options)]
			</select>
			</td>
		</tr>
		<tr>
			<th>BackR:</th>
			<td>
			<select name='outfit_backr'>
				[add_none_option(o_items_options)]
			</select>
			</td>
		</tr>
		<tr>
			<th>BackL:</th>
			<td>
			<select name='outfit_backl'>
				[add_none_option(o_items_options)]
			</select>
			</td>
		</tr>
		<tr>
			<th>Ring:</th>
			<td>
			<select name='outfit_ring'>
				[add_none_option(o_ring_options)]
			</select>
			</td>
		</tr>
		<tr>
			<th>Wrists:</th>
			<td>
			<select name='outfit_wrists'>
				[add_none_option(o_wrists_options)]
			</select>
			</td>
		</tr>
		<tr>
			<th>Gloves:</th>
			<td>
			<select name='outfit_gloves'>
				[add_none_option(o_gloves_options)]
			</select>
			</td>
		</tr>
		<tr>
			<th>Shirt:</th>
			<td>
			<select name='outfit_shirt'>
				[add_none_option(o_shirt_options)]
			</select>
			</td>
		</tr>
		<tr>
			<th>Armor:</th>
			<td>
			<select name='outfit_armor'>
				[add_none_option(o_armor_options)]
			</select>
			</td>
		</tr>
		<tr>
			<th>Pants:</th>
			<td>
			<select name='outfit_pants'>
				[add_none_option(o_pants_options)]
			</select>
			</td>
		</tr>
		<tr><th>Belt:</th><td>
			<select name='outfit_belt'>
				[add_none_option(o_belt_options)]
			</select>
		</td></tr>
		<tr>
			<th>Shoes:</th>
			<td>
			<select name='outfit_shoes'>
				[add_none_option(o_shoes_options)]
			</select>
			</td>
		</tr>

		<tr><th>Scabbard L and R</th><td>
			<select name='job_enabled_scabbard' id='job_enabled_scabbard' onchange='
				document.getElementById("scabbard_option").style.display = (this.value == "1") ? "block" : "none";
			'>
				[generate_boolean_option(FALSE)]
			</select>
			<br>
			<div id='scabbard_option'  style='display:[temp_antag_bool ? "block" : "none"];'>
				<select name='outfit_scabbard1'>
					[add_none_option(o_scabbards_options)]
				</select>
				<select name='outfit_scabbard2'>
					[add_none_option(o_scabbards_options)]
				</select>
			</div>
		</td></tr>
		<tr>
			<th>BeltL 1:</th>
			<td>
			<select name='outfit_beltl'>
				[add_none_option(o_items_options)]
			</select>
			</td>
		</tr>
		<tr>
			<th>BeltR 2:</th>
			<td>
			<select name='outfit_beltr'>
				[add_none_option(o_items_options)]
			</select>
			</td>
		</tr>
	</table>
	<br>
	<input type="submit" value="Save">
	</form></body></html>
	"}

	var/datum/browser/popup = new (admin, "outfit_manager", "Outfit Manager", 500, 550)
	popup.set_content(dat)

	popup.open()

/datum/create_wave/proc/view_outfit(mob/admin, datum/outfit/O)
	if(!O)
		return

	var/list/dat = list("<html><body>")
	if(O.name)
		dat += "<h2>Outfit Name: [O.name]</h2>"
	if(O.head)
		dat += "<h3>Outfit Head:</h3> [O.head]<br>"
	if(O.mask)
		dat += "<h3>Outfit Mask:</h3> [O.mask]<br>"
	if(O.neck)
		dat += "<h3>Outfit Neck:</h3> [O.neck]<br>"
	if(O.cloak)
		dat += "<h3>Outfit Cloak:</h3> [O.cloak]<br>"
	if(O.backl)
		dat += "<h3>Outfit BackL:</h3> [O.backl]<br>"
	if(O.backr)
		dat += "<h3>Outfit BackR:</h3> [O.backr]<br>"
	if(O.ring)
		dat += "<h3>Outfit Ring:</h3> [O.ring]<br>"
	if(O.wrists)
		dat += "<h3>Outfit Wrists:</h3> [O.wrists]<br>"
	if(O.gloves)
		dat += "<h3>Outfit Gloves:</h3> [O.gloves]<br>"
	if(O.shirt)
		dat += "<h3>Outfit Shirt:</h3> [O.shirt]<br>"
	if(O.armor)
		dat += "<h3>Outfit Armor:</h3> [O.armor]<br>"
	if(O.pants)
		dat += "<h3>Outfit Pants:</h3> [O.pants]<br>"
	if(O.belt)
		dat += "<h3>Outfit Belt:</h3> [O.belt]<br>"
	if(O.shoes)
		dat += "<h3>Outfit Shoes:</h3> [O.shoes]<br>"
	if(O.beltr)
		dat += "<h3>Outfit BeltR:</h3> [O.beltr]<br>"
	if(O.beltl)
		dat += "<h3>Outfit BeltL:</h3> [O.beltl]<br>"
	if(length(O.scabbards))
		dat += "<h3>Outfit Scabbard:</h3><ul>"
		for(var/scabbard in O.scabbards)
			dat += "<li>[scabbard]</li>"
		dat += "</ul>"

	dat += "<br>"
//	dat += "<br><a href='byond://?src=[REF(src)];[HrefToken()];'>Close</a>"
	dat += "</body></html>"

	var/datum/browser/popup = new(admin, "customjob_view", "Custom Outfit Preview", 500, 500, src)
	popup.set_content(dat.Join())
	popup.open(FALSE)


/datum/create_wave/proc/create_outfit_finalize(mob/admin, list/href_list)
	var/datum/outfit/O = new

	O.name = href_list["outfit_name"]
	O.head = text2path(href_list["outfit_head"])
	O.mask = text2path(href_list["outfit_mask"])
	O.neck = text2path(href_list["outfit_neck"])
	O.cloak = text2path(href_list["outfit_cloak"])
	O.backl = text2path(href_list["outfit_backl"])
	O.backr = text2path(href_list["outfit_backr"])
	O.ring = text2path(href_list["outfit_ring"])
	O.wrists = text2path(href_list["outfit_wrists"])
	O.gloves = text2path(href_list["outfit_gloves"])
	O.shirt = text2path(href_list["outfit_shirt"])
	O.armor = text2path(href_list["outfit_armor"])
	O.pants = text2path(href_list["outfit_pants"])
	O.belt = text2path(href_list["outfit_belt"])
	O.shoes = text2path(href_list["outfit_shoes"])
	O.beltr = text2path(href_list["outfit_beltr"])
	O.beltl = text2path(href_list["outfit_beltl"])

	var/job_enabled_scabbard = text2num(href_list["job_enabled_scabbard"])

	if(job_enabled_scabbard == 1)
		var/loaded_scabbard1 = text2path(href_list["outfit_scabbard1"])
		if(loaded_scabbard1)
			LAZYADD(O.scabbards, loaded_scabbard1)

		var/loaded_scabbard2 = text2path(href_list["outfit_scabbard2"])
		if(loaded_scabbard2)
			LAZYADD(O.scabbards, loaded_scabbard2)

	O.id = "[O.name]_[world.time]"

	GLOB.custom_outfits[O.id] = O
	message_admins("[key_name(usr)] created \"[O.name]\" outfit!")

	outfit_manager(admin)
