
/obj/structure/blueprint
	name = "construction blueprint"
	desc = "A holographic blueprint for construction."
	icon = 'icons/effects/alphacolors.dmi'
	icon_state = "white"
	alpha = 0 // Keep parent invisible
	invisibility = 100 /// on_hover still triggers on no alpha objects
	anchored = TRUE
	density = FALSE
	UUID_saving = TRUE

	var/datum/blueprint_recipe/recipe
	var/tmp/mob/creator
	var/construction_progress = 0
	var/max_construction_progress = 100
	var/tmp/list/viewing_images = list() // Track images by client
	var/blueprint_dir = SOUTH // Direction this blueprint will be built in

	var/tmp/image/cached_image
	var/stored_pixel_y = 0
	var/stored_pixel_x = 0

	var/tmp/time_when_placed

/obj/structure/blueprint/Initialize(mapload)
	. = ..()
	GLOB.active_blueprints += src
	SSblueprints.add_new_blueprint(src)

/obj/structure/blueprint/after_load()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(setup_blueprint), 1 SECONDS))

/obj/structure/blueprint/Destroy()
	GLOB.active_blueprints -= src
	SSblueprints.remove_blueprint(src)
	clear_all_viewers()
	return ..()

/obj/structure/blueprint/after_load()
	GLOB.active_blueprints |= src
	SSblueprints.add_new_blueprint(src)

/obj/structure/blueprint/attackby(obj/item/I, mob/user, list/modifiers)
	if(!istype(I, recipe.construct_tool))
		return
	try_construct(user, I)

/obj/structure/blueprint/attack_hand(mob/user)
	if(recipe.construct_tool)
		return
	try_construct(user)
/obj/structure/blueprint/proc/setup_blueprint()
	if(!recipe)
		return

	name = "[recipe.name] blueprint"
	if(recipe.supports_directions)
		name += " ([dir2text(blueprint_dir)])"
	var/list/desc_lines = list()
	desc_lines += "[recipe.desc]"
	desc_lines += ""

	if(recipe.construct_tool)
		var/obj/item/tool = new recipe.construct_tool
		desc_lines += span_notice("Required tool: [initial(tool.name)]")
		qdel(tool)

	if(length(recipe.required_materials))
		desc_lines += span_notice("Required materials:")
		for(var/atom/material_path as anything in recipe.required_materials)
			var/count = recipe.required_materials[material_path]
			desc_lines += "- [count] [initial(material_path.name)]"

	if(recipe.skillcraft)
		var/datum/skill/recipe_skill = recipe.skillcraft
		var/difficulty_text = ""
		if(recipe.craftdiff > 0)
			difficulty_text = " (Difficulty: [recipe.craftdiff])"
		desc_lines += span_notice("Required skill: [initial(recipe_skill.name)][difficulty_text]")

	desc_lines += span_notice("Construction time: [recipe.build_time * 0.1] seconds")

	if(recipe.supports_directions)
		desc_lines += "Can be rotated during construction"
	if(recipe.floor_object)
		desc_lines += "Covers entire floor tile"

	desc = desc_lines.Join("\n")


	var/atom/result = recipe.result_type
	icon = initial(result.icon)
	icon_state = initial(result.icon_state)
	smoothing_icon = initial(result.icon_state)
	smoothing_flags = initial(result.smoothing_flags)
	smoothing_groups = initial(result.smoothing_groups)
	smoothing_list = initial(result.smoothing_list)

	if(smoothing_flags & SMOOTH_EDGE)
		smoothing_flags &= ~SMOOTH_EDGE

	if(smoothing_flags)
		SETUP_SMOOTHING()
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)
	dir = recipe.supports_directions ? blueprint_dir : initial(result.dir)

	// Update all existing images when appearance changes
	update_all_images(FALSE)

/obj/structure/blueprint/proc/add_viewer(mob/living/viewer)
	if(!viewer.client || viewing_images[viewer.client])
		return
	if(recipe) // this helps me visualize it give me a break
		if(recipe?.requires_learning && !(recipe?.type in viewer.mind?.learned_recipes))
			return

	var/image/blueprint_image = create_blueprint_image()
	viewing_images[viewer.client] = blueprint_image
	viewer.client.images += blueprint_image

