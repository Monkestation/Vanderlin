/datum/recipe_tree_node
	var/recipe_path				// Path to the actual recipe datum
	var/recipe_type				// Type of crafting system (slapcraft, anvil, etc.)
	var/item_result			// What this recipe produces
	var/recipe_name			// Display name of the recipe
	var/list/ingredients = list()		// Required ingredients
	var/list/child_nodes = list()		// Sub-recipes needed for ingredients
	var/node_x = 0				// Position in tree
	var/node_y = 0
	var/depth = 0				// How deep in the tree (0 = final product)
	var/can_craft = FALSE			// Whether player can currently make this

/datum/recipe_tree_interface
	var/target_item				// The item we're building a tree for
	var/datum/recipe_tree_node/root_node	// Top-level recipe
	var/list/all_nodes = list()		// All nodes in the tree
	var/mob/user				// Who's viewing this
	var/list/recipe_cache = list()			// Cache of all recipes indexed by result item
	var/recipe_cache_built = FALSE			// Whether cache has been built

/datum/recipe_tree_interface/New(target_item_path, mob/viewing_user)
	target_item = target_item_path
	user = viewing_user
	build_recipe_tree()


/datum/recipe_tree_interface/proc/calculate_tree_positions()
	if(!root_node)
		return

	var/list/levels = list()
	organize_nodes_by_depth(root_node, levels)

	for(var/depth in levels)
		var/list/nodes_at_depth = levels[depth]
		var/node_count = length(nodes_at_depth)
		var/spacing = 200 // Horizontal spacing between nodes
		var/start_x = -(node_count - 1) * spacing / 2

		for(var/i = 1; i <= node_count; i++)
			var/datum/recipe_tree_node/node = nodes_at_depth[i]
			node.node_x = start_x + (i - 1) * spacing
			node.node_y = text2num(depth) * 120 // Vertical spacing between levels

/datum/recipe_tree_interface/proc/organize_nodes_by_depth(datum/recipe_tree_node/node, list/levels, visited = null)
	if(!visited)
		visited = list()

	if(node in visited)
		return
	visited += node

	if(!levels["[node.depth]"])
		levels["[node.depth]"] = list()
	levels["[node.depth]"] += node

	for(var/datum/recipe_tree_node/child in node.child_nodes)
		organize_nodes_by_depth(child, levels, visited)

/datum/recipe_tree_interface/proc/build_recipe_tree()
	var/list/recipes = find_recipes_for_item(target_item)

	if(!length(recipes))
		return FALSE

	all_nodes.Cut()

	root_node = create_recipe_node(recipes[1], 0, 0, 0)
	all_nodes += root_node

	var/list/created_nodes = list()
	created_nodes[target_item] = root_node

	build_dependencies(root_node, created_nodes)

	calculate_tree_positions()

	return TRUE

/datum/recipe_tree_interface/proc/build_recipe_cache()
	if(recipe_cache_built)
		return

	recipe_cache_built = TRUE

	scan_repeatable_crafting_recipes()
	scan_orderless_slapcraft_recipes()
	scan_slapcraft_recipes()
	scan_container_craft_recipes()
	scan_molten_recipes()
	scan_anvil_recipes()
	scan_artificer_recipes()
	scan_pottery_recipes()
	scan_brewing_recipes()
	scan_runerituals_recipes()
	scan_alch_cauldron_recipes()
	scan_natural_precursor_recipes()
	scan_essence_combination_recipes()
	scan_essence_infusion_recipes()
	scan_blueprint_recipes()


/datum/recipe_tree_interface/proc/scan_blueprint_recipes()
	for(var/recipe_path in subtypesof(/datum/blueprint_recipe))
		var/datum/blueprint_recipe/recipe = new recipe_path()

		if(!recipe.result_type)
			qdel(recipe)
			continue

		var/list/ingredients = list()

		// Add the construction tool if specified
		if(recipe.construct_tool)
			ingredients += recipe.construct_tool

		// Add required materials
		if(recipe.required_materials)
			for(var/material in recipe.required_materials)
				ingredients += material

		add_recipe_to_cache(
			recipe.result_type,
			recipe_path,
			"blueprint",
			recipe.name,
			ingredients,
			list(
				"category" = recipe.category,
				"description" = recipe.desc,
				"build_time" = recipe.build_time,
				"craft_difficulty" = recipe.craftdiff,
				"skill_required" = recipe.skillcraft,
				"construct_tool" = recipe.construct_tool,
				"required_materials" = recipe.required_materials,
				"supports_directions" = recipe.supports_directions,
				"default_dir" = recipe.default_dir,
				"floor_object" = recipe.floor_object,
				"verbage" = recipe.verbage,
				"verbage_tp" = recipe.verbage_tp,
				"craftsound" = recipe.craftsound,
				"edge_density" = recipe.edge_density,
				"requires_learning" = recipe.requires_learning
			)
		)

		qdel(recipe)

/datum/recipe_tree_interface/proc/find_recipes_for_item(item_path)
	build_recipe_cache()
	return recipe_cache[item_path] || list()


/datum/recipe_tree_interface/proc/scan_slapcraft_recipes()
	for(var/recipe_path in subtypesof(/datum/slapcraft_recipe))
		var/datum/slapcraft_recipe/recipe = new recipe_path()

		if(!recipe.result_type && !length(recipe.result_list))
			qdel(recipe)
			continue

		var/list/unique_items = list()

		// Just get unique item types from steps
		if(islist(recipe.steps))
			for(var/step_type in recipe.steps)
				var/datum/slapcraft_step/step = new step_type()

				if(step.check_types && length(step.item_types))
					unique_items |= step.item_types

				qdel(step)

		add_recipe_to_cache(
			recipe.result_type,
			recipe_path,
			"slapcraft",
			recipe.name,
			unique_items,
			list(
				"category" = recipe.category,
				"subcategory" = recipe.subcategory,
				"craft_difficulty" = recipe.craftdiff,
				"skill_required" = recipe.skillcraft,
				"assembly_weight" = recipe.assembly_weight_class,
				"can_disassemble" = recipe.can_disassemble
			)
		)

		qdel(recipe)

/datum/recipe_tree_interface/proc/scan_molten_recipes()
	for(var/recipe_path in subtypesof(/datum/molten_recipe))
		var/datum/molten_recipe/recipe = new recipe_path()

		if(!length(recipe.output))
			qdel(recipe)
			continue

		var/list/ingredients = list()
		for(var/material in recipe.materials_required)
			ingredients += material

		for(var/output in recipe.output)
			add_recipe_to_cache(
				output,
				recipe_path,
				"molten",
				recipe.name,
				ingredients,
				list(
					"category" = recipe.category,
					"temperature" = recipe.temperature_required,
					"materials" = recipe.materials_required
				)
			)

		qdel(recipe)

