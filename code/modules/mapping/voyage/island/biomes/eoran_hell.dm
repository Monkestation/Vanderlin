
/datum/island_biome/eoran_hell
	name = "Fleshy"
	biome_weight = 40
	terrain_weights = list(
		/turf/open/floor/grass/red = 70,
		/turf/open/floor/flesh = 20,
		/turf/open/floor/grass/hell = 10
	)
	flora_weights = list(
		/obj/structure/flora/newtree/scorched = 20,
		/obj/structure/flora/grass = 30,
	)

	beach_turf = /turf/open/floor/sand/bloodied

	flora_density = 2
	max_height = 2
	fauna_density = 6

/datum/island_biome/eoran_hell/setup_spawn_rules()
	..()

	fauna_density -= min(3, difficulty)
	if(difficulty >= 1)
		fauna_types += list(
			/mob/living/simple_animal/pet/cat/cabbit = new /datum/fauna_spawn_rule(
				min_moist = 0.2,
				no_beach_spawn = TRUE,
				max_h = 1,
				weight = 120
			)
		)

	if(difficulty >= 2)
		fauna_types += list(
			/mob/living/simple_animal/hostile/retaliate/fae/sprite = new /datum/fauna_spawn_rule(
				min_moist = 0.3,
				max_moist = 0.8,
				min_temp = 0.3,
				max_temp = 0.7,
				no_beach_spawn = TRUE,
				weight = 80
			),
		)
	if(difficulty >= 3)
		add_settlement_type()

/datum/island_biome/eoran_hell/select_terrain(temperature, moisture, height)
	if(temperature < 0.35)
		if(moisture > 0.4)
			return /turf/open/floor/grass/red
		else
			return /turf/open/floor/flesh

	if(temperature > 0.7 && moisture < 0.35)
		if(prob(60))
			return /turf/open/floor/flesh
		else
			return /turf/open/floor/grass/hell

	if(temperature > 0.65)
		if(moisture > 0.45)
			if(prob(30))
				return /turf/open/floor/dirt
			else
				return /turf/open/floor/grass/hell
		else
			return /turf/open/floor/grass/hell

	if(moisture > 0.6 && temperature > 0.35 && temperature < 0.65)
		if(prob(85))
			return /turf/open/floor/grass/hell
		else
			return /turf/open/floor/flesh

	if(moisture > 0.4 && moisture < 0.7 && temperature > 0.35 && temperature < 0.65)
		var/roll = rand(1, 100)
		if(roll <= 60)
			return /turf/open/floor/grass/hell
		else if(roll <= 75)
			return /turf/open/floor/flesh
		else if(roll <= 90)
			return /turf/open/floor/grass/red
		else
			return /turf/open/floor/dirt

	if(moisture < 0.4 && temperature > 0.35 && temperature < 0.65)
		if(prob(50))
			return /turf/open/floor/flesh
		else
			return /turf/open/floor/grass/hell

	if(height > 0)
		if(prob(40 * height))
			return /turf/open/floor/flesh

	return pickweight(terrain_weights)

/datum/island_biome/eoran_hell/select_flora(temperature, moisture, height)
	if(prob(10))
		return /obj/item/natural/stone
	if(moisture > 0.4 && temperature > 0.3 && temperature < 0.7)
		if(prob(60))
			return /obj/structure/flora/newtree/scorched

	if(prob(70))
		var/list/pick_list = list(
			/obj/structure/wild_plant/nospread/westleach,
			/obj/structure/wild_plant/nospread/manabloom,
			/obj/structure/wild_plant/nospread/jacksberry_poison,
			/obj/structure/wild_plant/nospread/jacksberry,
			/obj/structure/flora/grass/herb/urtica,
			/obj/structure/flora/grass/herb/hypericum,
			/obj/structure/flora/grass/herb/symphitum,
			/obj/structure/flora/grass,
			/obj/structure/flora/grass/herb/salvia,
			/obj/structure/flora/grass/herb/mentha,
			/obj/structure/wild_plant/nospread/fyritiusflower,
			)
		return pick(pick_list)

	return /obj/effect/flora_patch_spawner/plains


/datum/island_biome/eoran_hell/select_patch_flora(temperature, moisture, height)

	if(prob(80))
		var/list/pick_list = list(
			/obj/structure/flora/grass,
			/obj/structure/flora/grass/water,
		)
		return pick(pick_list)
	else
		if(prob(70))
			var/list/pick_list = list(
				/obj/structure/wild_plant/nospread/westleach,
				/obj/structure/wild_plant/nospread/manabloom,
				/obj/structure/wild_plant/nospread/jacksberry_poison,
				/obj/structure/wild_plant/nospread/jacksberry,
				/obj/structure/flora/grass/herb/urtica,
				/obj/structure/flora/grass/herb/hypericum,
				/obj/structure/flora/grass/herb/symphitum,
				/obj/structure/flora/grass,
				/obj/structure/flora/grass/herb/salvia,
				/obj/structure/flora/grass/herb/mentha,
				/obj/structure/wild_plant/nospread/fyritiusflower,
				)
			return pick(pick_list)

		return null
