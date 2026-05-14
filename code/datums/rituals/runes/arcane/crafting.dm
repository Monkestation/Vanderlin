/obj/effect/decal/cleanable/ritual_rune/arcyne/crafting
	name = "arcyne crafting matrix"
	desc = "A large, intricate sigil that seems to hunger for materials..."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "imbuement"
	tier = 2
	runesize = 2
	SET_BASE_PIXEL(-64, -64)
	pixel_z = 0
	invocation = "Veth'kael un'dorath shar!"
	can_be_scribed = TRUE
	color = "#7B2FBE"

	/// Ordered list of /datum/crafting_slot each holds position + placed item ref
	var/list/datum/crafting_slot/slots = list()
	/// The matched recipe for the current staging, null if no match yet
	var/datum/arcyne_crafting_recipe/matched_recipe = null
	/// TRUE while the animation is playing; blocks all interaction
	var/animating = FALSE

/// Returns a list of [x, y] pixel offset pairs for N ingredients.
/obj/effect/decal/cleanable/ritual_rune/arcyne/crafting/proc/get_slot_layout(count)
	switch(count)
		if(1)
			return list(list(0, 0))
		if(2)
			return list(list(-44, 0), list(44, 0))
		if(3)
			return list(list(0, 48), list(-44, -28), list(44, -28))
		if(4)
			return list(list(-44, 44), list(44, 44), list(-44, -44), list(44, -44))
		if(5)
			return list(list(0, 56), list(27, 18), list(34, -48), list(-34, -48), list(-27, 18))
		if(6)
			return list(list(0, 56), list(48, 28), list(48, -28), list(0, -56), list(-48, -28), list(-48, 28))
	//evenly space around a circle at radius 48px if we are above 6 items
	var/list/offsets = list()
	for(var/i = 0, i < count, i++)
		var/angle = (360 / count) * i - 90
		offsets += list(list(round(48 * cos(angle)), round(48 * sin(angle))))
	return offsets

/obj/effect/decal/cleanable/ritual_rune/arcyne/crafting/attack_hand(mob/living/user)
	if(animating)
		to_chat(user, span_notice("The rune is already working..."))
		return

	//try to invoke if a recipe is matched, or eject if staged.
	if(!user.get_active_held_item())
		if(matched_recipe)
			try_invoke(user)
		else if(length(slots))
			to_chat(user, span_hierophant_warning("No recipe matches what's been placed here."))
		else
			. = ..()
		return

/obj/effect/decal/cleanable/ritual_rune/arcyne/crafting/attackby(obj/item/W, mob/user, list/modifiers)
	if(animating)
		to_chat(user, span_notice("The rune is already working..."))
		return
	// try to stage it.
	if(!try_place_item(user, W))
		return ..()

/// Attempts to place the held item into the next open slot.
/obj/effect/decal/cleanable/ritual_rune/arcyne/crafting/proc/try_place_item(mob/living/user, obj/item/item)
	// Check if the item is already staged on this rune.
	for(var/datum/crafting_slot/S in slots)
		if(S.item == item)
			to_chat(user, span_notice("That's already placed on the rune."))
			return

	// Find the maximum ingredient count across all recipes to cap slot count.
	var/static/max_slots = 0
	if(!max_slots)
		for(var/datum/arcyne_crafting_recipe/recipe_type as anything in subtypesof(/datum/arcyne_crafting_recipe))
			var/datum/arcyne_crafting_recipe/R = new recipe_type
			max_slots = max(max_slots, length(R.ingredients))
			qdel(R)

	if(length(slots) >= max_slots)
		to_chat(user, span_hierophant_warning("The rune can't hold any more ingredients."))
		return

	// Drop the item from the user's hand onto the rune's turf, then stage it.
	user.temporarilyRemoveItemFromInventory(item)
	item.forceMove(get_turf(src))

	var/datum/crafting_slot/slot = new()
	slot.item = item
	slots += slot

	// Assign pixel offsets once we know how many slots we'll need.
	// We re-layout all existing slots each time so they stay symmetric.
	relayout_slots()

	for(var/datum/crafting_slot/S in slots)
		if(S.item)
			S.item.anchored = TRUE
			slide_item_to_slot(S.item, S)

	to_chat(user, span_cultsmall("The item settles into place on the rune..."))
	playsound(src, 'sound/magic/glass.ogg', 60, TRUE)

	// Check if the current staged items match any recipe.
	matched_recipe = find_matching_recipe()
	if(matched_recipe)
		to_chat(user, span_hierophant_warning("The rune hums with readiness. Invoke it when ready."))
	return TRUE

/// Recalculates pixel positions for all staged slots based on current count.
/obj/effect/decal/cleanable/ritual_rune/arcyne/crafting/proc/relayout_slots()
	var/list/offsets = get_slot_layout(length(slots))
	for(var/i = 1, i <= length(slots), i++)
		var/datum/crafting_slot/S = slots[i]
		S.px = offsets[i][1]
		S.py = offsets[i][2]

