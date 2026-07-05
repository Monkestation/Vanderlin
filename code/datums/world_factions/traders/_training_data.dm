/datum/training_data
	///what recipes we teach goes: profession = list(recipe = list(level, cost))
	var/list/learnable_recipes = list()


/datum/training_data/proc/return_viable_recipes(mob/living/customer)
	var/list/possible_recipes = list()
	for(var/datum/profession/profession as anything in learnable_recipes)
		var/list/profession_recipes = learnable_recipes[profession]
		var/level = get_profession_level(customer.key, profession)
		for(var/item in profession_recipes)
			var/list/data = profession_recipes[item]
			if(level < data[1])
				continue
			if(has_recipe_unlocked(customer.ckey, item, profession))
				continue
			possible_recipes[item] = data[2]
	return possible_recipes

/datum/training_data/proc/return_recipe_profession(recipe_type)
	for(var/datum/profession/profession as anything in learnable_recipes)
		var/list/profession_recipes = learnable_recipes[profession]
		if(recipe_type in profession_recipes)
			return profession

/datum/training_data/blacksmith
	learnable_recipes = list(
		/datum/profession/blacksmith = list(
			/datum/anvil_recipe/armor/iron/neck/bevor = list(1, 20),
			/datum/anvil_recipe/armor/iron/under/chainleg = list(1, 20)
		)
	)
