/datum/map_template/broodmother_entry
	width = 11
	height = 9

	id = "broodmother_entry"
	name = "Broodmother Sinkhole"
	mappath = "_maps/templates/broodmother/broodmother_hole.dmm"

/obj/effect/mapping_helpers/broodmother_entry
	name = "broodmother_spawner"
	late = TRUE

/obj/effect/mapping_helpers/broodmother_entry/LateInitialize()
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(spawn_entry))

/obj/effect/mapping_helpers/broodmother_entry/proc/spawn_entry()
	var/turf/turf = get_turf(src)
	var/datum/map_template/template = new /datum/map_template/broodmother_entry()
	template.load(turf, TRUE)

	for(var/mob/listener as anything in GLOB.player_list)
		var/turf/listener_turf = get_turf(listener)
		if(!listener_turf || !is_in_zweb(listener_turf.z, turf.z))
			continue
		var/distance = get_dist(turf, listener_turf)
		if(turf == listener_turf)
			distance = 0
		var/base_shake_amount = sqrt(10 / (distance + 1))

		if(distance <= round(10 + world.view - 2, 1))
			shake_camera(listener, 3 SECONDS, clamp(base_shake_amount, 0, 5))
		else
			base_shake_amount = max(base_shake_amount,  3, 0) // Devastating explosions rock the station and ground
			shake_camera(listener, 2 SECONDS, min(base_shake_amount, 1.5))
	qdel(src)
