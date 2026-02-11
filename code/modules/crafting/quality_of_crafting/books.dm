/obj/item/recipe_book

	icon = 'icons/roguetown/items/books.dmi'
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 64
	slot_flags = ITEM_SLOT_HIP
	var/list/types = list()
	var/open
	var/can_spawn = TRUE
	var/list/categories = list("All") // Default categories
	var/current_category = "All"      // Default selected category
	var/current_recipe = null         // Currently viewed recipe
	var/search_query = ""             // Current search query

/obj/item/recipe_book/Initialize(mapload)
	. = ..()
	// Populate categories from types with custom categories
	generate_categories()

/obj/item/recipe_book/proc/generate_categories()
	categories = list("All") // Reset and add default

	// Gather categories from recipes themselves
	for(var/atom/path as anything in types)
		if(IS_ABSTRACT(path))
			// Handle abstract types
			for(var/atom/sub_path as anything in subtypesof(path))
				if(IS_ABSTRACT(sub_path))
					continue

				var/category = get_recipe_category(sub_path)
				if(category && !(category in categories))
					categories += category
		else
			// Handle non-abstract types directly
			var/category = get_recipe_category(path)
			if(category && !(category in categories))
				categories += category

/obj/item/recipe_book/proc/get_recipe_category(path)
	// Extract category from the recipe
	var/category = null

	// Try to create a temporary instance to get category
	if(ispath(path))
		var/datum/temp_recipe

		// Handle different recipe types
		if(ispath(path, /datum/repeatable_crafting_recipe))
			temp_recipe = new path()
			var/datum/repeatable_crafting_recipe/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/orderless_slapcraft))
			temp_recipe = new path()
			var/datum/orderless_slapcraft/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/blueprint_recipe))
			temp_recipe = new path()
			var/datum/blueprint_recipe/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/blueprint_recipe))
			temp_recipe = new path()
			var/datum/blueprint_recipe/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/container_craft))
			temp_recipe = new path()
			var/datum/container_craft/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/molten_recipe))
			temp_recipe = new path()
			var/datum/molten_recipe/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/anvil_recipe))
			temp_recipe = new path()
			var/datum/anvil_recipe/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/artificer_recipe))
			temp_recipe = new path()
			var/datum/artificer_recipe/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/pottery_recipe))
			temp_recipe = new path()
			var/datum/pottery_recipe/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/brewing_recipe))
			temp_recipe = new path()
			var/datum/brewing_recipe/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/runerituals))
			temp_recipe = new path()
			var/datum/runerituals/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/book_entry))
			temp_recipe = new path()
			var/datum/book_entry/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/alch_cauldron_recipe))
			temp_recipe = new path()
			var/datum/alch_cauldron_recipe/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/essence_combination))
			temp_recipe = new path()
			var/datum/essence_combination/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/natural_precursor))
			temp_recipe = new path()
			var/datum/natural_precursor/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/essence_infusion_recipe))
			temp_recipe = new path()
			var/datum/essence_infusion_recipe/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/plant_def))
			temp_recipe = new path()
			var/datum/plant_def/r = temp_recipe
			category = r.get_family_name()
		else if(ispath(path, /datum/surgery))
			temp_recipe = new path()
			var/datum/surgery/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/wound))
			temp_recipe = new path()
			var/datum/wound/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/chimeric_node))
			category = "Humors"
		else if(ispath(path, /datum/chimeric_table))
			category = "Humor Dossier"
		else if(ispath(path, /obj/item/reagent_containers/food/snacks/fish))
			category = "Fish"

		// Clean up our temporary instance
		if(temp_recipe)
			qdel(temp_recipe)

	return category

/obj/item/recipe_book/dropped(mob/user, silent)
	. = ..()
	user << browse(null,"window=recipe")

/obj/item/recipe_book/attack_self(mob/user, list/modifiers)
	. = ..()
	user << browse(generate_html(user),"window=recipe;size=800x810")

