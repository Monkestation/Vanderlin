/obj/effect/landmark/mapGenerator/rosewood/cave
	mapGeneratorType = /datum/mapGenerator/rosewoodcaves
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/rosewoodcaves
	modules = list(/datum/mapGeneratorModule/ambushing,
				/datum/mapGeneratorModule/rosewoodcave,
				/datum/mapGeneratorModule/rosewoodcave/dirt,
				/datum/mapGeneratorModule/rosewoodcave/sewers,
				/datum/mapGeneratorModule/rosewoodcave/wet)

/datum/mapGeneratorModule/rosewoodcave
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	clusterMax = 3
	clusterMin = 1
	allowed_turfs = list(/turf/open/floor/naturalstone)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/roguerock = 5,
							/obj/item/natural/stone = 10,
							/obj/structure/essence_node = 0.2,
							/obj/item/natural/rock = 3,
							/obj/item/natural/rock/random = 0.5)
	spawnableTurfs = list(/turf/open/floor/cobblerock = 25,
							/turf/open/floor/dirt = 10)
	allowed_areas = list(/area/under/cave,
							/area/under/cavewet)

/datum/mapGeneratorModule/rosewoodcave/dirt
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	clusterMax = 3
	clusterMin = 2
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/grass/herb/random = 1,
							/obj/item/grown/log/tree/stick = 4,
							/obj/structure/flora/grass/bush_meagre/tundra = 1)
	spawnableTurfs = list()
	allowed_areas = list(/area/under/cave,
							/area/under/cavewet)

/datum/mapGeneratorModule/rosewoodcave/sewers
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/water/sewer)
	excluded_turfs = list()
	spawnableAtoms = list(/obj/structure/kneestingers = 10,
							/obj/structure/flora/grass/water = 4,
							/obj/structure/flora/grass/water/reeds = 2)
	spawnableTurfs = list()
	allowed_areas = list(/area/under/town/sewer)

/datum/mapGeneratorModule/rosewoodcave/wet
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/water/cleanshallow)
	excluded_turfs = list()
	spawnableAtoms = list(/obj/structure/kneestingers = 3,
							/obj/structure/flora/grass/water = 4,
							/obj/structure/flora/grass/water/reeds = 8)
	spawnableTurfs = list()
	allowed_areas = list(/area/under/cavewet)
