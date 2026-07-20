/datum/test_situation/test_craft
	start = "test_craft"
	var/static/list/crafting_recipes = list()

/datum/test_situation/test_craft/arguements()
	if(!length(crafting_recipes))
		for(var/datum/repeatable_crafting_recipe/recipe as anything in subtypesof(/datum/repeatable_crafting_recipe))
			if(IS_ABSTRACT(recipe))
				continue
			crafting_recipes |= "[recipe]"
	return crafting_recipes

/datum/test_situation/test_craft/execute_test(obj/abstract/visual_ui_element/scrollable/console_output/output, list/arg_list)
	var/mob/living/starter = output.get_user()
	if(!isliving(starter))
		output.add_line("ERROR: No host to bind to.")
		return
	var/recipe = arg_list[1]
	if(!recipe)
		output.add_line("ERROR: No recipe passed.")
		return

	var/datum/repeatable_crafting_recipe/crafter = new recipe
	for(var/path as anything in crafter.requirements)
		for(var/i = 1 to crafter.requirements[path])
			new path(get_turf(starter))

	for(var/reagent as anything in crafter.reagent_requirements)
		var/obj/item/reagent_containers/glass/bottle/bottle = new(get_turf(starter))
		bottle.reagents.add_reagent(reagent, crafter.reagent_requirements[reagent])

	for(var/tool as anything in crafter.tool_usage)
		new tool(get_turf(starter))

	if(crafter.required_table)
		for(var/turf/open/turf in range(1, crafter))
			new /obj/structure/table(turf)
			break

	var/obj/item/attacked_item = locate(crafter.attacked_atom) in get_turf(starter)
	if(!attacked_item)
		attacked_item = new crafter.attacked_atom(get_turf(starter))

	var/obj/item/starting_atom = locate(crafter.starting_atom) in get_turf(starter)
	if(!starting_atom)
		starting_atom = new crafter.starting_atom(get_turf(starting_atom))

	starter.drop_all_held_items()

	starter.put_in_active_hand(starting_atom, TRUE)
	attacked_item.attackby(starting_atom, starter)

	qdel(crafter)