/datum/recipe_tree_interface/proc/scan_pottery_recipes()
	for(var/recipe_path in subtypesof(/datum/pottery_recipe))
		var/datum/pottery_recipe/recipe = new recipe_path()

		if(!recipe.created_item)
			qdel(recipe)
			continue

		add_recipe_to_cache(
			recipe.created_item,
			recipe_path,
			"pottery",
			recipe.name,
			recipe.recipe_steps,
			list(
				"category" = recipe.category,
				"difficulty" = recipe.difficulty,
				"speed_sweetspot" = recipe.speed_sweetspot,
				"step_times" = recipe.step_to_time
			)
		)

		qdel(recipe)

/datum/recipe_tree_interface/proc/scan_runerituals_recipes()
	for(var/recipe_path in subtypesof(/datum/runerituals))
		var/datum/runerituals/recipe = new recipe_path()

		if(!length(recipe.result_atoms) && !recipe.mob_to_summon)
			qdel(recipe)
			continue

		var/result
		if(length(recipe.result_atoms))
			result = recipe.result_atoms[1]
		else
			result = recipe.mob_to_summon

		add_recipe_to_cache(
			result,
			recipe_path,
			"ritual",
			recipe.name,
			recipe.required_atoms,
			list(
				"category" = recipe.category,
				"description" = recipe.desc,
				"tier" = recipe.tier,
				"blacklisted" = recipe.blacklisted,
				"banned_types" = recipe.banned_atom_types
			)
		)

		qdel(recipe)

/datum/recipe_tree_interface/proc/scan_repeatable_crafting_recipes()
	for(var/recipe_path in subtypesof(/datum/repeatable_crafting_recipe))
		var/datum/repeatable_crafting_recipe/recipe = new recipe_path()

		if(!recipe.output)
			qdel(recipe)
			continue

		var/list/ingredients = list()
		if(recipe.requirements)
			for(var/ingredient in recipe.requirements)
				ingredients += ingredient

		if(recipe.reagent_requirements)
			for(var/reagent in recipe.reagent_requirements)
				ingredients += reagent

		if(recipe.starting_atom)
			ingredients += recipe.starting_atom

		if(recipe.attacked_atom)
			ingredients += recipe.attacked_atom

		add_recipe_to_cache(
			recipe.output,
			recipe_path,
			"repeatable_crafting",
			recipe.name,
			ingredients,
			list(
				"category" = recipe.category,
				"craft_difficulty" = recipe.craftdiff,
				"skill_required" = recipe.skillcraft,
				"minimum_skill" = recipe.minimum_skill_level,
				"craft_time" = recipe.craft_time,
				"requires_learning" = recipe.requires_learning,
				"required_table" = recipe.required_table
			)
		)

		qdel(recipe)

/datum/recipe_tree_interface/proc/scan_orderless_slapcraft_recipes()
	for(var/recipe_path in subtypesof(/datum/orderless_slapcraft))
		var/datum/orderless_slapcraft/recipe = new recipe_path()

		if(!recipe.output_item)
			qdel(recipe)
			continue

		var/list/ingredients = list()

		if(recipe.starting_item)
			ingredients += recipe.starting_item

		if(recipe.requirements)
			for(var/requirement in recipe.requirements)
				ingredients += requirement

		if(recipe.finishing_item)
			ingredients += recipe.finishing_item

		add_recipe_to_cache(
			recipe.output_item,
			recipe_path,
			"orderless_slapcraft",
			recipe.recipe_name || recipe.name,
			ingredients,
			list(
				"category" = recipe.category,
				"action_time" = recipe.action_time,
				"related_skill" = recipe.related_skill,
				"skill_xp" = recipe.skill_xp_gained,
			)
		)

		qdel(recipe)

/datum/recipe_tree_interface/proc/scan_container_craft_recipes()
	for(var/recipe_path in subtypesof(/datum/container_craft))
		var/datum/container_craft/recipe = new recipe_path()

		if(!recipe.output)
			qdel(recipe)
			continue

		var/list/ingredients = list()

		if(recipe.requirements)
			for(var/requirement in recipe.requirements)
				ingredients += requirement

		if(recipe.wildcard_requirements)
			for(var/requirement in recipe.wildcard_requirements)
				ingredients += requirement

		if(recipe.reagent_requirements)
			for(var/reagent in recipe.reagent_requirements)
				ingredients += reagent

		add_recipe_to_cache(
			recipe.output,
			recipe_path,
			"container_craft",
			recipe.name,
			ingredients,
			list(
				"category" = recipe.category,
				"crafting_time" = recipe.crafting_time,
				"required_container" = recipe.required_container,
				"craft_verb" = recipe.craft_verb,
				"used_skill" = recipe.used_skill,
				"isolation_craft" = recipe.isolation_craft,
				"user_craft" = recipe.user_craft
			)
		)

		qdel(recipe)

/datum/recipe_tree_interface/proc/scan_anvil_recipes()
	for(var/recipe_path in subtypesof(/datum/anvil_recipe))
		var/datum/anvil_recipe/recipe = new recipe_path()

		if(!recipe.created_item)
			qdel(recipe)
			continue

		var/list/ingredients = list()

		if(recipe.req_bar)
			ingredients += recipe.req_bar

		if(recipe.additional_items)
			for(var/item in recipe.additional_items)
				ingredients += item

		add_recipe_to_cache(
			recipe.created_item,
			recipe_path,
			"anvil",
			recipe.recipe_name || recipe.name,
			ingredients,
			list(
				"category" = recipe.category,
				"craft_difficulty" = recipe.craftdiff,
				"skill_required" = recipe.appro_skill,
				"materials_needed" = recipe.num_of_materials,
				"rotations_required" = recipe.rotations_required,
				"created_count" = recipe.createditem_extra + 1
			)
		)

		qdel(recipe)

/datum/recipe_tree_interface/proc/scan_artificer_recipes()
	for(var/recipe_path in subtypesof(/datum/artificer_recipe))
		var/datum/artificer_recipe/recipe = new recipe_path()

		if(!recipe.created_item)
			qdel(recipe)
			continue

		var/list/ingredients = list()

		if(recipe.required_item)
			ingredients += recipe.required_item

		if(recipe.additional_items)
			for(var/item in recipe.additional_items)
				ingredients += item

		add_recipe_to_cache(
			recipe.created_item,
			recipe_path,
			"artificer",
			recipe.name,
			ingredients,
			list(
				"category" = recipe.category,
				"craft_difficulty" = recipe.craftdiff,
				"skill_required" = recipe.appro_skill,
				"hammers_per_item" = recipe.hammers_per_item,
				"created_amount" = recipe.created_amount
			)
		)

		qdel(recipe)

