	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		1048576	//Restricts client uploads to the server to 1MB //Could probably do with being lower.

GLOBAL_LIST_INIT(blacklisted_builds, list(
	"1407" = "bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1408" = "bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1428" = "bug causing right-click menus to show too many verbs that's been fixed in version 1429",

	))

GLOBAL_LIST_EMPTY(respawntimes)
GLOBAL_LIST_EMPTY(respawncounts)

#define LIMITER_SIZE	5
#define CURRENT_SECOND	1
#define SECOND_COUNT	2
#define CURRENT_MINUTE	3
#define MINUTE_COUNT	4
#define ADMINSWARNED_AT	5
	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/

/client
	var/commendedsomeone
	var/atom/movable/movingmob
	var/whitelisted = 2

/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	if(href_list["schizohelp"])
		answer_schizohelp(locate(href_list["schizohelp"]))
		return

	if(href_list["delete_painting"])
		if(!holder)
			return
		SSpaintings.del_player_painting(href_list["id"])
		SSpaintings.update_paintings()

	// asset_cache
	var/asset_cache_job
	if(href_list["asset_cache_confirm_arrival"])
		asset_cache_job = round(text2num(href_list["asset_cache_confirm_arrival"]))
		//because we skip the limiter, we have to make sure this is a valid arrival and not somebody tricking us
		//	into letting append to a list without limit.
		if (asset_cache_job > 0 && asset_cache_job <= last_asset_job && !(asset_cache_job in completed_asset_jobs))
			completed_asset_jobs += asset_cache_job
			return

	if(!holder && href_list["window_id"] != "statbrowser")
		var/mtl = CONFIG_GET(number/minute_topic_limit)
		if (mtl)
			var/minute = round(world.time, 1 MINUTES)
			if (!topiclimiter)
				topiclimiter = new(LIMITER_SIZE)
			if (minute != topiclimiter[CURRENT_MINUTE])
				topiclimiter[CURRENT_MINUTE] = minute
				topiclimiter[MINUTE_COUNT] = 0
			topiclimiter[MINUTE_COUNT] += 1
			if (topiclimiter[MINUTE_COUNT] > mtl)
				var/msg = "Your previous action was ignored because you've done too many in a minute."
				if (minute != topiclimiter[ADMINSWARNED_AT]) //only one admin message per-minute. (if they spam the admins can just boot/ban them)
					topiclimiter[ADMINSWARNED_AT] = minute
					msg += " Administrators have been informed."
					log_game("[key_name(src)] Has hit the per-minute topic limit of [mtl] topic calls in a given game minute")
					message_admins("[ADMIN_LOOKUPFLW(usr)] [ADMIN_KICK(usr)] Has hit the per-minute topic limit of [mtl] topic calls in a given game minute")
				to_chat(src, span_danger("[msg]"))
				return

		var/stl = CONFIG_GET(number/second_topic_limit)
		if (stl)
			var/second = round(world.time, 1 SECONDS)
			if (!topiclimiter)
				topiclimiter = new(LIMITER_SIZE)
			if (second != topiclimiter[CURRENT_SECOND])
				topiclimiter[CURRENT_SECOND] = second
				topiclimiter[SECOND_COUNT] = 0
			topiclimiter[SECOND_COUNT] += 1
			if (topiclimiter[SECOND_COUNT] > stl)
				to_chat(src, span_danger("Your previous action was ignored because you've done too many in a second"))
				return

	//Logs all hrefs, except chat pings
	if(!(href_list["_src_"] == "chat" && href_list["proc"] == "ping" && LAZYLEN(href_list) == 2))
		log_href("[src] (usr:[usr]\[[COORD(usr)]\]) : [hsrc ? "[hsrc] " : ""][href]")

	//byond bug ID:2256651
	if (asset_cache_job && (asset_cache_job in completed_asset_jobs))
		to_chat(src, "<span class='danger'>An error has been detected in how my client is receiving resources. Attempting to correct.... (If you keep seeing these messages you might want to close byond and reconnect)</span>")
		src << browse("...", "window=asset_cache_browser")

	// Keypress passthrough
	if(href_list["__keydown"])
		var/keycode = browser_keycode_to_byond(href_list["__keydown"])
		if(keycode)
			keyDown(keycode)
		return
	if(href_list["__keyup"])
		var/keycode = browser_keycode_to_byond(href_list["__keyup"])
		if(keycode)
			keyUp(keycode)
		return

	// Admin PM
	if(href_list["priv_msg"])
		cmd_admin_pm(href_list["priv_msg"],null)
		return

	if(href_list["playerlist"])
		if(SSticker.current_state != GAME_STATE_FINISHED)
			return
		view_rogue_manifest()
		return

	if(href_list["commendsomeone"])
		commendation_popup(TRUE)
		return

	if(href_list["viewstats"])
		show_round_stats(href_list["featured_stat"])
		return

	if(href_list["viewinfluences"])
		show_influences()
		return

	switch(href_list["_src_"])
		if("holder")
			hsrc = holder
		if("usr")
			hsrc = mob
		if("prefs")
			if (inprefs)
				return
			inprefs = TRUE
			. = prefs.process_link(usr,href_list)
			inprefs = FALSE
			return
		if("vars")
			return view_var_Topic(href,href_list,hsrc)
		if("chat")
			return chatOutput.Topic(href, href_list)

	switch(href_list["action"])
		if("openLink")
			src << link(href_list["link"])

	if(hsrc)
		var/datum/real_src = hsrc
		if(QDELETED(real_src))
			return

	//fun fact: Topic() acts like a verb and is executed at the end of the tick like other verbs. So we have to queue it if the server is
	//overloaded
	if(hsrc && hsrc != holder && DEFAULT_TRY_QUEUE_VERB(VERB_CALLBACK(src, PROC_REF(_Topic), hsrc, href, href_list)))
		return

	..()	//redirect to hsrc.Topic()

/client/proc/set_right_click_menu_mode(ctrl_only)

	if(ctrl_only)
		winset(src, "mapwindow.map", "right-click=true")
		winset(src, "CtrlUp", "is-disabled=false")
		winset(src, "Ctrl", "is-disabled=false")
	else
		winset(src, "mapwindow.map", "right-click=false")
		winset(src, "default.Ctrl", "is-disabled=true")
		winset(src, "default.CtrlUp", "is-disabled=true")

