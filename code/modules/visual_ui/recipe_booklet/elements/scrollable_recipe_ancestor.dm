/obj/abstract/visual_ui_element/hoverable/scroll_handle/book
	icon = 'icons/visual_ui/booklet.dmi'
	icon_state = "scroll-handle"

/obj/abstract/visual_ui_element/scroll_track/book
	icon = 'icons/visual_ui/booklet.dmi'
	icon_state = "scroll_bar"

/obj/abstract/visual_ui_element/hoverable/recipe_button
	icon = 'icons/visual_ui/booklet.dmi'
	icon_state = "recipe_button"

	layer = VISUAL_UI_BUTTON
	mouse_opacity = 1

	scroll_height = 18
	maptext_width = 130
	maptext_x = 48
	maptext_y = 34
	var/recipe

/obj/abstract/visual_ui_element/hoverable/recipe_button/Click(location, control, params)
	var/datum/visual_ui/ancestor = parent.get_ancestor()
	var/obj/abstract/visual_ui_element/scrollable/recipe_group/grouping = locate(/obj/abstract/visual_ui_element/scrollable/recipe_group) in ancestor.elements
	grouping?.set_selection(src)

/obj/abstract/visual_ui_element/scrollable/recipe_group
	icon = 'icons/visual_ui/booklet.dmi'
	icon_state = "scroll_area"
	scroll_handle = /obj/abstract/visual_ui_element/hoverable/scroll_handle/book
	scroll_track = /obj/abstract/visual_ui_element/scroll_track/book

	const_offset = 0
	scroll_step = 8

	visible_width = 94
	visible_height = 133

	var/obj/abstract/visual_ui_element/hoverable/recipe_button/selected_button

	var/current_key = "survival"
	var/selected_tab
	var/static/list/id_keys = list(
		"survival" = list(
			"fishing" = list(
				/datum/repeatable_crafting_recipe/fishing,
			),
			"cooking" = list(
				/datum/repeatable_crafting_recipe/dryleaf,
				/datum/repeatable_crafting_recipe/westleach,
				/datum/repeatable_crafting_recipe/salami,
				/datum/repeatable_crafting_recipe/coppiette,
				/datum/repeatable_crafting_recipe/salo,
				/datum/repeatable_crafting_recipe/saltfish,
				/datum/repeatable_crafting_recipe/raisins,
				/datum/repeatable_crafting_recipe/cooking/soap,
				/datum/repeatable_crafting_recipe/cooking/soap/bath,
			),
			"survival" = list(
				/datum/repeatable_crafting_recipe/survival,
				/datum/repeatable_crafting_recipe/sigsweet,
				/datum/repeatable_crafting_recipe/sigdry,
				/datum/repeatable_crafting_recipe/parchment,
				/datum/repeatable_crafting_recipe/crafting,
			)
		)
	)

/obj/abstract/visual_ui_element/scrollable/recipe_group/New(turf/loc, datum/visual_ui/P)
	. = ..()
	create_top_tabs(current_key)
	create_recipe_group(current_key)


/obj/abstract/visual_ui_element/scrollable/recipe_group/proc/create_top_tabs(id_key)
	var/list/recipes = id_keys[id_key]
	var/key_length = length(recipes)

	for(var/i = 1 to key_length)
		var/obj/abstract/visual_ui_element/hoverable/tab_selection/tab
		switch(i)//this is pure lazyness simply trannslate the x/y and use a random icon TRAIT_BASHDOORS
			if(1)
				tab = new /obj/abstract/visual_ui_element/hoverable/tab_selection(null, parent)
			if(2)
				tab = new /obj/abstract/visual_ui_element/hoverable/tab_selection/two(null, parent)
			if(3)
				tab = new /obj/abstract/visual_ui_element/hoverable/tab_selection/three(null, parent)
			else
				tab = new /obj/abstract/visual_ui_element/hoverable/tab_selection/four(null, parent)
		tab.tab_key = recipes[i]
		tab.update_ui_screen_loc()
		parent.elements += tab

