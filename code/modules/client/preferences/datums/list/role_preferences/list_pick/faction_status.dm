/datum/preference/list_type/role_setting/picker/faction_standing
	savefile_key = "faction_standing"
	setting_display_name = "Merchant Faction Standing"
	ui_category = "Merchant"
	max_lines = 1
	string = TRUE
	picker_options = list(
		"Loved by Zalad (Hated by Others)",
		"Loved by Coastal (Hated by Others)",
		"Loved by Mountain Clans (Hated by Others)",
		"Liked by Zalad (Disliked by Others)",
		"Liked by Coastal (Disliked by Others)",
		"Liked by Mountain Clans (Disliked by Others)",
	)
	post_job_pref = TRUE
	job_types = list(
		/datum/job/merchant
	)

	var/static/list/faction_standing_map = list(
		"Loved by Zalad (Hated by Others)" = list(/datum/world_faction/zalad_traders, "loved"),
		"Loved by Coastal (Hated by Others)" = list(/datum/world_faction/coastal_merchants, "loved"),
		"Loved by Mountain Clans (Hated by Others)" = list(/datum/world_faction/mountain_clans, "loved"),
		"Liked by Zalad (Disliked by Others)" = list(/datum/world_faction/zalad_traders, "liked"),
		"Liked by Coastal (Disliked by Others)" = list(/datum/world_faction/coastal_merchants, "liked"),
		"Liked by Mountain Clans (Disliked by Others)" = list(/datum/world_faction/mountain_clans, "liked"),
	)

/datum/preference/list_type/role_setting/picker/faction_standing/post_job_apply(mob/living/carbon/human/H, value, client/client)
	if(!islist(value))
		return

	var/selected_text
	for(var/entry in value)
		selected_text = entry
		break

	if(!selected_text)
		return

	var/list/mapped = faction_standing_map[selected_text]
	if(!mapped)
		return

	var/favored_type = mapped[1]
	var/standing_level = mapped[2]

	var/boost_tiers
	var/penalty_tiers

	if(standing_level == "loved")
		boost_tiers = 2
		penalty_tiers = 1.5
	else if(standing_level == "liked")
		boost_tiers = 1
		penalty_tiers = 0.75
	else
		return

	var/datum/world_faction/favored_faction

	for(var/datum/world_faction/faction in SSmerchant.world_factions)
		if(istype(faction, favored_type))
			favored_faction = faction
		else
			faction.adjust_reputation_by_tier(-penalty_tiers)

	if(!favored_faction)
		return // Faction wasn't instantiated for this map (allowed_maps mismatch) - nothing to favor

	favored_faction.adjust_reputation_by_tier(boost_tiers)
	SSmerchant.set_active_faction(favored_faction)