/obj/item/recipe_book/proc/generate_html(mob/user)
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
				margin-bottom: 20px;
			}
			.book-content {
				display: flex;
				height: 85%;
			}
			.sidebar {
				width: 30%;
				padding: 10px;
				border-right: 2px solid #3e2723;
				overflow-y: auto;
				max-height: 600px;
			}
			.main-content {
				width: 70%;
				padding: 10px;
				overflow-y: auto;
				max-height: 600px;
				text-align: left;
			}
			.categories {
				margin-bottom: 15px;
			}
			.category-btn {
				margin: 2px;
				padding: 5px;
				background-color: #d2b48c;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: "Charm", cursive;
			}
			.category-btn.active {
				background-color: #8b4513;
				color: white;
			}
			.search-box {
				width: 90%;
				padding: 5px;
				margin-bottom: 15px;
				border: 1px solid #3e2723;
				border-radius: 5px;
				font-family: "Charm", cursive;
			}
			.recipe-list {
				text-align: left;
			}
			.recipe-link {
				display: block;
				padding: 5px;
				color: #3e2723;
				text-decoration: none;
				border-bottom: 1px dotted #d2b48c;
			}
			.recipe-link:hover {
				background-color: rgba(210, 180, 140, 0.3);
			}
			.recipe-content {
				padding: 10px;
			}
			.recipe-title {
				font-size: 1.5em;
				margin-bottom: 15px;
				border-bottom: 1px solid #3e2723;
				padding-bottom: 5px;
			}
			.back-btn {
				margin-top: 10px;
				padding: 5px 10px;
				background-color: #d2b48c;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: "Charm", cursive;
			}
			.icon {
				width: 96px;
				height: 96px;
				vertical-align: middle;
				margin-right: 10px;
			}
			.result-icon {
				text-align: center;
				margin: 15px 0;
			}
			.craft-button {
				display: inline-block;
				margin: 10px 0;
				padding: 8px 15px;
				background-color: #8b4513;
				color: white;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: "Charm", cursive;
				text-decoration: none;
			}
			.no-matches {
				font-style: italic;
				color: #8b4513;
				padding: 10px;
				text-align: center;
				display: none;
			}
			/* Styles to match the original recipe display */
			table {
				margin: 10px auto;
				border-collapse: collapse;
			}
			table, th, td {
				border: 1px solid #3e2723;
			}
			th, td {
				padding: 8px;
				text-align: left;
			}
			th {
				background-color: rgba(210, 180, 140, 0.3);
			}
			.hidden {
				display: none;
			}
		</style>

		<body>
			<h1>[capitalize(name)]</h1>

			<div class="book-content">
				<div class="sidebar">
					<!-- Search box -->
					<input type="text" class="search-box" id="searchInput"
						placeholder="Search recipes..." value="[html_encode(search_query)]">

					<!-- Categories -->
					<div class="categories">
	"}

	// Add category buttons with direct links
	for(var/category in categories)
		var/active_class = category == current_category ? "active" : ""
		html += "<button class='category-btn [active_class]' onclick=\"location.href='byond://?src=\ref[src];action=set_category&category=[url_encode(category)]'\">[category]</button>"

	html += {"
					</div>

					<!-- Recipe List -->
					<div class="recipe-list" id="recipeList">
	"}

	// Add recipes based on current category
	for(var/atom/path as anything in types)
		if(IS_ABSTRACT(path))
			for(var/atom/sub_path as anything in subtypesof(path))
				if(IS_ABSTRACT(sub_path))
					continue
				if(ispath(sub_path, /datum/container_craft))
					var/datum/container_craft/craft = sub_path
					if(initial(craft.hides_from_books))
						continue
				if(ispath(sub_path, /datum/repeatable_crafting_recipe))
					var/datum/repeatable_crafting_recipe/craft = sub_path
					if(initial(craft.hides_from_books))
						continue
				if(ispath(sub_path, /datum/wound))
					var/datum/wound/wound = sub_path
					if(!initial(wound.show_in_book))
						continue

				var/recipe_name = initial(sub_path.name)
				if(ispath(sub_path, /datum/alch_cauldron_recipe))
					var/datum/alch_cauldron_recipe/typed_sub = sub_path
					recipe_name = typed_sub.recipe_name

				// Check if this recipe belongs to the current category
				var/should_show = TRUE
				if(current_category != "All")
					var/category = get_recipe_category(sub_path)
					if(category != current_category)
						should_show = FALSE

				// Default display style - will be changed by JS if searching
				var/display_style = should_show ? "" : "display: none;"

				var/search_data = ""
				if(ispath(sub_path, /datum/natural_precursor))
					var/datum/natural_precursor/temp = new sub_path()
					for(var/datum/thaumaturgical_essence/essence_type as anything in temp.essence_yields)
						search_data += "[initial(essence_type.name)],"
					qdel(temp)

				if(ispath(sub_path, /datum/surgery))
					var/datum/surgery/temp = new sub_path()
					for(var/datum/surgery_step/step_type as anything in temp.steps)
						search_data += "[initial(step_type.name)],"
					qdel(temp)

				html += "<a class='recipe-link' href='byond://?src=\ref[src];action=view_recipe&recipe=[sub_path]' style='[display_style]' data-search='[search_data]'>[recipe_name]</a>"
		else
			var/recipe_name = initial(path.name)

			// Check if this recipe belongs to the current category
			var/should_show = TRUE
			if(current_category != "All")
				var/category = get_recipe_category(path)
				if(category != current_category)
					should_show = FALSE

			// Default display style - will be changed by JS if searching
			var/display_style = should_show ? "" : "display: none;"

			html += "<a class='recipe-link' href='byond://?src=\ref[src];action=view_recipe&recipe=[path]' style='[display_style]'>[recipe_name]</a>"

	html += {"
						<div id="noMatchesMsg" class="no-matches">No matching recipes found.</div>
					</div>
				</div>

				<div class="main-content" id="mainContent">
	"}

	// If a recipe is selected, show its details
	if(current_recipe)
		html += generate_recipe_html(current_recipe, user)
	else
		html += "<div class='recipe-content'><p>Select a recipe from the list to view details.</p></div>"

	html += {"
				</div>
			</div>

			<script>
				// Live search functionality with debouncing
				let searchTimeout;
				document.getElementById('searchInput').addEventListener('keyup', function(e) {
					clearTimeout(searchTimeout);

					// Debounce the search to improve performance (only search after typing stops for 300ms)
					searchTimeout = setTimeout(function() {
						const query = document.getElementById('searchInput').value.toLowerCase();
						filterRecipes(query);
					}, 300);
				});

				function filterRecipes(query) {
					const recipeLinks = document.querySelectorAll('.recipe-link');
					const currentCategory = "[current_category]";
					let anyVisible = false;

					recipeLinks.forEach(function(link) {
						const recipeName = link.textContent.toLowerCase();
						const essences = (link.getAttribute('data-search') || "").toLowerCase();

						// Check if it matches either the recipe name or any of the essences
						const matchesQuery = query === '' ||
							recipeName.includes(query) ||
							essences.includes(query);

						if (matchesQuery) {
							link.style.display = 'block';
							anyVisible = true;
						} else {
							link.style.display = 'none';
						}
					});

					// Show a message if no recipes match
					const noMatchesMsg = document.getElementById('noMatchesMsg');
					noMatchesMsg.style.display = anyVisible ? 'none' : 'block';

					// Remember the query
					window.location.replace(`byond://?src=\\ref[src];action=remember_query&query=${encodeURIComponent(query)}`);
				}
			</script>
		</body>
		</html>
	"}

	return html

/obj/item/recipe_book/proc/generate_recipe_html(path, mob/user)
	if(!ispath(path))
		return "<div class='recipe-content'><p>Invalid recipe selected.</p></div>"

	var/html = "<div class='recipe-content'>"

	// Get recipe details
	var/recipe_name = "Unknown Recipe"
	var/recipe_description = "No description available."
	var/recipe_html = ""

	// Create a temporary instance to get the actual recipe content that would normally be shown in show_menu
	var/datum/temp_recipe
	if(ispath(path, /datum/repeatable_crafting_recipe))
		temp_recipe = new path()
		var/datum/repeatable_crafting_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_description = recipe_description
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/orderless_slapcraft))
		temp_recipe = new path()
		var/datum/orderless_slapcraft/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/blueprint_recipe))
		temp_recipe = new path()
		var/datum/blueprint_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_description = r.desc || recipe_description
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/blueprint_recipe))
		temp_recipe = new path()
		var/datum/blueprint_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/container_craft))
		temp_recipe = new path()
		var/datum/container_craft/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/molten_recipe))
		temp_recipe = new path()
		var/datum/molten_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/anvil_recipe))
		temp_recipe = new path()
		var/datum/anvil_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/artificer_recipe))
		temp_recipe = new path()
		var/datum/artificer_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/pottery_recipe))
		temp_recipe = new path()
		var/datum/pottery_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/brewing_recipe))
		temp_recipe = new path()
		var/datum/brewing_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/runerituals))
		temp_recipe = new path()
		var/datum/runerituals/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/book_entry))
		temp_recipe = new path()
		var/datum/book_entry/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/alch_cauldron_recipe))
		temp_recipe = new path()
		var/datum/alch_cauldron_recipe/r = temp_recipe
		recipe_name = initial(r.recipe_name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/natural_precursor))
		temp_recipe = new path()
		var/datum/natural_precursor/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/essence_combination))
		temp_recipe = new path()
		var/datum/essence_combination/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/essence_infusion_recipe))
		temp_recipe = new path()
		var/datum/essence_infusion_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/plant_def))
		temp_recipe = new path()
		var/datum/plant_def/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/surgery))
		temp_recipe = new path()
		var/datum/surgery/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/wound))
		temp_recipe = new path()
		var/datum/wound/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/chimeric_node))
		temp_recipe = new path()
		var/datum/chimeric_node/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/chimeric_table))
		temp_recipe = new path()
		var/datum/chimeric_table/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /obj/item/reagent_containers/food/snacks/fish))
		temp_recipe = new path()
		var/obj/item/reagent_containers/food/snacks/fish/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	if(temp_recipe)
		qdel(temp_recipe)

	// If we have recipe-specific HTML, use that
	if(recipe_html && recipe_html != "")
		html += recipe_html
	else
		// Otherwise use our fallback information display
		html += "<h2 class='recipe-title'>[recipe_name]</h2>"
		html += "<p>[recipe_description]</p>"

	// Back button with direct link - kinda really not needed lol
	html += "<button class='back-btn' onclick=\"location.href='byond://?src=\ref[src];action=clear_recipe'\">Back to Recipe List</button>"
	html += "</div>"

	return html

