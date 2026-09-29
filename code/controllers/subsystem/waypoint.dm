///I like this as a waypoint since its easier to debug
SUBSYSTEM_DEF(waypoints)
	name = "Waypoints"
	flags = SS_NO_FIRE

	var/list/mob/living/active_guides = list()
	///this is incase we have some weird lag and need to stop this for some reason
	var/stop_the_paths = FALSE

/datum/controller/subsystem/waypoints/proc/set_waypoint(mob/living/user, atom/target)
	var/datum/waypoint_guide/existing = active_guides[user]
	if(existing)
		qdel(existing) // replaces old trail with new one

	if(stop_the_paths)
		return
	active_guides[user] = new /datum/waypoint_guide(user, target)

/datum/controller/subsystem/waypoints/proc/clear_waypoint(mob/living/user)
	var/datum/waypoint_guide/existing = active_guides[user]
	if(existing)
		qdel(existing)
	active_guides -= user
