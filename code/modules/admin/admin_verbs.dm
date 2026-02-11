//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
//the procs are cause you can't put the comments in the GLOB var define

GLOBAL_LIST_INIT(admin_verbs_default, world.AVerbsDefault())
GLOBAL_PROTECT(admin_verbs_default)
/world/proc/AVerbsDefault()
	return list(
	/client/proc/check_pq,
	/client/proc/spawn_pollution,
	/client/proc/adjust_personal_see_leylines,
	/client/proc/spawn_liquid,
	/client/proc/spawn_faction_trader,
	/client/proc/crop_nutrient_debug,
	/client/proc/remove_liquid,
	/client/proc/adjust_pq,
	/client/proc/stop_restart,
	/client/proc/ghostears,
	/client/proc/ghostwhispers,
	/client/proc/ghosteyes,
	/client/proc/toggle_aghost_invis,
	/client/proc/admin_ghost,
	/client/proc/generate_bulk_codes,
	/client/proc/generate_custom_code,
	/client/proc/generate_codes,
	/client/proc/ghost_up,
	/datum/admins/proc/start_vote,
	/datum/admins/proc/show_player_panel,
	/datum/admins/proc/admin_heal,
	/datum/admins/proc/prompt_subclass,
	/datum/admins/proc/admin_bless,
	/datum/admins/proc/admin_curse,
	/datum/admins/proc/admin_sleep,
	/client/proc/ghost_down,
	/client/proc/jumptoarea,
	/client/proc/jumptokey,
	/client/proc/jumptomob,
	/client/proc/returntolobby,
	/datum/verbs/menu/Admin/verb/playerpanel,
	/client/proc/check_antagonists,
	/client/proc/admin_force_next_migrant_wave,
	/client/proc/cmd_admin_say,
	/client/proc/cmd_view_job_boosts,
	/client/proc/cmd_give_job_boost,
	/client/proc/deadmin,				/*destroys our own admin datum so we can play as a regular player*/
	/client/proc/toggle_context_menu,
	/client/proc/manage_books,
	/client/proc/manage_paintings,
	/client/proc/ShowAllFamilies,
	/datum/admins/proc/anoint_priest,
	)
GLOBAL_LIST_INIT(admin_verbs_admin, world.AVerbsAdmin())
GLOBAL_PROTECT(admin_verbs_admin)
/world/proc/AVerbsAdmin()
	return list(
	/client/proc/end_party,		/*destroys our own admin datum so we can play as a regular player*/
	/client/proc/cmd_admin_say,			/*admin-only ooc chat*/
	/client/proc/hide_verbs,			/*hides all our adminverbs*/
	/client/proc/hide_most_verbs,		/*hides all our hideable adminverbs*/
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify*/
	/client/proc/dsay,					/*talk in deadchat using our ckey/fakekey*/
	/client/proc/investigate_show,		/*various admintools for investigation. Such as a singulo grief-log*/
	/client/proc/secrets,
	/client/proc/toggle_hear_radio,		/*allows admins to hide all radio output*/
	/client/proc/reload_admins,
	/client/proc/reestablish_db_connection, /*reattempt a connection to the database*/
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,		/*admin-pm list*/
	/client/proc/stop_sounds,
	/client/proc/mark_datum_mapview,
	/client/proc/toggle_migrations, // toggles migrations.

	/client/proc/invisimin,				/*allows our mob to go invisible/visible*/
	/client/proc/toggle_specific_triumph_buy, /*toggle whether specific triumphs can be bought*/
	/client/proc/toggle_jobs_for_persistent, /*toggles jobs for the persistent server*/
	/client/proc/wave_creation_tools, /*custom job manage, custom wave manage and custom outfit manage*/
//	/datum/admins/proc/show_traitor_panel,	/*interface which shows a mob's mind*/ -Removed due to rare practical use. Moved to debug verbs ~Errorage
//	/datum/admins/proc/show_player_panel,	/*shows an interface for individual players, with various links (links require additional flags*/
//	/datum/verbs/menu/Admin/verb/playerpanel,
	/client/proc/game_panel,			/*game panel, allows to change game-mode etc*/
	/datum/admins/proc/toggleooc,		/*toggles ooc on/off for everyone*/
	/datum/admins/proc/toggleoocdead,	/*toggles ooc on/off for everyone who is dead*/
	/datum/admins/proc/togglelooc,
	/datum/admins/proc/fix_death_area,
	/datum/admins/proc/toggle_debug_pathfinding,
	/datum/admins/proc/give_all_triumphs,
	/datum/admins/proc/toggleenter,		/*toggles whether people can join the current game*/
	/datum/admins/proc/toggleguests,	/*toggles whether guests can join the current game*/
	/datum/admins/proc/announce,		/*priority announce something to all clients.*/
	/datum/admins/proc/set_admin_notice, /*announcement all clients see when joining the server.*/
	/datum/admins/proc/change_skill_exp_modifier, /*Tweaks experience gain*/
	/client/proc/toggle_aghost_invis, /* lets us choose whether our in-game mob goes visible when we aghost (off by default) */
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/ghostears,
	/client/proc/ghostwhispers,
	/client/proc/ghosteyes,
	/client/proc/ghost_up,
	/client/proc/ghost_down,
	/client/proc/toggle_view_range,		/*changes how far we can see*/
	/client/proc/getserverlogs,		/*for accessing server logs*/
	/client/proc/getcurrentlogs,		/*for accessing server logs for the current round*/
	/client/proc/cmd_admin_subtle_message,	/*send an message to somebody as a 'voice in their head'*/
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_admin_check_contents,	/*displays the contents of an instance*/
	/client/proc/check_antagonists,		/*shows all antags*/
	/client/proc/jumptocoord,			/*we ghost and jump to a coordinate*/
	/client/proc/Getmob,				/*teleports a mob to our location*/
	/client/proc/Getkey,				/*teleports a mob with a certain ckey to our location*/
//	/client/proc/sendmob,				/*sends a mob somewhere*/ -Removed due to it needing two sorting procs to work, which were executed every time an admin right-clicked. ~Errorage
	/client/proc/jumptoarea,
	/client/proc/jumptokey,				/*allows us to jump to the location of a mob with a certain ckey*/
	/client/proc/jumptomob,				/*allows us to jump to a specific mob*/
	/client/proc/jumptoturf,			/*allows us to jump to a specific turf*/
	/client/proc/spawn_in_test_area,
	/client/proc/jump_to_test_area,
	/client/proc/cmd_admin_direct_narrate,	/*send text directly to a player with no padding. Useful for narratives and fluff-text*/
	/client/proc/cmd_admin_world_narrate,	/*sends text to all players with no padding*/
	/client/proc/cmd_admin_local_narrate,	/*sends text to all mobs within view of atom*/
	/client/proc/cmd_admin_create_announcement,
	/client/proc/cmd_admin_check_player_exp, /* shows players by playtime */
	/client/proc/toggle_combo_hud, // toggle display of the combination pizza antag and taco sci/med/eng hud
	/client/proc/toggle_AI_interact, /*toggle admin ability to interact with machines as an AI*/
	/client/proc/deadchat,
	/client/proc/toggleprayers,
	/client/proc/toggle_prayer_sound,
	/client/proc/colorasay,
	/client/proc/resetasaycolor,
	/client/proc/set_personal_admin_ooc_color,
	/client/proc/reset_personal_admin_ooc_color,
	/client/proc/set_ghost_sprite,
	/client/proc/set_ui_theme,
	/client/proc/toggleadminhelpsound,
	/client/proc/respawn_character,
	/client/proc/discord_id_manipulation,
	/client/proc/ShowAllFamilies,
	/client/proc/send_bird_letter,
	)
