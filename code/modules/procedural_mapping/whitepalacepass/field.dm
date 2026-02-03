/obj/effect/landmark/mapGenerator/whitepalacepass/field
	mapGeneratorType = /datum/mapGenerator/wppfields
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/wppfields
	modules = list(/datum/mapGeneratorModule/ambushing,
				/datum/mapGeneratorModule/wppsnow,
				/datum/mapGeneratorModule/wppsnow/grass,
				/datum/mapGeneratorModule/wppsnow/grass/patchy,
				/datum/mapGeneratorModule/wppdirt,
				/datum/mapGeneratorModule/wppdirt/grass,
				/datum/mapGeneratorModule/wppdirt/road,
				/datum/mapGeneratorModule/wppgrass,
				/datum/mapGeneratorModule/wppgrass/grass)

/datum/mapGeneratorModule/wppsnow
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	clusterMax = 2
	clusterMin = 1
	allowed_turfs = list(/turf/open/floor/snow,
							/turf/open/floor/snow/rough)
	excluded_turfs = list(/turf/open/floor/snow/patchy)
	spawnableAtoms = list(/obj/structure/flora/grass/bush/tundra = 3,
							/obj/structure/flora/grass/bush_meagre/tundra = 14,
							/obj/structure/flora/grass/bush/wall/tall/tundra = 0.25,
							/obj/structure/flora/grass/herb/random = 1,
							/obj/structure/flora/grass/maneater = 1,
							/obj/structure/flora/grass/pyroclasticflowers = 1,
							/obj/item/natural/stone = 2,
							/obj/item/natural/rock = 4,
							/obj/item/grown/log/tree/stick = 6)
	spawnableTurfs = list(/turf/open/floor/snow/rough = 10,
							/turf/open/floor/snow/patchy = 10,
							/turf/open/floor/grass/cold = 5)
	allowed_areas = list(/area/outdoors/basin,
							/area/outdoors/basin/safe)

/datum/mapGeneratorModule/wppsnow/grass
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/snow,
							/turf/open/floor/snow/rough)
	excluded_turfs = list()
	spawnableAtoms = list(/obj/structure/flora/grass/tundra = 5)
	spawnableTurfs = list()
	allowed_areas = list(/area/outdoors/basin,
							/area/outdoors/basin/safe,
							/area/outdoors/town)

/datum/mapGeneratorModule/wppsnow/grass/patchy
		allowed_turfs = list(/turf/open/floor/snow/patchy)
		spawnableAtoms = list(/obj/structure/flora/grass/tundra = 25)

/datum/mapGeneratorModule/wppdirt
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	clusterMax = 2
	clusterMin = 1
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/grass/bush/tundra = 3,
							/obj/structure/flora/grass/bush_meagre/tundra = 14,
							/obj/structure/flora/grass/bush/wall/tall/tundra = 0.25,
							/obj/structure/flora/grass/herb/random = 1,
							/obj/structure/flora/grass/maneater = 1,
							/obj/structure/flora/grass/pyroclasticflowers = 1,
							/obj/item/natural/stone = 8,
							/obj/item/natural/rock = 4,
							/obj/item/grown/log/tree/stick = 8,
							/obj/structure/closet/dirthole/closed/loot=0.75,
							/obj/item/restraints/legcuffs/beartrap/armed/camouflage=0.5)
	spawnableTurfs = list(/turf/open/floor/dirt/road=5)
	allowed_areas = list(/area/outdoors/basin,
							/area/outdoors/basin/safe)

/datum/mapGeneratorModule/wppdirt/grass
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/grass/tundra = 10)
	allowed_areas = list(/area/outdoors/basin,
							/area/outdoors/basin/safe,
							/area/outdoors/town)

/datum/mapGeneratorModule/wppdirt/road
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/dirt/road)
	excluded_turfs = list()
	spawnableAtoms = list(/obj/structure/flora/grass/tundra = 5,
							/obj/item/natural/stone = 4,
							/obj/item/natural/rock = 1,
							/obj/item/grown/log/tree/stick = 4)
	allowed_areas = list(/area/outdoors/basin,
							/area/outdoors/basin/safe,
							/area/outdoors/town)

/datum/mapGeneratorModule/wppgrass
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	clusterMax = 2
	clusterMin = 1
	allowed_turfs = list(/turf/open/floor/grass/cold,
							/turf/open/floor/grass/yel)
	excluded_turfs = list()
	spawnableAtoms = list(/obj/structure/flora/grass/bush/tundra = 3,
							/obj/structure/flora/grass/bush_meagre/tundra = 14,
							/obj/structure/flora/grass/bush/wall/tall/tundra = 0.25,
							/obj/structure/flora/grass/herb/random = 1,
							/obj/structure/flora/grass/maneater = 1,
							/obj/structure/flora/grass/pyroclasticflowers = 1,
							/obj/item/natural/stone = 8,
							/obj/item/natural/rock = 2,
							/obj/item/grown/log/tree/stick = 8)
	spawnableTurfs = list()
	allowed_areas = list(/area/outdoors/basin,
							/area/outdoors/basin/safe)

/datum/mapGeneratorModule/wppgrass/grass
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/grass/cold)
	excluded_turfs = list()
	spawnableAtoms = list(/obj/structure/flora/grass/tundra = 50)
	spawnableTurfs = list()
	allowed_areas = list(/area/outdoors/basin,
							/area/outdoors/basin/safe,
							/area/outdoors/town)
