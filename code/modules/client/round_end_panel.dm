/// Shows round end popup with all kind of statistics
/client/proc/show_round_stats(featured_stat)
	if(SSticker.current_state != GAME_STATE_FINISHED && !check_rights(R_ADMIN|R_DEBUG))
		return

	var/list/data = list()

	// Navigation buttons
	data += "<div style='width: 100%; text-align: center; margin: 15px 0;'>"
	data += "<a href='byond://?src=[REF(src)];viewstats=1' style='display: inline-block; width: 120px; padding: 8px 12px; margin: 0 10px; background: #2a2a2a; border: 1px solid #444; color: #ddd; font-weight: bold; text-decoration: none; border-radius: 3px; font-size: 0.9em;'>CHRONICLE</a>"
	data += "<a href='byond://?src=[REF(src)];viewinfluences=1' style='display: inline-block; width: 120px; padding: 8px 12px; margin: 0 10px; background: #2a2a2a; border: 1px solid #444; color: #ddd; font-weight: bold; text-decoration: none; border-radius: 3px; font-size: 0.9em;'>INFLUENCES</a>"
	data += "</div>"

	// Divider
	data += "<div style='text-align: center; margin: 25px auto; width: 80%; max-width: 800px;'>"
	data += "<div style='border-top: 1.5px solid #444; margin: 15px auto; width: 100%;'></div>"
	data += "</div>"

	// Chronicle sub-tabs
	data += "<div style='width: 100%; text-align: center; margin: 15px 0;'>"
	data += "<a href='byond://?src=[REF(src)];viewchronicle=1;chronicletab=Gods' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #4a4a5a, #2a2a3a); border: 1px solid #6a6a7a; border-bottom: 2px solid #9a9aaa; color: #e0e0f0; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>GODS</a>"
	data += "<a href='byond://?src=[REF(src)];viewchronicle=1;chronicletab=Messages' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #3a2a1a, #1a120a); border: 1px solid #5a4a3a; border-bottom: 2px solid #8a7a6a; color: #d4c4b4; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>WHISPERS</a>"
	data += "<a href='byond://?src=[REF(src)];viewchronicle=1;chronicletab=The Realm' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #2a2a3a, #0a0a1a); border: 1px solid #4a4a5a; border-bottom: 2px solid #7a7a8a; color: #c4c4d4; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>THE REALM</a>"
	data += "<a href='byond://?src=[REF(src)];viewstats=1' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #3a2a0a, #1a1200); border: 1px solid #5a4a1a; border-bottom: 2px solid #8a7a3a; color: #dec97a; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>STATISTICS</a>"
	data += "<a href='byond://?src=[REF(src)];viewchronicle=1;chronicletab=Heroes' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #3a4a5a, #1a1b2a); border: 1px solid #6a7b8a; border-bottom: 2px solid #8f9caa; color: #c0c0d0; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>HEROES</a>"
	data += "<a href='byond://?src=[REF(src)];viewchronicle=1;chronicletab=Villains' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #3a1a1a, #1a0a0a); border: 1px solid #5a3a3a; border-bottom: 2px solid #8a6a6a; color: #d4b4b4; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>VILLAINS</a>"
	data += "<a href='byond://?src=[REF(src)];viewchronicle=1;chronicletab=Outlaws' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #5a3a0a, #3a1a0a); border: 1px solid #7a5a2a; border-bottom: 2px solid #aa8a5a; color: #ffd494; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>OUTLAWS</a>"
	data += "</div>"

	// Content
	data += "<div style='margin: 35px;'>"

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
	data += "<a href='byond://?src=[REF(src)];select_featured_stat=1' style='font-weight: bold; color: #bd1717; text-decoration: none;'>Featured Statistics</a>"
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
	data += "<font color='#7cc05c'><span class='bold'>Wounds sewed:</span></font> [GLOB.vanderlin_round_stats[STATS_WOUNDS_SEWED]]<br>"
	data += "<font color='#825b1c'><span class='bold'>Moat Fallers:</span></font> [GLOB.vanderlin_round_stats[STATS_MOAT_FALLERS]]<br>"
	data += "<font color='#ac5d5d'><span class='bold'>Ankles Broken:</span></font> [GLOB.vanderlin_round_stats[STATS_ANKLES_BROKEN]]<br>"
	data += "<font color='#e6d927'><span class='bold'>People Smitten:</span></font> [GLOB.vanderlin_round_stats[STATS_PEOPLE_SMITTEN]]<br>"
	data += "<div style='height: 17.5px;'>&nbsp;</div>"
	data += "<font color='#50aeb4'><span class='bold'>People Drowned:</span></font> [GLOB.vanderlin_round_stats[STATS_PEOPLE_DROWNED]]<br>"
	data += "<font color='#be8b37'><span class='bold'>Kleptomaniacs:</span></font> [GLOB.vanderlin_round_stats[STATS_KLEPTOMANIACS]]<br>"
	data += "<font color='#8f816b'><span class='bold'>Items Stolen:</span></font> [GLOB.vanderlin_round_stats[STATS_ITEMS_PICKPOCKETED]]<br>"
	data += "<font color='#c24bc2'><span class='bold'>Drugs Snorted:</span></font> [GLOB.vanderlin_round_stats[STATS_DRUGS_SNORTED]]<br>"
	data += "<font color='#90a037'><span class='bold'>Laughs Had:</span></font> [GLOB.vanderlin_round_stats[STATS_LAUGHS_MADE]]<br>"
	data += "<font color='#f5c02e'><span class='bold'>Taxes Collected:</span></font> [GLOB.vanderlin_round_stats[STATS_TAXES_COLLECTED]]<br>"
	data += "<font color='#c45459'><span class='bold'>Taxes Evaded:</span></font> [GLOB.vanderlin_round_stats[STATS_TAXES_EVADED]]<br>"
	data += "<font color='#7154ce'><span class='bold'>Slurs Spoken:</span></font> [GLOB.vanderlin_round_stats[STATS_SLURS_SPOKEN]]<br>"
	data += "</div>"

	// Right column
	data += "<div style='display: table-cell; width: 50%; vertical-align: top; padding: 0 10px;'>"
	data += "<font color='#36959c'><span class='bold'>Triumphs Awarded:</span></font> [GLOB.vanderlin_round_stats[STATS_TRIUMPHS_AWARDED]]<br>"
	data += "<font color='#c65fc9'><span class='bold'>Marriages Perfomed:</span></font> [GLOB.vanderlin_round_stats[STATS_MARRIAGES]]<br>"
	data += "<font color='#d7da2f'><span class='bold'>Prayers Made:</span></font> [GLOB.vanderlin_round_stats[STATS_PRAYERS_MADE]]<br>"
	data += "<font color='#bacfd6'><span class='bold'>Graves Consecrated:</span></font> [GLOB.vanderlin_round_stats[STATS_GRAVES_CONSECRATED]]<br>"
	data += "<font color='#7c7f80'><span class='bold'>Graves Robbed:</span></font> [GLOB.vanderlin_round_stats[STATS_GRAVES_ROBBED]]<br>"
	data += "<font color='#9c3e46'><span class='bold'>Controlled Deadites:</span></font> [GLOB.vanderlin_round_stats[STATS_DEADITES_ALIVE]]<br>"
	data += "<font color='#0f555c'><span class='bold'>Beards Shaved:</span></font> [GLOB.vanderlin_round_stats[STATS_BEARDS_SHAVED]]<br>"
	data += "<font color='#9fa3a5'><span class='bold'>Skills Learned:</span></font> [GLOB.vanderlin_round_stats[STATS_SKILLS_LEARNED]]<br>"
	data += "<div style='height: 17.5px;'>&nbsp;</div>"
	data += "<font color='#23af4d'><span class='bold'>Plants Harvested:</span></font> [GLOB.vanderlin_round_stats[STATS_PLANTS_HARVESTED]]<br>"
	data += "<font color='#4492a5'><span class='bold'>Fish Caught:</span></font> [GLOB.vanderlin_round_stats[STATS_FISH_CAUGHT]]<br>"
	data += "<font color='#836033'><span class='bold'>Trees Felled:</span></font> [GLOB.vanderlin_round_stats[STATS_TREES_CUT]]<br>"
	data += "<font color='#7db341'><span class='bold'>Potions Brewed:</span></font> [GLOB.vanderlin_round_stats[STATS_POTIONS_BREWED]]<br>"
	data += "<font color='#af2323'><span class='bold'>Organs Eaten:</span></font> [GLOB.vanderlin_round_stats[STATS_ORGANS_EATEN]]<br>"
	data += "<font color='#afa623'><span class='bold'>Locks Picked:</span></font> [GLOB.vanderlin_round_stats[STATS_LOCKS_PICKED]]<br>"
	data += "<font color='#c47edd'><span class='bold'>Hands Held:</span></font> [GLOB.vanderlin_round_stats[STATS_HANDS_HELD]]<br>"
	data += "<font color='#c52d8b'><span class='bold'>Kisses Made:</span></font> [GLOB.vanderlin_round_stats[STATS_KISSES_MADE]]<br>"
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

	var/literacy_rate = 0
	if(GLOB.vanderlin_round_stats[STATS_TOTAL_POPULATION] > 0)
		literacy_rate = round((1 - (GLOB.vanderlin_round_stats[STATS_ILLITERATES] / GLOB.vanderlin_round_stats[STATS_TOTAL_POPULATION])) * 100)

	// Left column
	data += "<div style='display: table-cell; width: 50%; vertical-align: top; border-left: 1px solid #444; padding: 0 10px;'>"
	data += "<font color='#8f1dc0'<span class='bold'>Ruler's Patron:</span></font> [GLOB.vanderlin_round_stats[STATS_MONARCH_PATRON]]<br>"
	data += "<font color='#4682B4'><span class='bold'>Total Populace:</span></font> [GLOB.vanderlin_round_stats[STATS_TOTAL_POPULATION]]<br>"
	data += "<font color='#ce4646'><span class='bold'>Nobility:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_NOBLES]]<br>"
	data += "<font color='#556B2F'><span class='bold'>Garrison:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_GARRISON]]<br>"
	data += "<font color='#DAA520'><span class='bold'>Clergy:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_CLERGY]]<br>"
	data += "<font color='#D2691E'><span class='bold'>Tradesmen:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_TRADESMEN]]<br>"
	data += "<font color='#d0cbd8'><span class='bold'>Foreigners:</span></font> [GLOB.vanderlin_round_stats[STATS_FOREIGNERS]]<br>"
	data += "<font color='#eb76b0'><span class='bold'>Married:</span></font> [GLOB.vanderlin_round_stats[STATS_MARRIED]]<br>"
	data += "<div style='height: 17.5px;'>&nbsp;</div>"
	data += "<font color='#65d6d6'><span class='bold'>Literacy:</span></font> [literacy_rate] %<br>"
	data += "<font color='#6b89e0'><span class='bold'>Males:</span></font> [GLOB.vanderlin_round_stats[STATS_MALE_POPULATION]]<br>"
	data += "<font color='#d67daa'><span class='bold'>Females:</span></font> [GLOB.vanderlin_round_stats[STATS_FEMALE_POPULATION]]<br>"
	data += "<font color='#FFD700'><span class='bold'>Children:</span></font> [GLOB.vanderlin_round_stats[STATS_CHILD_POPULATION]]<br>"
	data += "<font color='#d0d67c'><span class='bold'>Adults:</span></font> [GLOB.vanderlin_round_stats[STATS_ADULT_POPULATION]]<br>"
	data += "<font color='#a6ac6a'><span class='bold'>Middle-Aged:</span></font> [GLOB.vanderlin_round_stats[STATS_MIDDLEAGED_POPULATION]]<br>"
	data += "<font color='#C0C0C0'><span class='bold'>Elderly:</span></font> [GLOB.vanderlin_round_stats[STATS_ELDERLY_POPULATION]]<br>"
	data += "<font color='#f1dfa7'><span class='bold'>Immortals:</span></font> [GLOB.vanderlin_round_stats[STATS_IMMORTAL_POPULATION]]<br>"
	data += "</div>"

	// Right column
	data += "<div style='display: table-cell; width: 50%; vertical-align: top; padding: 0 15px;'>"
	data += "<font color='#8B4513'><span class='bold'>Humens:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_NORTHERN_HUMANS]]<br>"
	data += "<font color='#808080'><span class='bold'>Dwarves:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_DWARVES]]<br>"
	data += "<font color='#87CEEB'><span class='bold'>Pure Elves:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_SNOW_ELVES]]<br>"
	data += "<font color='#9ACD32'><span class='bold'>Half-Elves:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_HALF_ELVES]]<br>"
	data += "<font color='#bd83cc'><span class='bold'>Half-Drows:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_HALF_DROWS]]<br>"
	data += "<font color='#7729af'><span class='bold'>Dark Elves:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_DARK_ELVES]]<br>"
	data += "<font color='#30b39f'><span class='bold'>Tritons:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_TRITONS]]<br>"
	data += "<font color='#c0c25f'><span class='bold'>Halflings:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_HALFLINGS]]<br>"
	data += "<div style='height: 17.5px;'>&nbsp;</div>"
	data += "<font color='#228B22'><span class='bold'>Half-Orcs:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_HALF_ORCS]]<br>"
	data += "<font color='#CD853F'><span class='bold'>Kobolds:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_KOBOLDS]]<br>"
	data += "<font color='#DC143C'><span class='bold'>Tieflings:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_TIEFLINGS]]<br>"
	data += "<font color='#FFD700'><span class='bold'>Raksharis:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_RAKSHARI]]<br>"
	data += "<font color='#e7e3d9'><span class='bold'>Aasimars:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_AASIMAR]]<br>"
	data += "<font color='#d49d7c'><span class='bold'>Hollowkins:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_HOLLOWKINS]]<br>"
	data += "<font color='#99dfd5'><span class='bold'>Harpies:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_HARPIES]]<br>"
	data += "<font color='#a0936b'><span class='bold'>Medicators:</span></font> [GLOB.vanderlin_round_stats[STATS_ALIVE_MEDICATORS]]<br>"

	data += "</div>"

	data += "</div></div>"
	data += "</div>"

	data += "</div></div>"

	mob << browse(null, "window=vanderlin_influences")
	var/datum/browser/popup = new(mob, "vanderlin_round_end", "<center>The Chronicle</center>", 1085, 855)
	popup.set_content(data.Join())
	popup.open()