/obj/item/recipe_book/proc/get_recipe_specific_html(datum/recipe, mob/user)
	if(!istype(recipe))
		return ""
	var/html = ""

	html = recipe:generate_html(user)
	return html

/obj/item/recipe_book/Topic(href, href_list)
	. = ..()
	var/action = href_list["action"]
	if(!action)
		return

	switch(action)
		if("set_category")
			var/category = href_list["category"]
			if(category)
				current_category = category
				usr << browse(generate_html(usr), "window=recipe;size=800x810")
			return

		if("search")
			var/query = href_list["query"]
			if(query)
				search_query = query
				usr << browse(generate_html(usr), "window=recipe;size=800x810")
			return

		if("remember_query")
			var/query = href_list["query"]
			if(query)
				search_query = query
			return

		if("view_recipe")
			var/recipe_path = href_list["recipe"]
			if(recipe_path)
				var/datum/path = text2path(recipe_path)
				current_recipe = path
				usr << browse(generate_html(usr), "window=recipe;size=800x810")
			return

		if("clear_recipe")
			current_recipe = null
			usr << browse(generate_html(usr), "window=recipe;size=800x810")
			return

	if(href_list["set_category"])
		current_category = href_list["set_category"]
		usr << browse(generate_html(usr), "window=recipe;size=800x810")
		return

	if(href_list["search"])
		search_query = href_list["search"]
		usr << browse(generate_html(usr), "window=recipe;size=800x810")
		return

	if(href_list["view_recipe"])
		var/datum/path = text2path(href_list["view_recipe"])
		current_recipe = path
		usr << browse(generate_html(usr), "window=recipe;size=800x810")
		return

	if(href_list["clear_recipe"])
		current_recipe = null
		usr << browse(generate_html(usr), "window=recipe;size=800x810")
		return

	if(href_list["pick_recipe"])
		var/datum/path = text2path(href_list["pick_recipe"])
		current_recipe = path
		usr << browse(generate_html(usr), "window=recipe;size=800x810")