GLOBAL_LIST_INIT(admin_verbs_ban, list(/client/proc/unban_panel, /client/proc/ban_panel, /client/proc/role_ban_panel, /client/proc/check_pq, /client/proc/adjust_pq, /client/proc/getcurrentlogs, /client/proc/getserverlogs))
GLOBAL_PROTECT(admin_verbs_ban)
GLOBAL_LIST_INIT(admin_verbs_sounds, list(/client/proc/play_local_sound, /client/proc/play_sound, /client/proc/set_round_end_sound))
GLOBAL_PROTECT(admin_verbs_sounds)
GLOBAL_LIST_INIT(admin_verbs_fun, list(
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/set_dynex_scale,
	/client/proc/drop_dynex_bomb,
	/client/proc/object_say,
	/client/proc/toggle_random_events,
	/client/proc/set_ooc,
	/client/proc/reset_ooc,
	/client/proc/forceEvent,
	/client/proc/forceGamemode,
	/client/proc/run_particle_weather,
	/client/proc/show_tip,
	/client/proc/smite,
	/client/proc/heart_attack,
	))
GLOBAL_PROTECT(admin_verbs_fun)
GLOBAL_LIST_INIT(admin_verbs_spawn, list(/datum/admins/proc/spawn_atom, /datum/admins/proc/podspawn_atom, /client/proc/respawn_character, /datum/admins/proc/beaker_panel))
GLOBAL_PROTECT(admin_verbs_spawn)
GLOBAL_LIST_INIT(admin_verbs_server, world.AVerbsServer())
GLOBAL_PROTECT(admin_verbs_server)
/world/proc/AVerbsServer()
	return list(
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/end_round,
	/datum/admins/proc/delay,
	/datum/admins/proc/accelerate_or_delay_round_end,
	/datum/admins/proc/toggleaban,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_debug_del_all,
	/client/proc/toggle_random_events,
	/client/proc/forcerandomrotate,
	/client/proc/adminchangemap,
	/client/proc/panicbunker,
	/client/proc/toggle_hub,
	/client/proc/toggle_cdn
	)
