//genstuff
/obj/effect/landmark/mapGenerator/wyrmwood_cave
	mapGeneratorType = /datum/mapGenerator/wyrmwood_cave
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/wyrmwood_cave
	modules = list(/datum/mapGeneratorModule/ambushing,/datum/mapGeneratorModule/cavern)


/datum/mapGeneratorModule/cavern
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt,/turf/open/floor/cobblerock, /turf/open/floor/naturalstone)
	spawnableAtoms = list(/obj/item/natural/stone = 15,
						/obj/item/natural/rock = 10,
						/obj/item/natural/rock/random_ore = 5,
						/obj/structure/flora/shroom_tree = 5,
						/obj/item/restraints/legcuffs/beartrap/armed = 2)
	allowed_areas = list(/area/indoors/cave)