/obj/item/recipe_book/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/recipe_book/leatherworking
	name = "The Tanned Hide Tome: Mastery of Leather and Craft"
	desc = "Penned by Orym Vaynore, Fourth Generation Leatherworker."
	icon_state ="book8_0"
	base_icon_state = "book8"

	types = list(/datum/repeatable_crafting_recipe/leather)

/obj/item/recipe_book/sewing
	name = "Threads of Destiny: A Tailor's Codex"
	desc = "Penned by Elise Heiran, Second Generation Court Tailor."
	icon_state ="book7_0"
	base_icon_state = "book7"

	types = list(
		/datum/repeatable_crafting_recipe/sewing,
		/datum/orderless_slapcraft/bouquet,
		)

/obj/item/recipe_book/sewing_leather
	can_spawn = FALSE
	name = "High Fashion Encyclopedia"
	desc = "The combined works of famed Elise Heiran and Orym Vayore."
	icon_state ="book7_0"
	base_icon_state = "book7"
	types = list(
		/datum/repeatable_crafting_recipe/sewing,
		/datum/orderless_slapcraft/bouquet,
		/datum/repeatable_crafting_recipe/leather,
		)

/obj/item/recipe_book/cooking
	name = "The Hearthstone Grimoire: Culinary Secrets of the Realm"
	desc = "Penned by Aric Dunswell, Head Court Chef, Third Generation."
	icon_state ="book6_0"
	base_icon_state = "book6"

	types = list(
		/datum/book_entry/container_craft,
		/datum/brewing_recipe,
		/datum/container_craft/cooking,
		/datum/container_craft/oven,
		/datum/container_craft/pan,
		/datum/repeatable_crafting_recipe/cooking,
		/datum/repeatable_crafting_recipe/salami,
		/datum/repeatable_crafting_recipe/coppiette,
		/datum/repeatable_crafting_recipe/salo,
		/datum/repeatable_crafting_recipe/saltfish,
		/datum/repeatable_crafting_recipe/raisins,
		/datum/orderless_slapcraft/food/pie,
		/datum/orderless_slapcraft/food/tart.
	)

