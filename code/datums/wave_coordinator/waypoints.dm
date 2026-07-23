GLOBAL_LIST_EMPTY(wave_defense_landmarks)

/obj/effect/landmark/wave_defense
	name = "wave defense point"
	icon_state = "x2"
	/// Which waypoint set this belongs to
	var/set_id
	/// Order within that set, lower goes first
	var/order = 1

/obj/effect/landmark/wave_defense/Initialize(mapload)
	. = ..()
	GLOB.wave_defense_landmarks += src

/obj/effect/landmark/wave_defense/Destroy()
	GLOB.wave_defense_landmarks -= src
	return ..()

/proc/cmp_wave_landmark_order(obj/effect/landmark/wave_defense/a, obj/effect/landmark/wave_defense/b)
	return a.order - b.order

/proc/get_wave_defense_points(set_id)
	var/list/matching = list()
	for(var/obj/effect/landmark/wave_defense/landmark in GLOB.wave_defense_landmarks)
		if(landmark.set_id == set_id)
			matching += landmark

	if(!length(matching))
		CRASH("get_wave_defense_points: no landmarks found for set_id [set_id]")

	sortTim(matching, /proc/cmp_wave_landmark_order)

	var/list/atom/turfs = list()
	for(var/obj/effect/landmark/wave_defense/landmark as anything in matching)
		turfs += get_turf(landmark)
	return turfs