/// Shows round end popup with all kind of statistics
/client/proc/show_round_stats(featured_stat)
	if(SSticker.current_state != GAME_STATE_FINISHED && !check_rights(R_ADMIN))
		return

	var/list/data = list()

	// Navigation buttons
	data += "<div style='width: 100%; text-align: center; margin: 15px 0;'>"
	data += "<a href='byond://?src=[REF(src)];viewstats=1' style='display: inline-block; width: 120px; padding: 8px 12px; margin: 0 10px; background: #2a2a2a; border: 1px solid #444; color: #ddd; font-weight: bold; text-decoration: none; border-radius: 3px; font-size: 0.9em;'>STATISTICS</a>"
	data += "<a href='byond://?src=[REF(src)];viewinfluences=1' style='display: inline-block; width: 120px; padding: 8px 12px; margin: 0 10px; background: #2a2a2a; border: 1px solid #444; color: #ddd; font-weight: bold; text-decoration: none; border-radius: 3px; font-size: 0.9em;'>INFLUENCES</a>"
	data += "</div>"

	// Featured stat setup
	var/current_featured = featured_stat
	if(!current_featured || !(current_featured in GLOB.featured_stats))
		current_featured = pick(GLOB.featured_stats)
	var/list/stat_keys = GLOB.featured_stats
	var/current_index = stat_keys.Find(current_featured)
	var/next_stat = stat_keys[(current_index % length(stat_keys)) + 1]
	var/prev_stat = stat_keys[current_index == 1 ? length(stat_keys) : (current_index - 1)]

	// Influential deities section
	var/max_influence = -INFINITY
	var/max_chosen = 0
	var/datum/storyteller/most_influential
	var/datum/storyteller/most_frequent

	for(var/storyteller_name in SSgamemode.storytellers)
		var/datum/storyteller/initialized_storyteller = SSgamemode.storytellers[storyteller_name]
		if(!initialized_storyteller)
			continue

		var/influence = SSgamemode.calculate_storyteller_influence(initialized_storyteller.type)
		if(influence > max_influence)
			max_influence = influence
			most_influential = initialized_storyteller

		if(initialized_storyteller.times_chosen > max_chosen)
			max_chosen = initialized_storyteller.times_chosen
			most_frequent = initialized_storyteller
		else if(initialized_storyteller.times_chosen == max_chosen)
			if(!most_frequent || influence > SSgamemode.calculate_storyteller_influence(most_frequent.type))
				most_frequent = initialized_storyteller
			else if(influence == SSgamemode.calculate_storyteller_influence(most_frequent.type) && prob(50))
				most_frequent = initialized_storyteller

	// Gods display
	data += "<div style='text-align: center; margin: 25px auto; width: 80%; max-width: 800px;'>"
	if(max_influence <= 0 && max_chosen <= 0)
		data += "<div style='font-size: 1.2em; font-weight: bold; margin-bottom: 12px;'>"
		data += "No <span style='color: #bd1717;'>Gods</span>, No <span style='color: #bd1717;'>Masters</span>"
		data += "</div>"
	else
		if(most_influential == most_frequent && max_influence > 0)
			data += "<div style='font-size: 1.2em; font-weight: bold; margin-bottom: 12px;'>"
			data += "The most dominant God was <span style='color:[most_influential.color_theme];'>[most_influential.name]</span>"
			data += "</div>"
		else
			if(max_influence > 0)
				data += "<div style='font-size: 1.2em; font-weight: bold; margin-bottom: 12px;'>"
				data += "The most influential God is <span style='color:[most_influential.color_theme];'>[most_influential.name]</span>"
				data += "</div>"
			if(max_chosen > 0)
				data += "<div style='font-size: 1.2em; font-weight: bold; margin-bottom: 12px;'>"
				data += "The longest reigning God was <span style='color:[most_frequent.color_theme];'>[most_frequent.name]</span>"
				data += "</div>"
	data += "<div style='border-top: 1.5px solid #444; margin: 15px auto; width: 100%;'></div>"
	data += "</div>"

	// Main stats container
	data += "<div style='display: table; width: 100%; border-spacing: 0; table-layout: fixed;'>"
	data += "<div style='display: table-row;'>"

	// Featured Statistics Column (30%)
	data += "<div style='display: table-cell; width: 30%; vertical-align: top; padding-right: 15px;'>"
	data += "<div style='height: 38px; text-align: center;'>"
	data += "<a href='byond://?src=[REF(src)];viewstats=1;featured_stat=[prev_stat]' style='color: #e6b327; text-decoration: none; font-weight: bold; margin-right: 10px; font-size: 1.2em;'>&#9664;</a>"
	data += "<span style='font-weight: bold; color: #bd1717;'>Featured Statistics</span>"
	data += "<a href='byond://?src=[REF(src)];viewstats=1;featured_stat=[next_stat]' style='color: #e6b327; text-decoration: none; font-weight: bold; margin-left: 10px; font-size: 1.2em;'>&#9654;</a>"
	data += "</div>"
	data += "<div style='border-top: 1px solid #444; width: 80%; margin: 0 auto 15px auto;'></div>"
	data += "<div style='text-align: center; margin-bottom: 5px;'>"
	data += "<font color='[GLOB.featured_stats[current_featured]["color"]]'><span class='bold'>[GLOB.featured_stats[current_featured]["name"]]</span></font>"
	data += "</div>"

	// Centered container with left-aligned content
	data += "<div style='text-align: center;'>"
	data += "<div style='display: inline-block; text-align: left; margin-left: auto; margin-right: auto;'>"

	var/stat_is_object = GLOB.featured_stats[current_featured]["object_stat"]
	var/has_entries = length(GLOB.featured_stats[current_featured]["entries"])

	if(has_entries)
		if(stat_is_object)
			data += format_top_stats_objects(current_featured)
		else
			data += format_top_stats(current_featured)
	else
		data += "<div style='margin-top: 20px;'>[stat_is_object ? "None" : "Nobody"]</div>"

	data += "</div>"
	data += "</div>"
	data += "</div>"

	// General Statistics Section (37%)
	data += "<div style='display: table-cell; width: 37%; vertical-align: top;'>"
	data += "<div style='height: 38px; text-align: center;'>"
	data += "<span style='font-weight: bold; color: #bd1717;'>General Statistics</span>"
	data += "</div>"
	data += "<div style='border-top: 1px solid #444; width: 80%; margin: 0 auto 15px auto;'></div>"
	data += "<div style='display: table; width: 100%;'>"
	data += "<div style='display: table-row;'>"

	// Left column
	data += "<div style='display: table-cell; width: 50%; vertical-align: top; border-left: 1px solid #444; padding: 0 10px;'>"
	data += "<font color='#9b6937'><span class='bold'>Total Deaths:</span></font> [GLOB.vanderlin_round_stats[STATS_DEATHS]]<br>"
	data += "<font color='#6b5ba1'><span class='bold'>Noble Deaths:</span></font> [GLOB.vanderlin_round_stats[STATS_NOBLE_DEATHS]]<br>"
	data += "<font color='#e6b327'><span class='bold'>Holy Revivals:</span></font> [GLOB.vanderlin_round_stats[STATS_ASTRATA_REVIVALS]]<br>"
	data += "<font color='#2dc5bd'><span class='bold'>Lux Revivals:</span></font> [GLOB.vanderlin_round_stats[STATS_LUX_REVIVALS]]<br>"
	data += "<font color='#825b1c'><span class='bold'>Moat Fallers:</span></font> [GLOB.vanderlin_round_stats[STATS_MOAT_FALLERS]]<br>"
	data += "<font color='#ac5d5d'><span class='bold'>Ankles Broken:</span></font> [GLOB.vanderlin_round_stats[STATS_ANKLES_BROKEN]]<br>"
	data += "<font color='#e6d927'><span class='bold'>People Smitten:</span></font> [GLOB.vanderlin_round_stats[STATS_PEOPLE_SMITTEN]]<br>"
	data += "<font color='#50aeb4'><span class='bold'>People Drowned:</span></font> [GLOB.vanderlin_round_stats[STATS_PEOPLE_DROWNED]]<br>"
	data += "<font color='#be8b37'><span class='bold'>Kleptomaniacs:</span></font> [GLOB.vanderlin_round_stats[STATS_KLEPTOMANIACS]]<br>"
	data += "<font color='#8f816b'><span class='bold'>Items Stolen:</span></font> [GLOB.vanderlin_round_stats[STATS_ITEMS_PICKPOCKETED]]<br>"
	data += "<font color='#c24bc2'><span class='bold'>Drugs Snorted:</span></font> [GLOB.vanderlin_round_stats[STATS_DRUGS_SNORTED]]<br>"
	data += "<font color='#90a037'><span class='bold'>Laughs Had:</span></font> [GLOB.vanderlin_round_stats[STATS_LAUGHS_MADE]]<br>"
	data += "<font color='#f5c02e'><span class='bold'>Taxes Collected:</span></font> [GLOB.vanderlin_round_stats[STATS_TAXES_COLLECTED]]<br>"
	data += "<font color='#5d44af'><span class='bold'>Slurs Spoken:</span></font> [GLOB.vanderlin_round_stats[STATS_SLURS_SPOKEN]]<br>"
	data += "</div>"

	// Right column
	data += "<div style='display: table-cell; width: 50%; vertical-align: top; padding: 0 10px;'>"
	data += "<font color='#36959c'><span class='bold'>Triumphs Awarded:</span></font> [GLOB.vanderlin_round_stats[STATS_TRIUMPHS_AWARDED]]<br>"
	data += "<font color='#a02fa4'><span class='bold'>Triumphs Stolen:</span></font> [GLOB.vanderlin_round_stats[STATS_TRIUMPHS_STOLEN] * -1]<br>"
	data += "<font color='#d7da2f'><span class='bold'>Prayers Made:</span></font> [GLOB.vanderlin_round_stats[STATS_PRAYERS_MADE]]<br>"
	data += "<font color='#bacfd6'><span class='bold'>Graves Consecrated:</span></font> [GLOB.vanderlin_round_stats[STATS_GRAVES_CONSECRATED]]<br>"
	data += "<font color='#9c3e46'><span class='bold'>Wandering Deadites:</span></font> [GLOB.vanderlin_round_stats[STATS_DEADITES_ALIVE]]<br>"
	data += "<font color='#0f555c'><span class='bold'>Beards Shaved:</span></font> [GLOB.vanderlin_round_stats[STATS_BEARDS_SHAVED]]<br>"
	data += "<font color='#6e7c81'><span class='bold'>Skills Learned:</span></font> [GLOB.vanderlin_round_stats[STATS_SKILLS_LEARNED]]<br>"
	data += "<font color='#23af4d'><span class='bold'>Plants Harvested:</span></font> [GLOB.vanderlin_round_stats[STATS_PLANTS_HARVESTED]]<br>"
	data += "<font color='#4492a5'><span class='bold'>Fish Caught:</span></font> [GLOB.vanderlin_round_stats[STATS_FISH_CAUGHT]]<br>"
	data += "<font color='#836033'><span class='bold'>Trees Felled:</span></font> [GLOB.vanderlin_round_stats[STATS_TREES_CUT]]<br>"
	data += "<font color='#af2323'><span class='bold'>Organs Eaten:</span></font> [GLOB.vanderlin_round_stats[STATS_ORGANS_EATEN]]<br>"
	data += "<font color='#afa623'><span class='bold'>Locks Picked:</span></font> [GLOB.vanderlin_round_stats[STATS_LOCKS_PICKED]]<br>"
	data += "<font color='#af2379'><span class='bold'>Kisses Made:</span></font> [GLOB.vanderlin_round_stats[STATS_KISSES_MADE]]<br>"
	data += "<font color='#c02ef5'><span class='bold'>H*nds H*ld:</span></font> [GLOB.vanderlin_round_stats[STATS_HANDS_HELD]]<br>"
	data += "</div>"
	data += "</div></div>"
	data += "</div>"

	// Census Section (33%)
	data += "<div style='display: table-cell; width: 33%; vertical-align: top;'>"
	data += "<div style='height: 38px; text-align: center;'>"
	data += "<span style='font-weight: bold; color: #bd1717;'>Census</span>"
	data += "</div>"
	data += "<div style='border-top: 1px solid #444; width: 80%; margin: 0 auto 15px auto;'></div>"
	data += "<div style='display: table; width: 100%;'>"
	data += "<div style='display: table-row;'>"

	// Left column
	data += "<div style='display: table-cell; width: 50%; vertical-align: top; border-left: 1px solid #444; padding: 0 10px;'>"
	data += "<font color='#8f1dc0'<span class='bold'>Ruler's Patron:</span></font> [GLOB.vanderlin_round_stats[STATS_MONARCH_PATRON]]<br>"
	data += "<font color='#4682B4'><span class='bold'>Total Populace:</span></font> [GLOB.vanderlin_round_stats[STATS_TOTAL_POPULATION]]<br>"
	data += "<font color='#ce4646'><span class='bold'>Nobility:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_NOBLES]]<br>"
	data += "<font color='#556B2F'><span class='bold'>Garrison:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_GARRISON]]<br>"
	data += "<font color='#DAA520'><span class='bold'>Clergy:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_CLERGY]]<br>"
	data += "<font color='#D2691E'><span class='bold'>Tradesmen:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_TRADESMEN]]<br>"
	data += "<font color='#eb76b0'><span class='bold'>Married:</span></font> [GLOB.vanderlin_round_stats[STATS_MARRIED]]<br>"
	data += "<font color='#6b89e0'><span class='bold'>Males:</span></font> [GLOB.vanderlin_round_stats[STATS_MALE_POPULATION]]<br>"
	data += "<font color='#d67daa'><span class='bold'>Females:</span></font> [GLOB.vanderlin_round_stats[STATS_FEMALE_POPULATION]]<br>"
	data += "<font color='#FFD700'><span class='bold'>Children:</span></font> [GLOB.vanderlin_round_stats[STATS_CHILD_POPULATION]]<br>"
	data += "<font color='#d0d67c'><span class='bold'>Adults:</span></font> [GLOB.vanderlin_round_stats[STATS_ADULT_POPULATION] + GLOB.vanderlin_round_stats[STATS_IMMORTAL_POPULATION]]<br>"
	data += "<font color='#a6ac6a'><span class='bold'>Middle-Aged:</span></font> [GLOB.vanderlin_round_stats[STATS_MIDDLEAGED_POPULATION]]<br>"
	data += "<font color='#C0C0C0'><span class='bold'>Elderly:</span></font> [GLOB.vanderlin_round_stats[STATS_ELDERLY_POPULATION]]<br>"
	data += "</div>"

	// Right column
	data += "<div style='display: table-cell; width: 50%; vertical-align: top; padding: 0 10px;'>"
	data += "<font color='#8B4513'><span class='bold'>Humens:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_NORTHERN_HUMANS]]<br>"
	data += "<font color='#808080'><span class='bold'>Dwarves:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_DWARVES]]<br>"
	data += "<font color='#87CEEB'><span class='bold'>Pure Elves:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_SNOW_ELVES]]<br>"
	data += "<font color='#9ACD32'><span class='bold'>Half-Elves:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_HALF_ELVES]]<br>"
	data += "<font color='#bd83cc'><span class='bold'>Half-Drows:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_HALF_DROWS]]<br>"
	data += "<font color='#7729af'><span class='bold'>Dark Elves:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_DARK_ELVES]]<br>"
	data += "<font color='#DC143C'><span class='bold'>Tieflings:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_TIEFLINGS]]<br>"
	data += "<font color='#228B22'><span class='bold'>Half-Orcs:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_HALF_ORCS]]<br>"
	data += "<font color='#CD853F'><span class='bold'>Kobolds:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_KOBOLDS]]<br>"
	data += "<font color='#FFD700'><span class='bold'>Raksharis:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_RAKSHARI]]<br>"
	data += "<font color='#e7e3d9'><span class='bold'>Aasimars:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_AASIMAR]]<br>"
	data += "<font color='#d49d7c'><span class='bold'>Hollowkins:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_HOLLOWKINS]]<br>"
	data += "<font color='#99dfd5'><span class='bold'>Harpies:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_HARPIES]]<br>"
	data += "</div>"

	data += "</div></div>"
	data += "</div>"

	data += "</div></div>"

	// Confessions section
	data += "<div style='text-align: center; margin: 25px auto; padding: 15px 0; border-top: 1.5px solid #444; width: 80%; max-width: 800px;'>"
	if(GLOB.confessors.len)
		data += "<font color='#93cac7'><span class='bold'>Confessions:</span></font> "
		for(var/x in GLOB.confessors)
			data += "[x]"
	else
		data += "<font color='#93cac7'><span class='bold'>No confessions!</span></font>"
	data += "</div>"

	src.mob << browse(null, "window=vanderlin_influences")
	var/datum/browser/popup = new(src.mob, "vanderlin_stats", "<center>End Round Statistics</center>", 1050, 745)
	popup.set_content(data.Join())
	popup.open()

