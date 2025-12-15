
/obj/effect/landmark/mapGenerator/bog
	mapGeneratorType = /datum/mapGenerator/bog
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/bog
	modules = list(/datum/mapGeneratorModule/ambushing,/datum/mapGeneratorModule/bog, /datum/mapGeneratorModule/bogwater)

/datum/mapGeneratorModule/bog
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt, /turf/open/floor/grass)
	spawnableAtoms = list(/obj/structure/flora/tree = 1,
							/obj/structure/flora/grass/bush_meagre = 7,
							/obj/structure/flora/grass/bush_meagre/bog = 4,
							/obj/structure/flora/grass/maneater = 1,
							/obj/structure/flora/grass/herb/random = 20,
							/obj/structure/flora/grass = 23,
							/obj/structure/chair/bench/ancientlog = 20,
							/obj/item/natural/artifact = 4,
							/obj/structure/leyline = 3,
							/obj/structure/voidstoneobelisk = 3,
							/obj/structure/wild_plant/manabloom = 2,
							/obj/item/mana_battery/mana_crystal/small = 3,
							/obj/item/natural/rock = 30,
							/obj/item/natural/stone = 30,
							/obj/structure/flora/grass/swampweed = 30,
							/obj/item/grown/log/tree/stick = 3,
							/obj/structure/flora/grass/maneater/real = 2,
							/obj/structure/essence_node = 0.1,
							/obj/structure/innocent_bush = 1,
							/obj/structure/wild_plant/nospread/mushroom/merkel = 0.5,
							)
	spawnableTurfs = list(/turf/open/water/swamp = 5)
	allowed_areas = list(/area/outdoors/bog)

/datum/mapGeneratorModule/bogwater
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	spawnableAtoms = list(/obj/structure/flora/grass/water = 5,
						/obj/structure/flora/grass/water/reeds = 80,
						/obj/structure/kneestingers = 60)
	allowed_turfs = list(/turf/open/water/swamp,
						/turf/open/water/swamp/deep)
	allowed_areas = list(/area/outdoors/bog)
