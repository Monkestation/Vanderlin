/obj/effect/landmark/mapGenerator/dakka/mountain
	mapGeneratorType = /datum/mapGenerator/dmtn
	endTurfX = 155
	endTurfY = 155
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/dmtn
	modules = list(/datum/mapGeneratorModule/dambushing,/datum/mapGeneratorModule/dmtn)

/datum/mapGeneratorModule/dmtn
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/roguerock=5,/obj/item/natural/stone = 18,/obj/item/natural/rock = 10)
	allowed_areas = list(/area/outdoors/mountains,/area/outdoors/mountains/deception)
