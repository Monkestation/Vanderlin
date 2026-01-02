/datum/island_biome
	var/name = "Generic Biome"
	var/biome_weight = 100
	var/list/terrain_weights = list()
	var/list/flora_weights = list()
	var/list/feature_templates = list()
	var/list/cave_entry_templates = list(
		/datum/island_feature_template/generic_cave,
	)
	var/list/beach_flora_weights = list(
		/obj/structure/flora/driftwood = 30,
		/obj/structure/flora/starfish = 20,
		/obj/structure/flora/shells = 40,
		/obj/item/natural/stone = 10,
	)
	var/flora_density = 2
	var/beach_flora_density = 2
	var/turf/beach_turf = /turf/open/floor/sand
	var/max_height = 3
	var/list/temperature_map
	var/list/moisture_map

	var/list/fauna_types = list() //! Populated on New()
	var/fauna_density = 3
	var/difficulty = 0

	var/list/settlement_mobs = list()
	var/datum/settlement_generator/settlement_generator

/datum/island_biome/New(_difficulty)
	. = ..()
	difficulty = _difficulty
	setup_spawn_rules()

/datum/island_biome/proc/setup_spawn_rules()
	return

/datum/island_biome/proc/add_settlement_type()
	switch(rand(1, 3))
		if(1)
			fauna_types += list(
				/mob/living/carbon/human/species/orc/tribal = new /datum/fauna_spawn_rule(
					min_moist = 0.3,
					max_moist = 0.8,
					min_temp = 0.3,
					max_temp = 0.7,
					no_beach_spawn = TRUE,
					weight = 80
				),
			)
			settlement_mobs = list(
				/mob/living/carbon/human/species/orc/tribal,
				/mob/living/carbon/human/species/orc/slaved
			)
		if(2)
			fauna_types += list(
				/mob/living/carbon/human/species/goblin/slaved = new /datum/fauna_spawn_rule(
					min_moist = 0.3,
					max_moist = 0.8,
					min_temp = 0.3,
					max_temp = 0.7,
					no_beach_spawn = TRUE,
					weight = 80
				),
				/mob/living/carbon/human/species/goblin/npc = new /datum/fauna_spawn_rule(
					min_moist = 0.3,
					max_moist = 0.8,
					min_temp = 0.3,
					max_temp = 0.7,
					no_beach_spawn = TRUE,
					weight = 80
				),
			)
			settlement_mobs = list(
				/mob/living/carbon/human/species/goblin/slaved,
				/mob/living/carbon/human/species/goblin/npc
			)
		if(3)
			fauna_types += list(
				/mob/living/carbon/human/species/skeleton/npc = new /datum/fauna_spawn_rule(
					min_moist = 0.3,
					max_moist = 0.8,
					min_temp = 0.3,
					max_temp = 0.7,
					no_beach_spawn = TRUE,
					weight = 80
				),
			)
			settlement_mobs = list(
				/mob/living/carbon/human/species/skeleton/npc,
			)
	settlement_generator = new(src)

/datum/island_biome/proc/select_terrain(temperature, moisture, height)
	return pickweight(terrain_weights)

/datum/island_biome/proc/select_flora(temperature, moisture, height)
	return pickweight(flora_weights)

/datum/island_biome/proc/select_patch_flora(temperature, moisture, height)
	return pickweight(flora_weights)

/datum/island_biome/proc/select_beach_flora(temperature, moisture, height)
	return pickweight(beach_flora_weights)
