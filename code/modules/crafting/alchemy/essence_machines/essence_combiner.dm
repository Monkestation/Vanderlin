#define COMBINER_MODE_GENERIC 1
#define COMBINER_MODE_MANUAL  2
#define COMBINER_MODE_AUTO    3

/obj/machinery/essence/combiner
	name = "essence combiner"
	desc = "Fuses multiple alchemical essences into a unified compound."
	icon = 'icons/roguetown/misc/splitter.dmi'
	icon_state = "splitter"
	network_priority = 4

	/// Separate output storage so combined product doesn't mix with raw input
	var/datum/essence_storage/output_storage
	var/combining = FALSE
	var/max_concurrent_recipes = 3

	/// Current operating mode: COMBINER_MODE_GENERIC, COMBINER_MODE_MANUAL, or COMBINER_MODE_AUTO
	var/mode = COMBINER_MODE_GENERIC
	/// Locked recipe path when in manual mode
	var/datum/essence_combination/manual_recipe_path = null

/obj/machinery/essence/combiner/Initialize()
	. = ..()
	storage.max_total = 500
	storage.max_types = 10
	output_storage = new /datum/essence_storage(src)
	output_storage.max_total = 500
	output_storage.max_types = 10
	START_PROCESSING(SSobj, src)

/obj/machinery/essence/combiner/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(output_storage)
		qdel(output_storage)
	return ..()

/obj/machinery/essence/combiner/push_to_linked(datum/essence_storage/from_storage)
	// Input storage: only push surplus (anything no recipe can use)
	if(from_storage == storage)
		push_surplus_to_linked(from_storage)
		return
	// Output storage: push everything, it's all product meant to leave
	..()

/obj/machinery/essence/combiner/build_allowed_types()
	var/room = storage.space()
	if(room <= 0)
		return list()

	switch(mode)
		if(COMBINER_MODE_MANUAL)
			if(!manual_recipe_path)
				return list()
			var/list/result = list()
			var/datum/essence_combination/recipe = new manual_recipe_path
			for(var/etype in recipe.inputs)
				result[etype] = room
			qdel(recipe)
			return result

		if(COMBINER_MODE_AUTO)
			var/list/demand = build_network_demand()
			var/datum/essence_combination/best = null
			var/best_score = 0
			for(var/rpath in subtypesof(/datum/essence_combination))
				var/datum/essence_combination/recipe = new rpath
				var/score = demand[recipe.output_type] || 0
				if(score > best_score)
					if(best)
						qdel(best)
					best = recipe
					best_score = score
				else
					qdel(recipe)
			if(!best)
				return list()
			var/list/result = list()
			for(var/etype in best.inputs)
				// Only request exactly what one batch needs, minus what we already have
				var/need = best.inputs[etype] - storage.get(etype)
				if(need > 0)
					result[etype] = need
			qdel(best)
			return result

		else
			var/list/result = list()
			for(var/rpath in subtypesof(/datum/essence_combination))
				var/datum/essence_combination/recipe = new rpath
				for(var/etype in recipe.inputs)
					if(!(etype in result))
						result[etype] = room
				qdel(recipe)
			return result

/obj/machinery/essence/combiner/process()
	// Pull raw essences from inbound links into input storage
	pull_from_linked(storage)
	// Push combined output through outbound links
	push_to_linked(output_storage)

/obj/machinery/essence/combiner/on_storage_changed(essence_type, amount, added)
	. = ..()
	if(!added || combining)
		return
	if(mode == COMBINER_MODE_MANUAL || mode == COMBINER_MODE_AUTO)
		attempt_combination_auto()

/obj/machinery/essence/combiner/proc/attempt_combination_auto()
	if(!storage.contents.len)
		return

	var/list/queued = list()
	var/list/available = storage.snapshot()
	var/efficiency = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/combiner_output)

	while(queued.len < max_concurrent_recipes)
		var/datum/essence_combination/recipe = find_matching_combination(available)
		if(!recipe)
			break
		// No skill check, machine operates autonomously
		for(var/etype in recipe.inputs)
			available[etype] -= recipe.inputs[etype]
			if(available[etype] <= 0)
				available -= etype
		queued += recipe

	if(!queued.len)
		return

	var/total_out = 0
	for(var/datum/essence_combination/r in queued)
		total_out += round(r.output_amount * efficiency, 1)

	if(output_storage.space() < total_out)
		for(var/datum/essence_combination/r in queued)
			qdel(r)
		return

	begin_bulk_combination(null, queued)

