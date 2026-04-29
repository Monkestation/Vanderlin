SUBSYSTEM_DEF(achievements)
	name = "Achievements"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_ACHIEVEMENTS
	var/achievements_enabled = TRUE
	/// Typepath -> datum/award/achievement instances
	var/list/datum/award/achievement/achievements = list()
	/// Typepath -> datum/award/score instances
	var/list/datum/award/score/scores = list()
	/// Typepath -> all award instances (achievements + scores)
	var/list/datum/award/awards = list()

/datum/controller/subsystem/achievements/Initialize(timeofday)
	// Instantiate all award singletons
	for(var/T in subtypesof(/datum/award/achievement))
		var/datum/award/A = new T
		if(!A.name) // Skip abstract types
			qdel(A)
			continue
		achievements[T] = A
		awards[T] = A

	for(var/T in subtypesof(/datum/award/score))
		var/datum/award/A = new T
		if(!A.name)
			qdel(A)
			continue
		scores[T] = A
		awards[T] = A

	// Initialize any clients that connected before the subsystem was ready
	for(var/client/C in GLOB.clients)
		if(C.player_details?.achievements && !C.player_details.achievements.initialized)
			C.player_details.achievements.InitializeData()

	return ..()

/datum/controller/subsystem/achievements/Shutdown()
	force_save_all()

/// Flush any in-memory achievement state for all online players
/datum/controller/subsystem/achievements/proc/force_save_all()
	for(var/ckey in GLOB.player_details)
		var/datum/player_details/PD = GLOB.player_details[ckey]
		if(!PD?.achievements?.initialized)
			continue
		PD.achievements.save_achievements()
