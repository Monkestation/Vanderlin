/datum/blueprint_system
	var/client/holder
	var/datum/blueprint_recipe/selected_recipe
	var/mutable_appearance/preview_appearance
	var/image/preview_image
	var/atom/movable/screen/blueprint/recipe_button
	var/list/recipe_buttons = list()
	var/list/buttons = list()
	var/current_category = "General"
	var/datum/browser/recipe_browser = null
	var/switch_state = BLUEPRINT_SWITCHSTATE_NONE
	var/pixel_x_offset = 0
	var/pixel_y_offset = 0
	var/li_cb
	var/build_dir = SOUTH
	var/pixel_positioning_mode = FALSE
	var/atom/movable/screen/blueprint/direction/dir_button
	var/atom/movable/screen/blueprint/pixel_mode/pixel_button
	var/atom/movable/blueprint_pixel_dummy/pixel_positioning_dummy = null

/datum/blueprint_system/New(client/c)
	holder = c
	buttons = list()
	li_cb = CALLBACK(src, PROC_REF(post_login))
	holder.player_details.post_login_callbacks += li_cb
	create_buttons()
	holder.screen += buttons
	holder.click_intercept = src
	init_blueprint_recipes()
	RegisterSignal(holder.mob, COMSIG_USER_MOUSE_ENTERED, PROC_REF(on_mouse_moved))
	RegisterSignal(holder?.mob, COMSIG_ATOM_MOUSE_ENTERED, PROC_REF(on_mouse_moved_pre))

/datum/blueprint_system/proc/quit()
	holder.screen -= buttons
	holder.click_intercept = null
	clear_preview()
	clear_pixel_positioning_dummy()
	if(recipe_browser)
		recipe_browser.close()
		recipe_browser = null
	if(holder?.mob)
		UnregisterSignal(holder.mob, COMSIG_USER_MOUSE_ENTERED)
		UnregisterSignal(holder.mob, COMSIG_ATOM_MOUSE_ENTERED)
	qdel(src)

/datum/blueprint_system/Destroy()
	holder.player_details.post_login_callbacks -= li_cb
	holder = null
	clear_preview()
	clear_pixel_positioning_dummy()
	if(recipe_browser)
		recipe_browser.close()
		recipe_browser = null
	return ..()

/datum/blueprint_system/proc/post_login()
	if(QDELETED(holder))
		return
	holder.screen += buttons
	if(switch_state == BLUEPRINT_SWITCHSTATE_RECIPES)
		open_recipe_browser()

/datum/blueprint_system/proc/create_buttons()
	var/datum/hud/hud = holder?.mob?.hud_used
	recipe_button = new /atom/movable/screen/blueprint/recipe(null, hud, src)
	buttons += recipe_button

	dir_button = new /atom/movable/screen/blueprint/direction(null, hud, src)
	buttons += dir_button

	pixel_button = new /atom/movable/screen/blueprint/pixel_mode(null, hud, src)
	buttons += pixel_button

	buttons += new /atom/movable/screen/blueprint/help(null, hud, src)
	buttons += new /atom/movable/screen/blueprint/quit(null, hud, src)

/datum/blueprint_system/proc/create_preview_appearance(datum/blueprint_recipe/recipe)
	clear_preview()
	if(!recipe)
		return

	var/cache_key = "[recipe.result_type]_[build_dir]"
	if(GLOB.blueprint_appearance_cache[cache_key])
		preview_appearance = new
		preview_appearance.appearance = GLOB.blueprint_appearance_cache[cache_key]
	else
		preview_appearance = new
		var/atom/result = recipe.result_type
		preview_appearance.icon = result.icon
		preview_appearance.icon_state = result.icon_state
		if(initial(result.smoothing_flags) & SMOOTH_BITMASK)
			preview_appearance.icon_state = "[preview_appearance.icon_state]-0"
		preview_appearance.dir = recipe.supports_directions ? build_dir : initial(result.dir)
		preview_appearance.color = "#00FFFF"
		preview_appearance.alpha = 150
		GLOB.blueprint_appearance_cache[cache_key] = preview_appearance.appearance

	preview_image = new
	preview_image.appearance = preview_appearance
	preview_image.alpha = 150
	preview_image.plane = ABOVE_LIGHTING_PLANE
	preview_image.layer = FLOAT_LAYER
	preview_image.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	holder.images += preview_image
	update_preview_position()