/// Shows Gods influences menu
/client/proc/show_influences()
	if(SSticker.current_state != GAME_STATE_FINISHED && !check_rights(R_ADMIN))
		return

	var/list/data = list()

	// Navigation buttons
	data += "<div style='width: 91.5%; margin: 0 auto 30px; display: flex; justify-content: center; gap: 20px;'>"
	data += "<a href='byond://?src=[REF(src)];viewstats=1' style='padding: 12px 24px; background: #282828; border: 2px solid #404040; color: #d0d0d0; font-weight: bold; text-decoration: none; border-radius: 4px;'>STATISTICS</a>"
	data += "<a href='byond://?src=[REF(src)];viewinfluences=1' style='padding: 12px 24px; background: #282828; border: 2px solid #404040; color: #d0d0d0; font-weight: bold; text-decoration: none; border-radius: 4px;'>INFLUENCES</a>"
	data += "</div>"

	// Psydon Section
	var/psydonite_user = FALSE
	if(src.mob)
		if(isliving(src.mob))
			var/mob/living/living_user_mob = src.mob
			if(istype(living_user_mob.patron, /datum/patron/psydon))
				psydonite_user = TRUE

	var/psydon_followers = GLOB.patron_follower_counts["Psydon"] || 0
	var/largest_religion = (psydon_followers > 0)
	if(largest_religion)
		for(var/patron in GLOB.patron_follower_counts)
			if(patron == "Psydon")
				continue
			if(GLOB.patron_follower_counts[patron] >= psydon_followers)
				largest_religion = FALSE
				break
	var/apostasy_followers = GLOB.patron_follower_counts["Godless"] || 0
	var/psydonite_monarch = GLOB.vanderlin_round_stats[STATS_MONARCH_PATRON] == "Psydon" ? TRUE : FALSE
	var/psydon_influence = (psydon_followers * 20) + (GLOB.confessors.len * 20) + (GLOB.vanderlin_round_stats[STATS_HUMEN_DEATHS] * -10) + (GLOB.vanderlin_round_stats[STATS_ALIVE_TIEFLINGS] * -20) + (psydonite_monarch ? (psydonite_monarch * 500) : -250) + (largest_religion? (largest_religion * 500) : -250) + (GLOB.vanderlin_round_stats[STATS_PSYCROSS_USERS] * 10) + (apostasy_followers * -20) + (GLOB.vanderlin_round_stats[STATS_LUX_HARVESTED] * -50) + (psydonite_user ? 10000 : -10000)

	data += "<div style='width: 42.5%; margin: 0 auto 30px; border: 2px solid #99b2b1; background: #47636d; color: #d0d0d0; max-height: 420px;'>"
	data += "<div style='text-align: center; font-size: 1.3em; padding: 12px;'><b>PSYDON</b></div>"
	data += "<div style='padding: 0 15px 15px 15px;'>"
	data += "<div style='background: #1b1b2a; border-radius: 4px; padding: 12px;'>"
	data += "<div style='display: flex;'>"

	data += "<div style='flex: 1; padding-right: 10px;'>"
	data += "Number of followers: [psydon_followers] ([get_colored_influence_value(psydon_followers * 20)])<br>"
	data += "People wearing psycross: [GLOB.vanderlin_round_stats[STATS_PSYCROSS_USERS]] ([get_colored_influence_value(GLOB.vanderlin_round_stats[STATS_PSYCROSS_USERS] * 10)])<br>"
	data += "Number of confessions: [GLOB.confessors.len] ([get_colored_influence_value(GLOB.confessors.len * 20)])<br>"
	data += "Largest faith: [largest_religion ? "YES" : "NO"] ([get_colored_influence_value(largest_religion ? 500 : -250)])<br>"
	data += "Psydonite monarch: [psydonite_monarch ? "YES" : "NO"] ([get_colored_influence_value((psydonite_monarch ? (psydonite_monarch * 500) : -250))])<br>"
	data += "</div>"

	data += "<div style='flex: 1; padding-left: 60px;'>"
	data += "Number of apostates: [apostasy_followers] ([get_colored_influence_value(apostasy_followers * -20)])<br>"
	data += "Humen deaths: [GLOB.vanderlin_round_stats[STATS_HUMEN_DEATHS]] ([get_colored_influence_value(GLOB.vanderlin_round_stats[STATS_HUMEN_DEATHS] * -10)])<br>"
	data += "Lux harvested: [GLOB.vanderlin_round_stats[STATS_LUX_HARVESTED]] ([get_colored_influence_value(GLOB.vanderlin_round_stats[STATS_LUX_HARVESTED] * -50)])<br>"
	data += "Number of demonspawns: [GLOB.vanderlin_round_stats[STATS_ALIVE_TIEFLINGS]] ([get_colored_influence_value(GLOB.vanderlin_round_stats[STATS_ALIVE_TIEFLINGS] * -20)])<br>"
	data += "God's status: [psydonite_user ? "ALIVE" : "DEAD"] ([get_colored_influence_value(psydonite_user ? 10000 : -10000)])<br>"
	data += "</div>"

	data += "</div>"

	data += "<div style='border-top: 1px solid #444; margin: 12px 0 8px 0;'></div>"
	data += "<div style='text-align: center;'>Total Influence: [get_colored_influence_value(psydon_influence)]</div>"
	data += "</div></div></div>"

	// The Ten Section
	var/astrata_followers = GLOB.patron_follower_counts["Astrata"] || 0
	var/noc_followers = GLOB.patron_follower_counts["Noc"] || 0
	var/necra_followers = GLOB.patron_follower_counts["Necra"] || 0
	var/pestra_followers = GLOB.patron_follower_counts["Pestra"] || 0
	var/dendor_followers = GLOB.patron_follower_counts["Dendor"] || 0
	var/ravox_followers = GLOB.patron_follower_counts["Ravox"] || 0
	var/xylix_followers = GLOB.patron_follower_counts["Xylix"] || 0
	var/malum_followers = GLOB.patron_follower_counts["Malum"] || 0
	var/abyssor_followers = GLOB.patron_follower_counts["Abyssor"] || 0
	var/eora_followers = GLOB.patron_follower_counts["Eora"] || 0

	var/astrata_storyteller = /datum/storyteller/astrata
	var/noc_storyteller = /datum/storyteller/noc
	var/necra_storyteller = /datum/storyteller/necra
	var/pestra_storyteller = /datum/storyteller/pestra
	var/dendor_storyteller = /datum/storyteller/dendor
	var/ravox_storyteller = /datum/storyteller/ravox
	var/xylix_storyteller = /datum/storyteller/xylix
	var/malum_storyteller = /datum/storyteller/malum
	var/abyssor_storyteller = /datum/storyteller/abyssor
	var/eora_storyteller = /datum/storyteller/eora

	data += "<div style='text-align: center; font-size: 1.3em; color: #c0a828; margin: 20px 0 10px 0;'><b>THE TEN</b></div>"
	data += "<div style='border-top: 3px solid #404040; margin: 0 auto 30px; width: 91.5%;'></div>"

	data += "<div style='width: 91.5%; margin: 0 auto 40px;'>"
	data += "<div style='display: grid; grid-template-columns: repeat(5, 1fr); gap: 20px; margin-bottom: 30px;'>"

	// Astrata
	data += god_ui_block("ASTRATA", "#e7a962", "#642705", "\
		Number of followers: [astrata_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(astrata_storyteller))])<br>\
		Holy revivals: [GLOB.vanderlin_round_stats[STATS_ASTRATA_REVIVALS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(astrata_storyteller, STATS_ASTRATA_REVIVALS))])<br>\
		Number of nobles: [GLOB.vanderlin_round_stats[STATS_ALIVE_NOBLES]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(astrata_storyteller, STATS_ALIVE_NOBLES))])<br>\
		Noble deaths: [GLOB.vanderlin_round_stats[STATS_NOBLE_DEATHS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(astrata_storyteller, STATS_NOBLE_DEATHS))])<br>\
		Laws and decrees: [GLOB.vanderlin_round_stats[STATS_LAWS_AND_DECREES_MADE]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(astrata_storyteller, STATS_LAWS_AND_DECREES_MADE))])<br>\
		Slurs spoken: [GLOB.vanderlin_round_stats[STATS_SLURS_SPOKEN]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(astrata_storyteller, STATS_SLURS_SPOKEN))])", astrata_storyteller)

	// Dendor
	data += god_ui_block("DENDOR", "#412938", "#66745c", "\
		Number of followers: [dendor_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(dendor_storyteller))])<br>\
		Trees felled: [GLOB.vanderlin_round_stats[STATS_TREES_CUT]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(dendor_storyteller, STATS_TREES_CUT))])<br>\
		Plants harvested: [GLOB.vanderlin_round_stats[STATS_PLANTS_HARVESTED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(dendor_storyteller, STATS_PLANTS_HARVESTED))])<br>\
		Forest deaths: [GLOB.vanderlin_round_stats[STATS_FOREST_DEATHS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(dendor_storyteller, STATS_FOREST_DEATHS))])<br>\
		Number of verewolves: [GLOB.vanderlin_round_stats[STATS_WEREVOLVES]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(dendor_storyteller, STATS_WEREVOLVES))])<br>\
		Sacrifices to Dendor: [GLOB.vanderlin_round_stats[STATS_DENDOR_SACRIFICES]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(dendor_storyteller, STATS_DENDOR_SACRIFICES))])", dendor_storyteller)

	// Ravox
	data += god_ui_block("RAVOX", "#2c232d", "#710f0f", "\
		Number of followers: [ravox_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(ravox_storyteller))])<br>\
		Combat skills learned: [GLOB.vanderlin_round_stats[STATS_COMBAT_SKILLS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(ravox_storyteller, STATS_COMBAT_SKILLS))])<br>\
		Parries made: [GLOB.vanderlin_round_stats[STATS_PARRIES]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(ravox_storyteller, STATS_PARRIES))])<br>\
		Underworld duels: [GLOB.vanderlin_round_stats[STATS_UNDERWORLD_DUELS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(ravox_storyteller, STATS_UNDERWORLD_DUELS))])<br>\
		Warcries made: [GLOB.vanderlin_round_stats[STATS_WARCRIES]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(ravox_storyteller, STATS_WARCRIES))])<br>\
		Yields made: [GLOB.vanderlin_round_stats[STATS_YIELDS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(ravox_storyteller, STATS_YIELDS))])", ravox_storyteller)

	// Eora
	data += god_ui_block("EORA", "#a95063", "#e7c3da", "\
		Number of followers: [eora_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(eora_storyteller))])<br>\
		Marriages made: [GLOB.vanderlin_round_stats[STATS_MARRIAGES]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(eora_storyteller, STATS_MARRIAGES))])<br>\
		Number of parents: [GLOB.vanderlin_round_stats[STATS_PARENTS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(eora_storyteller, STATS_PARENTS))])<br>\
		Hugs made: [GLOB.vanderlin_round_stats[STATS_HUGS_MADE]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(eora_storyteller, STATS_HUGS_MADE))])<br>\
		H*nds h*ld: [GLOB.vanderlin_round_stats[STATS_HANDS_HELD]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(eora_storyteller, STATS_HANDS_HELD))])<br>\
		Number of pacifists: [GLOB.vanderlin_round_stats[STATS_PACIFISTS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(eora_storyteller, STATS_PACIFISTS))])", eora_storyteller)

	// Necra
	data += god_ui_block("NECRA", "#2a2459", "#4c82a8", "\
		Number of followers: [necra_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(necra_storyteller))])<br>\
		Total deaths: [GLOB.vanderlin_round_stats[STATS_DEATHS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(necra_storyteller, STATS_DEATHS))])<br>\
		Graves consecrated: [GLOB.vanderlin_round_stats[STATS_GRAVES_CONSECRATED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(necra_storyteller, STATS_GRAVES_CONSECRATED))])<br>\
		Graves robbed: [GLOB.vanderlin_round_stats[STATS_GRAVES_ROBBED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(necra_storyteller, STATS_GRAVES_ROBBED))])<br>\
		Deadites killed: [GLOB.vanderlin_round_stats[STATS_DEADITES_KILLED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(necra_storyteller, STATS_DEADITES_KILLED))])<br>\
		Vampires killed: [GLOB.vanderlin_round_stats[STATS_VAMPIRES_KILLED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(necra_storyteller, STATS_VAMPIRES_KILLED))])", necra_storyteller)

	data += "</div>"

	data += "<div style='display: grid; grid-template-columns: repeat(5, 1fr); gap: 20px;'>"

	// Noc
	data += god_ui_block("NOC", "#4e72a1", "#282137", "\
		Number of followers: [noc_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(noc_storyteller))])<br>\
		Books printed: [GLOB.vanderlin_round_stats[STATS_BOOKS_PRINTED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(noc_storyteller, STATS_BOOKS_PRINTED))])<br>\
		Literacy taught: [GLOB.vanderlin_round_stats[STATS_LITERACY_TAUGHT]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(noc_storyteller, STATS_LITERACY_TAUGHT))])<br>\
		Mana spent: [round(GLOB.vanderlin_round_stats[STATS_MANA_SPENT])] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(noc_storyteller, STATS_MANA_SPENT))])<br>\
		Number of illiterates: [GLOB.vanderlin_round_stats[STATS_ILLITERATES]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(noc_storyteller, STATS_ILLITERATES))])<br>\
		Skills dreamed: [GLOB.vanderlin_round_stats[STATS_SKILLS_DREAMED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(noc_storyteller, STATS_SKILLS_DREAMED))])", noc_storyteller)

	// Abyssor
	data += god_ui_block("ABYSSOR", "#50090f", "#bbace0", "\
		Number of followers: [abyssor_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(abyssor_storyteller))])<br>\
		Fish caught: [GLOB.vanderlin_round_stats[STATS_FISH_CAUGHT]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(abyssor_storyteller, STATS_FISH_CAUGHT))])<br>\
		Water consumed: [round(GLOB.vanderlin_round_stats[STATS_WATER_CONSUMED])] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(abyssor_storyteller, STATS_WATER_CONSUMED))])<br>\
		People drowned: [GLOB.vanderlin_round_stats[STATS_PEOPLE_DROWNED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(abyssor_storyteller, STATS_PEOPLE_DROWNED))])<br>\
		Abyssor remembered: [GLOB.vanderlin_round_stats[STATS_ABYSSOR_REMEMBERED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(abyssor_storyteller, STATS_ABYSSOR_REMEMBERED))])<br>\
		Leeches embedded: [GLOB.vanderlin_round_stats[STATS_LEECHES_EMBEDDED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(abyssor_storyteller, STATS_LEECHES_EMBEDDED))])", abyssor_storyteller)

	// Malum
	data += god_ui_block("MALUM", "#3d4139", "#955454", "\
		Number of followers: [malum_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(malum_storyteller))])<br>\
		Masterworks forged: [GLOB.vanderlin_round_stats[STATS_MASTERWORKS_FORGED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(malum_storyteller, STATS_MASTERWORKS_FORGED))])<br>\
		Rocks mined: [GLOB.vanderlin_round_stats[STATS_ROCKS_MINED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(malum_storyteller, STATS_ROCKS_MINED))])<br>\
		Blacksteel smelted: [GLOB.vanderlin_round_stats[STATS_BLACKSTEEL_SMELTED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(malum_storyteller, STATS_BLACKSTEEL_SMELTED))])<br>\
		Craft skills learned: [GLOB.vanderlin_round_stats[STATS_CRAFT_SKILLS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(malum_storyteller, STATS_CRAFT_SKILLS))])<br>\
		Beards shaved: [GLOB.vanderlin_round_stats[STATS_BEARDS_SHAVED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(malum_storyteller, STATS_BEARDS_SHAVED))])", malum_storyteller)

	// Xylix
	data += god_ui_block("XYLIX", "#7e632c", "#f6feff", "\
		Number of followers: [xylix_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(xylix_storyteller))])<br>\
		Laughs had: [GLOB.vanderlin_round_stats[STATS_LAUGHS_MADE]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(xylix_storyteller, STATS_LAUGHS_MADE))])<br>\
		Games rigged: [GLOB.vanderlin_round_stats[STATS_GAMES_RIGGED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(xylix_storyteller, STATS_GAMES_RIGGED))])<br>\
		Songs played: [GLOB.vanderlin_round_stats[STATS_SONGS_PLAYED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(xylix_storyteller, STATS_SONGS_PLAYED))])<br>\
		People mocked: [GLOB.vanderlin_round_stats[STATS_PEOPLE_MOCKED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(xylix_storyteller, STATS_PEOPLE_MOCKED))])<br>\
		Crits made: [GLOB.vanderlin_round_stats[STATS_CRITS_MADE]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(xylix_storyteller, STATS_CRITS_MADE))])", xylix_storyteller)

	// Pestra
	data += god_ui_block("PESTRA", "#517b27", "#1b2a2a", "\
		Number of followers: [pestra_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(pestra_storyteller))])<br>\
		Potions brewed: [GLOB.vanderlin_round_stats[STATS_POTIONS_BREWED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(pestra_storyteller, STATS_POTIONS_BREWED))])<br>\
		Wounds sewed up: [GLOB.vanderlin_round_stats[STATS_WOUNDS_SEWED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(pestra_storyteller, STATS_WOUNDS_SEWED))])<br>\
		Food rotted: [GLOB.vanderlin_round_stats[STATS_FOOD_ROTTED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(pestra_storyteller, STATS_FOOD_ROTTED))])<br>\
		Souls reincarnated: [GLOB.vanderlin_round_stats[STATS_SOULS_REINCARNATED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(pestra_storyteller, STATS_SOULS_REINCARNATED))])<br>\
		Animals bred: [GLOB.vanderlin_round_stats[STATS_ANIMALS_BRED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(pestra_storyteller, STATS_ANIMALS_BRED))])", pestra_storyteller)

	data += "</div></div>"

	// Inhumen Gods Section
	var/zizo_followers = GLOB.patron_follower_counts["Zizo"] || 0
	var/graggar_followers = GLOB.patron_follower_counts["Graggar"] || 0
	var/baotha_followers = GLOB.patron_follower_counts["Baotha"] || 0
	var/matthios_followers = GLOB.patron_follower_counts["Matthios"] || 0

	var/zizo_storyteller = /datum/storyteller/zizo
	var/graggar_storyteller = /datum/storyteller/graggar
	var/baotha_storyteller = /datum/storyteller/baotha
	var/matthios_storyteller = /datum/storyteller/matthios

	data += "<div style='text-align: center; font-size: 1.3em; color: #AA0000; margin: 20px 0 10px 0;'><b>INHUMEN GODS</b></div>"
	data += "<div style='border-top: 3px solid #404040; margin: 0 auto 30px; width: 91.5%;'></div>"

	data += "<div style='width: 91.5%; margin: 0 auto;'>"
	data += "<div style='display: grid; grid-template-columns: repeat(4, 1fr); grid-auto-rows: 1fr; gap: 20px; margin-bottom: 20px;'>"

	// Matthios
	data += god_ui_block("MATTHIOS", "#20202e", "#99b2b1", "\
		Number of followers: [matthios_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(matthios_storyteller))])<br>\
		Items pickpocketed: [GLOB.vanderlin_round_stats[STATS_ITEMS_PICKPOCKETED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(matthios_storyteller, STATS_ITEMS_PICKPOCKETED))])<br>\
		Locks picked: [GLOB.vanderlin_round_stats[STATS_LOCKS_PICKED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(matthios_storyteller, STATS_LOCKS_PICKED))])<br>\
		Dodges made: [GLOB.vanderlin_round_stats[STATS_DODGES]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(matthios_storyteller, STATS_DODGES))])<br>\
		Value offered to his idol: [GLOB.vanderlin_round_stats[STATS_SHRINE_VALUE]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(matthios_storyteller, STATS_SHRINE_VALUE))])<br>\
		Number of greedy people: [GLOB.vanderlin_round_stats[STATS_GREEDY_PEOPLE]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(matthios_storyteller, STATS_GREEDY_PEOPLE))])", matthios_storyteller)

	// Baotha
	data += god_ui_block("BAOTHA", "#46254a", "#e2abee", "\
		Number of followers: [baotha_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(baotha_storyteller))])<br>\
		Alcohol consumed: [round(GLOB.vanderlin_round_stats[STATS_ALCOHOL_CONSUMED])] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(baotha_storyteller, STATS_ALCOHOL_CONSUMED))])<br>\
		Drugs snorted: [GLOB.vanderlin_round_stats[STATS_DRUGS_SNORTED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(baotha_storyteller, STATS_DRUGS_SNORTED))])<br>\
		Luxurious food eaten: [GLOB.vanderlin_round_stats[STATS_LUXURIOUS_FOOD_EATEN]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(baotha_storyteller, STATS_LUXURIOUS_FOOD_EATEN))])<br>\
		Number of alcoholics: [GLOB.vanderlin_round_stats[STATS_ALCOHOLICS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(baotha_storyteller, STATS_ALCOHOLICS))])<br>\
		Number of junkies: [GLOB.vanderlin_round_stats[STATS_JUNKIES]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(baotha_storyteller, STATS_JUNKIES))])", baotha_storyteller)

	// Graggar
	data += god_ui_block("GRAGGAR", "#3b5e51", "#99bbc7", "\
		Number of followers: [graggar_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(graggar_storyteller))])<br>\
		Successful assasinations: [GLOB.vanderlin_round_stats[STATS_ASSASSINATIONS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(graggar_storyteller, STATS_ASSASSINATIONS))])<br>\
		Blood spilt: [round(GLOB.vanderlin_round_stats[STATS_BLOOD_SPILT] / 100)] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(graggar_storyteller, STATS_BLOOD_SPILT))])<br>\
		Limbs bitten: [GLOB.vanderlin_round_stats[STATS_LIMBS_BITTEN]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(graggar_storyteller, STATS_LIMBS_BITTEN))])<br>\
		Organs eaten: [GLOB.vanderlin_round_stats[STATS_ORGANS_EATEN]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(graggar_storyteller, STATS_ORGANS_EATEN))])<br>\
		People gibbed: [GLOB.vanderlin_round_stats[STATS_PEOPLE_GIBBED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(graggar_storyteller, STATS_PEOPLE_GIBBED))])", graggar_storyteller)

	// Zizo
	data += god_ui_block("ZIZO", "#661239", "#ed9da3", "\
		Number of followers: [zizo_followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(zizo_storyteller))])<br>\
		Zizo praised: [GLOB.vanderlin_round_stats[STATS_ZIZO_PRAISED]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(zizo_storyteller, STATS_ZIZO_PRAISED))])<br>\
		Deadites woken up: [GLOB.vanderlin_round_stats[STATS_DEADITES_WOKEN_UP]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(zizo_storyteller, STATS_DEADITES_WOKEN_UP))])<br>\
		Tortures performed: [GLOB.vanderlin_round_stats[STATS_TORTURES]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(zizo_storyteller, STATS_TORTURES))])<br>\
		Nobles killed: [GLOB.vanderlin_round_stats[STATS_NOBLE_DEATHS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(zizo_storyteller, STATS_NOBLE_DEATHS))])<br>\
		Clergy killed: [GLOB.vanderlin_round_stats[STATS_CLERGY_DEATHS]] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(zizo_storyteller, STATS_CLERGY_DEATHS))])", zizo_storyteller)

	data += "</div></div>"

	src.mob << browse(null, "window=vanderlin_stats")
	var/datum/browser/popup = new(src.mob, "vanderlin_influences", "<center>Gods influences</center>", 1325, 875)
	popup.set_content(data.Join())
	popup.open()

