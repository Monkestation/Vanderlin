/obj/effect/landmark/mapGenerator/dakka/swamp
	mapGeneratorType = /datum/mapGenerator/dswamp
	endTurfX = 155
	endTurfY = 155
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/dswamp
	modules = list(/datum/mapGeneratorModule/dambushing,/datum/mapGeneratorModule/dswamp, /datum/mapGeneratorModule/dswampwater)

/datum/mapGeneratorModule/dswamp
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt)
	spawnableAtoms = list(/obj/structure/flora/tree = 1,
							/obj/structure/flora/grass/bush_meagre = 12,
							/obj/structure/flora/grass/pyroclasticflowers = 1,
							/obj/structure/flora/grass/maneater = 0,
							/obj/structure/flora/grass = 23,
							/obj/structure/chair/bench/ancientlog = 20,
							/obj/item/natural/rock = 30,
							/obj/item/natural/stone = 30,
							/obj/structure/flora/grass/swampweed = 30,
							/obj/item/grown/log/tree/stick = 4,
							/obj/structure/flora/grass/maneater/real = 1,
							/obj/item/restraints/legcuffs/beartrap/armed/camouflage = 0)
	spawnableTurfs = list(/turf/open/water/swamp = 5,
	                     /turf/open/floor/dirt = 80)
	allowed_areas = list(/area/outdoors/bog)

/datum/mapGeneratorModule/dswampwater
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	spawnableAtoms = list(/obj/structure/flora/grass/water = 5,
						/obj/structure/flora/grass/water/reeds = 80,
						/obj/structure/kneestingers = 60)
	allowed_turfs = list(/turf/open/water/swamp,
						/turf/open/water/swamp/deep)
	allowed_areas = list(/area/outdoors/bog)
