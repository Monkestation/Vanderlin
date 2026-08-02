/datum/gossip_prefs
	var/mob/living/carbon/human/holder

/datum/gossip_prefs/New(mob/living/carbon/human/H)
	holder = H

/datum/gossip_prefs/ui_state(mob/user)
	return GLOB.always_state

/datum/gossip_prefs/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "GossipPrefs", "Gossip & Rumors")
		ui.open()

/datum/gossip_prefs/ui_data(mob/user)
	var/list/rumors = list()
	var/list/noble_gossip = list()

	if(holder?.client?.prefs)
		var/list/r = holder.client.prefs.read_preference(/datum/preference/list_type/rumors)
		for(var/text in r)
			rumors += text
		var/list/ng = holder.client.prefs.read_preference(/datum/preference/list_type/noble_gossip)
		for(var/text in ng)
			noble_gossip += text

	return list(
		"rumors" = rumors,
		"noble_gossip" = noble_gossip,
		"max_rumors" = MAX_RUMORS,
		"max_noble_gossip" = MAX_NOBLE_GOSSIP,
		"rival_count" = holder?.client?.prefs.read_preference(/datum/preference/numeric/rival_count),
		"rival_count_min" = /datum/preference/numeric/rival_count::minimum,
		"rival_count_max" = /datum/preference/numeric/rival_count::maximum,
	)

/datum/gossip_prefs/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	if(!holder?.client?.prefs)
		return FALSE

	switch(action)
		if("add_rumor")
			var/text = trim(params["text"])
			if(!length(text) || length(text) > MAX_GOSSIP_LENGTH)
				return FALSE
			var/list/current = holder.client.prefs.read_preference(/datum/preference/list_type/rumors)
			if(current.len >= MAX_RUMORS)
				return FALSE
			current += text
			holder.client.prefs.write_preference(/datum/preference/list_type/rumors, current)
			return TRUE

		if("remove_rumor")
			var/idx = params["index"]
			if(!isnum(idx))
				return FALSE
			var/list/current = holder.client.prefs.read_preference(/datum/preference/list_type/rumors)
			if(idx < 1 || idx > current.len)
				return FALSE
			current.Remove(current[idx])
			holder.client.prefs.write_preference(/datum/preference/list_type/rumors, current)
			return TRUE

		if("edit_rumor")
			var/idx = params["index"]
			var/text = trim(params["text"])
			if(!isnum(idx) || !length(text) || length(text) > MAX_GOSSIP_LENGTH)
				return FALSE
			var/list/current = holder.client.prefs.read_preference(/datum/preference/list_type/rumors)
			if(idx < 1 || idx > current.len)
				return FALSE
			current[idx] = text
			holder.client.prefs.write_preference(/datum/preference/list_type/rumors, current)
			return TRUE

		if("add_noble_gossip")
			var/text = trim(params["text"])
			if(!length(text) || length(text) > MAX_GOSSIP_LENGTH)
				return FALSE
			var/list/current = holder.client.prefs.read_preference(/datum/preference/list_type/noble_gossip)
			if(current.len >= MAX_NOBLE_GOSSIP)
				return FALSE
			current += text
			holder.client.prefs.write_preference(/datum/preference/list_type/noble_gossip, current)
			return TRUE

		if("remove_noble_gossip")
			var/idx = params["index"]
			if(!isnum(idx))
				return FALSE
			var/list/current = holder.client.prefs.read_preference(/datum/preference/list_type/noble_gossip)
			if(idx < 1 || idx > current.len)
				return FALSE
			current.Remove(current[idx])
			holder.client.prefs.write_preference(/datum/preference/list_type/noble_gossip, current)
			return TRUE

		if("edit_noble_gossip")
			var/idx = params["index"]
			var/text = trim(params["text"])
			if(!isnum(idx) || !length(text) || length(text) > MAX_GOSSIP_LENGTH)
				return FALSE
			if(!HAS_TRAIT(holder, TRAIT_NOBLE_BLOOD) && !HAS_TRAIT(holder, TRAIT_NOBLE_POWER))
				return FALSE
			var/list/current = holder.client.prefs.read_preference(/datum/preference/list_type/noble_gossip)
			if(idx < 1 || idx > current.len)
				return FALSE
			current[idx] = text
			holder.client.prefs.write_preference(/datum/preference/list_type/noble_gossip, current)
			return TRUE

		if("set_rival_count")
			var/val = params["value"]
			if(!isnum(val))
				return FALSE
			val = round(val)
			if(val < /datum/preference/numeric/rival_count::minimum || val > /datum/preference/numeric/rival_count::maximum)
				return FALSE
			holder.client.prefs.write_preference(/datum/preference/numeric/rival_count, val)
			return TRUE