/datum/blueprint_system/proc/update_preview_position()
	if(!preview_image)
		return

	if(!pixel_positioning_mode || !initial(selected_recipe.pixel_offsets))
		preview_image.pixel_x = 0
		preview_image.pixel_y = 0
	else
		preview_image.pixel_x = pixel_x_offset
		preview_image.pixel_y = pixel_y_offset

/datum/blueprint_system/proc/toggle_pixel_positioning_mode()
	pixel_positioning_mode = !pixel_positioning_mode
	pixel_button.update_appearance()

	if(pixel_positioning_mode)
		to_chat(holder.mob, "<span class='notice'>Pixel positioning mode enabled. Move mouse to adjust pixel position.</span>")
		create_pixel_positioning_dummy()
	else
		to_chat(holder.mob, "<span class='notice'>Pixel positioning mode disabled.</span>")
		clear_pixel_positioning_dummy()
		pixel_y_offset = 0
		pixel_x_offset = 0
		update_preview_position()

/datum/blueprint_system/proc/create_pixel_positioning_dummy()
	clear_pixel_positioning_dummy()
	if(!preview_image)
		return
	pixel_positioning_dummy = new /atom/movable/blueprint_pixel_dummy(get_turf(preview_image.loc), src)

/datum/blueprint_system/proc/clear_pixel_positioning_dummy()
	if(pixel_positioning_dummy)
		qdel(pixel_positioning_dummy)
		pixel_positioning_dummy = null

/datum/blueprint_system/proc/rotate_direction()
	if(!selected_recipe || !selected_recipe.supports_directions)
		to_chat(holder.mob, "<span class='warning'>This blueprint cannot be rotated!</span>")
		return

	switch(build_dir)
		if(SOUTH)
			build_dir = EAST
		if(EAST)
			build_dir = NORTH
		if(NORTH)
			build_dir = WEST
		if(WEST)
			build_dir = SOUTH

	dir_button.update_appearance()
	create_preview_appearance(selected_recipe)
	to_chat(holder.mob, "<span class='notice'>Direction set to [dir2text(build_dir)].</span>")

/datum/blueprint_system/proc/on_mouse_moved_pre(datum/source, atom/atom, params)
	if(istype(source, /atom/movable/blueprint_pixel_dummy))
		return
	on_mouse_moved(source, get_turf(atom), params)

/datum/blueprint_system/proc/on_mouse_moved(datum/source, turf/turf, params)
	if(turf == preview_image?.loc)
		return
	if(!preview_image || !turf)
		return

	preview_image.loc = turf

	if(pixel_positioning_dummy && params)
		pixel_positioning_dummy.forceMove(turf)
		var/list/offsets = get_pixel_offsets_from_screenloc(params)
		if(offsets)
			pixel_x_offset = offsets["x"]
			pixel_y_offset = offsets["y"]

	if(!pixel_positioning_mode)
		pixel_x_offset = 0
		pixel_y_offset = 0

	preview_image.pixel_x = pixel_x_offset
	preview_image.pixel_y = pixel_y_offset

/datum/blueprint_system/proc/clear_preview()
	if(preview_image)
		holder.images -= preview_image
		qdel(preview_image)
		preview_image = null
	preview_appearance = null

/datum/blueprint_system/proc/open_recipe_browser()
	if(!recipe_browser)
		recipe_browser = new(holder.mob, "blueprint_recipes", "Blueprint Recipes", 600, 800)

	var/content = generate_recipe_html()
	recipe_browser.set_content(content)
	recipe_browser.add_stylesheet("blueprintstyle", 'html/browser/buildmode.css')
	recipe_browser.set_window_options("can_close=1;can_minimize=0;can_maximize=0;can_resize=1")
	recipe_browser.open()
	switch_state = BLUEPRINT_SWITCHSTATE_RECIPES

