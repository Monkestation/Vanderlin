
/obj/effect/landmark/mapGenerator/mountain
	mapGeneratorType = /datum/mapGenerator/mtn
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/mtn
	modules = list(/datum/mapGeneratorModule/ambushing,/datum/mapGeneratorModule/mtn)

/datum/mapGeneratorModule/mtn
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/roguerock=5,/obj/item/natural/stone = 18,/obj/item/natural/rock = 10)
	allowed_areas = list(/area/outdoors/mountains,/area/outdoors/mountains/deception)
