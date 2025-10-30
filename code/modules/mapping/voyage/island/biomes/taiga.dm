
/datum/island_biome/tundra
	name = "Tundra"
	biome_weight = 80
	terrain_weights = list(
		/turf/open/floor/grass = 70,
		/turf/open/floor/snow = 20,
		/turf/open/floor/grass/yel = 10
	)
	flora_weights = list(
		/obj/structure/flora/newtree/snow = 20,
		/obj/structure/flora/grass/tundra = 30,
	)
	feature_templates = list(
		/datum/island_feature_template/hotspring,
		/datum/island_feature_template/abandoned_campsite,
		/datum/island_feature_template/abandoned_camp,
	)
	flora_density = 2
	max_height = 2
	fauna_density = 6

/datum/island_biome/tundra/setup_spawn_rules()
	..()

	fauna_density -= min(3, difficulty)
	if(difficulty >= 1)
		fauna_types += list(
			/mob/living/simple_animal/hostile/retaliate/saiga = new /datum/fauna_spawn_rule(
				min_moist = 0.3,
				max_moist = 0.8,
				min_temp = 0.3,
				max_temp = 0.7,
				no_beach_spawn = TRUE,
				weight = 80
			),
			/mob/living/simple_animal/hostile/retaliate/trufflepig = new /datum/fauna_spawn_rule(
				min_moist = 0.2,
				no_beach_spawn = TRUE,
				max_h = 1,
				weight = 120
			)
		)

	if(difficulty >= 2)
		fauna_types += list(
			/mob/living/simple_animal/hostile/retaliate/goat = new /datum/fauna_spawn_rule(
				min_moist = 0.3,
				max_moist = 0.8,
				min_temp = 0.3,
				max_temp = 0.7,
				no_beach_spawn = TRUE,
				weight = 80
			),
			/mob/living/simple_animal/hostile/retaliate/goatmale = new /datum/fauna_spawn_rule(
				min_moist = 0.3,
				max_moist = 0.8,
				min_temp = 0.3,
				max_temp = 0.7,
				no_beach_spawn = TRUE,
				weight = 80
			),
			/mob/living/simple_animal/hostile/retaliate/wolf = new /datum/fauna_spawn_rule(
				min_moist = 0.2,
				no_beach_spawn = TRUE,
				max_h = 1,
				weight = 120
			)
		)
	if(difficulty >= 3)
		add_settlement_type()

/datum/island_biome/tundra/select_terrain(temperature, moisture, height)
	if(temperature < 0.3)
		if(moisture > 0.5)
			return /turf/open/floor/snow
		return /turf/open/floor/grass/cold

	if(temperature < 0.5)
		var/snow_chance = (0.5 - temperature) * 100
		if(prob(snow_chance))
			return /turf/open/floor/grass/cold
		if(moisture > 0.5)
			return /turf/open/floor/snow
		return /turf/open/floor/grass

	if(moisture > 0.6)
		return /turf/open/floor/snow
	else if(moisture > 0.4)
		return prob(70) ? /turf/open/floor/snow : /turf/open/floor/grass/mixyel
	else
		return prob(60) ? /turf/open/floor/grass/yel : /turf/open/floor/snow


/datum/island_biome/tundra/select_flora(temperature, moisture, height)
	if(prob(10))
		return /obj/item/natural/stone
	if(moisture > 0.4 && temperature > 0.3 && temperature < 0.7)
		if(prob(60))
			return /obj/structure/flora/newtree/snow

	if(prob(70))
		var/list/pick_list = list(
			/obj/structure/wild_plant/nospread/blackberry,
			/obj/structure/wild_plant/nospread/raspberry,
			/obj/structure/flora/grass/herb/artemisia,
			/obj/structure/flora/grass/herb/hypericum,
			/obj/structure/flora/grass/herb/taraxacum,
			/obj/structure/flora/grass/tundra,
			/obj/structure/flora/grass/bush,
			/obj/structure/flora/grass/herb/salvia,
			/obj/structure/flora/grass/herb/matricaria,
			/obj/structure/flora/grass/herb/urtica,
			/obj/structure/flora/grass/herb/benedictus,
			/obj/structure/wild_plant/nospread/poppy,
			)
		return pick(pick_list)

	return /obj/effect/flora_patch_spawner/plains


/datum/island_biome/tundra/select_patch_flora(temperature, moisture, height)

	if(prob(80))
		var/list/pick_list = list(
			/obj/structure/flora/grass/tundra,
			/obj/structure/flora/grass/water,
		)
		return pick(pick_list)
	else
		if(prob(70))
			var/list/pick_list = list(
				/obj/structure/flora/grass/bush,
				/obj/structure/wild_plant/nospread/blackberry,
				/obj/structure/wild_plant/nospread/raspberry,
				/obj/structure/flora/grass/herb/artemisia,
				/obj/structure/flora/grass/herb/hypericum,
				/obj/structure/flora/grass/herb/taraxacum,
				/obj/structure/flora/grass/herb/salvia,
				/obj/structure/flora/grass/herb/matricaria,
				/obj/structure/flora/grass/herb/urtica,
				/obj/structure/flora/grass/herb/benedictus,
				/obj/structure/wild_plant/nospread/poppy,
			)
			return pick(pick_list)

		return null