/obj/structure/blueprint/proc/remove_viewer(mob/living/viewer)
	if(!viewer.client || !viewing_images[viewer.client])
		return

	var/image/blueprint_image = viewing_images[viewer.client]
	viewer.client.images -= blueprint_image
	viewing_images -= viewer.client

/obj/structure/blueprint/proc/clear_all_viewers()
	for(var/client/C in viewing_images)
		var/image/blueprint_image = viewing_images[C]
		C.images -= blueprint_image
	viewing_images.Cut()

/obj/structure/blueprint/proc/create_blueprint_image(use_cache = TRUE)
	if(use_cache && cached_image)
		return cached_image
	var/image/blueprint_image = image(icon, src, icon_state, layer, dir)
	blueprint_image.appearance = appearance
	blueprint_image.invisibility = 0

	blueprint_image.color = "#00FFFF"
	blueprint_image.alpha = 190 // Set desired alpha on the image
	blueprint_image.pixel_x = stored_pixel_x
	blueprint_image.pixel_y = stored_pixel_y
	blueprint_image.override = TRUE
	blueprint_image.appearance_flags = RESET_ALPHA | KEEP_APART
	cached_image = blueprint_image
	return blueprint_image

/obj/structure/blueprint/proc/update_all_images(use_cache = TRUE)
	for(var/client/C in viewing_images)
		var/image/old_image = viewing_images[C]
		C.images -= old_image

		var/image/new_image = create_blueprint_image(use_cache)
		viewing_images[C] = new_image
		C.images += new_image

/obj/structure/blueprint/set_smoothed_icon_state()
	. = ..()
	update_all_images(FALSE)

/obj/structure/blueprint/smooth_icon()
	. = ..()
	update_all_images(FALSE)

/obj/structure/blueprint/update_appearance(updates)
	. = ..()
	update_all_images(FALSE)

/obj/structure/blueprint/proc/try_construct(mob/user, obj/item/weapon/hammer/hammer)
	if(!recipe)
		qdel(src)
		return FALSE

	if(!recipe.check_craft_requirements(user, get_turf(src), src))
		return FALSE

	var/list/available_materials = get_materials_in_range(user)
	var/list/needed_materials = recipe.required_materials.Copy()

	for(var/mat_type in needed_materials)
		var/needed_amount = needed_materials[mat_type]
		var/available_amount = available_materials[mat_type] || 0
		if(available_amount < needed_amount)
			var/atom/temp = mat_type
			to_chat(user, span_warning("Need [needed_amount - available_amount] more [initial(temp.name)]!</span>"))
			return FALSE

	user.face_atom(src)
	to_chat(user, span_notice("You begin constructing \the [recipe.name]..."))

	for(var/i = 1 to 100)
		var/time_to_do = recipe.build_time
		if(HAS_TRAIT(user, TRAIT_QUICK_HANDS))
			time_to_do *= 0.9
		if(!do_after(user, time_to_do, target = src))
			return FALSE

		if(!recipe.check_craft_requirements(user, get_turf(src), src))
			return FALSE

		available_materials = get_materials_in_range(user)
		for(var/mat_type in needed_materials)
			var/needed_amount = needed_materials[mat_type]
			var/available_amount = available_materials[mat_type] || 0
			if(available_amount < needed_amount)
				var/atom/temp = mat_type
				to_chat(user, "<span class='warning'>Missing [needed_amount - available_amount] [initial(temp.name)]!</span>")
				return FALSE

		var/prob2craft = 25
		var/prob2fail = 1

		if(recipe.craftdiff)
			prob2craft -= (25 * recipe.craftdiff)

		if(recipe.skillcraft)
			if(user.mind)
				prob2craft += (user.get_skill_level(recipe.skillcraft) * 25)
		else
			prob2craft = 100

		if(isliving(user))
			var/mob/living/L = user
			if(L.STALUC > 10)
				prob2fail = 0
			if(L.STALUC < 10)
				prob2fail += (10 - L.STALUC)
			if(L.STAINT > 10)
				prob2craft += ((10 - L.STAINT) * -1) * 2

		if(prob2craft < 1)
			to_chat(user, "<span class='danger'>I lack the skills for this...</span>")
			return FALSE
		else
			prob2craft = CLAMP(prob2craft, 5, 99)

			if(prob(prob2fail)) // Critical fail
				to_chat(user, "<span class='danger'>MISTAKE! I've completely fumbled the construction of [recipe.name]!</span>")
				return FALSE

			if(!prob(prob2craft))
				if(user.client?.prefs.showrolls)
					to_chat(user, "<span class='danger'>I've failed to construct \the [recipe.name]. (Success chance: [prob2craft]%)</span>")
				else
					to_chat(user, "<span class='danger'>I've failed to construct \the [recipe.name].</span>")
				continue

		consume_materials(user, needed_materials)

		var/final_dir = recipe.supports_directions ? blueprint_dir : user.dir
		if(!ispath(recipe.result_type, /turf))
			var/atom/new_structure = new recipe.result_type(get_turf(src))
			if(recipe.supports_directions)
				new_structure.dir = blueprint_dir
			new_structure.pixel_x = stored_pixel_x + new_structure.base_pixel_x
			new_structure.pixel_y = stored_pixel_y + new_structure.base_pixel_y
			if(!initial(recipe.edge_density) && ((abs(pixel_x) >= 14) || (abs(pixel_y) >= 14)))
				new_structure.density = FALSE
			new_structure.OnCrafted(final_dir, user)
		else
			var/turf/turf = get_turf(src)
			var/turf/new_turf = turf.ChangeTurf(recipe.result_type)
			if(new_turf)
				new_turf.OnCrafted(final_dir, user)

		user.visible_message(span_smallnotice("[user] [recipe.verbage_tp] \the [recipe.name]!"), \
							span_notice("I [recipe.verbage] \the [recipe.name]!"))

		if(recipe.craftsound)
			playsound(src, recipe.craftsound, 100, TRUE)

		if(user.mind && recipe.skillcraft)
			if(isliving(user))
				var/mob/living/L = user
				var/amt2raise = L.STAINT * 2
				if(recipe.craftdiff > 0)
					amt2raise += (recipe.craftdiff * 10)
				if(amt2raise > 0)
					user.mind.add_sleep_experience(recipe.skillcraft, amt2raise, FALSE)

		qdel(src)
		return TRUE

	to_chat(user, "<span class='danger'>After many attempts, I cannot manage to construct \the [recipe.name].</span>")
	return FALSE

