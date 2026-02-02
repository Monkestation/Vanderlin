/obj/effect/island_tester
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
	var/datum/island_biome/biome = /datum/island_biome/plains

/obj/effect/island_tester/proc/generate_island()
	var/datum/island_biome/my_biome = new biome()
	var/datum/island_generator/generator = new(my_biome, 100, 100)
	generator.generate(get_turf(src))

/obj/effect/cave_tester
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
	var/datum/cave_biome/biome = /datum/cave_biome/mushroom

/obj/effect/cave_tester/proc/generate_cave()
	var/datum/cave_biome/my_biome = new biome()
	var/datum/cave_generator/generator = new(my_biome, 100, 100)
	generator.generate(get_turf(src))
