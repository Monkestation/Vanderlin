/obj/effect/landmark/mapGenerator/dakka/beach
	mapGeneratorType = /datum/mapGenerator/dbeach
	endTurfX = 155
	endTurfY = 45
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/dbeach
	modules = list(/datum/mapGeneratorModule/dbeach)

/datum/mapGeneratorModule/dbeach
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS|CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/outdoors/beach)
	spawnableAtoms = list(	/obj/item/natural/stone = 11,
							/obj/item/grown/log/tree/stick = 1)