/datum/recipe_tree_interface/proc/scan_brewing_recipes()
	for(var/recipe_path in subtypesof(/datum/brewing_recipe))
		var/datum/brewing_recipe/recipe = new recipe_path()

		if(!recipe.reagent_to_brew && !recipe.brewed_item)
			qdel(recipe)
			continue

		var/list/ingredients = list()
		if(recipe.needed_crops)
			for(var/crop in recipe.needed_crops)
				ingredients += crop

		if(recipe.needed_reagents)
			for(var/reagent in recipe.needed_reagents)
				ingredients += reagent

		if(recipe.needed_items)
			for(var/item in recipe.needed_items)
				ingredients += item

		var/output = recipe.brewed_item || recipe.reagent_to_brew

		add_recipe_to_cache(
			output,
			recipe_path,
			"brewing",
			recipe.secondary_name || recipe.name,
			ingredients,
			list(
				"category" = recipe.category,
				"brew_time" = recipe.brew_time,
				"sell_value" = recipe.sell_value,
				"brewed_amount" = recipe.brewed_amount,
				"per_brew_amount" = recipe.per_brew_amount,
				"ages" = length(recipe.age_times),
				"heat_required" = recipe.heat_required,
				"pre_reqs" = recipe.pre_reqs
			)
		)

		qdel(recipe)

/datum/recipe_tree_interface/proc/scan_alch_cauldron_recipes()
	for(var/recipe_path in subtypesof(/datum/alch_cauldron_recipe))
		var/datum/alch_cauldron_recipe/recipe = new recipe_path()

		if(!recipe.output_reagents && !recipe.output_items)
			qdel(recipe)
			continue

		var/list/ingredients = list()

		if(recipe.required_essences)
			for(var/essence in recipe.required_essences)
				ingredients += essence

		var/output
		if(recipe.output_items && length(recipe.output_items))
			output = recipe.output_items[1]
		else if(recipe.output_reagents && length(recipe.output_reagents))
			output = recipe.output_reagents[1]

		if(output)
			add_recipe_to_cache(
				output,
				recipe_path,
				"alch_cauldron",
				recipe.recipe_name,
				ingredients,
				list(
					"category" = recipe.category,
					"smells_like" = recipe.smells_like,
					"output_reagents" = recipe.output_reagents,
					"output_items" = recipe.output_items
				)
			)

		qdel(recipe)

/datum/recipe_tree_interface/proc/scan_natural_precursor_recipes()
	for(var/recipe_path in subtypesof(/datum/natural_precursor))
		var/datum/natural_precursor/recipe = new recipe_path()

		if(!recipe.essence_yields)
			qdel(recipe)
			continue

		var/list/ingredients = list()

		if(recipe.init_types)
			for(var/type in recipe.init_types)
				ingredients += type

		for(var/essence_type in recipe.essence_yields)
			add_recipe_to_cache(
				essence_type,
				recipe_path,
				"natural_precursor",
				"[recipe.name] -> [essence_type]",
				ingredients,
				list(
					"category" = recipe.category,
					"yield_amount" = recipe.essence_yields[essence_type],
					"all_yields" = recipe.essence_yields
				)
			)

		qdel(recipe)

/datum/recipe_tree_interface/proc/scan_essence_combination_recipes()
	for(var/recipe_path in subtypesof(/datum/essence_combination))
		var/datum/essence_combination/recipe = new recipe_path()

		if(!recipe.output_type)
			qdel(recipe)
			continue

		var/list/ingredients = list()

		if(recipe.inputs)
			for(var/essence in recipe.inputs)
				ingredients += essence

		add_recipe_to_cache(
			recipe.output_type,
			recipe_path,
			"essence_combination",
			recipe.name,
			ingredients,
			list(
				"category" = recipe.category,
				"output_amount" = recipe.output_amount,
				"skill_required" = recipe.skill_required,
				"inputs" = recipe.inputs
			)
		)

		qdel(recipe)

/datum/recipe_tree_interface/proc/scan_essence_infusion_recipes()
	for(var/recipe_path in subtypesof(/datum/essence_infusion_recipe))
		var/datum/essence_infusion_recipe/recipe = new recipe_path()

		if(!recipe.result_type)
			qdel(recipe)
			continue

		var/list/ingredients = list()

		if(recipe.target_type)
			ingredients += recipe.target_type

		if(recipe.required_essences)
			for(var/essence in recipe.required_essences)
				ingredients += essence

		add_recipe_to_cache(
			recipe.result_type,
			recipe_path,
			"essence_infusion",
			recipe.name,
			ingredients,
			list(
				"category" = recipe.category,
				"target_type" = recipe.target_type,
				"infusion_time" = recipe.infusion_time,
				"required_essences" = recipe.required_essences
			)
		)

		qdel(recipe)

/datum/recipe_tree_interface/proc/create_recipe_node(recipe_data, x, y, depth)
	var/datum/recipe_tree_node/node = new()

	node.recipe_path = recipe_data["path"]
	node.recipe_type = recipe_data["type"]
	node.item_result = recipe_data["result"] || "Unknown Item"
	node.recipe_name = recipe_data["name"] || "Unknown Recipe"
	node.ingredients = recipe_data["ingredients"] || list()
	node.node_x = x
	node.node_y = y
	node.depth = depth
	node.can_craft = can_user_craft_recipe(recipe_data)

	return node

/datum/recipe_tree_interface/proc/build_dependencies(datum/recipe_tree_node/parent, list/created_nodes)
	var/child_offset_x = -100 * length(parent.ingredients) / 2
	var/child_y = parent.node_y + 120

	for(var/ingredient in parent.ingredients)
		if(created_nodes[ingredient])
			parent.child_nodes += created_nodes[ingredient]
			continue

		var/list/ingredient_recipes = find_recipes_for_item(ingredient)

		var/datum/recipe_tree_node/child
		if(length(ingredient_recipes))
			child = create_recipe_node(
				ingredient_recipes[1],
				parent.node_x + child_offset_x,
				child_y,
				parent.depth + 1
			)
		else
			child = create_raw_material_node(
				ingredient,
				parent.node_x + child_offset_x,
				child_y,
				parent.depth + 1
			)

		created_nodes[ingredient] = child
		parent.child_nodes += child
		all_nodes += child

		if(child.depth < 10)
			build_dependencies(child, created_nodes)

		child_offset_x += 200

/datum/recipe_tree_interface/proc/create_raw_material_node(item_path, x, y, depth)
	var/datum/recipe_tree_node/node = new()

	node.recipe_path = null
	node.recipe_type = "raw_material"
	node.item_result = item_path
	node.recipe_name = "[get_item_name(item_path)] (Raw Material)"
	node.ingredients = list()
	node.node_x = x
	node.node_y = y
	node.depth = depth
	node.can_craft = can_user_obtain_raw_material(item_path)

	return node