GLOBAL_LIST_INIT(admin_verbs_debug, world.AVerbsDebug())
GLOBAL_PROTECT(admin_verbs_debug)
/world/proc/AVerbsDebug()
	return list(
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/Debug2,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/restart_controller,
	/client/proc/enable_debug_verbs,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/SDQL2_query,
	/client/proc/test_movable_UI,
	/client/proc/test_snap_UI,
	/client/proc/check_bomb_impacts,
	/client/proc/recipe_tree_debug_menu,
	/client/proc/family_tree_debug_menu,
	/client/proc/debug_loot_tables,
	/client/proc/debug_influences,
	/client/proc/get_dynex_power,		//*debug verbs for dynex explosions.
	/client/proc/get_dynex_range,		//*debug verbs for dynex explosions.
	/client/proc/set_dynex_scale,
	/client/proc/cmd_display_del_log,
	/client/proc/debug_huds,
	/client/proc/map_export,
	/client/proc/map_template_load,
	/client/proc/map_template_upload,
	/client/proc/jump_to_ruin,
	/client/proc/toggle_medal_disable,
	/client/proc/view_runtimes,
	/client/proc/pump_random_event,
	/client/proc/cmd_display_init_log,
	/client/proc/cmd_display_overlay_log,
	/client/proc/reload_configuration,
	/datum/admins/proc/create_or_modify_area,
	/client/proc/returntolobby,
	/client/proc/tracy_next_round,
	/client/proc/start_tracy,
	/client/proc/set_tod_override,
	/client/proc/check_timer_sources,
	/client/proc/debug_spell_requirements,
	/client/proc/cmd_regenerate_asset_cache,
	/client/proc/cmd_clear_smart_asset_cache,
	/client/proc/select_job_pack_debug,
)
GLOBAL_LIST_INIT(admin_verbs_possess, list(/proc/possess, GLOBAL_PROC_REF(release)))
GLOBAL_PROTECT(admin_verbs_possess)
GLOBAL_LIST_INIT(admin_verbs_permissions, list(/client/proc/edit_admin_permissions))
GLOBAL_PROTECT(admin_verbs_permissions)
GLOBAL_LIST_INIT(admin_verbs_poll, list(/client/proc/poll_panel))
GLOBAL_PROTECT(admin_verbs_poll)

//verbs which can be hidden - needs work
GLOBAL_LIST_INIT(admin_verbs_hideable, list(
	/client/proc/set_ooc,
	/client/proc/reset_ooc,
	/client/proc/deadmin,
	/datum/admins/proc/show_traitor_panel,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/toggleguests,
	/datum/admins/proc/announce,
	/datum/admins/proc/set_admin_notice,
	/client/proc/toggle_aghost_invis,
	/client/proc/admin_ghost,
	/client/proc/toggle_view_range,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_check_contents,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/cmd_admin_local_narrate,
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/set_round_end_sound,
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/drop_dynex_bomb,
	/client/proc/get_dynex_range,
	/client/proc/get_dynex_power,
	/client/proc/set_dynex_scale,
	/client/proc/cmd_admin_create_announcement,
	/client/proc/object_say,
	/client/proc/toggle_random_events,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/Debug2,
	/client/proc/reload_admins,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_del_all,
	/client/proc/enable_debug_verbs,
	/proc/possess,
	/proc/release,
	/client/proc/reload_admins,
	/client/proc/panicbunker,
	/client/proc/cmd_display_del_log,
	/client/proc/toggle_combo_hud,
	/client/proc/debug_huds
	))
GLOBAL_PROTECT(admin_verbs_hideable)

/client/proc/add_admin_verbs()
	if(holder)
		control_freak = CONTROL_FREAK_SKIN | CONTROL_FREAK_MACROS

		var/rights = holder.rank.rights
		add_verb(src, GLOB.admin_verbs_default)
		if(rights & R_BUILD)
			add_verb(src, /client/proc/togglebuildmodeself)
		if(rights & R_ADMIN)
			add_verb(src, GLOB.admin_verbs_admin)
		if(rights & R_BAN)
			add_verb(src, GLOB.admin_verbs_ban)
		if(rights & R_FUN)
			add_verb(src, GLOB.admin_verbs_fun)
		if(rights & R_SERVER)
			add_verb(src, GLOB.admin_verbs_server)
		if(rights & R_DEBUG)
			add_verb(src, GLOB.admin_verbs_debug)
		if(rights & R_POSSESS)
			add_verb(src, GLOB.admin_verbs_possess)
		if(rights & R_PERMISSIONS)
			add_verb(src, GLOB.admin_verbs_permissions)
		if(rights & R_STEALTH)
			add_verb(src, /client/proc/stealth)
		if(rights & R_ADMIN)
			add_verb(src, GLOB.admin_verbs_poll)
		if(rights & R_SOUND)
			add_verb(src, GLOB.admin_verbs_sounds)
			if(CONFIG_GET(string/invoke_youtubedl))
				add_verb(src, /client/proc/play_web_sound)
		if(rights & R_SPAWN)
			add_verb(src, GLOB.admin_verbs_spawn)

/client/proc/remove_admin_verbs()
	var/list/verbs = list(
		GLOB.admin_verbs_default,
		/client/proc/togglebuildmodeself,
		GLOB.admin_verbs_admin,
		GLOB.admin_verbs_ban,
		GLOB.admin_verbs_fun,
		GLOB.admin_verbs_server,
		GLOB.admin_verbs_debug,
		GLOB.admin_verbs_possess,
		GLOB.admin_verbs_permissions,
		/client/proc/stealth,
		GLOB.admin_verbs_poll,
		GLOB.admin_verbs_sounds,
		/client/proc/play_web_sound,
		GLOB.admin_verbs_spawn,
		GLOB.admin_verbs_debug_mapping,
		/client/proc/disable_debug_verbs,
		/client/proc/readmin
	)
	remove_verb(src, verbs)

