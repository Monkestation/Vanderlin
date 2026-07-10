GLOBAL_LIST_INIT(artificer_recipes, init_subtypes(/datum/artificer_recipe, list(), allow_abstract = FALSE))
GLOBAL_LIST_INIT(alch_grind_recipes, init_subtypes(/datum/alch_grind_recipe, list(), allow_abstract = FALSE))
GLOBAL_LIST_INIT(alch_cauldron_recipes, init_subtypes(/datum/alch_cauldron_recipe, list(), allow_abstract = FALSE))
GLOBAL_LIST_INIT(anvil_recipes, init_subtypes(/datum/anvil_recipe, list(), allow_abstract = FALSE))

/// This is a global list of typepaths, these typepaths are resulting atoms that are associated with anvil recipes.
GLOBAL_LIST_INIT(anvil_recipes_atom, init_anvil_recipes_atom())

/proc/init_anvil_recipes_atom()
	. = list()
	for(var/datum/anvil_recipe/recipe as anything in subtypesof(/datum/anvil_recipe))
		if(IS_ABSTRACT(recipe))
			continue
		.[recipe::created_item] = recipe
