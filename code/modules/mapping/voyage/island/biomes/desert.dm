/datum/island_biome/desert
	name = "Desert"
	biome_weight = 20
	terrain_weights = list(
		/turf/open/floor/cracked_earth = 70,
		/turf/open/floor/sand = 20,
		/turf/open/floor/dirt = 10
	)
	flora_weights = list(
		/obj/structure/flora/newtree/palm = 20,
		/obj/structure/flora/grass/thorn_bush = 30,
	)
	flora_density = 2
	max_height = 2
	fauna_density = 6

/datum/island_biome/desert/setup_spawn_rules()
	..()
	fauna_density -= min(3, difficulty)
	if(difficulty >= 1)
		fauna_types += list(
			/mob/living/simple_animal/hostile/retaliate/trufflepig = new /datum/fauna_spawn_rule(
				min_moist = 0.2,
				no_beach_spawn = TRUE,
				max_h = 1,
				weight = 120
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
			/mob/living/simple_animal/hostile/retaliate/bigrat = new /datum/fauna_spawn_rule(
				min_moist = 0.3,
				max_moist = 0.8,
				min_temp = 0.3,
				max_temp = 0.7,
				no_beach_spawn = TRUE,
				weight = 80
			),
			/mob/living/simple_animal/hostile/retaliate/bogbug = new /datum/fauna_spawn_rule(
				min_moist = 0.3,
				max_moist = 0.8,
				min_temp = 0.3,
				max_temp = 0.7,
				no_beach_spawn = TRUE,
				weight = 80
			),
			/mob/living/simple_animal/hostile/retaliate/spider = new /datum/fauna_spawn_rule(
				min_moist = 0.2,
				no_beach_spawn = TRUE,
				max_h = 1,
				weight = 120
			)
		)
	if(difficulty >= 3)
		add_settlement_type()

/datum/island_biome/desert/select_terrain(temperature, moisture, height)
	if(temperature > 0.7 && moisture < 0.3)
		if(height > 0.5)
			return /turf/open/floor/sand
		return /turf/open/floor/cracked_earth

	if(temperature > 0.6)
		if(moisture < 0.4)
			return prob(70) ? /turf/open/floor/dirt : /turf/open/floor/sand
		else if(moisture < 0.6)
			return prob(60) ? /turf/open/floor/sand : /turf/open/floor/cracked_earth
		else
			return /turf/open/floor/cracked_earth

	if(temperature > 0.4)
		if(moisture > 0.6)
			return /turf/open/floor/cracked_earth
		else if(moisture > 0.4)
			return prob(50) ? /turf/open/floor/cracked_earth : /turf/open/floor/sand
		else
			var/terrain_roll = rand(1, 100)
			if(terrain_roll <= 50)
				return /turf/open/floor/sand
			else if(terrain_roll <= 80)
				return /turf/open/floor/dirt
			else
				return /turf/open/floor/cracked_earth

	if(temperature > 0.3)
		if(moisture > 0.5)
			return /turf/open/floor/cracked_earth
		else
			return prob(60) ? /turf/open/floor/sand : /turf/open/floor/cracked_earth

	if(moisture > 0.5)
		return /turf/open/floor/cracked_earth
	else
		return prob(70) ? /turf/open/floor/cracked_earth : /turf/open/floor/sand

/datum/island_biome/desert/select_flora(temperature, moisture, height)
	if(prob(10))
		return /obj/item/natural/stone
	if(moisture > 0.4 && temperature > 0.4 && temperature < 0.8)
		if(prob(40))
			return /obj/structure/flora/newtree/palm

	if(temperature > 0.7 && moisture < 0.35)
		if(prob(45))
			return /obj/structure/flora/tree/dead_bush

	if(temperature > 0.6 && moisture > 0.25 && moisture < 0.5)
		if(prob(35))
			return /obj/structure/flora/tree/dying_bush

	if(moisture < 0.5 && temperature > 0.5 && temperature < 0.7)
		if(prob(30))
			return /obj/structure/flora/grass/thorn_bush

	if(prob(60))
		var/list/pick_list = list(
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
			/obj/structure/flora/grass/bush,
		)
		return pick(pick_list)

	return /obj/effect/flora_patch_spawner/plains

/datum/island_biome/desert/select_patch_flora(temperature, moisture, height)
	if(prob(80))
		var/list/pick_list = list(
			/obj/structure/flora/grass/thorn_bush,
		)
		return pick(pick_list)
	else
		if(prob(70))
			var/list/pick_list = list(
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
				/obj/structure/flora/grass,
			)
			return pick(pick_list)

		return null
