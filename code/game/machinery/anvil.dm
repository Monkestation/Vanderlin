/obj/machinery/anvil
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "anvil"
	icon_state = "anvil"
	max_integrity = 2000
	density = TRUE
	damage_deflection = 25
	climbable = TRUE
	var/smithing = FALSE // Is a minigame currently active?
	var/obj/item/working_material // Reference to the material being worked
	var/always_perfect = FALSE // Debug/admin flag

/obj/machinery/anvil/Destroy()
	if(working_material)
		working_material.forceMove(drop_location())
	. = ..()

/obj/machinery/anvil/crafted
	icon_state = "caveanvil"

/obj/machinery/anvil/examine(mob/user)
	. = ..()
	if(working_material)
		. += span_info("[src] has \a [working_material.name] on it.")
		if(working_material.currecipe)
			. += span_warning("It is currently being worked on to become \a [working_material.currecipe.name].")
		if(HAS_TRAIT(working_material, TRAIT_NEEDS_QUENCH))
			. += span_warning("[working_material] is too hot to touch.")

/obj/machinery/anvil/attack_hand_secondary(mob/user, list/modifiers)
	if(working_material && !smithing)
		return working_material.attack_hand_secondary(user, modifiers)
	return ..()

/obj/machinery/anvil/attackby(obj/item/attacking_item, mob/living/user, list/modifiers)
	if(smithing)
		to_chat(user, span_warning("[src] is currently being worked on!"))
		return TRUE

	// TODO: REWRITE TONGS INTERACTIONS USING interact_with_atom()
	var/actual_attacking_item = attacking_item
	var/obj/item/weapon/tongs/tongs_used
	if(istype(attacking_item, /obj/item/weapon/tongs))
		tongs_used = attacking_item
		if(tongs_used.held_item)
			actual_attacking_item = tongs_used.held_item

	if(try_place_item(actual_attacking_item, user))
		return TRUE

	if(working_material)
		if(istype(attacking_item, /obj/item/weapon/hammer))
			. = TRUE
			user.changeNext_move(CLICK_CD_MELEE)
			if(!HAS_TRAIT(working_material, TRAIT_NEEDS_QUENCH))
				if(working_material.currecipe)
					to_chat(user, span_warning("[working_material] has gone too cold to continue working on it."))
					return
				else
					return working_material.attackby(attacking_item, user, modifiers)

			if(!working_material.currecipe)
				if(!choose_recipe(user))
					return working_material.attackby(attacking_item, user, modifiers)
			if(!working_material.currecipe.is_recipe_available(user))
				return
			// Start the minigame instead of direct hammering
			start_minigame(user, attacking_item)
			return

		if(try_restore_material(actual_attacking_item, user))
			return TRUE

		if(tongs_used && !tongs_used.held_item)
			tongs_used.set_held_item(working_material)
			return TRUE

	. = ..()

/obj/machinery/anvil/attack_hand(mob/living/user, list/modifiers)
	if(smithing)
		to_chat(user, span_warning("[src] is currently being worked on!"))
		return TRUE
	if(working_material)
		return working_material.attack_hand(user, modifiers)
	return ..()

/obj/machinery/anvil/proc/try_place_item(obj/item/item, mob/living/user)
	if(working_material?.currecipe?.item_added(item, user))
		return TRUE

	if(!working_material)
		if(HAS_TRAIT(item, TRAIT_NEEDS_QUENCH) || item.melting_material || item.anvilrepair)
			set_working_material(item)
			return TRUE

	return FALSE