/obj/machinery/essence/combiner/attack_hand(mob/living/user)
	if(combining)
		to_chat(user, span_warning("A combination is already in progress."))
		return
	attempt_combination(user)

/obj/machinery/essence/combiner/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	show_mode_menu(user)

/obj/machinery/essence/combiner/proc/show_mode_menu(mob/user)
	var/list/choices = list(
		"Generic (try any recipe)" = COMBINER_MODE_GENERIC,
		"Manual (locked recipe)"   = COMBINER_MODE_MANUAL,
		"Automatic (network demand)" = COMBINER_MODE_AUTO
	)
	var/choice = input(user, "Select combiner mode", "Combiner Mode") as null|anything in choices
	if(!choice || !Adjacent(user))
		return

	var/new_mode = choices[choice]
	if(new_mode == COMBINER_MODE_MANUAL)
		var/list/recipe_options = list()
		for(var/rpath in subtypesof(/datum/essence_combination))
			var/datum/essence_combination/recipe = new rpath
			recipe_options[initial(recipe.name)] = rpath
			qdel(recipe)
		var/recipe_choice = input(user, "Select a recipe to lock to", "Manual Recipe") as null|anything in recipe_options
		if(!recipe_choice || !Adjacent(user))
			return
		manual_recipe_path = recipe_options[recipe_choice]
		mode = COMBINER_MODE_MANUAL
		to_chat(user, span_info("Combiner locked to: [recipe_choice]"))
	else
		manual_recipe_path = null
		mode = new_mode
		switch(mode)
			if(COMBINER_MODE_GENERIC)
				to_chat(user, span_info("Combiner set to generic mode."))
			if(COMBINER_MODE_AUTO)
				to_chat(user, span_info("Combiner set to automatic network demand mode."))

	if(network)
		network.invalidate_cache()

/obj/machinery/essence/combiner/examine(mob/user)
	. = ..()
	switch(mode)
		if(COMBINER_MODE_GENERIC)
			. += span_notice("Mode: Generic, will attempt any matching recipe.")
		if(COMBINER_MODE_MANUAL)
			if(manual_recipe_path)
				var/datum/essence_combination/recipe = new manual_recipe_path
				. += span_notice("Mode: Manual: locked to [initial(recipe.name)].")
				qdel(recipe)
			else
				. += span_warning("Mode: Manual: no recipe selected.")
		if(COMBINER_MODE_AUTO)
			. += span_notice("Mode: Automatic: prioritises recipes matching network demand.")

/obj/machinery/essence/combiner/proc/attempt_combination(mob/living/user)
	if(!storage.contents.len)
		to_chat(user, span_warning("No essences loaded."))
		return

	var/list/queued = list()
	var/list/available = storage.snapshot()
	var/efficiency = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/combiner_output)

	var/batch_limit = (mode == COMBINER_MODE_AUTO) ? 1 : max_concurrent_recipes

	while(queued.len < batch_limit)
		var/datum/essence_combination/recipe = find_matching_combination(available)
		if(!recipe)
			break
		if(GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/alchemy) < recipe.skill_required)
			qdel(recipe)
			break
		for(var/etype in recipe.inputs)
			available[etype] -= recipe.inputs[etype]
			if(available[etype] <= 0)
				available -= etype
		queued += recipe

	if(!queued.len)
		to_chat(user, span_warning("No valid combinations can be made with current essences."))
		return

	var/total_out = 0
	for(var/datum/essence_combination/r in queued)
		total_out += round(r.output_amount * efficiency, 1)

	if(output_storage.space() < total_out)
		to_chat(user, span_warning("Not enough output space for [queued.len] recipe(s)."))
		for(var/datum/essence_combination/r in queued)
			qdel(r)
		return

	begin_bulk_combination(user, queued)

/obj/machinery/essence/combiner/proc/begin_bulk_combination(mob/living/user, list/recipes)
	combining = TRUE
	if(user)
		user.visible_message(span_info("[user] activates [src] for bulk processing ([recipes.len] recipe(s))."))
	else
		visible_message(span_info("[src] begins automated combination ([recipes.len] recipe(s))."))
	update_appearance(UPDATE_OVERLAYS)
	var/speed = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/combiner_speed)
	var/time = (5 SECONDS + (recipes.len * 2 SECONDS)) / speed
	addtimer(CALLBACK(src, PROC_REF(finish_bulk_combination), user, recipes), time)

