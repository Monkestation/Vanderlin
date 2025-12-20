
/datum/island_biome/plains
	name = "Plains"
	terrain_weights = list(
		/turf/open/floor/grass = 70,
		/turf/open/floor/dirt = 20,
		/turf/open/floor/grass/yel = 10
	)
	flora_weights = list(
		/obj/structure/flora/newtree = 20,
		/obj/structure/flora/grass = 30,
	)
	feature_templates = list(
		/datum/island_feature_template/blackberry,
		/datum/island_feature_template/strawberry,
		/datum/island_feature_template/salvia,
		/datum/island_feature_template/flowerfield,
		/datum/island_feature_template/abandoned_campsite,
		/datum/island_feature_template/abandoned_camp,
	)
	flora_density = 2
	max_height = 2
	fauna_density = 6

/datum/island_biome/plains/setup_spawn_rules()
	..()

	fauna_density -= min(3, difficulty)
	if(difficulty >= 1)
		fauna_types += list(
			/mob/living/simple_animal/hostile/retaliate/cow = new /datum/fauna_spawn_rule(
				min_moist = 0.3,
				max_moist = 0.8,
				min_temp = 0.3,
				max_temp = 0.7,
				no_beach_spawn = TRUE,
				weight = 80
			),
			/mob/living/simple_animal/hostile/retaliate/chicken = new /datum/fauna_spawn_rule(
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

/datum/island_biome/plains/select_terrain(temperature, moisture, height)
	if(temperature < 0.35)
		if(moisture > 0.4)
			return /turf/open/floor/grass/cold
		else
			return /turf/open/floor/dirt

	if(temperature > 0.7 && moisture < 0.35)
		if(prob(60))
			return /turf/open/floor/dirt
		else
			return /turf/open/floor/grass/yel

	if(temperature > 0.65)
		if(moisture > 0.45)
			if(prob(40))
				return /turf/open/floor/grass/mixyel
			else if(prob(30))
				return /turf/open/floor/grass/yel
			else
				return /turf/open/floor/grass
		else
			if(prob(50))
				return /turf/open/floor/grass/yel
			else
				return /turf/open/floor/grass

	if(moisture > 0.6 && temperature > 0.35 && temperature < 0.65)
		if(prob(85))
			return /turf/open/floor/grass
		else
			return /turf/open/floor/dirt

	if(moisture > 0.4 && moisture < 0.7 && temperature > 0.35 && temperature < 0.65)
		var/roll = rand(1, 100)
		if(roll <= 60)
			return /turf/open/floor/grass
		else if(roll <= 75)
			return /turf/open/floor/dirt
		else if(roll <= 90)
			return /turf/open/floor/grass/mixyel
		else
			return /turf/open/floor/grass/yel

	if(moisture < 0.4 && temperature > 0.35 && temperature < 0.65)
		if(prob(50))
			return /turf/open/floor/dirt
		else
			return /turf/open/floor/grass

	if(height > 0)
		if(prob(40 * height))
			return /turf/open/floor/dirt

	return pickweight(terrain_weights)

/datum/island_biome/plains/select_flora(temperature, moisture, height)
	if(prob(10))
		return /obj/item/natural/stone
	if(moisture > 0.4 && temperature > 0.3 && temperature < 0.7)
		if(prob(60))
			return /obj/structure/flora/newtree
		if(prob(30))
			var/list/pick_list = list(
				/obj/structure/wild_plant/nospread/apple,
				/obj/structure/wild_plant/nospread/pear,
				/obj/structure/wild_plant/nospread/plum,
				/obj/structure/wild_plant/nospread/tangerine,
				/obj/structure/wild_plant/nospread/lemon,
				/obj/structure/wild_plant/nospread/lime,
				)
			return pick(pick_list)

	if(prob(70))
		var/list/pick_list = list(
			/obj/structure/wild_plant/nospread/strawberry,
			/obj/structure/wild_plant/nospread/blackberry,
			/obj/structure/wild_plant/nospread/raspberry,
			/obj/structure/wild_plant/nospread/jacksberry,
			/obj/structure/flora/grass/herb/urtica,
			/obj/structure/flora/grass/herb/hypericum,
			/obj/structure/flora/grass/herb/symphitum,
			/obj/structure/flora/grass,
			/obj/structure/flora/grass/bush,
			/obj/structure/flora/grass/herb/salvia,
			/obj/structure/flora/grass/herb/mentha,
			/obj/structure/wild_plant/nospread/poppy,
			)
		return pick(pick_list)

	return /obj/effect/flora_patch_spawner/plains


/datum/island_biome/plains/select_patch_flora(temperature, moisture, height)

	if(prob(80))
		var/list/pick_list = list(
			/obj/structure/flora/grass,
			/obj/structure/flora/grass/water,
		)
		return pick(pick_list)
	else
		if(moisture > 0.4 && temperature > 0.3 && temperature < 0.7)
			if(prob(30))
				var/list/pick_list = list(
					/obj/structure/wild_plant/nospread/apple,
					/obj/structure/wild_plant/nospread/pear,
					/obj/structure/wild_plant/nospread/plum,
					/obj/structure/wild_plant/nospread/tangerine,
					/obj/structure/wild_plant/nospread/lemon,
					/obj/structure/wild_plant/nospread/lime,
					)
				return pick(pick_list)

		if(prob(70))
			var/list/pick_list = list(
				/obj/structure/flora/grass/bush,
				/obj/structure/flora/grass,
				/obj/structure/wild_plant/nospread/strawberry,
				/obj/structure/wild_plant/nospread/blackberry,
				/obj/structure/wild_plant/nospread/raspberry,
				/obj/structure/wild_plant/nospread/jacksberry,
				/obj/structure/flora/grass/herb/urtica,
				/obj/structure/flora/grass/herb/hypericum,
				/obj/structure/flora/grass/herb/symphitum,
				/obj/structure/flora/grass/herb/salvia,
				/obj/structure/flora/grass/herb/mentha,
				/obj/structure/wild_plant/nospread/poppy,
				)
			return pick(pick_list)

		return null