/// UI block to format information about storyteller god and his influences
/proc/god_ui_block(name, bg_color, title_color, content, datum/storyteller/storyteller)
	var/total_influence = SSgamemode.calculate_storyteller_influence(storyteller)
	var/datum/storyteller/initialized_storyteller = SSgamemode.storytellers[storyteller]
	if(!initialized_storyteller)
		return

	var/suffix = initialized_storyteller.bonus_points >= 0 ? "from wanting to rule" : "from long reign exhaustion"
	var/bonus_display = "<div>([get_colored_influence_value(round(initialized_storyteller.bonus_points))] [suffix])</div>"

	return {"
	<div style='border:6px solid [bg_color]; background:[bg_color]; border-radius:6px; height:100%';>
		<div style='font-weight:bold; font-size:1.2em; padding:8px; color:[title_color]'>[name]</div>
		<div style='padding:8px; background:#111; border-radius:0 0 4px 4px;'>
			<div style='margin-bottom:8px;'>[content]</div>
			<div style='border-top:1px solid #444; padding-top:6px;'>
				<div>Total Influence: [get_colored_influence_value(total_influence)]</div>
				[bonus_display]
			</div>
		</div>
	</div>
	"}

/// Colors resulting number depending on its value, with the operator attached
/proc/get_colored_influence_value(num)
	var/color
	var/display_num
	if(num > 0)
		color = "#00ff00"
		display_num = "+[round(num, 0.1)]"
	else if(num < 0)
		color = "#ff0000"
		display_num = "[round(num, 0.1)]"
	else
		color = "#ffff00"
		display_num = "+0"
	return "<font color='[color]'>[display_num]</font>"

/client/proc/commendation_popup(intentional = FALSE)
	if(SSticker.current_state != GAME_STATE_FINISHED)
		return
	if(commendedsomeone)
		return
	if(!intentional)
		if(browser_alert(src, "DOES ANY SOUL DESERVE COMMENDATION?", "THE CURTAINS CLOSE", reverseRange(DEFAULT_INPUT_CHOICES), 20 SECONDS) != CHOICE_YES)
			return
	var/list/selections = GLOB.character_ckey_list.Copy()
	if(!selections.len)
		return
	var/list/selection_w_title = list()
	var/list/human_mobs = GLOB.human_list.Copy()
	for(var/real_name in selections)
		var/ckey =  GLOB.character_ckey_list[real_name]
		var/mob/living/carbon/human/H
		for(var/mob/mob in human_mobs)
			if(mob?.real_name == real_name)
				H = mob
				break
		if(QDELETED(H) || !istype(H))
			selection_w_title[real_name] = ckey
		else
			selection_w_title["[real_name], [H.get_role_title()]"] = ckey
	if(!selection_w_title)
		ASYNC {
			browser_alert(src, "this dude really playing VANDERLIN all by themself lmfaoooo")
		}
	var/selection = browser_input_list(src, "WHO RECIEVES YOUR COMMENDATION?", null, shuffle(selection_w_title), pick(selection_w_title))
	if(!selection)
		return
	if(commendedsomeone)
		return
	var/theykey = selection_w_title[selection]
	if(theykey == ckey)
		ASYNC {
			browser_alert(src,"YOU MAY NOT COMMEND YOURSELF", "THE EGO")
		}
		return
	if(theykey)
		commendedsomeone = TRUE
		add_commend(theykey, ckey)
		to_chat(src, "You have COMMENDED [selection].")
		log_game("COMMEND: [ckey] commends [theykey].")
		log_admin("COMMEND: [ckey] commends [theykey].")
	return

///dumb workaround because byond doesnt seem to recognize the Topic() typepath for /datum/proc/Topic() from the client Topic,
///so we cant queue it without this
/client/proc/_Topic(datum/hsrc, href, list/href_list)
	return hsrc.Topic(href, href_list)

/client/proc/is_content_unlocked()
	if(!prefs.unlock_content)
		to_chat(src, "Become a BYOND member to access member-perks and features, as well as support the engine that makes this game possible. Only 10 bucks for 3 months! <a href=\"https://secure.byond.com/membership\">Click Here to find out more</a>.")
		return 0
	return 1
/*
 * Call back proc that should be checked in all paths where a client can send messages
 *
 * Handles checking for duplicate messages and people sending messages too fast
 *
 * The first checks are if you're sending too fast, this is defined as sending
 * SPAM_TRIGGER_AUTOMUTE messages in
 * 5 seconds, this will start supressing my messages,
 * if you send 2* that limit, you also get muted
 *
 * The second checks for the same duplicate message too many times and mutes
 * you for it
 */
/client/proc/handle_spam_prevention(message, mute_type)

	//Increment message count
	total_message_count += 1

	//store the total to act on even after a reset
	var/cache = total_message_count

	if(total_count_reset <= world.time)
		total_message_count = 0
		total_count_reset = world.time + (5 SECONDS)

	//If they're really going crazy, mute them
	if(cache >= SPAM_TRIGGER_AUTOMUTE * 2)
		total_message_count = 0
		total_count_reset = 0
		cmd_admin_mute(src, mute_type, 1)
		return 1

	//Otherwise just supress the message
	else if(cache >= SPAM_TRIGGER_AUTOMUTE)
		return 1


	if(CONFIG_GET(flag/automute_on) && !holder && last_message == message)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			to_chat(src, "<span class='danger'>I have exceeded the spam filter limit for identical messages. An auto-mute was applied.</span>")
			cmd_admin_mute(src, mute_type, 1)
			return 1
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			to_chat(src, "<span class='danger'>I are nearing the spam filter limit for identical messages.</span>")
			return 0
	else
		last_message = message
		src.last_message_count = 0
		return 0
/*
//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>")
		return 0
	return 1
*/

	///////////
	//CONNECT//
	///////////

/client/New(TopicData)
	var/tdata = TopicData //save this for later use
	chatOutput = new /datum/chatOutput(src)
	TopicData = null							//Prevent calls to client.Topic from connect

	if(connection != "seeker" && connection != "web")//Invalid connection type.
		return null

	GLOB.clients += src
	GLOB.directory[ckey] = src

	spawn() // Goonchat does some non-instant checks in start()
		chatOutput.start()

	GLOB.ahelp_tickets.ClientLogin(src)
	var/connecting_admin = FALSE //because de-admined admins connecting should be treated like admins.
	//Admin Authorisation
	holder = GLOB.admin_datums[ckey]

	if(holder)
		GLOB.admins |= src
		holder.owner = src
		connecting_admin = TRUE
	else if(GLOB.deadmins[ckey])
		verbs += /client/proc/readmin
		connecting_admin = TRUE
	if(CONFIG_GET(flag/autoadmin))
		if(!GLOB.admin_datums[ckey])
			var/datum/admin_rank/autorank
			for(var/datum/admin_rank/R in GLOB.admin_ranks)
				if(R.name == CONFIG_GET(string/autoadmin_rank))
					autorank = R
					break
			if(!autorank)
				to_chat(world, "Autoadmin rank not found")
			else
				new /datum/admins(autorank, ckey)
	if(CONFIG_GET(flag/enable_localhost_rank) && !connecting_admin)
		var/localhost_addresses = list("127.0.0.1", "::1")
		if(isnull(address) || (address in localhost_addresses))
			var/datum/admin_rank/localhost_rank = new("!localhost!", R_EVERYTHING, R_DBRANKS, R_EVERYTHING) //+EVERYTHING -DBRANKS *EVERYTHING
			new /datum/admins(localhost_rank, ckey, 1, 1)
	//preferences datum - also holds some persistent data for the client (because we may as well keep these datums to a minimum)
	prefs = GLOB.preferences_datums[ckey]
	if(prefs)
		prefs.parent = src
	else
		prefs = new /datum/preferences(src)
		GLOB.preferences_datums[ckey] = prefs
	if(!holder)
		prefs.chat_toggles &= ~CHAT_GHOSTEARS
		prefs.chat_toggles &= ~CHAT_GHOSTWHISPER
		prefs.save_preferences()
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning
	fps = prefs.clientfps

	if(fexists(roundend_report_file()))
		verbs += /client/proc/show_previous_roundend_report

	var/full_version = "[byond_version].[byond_build ? byond_build : "xxx"]"
	log_access("Login: [key_name(src)] from [address ? address : "localhost"]-[computer_id] || BYOND v[full_version]")

	var/alert_mob_dupe_login = FALSE
	if(CONFIG_GET(flag/log_access))
		for(var/I in GLOB.clients)
			if(!I || I == src)
				continue
			var/client/C = I
			if(holder && C.holder)
				if(check_rights_for(C, R_ADMIN))
					to_chat(C, "Admin Login: [key]")
			if(C.key && (C.key != key) )
				var/matches
				if( (C.address == address) )
					matches += "IP ([address])"
				if( (C.computer_id == computer_id) )
					if(matches)
						matches += " and "
					matches += "ID ([computer_id])"
					alert_mob_dupe_login = TRUE
				if(matches)
					if(C)
						message_admins("<span class='danger'><B>Notice: </B></span><span class='notice'>[key_name_admin(src)] has the same [matches] as [key_name_admin(C)].</span>")
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(C)].")
					else
						message_admins("<span class='danger'><B>Notice: </B></span><span class='notice'>[key_name_admin(src)] has the same [matches] as [key_name_admin(C)] (no longer logged in). </span>")
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(C)] (no longer logged in).")

	show_popup_menus = FALSE

	if(holder)
		show_popup_menus = TRUE

	set_right_click_menu_mode(TRUE)

	var/reconnecting = FALSE
	if(GLOB.player_details[ckey])
		reconnecting = TRUE
		player_details = GLOB.player_details[ckey]
		player_details.byond_version = full_version
		player_details.byond_build = byond_build
	else
		player_details = new(ckey)
		player_details.byond_version = full_version
		player_details.byond_build = byond_build
		GLOB.player_details[ckey] = player_details


	. = ..()	//calls mob.Login()
	if (length(GLOB.stickybanadminexemptions))
		GLOB.stickybanadminexemptions -= ckey
		if (!length(GLOB.stickybanadminexemptions))
			restore_stickybans()

	if (byond_version >= 512)
		if (!byond_build || byond_build < 1386)
			message_admins("<span class='adminnotice'>[key_name(src)] has been detected as spoofing their byond version. Connection rejected.</span>")
			add_system_note("Spoofed-Byond-Version", "Detected as using a spoofed byond version.")
			log_access("Failed Login: [key] - Spoofed byond version")
			qdel(src)

		if (num2text(byond_build) in GLOB.blacklisted_builds)
			log_access("Failed login: [key] - blacklisted byond version")
			to_chat(src, "<span class='danger'>My version of byond is blacklisted.</span>")
			to_chat(src, "<span class='danger'>Byond build [byond_build] ([byond_version].[byond_build]) has been blacklisted for the following reason: [GLOB.blacklisted_builds[num2text(byond_build)]].</span>")
			to_chat(src, "<span class='danger'>Please download a new version of byond. If [byond_build] is the latest, you can go to <a href=\"https://secure.byond.com/download/build\">BYOND's website</a> to download other versions.</span>")
			if(connecting_admin)
				to_chat(src, "As an admin, you are being allowed to continue using this version, but please consider changing byond versions")
			else
				qdel(src)
				return

	if(SSinput.initialized)
		set_macros()
		update_movement_keys()

