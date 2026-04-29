GLOBAL_LIST_EMPTY(slapcraft_firststep_recipe_cache)
GLOBAL_LIST_EMPTY(slapcraft_categorized_recipes)
GLOBAL_LIST_EMPTY(slapcraft_steps)
GLOBAL_LIST_EMPTY(slapcraft_recipes)


/proc/init_slapcraft_recipes()
	var/list/recipe_list = GLOB.slapcraft_recipes
	for(var/datum/type as anything in typesof(/datum/slapcraft_recipe))
		if(IS_ABSTRACT(type))
			continue
		var/datum/slapcraft_recipe/recipe = new type()
		recipe_list[type] = recipe

		// Add the recipe to the categorized global list, which is used for the handbook UI
		if(!GLOB.slapcraft_categorized_recipes[recipe.category])
			GLOB.slapcraft_categorized_recipes[recipe.category] = list()
		if(!GLOB.slapcraft_categorized_recipes[recipe.category][recipe.subcategory])
			GLOB.slapcraft_categorized_recipes[recipe.category][recipe.subcategory] = list()
		GLOB.slapcraft_categorized_recipes[recipe.category][recipe.subcategory] += recipe


/proc/init_molten_recipes()
	var/list/recipe_list = GLOB.molten_recipes
	for(var/datum/type as anything in typesof(/datum/molten_recipe))
		if(IS_ABSTRACT(type))
			continue
		var/datum/molten_recipe/recipe = new type()
		recipe_list |= recipe


/proc/init_slapcraft_steps()
	var/list/step_list = GLOB.slapcraft_steps
	for(var/datum/type as anything in typesof(/datum/slapcraft_step))
		if(IS_ABSTRACT(type))
			continue
		step_list[type] = new type()

/// Gets cached recipes for a type. This is a method of optimizating recipe lookup. Ugly but gets the job done.
/// also WARNING: This will make it so all recipes whose first step is not type checked will not work, which all recipes that I can think of will be.
/// If you wish to remove this and GLOB.slapcraft_firststep_recipe_cache should this cause issues, replace the return with GLOB.slapcraft_recipes
/proc/slapcraft_recipes_for_type(passed_type)
	// Falsy entry means we need to make a cache for this type.
	if(isnull(GLOB.slapcraft_firststep_recipe_cache[passed_type]))
		var/list/fitting_recipes = list()
		for(var/recipe_type in GLOB.slapcraft_recipes)
			var/datum/slapcraft_recipe/recipe = SLAPCRAFT_RECIPE(recipe_type)
			var/datum/slapcraft_step/step_one = SLAPCRAFT_STEP(recipe.steps[1])
			if(step_one.check_type(passed_type))
				fitting_recipes += recipe

		if(fitting_recipes.len == 0)
			GLOB.slapcraft_firststep_recipe_cache[passed_type] = FALSE
		else if (fitting_recipes.len == 1)
			GLOB.slapcraft_firststep_recipe_cache[passed_type] = fitting_recipes[1]
		else
			GLOB.slapcraft_firststep_recipe_cache[passed_type] = fitting_recipes


	var/value = GLOB.slapcraft_firststep_recipe_cache[passed_type]
	if(value == FALSE)
		return null

	// Once again, either pointing to a list or to a single value is something hacky but useful here for a very easy memory optimization.
	else if (islist(value))
		return value
	else
		return list(value)

/// Gets examine hints for this item type for slap crafting.
/proc/slapcraft_examine_hints_for_type(passed_type)
	var/list/valid_recipes = slapcraft_recipes_for_type(passed_type)
	if(!valid_recipes)
		return null

	var/list/all_hints = list()
	for(var/datum/slapcraft_recipe/recipe as anything in valid_recipes)
		if(recipe.examine_hint)
			all_hints += recipe.examine_hint

	return all_hints

GLOBAL_LIST_INIT(orderless_slapcraft_recipes, init_orderless_slapcraft_recipes())

/proc/init_orderless_slapcraft_recipes()
	var/list/recipe_list = list()
	for(var/datum/type as anything in typesof(/datum/orderless_slapcraft))
		if(IS_ABSTRACT(type))
			continue
		var/datum/orderless_slapcraft/recipe = new type()
		///this is so we can easily get a list of all recipes from the attacked_item
		if(!(recipe.starting_item in recipe_list))
			recipe_list[recipe.starting_item] = list()
		recipe_list[recipe.starting_item] |= recipe
	return recipe_list

GLOBAL_LIST_INIT(repeatable_crafting_recipes, init_crafting_repeatable_recipes())

/proc/init_crafting_repeatable_recipes()
	var/list/recipe_list = list()
	for(var/datum/type as anything in typesof(/datum/repeatable_crafting_recipe))
		if(IS_ABSTRACT(type))
			continue
		var/datum/repeatable_crafting_recipe/recipe = new type()
		///this is so we can easily get a list of all recipes from the attacked_item
		if(!(recipe.starting_atom in recipe_list))
			recipe_list[recipe.starting_atom] = list()
		recipe_list[recipe.starting_atom] |= recipe
	return recipe_list
