//genstuff
/obj/effect/landmark/mapGenerator/decap
	mapGeneratorType = /datum/mapGenerator/decap
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/decap
	modules = list(/datum/mapGeneratorModule/ambushing,/datum/mapGeneratorModule/decapdirt,/datum/mapGeneratorModule/decaproad)


/datum/mapGeneratorModule/decapdirt
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/tree/burnt = 30,
							/obj/structure/flora/grass/bush_meagre = 25,
							/obj/structure/flora/grass = 23,
							/obj/structure/flora/grass/maneater = 13,
							/obj/item/natural/stone = 23,
							/obj/item/natural/rock = 8,
							/obj/item/grown/log/tree/stick = 16,
							/obj/structure/closet/dirthole/closed/loot = 3,
							/obj/item/restraints/legcuffs/beartrap/armed/camouflage = 7,
							/obj/structure/flora/grass/maneater/real = 0,
							/obj/structure/flora/grass/pyroclasticflowers = 15)
	spawnableTurfs = list(/turf/open/lava = 2,/turf/open/floor/dirt/road = 36)
	allowed_areas = list(/area/outdoors/mountains/decap)

/datum/mapGeneratorModule/decaproad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 23,/obj/item/natural/rock = 8,/obj/item/grown/log/tree/stick = 6)
	allowed_areas = list(/area/outdoors/mountains/decap)
