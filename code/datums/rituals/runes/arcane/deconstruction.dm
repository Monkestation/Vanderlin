/obj/effect/decal/cleanable/ritual_rune/arcyne/decrafting
	name = "arcyne decrafting matrix"
	desc = "A jagged, fractured sigil that seems to want to take things apart..."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "imbuement" // reuse the same base sprite; tint differentiates it
	tier = 2
	runesize = 2
	SET_BASE_PIXEL(-64, -64)
	pixel_z = 0
	invocation = "Keth'daal un'shar veth!"
	can_be_scribed = TRUE
	color = "#BE2F7B" // magenta-pink to distinguish from the purple crafter

	/// The single staged item, null when empty
	var/obj/item/staged_item = null
	/// The matched recipe datum (either arcyne or repeatable), null if none found
	var/datum/decraft_match/matched = null
	/// TRUE while the break-apart animation is playing; blocks all interaction
	var/animating = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/decrafting/attack_hand(mob/living/user)
	if(animating)
		to_chat(user, span_notice("The rune is already working..."))
		return

	if(!user.get_active_held_item())
		if(staged_item)
			if(matched)
				try_invoke(user)
			else
				to_chat(user, span_hierophant_warning("The rune does not know how to unmake what has been placed here."))
		else
			return ..()
		return

/obj/effect/decal/cleanable/ritual_rune/arcyne/decrafting/attackby(obj/item/W, mob/user, list/modifiers)
	if(animating)
		to_chat(user, span_notice("The rune is already working..."))
		return
	if(!try_stage_item(user, W))
		return ..()

/// Accepts exactly one item. Replaces any previously staged item (returning it
/// to the ground) so the player can swap without having to erase and re-draw.
/obj/effect/decal/cleanable/ritual_rune/arcyne/decrafting/proc/try_stage_item(mob/living/user, obj/item/item)
	if(staged_item == item)
		to_chat(user, span_notice("That's already placed on the rune."))
		return TRUE // handled, don't fall through

	// Eject whatever was there before
	if(staged_item && !QDELETED(staged_item))
		staged_item.anchored = FALSE
		animate(staged_item, pixel_x = 0, pixel_y = 0, time = 0.3 SECONDS, flags = ANIMATION_END_NOW)

	user.temporarilyRemoveItemFromInventory(item)
	item.forceMove(get_turf(src))
	item.anchored = TRUE
	animate(item, pixel_x = 0, pixel_y = 0, time = 0.7 SECONDS, flags = ANIMATION_END_NOW)

	staged_item = item
	matched = find_matching_recipe(item)

	if(matched)
		to_chat(user, span_hierophant_warning("The rune trembles with unmaking. Invoke it when ready."))
	else
		to_chat(user, span_warning("The rune does not recognise this item it cannot be unravelled here."))

	playsound(src, 'sound/magic/glass.ogg', 60, TRUE)
	return TRUE

/*
 * /datum/decraft_match
 * Lightweight holder so we don't keep the full recipe datum alive between
 * staging and invocation, and so we have a unified interface regardless of
 * where the recipe came from.
 *
 * ingredient_types – list of typepaths to spawn (repeatable)
 * OR an assoc list of type = count (arcyne)
 * required_skill – minimum arcane skill level needed
 * recipe_name – human-readable name for messages
 */
/datum/decraft_match
	var/recipe_name = "unknown recipe"
	var/list/ingredients = list() // flat list of typepaths to spawn
	var/required_skill = SKILL_LEVEL_NONE

/datum/decraft_match/New(name, list/ingredient_list, skill)
	recipe_name = name
	ingredients = ingredient_list
	required_skill = skill

/obj/effect/decal/cleanable/ritual_rune/arcyne/decrafting/proc/find_matching_recipe(obj/item/item)
	for(var/recipe_type as anything in subtypesof(/datum/arcyne_crafting_recipe))
		var/datum/arcyne_crafting_recipe/R = new recipe_type
		if(!ispath(R.output) || !istype(item, R.output))
			qdel(R)
			continue
		// Build a flat ingredient list respecting counts
		var/list/flat = list()
		for(var/ing_type in R.ingredients)
			flat += ing_type // arcyne ingredients list is already a flat list of types
		var/datum/decraft_match/M = new(recipe_type, flat, R.required_skill)
		qdel(R)
		return M

	for(var/recipe_type as anything in subtypesof(/datum/repeatable_crafting_recipe))
		var/datum/repeatable_crafting_recipe/R = new recipe_type
		if(!ispath(R.output) || !istype(item, R.output))
			qdel(R)
			continue
		var/list/flat = list()
		// requirements is an assoc list of type = count
		for(var/req_type in R.requirements)
			var/count = R.requirements[req_type]
			for(var/i = 1, i <= count, i++)
				flat += req_type
		var/datum/decraft_match/M = new(recipe_type, flat, initial(R.minimum_skill_level))
		qdel(R)
		return M

	return null