//	chatOutput.start() // Starts the chat

	if(alert_mob_dupe_login)
		spawn()
			alert(mob, "You have logged in already with another key this round, please log out of this one NOW or risk being banned!")

	connection_time = world.time
	connection_realtime = world.realtime
	connection_timeofday = world.timeofday
	winset(src, null, "command=\".configure graphics-hwmode on\"")
	var/cev = CONFIG_GET(number/client_error_version)
	var/ceb = CONFIG_GET(number/client_error_build)
	var/cwv = CONFIG_GET(number/client_warn_version)
	if (byond_version < cev || byond_build < ceb)		//Out of date client.
		to_chat(src, "<span class='danger'><b>My version of BYOND is too old:</b></span>")
		to_chat(src, CONFIG_GET(string/client_error_message))
		to_chat(src, "Your version: [byond_version].[byond_build]")
		to_chat(src, "Required version: [cev].[ceb] or later")
		to_chat(src, "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")
		if (connecting_admin)
			to_chat(src, "Because you are an admin, you are being allowed to walk past this limitation, But it is still STRONGLY suggested you upgrade")
		else
			qdel(src)
			return 0
	else if (byond_version < cwv)	//We have words for this client.
		if(CONFIG_GET(flag/client_warn_popup))
			var/msg = "<b>My version of byond may be getting out of date:</b><br>"
			msg += CONFIG_GET(string/client_warn_message) + "<br><br>"
			msg += "Your version: [byond_version]<br>"
			msg += "Required version to remove this message: [cwv] or later<br>"
			msg += "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.<br>"
			src << browse(msg, "window=warning_popup")
		else
			to_chat(src, "<span class='danger'><b>My version of byond may be getting out of date:</b></span>")
			to_chat(src, CONFIG_GET(string/client_warn_message))
			to_chat(src, "Your version: [byond_version]")
			to_chat(src, "Required version to remove this message: [cwv] or later")
			to_chat(src, "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")

	if (connection == "web" && !connecting_admin)
		if (!CONFIG_GET(flag/allow_webclient))
			to_chat(src, "Web client is disabled")
			qdel(src)
			return 0
		if (CONFIG_GET(flag/webclient_only_byond_members) && !IsByondMember())
			to_chat(src, "Sorry, but the web client is restricted to byond members only.")
			qdel(src)
			return 0

	if( (world.address == address || !address) && !GLOB.host )
		GLOB.host = key
		world.update_status()

	if(holder)
		add_admin_verbs()
		to_chat(src, get_message_output("memo"))
		adminGreet()
	if (mob && reconnecting)
		var/area/joined_area = get_area(mob.loc)
		if(joined_area)
			joined_area.reconnect_game(mob)

	add_verbs_from_config()
	var/cached_player_age = set_client_age_from_db(tdata) //we have to cache this because other shit may change it and we need it's current value now down below.
	if (isnum(cached_player_age) && cached_player_age == -1) //first connection
		player_age = 0
	var/nnpa = CONFIG_GET(number/notify_new_player_age)
	if (isnum(cached_player_age) && cached_player_age == -1) //first connection
		if (nnpa >= 0)
			message_admins("New user: [key_name_admin(src)] [ADMIN_PP(mob)] is connecting here for the first time.")
			if (CONFIG_GET(flag/irc_first_connection_alert))
				send2irc_adminless_only("New-user", "[key_name(src)] is connecting for the first time!")
	else if (isnum(cached_player_age) && cached_player_age < nnpa)
		message_admins("New user: [key_name_admin(src)] just connected with an age of [cached_player_age] day[(player_age==1?"":"s")]")
	if(CONFIG_GET(flag/use_account_age_for_jobs) && account_age >= 0)
		player_age = account_age
	if(account_age >= 0 && account_age < nnpa)
		message_admins("[key_name_admin(src)] (IP: [address], ID: [computer_id]) is a new BYOND account [account_age] day[(account_age==1?"":"s")] old, created on [account_join_date].")
		if (CONFIG_GET(flag/irc_first_connection_alert))
			send2irc_adminless_only("new_byond_user", "[key_name(src)] (IP: [address], ID: [computer_id]) is a new BYOND account [account_age] day[(account_age==1?"":"s")] old, created on [account_join_date].")
	get_message_output("watchlist entry", ckey)
	check_overwatch()
	validate_key_in_db()

	// If we aren't already generating a ban cache, fire off a build request
	// This way hopefully any users of request_ban_cache will never need to yield
	if(!ban_cache_start && SSban_cache?.query_started)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(build_ban_cache), src)