/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "Adminverbs - Hide Most"
	set category = "Admin.Admin Preferences"

	remove_verb(src, list(/client/proc/hide_most_verbs) + GLOB.admin_verbs_hideable)
	add_verb(src, /client/proc/show_verbs)

	to_chat(src, "<span class='interface'>Most of your adminverbs have been hidden.</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Hide Most Adminverbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Admin.Admin Preferences"

	remove_admin_verbs()
	add_verb(src, /client/proc/show_verbs)


	to_chat(src, "<span class='interface'>Almost all of your adminverbs have been hidden.</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Hide All Adminverbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin.Admin Preferences"

	remove_verb(src, /client/proc/show_verbs)
	add_admin_verbs()

	to_chat(src, "<span class='interface'>All of your adminverbs are now visible.</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Adminverbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_context_menu()
	set category = "Admin.Admin Preferences"
	set name = "Right-click Menu"
	if(!holder)
		return
	show_popup_menus = !show_popup_menus

	to_chat(usr, span_notice("Toggled context menu [show_popup_menus ? "ON" : "OFF"]."))
	log_admin("[key_name(usr)] toggled context menu [show_popup_menus ? "ON" : "OFF"].")

/client/proc/toggle_aghost_invis()
	set category = "Admin.Ghost"
	set name = "Aghost (Toggle Invisibility)"
	if (!holder)
		return
	aghost_toggle = !aghost_toggle
	to_chat(src, aghost_toggle ? "Aghosting will now turn your mob invisible." : "Aghost will no longer turn your mob invisible.")

/client/proc/admin_ghost()
	set category = "Admin.Ghost"
	set name = "Aghost"
	if(!holder)
		return
	. = TRUE
	if(isobserver(mob))
		//re-enter
		var/mob/dead/observer/ghost = mob
		if(!ghost.mind || !ghost.mind.current) //won't do anything if there is no body
			return FALSE
		if(!ghost.can_reenter_corpse)
			log_admin("[key_name(usr)] re-entered corpse")
			message_admins("[key_name_admin(usr)] re-entered corpse")
		if(istype(ghost.mind.current, /mob/living))
			var/mob/living/M = ghost.mind.current
			var/datum/status_effect/incapacitating/sleeping/S = M.IsSleeping()
			if(S && !HAS_TRAIT(M, TRAIT_FLOORED)) // Wake them up unless they're asleep for another reason
				M.remove_status_effect(S)
				M.set_resting(FALSE, TRUE)
			M.density = initial(M.density)
			M.invisibility = initial(M.invisibility)
		else
			var/mob/M = ghost.mind.current
			M.invisibility = initial(M.invisibility)
			M.density = initial(M.density)
		ghost.can_reenter_corpse = 1 //force re-entering even when otherwise not possible
		ghost.reenter_corpse()
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Admin Reenter") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else if(isnewplayer(mob))
//		to_chat(src, "<font color='red'>Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.</font>")
//		return FALSE
		var/mob/dead/new_player/NP = mob
		NP.make_me_an_observer()
	else
		//ghostize
		log_admin("[key_name(usr)] admin ghosted.")
		message_admins("[key_name_admin(usr)] admin ghosted.")
		var/mob/body = mob
		if (aghost_toggle)
			body.invisibility = INVISIBILITY_MAXIMUM
			body.density = 0
		body.ghostize(1)
		if(body && !body.key)
			body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Admin Ghost") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Admin.Admin Preferences"
	set desc = ""
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.invisibility = initial(mob.invisibility)
			to_chat(mob, "<span class='boldannounce'>Invisimin off. Invisibility reset.</span>")
		else
			mob.invisibility = INVISIBILITY_OBSERVER
			to_chat(mob, "<span class='adminnotice'><b>Invisimin on. You are now as invisible as a ghost.</b></span>")

/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "GameMaster.Antags"
	if(holder)
		holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")	//for tsar~
		if(!isobserver(usr) && SSticker.HasRoundStarted())
			message_admins("[key_name_admin(usr)] checked antagonists.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Check Antagonists") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/set_tod_override()
	set category = "Debug"
	set name = "SetTODOverride"
	var/list/TODs = list("dawn","day","dusk","night")
	var/choice = input(src,"","Set time of day override") as null|anything in TODs
	if(choice)
		GLOB.todoverride = choice
		world << "[ckey] has set the time of day override to [choice]."
	else
		GLOB.todoverride = null
		world << "[ckey] has disabled the time of day override."
	settod()

/client/proc/ban_panel()
	set name = "Banning Panel"
	set category = "Admin.Bans"
	if(!check_rights(R_BAN))
		return
	holder.ban_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Banning Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/role_ban_panel()
	set name = "Role Ban Panel"
	set category = "Admin.Bans"
	if(!check_rights(R_BAN))
		return
	holder.role_ban_panel.show_ui(usr)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Role Ban Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/unban_panel()
	set name = "Unbanning Panel"
	set category = "Admin.Bans"
	if(!check_rights(R_BAN))
		return
	holder.unban_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Unbanning Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin.Admin"
	if(holder)
		holder.Game()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Game Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin.Admin"
	if (holder)
		holder.Secrets()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Secrets Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/poll_panel()
	set name = "Server Poll Management"
	set category = "Admin.Admin"
	if(!check_rights(R_POLL))
		return
	holder.poll_list_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Server Poll Management") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/findStealthKey(txt)
	if(txt)
		for(var/P in GLOB.stealthminID)
			if(GLOB.stealthminID[P] == txt)
				return P
	txt = GLOB.stealthminID[ckey]
	return txt

/client/proc/createStealthKey()
	var/num = (rand(0,1000))
	var/i = 0
	while(i == 0)
		i = 1
		for(var/P in GLOB.stealthminID)
			if(num == GLOB.stealthminID[P])
				num++
				i = 0
	GLOB.stealthminID["[ckey]"] = "@[num2text(num)]"

/client/proc/stealth()
	set category = "Admin.Admin Preferences"
	set name = "Stealth Mode"
	if(holder)
		if(holder.fakekey)
			holder.fakekey = null
			if(isobserver(mob))
				mob.invisibility = initial(mob.invisibility)
				mob.alpha = initial(mob.alpha)
				mob.name = initial(mob.name)
				mob.mouse_opacity = initial(mob.mouse_opacity)
		else
			var/new_key = ckeyEx(input("Enter your desired display name.", "Fake Key", key) as text|null)
			if(!new_key)
				return
			if(length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			holder.fakekey = new_key
			createStealthKey()
			if(isobserver(mob))
				mob.invisibility = INVISIBILITY_MAXIMUM //JUST IN CASE
				mob.alpha = 0 //JUUUUST IN CASE
				mob.name = " "
				mob.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		log_admin("[key_name(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
		message_admins("[key_name_admin(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Stealth Mode") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/drop_bomb()
	set category = "GameMaster.Fun"
	set name = "Drop Bomb"
	set desc = ""

	var/list/choices = list("Small Bomb (1, 2, 3, 3)", "Medium Bomb (2, 3, 4, 4)", "Big Bomb (3, 5, 7, 5)", "Maxcap", "Custom Bomb")
	var/choice = input("What size explosion would you like to produce? NOTE: You can do all this rapidly and in an IC manner (using cruise missiles!) with the Config/Launch Supplypod verb. WARNING: These ignore the maxcap") as null|anything in choices
	var/turf/epicenter = mob.loc

	switch(choice)
		if(null)
			return 0
		if("Small Bomb (1, 2, 3, 3)")
			explosion(epicenter, 1, 2, 3, 3, TRUE, TRUE)
		if("Medium Bomb (2, 3, 4, 4)")
			explosion(epicenter, 2, 3, 4, 4, TRUE, TRUE)
		if("Big Bomb (3, 5, 7, 5)")
			explosion(epicenter, 3, 5, 7, 5, TRUE, TRUE)
		if("Maxcap")
			explosion(epicenter, GLOB.MAX_EX_DEVESTATION_RANGE, GLOB.MAX_EX_HEAVY_RANGE, GLOB.MAX_EX_LIGHT_RANGE, GLOB.MAX_EX_FLASH_RANGE)
		if("Custom Bomb")
			var/devastation_range = input("Devastation range (in tiles):") as null|num
			if(devastation_range == null)
				return
			var/heavy_impact_range = input("Heavy impact range (in tiles):") as null|num
			if(heavy_impact_range == null)
				return
			var/light_impact_range = input("Light impact range (in tiles):") as null|num
			if(light_impact_range == null)
				return
			var/flash_range = input("Flash range (in tiles):") as null|num
			if(flash_range == null)
				return
			if(devastation_range > GLOB.MAX_EX_DEVESTATION_RANGE || heavy_impact_range > GLOB.MAX_EX_HEAVY_RANGE || light_impact_range > GLOB.MAX_EX_LIGHT_RANGE || flash_range > GLOB.MAX_EX_FLASH_RANGE)
				if(alert("Bomb is bigger than the maxcap. Continue?",,"Yes","No") != "Yes")
					return
			epicenter = mob.loc //We need to reupdate as they may have moved again
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, TRUE, TRUE)
	message_admins("[ADMIN_LOOKUPFLW(usr)] creating an admin explosion at [epicenter.loc].")
	log_admin("[key_name(usr)] created an admin explosion at [epicenter.loc].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Drop Bomb") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/drop_dynex_bomb()
	set category = "GameMaster.Fun"
	set name = "Drop DynEx Bomb"
	set desc = ""

	var/ex_power = input("Explosive Power:") as null|num
	var/turf/epicenter = mob.loc
	if(ex_power && epicenter)
		dyn_explosion(epicenter, ex_power)
		message_admins("[ADMIN_LOOKUPFLW(usr)] creating an admin explosion at [epicenter.loc].")
		log_admin("[key_name(usr)] created an admin explosion at [epicenter.loc].")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Drop Dynamic Bomb") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/get_dynex_range()
	set category = "Debug.Debug"
	set name = "Get DynEx Range"
	set desc = ""

	var/ex_power = input("Explosive Power:") as null|num
	if (isnull(ex_power))
		return
	var/range = round((2 * ex_power)**GLOB.DYN_EX_SCALE)
	to_chat(usr, "Estimated Explosive Range: (Devastation: [round(range*0.25)], Heavy: [round(range*0.5)], Light: [round(range)])")

/client/proc/get_dynex_power()
	set category = "Debug.Debug"
	set name = "Get DynEx Power"
	set desc = ""

	var/ex_range = input("Light Explosion Range:") as null|num
	if (isnull(ex_range))
		return
	var/power = (0.5 * ex_range)**(1/GLOB.DYN_EX_SCALE)
	to_chat(usr, "Estimated Explosive Power: [power]")

/client/proc/set_dynex_scale()
	set category = "Debug.Debug"
	set name = "Set DynEx Scale"
	set desc = ""

	var/ex_scale = input("New DynEx Scale:") as null|num
	if(!ex_scale)
		return
	GLOB.DYN_EX_SCALE = ex_scale
	log_admin("[key_name(usr)] has modified Dynamic Explosion Scale: [ex_scale]")
	message_admins("[key_name_admin(usr)] has  modified Dynamic Explosion Scale: [ex_scale]")

/client/proc/give_spell(mob/spell_recipient in GLOB.mob_list)
	set category = "GameMaster.Fun"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."

	var/which = browser_alert(usr, "Chose by name or by type path?", "Chose option", list("Name", "Typepath"))
	if(!which)
		return
	if(QDELETED(spell_recipient))
		to_chat(usr, span_warning("The intended spell recipient no longer exists."))
		return

	var/list/spell_list = list()
	for(var/datum/action/cooldown/spell/to_add as anything in subtypesof(/datum/action/cooldown/spell))
		var/spell_name = initial(to_add.name)
		if(spell_name == "Spell") // abstract or un-named spells should be skipped.
			continue

		if(which == "Name")
			spell_list[spell_name] = to_add
		else
			spell_list += to_add

	var/chosen_spell = browser_input_list(usr, "Choose the spell to give to [spell_recipient]", "ABRAKADABRA", sortList(spell_list))
	if(isnull(chosen_spell))
		return
	var/datum/action/cooldown/spell/spell_path = which == "Typepath" ? chosen_spell : spell_list[chosen_spell]
	if(!ispath(spell_path))
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Give Spell") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(spell_recipient)] the spell [chosen_spell].")
	message_admins("[key_name_admin(usr)] gave [key_name_admin(spell_recipient)] the spell [chosen_spell].")

	var/datum/action/cooldown/spell/new_spell = new spell_path(spell_recipient.mind || spell_recipient)

	new_spell.Grant(spell_recipient)

	if(!spell_recipient.mind)
		to_chat(usr, span_userdanger("Spells given to mindless mobs will belong to the mob and not their mind, \
			and as such will not be transferred if their mind changes body (Such as from Mindswap)."))

/client/proc/remove_spell(mob/removal_target in GLOB.mob_list)
	set category = "GameMaster.Fun"
	set name = "Remove Spell"
	set desc = "Remove a spell from the selected mob."

	var/list/target_spell_list = list()
	for(var/datum/action/cooldown/spell/spell in removal_target.actions)
		target_spell_list[spell.name] = spell

	if(!length(target_spell_list))
		return

	var/chosen_spell = browser_input_list(usr, "Choose the spell to remove from [removal_target]", "ABRAKADABRA", sortList(target_spell_list))
	if(isnull(chosen_spell))
		return
	var/datum/action/cooldown/spell/to_remove = target_spell_list[chosen_spell]
	if(!istype(to_remove))
		return

	qdel(to_remove)
	log_admin("[key_name(usr)] removed the spell [chosen_spell] from [key_name(removal_target)].")
	message_admins("[key_name_admin(usr)] removed the spell [chosen_spell] from [key_name_admin(removal_target)].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Remove Spell") //If you are copy-pasting this, ensure the 2nd parameter is unique

/client/proc/object_say(obj/O in world)
	set category = "GameMaster.Interactions"
	set name = "ObjectSay"
	set desc = ""
	var/message = input(usr, "What do you want the message to be?", "Make Sound") as text | null
	if(!message)
		return
	O.say(message)
	log_admin("[key_name(usr)] made [O] at [AREACOORD(O)] say \"[message]\"")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] made [O] at [AREACOORD(O)]. say \"[message]\"</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Object Say") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "GameMaster"
	if (!(holder.rank.rights & R_BUILD))
		return
	if(src.mob)
		togglebuildmode(src.mob)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Build Mode") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/deadmin()
	set name = "Deadmin"
	set category = "Admin.Admin Preferences"
	set desc = ""

	if(!holder)
		return

	// Handle antag HUD if active
	if(has_antag_hud())
		toggle_combo_hud()

	// Deactivate admin holder
	holder.deactivate()

	//they can no longer use right click menus
	show_popup_menus = FALSE

	// Ensure the admin stops hearing ghosts like a mortal
	if(prefs)
		prefs.chat_toggles &= ~CHAT_GHOSTEARS   // Explicitly remove ghost hearing
		prefs.chat_toggles &= ~CHAT_GHOSTWHISPER // Explicitly remove ghost whispers
		prefs.save_preferences()
		to_chat(src, span_info("I will hear like a mortal."))

	// Messaging
	to_chat(src, span_interface("I am now a normal player."))
	log_admin("[src] deadmined themself.")
	message_admins("[src] deadmined themself.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Deadmin")

/client/proc/readmin()
	set name = "Readmin"
	set category = "Admin.Admin Preferences"
	set desc = ""

	var/datum/admins/A = GLOB.deadmins[ckey]

	if(!A)
		A = GLOB.admin_datums[ckey]
		if(!A)
			var/msg = " is trying to readmin but they have no deadmin entry"
			message_admins("[key_name_admin(src)][msg]")
			log_admin_private("[key_name(src)][msg]")
			return

	A.associate(src)

	// they can now use right click menus
	show_popup_menus = TRUE

	if(!holder)
		return //This can happen if an admin attempts to vv themself into somebody elses's deadmin datum by getting ref via brute force

	to_chat(src, "<span class='interface'>I am now an admin.</span>")
	message_admins("[src] re-adminned themselves.")
	log_admin("[src] re-adminned themselves.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Readmin")

/client/proc/toggle_AI_interact()
	set name = "Toggle Admin AI Interact"
	set category = "Admin.Admin"
	set desc = ""

	AI_Interact = !AI_Interact
	if(mob && IsAdminGhost(mob))
		mob.has_unlimited_silicon_privilege = AI_Interact

	log_admin("[key_name(usr)] has [AI_Interact ? "activated" : "deactivated"] Admin AI Interact")
	message_admins("[key_name_admin(usr)] has [AI_Interact ? "activated" : "deactivated"] their AI interaction")

/client/proc/end_party()
	set category = "GameMaster"
	set name = "EndPlaytest"
	set hidden = 1
	if(!holder)
		return
	if(!SSticker.end_party)
		SSticker.end_party=TRUE
		to_chat(src, "<span class='interface'>Ending enabled.</span>")
	else
		SSticker.end_party=FALSE
		to_chat(src, "<span class='interface'>Ending DISABLED.</span>")

/client/proc/manage_books()
	set category = "GameMaster.Interactions"
	set name = "Manage Books"
	if(!holder)
		return

	var/dat = "<table style='border-collapse: separate; border-spacing: 0 10px; width: 100%;'>"
	dat += "<tr>"
	dat += "<th style='padding: 10px 15px; text-align: left; color: #c72222;'>Title</th>"
	dat += "<th style='padding: 10px 15px; text-align: left; color: #c72222;'>Player Author</th>"
	dat += "<th style='padding: 10px 15px; text-align: left; color: #c72222;'>Author</th>"
	dat += "<th style='padding: 10px 15px; text-align: left; color: #c72222;'>Category</th>"
	dat += "<th style='padding: 10px 15px; text-align: left; color: #c72222;'>Actions</th>"
	dat += "</tr>"

	var/list/decoded_books = SSlibrarian.pull_player_book_titles()
	for(var/encoded_title in decoded_books)
		var/list/book = SSlibrarian.file2playerbook(encoded_title)
		if(!book || !book["book_title"])
			continue

		dat += "<tr>"
		dat += "<td style='padding: 12px 15px;'>[book["book_title"]]</td>"
		dat += "<td style='padding: 12px 15px;'>[book["author_ckey"]]</td>"
		dat += "<td style='padding: 12px 15px;'>[book["author"]]</td>"
		dat += "<td style='padding: 12px 15px;'>[book["category"]]</td>"
		dat += "<td style='padding: 12px 15px;'>"
		dat += "<a href='?src=[REF(src)];show_book=1;id=[url_encode(encoded_title)]' style='margin-right: 10px;'>View</a>"
		dat += "<a href='?src=[REF(src)];delete_book=1;author_ckey=[book["author_ckey"]];id=[url_encode(encoded_title)]'>Delete</a>"
		dat += "</td>"
		dat += "</tr>"

	if(!length(decoded_books))
		dat += "<tr><td colspan='4' style='padding: 20px; text-align: center;'>No books found</td></tr>"

	dat += "</table>"
	var/datum/browser/popup = new(usr, "book_management", "Book Management", 800, 700)
	popup.set_content(dat)
	popup.open()

/client/proc/show_book_content(title)
	var/list/book = SSlibrarian.file2playerbook(title)
	if(!book || !book["book_title"])
		to_chat(src, "<span class='warning'>Book not found!</span>")
		return

	src << browse_rsc('html/book.png')

	var/content = book["text"]
	var/dat = {"
	<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
	<html>
		<head>
			<style type=\"text/css\">
				body {
					background-image:url('book.png');
					background-repeat: repeat;
					color: #000000;
					font-size: 17px;
					line-height: 1.5;
					padding: 20px;
					font-family: 'Times New Roman', serif;
				}
			</style>
		</head>
		<body>
			[content]
		</body>
	</html>
	"}

	src << browse(dat, "window=reading;size=800x600;can_close=1;can_minimize=1;can_maximize=1;can_resize=1;border=0")

/client/proc/manage_paintings()
	set category = "GameMaster.Interactions"
	set name = "Manage Paintings"
	if(!holder)
		return

	var/dat = "<table style='border-collapse: separate; border-spacing: 0 10px; width: 100%;'>"
	dat += "<tr>"
	dat += "<th style='padding: 10px 15px; text-align: left; color: #c72222;'>Preview</th>"
	dat += "<th style='padding: 10px 15px; text-align: left; color: #c72222;'>Title</th>"
	dat += "<th style='padding: 10px 15px; text-align: left; color: #c72222;'>Author</th>"
	dat += "<th style='padding: 10px 15px; text-align: left; color: #c72222;'>Delete</th>"
	dat += "</tr>"

	if(SSpaintings?.paintings && length(SSpaintings.paintings))
		for(var/encoded_title in SSpaintings.paintings)
			var/list/painting = SSpaintings.paintings[encoded_title]
			if(!painting || !islist(painting))
				continue

			var/raw_title = painting["painting_title"]
			var/author = painting["author_ckey"]
			var/disk_filename = SSpaintings.get_painting_filename(raw_title)

			if(fexists(disk_filename))
				var/icon/painting_icon = icon(disk_filename)
				if(painting_icon)
					var/res_name = "painting_[md5(raw_title)].png"
					src << browse_rsc(painting_icon, res_name)
					dat += "<tr>"
					dat += "<td style='padding: 12px 15px;'><img src='[res_name]' height=64 width=64 style='display: block; margin: 0 auto;'></td>"
					dat += "<td style='padding: 12px 15px;'>[raw_title]</td>"
					dat += "<td style='padding: 12px 15px;'>[author]</td>"
					dat += "<td style='padding: 12px 15px;'>"
					dat += "<a href='?src=[REF(src)];delete_painting=1;id=[url_encode(raw_title)]'>Delete</a>"
					dat += "</td>"
					dat += "</tr>"
	else
		dat += "<tr><td colspan='4' style='padding: 20px; text-align: center;'>No paintings found</td></tr>"

	dat += "</table>"

	var/datum/browser/popup = new(usr, "painting_management", "Painting Management", 700, 700)
	popup.set_content(dat)
	popup.open()

//Family Tree Subsystem
/client/proc/ShowAllFamilies()
	set category = "GameMaster"
	set name = "Show All Families"
	var/dat = SSfamilytree.ReturnAllFamilies()
	if(!dat)
		to_chat(src, "<span class='interface'>Family List was Empty.</span>")
		return
	var/datum/browser/popup = new(usr, "ALLFAMILIES", "", 260, 400)
	popup.set_content(dat)
	popup.open()

/client/proc/tracy_next_round()
	set name = "Toggle Tracy Next Round"
	set desc = "Toggle running the byond-tracy profiler next round"
	set category = "Debug"
	if(!check_rights_for(src, R_DEBUG))
		return
#ifndef OPENDREAM
	if(!fexists(TRACY_DLL_PATH))
		to_chat(src, span_danger("byond-tracy library ([TRACY_DLL_PATH]) not present!"))
		return
	if(fexists(TRACY_ENABLE_PATH))
		fdel(TRACY_ENABLE_PATH)
	else
		rustg_file_write("[ckey]", TRACY_ENABLE_PATH)
	message_admins(span_adminnotice("[key_name_admin(src)] [fexists(TRACY_ENABLE_PATH) ? "enabled" : "disabled"] the byond-tracy profiler for next round."))
	log_admin("[key_name(src)] [fexists(TRACY_ENABLE_PATH) ? "enabled" : "disabled"] the byond-tracy profiler for next round.")
#else
	to_chat(src, span_danger("byond-tracy is not supported on OpenDream, sorry!"))
#endif

/client/proc/start_tracy()
	set name = "Run Tracy Now"
	set desc = "Start running the byond-tracy profiler immediately."
	set category = "Debug"
	if(!check_rights_for(src, R_DEBUG))
		return
#ifndef OPENDREAM
	if(GLOB.tracy_initialized)
		to_chat(src, span_warning("byond-tracy is already running!"))
		return
	else if(GLOB.tracy_init_error)
		to_chat(src, span_danger("byond-tracy failed to initialize during an earlier attempt: [GLOB.tracy_init_error]"))
		return
	else if(!fexists(TRACY_DLL_PATH))
		to_chat(src, span_danger("byond-tracy library ([TRACY_DLL_PATH]) not present!"))
		return
	message_admins(span_adminnotice("[key_name_admin(src)] is trying to start the byond-tracy profiler."))
	log_admin("[key_name(src)] is trying to start the byond-tracy profiler.")
	GLOB.tracy_initialized = FALSE
	GLOB.tracy_init_reason = "[ckey]"
	world.init_byond_tracy()
	if(GLOB.tracy_init_error)
		to_chat(src, span_danger("byond-tracy failed to initialize: [GLOB.tracy_init_error]"))
		message_admins(span_adminnotice("[key_name_admin(src)] tried to start the byond-tracy profiler, but it failed to initialize ([GLOB.tracy_init_error])"))
		log_admin("[key_name(src)] tried to start the byond-tracy profiler, but it failed to initialize ([GLOB.tracy_init_error])")
		return
	to_chat(src, span_notice("byond-tracy successfully started!"))
	message_admins(span_adminnotice("[key_name_admin(src)] started the byond-tracy profiler."))
	log_admin("[key_name(src)] started the byond-tracy profiler.")
	if(GLOB.tracy_log)
		rustg_file_write("[GLOB.tracy_log]", "[GLOB.log_directory]/tracy.loc")
#else
	to_chat(src, span_danger("byond-tracy is not supported on OpenDream, sorry!"))
#endif

/// Debug verb for seeing at a glance what all spells have as set requirements
/client/proc/debug_spell_requirements()
	set name = "Show Spell Requirements"
	set category = "Debug"

	var/header = "<tr><th>Name</th> <th>Requirements</th>"
	var/all_requirements = list()
	for(var/datum/action/cooldown/spell/spell as anything in typesof(/datum/action/cooldown/spell))
		if(initial(spell.name) == "Spell")
			continue

		var/list/real_reqs = list()
		var/reqs = initial(spell.spell_requirements)
		if(reqs & SPELL_CASTABLE_WHILE_PHASED)
			real_reqs += "Castable phased"
		if(reqs & SPELL_REQUIRES_HUMAN)
			real_reqs += "Must be human"
		if(reqs & SPELL_REQUIRES_MIND)
			real_reqs += "Must have a mind"
		if(reqs & SPELL_REQUIRES_NO_ANTIMAGIC)
			real_reqs += "Must have no antimagic"
		if(reqs & SPELL_REQUIRES_STATION)
			real_reqs += "Must be off central command z-level"
		if(reqs & SPELL_REQUIRES_WIZARD_GARB)
			real_reqs += "Must have wizard clothes"
		if(reqs & SPELL_REQUIRES_NO_MOVE)
			real_reqs += "Must stand still while casting"

		all_requirements += "<tr><td>[initial(spell.name)]</td> <td>[english_list(real_reqs, "No requirements")]</td></tr>"

	var/page_style = "<style>table, th, td {border: 1px solid black;border-collapse: collapse;}</style>"
	var/page_contents = "[page_style]<table style=\"width:100%\">[header][jointext(all_requirements, "")]</table>"
	var/datum/browser/popup = new(mob, "spellreqs", "Spell Requirements", 600, 400)
	popup.set_content(page_contents)
	popup.open()