/// Animates a single item sliding from its current pixel position to its slot.
/obj/effect/decal/cleanable/ritual_rune/arcyne/crafting/proc/slide_item_to_slot(obj/item/item, datum/crafting_slot/slot)
	animate(item, pixel_x = slot.px, pixel_y = slot.py, time = 0.7 SECONDS, flags = ANIMATION_END_NOW)

/// Scans all recipe subtypes and returns the first whose ingredients are fully satisfied.
/obj/effect/decal/cleanable/ritual_rune/arcyne/crafting/proc/find_matching_recipe()
	var/list/staged_types = list()
	for(var/datum/crafting_slot/S in slots)
		staged_types += S.item.type

	for(var/recipe_type as anything in subtypesof(/datum/arcyne_crafting_recipe))
		var/datum/arcyne_crafting_recipe/R = new recipe_type
		var/list/needed = R.ingredients.Copy()
		if(length(needed) != length(slots))
			continue
		// Try to match each staged item against the needed list.
		var/list/remaining = needed.Copy()
		var/matched = TRUE
		for(var/datum/crafting_slot/S in slots)
			var/found = FALSE
			for(var/req_type in remaining)
				if(istype(S.item, req_type))
					remaining.Remove(req_type)
					found = TRUE
					break
			if(!found)
				matched = FALSE
				break
		if(matched && !length(remaining))
			return new recipe_type()
		qdel(R)
	return null

/obj/effect/decal/cleanable/ritual_rune/arcyne/crafting/proc/try_invoke(mob/living/user)
	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane) <= SKILL_LEVEL_NONE)
		to_chat(user, span_warning("You aren't able to invoke these symbols."))
		return
	if(rune_in_use)
		to_chat(user, span_notice("The rune is already active."))
		return
	rune_in_use = TRUE
	animating = TRUE

	// Check skill gate.
	var/skill_level = GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane)
	if(skill_level < matched_recipe.required_skill)
		to_chat(user, span_hierophant_warning("My arcyne is not refined enough to complete this working..."))
		abort_ritual()
		return

	user.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
	playsound(src, 'sound/magic/cosmic_expansion.ogg', 60, TRUE)
	SpinAnimation(
		speed = 1.5 SECONDS,
		loops = 1,
		clockwise = TRUE,
		segments = 6, // smoother than default 3
		parallel = TRUE
	)

	INVOKE_ASYNC(src, PROC_REF(run_craft_animation), user)

/obj/effect/decal/cleanable/ritual_rune/arcyne/crafting/proc/run_craft_animation(mob/living/user)
	var/turf/center = get_turf(src)

	//slide all items to center and fade them out.
	for(var/datum/crafting_slot/S in slots)
		animate(S.item,
			pixel_x = 0, pixel_y = 0,
			alpha = 0,
			transform = matrix() * 0.2,
			time = 1.5 SECONDS,
			flags = ANIMATION_END_NOW
		)
	sleep(1.5 SECONDS)

	//delete ingredients.
	for(var/datum/crafting_slot/S in slots)
		qdel(S.item)
	slots.Cut()

	sleep(0.2 SECONDS)

	//spawn output invisible and floating, then fade it in.
	var/obj/item/result = new matched_recipe.output(center)
	result.alpha = 0
	var/saved_transform = result.transform
	result.transform = matrix() * 0.1
	animate(result,
		alpha = 255,
		transform = saved_transform,
		pixel_y = 8,
		time = 1.2 SECONDS,
		flags = ANIMATION_END_NOW
	)
	sleep(1.2 SECONDS)
	animate(result, pixel_y = 0, time = 0.3 SECONDS, flags = ANIMATION_END_NOW)
	sleep(0.3 SECONDS)

	playsound(src, 'sound/magic/blink.ogg', 80, TRUE)

	matched_recipe = null
	animating = FALSE
	rune_in_use = FALSE
	do_invoke_glow()

/// Releases all staged items and resets state without crafting anything.
/obj/effect/decal/cleanable/ritual_rune/arcyne/crafting/proc/abort_ritual()
	for(var/datum/crafting_slot/S in slots)
		if(S.item && !QDELETED(S.item))
			S.item.anchored = FALSE
			animate(S.item, pixel_x = 0, pixel_y = 0, time = 0.5 SECONDS, flags = ANIMATION_END_NOW)
	slots.Cut()
	matched_recipe = null
	animating = FALSE
	rune_in_use = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/crafting/Destroy()
	abort_ritual()
	return ..()

///this is really just an ease thing can be removed if we really care
/datum/crafting_slot
	/// The item currently occupying this slot
	var/obj/item/item = null
	/// Pixel X offset from the rune's tile center
	var/px = 0
	/// Pixel Y offset from the rune's tile center
	var/py = 0