/obj/machinery/anvil/proc/try_restore_material(obj/item/item, mob/living/user)
	if(!istype(item, /obj/item/ingot))
		return FALSE
	if(!working_material || !working_material.anvilrepair || !working_material.uses_integrity)
		return FALSE

	if(working_material.max_integrity >= initial(working_material.max_integrity))
		to_chat(user, span_warning("[working_material] does not need to be restored."))
		return FALSE

	var/skill_value = GET_MOB_SKILL_VALUE(user, working_material.anvilrepair)
	if(skill_value <= 0)
		to_chat(user, span_warning("You don't know enough about this craft to restore [working_material]."))
		return FALSE

	var/expected_ingot_type
	if(working_material.melting_material)
		var/datum/material/mat = GET_ATTRIBUTE_DATUM(working_material.melting_material)
		expected_ingot_type = mat?.solid_form
	else if(working_material.smeltresult)
		if(istype(working_material.smeltresult, /obj/item/ingot))
			expected_ingot_type = working_material.smeltresult
	if(!expected_ingot_type || !istype(item, expected_ingot_type))
		to_chat(user, span_warning("This isn't the right material to restore [working_material]."))
		return FALSE

	if(!HAS_TRAIT(working_material, TRAIT_NEEDS_QUENCH))
		to_chat(item, span_warning("[working_material] needs to be heated first to be mended!"))
		return FALSE
	if(!HAS_TRAIT(item, TRAIT_NEEDS_QUENCH))
		to_chat(item, span_warning("[item] needs to be heated first to be used as mending material!"))
		return FALSE

	var/restores_done = working_material.integrity_restores
	var/base_restore = (skill_value / SKILL_MASTER) * 0.20
	var/diminish_factor = max(0.1, 1.0 - (restores_done * 0.30))
	var/restore_amount = round(working_material.max_integrity * base_restore * diminish_factor)

	if(restore_amount <= 0)
		to_chat(user, span_warning("[working_material] has been restored too many times. It no longer accepts new material."))
		return FALSE

	var/new_max_integrity = min(working_material.max_integrity + restore_amount, initial(working_material.max_integrity))

	working_material.modify_max_integrity(new_max_integrity, FALSE)
	working_material.integrity_restores++

	qdel(item)

	var/datum/mind/smith_mind = user.mind
	var/amt2raise = max(GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE), 1) * 0.25
	smith_mind.add_sleep_experience(working_material.anvilrepair, amt2raise)

	playsound(src, 'sound/items/bsmith3.ogg', 100, FALSE)
	user.visible_message(span_info("[user] works new material into [working_material], restoring its maximum integrity."))

	return TRUE

/obj/machinery/anvil/proc/start_minigame(mob/living/user, obj/item/weapon/hammer/hammer)
	if(!working_material || !working_material.currecipe)
		return

	if(!working_material.currecipe.can_advance(user))
		shake_camera(user, 1, 1)
		playsound(src, 'sound/items/bsmithfail.ogg', 100, FALSE)
		return

	smithing = TRUE

	var/datum/anvil_challenge/challenge = new(src, working_material.currecipe, user)
	if(!challenge)
		smithing = FALSE
		return

/obj/machinery/anvil/proc/process_minigame_result(quality_score, mob/living/user)
	if(!working_material || !working_material.currecipe)
		return

	var/datum/anvil_recipe/recipe = working_material.currecipe

	if(quality_score >= MINIMUM_ANVIL_MINIGAME_SCORE) // Did you even try?
		var/recipe_skill = recipe.appro_skill
		var/amt2raise = max(GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE), 1) * 1.5 // It would be impossible to level up otherwise
		amt2raise *= user.get_learning_boon(recipe_skill)
		if(HAS_TRAIT(user, TRAIT_MALUMFIRE) || GET_MOB_SKILL_VALUE_OLD(user, recipe_skill) < 3)// Sanity, no expert blacksmith has lower skill than 3, for if admins manually add the trait or blacksmith vampire thralls
			user.mind.add_sleep_experience(recipe_skill, amt2raise, FALSE)

		// Breakthrough system for RNG success
		var/obj/item/weapon/hammer/hammer = user.get_active_held_item()
		var/total_chance = GET_MOB_SKILL_VALUE_OLD(user, recipe_skill) * GET_MOB_ATTRIBUTE_VALUE(user, STAT_PERCEPTION)/10
		if(istype(hammer))
			total_chance += (1 / hammer.toolspeed)
		if(prob((1 + total_chance)))
			user.flash_fullscreen("whiteflash")
			quality_score = 100

	var/success = recipe.advance(user, quality_score)
	if(!success)
		return

	if(quality_score >= 80)
		user.visible_message(span_greentext("[user] deftly strikes the bar!"))
	else if(quality_score >= 40)
		user.visible_message(span_info("[user] strikes the bar!"))
	else
		user.visible_message(span_warning("[user] fumbles the bar!"))

	var/datum/effect_system/spark_spread/sparks = new()
	var/turf/front = get_turf(src)
	sparks.set_up(1, 1, front)
	sparks.start()
	user.adjust_stamina(user.maximum_stamina / 4)

	if(recipe.progress >= 100 && !length(recipe.additional_items) && !recipe.needed_item)
		complete_recipe(user, quality_score)

