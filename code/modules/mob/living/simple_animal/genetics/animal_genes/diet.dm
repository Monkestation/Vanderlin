/datum/animal_gene/diet
	abstract_type = /datum/animal_gene/diet
	exclusion_group = GENE_GROUP_DIET
	var/list/added_foods = list()
	var/list/removed_foods = list()

/datum/animal_gene/diet/apply_to(mob/living/simple_animal/hostile/target)
	if(..())
		return
	if(!target.food_type)
		target.food_type = list()
	for(var/F in removed_foods)
		target.food_type -= F
	for(var/F in added_foods)
		if(!(F in target.food_type))
			target.food_type += F
	if(target.ai_controller)
		target.ai_controller.set_blackboard_key(BB_BASIC_FOODS, typecacheof(target.food_type))

/datum/animal_gene/diet/remove_from(mob/living/simple_animal/hostile/target)
	if(!..())
		return
	if(!target.food_type)
		return
	for(var/F in added_foods)
		target.food_type -= F
	for(var/F in removed_foods)
		if(!(F in target.food_type))
			target.food_type += F
	if(target.ai_controller)
		target.ai_controller.set_blackboard_key(BB_BASIC_FOODS, typecacheof(target.food_type))

/datum/animal_gene/diet/strict_herbivore
	name = "Strict Herbivore"
	desc = "Will only eat plant matter. Refuses meat entirely."
	rarity = 5
	removed_foods = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/smallrat,
		/obj/item/reagent_containers/food/snacks/fish,
	)

/datum/animal_gene/diet/omnivore
	name = "Opportunistic Omnivore"
	desc = "Will eat almost anything, including meat and fish."
	rarity = 4
	added_foods = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/smallrat,
		/obj/item/reagent_containers/food/snacks/fish,
	)

/datum/animal_gene/diet/carnivore_instinct
	name = "Carnivore Instinct"
	desc = "A rare genetic throwback. This animal craves meat above all else."
	rarity = 2
	dominant = TRUE
	added_foods = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/smallrat,
		/obj/item/reagent_containers/food/snacks/fish,
	)
	removed_foods = list(
		/obj/item/reagent_containers/food/snacks/produce,
	)
	type_whitelist = list(/mob/living/simple_animal/hostile/retaliate/cow)
