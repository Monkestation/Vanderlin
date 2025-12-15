//genstuff
/obj/effect/landmark/mapGenerator/anvil
	mapGeneratorType = /datum/mapGenerator/anvil
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/anvil
	modules = list(/datum/mapGeneratorModule/ambushing,/datum/mapGeneratorModule/abovemountain,/datum/mapGeneratorModule/undermountain,/datum/mapGeneratorModule/grove)


/datum/mapGeneratorModule/abovemountain
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	include_subtypes = FALSE
	allowed_turfs = list(/turf/open/floor/snow,/turf/open/floor/grass/cold,/turf/open/floor/snow/patchy)
	spawnableAtoms = list(/obj/structure/flora/grass/bush_meagre/tundra = 10,
						/obj/structure/flora/grass/tundra = 40,
						/obj/structure/flora/grass/herb/random = 5,
						/obj/item/natural/stone = 10,
						/obj/item/natural/rock = 5,
						/obj/structure/essence_node = 0.1,
						/obj/item/grown/log/tree/stick = 10,
						/obj/structure/flora/grass/pyroclasticflowers = 10,
						/obj/structure/wild_plant/nospread/mushroom/merkel = 1,)
	allowed_areas = list(/area/outdoors/mountains/anvil/snowyforest)

/datum/mapGeneratorModule/undermountain
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt,/turf/open/floor/cobblerock, /turf/open/floor/naturalstone)
	spawnableAtoms = list(/obj/item/natural/stone = 10,
						/obj/item/natural/rock = 8,
						/obj/item/natural/rock/random_ore = 2,
						/obj/structure/flora/shroom_tree = 1,
						/obj/structure/essence_node = 0.1,
						/obj/item/restraints/legcuffs/beartrap/armed = 0.5,
						/obj/structure/wild_plant/nospread/mushroom/caveweep = 1,)
	allowed_areas = list(/area/under/mountains/anvil/lower)

/datum/mapGeneratorModule/grove // This area is not utilized in Malum's Anvil at all as of 10-13-2025
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt,/turf/open/floor/dirt/road, /turf/open/floor/grass)
	spawnableAtoms = list(/obj/item/natural/stone = 3,
						/obj/structure/flora/grass = 25,
						/obj/structure/flora/grass/herb/random = 2,
						/obj/structure/flora/grass/bush = 4,
						/obj/structure/essence_node = 0.2,
						/obj/item/grown/log/tree/stick = 10)
	allowed_areas = list(/area/outdoors/mountains/anvil/grove)
