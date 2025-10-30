/datum/cave_biome
	var/name = "Generic Cave"
	var/list/terrain_weights = list()
	var/list/terrain_weights_lower = list()
	var/list/flora_weights = list()
	var/list/flora_weights_lower = list()
	var/list/feature_templates = list()
	var/flora_density = 0.08
	var/flora_density_lower = 0.08
	var/list/temperature_map
	var/list/moisture_map
	var/list/fauna_types = list()
	var/list/fauna_types_lower = list()
	var/fauna_density = 3
	var/fauna_density_lower = 8
	var/difficulty = 0
	var/list/ore_types_upper = list()
	var/list/ore_types_lower = list()
	var/ore_vein_density = 10
	var/ore_spread_iterations = 4

/datum/cave_biome/New(_difficulty)
	. = ..()
	difficulty = _difficulty
	setup_spawn_rules()
	setup_ores()

/datum/cave_biome/proc/setup_ores()
	var/list/ores = list(
		"iron" = list(
			"turf" = /turf/closed/mineral/iron,
			"spread_chance" = 60,
			"spread_range" = 3,
			"tier" = "common"
		),
		"copper" = list(
			"turf" = /turf/closed/mineral/copper,
			"spread_chance" = 60,
			"spread_range" = 3,
			"tier" = "common"
		),
		"tin" = list(
			"turf" = /turf/closed/mineral/tin,
			"spread_chance" = 60,
			"spread_range" = 3,
			"tier" = "common"
		),
		"coal" = list(
			"turf" = /turf/closed/mineral/coal,
			"spread_chance" = 60,
			"spread_range" = 2,
			"tier" = "common"
		),
		"salt" = list(
			"turf" = /turf/closed/mineral/salt,
			"spread_chance" = 60,
			"spread_range" = 2,
			"tier" = "common"
		),
		"gold" = list(
			"turf" = /turf/closed/mineral/gold,
			"spread_chance" = 50,
			"spread_range" = 2,
			"tier" = "rare"
		),
		"silver" = list(
			"turf" = /turf/closed/mineral/silver,
			"spread_chance" = 50,
			"spread_range" = 2,
			"tier" = "rare"
		),
		"gems" = list(
			"turf" = /turf/closed/mineral/gemeralds,
			"spread_chance" = 50,
			"spread_range" = 2,
			"tier" = "rare"
		),
		"cinnabar" = list(
			"turf" = /turf/closed/mineral/cinnabar,
			"spread_chance" = 50,
			"spread_range" = 2,
			"tier" = "rare"
		),
		"mana crystal" = list(
			"turf" = /turf/closed/mineral/mana_crystal,
			"spread_chance" = 50,
			"spread_range" = 2,
			"tier" = "rare"
		)
	)

	var/static/list/all_ore_types = list()
	if(!length(all_ore_types))
		all_ore_types = ores.Copy()

	for(var/i = 1 to rand(3, 4))
		var/picked = pick(all_ore_types)
		var/list/list = all_ore_types[picked]
		ore_types_upper += list("[picked]" = list)
		all_ore_types -= picked
		if(!length(all_ore_types))
			all_ore_types = ores.Copy()

	for(var/i = 1 to rand(3, 4))
		var/picked = pick(all_ore_types)
		var/list/list = all_ore_types[picked]
		ore_types_lower += list("[picked]" = list)
		all_ore_types -= picked
		if(!length(all_ore_types))
			all_ore_types = ores.Copy()

/datum/cave_biome/proc/setup_spawn_rules()
	return

/datum/cave_biome/proc/select_terrain(temperature, moisture, level)
	if(level == 0 && terrain_weights_lower.len)
		return pickweight(terrain_weights_lower)
	return pickweight(terrain_weights)

/datum/cave_biome/proc/select_flora(temperature, moisture, level)
	if(level == 0 && flora_weights_lower.len)
		return pickweight(flora_weights_lower)
	if(!flora_weights.len)
		return null
	return pickweight(flora_weights)

/datum/cave_biome/mushroom
	name = "Mushroom Cave"
	terrain_weights = list(
		/turf/open/floor/naturalstone = 60,
		/turf/open/floor/cobblerock = 30,
		/turf/open/floor/volcanic = 10
	)
	terrain_weights_lower = list(
		/turf/open/floor/mushroom = 50,
		/turf/open/floor/mushroom/green = 30,
		/turf/open/floor/mushroom/blue = 20
	)
	flora_weights = list(
		/obj/structure/flora/grass/mushroom = 70,
		/obj/structure/flora/shroom_tree = 30
	)
	flora_weights_lower = list(
		/obj/structure/flora/shroom_tree = 50,
		/obj/structure/flora/grass/mushroom = 50
	)
	feature_templates = list()
	flora_density = 2
	flora_density_lower = 1.5
	fauna_density = 3
	fauna_density_lower = 7

