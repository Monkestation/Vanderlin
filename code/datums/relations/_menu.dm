/datum/tgui_relations
	var/datum/mind/mind

/datum/tgui_relations/New(datum/mind/M)
	mind = M

/datum/tgui_relations/ui_host(mob/user)
	return user

/datum/tgui_relations/ui_state(mob/user)
	return GLOB.always_state

/datum/tgui_relations/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "Relations", "Relations")
		ui.open()

/datum/tgui_relations/ui_data(mob/user)
	var/list/rel_list = list()
	for(var/rel_index in 1 to length(mind.relations))
		var/datum/relation/R = mind.relations[rel_index]
		if(!R.snapshot)
			continue
		var/list/grudge_data = list()
		for(var/history_index in 1 to length(R.relation_history))
			var/datum/history/G = R.relation_history[history_index]
			var/is_gossip = istype(G, /datum/history/gossip)
			var/side_text = is_gossip ? G:heard_text : (mind == G.aggressor) ? G.aggressor_text : G.victim_text
			grudge_data += list(list(
				"label" = G.label,
				"text" = side_text,
				"is_gossip" = is_gossip,
				"rel_index" = rel_index,
				"history_index" = history_index,
				"say_string" = is_gossip ? "Did you hear that [R.snapshot?["name"] || "someone"] [G:heard_text]?" : null,
			))
		rel_list += list(list(
			"name" = R.other?.name,
			"category" = R.category,
			"snapshot" = R.snapshot?.Copy(),
			"desc" = R.desc,
			"grudges" = grudge_data,
			"is_asymmetric" = !R.symmetric,
		))
	var/rival_count = 0
	for(var/datum/relation/R in mind.relations)
		if(istype(R, /datum/relation/rival))
			rival_count++
	var/rival_pref = 1
	if(mind.current?.client?.prefs)
		rival_pref = mind.current.client.prefs.read_preference(/datum/preference/numeric/rival_count)
	return list(
		"relations" = rel_list,
		"rival_count" = rival_count,
		"rival_pref" = rival_pref,
	)

/datum/tgui_relations/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE
	switch(action)
		if("say_gossip")
			var/text = params["text"]
			var/rel_index = params["rel_index"]
			var/history_index = params["history_index"]
			if(!istext(text) || !length(text) || !isnum(rel_index) || !isnum(history_index))
				return FALSE
			text = copytext(text, 1, 280)
			var/mob/living/M = ui.user
			if(!isliving(M))
				return FALSE

			var/datum/relation/R = mind.relations[rel_index]
			if(!R || !R.relation_history)
				return FALSE
			var/datum/history/gossip/matched_gossip = R.relation_history[history_index]
			if(!matched_gossip || !istype(matched_gossip, /datum/history/gossip))
				return FALSE
			var/datum/mind/subject_mind = R.other
			if(!subject_mind)
				return FALSE

			M.say(text)

			for(var/mob/living/carbon/human/listener in range(5, M))
				if(listener == M)
					continue
				if(!listener.mind)
					continue
				var/datum/relation/target_R = SSrelations.get_or_create_gossip_relation(listener.mind, subject_mind)
				if(!target_R)
					continue
				var/datum/history/gossip/G = new matched_gossip.type()
				G.heard_text = matched_gossip.heard_text
				target_R.add_history(G)

			return TRUE
