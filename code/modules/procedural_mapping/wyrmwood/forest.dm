//genstuff
/obj/effect/landmark/mapGenerator/wyrmwood_forest
	mapGeneratorType = /datum/mapGenerator/wyrmwood_forest
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/wyrmwood_forest
	modules = list(
		/datum/mapGeneratorModule/ambushing,
		/datum/mapGeneratorModule/wyrmwood_forestgrassturf,
		/datum/mapGeneratorModule/wyrmwood_forest,
		/datum/mapGeneratorModule/wyrmwood_forestroad,
		/datum/mapGeneratorModule/wyrmwood_forestgrass,
		/datum/mapGeneratorModule/wyrmwood_forestswampwaterturf,
		/datum/mapGeneratorModule/wyrmwood_forestwaterturf,
		/datum/mapGeneratorModule/wyrmwood_towngrass,
	)

/datum/mapGeneratorModule/wyrmwood_forest
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(
		/obj/structure/flora/grass = 80,
		/obj/structure/flora/grass/thorn_bush = 6,
		/obj/item/natural/rock = 6,
		/obj/structure/flora/grass/herb/random = 0.5,
		/obj/structure/closet/dirthole/closed = 2,
		/obj/structure/flora/newtree = 5,
		/obj/structure/wild_plant/nospread/ollie = 0.6,
		/obj/item/natural/stone = 5,
		/obj/item/grown/log/tree/stick = 4,
		/obj/structure/flora/grass/bush_meagre = 4,
		/obj/structure/table/wood/treestump = 4,
		/obj/structure/chair/bench/ancientlog = 3,
	)
	spawnableTurfs = list(
		/turf/open/floor/dirt/road = 30,
	)
	allowed_areas = list(/area/outdoors/wilderness)

/datum/mapGeneratorModule/wyrmwood_forestroad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(
		/obj/item/natural/stone = 3,
		/obj/item/grown/log/tree/stick = 2,
	)

/datum/mapGeneratorModule/wyrmwood_forestgrassturf
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableTurfs = list(/turf/open/floor/grass = 15)
	allowed_areas = list(/area/outdoors/wilderness)

/datum/mapGeneratorModule/wyrmwood_forestgrass
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/floor/grass)
	allowed_areas = list(/area/outdoors/wilderness)
	spawnableAtoms = list(
		/obj/structure/flora/grass = 80,
		/obj/structure/flora/grass/bush_meagre = 7,
		/obj/structure/flora/grass/herb/random = 1,
		/obj/item/grown/log/tree/stick = 5,
		/obj/structure/flora/grass/thorn_bush = 4,
		/obj/structure/chair/bench/ancientlog = 4,
		/obj/item/natural/stone = 3,
		/obj/item/natural/rock = 2,
		/obj/structure/flora/grass/pyroclasticflowers = 1,
		/obj/structure/flora/grass/maneater = 0.3,
		/obj/structure/flora/grass/maneater/real = 0.1,
		/obj/structure/wild_plant/nospread/mushroom/waddle = 0.5,
		/obj/structure/wild_plant/nospread/mushroom/merkel = 0.2,
	)

/datum/mapGeneratorModule/wyrmwood_forestwaterturf
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/water/clean)
	allowed_areas = list(/area/outdoors/wilderness)
	spawnableAtoms = list(
		/obj/structure/flora/grass/water = 20,
	   	/obj/structure/flora/grass/water/reeds = 25,
		/obj/structure/kneestingers = 25,
	)

/datum/mapGeneratorModule/wyrmwood_forestswampwaterturf
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/water/swamp)
	allowed_areas = list(/area/outdoors/wilderness)
	spawnableAtoms = list(
		/obj/structure/flora/grass/water = 20,
		/obj/structure/flora/grass/water/reeds = 30,
		/obj/structure/kneestingers = 30,
	)

/datum/mapGeneratorModule/wyrmwood_towngrass
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/floor/grass)
	allowed_areas = list(/area/outdoors/town)
	spawnableAtoms = list(
		/obj/structure/flora/grass = 80,
		/obj/structure/flora/grass/tundra = 40,
		/obj/structure/flora/grass/bush_meagre = 7,
		/obj/structure/flora/grass/herb/random = 0.2,
		/obj/item/grown/log/tree/stick = 5,
		/obj/item/natural/stone = 3,
		/obj/structure/wild_plant/nospread/mushroom/waddle = 0.2,
		/obj/structure/wild_plant/nospread/mushroom/merkel = 0.1,
	)