/obj/machinery/anvil/proc/complete_recipe(mob/living/user, quality_score)
	if(!working_material || !working_material.currecipe)
		return

	var/datum/anvil_recipe/recipe = working_material.currecipe
	var/obj/item/output_item_path = recipe.created_item

	SEND_SIGNAL(user, COMSIG_ITEM_FORGED, recipe.created_item)
	record_featured_stat(FEATURED_STATS_SMITHS, user)
	record_featured_object_stat(FEATURED_STATS_FORGED_ITEMS, initial(output_item_path.name))

	recipe.handle_creation(loc, user)

	user?.visible_message(span_info("[user] finishes crafting \the [initial(output_item_path.name)]!"))
	qdel(working_material)

/obj/machinery/anvil/proc/choose_recipe(mob/living/user)
	if(!working_material || !HAS_TRAIT(working_material, TRAIT_NEEDS_QUENCH) || working_material.currecipe)
		return

	var/list/valid_types = list()
	for(var/datum/anvil_recipe/recipe_instance as anything in GLOB.anvil_recipes)
		var/datum/recipe_type = recipe_instance.type // necessary typecasting of type for macro
		if(IS_ABSTRACT(recipe_type))
			continue
		if(!recipe_instance.is_recipe_available(user))
			continue
		if(!istype(working_material, recipe_instance.required_material))
			continue

		var/recipe_category = recipe_instance.category
		if(!valid_types[recipe_category])
			valid_types[recipe_category] = list()
		valid_types[recipe_category] += recipe_instance

	if(!length(valid_types))
		return

	var/category_choice
	if(length(valid_types) == 1)
		category_choice = valid_types[1]
	else
		category_choice = browser_input_list(user, "Choose a category", "Anvil", valid_types)
	if(!category_choice)
		return

	var/list/chosen_category = valid_types[category_choice]
	if(!length(chosen_category))
		return

	var/list/final_recipe_list = list()
	for(var/datum/anvil_recipe/recipe_instance as anything in chosen_category)
		var/modified_name = "[recipe_instance.name]"
		if(recipe_instance.output_amount > 1)
			modified_name += " ([recipe_instance.output_amount]x)"
		final_recipe_list["[modified_name] \[[uppertext(SSskills.level_names_plain[recipe_instance.craftdiff])]\]"] = recipe_instance

	var/datum/chosen_recipe = browser_input_list(user, "Choose what to start working on:", "Anvil", sortList(final_recipe_list))

	chosen_recipe = final_recipe_list[chosen_recipe]
	if(!working_material.currecipe && chosen_recipe)
		working_material.currecipe = new chosen_recipe.type(working_material)
		return TRUE

/obj/machinery/anvil/proc/set_working_material(obj/item/new_material)
	if(!QDELETED(working_material))
		UnregisterSignal(working_material, list(\
			SIGNAL_ADDTRAIT(TRAIT_NEEDS_QUENCH), SIGNAL_REMOVETRAIT(TRAIT_NEEDS_QUENCH), \
			COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	working_material = new_material
	if(working_material)
		working_material.forceMove(src)
		RegisterSignals(working_material, list(SIGNAL_ADDTRAIT(TRAIT_NEEDS_QUENCH), SIGNAL_REMOVETRAIT(TRAIT_NEEDS_QUENCH)), PROC_REF(update_overlay_upon_signal))
		RegisterSignals(working_material, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED), PROC_REF(unset_material_on_signal))
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/anvil/proc/update_overlay_upon_signal(datum/source, trait)
	SIGNAL_HANDLER
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/anvil/proc/unset_material_on_signal(datum/source, trait)
	SIGNAL_HANDLER
	set_working_material(null)

/obj/machinery/anvil/update_overlays()
	. = ..()
	if(working_material)
		var/mutable_appearance/M = new /mutable_appearance(working_material)
		M.transform *= 0.5
		M.pixel_y = 4
		M.pixel_x = 3
		. += M
