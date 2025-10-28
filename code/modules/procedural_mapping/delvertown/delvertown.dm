/obj/effect/landmark/mapGenerator/delvertown
	mapGeneratorType = /datum/mapGenerator/delvertown
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/delvertown
	modules = list(
				/datum/mapGeneratorModule/delvertown,
				/datum/mapGeneratorModule/plains,
				/datum/mapGeneratorModule/marsh,
				// /datum/mapGeneratorModule/woods,
				// /datum/mapGeneratorModule/river,
				// /datum/mapGeneratorModule/mountain,)
	)

/datum/mapGeneratorModule/delvertown // Grass and other misc atoms for most of the map
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/grass, /turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/grass = 80,
						/obj/structure/flora/ausbushes/sparsegrass = 20,
						/obj/item/natural/rock = 4,
						/obj/structure/flora/grass/bush = 5,
						/obj/structure/flora/grass/bush_meagre = 3,
						// /obj/structure/flora/ausbushes/lavendergrass = 10,
						// /obj/structure/flora/grass/herb/salvia = 8,
						/obj/structure/flora/newtree = 5,
						/obj/structure/table/wood/treestump = 4,)
	allowed_areas = list(/area/rogue/delver/town, /area/rogue/delver/plains, /area/rogue/delver/woods)

/datum/mapGeneratorModule/plains
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/grass, /turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/ausbushes/brflowers = 10)
	allowed_areas = list(/area/rogue/delver/plains)
