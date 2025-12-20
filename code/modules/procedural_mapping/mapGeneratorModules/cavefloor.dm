
/obj/effect/landmark/mapGenerator/cave
	mapGeneratorType = /datum/mapGenerator/cave
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/cave
	modules = list(/datum/mapGeneratorModule/cave,/datum/mapGeneratorModule/cavedirt,/datum/mapGeneratorModule/sewerwaterturf)

/datum/mapGeneratorModule/cave
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road,/turf/open/water,/turf/open/floor/volcanic)
	spawnableAtoms = list(/obj/item/natural/stone = 5, /obj/structure/roguerock=5, /obj/item/natural/rock=3, /obj/structure/kneestingers=1, /obj/item/restraints/legcuffs/beartrap/armed/camouflage=1, /obj/structure/innouous_rock = 1)
	allowed_areas = list(/area/under/cave/spider,/area/indoors/cave,/area/under/cavewet,/area/under/cave,/area/under/cavelava)

/datum/mapGeneratorModule/cavedirt
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/dirt)
	spawnableAtoms = list(/obj/structure/flora/shroom_tree=16, /obj/structure/roguerock=8, /obj/structure/closet/dirthole/closed/loot=3, /obj/item/natural/stone=10, /obj/item/natural/rock=8, /obj/structure/kneestingers = 0, /obj/item/restraints/legcuffs/beartrap/armed/camouflage=0)
	allowed_areas = list(/area/under/cave/spider,/area/indoors/cave,/area/under/cavewet,/area/under/cave,/area/under/cavelava)

/obj/effect/landmark/mapGenerator/cave/lava
	mapGeneratorType = /datum/mapGenerator/cave/lava

/datum/mapGenerator/cave/lava
	modules = list(/datum/mapGeneratorModule/cave,/datum/mapGeneratorModule/cavedirt/lava)

/datum/mapGeneratorModule/cavedirt/lava
	spawnableTurfs = list(/turf/open/lava=2,/turf/open/floor/dirt/road=30)


/obj/effect/landmark/mapGenerator/cave/spider
	mapGeneratorType = /datum/mapGenerator/cave/spider
	endTurfX = 64
	endTurfY = 64
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/cave/spider
	modules = list(/datum/mapGeneratorModule/cavespider,/datum/mapGeneratorModule/cave,/datum/mapGeneratorModule/cavedirt)

/datum/mapGeneratorModule/cavespider
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt)
	spawnableAtoms = list(/obj/structure/spider/stickyweb=10)
	allowed_areas = list(/area/under/cave/spider)

/datum/mapGeneratorModule/sewerwaterturf
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/water/cleanshallow)
	allowed_areas = list(/area/under/town/sewer)
	spawnableAtoms = list(/obj/structure/flora/grass/water = 20,
	                        /obj/structure/kneestingers = 1)