/obj/item/recipe_book/survival
	name = "The Wilderness Guide: Secrets of Survival"
	desc = "Penned by Kaelen Stormrider, Fourth Generation Trailblazer."
	icon_state ="book5_0"
	base_icon_state = "book5"

	types = list(
		/obj/item/reagent_containers/food/snacks/fish,
		/datum/repeatable_crafting_recipe/survival,
		/datum/repeatable_crafting_recipe/cooking/soap,
		/datum/repeatable_crafting_recipe/cooking/soap/bath,
		/datum/repeatable_crafting_recipe/fishing,
		/datum/repeatable_crafting_recipe/sigsweet,
		/datum/repeatable_crafting_recipe/sigdry,
		/datum/repeatable_crafting_recipe/dryleaf,
		/datum/repeatable_crafting_recipe/westleach,
		/datum/repeatable_crafting_recipe/salami,
		/datum/repeatable_crafting_recipe/coppiette,
		/datum/repeatable_crafting_recipe/salo,
		/datum/repeatable_crafting_recipe/saltfish,
		/datum/repeatable_crafting_recipe/raisins,
		/datum/repeatable_crafting_recipe/parchment,
		/datum/repeatable_crafting_recipe/crafting,
		/datum/repeatable_crafting_recipe/projectile,
	)

/obj/item/recipe_book/underworld
	name = "The Smuggler’s Guide: A Treatise on Elixirs of the Guild"
	desc = "Penned by Thorne Ashveil, Thieves' Guild's Alchemist, Second Generation."
	icon_state ="book4_0"
	base_icon_state = "book4"
	can_spawn = FALSE

	types = list(
		/datum/repeatable_crafting_recipe/narcotics,
		/datum/container_craft/cooking/drugs,
		/datum/repeatable_crafting_recipe/bomb,
	)

/obj/item/recipe_book/carpentry
	name = "The Woodwright's Codex: Crafting with Timber and Grain"
	desc = "Penned by Eadric Hollowell, Master Carpenter, Fourth Generation."
	icon_state ="book3_0"
	base_icon_state = "book3"

	types = list(
		/datum/blueprint_recipe/carpentry,
	)

/obj/item/recipe_book/engineering
	name = "The Engineer’s Primer: Machines, Mechanisms, and Marvels"
	desc = "Penned by Liora Brasslock, Chief Engineer, Second Generation."
	icon_state ="book2_0"
	base_icon_state = "book2"

	types = list(
		/datum/book_entry/rotation_stress,
		/datum/book_entry/water_pressure,
		/datum/repeatable_crafting_recipe/engineering,
		/datum/blueprint_recipe/engineering,
		/datum/artificer_recipe,
	)