/datum/recipe_tree_interface/proc/can_user_obtain_raw_material(item_path)
	// Check if the user can obtain this raw material
	// This SHOULD check things like:
	// - Is it a gatherable resource they have access to?
	// - Do they have the right tools/skills to gather it?
	// But this is a POC
	return TRUE

/datum/recipe_tree_interface/proc/generate_recipe_nodes_html()
	var/html = ""
	var/center_x = 0
	var/center_y = 0

	var/list/rendered_nodes = list()

	for(var/datum/recipe_tree_node/node in all_nodes)
		if(rendered_nodes["\ref[node]"])
			continue
		rendered_nodes["\ref[node]"] = TRUE

		var/class_list = "recipe-node"

		// Add recipe type specific classes
		if(node.recipe_type == "raw_material")
			class_list += " raw-material"
			if(node.can_craft)
				class_list += " obtainable"
			else
				class_list += " unavailable"
		else if(node.recipe_type == "blueprint")
			class_list += " blueprint"
			if(node.can_craft)
				class_list += " craftable"
			else
				class_list += " locked"
		else
			if(node.can_craft)
				class_list += " craftable"
			else
				class_list += " locked"

		var/node_x = center_x + node.node_x - 24
		var/node_y = center_y + node.node_y - 24

		var/node_data = list(
			"name" = node.recipe_name,
			"type" = node.recipe_type,
			"ingredients" = get_ingredient_names(node.ingredients),
			"result" = node.item_result,
			"path" = node.recipe_path,
			"is_raw_material" = (node.recipe_type == "raw_material"),
			"is_blueprint" = (node.recipe_type == "blueprint")
		)

		var/item_icon = get_item_icon(node.item_result)
		var/item_icon_state = get_item_icon_state(node.item_result)

		html += {"<div class="[class_list]"
			style="left: [node_x]px; top: [node_y]px;"
			data-nodeinfo='[json_encode(node_data)]'
			title="[node.recipe_name]">
			<img src='\ref[item_icon]?state=[item_icon_state]' alt="[node.recipe_name]" />
			<div class="recipe-type-tag">[get_recipe_type_abbreviation(node.recipe_type)]</div>
		</div>"}

	return html

/datum/recipe_tree_interface/proc/generate_recipe_connections_html()
	var/html = ""
	var/center_x = 0
	var/center_y = 0

	for(var/datum/recipe_tree_node/parent in all_nodes)
		for(var/datum/recipe_tree_node/child in parent.child_nodes)
			var/start_center_x = center_x + parent.node_x
			var/start_center_y = center_y + parent.node_y
			var/end_center_x = center_x + child.node_x
			var/end_center_y = center_y + child.node_y

			var/dx = end_center_x - start_center_x
			var/dy = end_center_y - start_center_y
			var/distance = sqrt(dx*dx + dy*dy)

			if(distance == 0)
				continue

			var/angle = arctan(dx, dy)
			if(angle < 0)
				angle += 360

			var/is_craftable_connection = parent.can_craft && child.can_craft
			var/connection_class = "connection-line"
			if(is_craftable_connection)
				connection_class += " craftable"

			html += {"<div class="[connection_class]"
				style="left: [start_center_x]px; top: [start_center_y - 1.5]px; width: [distance]px; transform: rotate([angle]deg); transform-origin: 0 50%; z-index: 1;">
			</div>"}

	return html

/datum/recipe_tree_interface/proc/get_ingredient_names(list/ingredients)
	var/list/names = list()
	for(var/ingredient in ingredients)
		names += get_item_name(ingredient)
	return names

/datum/recipe_tree_interface/proc/get_item_name(atom/item_path)
	if(ispath(item_path))
		return initial(item_path.name) || "[item_path]"
	return "[item_path]"

/datum/recipe_tree_interface/proc/get_item_icon(atom/item_path)
	if(ispath(item_path))
		return initial(item_path.icon) || 'icons/roguetown/items/misc.dmi'
	return 'icons/roguetown/items/misc.dmi'

/datum/recipe_tree_interface/proc/get_item_icon_state(atom/item_path)
	// This should return the icon state for the item
	if(ispath(item_path))
		return initial(item_path.icon_state) || ""
	return ""

/datum/recipe_tree_interface/proc/get_recipe_type_abbreviation(recipe_type)
	switch(recipe_type)
		if("repeatable_crafting")
			return "RC"
		if("slapcraft")
			return "SC"
		if("anvil")
			return "AN"
		if("artificer")
			return "AR"
		if("pottery")
			return "PT"
		if("brewing")
			return "BR"
		if("alchemy")
			return "AL"
		if("raw_material")
			return "RM"
		if("blueprint")
			return "BP"
		else
			return "??"

/datum/recipe_tree_interface/proc/can_user_craft_recipe(recipe_data)
	// Check if user has required skills, tools, access, etc.
	// This would integrate with your existing crafting permission system

	switch(recipe_data["type"])
		if("repeatable_crafting")
			return can_craft_repeatable_crafting(recipe_data)
		if("slapcraft")
			return can_craft_slapcraft(recipe_data)
		if("anvil")
			return can_craft_anvil(recipe_data)


	return TRUE
/datum/recipe_tree_interface/proc/can_craft_repeatable_crafting(recipe_data)
	// TODO: Implement specific checks for repeatable crafting
	return TRUE

/datum/recipe_tree_interface/proc/can_craft_slapcraft(recipe_data)
	// TODO: Implement specific checks for slapcraft
	return TRUE

/datum/recipe_tree_interface/proc/can_craft_anvil(recipe_data)
	// TODO: Implement specific checks for anvil recipes
	return TRUE

/datum/recipe_tree_interface/proc/generate_interface_html()
	user << browse_rsc('html/KettleParallaxBG.png')
	user << browse_rsc('html/KettleParallaxNeb.png')

	var/html = {"
	<html>
	<head>
		<style>
			body {
				margin: 0;
				padding: 0;
				background: #000;
				color: #eee;
				font-family: Arial, sans-serif;
				overflow: hidden;
			}

			.parallax-container {
				position: fixed;
				top: 0;
				left: 0;
				width: 100%;
				height: 100vh;
				overflow: hidden;
				z-index: -1;
			}

			.parallax-layer {
				position: absolute;
				width: 120%;
				height: 120%;
				background-repeat: repeat;
			}

			.parallax-bg {
				background-image: url('KettleParallaxBG.png');
				background-size: cover;
				background-repeat: no-repeat;
				background-position: center;
			}

			.parallax-stars-1 {
				background: radial-gradient(ellipse at center,
					rgba(34, 139, 34, 0.3) 0%,
					rgba(0, 100, 0, 0.2) 40%,
					transparent 70%),
					radial-gradient(circle at 20% 30%, rgba(144, 238, 144, 0.8) 1px, transparent 2px),
					radial-gradient(circle at 80% 20%, rgba(34, 139, 34, 0.6) 1px, transparent 2px),
					radial-gradient(circle at 60% 80%, rgba(46, 139, 87, 0.4) 2px, transparent 4px);
				background-size: 800px 600px, 200px 150px, 300px 200px, 250px 180px;
				opacity: 0.8;
			}

			.parallax-stars-2 {
				background: radial-gradient(ellipse at 40% 60%,
					rgba(34, 139, 34, 0.2) 0%,
					rgba(0, 100, 0, 0.1) 50%,
					transparent 80%),
					radial-gradient(circle at 15% 85%, rgba(144, 238, 144, 0.9) 1px, transparent 2px),
					radial-gradient(circle at 70% 15%, rgba(34, 139, 34, 0.7) 1px, transparent 2px);
				background-size: 600px 450px, 180px 130px, 280px 190px;
				opacity: 0.6;
			}

			.parallax-neb {
				background-image: url('KettleParallaxNeb.png');
				background-size: cover;
				background-repeat: no-repeat;
				background-position: center;
				opacity: 0.4;
			}

			.recipe-container {
				position: relative;
				width: 100%;
				height: 100vh;
				overflow: hidden;
				cursor: grab;
				z-index: 1;
			}

			.recipe-container.dragging { cursor: grabbing; }

			.recipe-node.blueprint {
				border-radius: 6px;
				border: 2px solid rgba(70, 130, 180, 0.6); /* Steel blue border for blueprints */
			}

			.recipe-node.blueprint.craftable {
				border: 2px solid rgba(30, 144, 255, 0.7); /* Dodger blue if craftable */
			}

			.recipe-node.blueprint.craftable img {
				filter: hue-rotate(210deg) brightness(1.1) drop-shadow(0 0 4px rgba(30,144,255,0.6));
			}

			.recipe-node.blueprint.locked {
				border: 2px solid rgba(105, 105, 105, 0.7); /* Dim gray if locked */
				opacity: 0.6;
			}

			.recipe-node.blueprint.locked img {
				filter: grayscale(80%) brightness(0.8);
			}

			.recipe-node.blueprint .recipe-type-tag {
				background: rgba(70, 130, 180, 0.8);
				border: 1px solid rgba(100, 149, 237, 0.6);
			}

			.recipe-node.blueprint.craftable .recipe-type-tag {
				background: rgba(30, 144, 255, 0.8);
				border: 1px solid rgba(65, 105, 225, 0.6);
			}

			.tooltip.blueprint h3 {
				color: #87CEEB; /* Sky blue for blueprint recipe names */
				text-shadow: 0 0 4px rgba(135,206,235,0.5);
			}

			.blueprint-info {
				color: #87CEEB;
			}

			.recipe-node.raw-material {
				border-radius: 8px;
				border: 2px solid rgba(139, 69, 19, 0.6); /* Brown border for raw materials */
			}

			.recipe-node.raw-material.obtainable {
				border: 2px solid rgba(34, 139, 34, 0.7); /* Green if obtainable */
			}

			.recipe-node.raw-material.obtainable img {
				filter: hue-rotate(90deg) brightness(1.1) drop-shadow(0 0 4px rgba(34,139,34,0.6));
			}

			.recipe-node.raw-material.unavailable {
				border: 2px solid rgba(139, 0, 0, 0.7); /* Red if unavailable */
				opacity: 0.6;
			}

			.recipe-node.raw-material.unavailable img {
				filter: grayscale(80%) brightness(0.8);
			}

			.recipe-node.raw-material .recipe-type-tag {
				background: rgba(139, 69, 19, 0.8);
				border: 1px solid rgba(160, 82, 45, 0.6);
			}

			.recipe-node.raw-material.obtainable .recipe-type-tag {
				background: rgba(34, 139, 34, 0.8);
				border: 1px solid rgba(50, 205, 50, 0.6);
			}

			.recipe-canvas {
				position: absolute;
				transform-origin: 0 0;
			}

			.connection-line {
				position: absolute;
				height: 3px;
				background: linear-gradient(90deg,
					rgba(34,139,34,0.8) 0%,
					rgba(50,205,50,0.6) 50%,
					rgba(34,139,34,0.4) 100%);
				transform-origin: left center;
				z-index: 5;
				border-radius: 1px;
				box-shadow: 0 0 4px rgba(34,139,34,0.3);
			}

			.connection-line.craftable {
				background: linear-gradient(90deg,
					rgba(255,215,0,0.8) 0%,
					rgba(255,140,0,0.6) 50%,
					rgba(255,215,0,0.4) 100%);
				box-shadow: 0 0 4px rgba(255,215,0,0.3);
			}

			.recipe-node {
				position: absolute;
				width: 32px;
				height: 32px;
				cursor: pointer;
				transition: all 0.15s ease;
				display: flex;
				align-items: center;
				justify-content: center;
				z-index: 10;
				border-radius: 4px;
			}

			.recipe-node img {
				width: 40px;
				height: 40px;
				object-fit: contain;
			}

			.recipe-node.craftable {
				border: 2px solid rgba(0, 255, 0, 0.5);
			}

			.recipe-node.craftable img {
				filter: hue-rotate(45deg) brightness(1.2) drop-shadow(0 0 4px rgba(50,205,50,0.8));
			}

			.recipe-node.available {
				border: 2px solid rgba(255, 165, 0, 0.5);
			}

			.recipe-node.available img {
				filter: hue-rotate(20deg) brightness(1.1) drop-shadow(0 0 4px rgba(255,165,0,0.6));
			}

			.recipe-node.locked {
				opacity: 0.4;
				filter: grayscale(100%) brightness(0.7);
			}

			.recipe-node.locked img {
				opacity: 0.4;
				filter: grayscale(100%) brightness(0.7);
			}

			.recipe-node.selected {
				transform: scale(1.05);
			}

			.recipe-node.selected img {
				filter: hue-rotate(-30deg) brightness(1.3) drop-shadow(0 0 8px rgba(255, 69, 0, 0.8));
			}

			.recipe-node:hover {
				transform: scale(1.15);
				z-index: 100;
			}

			.recipe-node:hover img {
				filter: brightness(1.4) drop-shadow(0 0 6px rgba(255, 255, 255, 0.8));
			}

			.tooltip {
				position: absolute;
				background: rgba(15,15,30,0.95);
				border: 2px solid #228B22;
				border-radius: 12px;
				padding: 12px;
				max-width: 320px;
				z-index: 1000;
				pointer-events: none;
				box-shadow: 0 8px 24px rgba(0,0,0,0.7);
				backdrop-filter: blur(5px);
			}

			.tooltip h3 {
				margin: 0 0 8px 0;
				color: #90EE90;
				text-shadow: 0 0 4px rgba(144,238,144,0.5);
			}

			.tooltip.craftable h3 {
				color: #32CD32;
				text-shadow: 0 0 4px rgba(50,205,50,0.5);
			}

			.tooltip p { margin: 5px 0; font-size: 12px; }
			.ingredients { color: #FFB6C1; }
			.recipe-type { color: #87CEEB; }
			.craftable-info { color: #32CD32; }
			.locked-info { color: #FF6B6B; }

			.info-panel {
				position: fixed;
				bottom: 10px;
				left: 10px;
				background: rgba(15,15,30,0.9);
				border: 2px solid #228B22;
				border-radius: 8px;
				padding: 10px;
				color: #90EE90;
			}

			.recipe-type-tag {
				position: absolute;
				top: -8px;
				right: -8px;
				background: rgba(34,139,34,0.8);
				color: white;
				font-size: 10px;
				padding: 2px 4px;
				border-radius: 4px;
				border: 1px solid rgba(50,205,50,0.5);
			}
		</style>
	</head>
	<body>
		<div class="parallax-container">
			<div class="parallax-layer parallax-bg" id="parallax-bg"></div>
			<div class="parallax-layer parallax-stars-1" id="parallax-stars-1"></div>
			<div class="parallax-layer parallax-stars-2" id="parallax-stars-2"></div>
			<div class="parallax-layer parallax-neb" id="parallax-neb"></div>
		</div>

		<div class="recipe-container" id="container">
			<div class="recipe-canvas" id="canvas">
				[generate_recipe_connections_html()]
				[generate_recipe_nodes_html()]
			</div>
		</div>

		<div class="info-panel">
			<div>Recipe Tree for: [get_item_name(target_item)]</div>
			<div>Total Recipes Found: [length(all_nodes)]</div>
		</div>

		<div class="tooltip" id="tooltip" style="display: none;"></div>

		<script>
			let isDragging = false;
			let startX, startY;
			let currentX = 400, currentY = 300;
			let scale = 1;

			// Load saved position
			try {
				const savedX = sessionStorage.getItem('recipe_pos_x');
				const savedY = sessionStorage.getItem('recipe_pos_y');
				const savedScale = sessionStorage.getItem('recipe_scale');
				if (savedX !== null) currentX = parseFloat(savedX);
				if (savedY !== null) currentY = parseFloat(savedY);
				if (savedScale !== null) scale = parseFloat(savedScale);
			} catch(e) {
				currentX = 400;
				currentY = 300;
				scale = 1;
			}

			const container = document.getElementById('container');
			const canvas = document.getElementById('canvas');
			const tooltip = document.getElementById('tooltip');

			const parallaxBg = document.getElementById('parallax-bg');
			const parallaxStars1 = document.getElementById('parallax-stars-1');
			const parallaxStars2 = document.getElementById('parallax-stars-2');
			const parallaxNeb = document.getElementById('parallax-neb');

			updateCanvasTransform();

			// Event listeners
			container.addEventListener('mousedown', function(e) {
				if (e.target === container || e.target === canvas || e.target.classList.contains('connection-line')) {
					isDragging = true;
					startX = e.clientX - currentX;
					startY = e.clientY - currentY;
					container.classList.add('dragging');
					e.preventDefault();
				}
			});

			document.addEventListener('mousemove', function(e) {
				if (isDragging) {
					currentX = e.clientX - startX;
					currentY = e.clientY - startY;
					updateCanvasTransform();
					updateParallax();
					savePosition();
				}

				// Tooltip handling
				if (e.target.classList.contains('recipe-node') || e.target.parentElement.classList.contains('recipe-node')) {
					const node = e.target.classList.contains('recipe-node') ? e.target : e.target.parentElement;
					showTooltip(e, node);
				} else {
					hideTooltip();
				}
			});

			document.addEventListener('mouseup', function() {
				isDragging = false;
				container.classList.remove('dragging');
			});

			container.addEventListener('wheel', function(e) {
				e.preventDefault();
				const zoomSpeed = 0.1;
				const rect = container.getBoundingClientRect();
				const mouseX = e.clientX - rect.left;
				const mouseY = e.clientY - rect.top;

				const oldScale = scale;
				scale += e.deltaY > 0 ? -zoomSpeed : zoomSpeed;
				scale = Math.max(0.3, Math.min(3, scale));

				const scaleChange = scale / oldScale;
				currentX = mouseX - (mouseX - currentX) * scaleChange;
				currentY = mouseY - (mouseY - currentY) * scaleChange;

				updateCanvasTransform();
				updateParallax();
				savePosition();
			});

			function updateCanvasTransform() {
				canvas.style.transform = 'translate(' + currentX + 'px, ' + currentY + 'px) scale(' + scale + ')';
			}

			function updateParallax() {
				const bgSlowness = 0.998046875;
				const stars1Slowness = 0.696625;
				const stars2Slowness = 0.896625;
				const nebSlowness = 0.5;

				parallaxBg.style.transform = 'translate(' + (currentX * (1 - bgSlowness)) + 'px, ' + (currentY * (1 - bgSlowness)) + 'px)';
				parallaxStars1.style.transform = 'translate(' + (currentX * (1 - stars1Slowness)) + 'px, ' + (currentY * (1 - stars1Slowness)) + 'px)';
				parallaxStars2.style.transform = 'translate(' + (currentX * (1 - stars2Slowness)) + 'px, ' + (currentY * (1 - stars2Slowness)) + 'px)';
				parallaxNeb.style.transform = 'translate(' + (currentX * (1 - nebSlowness)) + 'px, ' + (currentY * (1 - nebSlowness)) + 'px)';
			}

			function savePosition() {
				try {
					sessionStorage.setItem('recipe_pos_x', currentX.toString());
					sessionStorage.setItem('recipe_pos_y', currentY.toString());
					sessionStorage.setItem('recipe_scale', scale.toString());
				} catch(e) {
					// Silently fail
				}
			}

			function showTooltip(e, node) {
				try {
					const nodeData = JSON.parse(node.dataset.nodeinfo);
					const isCraftable = node.classList.contains('craftable');
					const isBlueprint = nodeData.is_blueprint;

					let html = '<h3>' + nodeData.name + '</h3>';
					html += '<p class="recipe-type"><strong>Recipe Type:</strong> ' + nodeData.type + '</p>';

					if (nodeData.ingredients && nodeData.ingredients.length > 0) {
						html += '<p class="ingredients"><strong>Ingredients:</strong></p>';
						nodeData.ingredients.forEach(function(ingredient) {
							html += '<p class="ingredients">' + ingredient + '</p>';
						});
					}

					if (isBlueprint) {
						html += '<p class="blueprint-info"><strong>Category:</strong> Construction</p>';
						html += '<p class="blueprint-info"><strong>Build Type:</strong> Blueprint</p>';
					}

					if (isCraftable) {
						html += '<p class="craftable-info"><strong>Status:</strong> Can Craft</p>';
					} else {
						html += '<p class="locked-info"><strong>Status:</strong> Missing Requirements</p>';
					}

					tooltip.innerHTML = html;
					let tooltipClass = 'tooltip';
					if (isCraftable) tooltipClass += ' craftable';
					if (isBlueprint) tooltipClass += ' blueprint';

					tooltip.className = tooltipClass;
					tooltip.style.display = 'block';
					tooltip.style.left = (e.clientX + 15) + 'px';
					tooltip.style.top = (e.clientY + 15) + 'px';
				} catch(err) {
					console.error('Error showing tooltip:', err);
				}
			}

			function hideTooltip() {
				tooltip.style.display = 'none';
			}

			updateParallax();
		</script>
	</body>
	</html>
	"}

	return html

/datum/recipe_tree_interface/proc/clear_recipe_cache()
	recipe_cache.Cut()
	recipe_cache_built = FALSE

/datum/recipe_tree_interface/proc/add_recipe_to_cache(result_item, recipe_path, recipe_type, recipe_name, list/ingredients, additional_data = null)
	if(!recipe_cache[result_item])
		recipe_cache[result_item] = list()

	var/list/recipe_entry = list(
		"path" = recipe_path,
		"type" = recipe_type,
		"name" = recipe_name,
		"ingredients" = ingredients,
		"result" = result_item
	)

	if(additional_data)
		for(var/key in additional_data)
			recipe_entry[key] = additional_data[key]

	recipe_cache[result_item] += list(recipe_entry)

/datum/recipe_tree_interface/proc/show_recipe_tree_for_item(item_path, mob/user)
	var/datum/recipe_tree_interface/tree = new(item_path, user)
	if(tree.build_recipe_tree())
		var/html = tree.generate_interface_html()
		user << browse(html, "window=recipe_tree;size=1200x800")
	else
		to_chat(user, "No recipes found for that item.")

/datum/recipe_tree_interface/proc/rebuild_cache()
	clear_recipe_cache()
	build_recipe_cache()
	return "Recipe cache rebuilt successfully."

/datum/recipe_tree_interface/proc/get_all_craftable_items()
	build_recipe_cache()
	return recipe_cache.Copy()


/client/proc/recipe_tree_debug_menu()
	set name = "Recipe Tree Debug Menu"
	set category = "Debug.Debug"

	var/html = {"
	<html>
	<head>
		<style>
			body { font-family: Arial, sans-serif; margin: 20px; background: #f0f0f0; }
			.container { max-width: 1000px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; }
			.section { margin-bottom: 30px; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
			.section h2 { margin-top: 0; color: #333; border-bottom: 2px solid #007acc; padding-bottom: 5px; }
			.button {
				background: #007acc; color: white; padding: 10px 15px; border: none;
				border-radius: 5px; cursor: pointer; margin: 5px; display: inline-block;
				text-decoration: none;
			}
			.button:hover { background: #005fa3; }
			.search-box { width: 300px; padding: 8px; margin: 5px; border: 1px solid #ddd; border-radius: 3px; }
			.recipe-list { max-height: 300px; overflow-y: scroll; border: 1px solid #ddd; padding: 10px; }
			.recipe-item {
				padding: 5px; margin: 2px 0; background: #f9f9f9; border-radius: 3px;
				cursor: pointer; border: 1px solid transparent;
			}
			.recipe-item:hover { background: #e9e9e9; border-color: #007acc; }
			.stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; }
			.stat-box { background: #f8f9fa; padding: 15px; border-radius: 5px; text-align: center; }
			.stat-number { font-size: 24px; font-weight: bold; color: #007acc; }
			.warning { background: #fff3cd; border: 1px solid #ffeaa7; padding: 10px; border-radius: 5px; color: #856404; }
		</style>
	</head>
	<body>
		<div class="container">
			<h1>Recipe Tree Debug Interface</h1>

			<div class="section">
				<h2>Quick Actions</h2>
				<a href="byond://?src=\ref[src];action=rebuild_cache" class="button">Rebuild Recipe Cache</a>
				<a href="byond://?src=\ref[src];action=cache_stats" class="button">Show Cache Statistics</a>
				<a href="byond://?src=\ref[src];action=test_system" class="button">Test Recipe System</a>
				<a href="byond://?src=\ref[src];action=export_cache" class="button">Export Cache Data</a>
			</div>

			<div class="section">
				<h2>Recipe Tree Viewer</h2>
				<input type="text" class="search-box" id="item-search" placeholder="Enter item path (e.g., /obj/item/weapon/sword)" />
				<a href="#" class="button" onclick="showRecipeTree()">Show Recipe Tree</a>
				<a href="byond://?src=\ref[src];action=browse_items" class="button">Browse All Craftable Items</a>
			</div>

			<div class="section">
				<h2>Recipe Type Analysis</h2>
				<div id="recipe-type-stats">
					<p>Click "Show Cache Statistics" to view recipe type breakdown</p>
				</div>
			</div>

			<div class="section">
				<h2>Search Results</h2>
				<div id="search-results" class="recipe-list">
					<p>Search results will appear here</p>
				</div>
			</div>

			<div class="warning">
				<strong>Note:</strong> This debug interface requires the recipe cache to be built first.
				If you're seeing empty results, click "Rebuild Recipe Cache" first.
			</div>
		</div>

		<script>
			function showRecipeTree() {
				var itemPath = document.getElementById('item-search').value;
				if (!itemPath) {
					alert('Please enter an item path');
					return;
				}
				window.location = 'byond://?src=\\ref[src];action=show_tree;item=' + encodeURIComponent(itemPath);
			}

			function selectItem(itemPath) {
				document.getElementById('item-search').value = itemPath;
			}
		</script>
	</body>
	</html>
	"}

	src << browse(html, "window=recipe_debug;size=1200x800")

/client/Topic(href, href_list)
	. = ..()

	if(!check_rights(R_DEBUG, FALSE))
		return

	if(href_list["action"])
		switch(href_list["action"])
			if("rebuild_cache")
				debug_rebuild_cache()
			if("cache_stats")
				debug_show_cache_stats()
			if("test_system")
				debug_test_system()
			if("export_cache")
				debug_export_cache()
			if("show_tree")
				debug_show_recipe_tree(href_list["item"])
			if("browse_items")
				debug_browse_items()

/client/proc/debug_rebuild_cache()
	to_chat(mob, "Rebuilding recipe cache...")
	var/datum/recipe_tree_interface/tree = new()
	var/start_time = world.time
	tree.build_recipe_cache()
	var/end_time = world.time

	var/total_recipes = 0
	for(var/item in tree.recipe_cache)
		total_recipes += length(tree.recipe_cache[item])

	to_chat(mob, "Recipe cache rebuilt successfully!")
	to_chat(mob, "- Total items with recipes: [length(tree.recipe_cache)]")
	to_chat(mob, "- Total recipes: [total_recipes]")
	to_chat(mob, "- Build time: [end_time - start_time] deciseconds")

/client/proc/debug_show_cache_stats()
	var/datum/recipe_tree_interface/tree = new()
	tree.build_recipe_cache()

	var/list/type_counts = list()
	var/total_recipes = 0

	for(var/item in tree.recipe_cache)
		var/list/recipes = tree.recipe_cache[item]
		total_recipes += length(recipes)

		for(var/i = 1; i <= length(recipes); i++)
			var/list/recipe_data = recipes[i]
			var/recipe_type = recipe_data["type"]
			type_counts[recipe_type] = (type_counts[recipe_type] || 0) + 1

	var/html = {"
	<html>
	<head>
		<style>
			body { font-family: Arial, sans-serif; margin: 20px; background: #f0f0f0; }
			.container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; }
			table { width: 100%; border-collapse: collapse; margin: 20px 0; }
			th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
			th { background: #007acc; color: white; }
			.stat-highlight { font-size: 24px; color: #007acc; font-weight: bold; text-align: center; margin: 20px 0; }
		</style>
	</head>
	<body>
		<div class="container">
			<h1>Recipe Cache Statistics</h1>

			<div class="stat-highlight">
				Total Items: [length(tree.recipe_cache)] | Total Recipes: [total_recipes]
			</div>

			<h2>Recipe Types Breakdown</h2>
			<table>
				<tr><th>Recipe Type</th><th>Count</th><th>Percentage</th></tr>
	"}

	for(var/recipe_type in type_counts)
		var/count = type_counts[recipe_type]
		var/percentage = round((count / total_recipes) * 100, 0.1)
		html += "<tr><td>[recipe_type]</td><td>[count]</td><td>[percentage]%</td></tr>"

	html += {"
			</table>
		</div>
	</body>
	</html>
	"}

	src << browse(html, "window=recipe_stats;size=800x600")

/client/proc/debug_test_system()
	var/datum/recipe_tree_interface/tree = new()
	to_chat(mob, "Testing recipe system...")

	tree.build_recipe_cache()

	if(!length(tree.recipe_cache))
		to_chat(mob, "ERROR: Recipe cache is empty!")
		return

	var/test_item = tree.recipe_cache[rand(length(tree.recipe_cache), 1)]
	to_chat(mob, "Testing with item: [test_item]")

	var/datum/recipe_tree_interface/test_tree = new(test_item, mob)
	if(test_tree.build_recipe_tree())
		to_chat(mob, "SUCCESS: Recipe tree built successfully")
		to_chat(mob, "- Root node: [test_tree.root_node.recipe_name]")
		to_chat(mob, "- Total nodes: [length(test_tree.all_nodes)]")
		to_chat(mob, "- Max depth: [get_max_depth(test_tree.all_nodes)]")
	else
		to_chat(mob, "ERROR: Failed to build recipe tree")

/client/proc/debug_export_cache()
	var/datum/recipe_tree_interface/tree = new()
	tree.build_recipe_cache()

	var/export_data = ""
	export_data += "RECIPE CACHE EXPORT\n"
	export_data += "Generated: [time2text(world.realtime)]\n"
	export_data += "Total Items: [length(tree.recipe_cache)]\n\n"

	for(var/item in tree.recipe_cache)
		export_data += "ITEM: [item]\n"
		var/list/recipes = tree.recipe_cache[item]

		for(var/i = 1; i <= length(recipes); i++)
			var/list/recipe_data = recipes[i]
			export_data += "  Recipe [i]: [recipe_data["name"]] ([recipe_data["type"]])\n"
			export_data += "    Path: [recipe_data["path"]]\n"
			export_data += "    Ingredients: [json_encode(recipe_data["ingredients"])]\n"

		export_data += "\n"

	src << browse_rsc(export_data, "recipe_cache_export.txt")
	to_chat(mob, "Recipe cache exported to recipe_cache_export.txt")

/client/proc/debug_show_recipe_tree(item_path)
	if(!item_path)
		return

	var/path = text2path(item_path)
	if(!path)
		to_chat(mob, "Invalid item path: [item_path]")
		return

	var/datum/recipe_tree_interface/tree = new(path, mob)
	if(tree.build_recipe_tree())
		var/html = tree.generate_interface_html()
		src << browse(html, "window=recipe_tree;size=1200x800")
	else
		to_chat(mob, "No recipes found for [item_path]")

/client/proc/debug_browse_items()
	var/datum/recipe_tree_interface/tree = new()
	tree.build_recipe_cache()

	var/html = {"
	<html>
	<head>
		<style>
			body { font-family: Arial, sans-serif; margin: 20px; }
			.item-list { max-height: 500px; overflow-y: scroll; border: 1px solid #ddd; }
			.item-entry {
				padding: 8px; margin: 2px 0; background: #f9f9f9; border-radius: 3px;
				cursor: pointer; border: 1px solid transparent;
			}
			.item-entry:hover { background: #e9e9e9; border-color: #007acc; }
			.recipe-count { color: #666; font-size: 12px; }
		</style>
	</head>
	<body>
		<h1>All Craftable Items ([length(tree.recipe_cache)] items)</h1>
		<div class="item-list">
	"}

	for(var/item in tree.recipe_cache)
		var/list/recipes = tree.recipe_cache[item]
		var/recipe_count = length(recipes)
		html += {"<div class="item-entry" onclick="parent.selectItem('[item]')">
			<strong>[item]</strong><br>
			<span class="recipe-count">[recipe_count] recipe[recipe_count > 1 ? "s" : ""]</span>
		</div>"}

	html += {"
		</div>
		<script>
			function selectItem(itemPath) {
				window.location = 'byond://?src=\\ref[src];action=show_tree;item=' + encodeURIComponent(itemPath);
			}
		</script>
	</body>
	</html>
	"}

	src << browse(html, "window=item_browser;size=600x700")

/proc/get_max_depth(list/nodes)
	var/max_depth = 0
	for(var/datum/recipe_tree_node/node in nodes)
		if(node.depth > max_depth)
			max_depth = node.depth
	return max_depth
