GLOBAL_LIST_EMPTY(blueprint_appearance_cache)
GLOBAL_LIST_EMPTY(active_blueprints)
GLOBAL_LIST_EMPTY(blueprint_recipes)

#define BLUEPRINT_SWITCHSTATE_NONE 0
#define BLUEPRINT_SWITCHSTATE_RECIPES 1

/proc/init_blueprint_recipes()
	if(GLOB.blueprint_recipes.len)
		return
	for(var/datum/blueprint_recipe/recipe as anything in subtypesof(/datum/blueprint_recipe))
		if(IS_ABSTRACT(recipe))
			continue
		GLOB.blueprint_recipes[initial(recipe.name)] = new recipe

/datum/blueprint_recipe
	var/name = "Unknown Structure"
	var/desc = "A mysterious structure."
	var/atom/result_type = null // What gets built
	var/list/required_materials = list() // Materials needed (path = amount)
	var/atom/construct_tool
	var/build_time = 2 SECONDS
	var/category = "General"
	var/supports_directions = FALSE // Whether this recipe can be rotated
	var/default_dir = SOUTH // Default direction for the recipe
	///do we take up the whole floor?
	var/floor_object = FALSE

	var/datum/skill/skillcraft = /datum/skill/craft/crafting // What skill this recipe requires (e.g., /datum/skill/craft/carpentry)
	var/craftdiff = 0 // Difficulty modifier (0 = easy, higher = harder)
	var/verbage = "construct" // What the user does (e.g., "build", "assemble")
	var/verbage_tp = "constructs" // Third person version
	var/craftsound = 'sound/foley/bandage.ogg'
	var/edge_density = TRUE
	var/requires_learning = FALSE
	var/pixel_offsets = TRUE
	var/check_placement = FALSE // Whether to run placement checks
	var/check_above_space = FALSE // Check if space above is clear
	var/check_adjacent_wall = FALSE // Check for adjacent wall
	var/requires_ceiling = FALSE
	var/place_on_wall = FALSE /// do we need to be placed directly on the wall turf itself and then offset?
	var/inverse_check = FALSE

/datum/blueprint_recipe/proc/check_craft_requirements(mob/user, turf/T, obj/structure/blueprint/blueprint)
	if(check_above_space)
		var/turf/checking = GET_TURF_ABOVE(T)
		if(!isopenspace(checking))
			return FALSE

	if(requires_ceiling)
		var/turf/checking = GET_TURF_ABOVE(T)
		if(!checking)
			to_chat(user, "<span class='warning'>Need a ceiling above to hang this!</span>")
			return FALSE
		if(istype(checking, /turf/open/openspace))
			to_chat(user, "<span class='warning'>Need a solid ceiling above!</span>")
			return FALSE

	if(check_placement)
		if(locate(/obj/machinery/light/fueled/lanternpost) in T)
			to_chat(user, "<span class='warning'>There's already a light post here!</span>")
			return FALSE
		if(locate(/obj/machinery/light/fueledstreet) in T)
			to_chat(user, "<span class='warning'>There's already a street lamp here!</span>")
			return FALSE
		if(locate(/obj/structure/noose) in T)
			to_chat(user, "<span class='warning'>There's already a noose here!</span>")
			return FALSE

	if(check_adjacent_wall)
		var/turf/check_turf = get_step(T, blueprint.blueprint_dir)
		if(inverse_check)
			check_turf = get_step(T, REVERSE_DIR(blueprint.blueprint_dir))
		if(!isclosedturf(check_turf))
			to_chat(user, "<span class='warning'>Need a wall to attach this to!</span>")
			return FALSE
	return TRUE

