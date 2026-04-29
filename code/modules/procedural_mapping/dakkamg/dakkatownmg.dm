/obj/effect/landmark/mapGenerator/dakka/dakkatownfield
	mapGeneratorType = /datum/mapGenerator/dakkatownfield
	endTurfX = 155
	endTurfY = 155
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/dakkatownfield
	modules = list(/datum/mapGeneratorModule/dambushing,/datum/mapGeneratorModule/dakkatownfield,/datum/mapGeneratorModule/dakkatownfield/road,/datum/mapGeneratorModule/dakkatownfield/grass)

/datum/mapGeneratorModule/dakkatownfield
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/newtree = 5,
							/obj/structure/flora/grass/bush_meagre = 13,
							/obj/structure/flora/grass/pyroclasticflowers = 1,
							/obj/structure/flora/grass = 50,
							/obj/structure/flora/grass/maneater = 1,
							/obj/item/natural/stone = 8,
							/obj/item/natural/rock = 7,
							/obj/item/grown/log/tree/stick = 3,
							/obj/structure/closet/dirthole/closed/loot=6,
							/obj/item/restraints/legcuffs/beartrap/armed/camouflage=0.5)
	spawnableTurfs = list(/turf/open/floor/dirt/road=5)
	allowed_areas = list(/area/outdoors/basin)

/datum/mapGeneratorModule/dakkatownfield/road
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road)
	excluded_turfs = list()
	spawnableAtoms = list(/obj/item/natural/stone = 8,
							/obj/item/grown/log/tree/stick = 3)
	allowed_areas = list(/area/outdoors/basin)

/datum/mapGeneratorModule/dakkatownfield/grass
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableTurfs = list(/turf/open/floor/grass = 15)
	allowed_areas = list(/area/outdoors/basin)