/obj/machinery/essence/combiner/proc/finish_bulk_combination(mob/living/user, list/recipes)
	var/list/report = list()
	var/efficiency = GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/combiner_output)
	for(var/datum/essence_combination/recipe in recipes)
		for(var/etype in recipe.inputs)
			storage.remove(etype, recipe.inputs[etype])
		var/out_amount = round(recipe.output_amount * efficiency, 1)
		output_storage.add(recipe.output_type, out_amount)
		var/datum/thaumaturgical_essence/e = new recipe.output_type
		report["[e.name]"] = (report["[e.name]"] || 0) + out_amount
		qdel(e)
		qdel(recipe)
	combining = FALSE

	if(network)
		network.invalidate_cache()

	update_appearance(UPDATE_OVERLAYS)
	var/list/parts = list()
	for(var/label in report)
		parts += "[label] ([report[label]] units)"
	visible_message(span_info("[src] finishes: [jointext(parts, ", ")]."))
	if(user)
		var/boon = user.get_learning_boon(/datum/attribute/skill/craft/alchemy)
		var/xp = GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * recipes.len
		user.adjust_experience(/datum/attribute/skill/craft/alchemy, xp * boon, FALSE)
	if(mode == COMBINER_MODE_MANUAL || mode == COMBINER_MODE_AUTO)
		attempt_combination_auto()

/**
 * Finds the best matching recipe given [available] essence snapshot.
 * In auto mode, scores recipes by how much their output is demanded
 * by downstream machines on the network, preferring the most-wanted first.
 * In manual mode, only considers the locked recipe.
 * In generic mode, returns the first matching recipe as before.
 */
/obj/machinery/essence/combiner/proc/find_matching_combination(list/available)
	switch(mode)
		if(COMBINER_MODE_MANUAL)
			if(!manual_recipe_path)
				return null
			var/datum/essence_combination/recipe = new manual_recipe_path
			var/ok = TRUE
			for(var/etype in recipe.inputs)
				if((available[etype] || 0) < recipe.inputs[etype])
					ok = FALSE
					break
			if(ok)
				return recipe
			qdel(recipe)
			return null

		if(COMBINER_MODE_AUTO)
			// Build a demand map from the network: output_type -> total units wanted
			var/list/demand = build_network_demand()
			var/datum/essence_combination/best_recipe = null
			var/best_score = 0
			for(var/rpath in subtypesof(/datum/essence_combination))
				var/datum/essence_combination/recipe = new rpath
				var/ok = TRUE
				for(var/etype in recipe.inputs)
					if((available[etype] || 0) < recipe.inputs[etype])
						ok = FALSE
						break
				if(!ok)
					qdel(recipe)
					continue
				var/score = demand[recipe.output_type] || 0
				if(score > best_score)
					if(best_recipe)
						qdel(best_recipe)
					best_recipe = recipe
					best_score = score
				else
					qdel(recipe)
			return best_recipe // null if nothing matched

		else
			for(var/rpath in subtypesof(/datum/essence_combination))
				var/datum/essence_combination/recipe = new rpath
				var/ok = TRUE
				for(var/etype in recipe.inputs)
					if((available[etype] || 0) < recipe.inputs[etype])
						ok = FALSE
						break
				if(ok)
					return recipe
				qdel(recipe)
			return null

/**
 * Surveys every machine on the network (except ourselves) and sums up
 * how many units of each essence type they currently want.
 * Returns assoc list: [essence_type] = total_units_wanted
 */
/obj/machinery/essence/combiner/proc/build_network_demand()
	if(!network)
		return list()
	return network.get_demand(list(/obj/machinery/essence/reservoir, type))

/obj/machinery/essence/combiner/get_mechanics_examine(mob/user)
	. = ..()
	. += span_notice("=== Output ===")
	if(output_storage.contents.len)
		for(var/etype in output_storage.contents)
			var/datum/thaumaturgical_essence/e = new etype
			var/label = HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST) \
				? e.name : "essence smelling of [e.smells_like]"
			. += span_notice("  - [label]: [output_storage.contents[etype]] units")
			qdel(e)
	else
		. += span_notice("  (empty)")
	if(combining)
		. += span_warning("Combination in progress…")

#undef COMBINER_MODE_GENERIC
#undef COMBINER_MODE_MANUAL
#undef COMBINER_MODE_AUTO
