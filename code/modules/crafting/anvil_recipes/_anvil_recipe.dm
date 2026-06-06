/datum/anvil_recipe
	abstract_type = /datum/anvil_recipe
	var/name
	/// Category of crafted item. Will determine how it shows up in menus.
	var/category = "Misc"
	/// Quality of the bar(s) used. Accumulated per added ingot.
	var/material_quality = 0
	/// Total number of materials (with quality) used. Quality divided among them.
	var/num_of_materials = 1
	/// The skill that will be taken into account when crafting.
	var/appro_skill = /datum/attribute/skill/craft/blacksmithing
	/// The typepath of the material we need to start the recipe.
	var/obj/item/required_material
	/// The item created when the recipe is fulfilled. SHOULD BE A TYPEPATH
	var/atom/created_item
	/// How much of the item does this recipe create?
	var/output_amount = 1
	/// Difficulty of craft. Affects difficulty of minigame and amount of minigames.
	var/craftdiff = 0
	/// List of the object(s) we need to complete this recipe.
	var/list/additional_items
	/// What item we need to add to proceed to the next step. Draws from the list on var/additional_items.
	var/obj/item/needed_item
	/// 0 to 100%, percentage of completion on this step of crafting (or overall if no extra items required)
	var/progress = 0
	/// Based on the performance of each minigame attempt.
	var/accumulated_quality = 0
	/// Based on skill level of everyone who worked on this recipe.
	var/skill_quality
	/// Increased each time the minigame is played. Used to average accumulated_quality and skill_quality.
	var/numberofhits = 0
	/// The item that the recipe currently applies to
	var/datum/parent
	var/rotations_required = 1
	/// Set to FALSE if needs to be learned first
	var/always_available = TRUE

/datum/anvil_recipe/New(datum/P, ...)
	parent = P
	if(parent)
		process_parent(parent)
	. = ..()

/datum/anvil_recipe/Destroy(force, ...)
	LAZYNULL(additional_items)
	parent = null
	required_material = null
	created_item = null
	return ..()

/datum/anvil_recipe/proc/process_parent(parent)
	if(isitem(parent))
		material_quality += parent:recipe_quality

/datum/anvil_recipe/proc/can_advance(mob/user)
	if(progress == 100)
		to_chat(user, span_info("It's ready."))
		return FALSE

	if(needed_item)
		to_chat(user, span_notice("Now it's time to add \a [needed_item.name]."))
		return FALSE

	return TRUE

// Keep this simple, we can do the math and randomization in quality_manager
/datum/anvil_recipe/proc/advance(mob/user, quality_score = 0)
	if(!can_advance(user))
		return FALSE

	numberofhits++
	accumulated_quality += quality_score
	var/skill_level_to_add = GET_MOB_SKILL_VALUE_OLD(user, appro_skill)
	skill_quality += skill_level_to_add

	var/progress_to_add = 100
	switch(craftdiff)
		if(0)
			progress_to_add /= 2
		if(1)
			progress_to_add /= 2
		if(2)
			progress_to_add /= 3
		if(3)
			progress_to_add /= 3
		if(4)
			progress_to_add /= 4
		if(5)
			progress_to_add /= 4
		if(6)
			progress_to_add /= 5
	// Progress scales based on additional_items to prevent multi-item recipes from taking too long
	progress_to_add *= LAZYLEN(additional_items)+1
	if(quality_score < MINIMUM_ANVIL_MINIGAME_SCORE) // Did you even try?
		progress /= 2
	progress += progress_to_add

	if(progress >= 100)
		if(length(additional_items))
			needed_item = pick_n_take(additional_items)
			to_chat(user, span_notice("Now it's time to add \a [needed_item.name]."))
			progress = 0
		else
			to_chat(user, span_info("It's ready."))

	return TRUE

/datum/anvil_recipe/proc/item_added(obj/item/added_item, mob/user)
	if(!needed_item)
		return FALSE
	if(!istype(added_item, needed_item))
		return FALSE
	user.visible_message(span_info("[user] adds \a [added_item.name]."))
	if(istype(added_item, /obj/item/ingot))
		material_quality += added_item.recipe_quality
		num_of_materials++
	qdel(added_item)
	needed_item = null
	return TRUE

/datum/anvil_recipe/proc/handle_creation(atom/output_location, mob/user)
	var/datum/quality_calculator/blacksmithing/quality_calc = new(
		mat_qual = material_quality,
		skill_qual = skill_quality,
		components = num_of_materials,
		perf_qual = accumulated_quality,
		diff_mod = craftdiff,
		mini_play = numberofhits
	)

	for(var/i in 1 to output_amount)
		var/obj/item/output_item = new created_item(output_location)
		handle_output(output_item, quality_calc)
		output_item.OnCrafted(user?.dir, user)

	qdel(quality_calc)

/datum/anvil_recipe/proc/handle_output(obj/item/output_item, datum/quality_calculator/blacksmithing/quality_calculator)
	quality_calculator.apply_quality_to_item(output_item, TRUE)
	output_item.add_quench_requirement("recipe_creation", 60 SECONDS)

/datum/anvil_recipe/proc/is_recipe_available(mob/user)
	if(has_world_trait(/datum/world_trait/delver))
		if(!has_recipe_unlocked(user.key, type))
			return FALSE

	if(!always_available && !(type in user?.mind?.learned_recipes))
		return FALSE

	return TRUE