/obj/structure/blueprint/proc/get_materials_in_range(mob/user, range = 3)
	var/list/materials = list()

	var/list/range_stuff =  range(range, src)
	range_stuff += user.get_active_held_item()
	range_stuff += user.get_inactive_held_item()

	for(var/obj/item/I in range_stuff)
		// Check each material type in the recipe to see if this item matches
		for(var/mat_type in recipe.required_materials)
			if(istype(I, mat_type))
				if(!materials[mat_type])
					materials[mat_type] = 0

				if(istype(I, /obj/item/natural/bundle))
					var/obj/item/natural/bundle/S = I
					materials[mat_type] += S.amount
				else
					materials[mat_type] += 1
				break // Don't double-count items that match multiple types

	for(var/obj/item/natural/bundle/B in range_stuff)
		var/bundle_type = B.stacktype || B.type
		for(var/mat_type in recipe.required_materials)
			if(istype(new bundle_type, mat_type) || bundle_type == mat_type)
				if(!materials[mat_type])
					materials[mat_type] = 0
				materials[mat_type] += B.amount
				break

	return materials

/obj/structure/blueprint/proc/consume_materials(mob/user, list/needed_materials)
	for(var/mat_type in needed_materials)
		var/needed_amount = needed_materials[mat_type]

		var/list/materials = range(3, src)
		materials += user.get_active_held_item()
		materials += user.get_inactive_held_item()

		// First consume from bundles
		for(var/obj/item/natural/bundle/B in materials)
			if(needed_amount <= 0)
				break
			var/bundle_type = B.stacktype || B.type
			if(istype(new bundle_type, mat_type) || bundle_type == mat_type)
				var/consumed = min(needed_amount, B.amount)
				B.amount -= consumed
				if(B.amount <= 0)
					materials -= B
					qdel(B)
				needed_amount -= consumed

		if(needed_amount > 0)
			for(var/obj/item/I in materials)
				if(needed_amount <= 0)
					break
				if(istype(I, mat_type))
					if(istype(I, /obj/item/natural/bundle))
						var/obj/item/natural/bundle/S = I
						var/consumed = min(needed_amount, S.amount)
						S.amount -= consumed
						if(S.amount <= 0)
							materials -= S
							qdel(S)
						needed_amount -= consumed
					else
						materials -= I
						qdel(I)
						needed_amount -= 1
