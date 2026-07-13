SUBSYSTEM_DEF(regionthreat)
	name = "Regional Threat"
	wait = 5 MINUTES
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME
	var/list/threat_regions = list()
	COOLDOWN_DECLARE(harlequinn_spawn_cooldown)

/datum/controller/subsystem/regionthreat/Initialize(start_timeofday)
	for(var/datum/threat_region/region as anything in subtypesof(/datum/threat_region))
		if(IS_ABSTRACT(region))
			continue
		threat_regions += new region()
	return ..()

/datum/controller/subsystem/regionthreat/fire(resumed)
	var/player_count = length(GLOB.player_list)
	var/ishighpop = player_count >= HIGHPOP_THRESHOLD

	for(var/datum/threat_region/TR as anything in threat_regions)
		if(ishighpop)
			TR.increase_latent_ambush(TR.highpop_tick)
		else
			TR.increase_latent_ambush(TR.lowpop_tick)

		if(TR.latent_ambush >= TR.max_ambush)
			trigger_invasion(TR)

/datum/controller/subsystem/regionthreat/proc/trigger_invasion(datum/threat_region/TR)
	if(!COOLDOWN_FINISHED(TR, invasion_cooldown))
		return

	COOLDOWN_START(TR, invasion_cooldown, 30 MINUTES)

	log_game("THREAT: [TR.region_name] reached invasion threshold ([TR.latent_ambush]). Triggering invasion.")
	message_admins("THREAT: [TR.region_name] has reached invasion threshold! Invasion triggered.")

	TR.on_invasion_threshold()


/datum/controller/subsystem/regionthreat/proc/get_region(region_name)
	for(var/datum/threat_region/TR as anything in threat_regions)
		if(TR.region_name == region_name)
			return TR
	return null

/datum/controller/subsystem/regionthreat/proc/get_region_for_turf(turf/T)
	if(!T)
		return null
	var/area/area = get_area(T)
	for(var/datum/threat_region/TR as anything in threat_regions)
		if(TR.region_name == area.threat_region)
			return TR
	return null

/datum/threat_region_display
	var/region_name
	var/danger_level
	var/danger_color

/datum/controller/subsystem/regionthreat/proc/get_threat_regions_for_display()
	var/list/threat_region_displays = list()
	for(var/datum/threat_region/TR as anything in threat_regions)
		var/datum/threat_region_display/TRS = new /datum/threat_region_display
		TRS.region_name = TR.region_name
		TRS.danger_level = TR.get_danger_level()
		TRS.danger_color = TR.get_danger_color()
		threat_region_displays += TRS
	return threat_region_displays
