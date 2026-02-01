/obj/effect/landmark/mapGenerator/delver
	mapGeneratorType = /datum/mapGenerator/delver
	endTurfX = 200
	endTurfY = 200
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/delver
	modules = list(
				/datum/mapGeneratorModule/delvertown,
				/datum/mapGeneratorModule/delverplains,
				/datum/mapGeneratorModule/delvermarsh,
				/datum/mapGeneratorModule/delverwoods,
				/datum/mapGeneratorModule/delverwater,
				/datum/mapGeneratorModule/delvermtn
	)

/datum/mapGeneratorModule/delvertown
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/grass, /turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/grass = 60,
						/obj/structure/flora/ausbushes/sparsegrass = 10,
						/obj/structure/flora/grass/bush = 10,
						/obj/structure/flora/grass/bush_meagre = 8,
						/obj/structure/flora/ausbushes/lavendergrass = 10,
						/obj/structure/flora/ausbushes/ppflowers = 10,
						/obj/structure/flora/grass/herb/salvia = 8,
						/obj/structure/flora/grass/herb/symphitum = 8,
						/obj/structure/flora/newtree = 10,
						/obj/structure/table/wood/treestump = 12)
	allowed_areas = list(/area/delver/town)

/datum/mapGeneratorModule/delverplains
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/grass, /turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/grass = 90,
					/obj/structure/flora/ausbushes/sparsegrass = 6,
					/obj/structure/flora/ausbushes/brflowers = 10,
					/obj/structure/flora/ausbushes/ywflowers = 10,
					/obj/structure/flora/grass/herb/taraxacum = 8,
					/obj/structure/flora/grass/herb/calendula = 8,
					/obj/structure/flora/newtree = 8)
	allowed_areas = list(/area/delver/plains)

/datum/mapGeneratorModule/delvermarsh
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	include_subtypes = TRUE
	allowed_turfs = list(/turf/open/floor/grass, /turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/grass = 40,
						/obj/structure/flora/ausbushes/sparsegrass = 8,
						/obj/structure/flora/newtree = 12,
						/obj/structure/flora/tree = 18,
						/obj/structure/flora/tree/dead_bush = 12,
						/obj/structure/flora/tree/dying_bush = 4,
						/obj/structure/flora/grass/thorn_bush = 7,
						/obj/structure/flora/grass/herb/paris = 6,
						/obj/structure/flora/grass/herb/euphorbia = 8,
						/obj/structure/flora/grass/herb/mentha = 6,
						/obj/structure/flora/driftwood = 4)
	allowed_areas = list(/area/delver/marsh)

/datum/mapGeneratorModule/delverwoods
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/grass, /turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/grass = 50,
						/obj/structure/flora/ausbushes/sparsegrass = 8,
						/obj/structure/flora/newtree = 60,
						/obj/structure/flora/tree/dying_bush = 12,
						/obj/structure/flora/grass/thorn_bush = 8,
						/obj/structure/flora/grass/herb/hypericum = 8,
						/obj/structure/flora/grass/herb/rosa = 6)
	allowed_areas = list(/area/delver/woods)

/datum/mapGeneratorModule/delverwater
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/water)
	excluded_turfs = list(/turf/open/water/river)
	spawnableAtoms = list(/obj/structure/flora/grass/water = 10,
						/obj/structure/flora/ausbushes/reedbush = 6,
						/obj/structure/flora/grass/water/reeds = 3)

/datum/mapGeneratorModule/delvermtn //For the hilltops
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/grass, /turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/grass = 60,
						/obj/structure/flora/newtree = 20,
						/obj/structure/flora/grass/thorn_bush = 80)
	allowed_areas = list(/area/delver/mountains)