//	send_resources()


	generate_clickcatcher()
	apply_clickcatcher()

	if(prefs.toggles & TOGGLE_FULLSCREEN)
		toggle_fullscreeny(TRUE)
	else
		toggle_fullscreeny(FALSE)

	if(ckey in GLOB.clientmessages)
		for(var/message in GLOB.clientmessages[ckey])
			to_chat(src, message)
		GLOB.clientmessages.Remove(ckey)

	if(CONFIG_GET(flag/autoconvert_notes))
		convert_notes_sql(ckey)


	to_chat(src, get_message_output("message", ckey))



//	if(!winexists(src, "asset_cache_browser")) // The client is using a custom skin, tell them.
//		to_chat(src, "<span class='warning'>Unable to access asset cache browser, if you are using a custom skin file, please allow DS to download the updated version, if you are not, then make a bug report. This is not a critical issue but can cause issues with resource downloading, as it is impossible to know when extra resources arrived to you.</span>")

	update_ambience_pref()


	//This is down here because of the browse() calls in tooltip/New()
	if(!tooltips)
		tooltips = new /datum/tooltip(src)

	var/list/topmenus = GLOB.menulist[/datum/verbs/menu]
	for (var/thing in topmenus)
		var/datum/verbs/menu/topmenu = thing
		var/topmenuname = "[topmenu]"
		if (topmenuname == "[topmenu.type]")
			var/list/tree = splittext(topmenuname, "/")
			topmenuname = tree[tree.len]
		winset(src, "[topmenu.type]", "parent=menu;name=[url_encode(topmenuname)]")
		var/list/entries = topmenu.Generate_list(src)
		for (var/child in entries)
			winset(src, "[child]", "[entries[child]]")
			if (!ispath(child, /datum/verbs/menu))
				var/procpath/verbpath = child
				if (copytext(verbpath.name,1,2) != "@")
					new child(src)

	for (var/thing in prefs.menuoptions)
		var/datum/verbs/menu/menuitem = GLOB.menulist[thing]
		if (menuitem)
			menuitem.Load_checked(src)

	Master.UpdateTickRate()

//////////////
//DISCONNECT//
//////////////

/client/Del()
	log_access("Logout: [key_name(src)]")

	if(holder)
		for(var/I in GLOB.clients)
			if(!I || I == src)
				continue
			var/client/C = I
			if(C.holder)
				if(check_rights_for(C, R_ADMIN))
					to_chat(C, "Admin Logout: [ckey]")
		adminGreet(1)
		holder.owner = null
		GLOB.admins -= src
/*		if (!GLOB.admins.len && SSticker.IsRoundInProgress()) //Only report this stuff if we are currently playing.
			var/cheesy_message = pick(
				"I have no admins online!",\
				"I'm all alone :(",\
				"I'm feeling lonely :(",\
				"I'm so lonely :(",\
				"Why does nobody love me? :(",\
				"I want a man :(",\
				"Where has everyone gone?",\
				"I need a hug :(",\
				"Someone come hold me :(",\
				"I need someone on me :(",\
				"What happened? Where has everyone gone?",\
				"Forever alone :("\
			)

//			send2irc("Server", "[cheesy_message] (No admins online)")
*/
	if(player_details)
		player_details.achievements.save()

	GLOB.ahelp_tickets.ClientLogout(src)
	GLOB.directory -= ckey
	GLOB.clients -= src
	QDEL_LIST_ASSOC_VAL(char_render_holders)
	if(movingmob != null)
		movingmob.client_mobs_in_contents -= mob
		UNSETEMPTY(movingmob.client_mobs_in_contents)
	Master.UpdateTickRate()
	return ..()

/client/Destroy()
	. = ..() //Even though we're going to be hard deleted there are still some things that want to know the destroy is happening
	QDEL_NULL(droning_sound)
	last_droning_sound = null
	return QDEL_HINT_HARDDEL_NOW

