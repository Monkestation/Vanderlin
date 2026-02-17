/obj/machinery/essence/infuser
	name = "essence infuser"
	desc = "A complex device that infuses items with essences according to specific recipes."
	icon_state = "splitter"
	icon = 'icons/roguetown/misc/splitter.dmi'
	density = TRUE
	anchored = TRUE
	var/datum/essence_storage/storage
	var/datum/essence_infusion_recipe/current_recipe = null
	var/obj/item/infusion_target = null
	var/working = FALSE
	var/progress = 0
	var/completion_time = 100

	processing_priority = 1

/obj/machinery/essence/infuser/Initialize()
	. = ..()
	storage = new /datum/essence_storage(src)
	storage.max_total_capacity = 500
	storage.max_essence_types = 10

/obj/machinery/essence/infuser/Destroy()
	if(storage)
		qdel(storage)
	if(infusion_target)
		infusion_target.forceMove(get_turf(src))
	current_recipe = null
	infusion_target = null
	return ..()

/obj/machinery/essence/infuser/is_essence_allowed(essence_type)
	if(!current_recipe)
		return FALSE
	return (essence_type in current_recipe.required_essences)

/obj/machinery/essence/infuser/can_target_accept_essence(target, essence_type)
	return is_essence_allowed(essence_type)

/obj/machinery/essence/infuser/update_overlays()
	. = ..()

	if(infusion_target)
		var/mutable_appearance/MA = mutable_appearance(icon, "infuser_item")
		. += MA

	if(working)
		var/mutable_appearance/work = mutable_appearance(icon, "infuser_working")
		. += work

	var/essence_percent = (storage.get_total_stored()) / (storage.max_total_capacity)
	if(!essence_percent)
		return
	var/level = clamp(CEILING(essence_percent * 5, 1), 1, 5)

	. += mutable_appearance(icon, "liquid_[level]", color = calculate_mixture_color())
	. += emissive_appearance(icon, "liquid_[level]", alpha = src.alpha)

/obj/machinery/essence/infuser/return_storage()
	return storage

/obj/machinery/essence/infuser/process()
	if(!working || !current_recipe)
		return

	progress += 1.5 * GLOB.thaumic_research.get_research_bonus(/datum/thaumic_research_node/transmutation)
	if(progress >= completion_time)
		complete_infusion()
		return

	if(prob(25))
		var/datum/effect_system/spark_spread/sparks = new
		sparks.set_up(2, 1, src)
		sparks.start()

/obj/machinery/essence/infuser/proc/can_accept_essence(essence_type)
	if(!current_recipe)
		return FALSE

	if(!(essence_type in current_recipe.required_essences))
		return FALSE

	var/amount_needed = current_recipe.required_essences[essence_type]
	var/amount_stored = storage.get_essence_amount(essence_type)

	if(amount_stored >= amount_needed)
		return FALSE

	if(storage.get_available_space() <= 0)
		return FALSE

	return TRUE

/obj/machinery/essence/infuser/proc/check_recipe_completion()
	if(!current_recipe || !infusion_target)
		return FALSE

	for(var/essence_type in current_recipe.required_essences)
		var/amount_needed = current_recipe.required_essences[essence_type]
		var/amount_stored = storage.get_essence_amount(essence_type)
		if(amount_stored < amount_needed)
			return FALSE
	return TRUE

/obj/machinery/essence/infuser/proc/complete_infusion()
	working = FALSE

	// Consume essences
	for(var/essence_type in current_recipe.required_essences)
		var/amount = current_recipe.required_essences[essence_type]
		storage.remove_essence(essence_type, amount)

	// Create result
	new current_recipe.result_type(get_turf(src))
	qdel(infusion_target)
	infusion_target = null
	current_recipe = null
	progress = 0
	update_appearance(UPDATE_OVERLAYS)
	visible_message(span_notice("The [src] dings as it completes its work!"))