/obj/abstract/visual_ui_element/scrollable/recipe_group/proc/create_recipe_group(id_key, after_add)
	var/list/recipe_list = id_keys[id_key]
	if(!selected_tab)
		selected_tab = recipe_list[1]
	var/list/true_recipes = recipe_list[selected_tab]
	var/length = 1
	for(var/datum/repeatable_crafting_recipe/recipe as anything in true_recipes)
		if(IS_ABSTRACT(recipe))
			for(var/atom/sub_path as anything in subtypesof(recipe))
				var/obj/abstract/visual_ui_element/hoverable/recipe_button/button = new /obj/abstract/visual_ui_element/hoverable/recipe_button(null, parent)
				button.name = initial(sub_path.name)
				button.offset_x = offset_x
				button.offset_y = offset_y + (18 * (length-1))
				button.update_ui_screen_loc()
				parent.elements += button
				if(after_add)
					var/mob/current = parent.get_user()
					current.client.screen |= button

				button.maptext = MAPTEXT_PIXELIFY("<span class='center' style='color:[hover_color]'>[initial(sub_path.name)]</span>")
				button.recipe = sub_path
				register_element(button)
				length++
		else
			var/obj/abstract/visual_ui_element/hoverable/recipe_button/button = new /obj/abstract/visual_ui_element/hoverable/recipe_button(null, parent)
			button.name = initial(recipe.name)
			button.offset_x = offset_x
			button.offset_y = offset_y + (18 * (length-1))
			button.update_ui_screen_loc()
			parent.elements += button
			if(after_add)
				var/mob/current = parent.get_user()
				current.client.screen |= button

			button.maptext = MAPTEXT_PIXELIFY("<span class='center' style='color:[hover_color]'>[initial(recipe.name)]</span>")
			button.recipe = recipe
			register_element(button)
			length++

/obj/abstract/visual_ui_element/scrollable/recipe_group/proc/tab_selection_click(id_key)
	if(id_key == selected_tab)
		return
	selected_tab = id_key

	for(var/obj/abstract/visual_ui_element/element as anything in container_elements)
		element.scrollable_parent = null
		container_elements -= element
		parent.elements -= element
		var/mob/current = parent.get_user()
		current.client.screen -= element
		qdel(element)

	scroll_position = 0
	unset_button()
	clear_selected_recipe()
	update_element_positions()
	update_scroll_handle()

	create_recipe_group(current_key, TRUE)

/obj/abstract/visual_ui_element/scrollable/recipe_group/proc/set_selection(obj/abstract/visual_ui_element/hoverable/recipe_button/recipe)
	if(selected_button == recipe)
		return

	if(selected_button)
		unset_button()

	selected_button = recipe
	selected_button.base_icon_state = "recipe_button-selected"
	selected_button.icon_state = "recipe_button-selected"

	set_selected_recipe()

/obj/abstract/visual_ui_element/scrollable/recipe_group/proc/unset_button()
	selected_button.base_icon_state = initial(selected_button.icon_state)
	selected_button.icon_state = initial(selected_button.icon_state)
	selected_button = null

/obj/abstract/visual_ui_element/scrollable/recipe_group/proc/set_selected_recipe()
	var/datum/visual_ui/ancestor = parent.get_ancestor()
	var/obj/abstract/visual_ui_element/scrollable/selected_recipe/grouping = locate(/obj/abstract/visual_ui_element/scrollable/selected_recipe) in ancestor.elements
	var/obj/abstract/visual_ui_element/current_recipe/header = locate(/obj/abstract/visual_ui_element/current_recipe) in ancestor.elements

	header.maptext = MAPTEXT_PIXELIFY("<span class='center' style='color:[hover_color]'>[selected_button.name]</span>")
	grouping.recipe_selection = selected_button.recipe
	grouping.build_recipe()

/obj/abstract/visual_ui_element/scrollable/recipe_group/proc/clear_selected_recipe()
	var/datum/visual_ui/ancestor = parent.get_ancestor()
	var/obj/abstract/visual_ui_element/scrollable/selected_recipe/grouping = locate(/obj/abstract/visual_ui_element/scrollable/selected_recipe) in ancestor.elements
	var/obj/abstract/visual_ui_element/current_recipe/header = locate(/obj/abstract/visual_ui_element/current_recipe) in ancestor.elements

	header.maptext = null
	grouping.recipe_selection = null
	grouping.build_recipe()