/client/proc/set_client_age_from_db(connectiontopic)
	if (IsGuestKey(src.key))
		return
	if(!SSdbcore.Connect())
		return
	var/datum/DBQuery/query_get_related_ip = SSdbcore.NewQuery(
		"SELECT ckey FROM [format_table_name("player")] WHERE ip = INET_ATON(:address) AND ckey != :ckey",
		list("address" = address, "ckey" = ckey)
	)
	if(!query_get_related_ip.Execute())
		qdel(query_get_related_ip)
		return
	related_accounts_ip = ""
	while(query_get_related_ip.NextRow())
		related_accounts_ip += "[query_get_related_ip.item[1]], "
	qdel(query_get_related_ip)
	var/datum/DBQuery/query_get_related_cid = SSdbcore.NewQuery(
		"SELECT ckey FROM [format_table_name("player")] WHERE computerid = :computerid AND ckey != :ckey",
		list("computerid" = computer_id, "ckey" = ckey)
	)
	if(!query_get_related_cid.Execute())
		qdel(query_get_related_cid)
		return
	related_accounts_cid = ""
	while (query_get_related_cid.NextRow())
		related_accounts_cid += "[query_get_related_cid.item[1]], "
	qdel(query_get_related_cid)
	var/admin_rank = "Player"
	if (src.holder && src.holder.rank)
		admin_rank = src.holder.rank.name
	else
		if (!GLOB.deadmins[ckey] && check_randomizer(connectiontopic))
			return

	var/new_player
	var/datum/DBQuery/query_client_in_db = SSdbcore.NewQuery(
		"SELECT 1 FROM [format_table_name("player")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	if(!query_client_in_db.Execute())
		qdel(query_client_in_db)
		return
	if(!query_client_in_db.NextRow())
		if (CONFIG_GET(flag/panic_bunker) && !holder && !GLOB.deadmins[ckey])
			log_access("Failed Login: [key] - New account attempting to connect during panic bunker")
			message_admins("<span class='adminnotice'>Failed Login: [key] - New account attempting to connect during panic bunker</span>")
			to_chat(src, CONFIG_GET(string/panic_bunker_message))
			var/list/connectiontopic_a = params2list(connectiontopic)
			var/list/panic_addr = CONFIG_GET(string/panic_server_address)
			if(panic_addr && !connectiontopic_a["redirect"])
				var/panic_name = CONFIG_GET(string/panic_server_name)
				to_chat(src, "<span class='notice'>Sending you to [panic_name ? panic_name : panic_addr].</span>")
				winset(src, null, "command=.options")
				src << link("[panic_addr]?redirect=1")
			qdel(query_client_in_db)
			qdel(src)
			return

		new_player = 1
		account_join_date = findJoinDate()
		var/datum/DBQuery/query_add_player = SSdbcore.NewQuery({"
			INSERT INTO [format_table_name("player")] (`ckey`, `byond_key`, `firstseen`, `firstseen_round_id`, `lastseen`, `lastseen_round_id`, `ip`, `computerid`, `lastadminrank`, `accountjoindate`)
			VALUES (:ckey, :key, Now(), :round_id, Now(), :round_id, INET_ATON(:ip), :computerid, :adminrank, :account_join_date)
		"}, list("ckey" = ckey, "key" = key, "round_id" = GLOB.round_id, "ip" = address, "computerid" = computer_id, "adminrank" = admin_rank, "account_join_date" = account_join_date || null))
		if(!query_add_player.Execute())
			qdel(query_client_in_db)
			qdel(query_add_player)
			return
		qdel(query_add_player)
		if(!account_join_date)
			account_join_date = "Error"
			account_age = -1
	qdel(query_client_in_db)
	var/datum/DBQuery/query_get_client_age = SSdbcore.NewQuery(
		"SELECT firstseen, DATEDIFF(Now(),firstseen), accountjoindate, DATEDIFF(Now(),accountjoindate) FROM [format_table_name("player")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	if(!query_get_client_age.Execute())
		qdel(query_get_client_age)
		return
	if(query_get_client_age.NextRow())
		player_join_date = query_get_client_age.item[1]
		player_age = text2num(query_get_client_age.item[2])
		if(!account_join_date)
			account_join_date = query_get_client_age.item[3]
			account_age = text2num(query_get_client_age.item[4])
			if(!account_age)
				account_join_date = findJoinDate()
				if(!account_join_date)
					account_age = -1
				else
					var/datum/DBQuery/query_datediff = SSdbcore.NewQuery(
						"SELECT DATEDIFF(Now(), :account_join_date)",
						list("account_join_date" = account_join_date)
					)
					if(!query_datediff.Execute())
						qdel(query_datediff)
						return
					if(query_datediff.NextRow())
						account_age = text2num(query_datediff.item[1])
					qdel(query_datediff)
	qdel(query_get_client_age)
	if(!new_player)
		var/datum/DBQuery/query_log_player = SSdbcore.NewQuery(
			"UPDATE [format_table_name("player")] SET lastseen = Now(), lastseen_round_id = :round_id, ip = INET_ATON(:ip), computerid = :computerid, lastadminrank = :admin_rank, accountjoindate = :account_join_date WHERE ckey = :ckey",
			list("round_id" = GLOB.round_id, "ip" = address, "computerid" = computer_id, "admin_rank" = admin_rank, "account_join_date" = account_join_date || null, "ckey" = ckey)
		)
		if(!query_log_player.Execute())
			qdel(query_log_player)
			return
		qdel(query_log_player)
	if(!account_join_date)
		account_join_date = "Error"
	var/datum/DBQuery/query_log_connection = SSdbcore.NewQuery({"
		INSERT INTO `[format_table_name("connection_log")]` (`id`,`datetime`,`server_ip`,`server_port`,`round_id`,`ckey`,`ip`,`computerid`)
		VALUES(null,Now(),INET_ATON(:internet_address),:port,:round_id,:ckey,INET_ATON(:ip),:computerid)
	"}, list("internet_address" = world.internet_address || "0", "port" = world.port, "round_id" = GLOB.round_id, "ckey" = ckey, "ip" = address, "computerid" = computer_id))
	query_log_connection.Execute()
	qdel(query_log_connection)
	if(new_player)
		player_age = -1
	. = player_age

/client/proc/toggle_fullscreeny(new_value)
	if(new_value)
		winset(src, "mainwindow", "is-maximized=false;can-resize=false;titlebar=false;menu=menu")
	else
		winset(src, "mainwindow", "is-maximized=false;can-resize=true;titlebar=true;menu=menu")
	winset(src, "mainwindow", "is-maximized=true")

/client/proc/log_client_to_db_connection_log()
	if(!SSdbcore.shutting_down)
		SSdbcore.FireAndForget({"
			INSERT INTO `[format_table_name("connection_log")]` (`id`,`datetime`,`server_ip`,`server_port`,`round_id`,`ckey`,`ip`,`computerid`,`byond_version`,`byond_build`)
			VALUES(null,Now(),INET_ATON(:internet_address),:port,:round_id,:ckey,INET_ATON(:ip),:computerid,:byond_version,:byond_build)
		"}, list("internet_address" = world.internet_address || "0", "port" = world.port, "round_id" = GLOB.round_id, "ckey" = ckey, "ip" = address, "computerid" = computer_id, "byond_version" = byond_version, "byond_build" = byond_build))

/client/proc/findJoinDate()
	var/list/http = world.Export("http://www.byond.com/members/[ckey]?format=text")
	if(!http)
		log_world("Failed to connect to byond member page to age check [ckey]")
		return
	var/F = file2text(http["CONTENT"])
	if(F)
		var/regex/R = regex("joined = \"(\\d{4}-\\d{2}-\\d{2})\"")
		if(R.Find(F))
			. = R.group[1]
		else
			CRASH("Age check regex failed for [src.ckey]")

/client/proc/validate_key_in_db()
	var/sql_key
	var/datum/DBQuery/query_check_byond_key = SSdbcore.NewQuery(
		"SELECT byond_key FROM [format_table_name("player")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	if(!query_check_byond_key.Execute())
		qdel(query_check_byond_key)
		return
	if(query_check_byond_key.NextRow())
		sql_key = query_check_byond_key.item[1]
	qdel(query_check_byond_key)
	if(key != sql_key)
		var/list/http = world.Export("http://byond.com/members/[ckey]?format=text")
		if(!http)
			log_world("Failed to connect to byond member page to get changed key for [ckey]")
			return
		var/F = file2text(http["CONTENT"])
		if(F)
			var/regex/R = regex("\\tkey = \"(.+)\"")
			if(R.Find(F))
				var/web_key = R.group[1]
				var/datum/DBQuery/query_update_byond_key = SSdbcore.NewQuery(
					"UPDATE [format_table_name("player")] SET byond_key = :byond_key WHERE ckey = :ckey",
					list("byond_key" = web_key, "ckey" = ckey)
				)
				query_update_byond_key.Execute()
				qdel(query_update_byond_key)
			else
				CRASH("Key check regex failed for [ckey]")

/client/proc/update_ambience_pref()
	if(prefs.toggles & SOUND_AMBIENCE)
		if(SSambience.ambience_listening_clients[src] > world.time)
			return // If already properly set we don't want to reset the timer.
		SSambience.ambience_listening_clients[src] = world.time + 10 SECONDS //Just wait 10 seconds before the next one aight mate? cheers.
	else
		SSambience.remove_ambience_client(src)

/client/proc/check_randomizer(topic)
	. = FALSE
	if (connection != "seeker")
		return
	topic = params2list(topic)
	if (!CONFIG_GET(flag/check_randomizer))
		return
	var/static/cidcheck = list()
	var/static/tokens = list()
	var/static/cidcheck_failedckeys = list() //to avoid spamming the admins if the same guy keeps trying.
	var/static/cidcheck_spoofckeys = list()

	var/datum/DBQuery/query_cidcheck = SSdbcore.NewQuery(
		"SELECT computerid FROM [format_table_name("player")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	query_cidcheck.Execute()

	var/lastcid
	if (query_cidcheck.NextRow())
		lastcid = query_cidcheck.item[1]
	qdel(query_cidcheck)
	var/oldcid = cidcheck[ckey]

	if (oldcid)
		if (!topic || !topic["token"] || !tokens[ckey] || topic["token"] != tokens[ckey])
			if (!cidcheck_spoofckeys[ckey])
				message_admins("<span class='adminnotice'>[key_name(src)] appears to have attempted to spoof a cid randomizer check.</span>")
				cidcheck_spoofckeys[ckey] = TRUE
			cidcheck[ckey] = computer_id
			tokens[ckey] = cid_check_reconnect()

			sleep(15 SECONDS) //Longer sleep here since this would trigger if a client tries to reconnect manually because the inital reconnect failed

			//we sleep after telling the client to reconnect, so if we still exist something is up
			log_access("Forced disconnect: [key] [computer_id] [address] - CID randomizer check")

			qdel(src)
			return TRUE

		if (oldcid != computer_id && computer_id != lastcid) //IT CHANGED!!!
			cidcheck -= ckey //so they can try again after removing the cid randomizer.

			to_chat(src, "<span class='danger'>Connection Error:</span>")
			to_chat(src, "<span class='danger'>Invalid ComputerID(spoofed). Please remove the ComputerID spoofer from my byond installation and try again.</span>")

			if (!cidcheck_failedckeys[ckey])
				message_admins("<span class='adminnotice'>[key_name(src)] has been detected as using a cid randomizer. Connection rejected.</span>")
				send2irc_adminless_only("CidRandomizer", "[key_name(src)] has been detected as using a cid randomizer. Connection rejected.")
				cidcheck_failedckeys[ckey] = TRUE
				note_randomizer_user()

			log_access("Failed Login: [key] [computer_id] [address] - CID randomizer confirmed (oldcid: [oldcid])")

			qdel(src)
			return TRUE
		else
			if (cidcheck_failedckeys[ckey])
				message_admins("<span class='adminnotice'>[key_name_admin(src)] has been allowed to connect after showing they removed their cid randomizer</span>")
				send2irc_adminless_only("CidRandomizer", "[key_name(src)] has been allowed to connect after showing they removed their cid randomizer.")
				cidcheck_failedckeys -= ckey
			if (cidcheck_spoofckeys[ckey])
				message_admins("<span class='adminnotice'>[key_name_admin(src)] has been allowed to connect after appearing to have attempted to spoof a cid randomizer check because it <i>appears</i> they aren't spoofing one this time</span>")
				cidcheck_spoofckeys -= ckey
			cidcheck -= ckey
	else if (computer_id != lastcid)
		cidcheck[ckey] = computer_id
		tokens[ckey] = cid_check_reconnect()

		sleep(5 SECONDS) //browse is queued, we don't want them to disconnect before getting the browse() command.

		//we sleep after telling the client to reconnect, so if we still exist something is up
		log_access("Forced disconnect: [key] [computer_id] [address] - CID randomizer check")

		qdel(src)
		return TRUE

/client/proc/cid_check_reconnect()
	var/token = md5("[rand(0,9999)][world.time][rand(0,9999)][ckey][rand(0,9999)][address][rand(0,9999)][computer_id][rand(0,9999)]")
	. = token
	log_access("Failed Login: [key] [computer_id] [address] - CID randomizer check")
	var/url = winget(src, null, "url")
	//special javascript to make them reconnect under a new window.
	src << browse({"<a id='link' href="byond://[url]?token=[token]">byond://[url]?token=[token]</a><script type="text/javascript">document.getElementById("link").click();window.location="byond://winset?command=.quit"</script>"}, "border=0;titlebar=0;size=1x1;window=redirect")
	to_chat(src, {"<a href="byond://[url]?token=[token]">I will be automatically taken to the game, if not, click here to be taken manually</a>"})

/client/proc/note_randomizer_user()
	add_system_note("CID-Error", "Detected as using a cid randomizer.")

/client/proc/add_system_note(system_ckey, message)

	//check to see if we noted them in the last day.
	var/datum/DBQuery/query_get_notes = SSdbcore.NewQuery(
		"SELECT id FROM [format_table_name("messages")] WHERE type = 'note' AND targetckey = :targetckey AND adminckey = :adminckey AND timestamp + INTERVAL 1 DAY < NOW() AND deleted = 0 AND (expire_timestamp > NOW() OR expire_timestamp IS NULL)",
		list("targetckey" = ckey, "adminckey" = system_ckey)
	)
	if(!query_get_notes.Execute())
		qdel(query_get_notes)
		return
	if(query_get_notes.NextRow())
		qdel(query_get_notes)
		return
	qdel(query_get_notes)
	//regardless of above, make sure their last note is not from us, as no point in repeating the same note over and over.
	query_get_notes = SSdbcore.NewQuery(
		"SELECT adminckey FROM [format_table_name("messages")] WHERE targetckey = :targetckey AND deleted = 0 AND (expire_timestamp > NOW() OR expire_timestamp IS NULL) ORDER BY timestamp DESC LIMIT 1",
		list("targetckey" = ckey)
	)
	if(!query_get_notes.Execute())
		qdel(query_get_notes)
		return
	if(query_get_notes.NextRow())
		if (query_get_notes.item[1] == system_ckey)
			qdel(query_get_notes)
			return
	qdel(query_get_notes)
	create_message("note", key, system_ckey, message, null, null, 0, 0, null, 0, 0)


/client/proc/check_overwatch()
	var/failed = FALSE
	SSoverwatch.CollectClientData(src)
	failed = SSoverwatch.HandleClientAccessCheck(src)
	SSoverwatch.HandleASNbanCheck(src)

	var/string
	if(ip_info)
		if(ip_info.ip_proxy)
			string += "Proxy IP"
		if(ip_info.ip_hosting)
			if(string)
				string += ", "
			string += "Hosted IP"
		if(ip_info.ip_mobile)
			if(string)
				string += ", "
			string += "Mobile Hostspot IP"

	if(failed && !(is_admin(src)))
		message_admins(span_adminnotice("Proxy Detection: [key_name_admin(src)] [ADMIN_PP(mob)] Overwatch detected this is a [string]"))

	return failed

/client/Click(atom/object, atom/location, control, params)
	if(click_intercept_time)
		if(click_intercept_time >= world.time)
			click_intercept_time = 0 //Reset and return. Next click should work, but not this one.
			return
		click_intercept_time = 0 //Just reset. Let's not keep re-checking forever.

	var/ab = FALSE
	var/list/L = params2list(params)

	var/dragged = L["drag"]
	if(dragged && !L[dragged])
		return

	if (object && object == middragatom && L["left"])
		ab = max(0, 5 SECONDS-(world.time-middragtime)*0.1)

	var/mcl = CONFIG_GET(number/minute_click_limit)
	if (!holder && mcl)
		var/minute = round(world.time, 600)
		if (!clicklimiter)
			clicklimiter = new(LIMITER_SIZE)
		if (minute != clicklimiter[CURRENT_MINUTE])
			clicklimiter[CURRENT_MINUTE] = minute
			clicklimiter[MINUTE_COUNT] = 0
		clicklimiter[MINUTE_COUNT] += 1+(ab)
		if (clicklimiter[MINUTE_COUNT] > mcl)
			var/msg = "Your previous click was ignored because you've done too many in a minute."
			if (minute != clicklimiter[ADMINSWARNED_AT]) //only one admin message per-minute. (if they spam the admins can just boot/ban them)
				clicklimiter[ADMINSWARNED_AT] = minute

				msg += " Administrators have been informed."
				if (ab)
					log_game("[key_name(src)] is using the middle click aimbot exploit")
					message_admins("[ADMIN_LOOKUPFLW(usr)] [ADMIN_KICK(usr)] is using the middle click aimbot exploit</span>")
					add_system_note("aimbot", "Is using the middle click aimbot exploit")
				log_game("[key_name(src)] Has hit the per-minute click limit of [mcl] clicks in a given game minute")
				message_admins("[ADMIN_LOOKUPFLW(usr)] [ADMIN_KICK(usr)] Has hit the per-minute click limit of [mcl] clicks in a given game minute")
//			to_chat(src, "<span class='danger'>[msg]</span>")
			return

	var/scl = CONFIG_GET(number/second_click_limit)
	if (!holder && scl)
		var/second = round(world.time, 10)
		if (!clicklimiter)
			clicklimiter = new(LIMITER_SIZE)
		if (second != clicklimiter[CURRENT_SECOND])
			clicklimiter[CURRENT_SECOND] = second
			clicklimiter[SECOND_COUNT] = 0
		clicklimiter[SECOND_COUNT] += 1+(!!ab)
		if (clicklimiter[SECOND_COUNT] > scl)
//			to_chat(src, "<span class='danger'>My previous click was ignored because you've done too many in a second</span>")
			return

	//check if the server is overloaded and if it is then queue up the click for next tick
	//yes having it call a wrapping proc on the subsystem is fucking stupid glad we agree unfortunately byond insists its reasonable
	if(!QDELETED(object) && TRY_QUEUE_VERB(VERB_CALLBACK(object, TYPE_PROC_REF(/atom, _Click), location, control, params), VERB_HIGH_PRIORITY_QUEUE_THRESHOLD, SSinput, control))
		return

	if (prefs.hotkeys)
		// If hotkey mode is enabled, then clicking the map will automatically
		// unfocus the text bar. This removes the red color from the text bar
		// so that the visual focus indicator matches reality.
		winset(src, null, "command=disableInput input.background-color=[COLOR_INPUT_DISABLED] input.text-color = #ad9eb4")

	else
		winset(src, null, "input.focus=true command=activeInput input.background-color=[COLOR_INPUT_ENABLED] input.text-color = #EEEEEE")

	..()

/client/proc/add_verbs_from_config()
	if(CONFIG_GET(flag/see_own_notes))
		verbs += /client/proc/self_notes
	if(CONFIG_GET(flag/use_exp_tracking))
		verbs += /client/proc/self_playtime


#undef UPLOAD_LIMIT

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration = CONFIG_GET(number/inactivity_period))
	if(inactivity > duration)
		return inactivity
	return FALSE
/// Send resources to the client.
/// Sends both game resources and browser assets.
/client/proc/send_resources()
#if (PRELOAD_RSC == 0)
	var/static/next_external_rsc = 0
	var/list/external_rsc_urls = CONFIG_GET(keyed_list/external_rsc_urls)
	if(length(external_rsc_urls))
		next_external_rsc = WRAP(next_external_rsc+1, 1, external_rsc_urls.len+1)
		preload_rsc = external_rsc_urls[next_external_rsc]
#endif

	spawn (10) //removing this spawn causes all clients to not get verbs. (this can't be addtimer because these assets may be needed before the mc inits)

		//load info on what assets the client has
		src << browse('code/modules/asset_cache/validate_assets.html', "window=asset_cache_browser")

		//Precache the client with all other assets slowly, so as to not block other browse() calls
		if (CONFIG_GET(flag/asset_simple_preload))
			addtimer(CALLBACK(SSassets.transport, TYPE_PROC_REF(/datum/asset_transport, send_assets_slow), src, SSassets.transport.preload), 5 SECONDS)


//Hook, override it to run code when dir changes
//Like for /atoms, but clients are their own snowflake FUCK
/client/proc/setDir(newdir)
	dir = newdir

/client/vv_edit_var(var_name, var_value)
	switch (var_name)
		if ("holder")
			return FALSE
		if ("ckey")
			return FALSE
		if ("key")
			return FALSE
		if("view")
			change_view(var_value)
			return TRUE
	. = ..()

/client/proc/rescale_view(change, min, max)
	var/viewscale = getviewsize(view)
	var/x = viewscale[1]
	var/y = viewscale[2]
	x = CLAMP(x+change, min, max)
	y = CLAMP(y+change, min,max)
	change_view("[x]x[y]")

/client/proc/update_movement_keys()
	if(!prefs?.key_bindings)
		return
	movement_keys = list()
	for(var/key in prefs.key_bindings)
		for(var/kb_name in prefs.key_bindings[key])
			switch(kb_name)
				if("North")
					movement_keys[key] = NORTH
				if("East")
					movement_keys[key] = EAST
				if("West")
					movement_keys[key] = WEST
				if("South")
					movement_keys[key] = SOUTH

/client/proc/change_view(new_size)
	if (isnull(new_size))
		CRASH("change_view called without argument.")

	if(prefs && !prefs.widescreenpref && new_size == CONFIG_GET(string/default_view))
		new_size = CONFIG_GET(string/default_view_square)

	view = new_size
	apply_clickcatcher()
	mob.reload_fullscreen()
	if (isliving(mob))
		var/mob/living/M = mob
		M.update_damage_hud()
	if (prefs.auto_fit_viewport)
		addtimer(CALLBACK(src, VERB_REF(fit_viewport), 1 SECONDS)) //Delayed to avoid wingets from Login calls.

/client/proc/generate_clickcatcher()
	if(!void)
		void = new()
		screen += void

/client/proc/apply_clickcatcher()
	generate_clickcatcher()
	var/list/actualview = getviewsize(view)
	void.UpdateGreed(actualview[1],actualview[2])

/client/proc/AnnouncePR(announcement)
	if(prefs && prefs.chat_toggles & CHAT_PULLR)
		to_chat(src, announcement)

/client/proc/show_character_previews(mutable_appearance/MA)
	var/pos = 0
	for(var/D in GLOB.cardinals)
		pos++
		var/atom/movable/screen/char_preview/O = LAZYACCESS(char_render_holders, "[D]")
		if(O)
			screen -= O
			char_render_holders -= O
			qdel(O)
		O = new
		LAZYSET(char_render_holders, "[D]", O)
		screen += O
		O.appearance = MA
		O.dir = D
		switch(pos)
			if(1)
				O.screen_loc = "character_preview_map:1:2,2:-18"
			if(2)
				O.screen_loc = "character_preview_map:0:2,2:-18"
			if(3)
				O.screen_loc = "character_preview_map:1:2,0:10"
			if(4)
				O.screen_loc = "character_preview_map:0:2,0:10"

/client/proc/clear_character_previews()
	for(var/atom/movable/screen/S in char_render_holders)
//		var/atom/movable/screen/S = char_render_holders[index]
		screen -= S
		qdel(S)
	char_render_holders = list()

/client/proc/fullscreen()
	winset(src, "mainwindow", "statusbar=false")

/client/New()
	..()
	fullscreen()

/client/proc/give_award(achievement_type, mob/user)
	return	player_details.achievements.unlock(achievement_type, mob/user)

/client/proc/ghostize(can_reenter_corpse = 1, mob/current)
	if(current)
		if(mob)
			if(mob != current)
				return
	if(mob)
		if(isliving(mob)) //no ghost can call this
			mob.ghostize(can_reenter_corpse)
		testing("[mob] [mob.type] YEA CLIE")


/client/proc/whitelisted()
	if(whitelisted != 2)
		return whitelisted
	else
		if(check_whitelist(ckey))
			whitelisted = 1
		else
			whitelisted = 0
		return whitelisted

/client/proc/commendsomeone(forced = FALSE)
	set category = "OOC"
	set name = "Commend"
	set desc = "Make that one person you had Quality RolePlay with happy."

	commendation_popup(forced)

/client/proc/view_stats()
	set name = "View Statistics"
	set category = "OOC"

	show_round_stats(pick_assoc(GLOB.featured_stats))