/datum/blueprint_recipe/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	SSassets.transport.send_assets(client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	user << browse_rsc('html/book.png')

	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				font-family: "Charm", cursive;
				font-size: 1.2em;
				text-align: center;
				margin: 20px;
				background-color: #f4efe6;
				color: #3e2723;
				background-color: rgb(31, 20, 24);
				background:
					url('[SSassets.transport.get_asset_url("try4_border.png")]'),
					url('book.png');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
			}
			h1 {
				text-align: center;
				font-size: 2em;
				border-bottom: 2px solid #3e2723;
				padding-bottom: 10px;
				margin-bottom: 10px;
			}
			h2 {
				font-size: 1.5em;
				margin-top: 20px;
				margin-bottom: 10px;
				color: #5d4037;
			}
			.icon {
				width: 64px;
				height: 64px;
				vertical-align: middle;
				margin-right: 10px;
			}
			.requirements {
				margin-bottom: 20px;
			}
			.construction-info {
				margin-top: 20px;
				padding: 15px;
				background-color: rgba(139, 69, 19, 0.1);
				border: 1px solid #8b4513;
				border-radius: 5px;
			}
			.skill-info {
				margin-top: 15px;
				font-style: italic;
				color: #6d4c41;
			}
			.description {
				margin: 15px 0;
				font-style: italic;
				color: #5d4037;
			}
			.category {
				display: inline-block;
				background-color: #8b4513;
				color: white;
				padding: 3px 8px;
				border-radius: 3px;
				font-size: 0.9em;
				margin-bottom: 10px;
			}
			.difficulty {
				color: #d32f2f;
				font-weight: bold;
			}
		</style>
		<body>
		  <div>
			<h1>[name]</h1>
			<div class="category">[category]</div>
			<div class="description">[desc]</div>
	"}

	// Add required materials
	if(length(required_materials))
		html += "<div class='requirements'><h2>Required Materials</h2>"
		for(var/atom/path as anything in required_materials)
			var/count = required_materials[path]
			html += "[icon2html(new path, user)] [count] [initial(path.name)]<br>"
		html += "</div>"

	// Construction information
	html += "<div class='construction-info'>"

	// Tool requirement
	if(construct_tool)
		var/obj/item/tool = new construct_tool
		html += "<strong>Required Tool:</strong><br>"
		html += "[icon2html(tool, user)] [initial(tool.name)]<br><br>"
		qdel(tool)
	else
		html += "<strong>Required Tool: hand</strong><br>"

	if(skillcraft)
		html += "<strong>Required Skill:</strong> [initial(skillcraft.name)]<br>"

		if(craftdiff > 0)
			html += "<span class='difficulty'>Difficulty: [craftdiff]</span><br>"


	html += "<strong>Construction Time:</strong> [build_time * 0.1] seconds<br>"

	if(supports_directions)
		html += "<strong>Supports Rotation:</strong> Yes<br>"
		var/dir_name = "South" // Default
		switch(default_dir)
			if(NORTH) dir_name = "North"
			if(SOUTH) dir_name = "South"
			if(EAST) dir_name = "East"
			if(WEST) dir_name = "West"
		html += "<strong>Default Direction:</strong> [dir_name]<br>"

	// Floor object indicator
	if(floor_object)
		html += "<strong>Floor Coverage:</strong> Full floor tile<br>"

	html += "</div>"

	// Result information
	html += "<div class='requirements'><h2>Creates</h2>"
	if(result_type)
		var/atom/result = new result_type
		html += "[icon2html(result, user)] <strong>[initial(result.name)]</strong><br>"
		qdel(result)
	else
		html += "Unknown result<br>"
	html += "</div>"

	html += {"
		</div>
	</body>
	</html>
	"}

	return html

/datum/blueprint_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user), "window=blueprint_recipe;size=500x810")

// Optional: Recipe book collection system
/datum/blueprint_recipe/proc/generate_recipe_book_html(mob/user, list/recipes)
	var/client/client = user
	if(!istype(client))
		client = user.client
	SSassets.transport.send_assets(client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	user << browse_rsc('html/book.png')

	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				font-family: "Charm", cursive;
				font-size: 1.1em;
				margin: 20px;
				background-color: rgb(31, 20, 24);
				color: #3e2723;
				background:
					url('[SSassets.transport.get_asset_url("try4_border.png")]'),
					url('book.png');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
			}
			h1 {
				text-align: center;
				font-size: 2.5em;
				border-bottom: 3px solid #3e2723;
				padding-bottom: 15px;
				margin-bottom: 20px;
			}
			h2 {
				font-size: 1.8em;
				margin-top: 25px;
				margin-bottom: 15px;
				color: #5d4037;
				border-bottom: 1px solid #8b4513;
			}
			.recipe-entry {
				margin: 10px 0;
				padding: 10px;
				background-color: rgba(139, 69, 19, 0.1);
				border-left: 4px solid #8b4513;
				cursor: pointer;
			}
			.recipe-entry:hover {
				background-color: rgba(139, 69, 19, 0.2);
			}
			.recipe-name {
				font-weight: bold;
				font-size: 1.1em;
			}
			.recipe-desc {
				font-style: italic;
				color: #6d4c41;
				margin-top: 5px;
			}
			.category-tag {
				display: inline-block;
				background-color: #8b4513;
				color: white;
				padding: 2px 6px;
				border-radius: 3px;
				font-size: 0.8em;
				margin-right: 10px;
			}
		</style>
		<script>
			function showRecipe(recipe_ref) {
				window.location.href = '?src=' + recipe_ref + ';show_recipe=1';
			}
		</script>
		<body>
		  <div>
			<h1>Construction Recipe Book</h1>
	"}

	// Group recipes by category
	var/list/categories = list()
	for(var/datum/blueprint_recipe/recipe in recipes)
		if(!categories[recipe.category])
			categories[recipe.category] = list()
		categories[recipe.category] += recipe

	// Display each category
	for(var/category_name in categories)
		html += "<h2>[category_name]</h2>"
		var/list/category_recipes = categories[category_name]
		for(var/datum/blueprint_recipe/recipe in category_recipes)
			html += "<div class='recipe-entry' onclick='showRecipe(\"[REF(recipe)]\")'>"
			html += "<div class='recipe-name'>[recipe.name]</div>"
			html += "<div class='recipe-desc'>[recipe.desc]</div>"
			html += "</div>"

	html += {"
		</div>
	</body>
	</html>
	"}

	return html

/datum/blueprint_recipe/proc/show_recipe_book(mob/user, list/recipes)
	user << browse(generate_recipe_book_html(user, recipes), "window=recipe_book;size=600x800")

/mob
	var/datum/blueprint_system/blueprints

/mob/proc/enter_blueprint()
	if(!client)
		return
	ADD_TRAIT(src, TRAIT_BLUEPRINT_VISION, TRAIT_GENERIC)
	blueprints = new(client)