/datum/cave_biome/mushroom/setup_spawn_rules()
	. = ..()
	fauna_types = list(
		/mob/living/carbon/human/species/goblin/npc = new /datum/fauna_spawn_rule(
			min_temp = 0.4,
			max_temp = 0.9,
			min_moist = 0.2,
			max_moist = 0.8,
			weight = 100
		),
		/mob/living/simple_animal/hostile/retaliate/mole = new /datum/fauna_spawn_rule(
			min_temp = 0.3,
			max_temp = 1.0,
			min_moist = 0.0,
			max_moist = 1.0,
			weight = 100
		),
		/mob/living/simple_animal/hostile/retaliate/spider = new /datum/fauna_spawn_rule(
			min_temp = 0.5,
			max_temp = 1.0,
			min_moist = 0.0,
			max_moist = 1.0,
			weight = 100
		),
		/mob/living/simple_animal/hostile/retaliate/bigrat = new /datum/fauna_spawn_rule(
			min_temp = 0.3,
			max_temp = 1.0,
			min_moist = 0.0,
			max_moist = 1.0,
			weight = 100
		),
	)
	fauna_types_lower = list(
		/mob/living/carbon/human/species/goblin/npc = new /datum/fauna_spawn_rule(
			min_temp = 0.3,
			max_temp = 1.0,
			min_moist = 0.0,
			max_moist = 1.0,
			weight = 150
		),
		/mob/living/simple_animal/hostile/retaliate/mole = new /datum/fauna_spawn_rule(
			min_temp = 0.3,
			max_temp = 1.0,
			min_moist = 0.0,
			max_moist = 1.0,
			weight = 300
		),
		/mob/living/simple_animal/hostile/retaliate/spider = new /datum/fauna_spawn_rule(
			min_temp = 0.5,
			max_temp = 1.0,
			min_moist = 0.0,
			max_moist = 1.0,
			weight = 300
		),
		/mob/living/simple_animal/hostile/retaliate/troll/axe = new /datum/fauna_spawn_rule(
			min_temp = 0.3,
			max_temp = 1.0,
			min_moist = 0.0,
			max_moist = 1.0,
			weight = 20
		),
		/mob/living/simple_animal/hostile/retaliate/troll/bog = new /datum/fauna_spawn_rule(
			min_temp = 0.3,
			max_temp = 1.0,
			min_moist = 0.0,
			max_moist = 1.0,
			weight = 20
		),
		/mob/living/simple_animal/hostile/retaliate/minotaur = new /datum/fauna_spawn_rule(
			min_temp = 0.3,
			max_temp = 1.0,
			min_moist = 0.0,
			max_moist = 1.0,
			weight = 1
		),
	)

/datum/cave_biome/mushroom/select_terrain(temperature, moisture, level)
	if(level == 0)  // Lower level - mushroom floors only
		if(temperature > 0.7)
			if(prob(80))
				return /turf/open/floor/mushroom
			else
				return /turf/open/floor/mushroom/green
		if(temperature < 0.3)
			if(prob(70))
				return /turf/open/floor/mushroom/blue
			else
				return /turf/open/floor/mushroom
		return pickweight(terrain_weights_lower)
	else  // Upper level - regular stone floors
		if(temperature > 0.7)
			return /turf/open/floor/volcanic
		if(temperature < 0.3)
			return /turf/open/floor/naturalstone
		return pickweight(terrain_weights)

/datum/cave_biome/mushroom/select_flora(temperature, moisture, level)
	if(level == 0)  // Lower level - more mushroom trees
		if(temperature < 0.7)
			if(prob(50))
				return /obj/structure/flora/shroom_tree
			if(prob(80))
				return /obj/structure/flora/grass/mushroom
		return pickweight(flora_weights_lower)
	else  // Upper level - sparse mushroom growth
		if(temperature < 0.7)
			if(prob(30))
				return /obj/structure/flora/shroom_tree
			if(prob(60))
				return /obj/structure/flora/grass/mushroom
		return pickweight(flora_weights)