/datum/blueprint_system/proc/generate_recipe_html()
	var/list/dat = list()
	var/mob/user = usr
	dat += "<div class='buildmode-browser'>"
	dat += "<h3>Blueprint Recipe Selection</h3>"

	var/list/categories = list()
	for(var/recipe_id in GLOB.blueprint_recipes)
		var/datum/blueprint_recipe/recipe = GLOB.blueprint_recipes[recipe_id]
		if(recipe.requires_learning && !(recipe.type in user.mind?.learned_recipes))
			continue
		if(!categories[recipe.category])
			categories[recipe.category] = list()
		categories[recipe.category] += recipe_id

	dat += "<div class='tabs'>"
	var/first_category = TRUE
	for(var/category in categories)
		var/active_class = first_category ? "active" : ""
		dat += "<a class='tab [active_class]' href='javascript:void(0)' onclick='showCategory(\"[category]\")'>[category]</a>"
		first_category = FALSE
	dat += "</div>"

	dat += "<div class='search-container'>"
	dat += "<input type='text' class='search-bar' id='recipe-search' placeholder='Search all recipes...'>"
	dat += "</div>"

	dat += {"
	<style>
		.recipe-grid {
			display: grid;
			grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
			gap: 10px;
			padding: 10px;
		}

		.recipe-card {
			background: #2a2a2a;
			border: 1px solid #444;
			border-radius: 6px;
			padding: 8px;
			cursor: pointer;
			transition: all 0.2s ease;
			position: relative;
			min-height: 80px;
			display: flex;
			flex-direction: column;
			align-items: center;
			text-align: center;
			width: 100%;
			box-sizing: border-box;
		}

		.recipe-card:hover {
			background: #3a3a3a;
			border-color: #666;
			transform: translateY(-2px);
		}

		.recipe-card-icon {
			width: 32px;
			height: 32px;
			margin-bottom: 4px;
		}

		.recipe-card-icon img {
			width: 100%;
			height: 100%;
			object-fit: contain;
		}

		.recipe-card-name {
			font-size: 11px;
			font-weight: bold;
			color: #fff;
			line-height: 1.2;
			word-break: break-word;
		}

		.recipe-tooltip {
			position: absolute;
			background: #1a1a1a;
			border: 1px solid #666;
			border-radius: 4px;
			padding: 8px;
			z-index: 1000;
			min-width: 200px;
			max-width: 300px;
			box-shadow: 0 4px 8px rgba(0,0,0,0.3);
			pointer-events: none;
			opacity: 0;
			transition: opacity 0.2s ease;
		}

		.recipe-tooltip.visible {
			opacity: 1;
		}

		.tooltip-name {
			font-weight: bold;
			color: #fff;
			margin-bottom: 4px;
			font-size: 12px;
		}

		.tooltip-desc {
			color: #ccc;
			font-size: 11px;
			margin-bottom: 6px;
			line-height: 1.3;
		}

		.tooltip-materials {
			color: #aaf;
			font-size: 10px;
			margin-bottom: 4px;
		}

		.tooltip-features {
			color: #afa;
			font-size: 10px;
		}

		.category-header {
			grid-column: 1 / -1;
			margin: 10px 0 5px 0;
			color: #fff;
			font-size: 14px;
			border-bottom: 1px solid #444;
			padding-bottom: 2px;
		}

		.recipe-category {
			display: contents;
		}
	</style>
	"}

	// Scripts
	dat += {"
	<script type='text/javascript'>
	(function setupListeners() {
		if (window.blueprintScriptLoaded) return;
		window.blueprintScriptLoaded = true;

		var tooltip = null;

		// Create tooltip element
		function createTooltip() {
			if (!tooltip) {
				tooltip = document.createElement('div');
				tooltip.className = 'recipe-tooltip';
				document.body.appendChild(tooltip);
			}
			return tooltip;
		}

		// Show tooltip
		function showTooltip(event, card) {
			var tip = createTooltip();

			// Build tooltip content from data attributes
			var name = card.getAttribute('data-recipe-name');
			var desc = card.getAttribute('data-recipe-desc');
			var initiateItem = card.getAttribute('data-initiate-item');
			var materialsJson = card.getAttribute('data-materials');
			var featuresJson = card.getAttribute('data-features');

			var content = "<div class='tooltip-name'>" + name + "</div>";
			content += "<div class='tooltip-desc'>" + desc + "</div>";
			content += "<div class='tooltip-materials'>Build with: " + initiateItem + "<br>";
			if (materialsJson && materialsJson !== '\[]') {
				try {
					var materials = JSON.parse(materialsJson);
					content += "<div class='tooltip-materials'>Materials:<br>";
					for (var i = 0; i < materials.length; i++) {
						content += "&nbsp;&nbsp;" + materials\[i\] + "<br>";
					}
					content += "</div>";
				} catch(e) {
					content += "<div class='tooltip-materials'>Materials: " + materialsJson + "</div>";
				}
			}

			if (featuresJson && featuresJson !== '\[]') {
				try {
					var features = JSON.parse(featuresJson);
					content += "<div class='tooltip-features'>Features: " + features.join(', ') + "</div>";
				} catch(e) {
					content += "<div class='tooltip-features'>Features: " + featuresJson + "</div>";
				}
			}

			tip.innerHTML = content;
			tip.classList.add('visible');

			var rect = card.getBoundingClientRect();
			var tipRect = tip.getBoundingClientRect();

			var left = rect.right + 10;
			var top = rect.top;

			// Adjust if tooltip goes off screen
			if (left + tipRect.width > window.innerWidth) {
				left = rect.left - tipRect.width - 10;
			}
			if (top + tipRect.height > window.innerHeight) {
				top = window.innerHeight - tipRect.height - 10;
			}

			tip.style.left = left + 'px';
			tip.style.top = top + 'px';
		}

		// Hide tooltip
		function hideTooltip() {
			if (tooltip) {
				tooltip.classList.remove('visible');
			}
		}

		// Setup tooltip listeners for recipe cards
		function setupTooltips() {
			var cards = document.getElementsByClassName('recipe-card');
			for (var i = 0; i < cards.length; i++) {
				cards\[i\].addEventListener('mouseenter', function(e) {
					showTooltip(e, this);
				});

				cards\[i\].addEventListener('mouseleave', hideTooltip);

				cards\[i\].addEventListener('mousemove', function(e) {
					if (tooltip && tooltip.classList.contains('visible')) {
						var rect = this.getBoundingClientRect();
						var tipRect = tooltip.getBoundingClientRect();

						var left = e.clientX + 10;
						var top = e.clientY - 10;

						if (left + tipRect.width > window.innerWidth) {
							left = e.clientX - tipRect.width - 10;
						}
						if (top + tipRect.height > window.innerHeight) {
							top = e.clientY - tipRect.height - 10;
						}

						tooltip.style.left = left + 'px';
						tooltip.style.top = top + 'px';
					}
				});
			}
		}

		var input = document.getElementById('recipe-search');
		if (input) {
			input.addEventListener('keyup', function() {
				var filter = input.value.toUpperCase();
				var categories = document.getElementsByClassName('recipe-category');
				var hasVisibleItems = false;

				// Search across ALL categories
				for (var i = 0; i < categories.length; i++) {
					var category = categories\[i\];
					var recipes = category.getElementsByClassName('recipe-card');
					var categoryHasVisible = false;

					for (var j = 0; j < recipes.length; j++) {
						var recipeName = recipes\[j\].getElementsByClassName('recipe-card-name')\[0\];
						var recipeId = recipes\[j\].getAttribute('data-recipe-id') || '';
						var tooltipContent = recipes\[j\].getAttribute('data-tooltip') || '';

						if (recipeName) {
							if (
								recipeName.innerHTML.toUpperCase().indexOf(filter) > -1 ||
								recipeId.toUpperCase().indexOf(filter) > -1 ||
								tooltipContent.toUpperCase().indexOf(filter) > -1
							) {
								recipes\[j\].style.display = '';
								categoryHasVisible = true;
								hasVisibleItems = true;
							} else {
								recipes\[j\].style.display = 'none';
							}
						}
					}

					// Show/hide category based on whether it has visible items
					if (filter === '') {
						// No filter - show current tab only
						var isActive = category.style.display !== 'none';
						category.style.display = isActive ? '' : 'none';
					} else {
						// Filter active - show categories with matches
						category.style.display = categoryHasVisible ? '' : 'none';
					}
				}

				// Update tabs to show search is active
				var tabs = document.getElementsByClassName('tab');
				for (var k = 0; k < tabs.length; k++) {
					if (filter === '') {
						// Restore normal tab behavior
						tabs\[k\].style.opacity = '';
					} else {
						// Dim tabs during search
						tabs\[k\].style.opacity = '0.5';
					}
				}
			});
		}

		// Tab switching function
		window.showCategory = function(categoryName) {
			var categories = document.getElementsByClassName('recipe-category');
			var tabs = document.getElementsByClassName('tab');

			var searchInput = document.getElementById('recipe-search');
			if (searchInput) {
				searchInput.value = '';
			}
			hideTooltip();
			for (var i = 0; i < categories.length; i++) {
				categories\[i\].style.display = 'none';
			}

			for (var j = 0; j < tabs.length; j++) {
				tabs\[j\].classList.remove('active');
				tabs\[j\].style.opacity = '';
			}

			var targetCategory = document.getElementById('category-' + categoryName.replace(/\\s+/g, '-'));
			if (targetCategory) {
				targetCategory.style.display = '';
			}
			event.target.classList.add('active');
			if (targetCategory) {
				var recipes = targetCategory.getElementsByClassName('recipe-card');
				for (var k = 0; k < recipes.length; k++) {
					recipes\[k\].style.display = '';
				}
			}

			setTimeout(setupTooltips, 50);
		};

		setTimeout(setupTooltips, 100);
	})();
	</script>
	"}
	dat += "<div class='recipe-grid' id='recipe-grid'>"

	var/first_cat = TRUE
	for(var/category in categories)
		var/category_id = replacetext(category, " ", "-")
		var/display_style = first_cat ? "grid" : "none"
		dat += "<div class='recipe-category' id='category-[category_id]' style='display: [display_style]; grid-column: 1 / -1; display: contents;'>"
		dat += "<div class='category-header' style='grid-column: 1 / -1;'>[category]</div>"

		for(var/recipe_id in categories[category])
			var/datum/blueprint_recipe/recipe = GLOB.blueprint_recipes[recipe_id]

			var/initiate_item = "hand"
			if(recipe.construct_tool)
				initiate_item = "[recipe.construct_tool.name]"

			var/list/materials = list()
			for(var/mat_type in recipe.required_materials)
				var/amount = recipe.required_materials[mat_type]
				var/atom/temp = mat_type
				materials += "[amount]x [initial(temp.name)]"

			var/list/features = list()
			if(recipe.supports_directions)
				features += "Rotatable"
			if(!recipe.edge_density)
				features += "No Edge Density"

			dat += "<div class='recipe-card' data-recipe-id='[recipe_id]' data-recipe-name='[html_encode(recipe.name)]' data-recipe-desc='[html_encode(recipe.desc)]' data-initiate-item='[html_encode(initiate_item)]' data-materials='[html_encode(json_encode(materials))]' data-features='[html_encode(json_encode(features))]' onclick='selectRecipe(\"[recipe_id]\")'>"
			var/atom/result = recipe.result_type
			dat += "<div class='recipe-card-icon'><img src='\ref[initial(result.icon)]?state=[initial(result.icon_state)]&dir=[initial(result.dir)]'/></div>"
			dat += "<div class='recipe-card-name'>[recipe.name]</div>"
			dat += "</div>"

		dat += "</div>"
		first_cat = FALSE

	dat += "</div>"
	dat += "</div>"
	dat += {"
	<script>
		function selectRecipe(recipeId) {
			window.location = 'byond://?src=[REF(src)];blueprint_select_recipe=' + recipeId;
		}
	</script>
	"}

	return dat.Join()

/datum/blueprint_system/Topic(href, href_list)
	if(!holder || !holder.mob || QDELETED(holder.mob))
		return

	if(href_list["blueprint_select_recipe"])
		var/recipe_id = href_list["blueprint_select_recipe"]
		select_recipe(recipe_id)
		return TRUE

	return FALSE

/datum/blueprint_system/proc/select_recipe(recipe_id)
	if(!GLOB.blueprint_recipes[recipe_id])
		return

	selected_recipe = GLOB.blueprint_recipes[recipe_id]
	build_dir = selected_recipe.default_dir
	create_preview_appearance(selected_recipe)
	recipe_button.update_appearance(UPDATE_NAME)
	dir_button.update_appearance()
	to_chat(holder.mob, "<span class='notice'>Selected blueprint: [selected_recipe.name]</span>")
	if(selected_recipe.supports_directions)
		to_chat(holder.mob, "<span class='info'>This blueprint can be rotated using the direction button.</span>")

/datum/blueprint_system/proc/InterceptClickOn(mob/user, list/modifiers, atom/object)
	var/left_click = LAZYACCESS(modifiers, LEFT_CLICK)
	var/right_click = LAZYACCESS(modifiers, RIGHT_CLICK)

	if(selected_recipe)
		if(left_click)
			place_blueprint(get_turf(object), user)
			return TRUE
		if(right_click)
			if(selected_recipe)
				clear_selection()
			return TRUE
	else
		if(right_click)
			if(istype(object, /obj/structure/blueprint))
				var/obj/structure/blueprint/print = object
				if(!print.creator)
					return TRUE
				if(print.creator != user && world.time < print.time_when_placed + 3 MINUTES)
					return TRUE
				to_chat(user, span_red("[object.name] removed."))
				qdel(object)
	return FALSE

// Modified blueprint system proc to handle wall fixture placement
/datum/blueprint_system/proc/place_blueprint(turf/location, mob/user)
	if(!selected_recipe || !location)
		return

	var/turf/final_location = location

	var/atom/selected_output = selected_recipe.result_type

	if(ispath(selected_output, /turf/closed) && (istype(get_area(final_location), /area/overlord_lair) && !("overlord" in user.faction)))
		return

	// Handle wall fixtures - place blueprint on adjacent floor when clicking on wall
	if(selected_recipe.check_adjacent_wall && selected_recipe.place_on_wall && !selected_recipe.floor_object)
		var/turf/wall_turf = location

		// If we clicked on a wall, find the adjacent floor turf
		if(wall_turf.density || istype(wall_turf, /turf/closed))
			// Determine direction from wall to adjacent floor
			var/wall_dir = get_wall_direction(wall_turf, user)
			if(wall_dir)
				var/turf/adjacent_floor = get_step(wall_turf, turn(wall_dir, 180)) // Opposite direction
				if(adjacent_floor && !adjacent_floor.density && istype(adjacent_floor, /turf/open))
					final_location = adjacent_floor
					// Set build direction to face the wall
					build_dir = wall_dir
				else
					to_chat(user, "<span class='warning'>No valid floor space adjacent to wall!</span>")
					return
			else
				to_chat(user, "<span class='warning'>Cannot determine wall orientation!</span>")
				return
		// If we clicked on floor, check if there's an adjacent wall in the build direction
		else if(!wall_turf.density)
			var/turf/target_wall = get_step(wall_turf, build_dir)
			if(!target_wall || (!target_wall.density && !istype(target_wall, /turf/closed)))
				to_chat(user, "<span class='warning'>No adjacent wall found in that direction!</span>")
				return
			// final_location remains the clicked floor turf

	if(!can_place_at(final_location))
		to_chat(user, "<span class='warning'>Cannot place blueprint here!</span>")
		return

	var/obj/structure/blueprint/B = new(final_location)
	B.recipe = selected_recipe
	B.creator = user
	B.blueprint_dir = build_dir
	B.time_when_placed = world.time

	// Calculate wall fixture pixel offsets
	var/final_pixel_x = pixel_x_offset
	var/final_pixel_y = pixel_y_offset

	if(selected_recipe.check_adjacent_wall && selected_recipe.place_on_wall && !selected_recipe.floor_object)
		switch(build_dir)
			if(NORTH)
				final_pixel_y += 32
			if(SOUTH)
				final_pixel_y -= 32
			if(EAST)
				final_pixel_x += 32
			if(WEST)
				final_pixel_x -= 32

	B.stored_pixel_x = final_pixel_x
	B.stored_pixel_y = final_pixel_y
	B.setup_blueprint()

	to_chat(user, span_notice("[B.name] placed."))

/datum/blueprint_system/proc/get_wall_direction(turf/wall_turf, mob/user)
	// Check all cardinal directions for open floor space
	var/list/possible_dirs = list(NORTH, SOUTH, EAST, WEST)
	var/list/valid_dirs = list()

	for(var/dir in possible_dirs)
		var/turf/check_turf = get_step(wall_turf, turn(dir, 180))
		if(check_turf && !check_turf.density && istype(check_turf, /turf/open))
			valid_dirs += dir

	if(!valid_dirs.len)
		return null

	if(valid_dirs.len == 1)
		return valid_dirs[1]

	// Multiple valid directions - prefer the one closest to user's position
	var/best_dir = valid_dirs[1]
	var/best_distance = get_dist(user, get_step(wall_turf, turn(best_dir, 180)))

	for(var/dir in valid_dirs)
		var/turf/floor_turf = get_step(wall_turf, turn(dir, 180))
		var/distance = get_dist(user, floor_turf)
		if(distance < best_distance)
			best_distance = distance
			best_dir = dir

	return best_dir

/datum/blueprint_system/proc/can_place_at(turf/location)
	for(var/obj/structure/blueprint/print in location)
		if(print.recipe.floor_object && selected_recipe.floor_object)
			return FALSE
	if(location.density)
		return FALSE
	return TRUE

/datum/blueprint_system/proc/clear_selection()
	selected_recipe = null
	clear_preview()
	recipe_button.update_appearance(UPDATE_NAME)
	dir_button.update_appearance()
	to_chat(holder.mob, "<span class='notice'>Blueprint selection cleared.</span>")
