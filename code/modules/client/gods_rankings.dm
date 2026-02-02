/proc/check_roundstart_gods_rankings()
	var/list/storytellers = list()
	for(var/storyteller_name in SSgamemode.storytellers)
		var/datum/storyteller/initialized_storyteller = SSgamemode.storytellers[storyteller_name]
		if(initialized_storyteller)
			storytellers += initialized_storyteller

	sortTim(storytellers, GLOBAL_PROC_REF(cmp_storyteller_ranking))

	for(var/i in 1 to length(storytellers))
		var/datum/storyteller/initialized_storyteller = storytellers[i]

		// Top 3 penalties
		if(i == 1)
			initialized_storyteller.influence_modifier = 0.925
		else if(i == 2)
			initialized_storyteller.influence_modifier = 0.95
		else if(i == 3)
			initialized_storyteller.influence_modifier = 0.975

		// Bottom 3 bonuses
		else if(i == length(storytellers))
			initialized_storyteller.influence_modifier = 1.075
		else if(i == (length(storytellers) - 1))
			initialized_storyteller.influence_modifier = 1.05
		else if(i == (length(storytellers) - 2))
			initialized_storyteller.influence_modifier = 1.025

/proc/handle_god_ascensions()
	if(length(GLOB.clients) < 50)
		return

	var/json_file = file("data/gods_rankings.json")
	if(!fexists(json_file))
		return

	var/list/json = json_decode(file2text(json_file))
	var/modified = FALSE

	for(var/storyteller_name in SSgamemode.storytellers)
		var/datum/storyteller/initialized_storyteller = SSgamemode.storytellers[storyteller_name]
		if(!initialized_storyteller)
			continue

		var/points = json[initialized_storyteller.name] || 0
		if(points >= 100)
			modified = TRUE
			json[initialized_storyteller.name] = 0
			initialized_storyteller.ascendant = TRUE
			adjust_storyteller_influence(initialized_storyteller.name, 500)

			for(var/datum/round_event_control/listed as anything in SSgamemode.control)
				listed.occurrences = 0
				listed.last_round_occurrences = 0

			for(var/client/C in GLOB.clients)
				if(!C?.mob)
					continue
				C.mob.playsound_local(C.mob, GLOB.patron_sound_themes[initialized_storyteller.name], initialized_storyteller.name == RAVOX ? 70 : 100)

			bordered_message(world, list(
				"<span style='font-size: 180%; color: [initialized_storyteller.color_theme]'>[initialized_storyteller.name] is ascendant!</span>",
			))
			break

	if(modified)
		fdel(json_file)
		WRITE_FILE(json_file, json_encode(json))

/proc/get_god_rankings()
	var/json_file = file("data/gods_rankings.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
		return list()

	var/list/json = json_decode(file2text(json_file))
	return json

/proc/update_god_rankings()
	var/most_influential
	var/most_frequent
	var/highest_influence = -1
	var/highest_chosen = -1
	var/list/all_storytellers = list()

	for(var/storyteller_name in SSgamemode.storytellers)
		var/datum/storyteller/initialized_storyteller = SSgamemode.storytellers[storyteller_name]
		if(!initialized_storyteller)
			continue

		all_storytellers += initialized_storyteller.name

		var/influence = SSgamemode.calculate_storyteller_influence(initialized_storyteller.type)
		if(influence > highest_influence)
			highest_influence = influence
			most_influential = initialized_storyteller.name

		if(initialized_storyteller.times_chosen > highest_chosen)
			highest_chosen = initialized_storyteller.times_chosen
			most_frequent = initialized_storyteller.name

	if(!most_influential || !most_frequent)
		return

	var/json_file = file("data/gods_rankings.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))

	var/current_points_influential = json[most_influential] || 0
	var/current_points_frequent = json[most_frequent] || 0

	var/list/eligible_storytellers = all_storytellers - list(most_influential, most_frequent)

	if(most_influential == most_frequent)
		json[most_influential] = min(current_points_influential + 3, 100)
	else
		json[most_influential] = min(current_points_influential + 1, 100)
		json[most_frequent] = min(current_points_frequent + 2, 100)

	if(length(eligible_storytellers) > 0)
		var/random_god = pick(eligible_storytellers)
		var/current_points_random = json[random_god] || 0
		json[random_god] = min(current_points_random + 1, 100)

	fdel(json_file)
	WRITE_FILE(json_file, json_encode(json))

/proc/cmp_god_ranking(list/a, list/b)
	return b["points"] - a["points"]

/proc/cmp_storyteller_ranking(datum/storyteller/a, datum/storyteller/b)
	var/list/json = get_god_rankings()
	return (json[b.name] || 0) - (json[a.name] || 0)

/proc/create_god_ranking_entry(god_name, points, color_theme)
	var/percentage = min(points, 100)

	return {"
	<div style='margin-bottom: 8px;'>
		<div style='display: flex; align-items: center; gap: 8px;'>
			<div style='width: 80px; margin-left: 40px; color: [color_theme];'>[god_name]</div>
			<div style='flex-grow: 1; background: #333; height: 20px;'>
				<div style='width: [percentage]%; height: 100%; background: [color_theme];'></div>
			</div>
			<div style='width: 50px; text-align: right;'>[points]/100</div>
		</div>
	</div>
	"}
