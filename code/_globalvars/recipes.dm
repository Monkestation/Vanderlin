GLOBAL_LIST_INIT(artificer_recipes, init_subtypes(/datum/artificer_recipe, list(), allow_abstract = FALSE))
GLOBAL_LIST_INIT(alch_grind_recipes, init_subtypes(/datum/alch_grind_recipe, list(), allow_abstract = FALSE))
GLOBAL_LIST_INIT(alch_cauldron_recipes, init_subtypes(/datum/alch_cauldron_recipe, list(), allow_abstract = FALSE))
GLOBAL_LIST_INIT(brewing_recipes, init_subtypes(/datum/brewing_recipe, list(), allow_abstract = FALSE))
/// This is a global list of typepaths, these typepaths are resulting atoms that are associated with anvil recipe paths.
GLOBAL_LIST_EMPTY(anvil_recipes_atom)
/// List of anvil recipe typepaths associated with modified name to display when presenting recipes
GLOBAL_LIST_EMPTY(anvil_recipe_description)
/// Global list of all instances of smithing-related recipes
GLOBAL_LIST_INIT(anvil_recipes, init_anvil_recipes())

/proc/init_anvil_recipes()
	. = list()
	var/list/anvil_recipes_atoms = GLOB.anvil_recipes_atom
	var/list/anvil_recipe_description = GLOB.anvil_recipe_description
	for(var/datum/path as anything in subtypesof(/datum/anvil_recipe))
		if(IS_ABSTRACT(path))
			continue
		var/datum/anvil_recipe/recipe_instance = new path()
		. += new path()
		anvil_recipes_atoms[recipe_instance.created_item] = path

		var/modified_name = "[recipe_instance.name]"

		if(recipe_instance.output_amount > 1)
			modified_name += " ([recipe_instance.output_amount]x)"

		modified_name += " \[[uppertext(SSskills.level_names_plain[recipe_instance.craftdiff])]\]"

		var/list/additional_items = list()
		for(var/obj/item/item as anything in recipe_instance.additional_items)
			additional_items += "+[capitalize(item.name)] [recipe_instance.additional_items[item]]x"
		var/combined_string = additional_items.Join(",  ")
		if(combined_string)
			modified_name += " ([combined_string])"

		anvil_recipe_description[path] = modified_name
