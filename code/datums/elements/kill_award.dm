/// Element that grants an achievement to all mobs around the owner when it dies, different to one that forces participation.
/datum/element/kill_achievement
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// Achievements to grant when killed
	var/list/achievement_types = null
	/// Range in which to grant the achievement
	var/achievement_range = 7
	/// Blackbox tally string to record kills into
	var/tally_string = "interesting_kill"

/datum/element/kill_achievement/Attach(datum/target, list/achievement_types, achievement_range = 7, tally_string = "interesting_kill")
	. = ..()
	if (!isliving(target) || !length(achievement_types))
		return ELEMENT_INCOMPATIBLE
	src.achievement_types = achievement_types
	src.achievement_range = achievement_range
	src.tally_string = tally_string
	RegisterSignal(target, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/element/kill_achievement/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_LIVING_DEATH)

/datum/element/kill_achievement/proc/on_death(mob/living/source, gibbed)
	SIGNAL_HANDLER

	if ((source.flags_1 & ADMIN_SPAWNED_1) || !SSachievements.achievements_enabled)
		return

	var/turf/our_loc = get_turf(source)
	if (!our_loc)
		return

	for (var/mob/living/player in SSmobs.clients_by_zlevel[our_loc.z])
		var/turf/player_turf = get_turf(player)
		if (player.stat || get_dist(player_turf, source) > achievement_range)
			continue

		for (var/achievement_type in achievement_types)
			player.client.give_award(achievement_type, player)

	SSblackbox.record_feedback("tally", "[tally_string]", 1, "[initial(source.name)]")