/client/proc/select_featured_stat()
	var/list/stat_choices = list()
	for(var/stat in GLOB.featured_stats)
		var/list/stat_data = GLOB.featured_stats[stat]
		stat_choices[stat_data["name"]] = stat

	var/chosen = browser_input_list(mob, "Select featured statistic", "Featured Statistics", stat_choices)
	if(chosen && (chosen in stat_choices))
		show_round_stats(stat_choices[chosen])

/// Shows chronicle page
/client/proc/show_chronicle(tab = "The Realm")
	if(SSticker.current_state != GAME_STATE_FINISHED && !check_rights(R_ADMIN|R_DEBUG))
		return

	var/list/data = list()

	// Navigation buttons
	data += "<div style='width: 100%; text-align: center; margin: 15px 0;'>"
	data += "<a href='byond://?src=[REF(src)];viewstats=1' style='display: inline-block; width: 120px; padding: 8px 12px; margin: 0 10px; background: #2a2a2a; border: 1px solid #444; color: #ddd; font-weight: bold; text-decoration: none; border-radius: 3px; font-size: 0.9em;'>CHRONICLE</a>"
	data += "<a href='byond://?src=[REF(src)];viewinfluences=1' style='display: inline-block; width: 120px; padding: 8px 12px; margin: 0 10px; background: #2a2a2a; border: 1px solid #444; color: #ddd; font-weight: bold; text-decoration: none; border-radius: 3px; font-size: 0.9em;'>INFLUENCES</a>"
	data += "</div>"

	// Divider
	data += "<div style='text-align: center; margin: 25px auto; width: 80%; max-width: 800px;'>"
	data += "<div style='border-top: 1.5px solid #444; margin: 15px auto; width: 100%;'></div>"
	data += "</div>"

	// Chronicle sub-tabs
	data += "<div style='width: 100%; text-align: center; margin: 15px 0;'>"
	data += "<a href='byond://?src=[REF(src)];viewchronicle=1;chronicletab=Gods' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #4a4a5a, #2a2a3a); border: 1px solid #6a6a7a; border-bottom: 2px solid #9a9aaa; color: #e0e0f0; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>GODS</a>"
	data += "<a href='byond://?src=[REF(src)];viewchronicle=1;chronicletab=Messages' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #3a2a1a, #1a120a); border: 1px solid #5a4a3a; border-bottom: 2px solid #8a7a6a; color: #d4c4b4; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>WHISPERS</a>"
	data += "<a href='byond://?src=[REF(src)];viewchronicle=1;chronicletab=The Realm' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #2a2a3a, #0a0a1a); border: 1px solid #4a4a5a; border-bottom: 2px solid #7a7a8a; color: #c4c4d4; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>THE REALM</a>"
	data += "<a href='byond://?src=[REF(src)];viewstats=1' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #3a2a0a, #1a1200); border: 1px solid #5a4a1a; border-bottom: 2px solid #8a7a3a; color: #dec97a; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>STATISTICS</a>"
	data += "<a href='byond://?src=[REF(src)];viewchronicle=1;chronicletab=Heroes' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #3a4a5a, #1a1b2a); border: 1px solid #6a7b8a; border-bottom: 2px solid #8f9caa; color: #c0c0d0; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>HEROES</a>"
	data += "<a href='byond://?src=[REF(src)];viewchronicle=1;chronicletab=Villains' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #3a1a1a, #1a0a0a); border: 1px solid #5a3a3a; border-bottom: 2px solid #8a6a6a; color: #d4b4b4; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>VILLAINS</a>"
	data += "<a href='byond://?src=[REF(src)];viewchronicle=1;chronicletab=Outlaws' style='display: inline-block; width: 100px; padding: 6px 10px; margin: 0 5px; background: linear-gradient(to bottom, #5a3a0a, #3a1a0a); border: 1px solid #7a5a2a; border-bottom: 2px solid #aa8a5a; color: #ffd494; font-weight: bold; text-decoration: none; border-radius: 2px; font-size: 0.8em; box-shadow: 0 1px 3px rgba(0,0,0,0.5);'>OUTLAWS</a>"
	data += "</div>"

	// Content
	data += "<div style='margin: 35px;'>"
	switch(tab)
		if("Gods")

			// Gods' Interventions Section
			data += "<div>"
			data += "<div style='text-align: center; color: #e0e0f0; font-size: 1.2em; margin-bottom: 10px;'>GODS' INTERVENTIONS</div>"
			data += "<div style='border-top: 1px solid #9a9aaa; margin: 20px auto 10px auto; width: 90%;'></div>"

			if(length(SSmapping.active_world_traits))
				data += "<div style='display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 15px; margin-top: 20px; margin-bottom: 30px;'>"
				for(var/datum/world_trait/trait in SSmapping.active_world_traits)
					data += "<div style='background: #2a2a3a; border: 1px solid #4a4a5a; padding: 10px; border-radius: 4px;'>"
					data += "<div style='color: #e0e0f0; font-weight: bold; margin-bottom: 5px;'>[trait.name]</div>"
					data += "<div style='color: #b0b0b0; font-style: italic;'>[trait.desc]</div>"
					data += "</div>"

				data += "</div>"
			else
				data += "<div style='text-align: center; color: #999; font-style: italic; padding: 30px 0;'>The Gods are silent</div>"

			data += "</div>"

			// Ranking of the Gods Section
			data += "<div style='text-align: center; color: #e0e0f0; font-size: 1.2em; margin-bottom: 15px;'>RANKING OF THE GODS</div>"
			data += "<div style='border-top: 1.5px solid #9a9aaa; margin: 0 auto 20px auto; width: 90%;'></div>"

			var/list/god_rankings = get_god_rankings()
			var/list/sorted_gods = list()

			for(var/storyteller_name in SSgamemode.storytellers)
				var/datum/storyteller/S = SSgamemode.storytellers[storyteller_name]
				if(!S)
					continue
				sorted_gods += list(list(
					"name" = S.name,
					"points" = god_rankings[S.name] || 0,
					"color" = S.color_theme
				))

			sortTim(sorted_gods, GLOBAL_PROC_REF(cmp_god_ranking))

			for(var/list/god_data in sorted_gods)
				data += create_god_ranking_entry(god_data["name"], god_data["points"], god_data["color"])

			// Gods' Events Section
			data += "<div style='text-align: center; color: #e0e0f0; font-size: 1.2em; margin-top: 20px; margin-bottom: 20px;'>GODS' EVENTS</div>"
			data += "<div style='border-top: 1.5px solid #9a9aaa; margin: 0 auto 20px auto; width: 90%;'></div>"

			var/list/event_categories = list(
				EVENT_TRACK_MUNDANE,
				EVENT_TRACK_PERSONAL,
				EVENT_TRACK_MODERATE,
				EVENT_TRACK_INTERVENTION,
				EVENT_TRACK_CHARACTER_INJECTION,
				EVENT_TRACK_OMENS,
				EVENT_TRACK_RAIDS,
			)

			var/list/events_by_category = list()
			var/has_events = FALSE

			for(var/datum/round_event_control/event_control in SSgamemode.control)
				var/occurrences_this_round = event_control.occurrences - event_control.last_round_occurrences
				if(occurrences_this_round <= 0)
					continue

				if(!events_by_category[event_control.track])
					events_by_category[event_control.track] = list()

				events_by_category[event_control.track] += list(list(
					"name" = event_control.name,
					"count" = occurrences_this_round
				))
				has_events = TRUE

			if(!has_events)
				data += "<div style='text-align: center; color: #999; font-style: italic; padding: 30px 0;'>The Gods did not meddle with mortals, yet</div>"
			else
				data += "<div style='display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-top: 20px;'>"

				for(var/category in event_categories)
					var/list/category_events = events_by_category[category]

					data += "<div style='background: #2a2a3a; border: 1px solid #4a4a5a; padding: 15px; border-radius: 4px;'>"
					data += "<div style='color: #e0e0f0; font-weight: bold; margin-bottom: 10px; border-bottom: 1px solid #6a6a7a; padding-bottom: 5px; text-align: center;'>[category]</div>"

					if(length(category_events))
						for(var/list/event_data in category_events)
							data += "<div style='margin-bottom: 5px; padding-left: 8px; border-left: 2px solid #6a6a7a;'>"
							data += "<span style='color: #b0b0b0;'>[event_data["name"]]:</span> <span style='color: #e0e0f0;'>[event_data["count"]]</span>"
							data += "</div>"
					else
						data += "<div style='color: #999; font-style: italic; text-align: center; padding: 10px 0;'>No events occurred</div>"

					data += "</div>"

				data += "</div>"

		if("Messages")
			data += "<div style='display: table; width: 100%; table-layout: fixed;'>"
			data += "<div style='display: table-row;'>"

			// Last Words Column (33%)
			data += "<div style='display: table-cell; width: 33%; vertical-align: top; padding: 0 5px;'>"
			data += "<div style='color: #bd1717; font-size: 1.2em; font-weight: bold; text-align: center; margin-bottom: 10px;'>LAST WORDS</div>"
			data += "<div style='border-top: 1px solid #bd1717; width: 90%; margin: 0 auto 15px auto;'></div>"

			if(length(GLOB.last_words))
				for(var/entry in GLOB.last_words)
					data += "<div style='color: #ff6b6b; margin: 0 0 12px 0px; padding: 8px; background: rgba(189, 23, 23, 0.08); border-left: 3px solid #bd1717; border-radius: 0 3px 3px 0;'>"
					data += "[entry]"
					data += "</div>"
			else
				data += "<div style='color: #aaaaaa; font-style: italic; text-align: center; padding: 20px 0;'>No last words told</div>"
			data += "</div>"

			// Prayers Column (33%)
			data += "<div style='display: table-cell; width: 33%; vertical-align: top; padding: 0 5px;'>"
			data += "<div style='color: #e6b327; font-size: 1.2em; font-weight: bold; text-align: center; margin-bottom: 10px;'>PRAYERS</div>"
			data += "<div style='border-top: 1px solid #e6b327; width: 90%; margin: 0 auto 15px auto;'></div>"

			if(length(GLOB.prayers))
				for(var/entry in GLOB.prayers)
					data += "<div style='color: #dbd9d9; margin: 0 0 12px 0px; padding: 8px; background: rgba(230, 179, 39, 0.08); border-left: 3px solid #e6b327; border-radius: 0 3px 3px 0;'>"
					data += "[strip_html(entry)]"
					data += "</div>"
			else
				data += "<div style='color: #aaaaaa; font-style: italic; text-align: center; padding: 20px 0;'>No prayers made</div>"
			data += "</div>"

			// Correspondence Column (33%)
			data += "<div style='display: table-cell; width: 33%; vertical-align: top; padding: 0 5px;'>"
			data += "<div style='color: #a0c4e0; font-size: 1.2em; font-weight: bold; text-align: center; margin-bottom: 10px;'>CORRESPONDENCE</div>"
			data += "<div style='border-top: 1px solid #a0c4e0; width: 90%; margin: 0 auto 15px auto;'></div>"

			if(length(GLOB.letters_sent))
				for(var/entry in GLOB.letters_sent)
					data += "<div style='color: #e0e8f0; margin: 0 0 12px 0px; padding: 8px; background: rgba(160, 196, 224, 0.08); border-left: 3px solid #a0c4e0; border-radius: 0 3px 3px 0;'>"
					data += "[entry]"
					data += "</div>"
			else
				data += "<div style='color: #aaaaaa; font-style: italic; text-align: center; padding: 20px 0;'>No correspondence sent</div>"
			data += "</div>"

			data += "</div></div>"

		if("The Realm")
			// Notable People Section
			data += "<div style='text-align: center;'>"
			data += "<div style='color: #e6a962; font-size: 1.2em; margin-bottom: 15px; text-transform: uppercase;'>NOTABLE PEOPLE</div>"
			data += "<div style='border-top: 1.5px solid #e6a962; margin: 0 auto 25px auto; width: 90%;'></div>"

			data += "<div style='display: inline-block; margin: 0 5%; width: 90%;'>"
			data += "<div style='display: table; width: 100%;'>"
			data += "<div style='display: table-row;'>"

			var/stats_per_column = CEILING(length(SSgamemode.chosen_chronicle_stats) / 4, 1)
			var/current_stat = 1

			for(var/col in 1 to 4)
				data += "<div style='display: table-cell; width: 25%; text-align: center; padding: 0 15px; vertical-align: top;'>"

				for(var/i in 1 to stats_per_column)
					if(current_stat > length(SSgamemode.chosen_chronicle_stats))
						break

					var/stat_name = SSgamemode.chosen_chronicle_stats[current_stat]
					var/include_title = (i == 1)
					var/is_second_block = (i > 1)

					data += create_chronicle_holder_block(stat_name, include_title, is_second_block)
					current_stat++

				data += "</div>"

			data += "</div></div></div>"
			data += "<div style='height: 20px;'></div>"

			// Treasury Section
			data += "<div style='text-align: center; color: #e6b327; font-size: 1.2em; margin: 15px 0; text-transform: uppercase;'>Realm's Treasury: [SStreasury.treasury_value]</div>"
			data += "<div style='border-top: 1.5px solid #e6b327; margin: 0 auto 20px auto; width: 75%;'></div>"

			data += "<div style='width: 100%; margin: 0 auto; position: relative;'>"
			data += "<div style='display: flex; justify-content: space-between; gap: 0;'>"

			// Left column (Revenue)
			data += "<div style='width: 44%; display: flex; justify-content: flex-end;'>"
			data += "<div style='text-align: left; padding-right: 20px;'>"
			data += "<div style='margin-bottom: 4px;'><font color='#f0c759'>Starting Treasury: </font>[GLOB.vanderlin_round_stats[STATS_STARTING_TREASURY]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#caa64a'>Total Vault Revenue: </font>[GLOB.vanderlin_round_stats[STATS_VAULT_TOTAL_REVENUE]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#e67e22'>Noble Estates Revenue: </font>[GLOB.vanderlin_round_stats[STATS_NOBLE_INCOME_TOTAL]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#f5c02e'>Royal Taxes Collected: </font>[GLOB.vanderlin_round_stats[STATS_TAXES_COLLECTED]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#8fa36a'>Mammons Deposited: </font>[GLOB.vanderlin_round_stats[STATS_MAMMONS_DEPOSITED]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#90b34f'>Stockpile Exports: </font>[GLOB.vanderlin_round_stats[STATS_STOCKPILE_EXPORTS_VALUE]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#a2b337'>Bought from Stockpile: </font>[GLOB.vanderlin_round_stats[STATS_STOCKPILE_REVENUE]]</div>"
			data += "<div style='border-top: 1px solid #555; margin: 8px 0;'></div>"
			data += "<div style='margin-bottom: 4px;'><font color='#23ba30'>Total Revenue: </font>[GLOB.vanderlin_round_stats[STATS_STARTING_TREASURY] + GLOB.vanderlin_round_stats[STATS_VAULT_TOTAL_REVENUE] + GLOB.vanderlin_round_stats[STATS_NOBLE_INCOME_TOTAL] + GLOB.vanderlin_round_stats[STATS_TAXES_COLLECTED] + GLOB.vanderlin_round_stats[STATS_MAMMONS_DEPOSITED] + GLOB.vanderlin_round_stats[STATS_STOCKPILE_EXPORTS_VALUE] + GLOB.vanderlin_round_stats[STATS_STOCKPILE_REVENUE]]</div>"
			data += "</div></div>"

			// Right column (Expenses)
			data += "<div style='width: 44%; display: flex; justify-content: flex-start;'>"
			data += "<div style='text-align: left; padding-left: 20px;'>"
			data += "<div style='margin-bottom: 4px;'><font color='#c95555'>Mammons Withdrawn: </font>[GLOB.vanderlin_round_stats[STATS_MAMMONS_WITHDRAWN]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#db853d'>Stockpile Imports: </font>[GLOB.vanderlin_round_stats[STATS_STOCKPILE_IMPORTS_VALUE]]</div>"
			data += "<div style='border-top: 1px solid #555; margin: 8px 0;'></div>"
			data += "<div style='margin-bottom: 4px;'><font color='#c44731'>Total Expenses: </font>[GLOB.vanderlin_round_stats[STATS_MAMMONS_WITHDRAWN] + GLOB.vanderlin_round_stats[STATS_STOCKPILE_IMPORTS_VALUE]]</div>"
			data += "</div></div>"

			data += "</div></div>"

			// Economy Section
			data += "<div style='text-align: center; color: #e6b327; font-size: 1.2em; margin: 15px 0; text-transform: uppercase; margin-top: 35px;'>ECONOMY</div>"
			data += "<div style='border-top: 1.5px solid #e6b327; margin: 0 auto 20px auto; width: 75%;'></div>"

			data += "<div style='width: 100%; margin: 0 auto; position: relative;'>"
			data += "<div style='display: flex; justify-content: space-between; gap: 0;'>"

			// Left column
			data += "<div style='width: 44%; display: flex; justify-content: flex-end;'>"
			data += "<div style='text-align: left; padding-right: 20px;'>"
			data += "<div style='margin-bottom: 4px;'><font color='#cdd86f'>Mammons in Accounts: </font>[GLOB.vanderlin_round_stats[STATS_MAMMONS_IN_BANK]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#e6b327'>Regular Vault Income: </font>[GLOB.vanderlin_round_stats[STATS_REGULAR_VAULT_INCOME]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#c57e62'>Sold to Stockpile: </font>[GLOB.vanderlin_round_stats[STATS_STOCKPILE_EXPANSES]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#b6a17f'>Salary Payments: </font>[GLOB.vanderlin_round_stats[STATS_WAGES_PAID]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#aac484'>Treasury Transfers: </font>[GLOB.vanderlin_round_stats[STATS_DIRECT_TREASURY_TRANSFERS]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#c78445'>Royal Fines Collected: </font>[GLOB.vanderlin_round_stats[STATS_FINES_INCOME]]</div>"
			data += "<div><font color='#e74c3c'>Royal Taxes Evaded: </font>[GLOB.vanderlin_round_stats[STATS_TAXES_EVADED]]</div>"
			data += "</div></div>"

			// Right column
			data += "<div style='width: 44%; display: flex; justify-content: flex-start;'>"
			data += "<div style='text-align: left; padding-left: 20px;'>"
			data += "<div style='margin-bottom: 4px;'><font color='#ebbf49'>Mammons Circulating: </font>[GLOB.vanderlin_round_stats[STATS_MAMMONS_HELD]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#db9a59'>Trade Value Exported: </font>[GLOB.vanderlin_round_stats[STATS_TRADE_VALUE_EXPORTED]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#dfbf57'>Trade Value Imported: </font>[GLOB.vanderlin_round_stats[STATS_TRADE_VALUE_IMPORTED]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#c08f83'>HEADEATER Exports: </font>[GLOB.vanderlin_round_stats[STATS_HEADEATER_EXPORTS]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#c0b283'>GOLDFACE Imports: </font>[GLOB.vanderlin_round_stats[STATS_GOLDFACE_VALUE_SPENT]]</div>"
			data += "<div style='margin-bottom: 4px;'><font color='#b5a642'>PURITY Imports: </font>[GLOB.vanderlin_round_stats[STATS_PURITY_VALUE_SPENT]]</div>"
			data += "<div><font color='#7495d3'>Peddler Revenue: </font>[GLOB.vanderlin_round_stats[STATS_PEDDLER_REVENUE]]</div>"
			data += "</div></div>"

			data += "</div></div>"

		if("Heroes")
			data += "<div style='text-align: center; color: #e6e6e6; font-size: 1.2em; margin-bottom: 15px;'>HEROES OF THE REALM</div>"
			data += "<div style='border-top: 1.5px solid #7a7a7a; margin: 0 auto 20px auto; width: 75%;'></div>"

			if(length(GLOB.personal_objective_minds))
				data += "<div style='display: grid; grid-template-columns: repeat(auto-fill, minmax(400px, 1fr)); gap: 20px;'>"

				for(var/datum/mind/mind as anything in GLOB.personal_objective_minds)
					if(!mind.personal_objectives || !length(mind.personal_objectives))
						continue

					data += "<div style='background: #1a1a1a; border: 1px solid #4a4a4a; padding: 12px; border-radius: 4px;'>"
					data += "<div style='color: #e6e6e6; font-weight: bold; margin-bottom: 8px;'>"
					if(mind.current)
						var/jobtext = ""
						if(mind.special_role)
							jobtext = " the <b>[mind.special_role]</b>"
						else if(mind.assigned_role && mind.current)
							jobtext = " the <b>[mind.assigned_role.get_informed_title(mind.current)]</b>"
						var/usede = get_display_ckey(mind.key)
						data += "<b>[usede]</b> was <span style='color:#e6a962'><b>[mind.name]</b>[jobtext]</span> and "
						if(mind.current.stat == DEAD)
							data += "<span style='color:#d9534f'>died</span>"
						else
							data += "<span style='color:#4ccf4c'>survived</span>"
					else
						data += "<b>Unknown Hero</b>"
					data += "</div>"

					var/obj_count = 1
					for(var/datum/objective/personal/objective as anything in mind.personal_objectives)
						var/completed = objective.check_completion()
						data += "<div style='margin-bottom: 6px; padding-left: 8px; border-left: 2px solid #555;'>"
						data += "<b>Quest #[obj_count]:</b> [objective.explanation_text] "
						data += "<span style='color:[completed ? "#5cb85c" : "#d9534f"]'>"
						data += "[completed ? "(COMPLETED)" : "(FAILED)"]</span>"
						data += "</div>"
						obj_count++

					data += "</div>"

				data += "</div>"
			else
				data += "<div style='text-align: center; color: #999; font-style: italic;'>Psydon was the last hero to live</div>"

		if("Villains")
			data += "<div style='text-align: center; color: #d4b4b4; font-size: 1.2em; margin-bottom: 15px;'>VILLAINS OF THE REALM</div>"
			data += "<div style='border-top: 1.5px solid #8a6a6a; margin: 0 auto 20px auto; width: 75%;'></div>"

			var/list/all_teams = list()
			var/list/all_antagonists = list()

			for(var/datum/team/A in GLOB.antagonist_teams)
				if(A.type != /datum/team && length(A.members))
					all_teams |= A

			for(var/datum/antagonist/A in GLOB.antagonists)
				if(A.owner && A.type != /datum/antagonist)
					var/should_exclude = FALSE
					if(length(A.owner.antag_datums) == 1)
						for(var/datum/team/T in all_teams)
							if(A.owner in T.members)
								should_exclude = TRUE
								break

					if(!should_exclude)
						all_antagonists |= A

			if(!length(all_teams) && !length(all_antagonists) && !length(GLOB.confessors))
				data += "<div style='text-align: center; color: #999; font-style: italic;'>The Realm has no villains... for now</div>"
			else
				if(length(GLOB.confessors))
					data += "<div style='background: #1a0a0a; border: 1px solid #5a3a3a; padding: 12px; border-radius: 4px; margin-bottom: 15px;'>"
					data += "<div style='color: #d4b4b4; font-weight: bold; margin-bottom: 8px;'>Confessed Heretics</div>"
					data += "<div style='margin-left: 10px;'>"
					for(var/x in GLOB.confessors)
						data += "<div style='margin-bottom: 10px;'>"
						data += "<span style='color:#e6a962'><b>[x]</b></span>"
						data += "</div>"
					data += "</div></div>"

				for(var/datum/team/T in all_teams)
					data += "<div style='background: #1a0a0a; border: 1px solid #5a3a3a; padding: 12px; border-radius: 4px; margin-bottom: 15px;'>"
					data += "<div style='color: #d4b4b4; font-weight: bold; margin-bottom: 8px;'>[capitalize(T.name)]</div>"
					data += "<div style='margin-left: 10px;'>"

					for(var/datum/mind/member in T.members)
						data += "<div style='margin-bottom: 10px;'>"

						if(member.current)
							var/jobtext = ""
							if(member.special_role)
								jobtext = " the <b>[member.special_role]</b>"
							else if(member.assigned_role && member.current)
								jobtext = " the <b>[member.assigned_role.get_informed_title(member.current)]</b>"
							var/usede = get_display_ckey(member.key)
							data += "<b>[usede]</b> was <span style='color:#e6a962'><b>[member.name]</b>[jobtext]</span> and "
							if(member.current.stat == DEAD)
								data += "<span style='color:#d9534f'>died</span>"
							else
								data += "<span style='color:#4ccf4c'>survived</span>"
						else
							data += "<b>Unknown Villain</b>"

						if(member.antag_datums?.len)
							data += "<div style='margin-left: 15px; margin-top: 5px;'>"
							for(var/datum/antagonist/A in member.antag_datums)
								if(A.objectives.len)
									var/obj_count = 1
									for(var/datum/objective/O in A.objectives)
										var/completed = O.check_completion()
										data += "<div style='margin-bottom: 3px;'>"
										data += "<b>Objective #[obj_count]:</b> [O.explanation_text] "
										data += "<span style='color:[completed ? "#5cb85c" : "#d9534f"]'>"
										data += "[completed ? "(COMPLETED)" : "(FAILED)"]</span>"
										data += "</div>"
										obj_count++
							data += "</div>"
						data += "</div>"
					data += "</div></div>"

				var/current_category
				var/datum/antagonist/previous_category
				sortTim(all_antagonists, GLOBAL_PROC_REF(cmp_antag_category))

				for(var/datum/antagonist/A in all_antagonists)
					if(A.roundend_category != current_category)
						if(previous_category)
							data += "</div></div>"
						data += "<div style='background: #1a0a0a; border: 1px solid #5a3a3a; padding: 12px; border-radius: 4px; margin-bottom: 15px;'>"
						data += "<div style='color: #d4b4b4; font-weight: bold; margin-bottom: 8px;'>[capitalize(A.roundend_category)]</div>"
						data += "<div style='margin-left: 10px;'>"
						current_category = A.roundend_category
						previous_category = A

					data += "<div style='margin-bottom: 10px;'>"
					if(A.owner?.current)
						var/jobtext = ""
						if(A.owner.special_role)
							jobtext = " the <b>[A.owner.special_role]</b>"
						else if(A.owner.assigned_role && A.owner.current)
							jobtext = " the <b>[A.owner.assigned_role.get_informed_title(A.owner.current)]</b>"
						var/usede = get_display_ckey(A.owner.key)
						data += "<b>[usede]</b> was <span style='color:#e6a962'><b>[A.owner.name]</b>[jobtext]</span> and "
						if(A.owner.current.stat == DEAD)
							data += "<span style='color:#d9534f'>died</span>"
						else
							data += "<span style='color:#4ccf4c'>survived</span>"
					else
						data += "<b>Unknown Villain</b>"

					if(A.objectives.len)
						data += "<div style='margin-left: 15px; margin-top: 5px;'>"
						var/obj_count = 1
						for(var/datum/objective/O in A.objectives)
							var/completed = O.check_completion()
							data += "<div style='margin-bottom: 3px;'>"
							data += "<b>Objective #[obj_count]:</b> [O.explanation_text] "
							data += "<span style='color:[completed ? "#5cb85c" : "#d9534f"]'>"
							data += "[completed ? "(COMPLETED)" : "(FAILED)"]</span>"
							data += "</div>"
							obj_count++
						data += "</div>"
					data += "</div>"

				if(all_antagonists.len)
					data += "</div></div>"

		if("Outlaws")
			data += "<div style='text-align: center; color: #ffd494; font-size: 1.2em; margin-bottom: 15px;'>WANTED OUTLAWS</div>"
			data += "<div style='border-top: 1.5px solid #aa8a5a; margin: 0 auto 20px auto; width: 75%;'></div>"

			var/list/outlaws = list()
			for(var/mob/living/carbon/human/outlaw in GLOB.human_list)
				if(outlaw.real_name in GLOB.outlawed_players)
					var/icon/credit_icon = SScrediticons.get_credit_icon(outlaw, TRUE)
					if(credit_icon)
						outlaws += list(list(
							"name" = outlaw.real_name,
							"icon" = credit_icon
						))

			if(!length(outlaws))
				data += "<div style='text-align: center; color: #999; font-style: italic;'>The Realm is peaceful, its inhabitants kind</div>"
			else
				data += {"
				<style>
					.wanted-container {
						display: flex;
						flex-wrap: wrap;
						justify-content: center;
						gap: 20px;
						padding: 15px;
						max-width: calc(200px * 3 + 20px * 2);
						margin: 0 auto;
					}
					.wanted-poster {
						width: 175px;
						height: 228px;
						border: 3px double #5c2c0f;
						background-color: #f5e7d0;
						padding: 8px;
						box-shadow: 3px 3px 5px rgba(0,0,0,0.3);
						font-family: 'Times New Roman', serif;
						display: flex;
						flex-direction: column;
					}
					.wanted-header {
						color: #c70404;
						font-size: 28px;
						font-weight: bold;
						text-align: center;
						margin-bottom: 5px;
						text-transform: uppercase;
					}
					.wanted-divider {
						border-bottom: 2px solid #8B0000;
						margin: 5px 0;
					}
					.wanted-footer {
						color: #8B0000;
						font-size: 16px;
						font-weight: bold;
						text-align: center;
						margin-bottom: 8px;
						text-transform: uppercase;
					}
					.wanted-icon-container {
						width: 120px;
						height: 85px;
						margin: 0 auto;
						border: 2px solid #5c2c0f;
						background-color: #ccac74;
						padding: 3px;
					}
					.wanted-icon {
						width: 100%;
						height: 90%;
						object-fit: cover;
						image-rendering: pixelated;
					}
					.wanted-name-container {
						flex-grow: 1;
						display: flex;
						flex-direction: column;
						justify-content: center;
						min-height: 65px;
						margin-top: 5px;
					}
					.wanted-name {
						color: #000000;
						font-size: 18px;
						font-weight: bold;
						text-align: center;
						padding: 0 5px;
						text-transform: uppercase;
						word-break: break-word;
						overflow: hidden;
						display: -webkit-box;
						-webkit-line-clamp: 3;
						-webkit-box-orient: vertical;
					}
				</style>
				<div class='wanted-container'>
				"}

				for(var/list/outlaw_data in outlaws)
					var/icon_html = ""
					if(outlaw_data["icon"])
						icon_html = "<img class='wanted-icon' src='data:image/png;base64,[icon2base64(outlaw_data["icon"])]'>"
					else
						icon_html = "<div class='wanted-icon' style='background:#8B4513;'></div>"

					data += {"
					<div class='wanted-poster'>
						<div class='wanted-header'>WANTED</div>
						<div class='wanted-divider'></div>
						<div class='wanted-footer'>DEAD OR ALIVE</div>
						<div class='wanted-icon-container'>
							[icon_html]
						</div>
						<div class='wanted-name-container'>
							<div class='wanted-name'>[outlaw_data["name"]]</div>
						</div>
					</div>
					"}

				data += "</div>"

	data += "</div>"

	mob << browse(null, "window=vanderlin_influences")
	var/datum/browser/popup = new(mob, "vanderlin_round_end", "<center>The Chronicle</center>", 1085, 855)
	popup.set_content(data.Join())
	popup.open()

/// Creates a chronicle holder block
/proc/create_chronicle_holder_block(stat_name, include_title = TRUE, is_second_block = FALSE)
	var/list/stat_data = GLOB.chronicle_stats[stat_name]
	if(!stat_data)
		var/initial_title = initial(GLOB.chronicle_stats[stat_name]["title"])
		var/initial_color = initial(GLOB.chronicle_stats[stat_name]["title_color"])
		if(is_second_block)
			return "<div style='margin: 30px 0 15px 0;'><font color='[initial_color]'>[initial_title]</font></div>Nobody"
		else if(include_title)
			return "<div style='margin-bottom: 15px;'><font color='[initial_color]'>[initial_title]</font></div>Nobody"
		else
			return "Nobody"

	var/datum/weakref/mob_weakref = stat_data["holder"]
	var/mob/living/holder = mob_weakref?.resolve()
	if(!holder)
		if(is_second_block)
			return "<div style='margin: 30px 0 15px 0;'><font color='[stat_data["title_color"]]'>[stat_data["title"]]</font></div>Nobody"
		else if(include_title)
			return "<div style='margin-bottom: 15px;'><font color='[stat_data["title_color"]]'>[stat_data["title"]]</font></div>Nobody"
		else
			return "<div style='margin: 30px 0 15px 0;'><font color='[stat_data["title_color"]]'>[stat_data["title"]]</font></div>Nobody"

	var/list/output = list()
	if(include_title)
		output += "<div style='margin-bottom: 15px;'><font color='[stat_data["title_color"]]'>[stat_data["title"]]</font></div>"
	else if(is_second_block)
		output += "<div style='margin: 30px 0 15px 0;'><font color='[stat_data["title_color"]]'>[stat_data["title"]]</font></div>"

	output += {"
	[get_headshot_icon(holder)]
	<div style='margin: 10px 0;'>
		<font color='#e6a962'>[holder.real_name]</font><br>
		<i>[holder.job]</i><br>
		(with <font color='[stat_data["title_color"]]'>[stat_data["value_text"]]</font>)
	</div>
	"}

	return output.Join("")

/// Shows Gods influences menu
/client/proc/show_influences(debug = FALSE)
	if(SSticker.current_state != GAME_STATE_FINISHED && !check_rights(R_ADMIN|R_DEBUG))
		return

	var/list/data = list()

	// Navigation buttons
	data += "<div style='width: 100%; text-align: center; margin: 15px 0;'>"
	data += "<a href='byond://?src=[REF(src)];viewstats=1' style='display: inline-block; width: 120px; padding: 8px 12px; margin: 0 10px; background: #2a2a2a; border: 1px solid #444; color: #ddd; font-weight: bold; text-decoration: none; border-radius: 3px; font-size: 0.9em;'>CHRONICLE</a>"
	data += "<a href='byond://?src=[REF(src)];viewinfluences=1' style='display: inline-block; width: 120px; padding: 8px 12px; margin: 0 10px; background: #2a2a2a; border: 1px solid #444; color: #ddd; font-weight: bold; text-decoration: none; border-radius: 3px; font-size: 0.9em;'>INFLUENCES</a>"
	data += "</div>"

	data += "<div style='margin-bottom: 25px'></div>"

	if(debug && check_rights(R_DEBUG))
		data += "<div style='text-align: center; margin: 10px 0;'>"
		data += "<a href='byond://?src=[REF(src)];viewinfluences=1;debug=[!debug]' style='color: [debug ? "#00FF00" : "#FF0000"];'>[debug ? "DEBUG MODE ON" : "DEBUG MODE OFF"]</a>"
		data += "</div>"

	// Psydon Section
	var/psydonite_user = FALSE
	if(mob)
		if(isliving(mob))
			var/mob/living/living_user_mob = mob
			if(istype(living_user_mob.patron, /datum/patron/psydon))
				psydonite_user = TRUE

	var/psydon_followers = GLOB.patron_follower_counts[/datum/patron/psydon::name] || 0
	var/largest_religion = (psydon_followers > 0)
	if(largest_religion)
		for(var/patron in GLOB.patron_follower_counts)
			if(patron == /datum/patron/psydon::name)
				continue
			if(GLOB.patron_follower_counts[patron] >= psydon_followers)
				largest_religion = FALSE
				break
	var/apostasy_followers = GLOB.patron_follower_counts[/datum/patron/godless/godless::name] + GLOB.patron_follower_counts[/datum/patron/godless/autotheist::name] + GLOB.patron_follower_counts[/datum/patron/godless/defiant::name] + GLOB.patron_follower_counts[/datum/patron/godless/dystheist::name] + GLOB.patron_follower_counts[/datum/patron/godless/naivety::name]|| 0
	var/psydonite_monarch = GLOB.vanderlin_round_stats[STATS_MONARCH_PATRON] == /datum/patron/psydon::name ? TRUE : FALSE
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

	data += "<div style='text-align: center; font-size: 1.3em; color: #c0a828; margin: 20px 0 10px 0;'><b>THE TEN</b></div>"
	data += "<div style='border-top: 3px solid #404040; margin: 0 auto 30px; width: 91.5%;'></div>"

	data += "<div style='width: 91.5%; margin: 0 auto 40px;'>"
	data += "<div style='display: grid; grid-template-columns: repeat(5, 1fr); gap: 20px; margin-bottom: 30px;'>"

	// Astrata
	data += god_ui_block("ASTRATA", "#e7a962", "#642705", /datum/storyteller/astrata, debug)

	// Dendor
	data += god_ui_block("DENDOR", "#412938", "#66745c", /datum/storyteller/dendor, debug)

	// Ravox
	data += god_ui_block("RAVOX", "#2c232d", "#710f0f", /datum/storyteller/ravox, debug)

	// Eora
	data += god_ui_block("EORA", "#a95063", "#e7c3da", /datum/storyteller/eora, debug)

	// Necra
	data += god_ui_block("NECRA", "#2a2459", "#4c82a8", /datum/storyteller/necra, debug)

	data += "</div>"

	data += "<div style='display: grid; grid-template-columns: repeat(5, 1fr); gap: 20px;'>"

	// Noc
	data += god_ui_block("NOC", "#4e72a1", "#282137", /datum/storyteller/noc, debug)

	// Abyssor
	data += god_ui_block("ABYSSOR", "#50090f", "#bbace0", /datum/storyteller/abyssor, debug)

	// Malum
	data += god_ui_block("MALUM", "#3d4139", "#955454", /datum/storyteller/malum, debug)

	// Xylix
	data += god_ui_block("XYLIX", "#7e632c", "#f6feff", /datum/storyteller/xylix, debug)

	// Pestra
	data += god_ui_block("PESTRA", "#517b27", "#1b2a2a", /datum/storyteller/pestra, debug)

	data += "</div></div>"

	// Inhumen Gods Section

	data += "<div style='text-align: center; font-size: 1.3em; color: #AA0000; margin: 20px 0 10px 0;'><b>INHUMEN GODS</b></div>"
	data += "<div style='border-top: 3px solid #404040; margin: 0 auto 30px; width: 91.5%;'></div>"

	data += "<div style='width: 91.5%; margin: 0 auto;'>"
	data += "<div style='display: grid; grid-template-columns: repeat(4, 1fr); grid-auto-rows: 1fr; gap: 20px; margin-bottom: 20px;'>"

	// Matthios
	data += god_ui_block("MATTHIOS", "#20202e", "#99b2b1", /datum/storyteller/matthios, debug)

	// Baotha
	data += god_ui_block("BAOTHA", "#46254a", "#e2abee", /datum/storyteller/baotha, debug)

	// Graggar
	data += god_ui_block("GRAGGAR", "#3b5e51", "#99bbc7", /datum/storyteller/graggar, debug)

	// Zizo
	data += god_ui_block("ZIZO", "#661239", "#ed9da3", /datum/storyteller/zizo, debug)

	data += "</div></div>"

	mob << browse(null, "window=vanderlin_round_end")
	var/datum/browser/popup = new(mob, "vanderlin_influences", "<center>Gods' Influences</center>", 1325, 875)
	popup.set_content(data.Join())
	popup.open()

/// UI block to format information about storyteller god and his influences
/proc/god_ui_block(name, bg_color, title_color, datum/storyteller/storyteller, debug = FALSE)
	var/total_influence = SSgamemode.calculate_storyteller_influence(storyteller)
	var/datum/storyteller/initialized_storyteller = SSgamemode.storytellers[storyteller]
	if(!initialized_storyteller)
		return

	var/dynamic_content = ""
	var/followers = GLOB.patron_follower_counts[initialized_storyteller.name] || 0

	if(!debug)
		dynamic_content += "Number of followers: [followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(storyteller))])<br>"
		for(var/stat in initialized_storyteller.influence_factors)
			var/list/stat_data = initialized_storyteller.influence_factors[stat]
			var/stat_value = GLOB.vanderlin_round_stats[stat] || 0

			dynamic_content += "[stat_data["name"]] [round(stat_value)] ([get_colored_influence_value(SSgamemode.calculate_specific_influence(storyteller, stat))])<br>"
	else
		dynamic_content += "<div style='color: #FFFF00;'><b>DEBUG MODE</b></div>"
		dynamic_content += "Total reigns: [initialized_storyteller.times_chosen]<br>"
		dynamic_content += "Number of followers: [followers] ([get_colored_influence_value(SSgamemode.get_follower_influence(storyteller))])<br>"

		var/datum/storyteller/prototype = new storyteller
		for(var/set_name in prototype.influence_sets)
			var/list/current_set = prototype.influence_sets[set_name]
			for(var/stat in current_set)
				var/list/stat_data = current_set[stat]
				var/stat_value = GLOB.vanderlin_round_stats[stat] || 0
				var/scaling_factor = initialized_storyteller.influence_modifier
				if(stat_data["points"] < 0)
					scaling_factor = 1 / scaling_factor
				var/influence_value = (stat_value * stat_data["points"]) * scaling_factor
				var/is_active = (stat in initialized_storyteller.influence_factors)

				dynamic_content += "<span style='color: [is_active ? "#88f088" : "#f79090"];'>"
				dynamic_content += "[stat_data["name"]] [round(stat_value)] ([get_colored_influence_value(influence_value)])</span><br>"
		qdel(prototype)

	var/suffix = initialized_storyteller.bonus_points >= 0 ? "from wanting to rule" : "from long reign exhaustion"
	var/bonus_display = "<div>([get_colored_influence_value(round(initialized_storyteller.bonus_points))] [suffix])</div>"

	return {"
	<div style='border:6px solid [bg_color]; background:[bg_color]; border-radius:6px; height:100%';>
		<div style='font-weight:bold; font-size:1.2em; padding:8px; color:[title_color]'>[name]</div>
		<div style='padding:8px; background:#111; border-radius:0 0 4px 4px;'>
			<div style='margin-bottom:8px;'>[dynamic_content]</div>
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

/// Global proc to show debug version of gods influences
/client/proc/debug_influences()
	set name = "Debug Gods' Influences"
	set category = "Debug.Debug"

	show_influences(debug = TRUE)