/obj/item/recipe_book/masonry
	name = "The Stonebinder’s Manual: Foundations of Craft and Fortitude"
	desc = "Penned by Garrin Ironvein, Master Mason, Third Generation."
	icon_state ="book_0"
	base_icon_state = "book"

	types = list(
		/datum/pottery_recipe,
		/datum/blueprint_recipe/masonry,
		/datum/slapcraft_recipe/masonry,
	)

/obj/item/recipe_book/art
	name = "The Artisan's Palette"
	desc = "Created by Elara Moondance, Visionary Painter and Esteemed Tutor."
	icon_state ="book3_0"
	base_icon_state = "book3"

	types = list(
		/datum/repeatable_crafting_recipe/canvas,
		/datum/repeatable_crafting_recipe/paint_palette,
		/datum/repeatable_crafting_recipe/paintbrush,
		/datum/blueprint_recipe/carpentry/easel,
		/datum/repeatable_crafting_recipe/parchment,
		/datum/repeatable_crafting_recipe/crafting/scroll,
		/datum/repeatable_crafting_recipe/reading/guide,
	)

/obj/item/recipe_book/blacksmithing
	name = "The Smith’s Legacy"
	desc = "Penned by Aldric Forgeheart, Master Blacksmith and Keeper of the Ancestral Flame."
	icon_state ="book3_0"
	base_icon_state = "book3"

	types = list(
		/datum/molten_recipe,
		/datum/anvil_recipe,
	)

/obj/item/recipe_book/arcyne
	name = "The Arcanum of Arcyne"
	desc = "Penned by Elyndor Starforge, Grand Arcanist and Keeper of the Ethereal Crucible."
	icon_state ="book4_0"
	base_icon_state = "book4"

	types = list(
		/datum/book_entry/grimoire,
		/datum/book_entry/attunement,
		/datum/book_entry/mana_sources,
		/datum/repeatable_crafting_recipe/arcyne,
		/datum/blueprint_recipe/arcyne,
		/datum/container_craft/cooking/arcyne,
		/datum/runerituals,
	)


/obj/item/recipe_book/alchemy
	name = "Codex Virellia"
	desc = "Transcribed by Maerion Duskwind, Avid Hater of Gnomes."
	icon_state ="book4_0"
	base_icon_state = "book4"

	types = list(
		/datum/book_entry/gnome_homunculus,
		/datum/book_entry/essence_crafting,
		/datum/alch_cauldron_recipe,
		/datum/essence_combination,
		/datum/natural_precursor,
		/datum/essence_infusion_recipe,
		/datum/container_craft/cooking/herbal_salve,
		/datum/container_craft/cooking/herbal_tea,
		/datum/container_craft/cooking/herbal_oil,
		/datum/blueprint_recipe/alchemy,
		/datum/repeatable_crafting_recipe/alchemy,
	)

// Shown when MMBing the /atom/movable/screen/craft "craft" HUD element
/obj/item/recipe_book/always_known
	name = "Survival"
	can_spawn = FALSE
	types = list(
		/datum/repeatable_crafting_recipe/survival)

/obj/item/recipe_book/agriculture
	name = "The Farmers Almanac: Principles of Growth and Harvest"
	desc = "Compiled by Elira Greenshade."
	icon_state = "book_0"
	base_icon_state = "book"

	types = list(
		/datum/book_entry/farming_basics,
		/datum/book_entry/soil_management,
		/datum/book_entry/plant_families,
		/datum/book_entry/plant_genetics,
		/datum/plant_def,
		/datum/repeatable_crafting_recipe/bee_treatment,
		/datum/repeatable_crafting_recipe/bee_treatment/antiviral,
		/datum/repeatable_crafting_recipe/bee_treatment/miticide,
		/datum/repeatable_crafting_recipe/bee_treatment/insecticide,
		/datum/blueprint_recipe/carpentry/apiary,
		/datum/repeatable_crafting_recipe/survival/mushmound,
	)

/obj/item/recipe_book/medical
	name = "The Feldsher's Handbook: Field Medicine and Improvised Care"
	desc = "Compiled by Grim the fickle."
	icon_state ="book4_0"
	base_icon_state = "book4"

	types = list(
		/datum/book_entry/grims_guide,
		/datum/chimeric_table,
		/datum/chimeric_node,
		/datum/wound,
		/datum/surgery,
	)