/obj/effect/decal/cleanable/ritual_rune/arcyne/decrafting/proc/try_invoke(mob/living/user)
	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane) <= SKILL_LEVEL_NONE)
		to_chat(user, span_warning("You aren't able to invoke these symbols."))
		return
	if(rune_in_use)
		to_chat(user, span_notice("The rune is already active."))
		return
	rune_in_use = TRUE
	animating = TRUE

	var/skill_level = GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane)
	if(skill_level < matched.required_skill)
		to_chat(user, span_hierophant_warning("My arcyne is not refined enough to perform this unmaking..."))
		abort_ritual()
		return

	if(!isnull(user.mana_pool) && user.mana_pool.amount > 20)
		var/drain = min(user.mana_pool.amount, 20)
		user.mana_pool.adjust_mana(-drain)
	else
		to_chat(user, span_notice("You lack the mana to activate this."))
		return

	user.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
	playsound(src, 'sound/magic/cosmic_expansion.ogg', 60, TRUE)
	SpinAnimation(
		speed = 1.5 SECONDS,
		loops = 1,
		clockwise = FALSE, // spins counter-clockwise to feel like "undoing"
		segments = 6,
		parallel = TRUE
	)

	INVOKE_ASYNC(src, PROC_REF(run_decraft_animation), user)

/obj/effect/decal/cleanable/ritual_rune/arcyne/decrafting/proc/run_decraft_animation(mob/living/user)
	var/turf/center = get_turf(src)

	animate(staged_item, pixel_x = 6, time = 0.15 SECONDS, flags = ANIMATION_END_NOW)
	sleep(0.15 SECONDS)
	animate(staged_item, pixel_x = -6, time = 0.15 SECONDS, flags = ANIMATION_END_NOW)
	sleep(0.15 SECONDS)
	animate(staged_item, pixel_x = 4, time = 0.1 SECONDS, flags = ANIMATION_END_NOW)
	sleep(0.1 SECONDS)
	animate(staged_item, pixel_x = 0, time = 0.1 SECONDS, flags = ANIMATION_END_NOW)
	sleep(0.1 SECONDS)

	animate(staged_item,
		alpha = 0,
		transform = matrix() * 1.6,
		time = 0.8 SECONDS,
		flags = ANIMATION_END_NOW
	)
	sleep(0.8 SECONDS)

	qdel(staged_item)
	staged_item = null

	sleep(0.15 SECONDS)

	var/list/ingredient_types = matched.ingredients
	var/count = length(ingredient_types)
	var/list/offsets = get_spawn_offsets(count)

	var/list/spawned = list()
	for(var/i = 1, i <= count, i++)
		var/ing_type = ingredient_types[i]
		var/obj/item/ing = new ing_type(center)
		ing.alpha = 0
		ing.transform = matrix() * 0.1
		ing.pixel_x = 0
		ing.pixel_y = 0
		spawned += ing

	sleep(0.1 SECONDS)

	for(var/i = 1, i <= length(spawned), i++)
		var/obj/item/ing = spawned[i]
		animate(ing,
			alpha = 255,
			transform = matrix(),
			pixel_x = offsets[i][1],
			pixel_y = offsets[i][2],
			time = 1.0 SECONDS,
			flags = ANIMATION_END_NOW
		)

	sleep(1.0 SECONDS)

	// Let them drop naturally (unanchor so they sit on the tile)
	for(var/obj/item/ing in spawned)
		animate(ing, pixel_x = 0, pixel_y = 0, time = 0.4 SECONDS, flags = ANIMATION_END_NOW)

	sleep(0.4 SECONDS)

	playsound(src, 'sound/magic/blink.ogg', 80, TRUE)

	matched = null
	animating = FALSE
	rune_in_use = FALSE
	do_invoke_glow()

/// Returns a list of [x, y] pixel offset pairs for N spawned ingredients,
/// arranged in a ring so they fan outward from the rune centre.
/obj/effect/decal/cleanable/ritual_rune/arcyne/decrafting/proc/get_spawn_offsets(count)
	if(count <= 0)
		return list()
	var/list/offsets = list()
	var/radius = clamp(count * 10, 36, 64)
	for(var/i = 0, i < count, i++)
		var/angle = (360 / count) * i - 90
		offsets += list(list(round(radius * cos(angle)), round(radius * sin(angle))))
	return offsets

/// Releases the staged item and resets all state without decrafting anything.
/obj/effect/decal/cleanable/ritual_rune/arcyne/decrafting/proc/abort_ritual()
	if(staged_item && !QDELETED(staged_item))
		staged_item.anchored = FALSE
		animate(staged_item, pixel_x = 0, pixel_y = 0, time = 0.5 SECONDS, flags = ANIMATION_END_NOW)
	staged_item = null
	matched = null
	animating = FALSE
	rune_in_use = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/decrafting/Destroy()
	abort_ritual()
	return ..()