/obj/machinery/essence/infuser/proc/calculate_mixture_color()
	var/list/essence_contents = list()
	essence_contents |= storage.stored_essences

	if(!length(essence_contents))
		return "#4A90E2"

	var/total_weight = 0
	var/r = 0, g = 0, b = 0

	for(var/essence_type in essence_contents)
		var/datum/thaumaturgical_essence/essence = new essence_type
		var/amount = essence_contents[essence_type]
		var/weight = amount * (essence.tier + 1)

		total_weight += weight
		var/color_val = hex2num(copytext(essence.color, 2, 4))
		r += color_val * weight
		color_val = hex2num(copytext(essence.color, 4, 6))
		g += color_val * weight
		color_val = hex2num(copytext(essence.color, 6, 8))
		b += color_val * weight

		qdel(essence)

	if(total_weight == 0)
		return "#4A90E2"

	r = FLOOR(r / total_weight, 1)
	g = FLOOR(g / total_weight, 1)
	b = FLOOR(b / total_weight, 1)

	return rgb(r, g, b)

/obj/machinery/essence/infuser/attackby(obj/item/I, mob/user, list/modifiers)
	if(working)
		to_chat(user, span_warning("The infuser is currently working!"))
		return

	if(istype(I, /obj/item/essence_vial))
		var/obj/item/essence_vial/vial = I
		if(!vial.contained_essence || vial.essence_amount <= 0)
			to_chat(user, span_warning("The vial is empty!"))
			return

		var/essence_type = vial.contained_essence.type

		if(!can_accept_essence(essence_type))
			to_chat(user, span_warning("This essence is not needed for the current recipe!"))
			return

		var/amount_needed = current_recipe.required_essences[essence_type]
		var/amount_stored = storage.get_essence_amount(essence_type)
		var/amount_to_transfer = min(vial.essence_amount, amount_needed - amount_stored)

		if(storage.add_essence(essence_type, amount_to_transfer))
			to_chat(user, span_notice("You pour [amount_to_transfer] units of [vial.contained_essence.name] into the infuser."))
			vial.essence_amount -= amount_to_transfer
			if(vial.essence_amount <= 0)
				vial.contained_essence = null
			vial.update_appearance(UPDATE_OVERLAYS)
			update_appearance(UPDATE_OVERLAYS)
			return TRUE

	// Handle target item insertion
	if(!infusion_target)
		for(var/recipe_type in subtypesof(/datum/essence_infusion_recipe))
			var/datum/essence_infusion_recipe/recipe = new recipe_type
			if(istype(I, recipe.target_type))
				infusion_target = I
				current_recipe = recipe
				user.transferItemToLoc(I, src)
				to_chat(user, span_notice("You place [I] into the infuser. It requires:"))
				for(var/essence_type in recipe.required_essences)
					var/datum/thaumaturgical_essence/essence = new essence_type
					to_chat(user, span_notice("- [recipe.required_essences[essence_type]] units of [essence.name]"))
					qdel(essence)
				update_appearance(UPDATE_OVERLAYS)
				return TRUE
			qdel(recipe)

	return ..()

/obj/machinery/essence/infuser/attack_hand(mob/living/user)
	. = ..()

	if(working)
		to_chat(user, span_warning("The infuser is currently working!"))
		return

	if(!infusion_target)
		to_chat(user, span_warning("There is no item in the infuser!"))
		return

	if(!current_recipe)
		to_chat(user, span_warning("No valid recipe found for this item!"))
		eject_target()
		return

	if(!check_recipe_completion())
		to_chat(user, span_warning("Missing required essences for the recipe!"))
		return

	working = TRUE
	progress = 0
	START_PROCESSING(SSobj, src)
	update_appearance(UPDATE_OVERLAYS)
	to_chat(user, span_notice("You start the infusion process..."))

/obj/machinery/essence/infuser/proc/eject_target()
	if(!infusion_target)
		return
	infusion_target.forceMove(get_turf(src))
	infusion_target = null
	current_recipe = null
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/infuser/examine(mob/user)
	. = ..()
	. += span_notice("Essence Storage: [storage.get_total_stored()]/[storage.max_total_capacity]")

	if(infusion_target && current_recipe)
		. += span_notice("Contains: [infusion_target]")
		. += span_notice("Recipe requirements:")
		for(var/essence_type in current_recipe.required_essences)
			var/amount_needed = current_recipe.required_essences[essence_type]
			var/amount_stored = storage.get_essence_amount(essence_type)
			var/datum/thaumaturgical_essence/essence = new essence_type
			. += span_notice("- [essence.name]: [amount_stored]/[amount_needed]")
			qdel(essence)
	else
		. += span_notice("No recipe selected. Insert a valid item to begin.")

	if(working)
		. += span_notice("Currently working: [round((progress / completion_time) * 100)]% complete")
