//genstuff
/obj/effect/landmark/mapGenerator/wyrmwood_forest_top
	mapGeneratorType = /datum/mapGenerator/wyrmwood_forest_top
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/wyrmwood_forest_top
	modules = list(
		/datum/mapGeneratorModule/ambushing,
		/datum/mapGeneratorModule/wyrmwood_forest_topgrassturf,
		/datum/mapGeneratorModule/wyrmwood_forest_top,
		/datum/mapGeneratorModule/wyrmwood_forest_toproad,
		/datum/mapGeneratorModule/wyrmwood_forest_topgrass,
		/datum/mapGeneratorModule/wyrmwood_forest_topswampwaterturf,
		/datum/mapGeneratorModule/wyrmwood_forest_topwaterturf,
	)

/datum/mapGeneratorModule/wyrmwood_forest_top
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(
		/obj/structure/flora/grass = 80,
		/obj/structure/flora/grass/thorn_bush = 6,
		/obj/item/natural/rock = 6,
		/obj/structure/flora/grass/herb/random = 5,
		/obj/structure/closet/dirthole/closed = 5,
		/obj/structure/flora/newtree = 5,
		/obj/structure/wild_plant/nospread/ollie = 0.6,
		/obj/item/natural/stone = 5,
		/obj/item/grown/log/tree/stick = 4,
		/obj/structure/flora/grass/bush_meagre = 4,
		/obj/structure/essence_node = 0.4,
		/obj/structure/table/wood/treestump = 4,
		/obj/structure/chair/bench/ancientlog = 3,
	)
	spawnableTurfs = list(
		/turf/open/floor/dirt/road = 30,
	)
	allowed_areas = list(/area/outdoors/wilderness)

/datum/mapGeneratorModule/wyrmwood_forest_toproad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(
		/obj/item/natural/stone = 3,
		/obj/item/grown/log/tree/stick = 2,
	)

/datum/mapGeneratorModule/wyrmwood_forest_topgrassturf
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableTurfs = list(/turf/open/floor/grass = 15)
	allowed_areas = list(/area/outdoors/wilderness)

/datum/mapGeneratorModule/wyrmwood_forest_topgrass
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/floor/grass)
	allowed_areas = list(/area/outdoors/wilderness)
	spawnableAtoms = list(
		/obj/structure/flora/grass = 80,
		/obj/structure/flora/grass/bush_meagre = 7,
		/obj/structure/flora/grass/herb/random = 6,
		/obj/item/grown/log/tree/stick = 5,
		/obj/structure/chair/bench/ancientlog = 4,
		/obj/item/natural/stone = 3,
		/obj/item/natural/rock = 2,
		/obj/structure/essence_node = 1,
		/obj/structure/flora/grass/pyroclasticflowers = 1,
		/obj/structure/wild_plant/nospread/mushroom/waddle = 0.5,
		/obj/structure/wild_plant/nospread/mushroom/merkel = 0.2,
	)

/datum/mapGeneratorModule/wyrmwood_forest_topwaterturf
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/water/clean)
	allowed_areas = list(/area/outdoors/wilderness)
	spawnableAtoms = list(
		/obj/structure/flora/grass/water = 20,
	   	/obj/structure/flora/grass/water/reeds = 25,
		/obj/structure/kneestingers = 25,
	)

/datum/mapGeneratorModule/wyrmwood_forest_topswampwaterturf
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/water/swamp)
	allowed_areas = list(/area/outdoors/wilderness)
	spawnableAtoms = list(
		/obj/structure/flora/grass/water = 20,
		/obj/structure/flora/grass/water/reeds = 30,
		/obj/structure/kneestingers = 30,
	)
