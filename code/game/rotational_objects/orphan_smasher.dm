#define STEP_FIDDLE "fiddle with the machine"
#define STEP_LEVER "pull the lever"
#define STEP_BUTTON "push a button"

/datum/hover_data/orphan_smasher

/datum/hover_data/orphan_smasher/proc/build_image(atom/source)
	var/obj/structure/orphan_smasher/smasher = source
	if(!smasher.current)
		return null

	var/obj/item/product = smasher.current.created_item
	var/image/hover_image = image(icon = initial(product.icon), icon_state = initial(product.icon_state), loc = source, layer = ABOVE_HUD_PLANE)
	hover_image.plane = GAME_PLANE_UPPER
	hover_image.pixel_y = 40

	var/bar_progress = round((smasher.progress / smasher.needed_progress) * 100, 5)
	var/image/progress_overlay = image(icon = 'icons/effects/progressbar.dmi', icon_state = "prog_bar_[bar_progress]")
	progress_overlay.pixel_y = 38
	hover_image.overlays += progress_overlay

	var/queue_len = length(smasher.anvil_recipes_to_craft)
	if(queue_len > 1)
		var/x_offset = 24
		var/alpha_value = 255
		for(var/i in 2 to queue_len)
			alpha_value *= 0.7
			var/datum/anvil_recipe/queued_recipe = smasher.anvil_recipes_to_craft[i]
			var/obj/item/queued_product = queued_recipe.created_item
			var/image/queue_icon = image(icon = initial(queued_product.icon), icon_state = initial(queued_product.icon_state))
			queue_icon.pixel_x = x_offset
			queue_icon.pixel_y = 0
			queue_icon.alpha = alpha_value
			hover_image.overlays += queue_icon
			x_offset += 24

	return hover_image

/datum/hover_data/orphan_smasher/setup_data(atom/source, mob/enterer)
	if(!enterer.client)
		return
	var/image/hover_image = build_image(source)
	if(!hover_image)
		return
	add_client_image(hover_image, enterer.client)

/obj/structure/orphan_smasher
	name = "auto anvil"
	desc = "A holy amalgamation of buttons and levers built purposely to fulfill Malum's will."

	icon = 'icons/obj/autosmithy.dmi'
	icon_state = "1"
	rotation_structure = TRUE
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_LEFT | CONN_DIR_FLIP | CONN_DIR_Z_DOWN

	var/list/anvil_recipes_to_craft = list()
	var/list/completed_items = list()

	var/datum/anvil_recipe/current
	var/list/current_requirements = list()

	var/obj/structure/material_bin/bin

	var/working = FALSE
	var/bloodied = FALSE

	var/progress = 0
	var/needed_progress = 100

	var/static/list/regular_recipes = list()
	var/static/list/gib_sounds = list('sound/combat/gib (1).ogg', 'sound/combat/gib (2).ogg')

	var/list/step_list = list()

	var/list/pre_start_list = list(STEP_FIDDLE, STEP_BUTTON, STEP_LEVER)
	var/list/post_start_list = list(STEP_BUTTON, STEP_LEVER, STEP_FIDDLE)

/obj/structure/orphan_smasher/Initialize()
	. = ..()
	var/turf/turf = get_step(src, EAST)
	bin = new /obj/structure/material_bin(turf)
	bin.parent = src
	LAZYINITLIST(regular_recipes)
	if(!length(regular_recipes))
		for(var/datum/anvil_recipe/recipe_path as anything in subtypesof(/datum/anvil_recipe))
			if(IS_ABSTRACT(recipe_path))
				continue
			regular_recipes |= new recipe_path

	AddComponent(/datum/component/hovering_information, /datum/hover_data/orphan_smasher)
	START_PROCESSING(SSobj, src)

/obj/structure/orphan_smasher/Destroy()
	if(current)
		QDEL_NULL(current)
	for(var/datum/anvil_recipe/recipe as anything in regular_recipes)
		LAZYREMOVE(regular_recipes, recipe)
		QDEL_NULL(recipe)
	QDEL_NULL(bin)
	current_requirements.Cut()
	anvil_recipes_to_craft.Cut()
	completed_items.Cut()
	return ..()

/obj/structure/orphan_smasher/examine(mob/user)
	. = ..()
	var/next_step
	if(!working)
		next_step = pre_start_list[length(step_list) + 1]
		. += span_notice("[src] is currently OFF.")
	else
		next_step = post_start_list[length(step_list) + 1]
		. += span_notice("[src] is currently ON.")
	switch(next_step)
		if(STEP_FIDDLE)
			. += span_notice("To toggle the machine, use RMB.")
		if(STEP_BUTTON)
			. += span_notice("To toggle the machine, use Ctrl+Click.")
		if(STEP_LEVER)
			. += span_notice("To toggle the machine, use MMB.")

/obj/structure/orphan_smasher/process()
	if(!working)
		return
	if(!length(anvil_recipes_to_craft))
		return
	try_set_recipe_stuff()

	if(current.rotations_required > rotations_per_minute)
		return

	if(!materials_satisfied())
		return

	progress += 5 * (rotations_per_minute / 16)
	if(progress >= needed_progress)
		create_current()

/obj/structure/orphan_smasher/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(!working)
		return

	if(!istype(I, /obj/item/grabbing))
		return
	var/obj/item/grabbing/grab = I
	var/mob/living/carbon/victim = grab.grabbed
	if(!istype(victim))
		return
	user.visible_message(span_danger("[user] starts to put [victim] under [src]!"), span_danger("You start to put [victim] under [src]!"))
	if(!do_after(user, 10 SECONDS, src))
		return

	victim.apply_damage(10 * (rotations_per_minute / 8), BRUTE, BODY_ZONE_HEAD, damage_type = BCLASS_BLUNT)
	playsound(src, pick(gib_sounds), 200, FALSE, 3)
	bloodied = TRUE
	update_animation_effect()

/obj/structure/orphan_smasher/MiddleClick(mob/user, list/modifiers)
	try_step(STEP_LEVER, user)
	return TRUE

/obj/structure/orphan_smasher/CtrlClick(mob/user, list/modifiers)
	if(!user.Adjacent(src))
		return
	try_step(STEP_BUTTON, user)
	return TRUE

/obj/structure/orphan_smasher/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	try_step(STEP_FIDDLE, user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/orphan_smasher/attack_hand(mob/user)
	. = ..()
	if(!check_step_damage(user))
		return

	var/option = tgui_input_list(user, "Remove or Add a recipe?", "Recipe Queue", list("Add", "Remove"))
	if(!option)
		return

	if(option == "Add")
		var/list/options = list()
		for(var/datum/anvil_recipe/recipe as anything in regular_recipes)
			options |= recipe

		if(!length(options))
			return

		var/datum/anvil_recipe/choice = tgui_input_list(user, "Choose a recipe to add to the queue", "Add Recipe", options)
		if(!choice)
			return
		anvil_recipes_to_craft |= choice
	else
		if(!length(anvil_recipes_to_craft))
			return

		var/datum/anvil_recipe/choice = tgui_input_list(user, "Choose a recipe to remove from the queue", "Remove Recipe", anvil_recipes_to_craft)
		if(!choice)
			return
		if(choice == current)
			current = null
			progress = 0
		anvil_recipes_to_craft -= choice

/obj/structure/orphan_smasher/update_animation_effect()
	var/prefix = bloodied ? "b" : ""
	if(!rotation_network || rotation_network?.overstressed || !rotations_per_minute || !working)
		animate(src, icon_state = "[prefix]1", time = 1)
		return

	var/frame_stage = 1 / ((rotations_per_minute / 30) * 5)
	var/list/frame_order = rotation_direction == WEST ? list(1,2,3,4,5) : list(5,4,3,2,1)

	animate(src, icon_state = "[prefix][frame_order[1]]", time = frame_stage, loop = -1)
	for(var/i in 2 to length(frame_order))
		animate(icon_state = "[prefix][frame_order[i]]", time = frame_stage)

/obj/structure/orphan_smasher/set_rotations_per_minute(speed)
	. = ..()
	if(!.)
		return
	set_stress_use(128 * (speed / 8))

/// Returns TRUE if everything current_requirements calls for is currently sitting in the bin.
/obj/structure/orphan_smasher/proc/materials_satisfied()
	var/list/material_copy = current_requirements.Copy()
	for(var/atom/listed_atom in bin.contents)
		if(listed_atom.type in material_copy)
			material_copy[listed_atom.type]--
			if(material_copy[listed_atom.type] <= 0)
				material_copy -= listed_atom.type

	return !length(material_copy)

/// Deletes the materials required for current_requirements out of the bin.
/obj/structure/orphan_smasher/proc/consume_materials()
	var/list/material_copy = current_requirements.Copy()
	for(var/atom/listed_atom in bin.contents)
		if(listed_atom.type in material_copy)
			material_copy[listed_atom.type]--
			SEND_SIGNAL(bin, COMSIG_TRY_STORAGE_TAKE, listed_atom, get_turf(src), TRUE)
			qdel(listed_atom)

			if(material_copy[listed_atom.type] <= 0)
				material_copy -= listed_atom.type

/// Applies crush damage + gib sound + a visible message to user's active arm.
/obj/structure/orphan_smasher/proc/crush_user(mob/living/user, damage, self_message, others_message)
	user.apply_damage(damage, BRUTE, get_active_arm(user), damage_type = BCLASS_BLUNT)
	playsound(src, pick(gib_sounds), 200, FALSE, 3)
	user.visible_message(span_danger(others_message), span_danger(self_message))

/// Which arm zone to hit based on the user's active hand.
/obj/structure/orphan_smasher/proc/get_active_arm(mob/living/user)
	return (user.active_hand_index == 1) ? BODY_ZONE_L_ARM : BODY_ZONE_R_ARM

/obj/structure/orphan_smasher/proc/try_set_recipe_stuff()
	var/datum/anvil_recipe/first = anvil_recipes_to_craft[1]
	if(first == current)
		return

	var/list/materials = list()

	materials[first.required_material]++
	for(var/atom/atom_path as anything in first.additional_items)
		materials[atom_path] += first.additional_items[atom_path]

	current = first
	current_requirements = materials
	needed_progress = max(1, current.craftdiff) * 100

/obj/structure/orphan_smasher/proc/create_current()
	consume_materials()

	var/atom/new_atom
	for(var/i in 1 to current.output_amount)
		new_atom = new current.created_item(get_turf(bin))
		new_atom.update_integrity(new_atom.max_integrity, update_atom = FALSE)
		SEND_SIGNAL(bin, COMSIG_TRY_STORAGE_INSERT, new_atom, null, TRUE, TRUE)

	visible_message(span_notice("[new_atom] falls into the hopper of [src]."))
	anvil_recipes_to_craft -= current
	current = null
	current_requirements = list()
	progress = 0

/obj/structure/orphan_smasher/proc/check_step_damage(mob/living/user)
	if(!length(step_list))
		return TRUE

	if(working)
		crush_user(user, 15 * (rotations_per_minute / 8), \
			"You get your arm crushed by [src]!", "[user] gets their arm crushed by [src]!")
		bloodied = TRUE
		update_animation_effect()

	var/step_on = step_list[length(step_list)]

	switch(step_on)
		if(STEP_FIDDLE)
			crush_user(user, 5 * (rotations_per_minute / 8), \
				"You get your hand caught in [src]'s cogs!", "[user] gets their hand caught in [src]'s cogs!")
		if(STEP_BUTTON)
			crush_user(user, 8 * (rotations_per_minute / 8), \
				"You get your hand flattened by [src]!", "[user] gets their hand flattened by [src]!")
		if(STEP_LEVER)
			return

/obj/structure/orphan_smasher/proc/try_step(step_type, mob/living/user)
	var/next_step
	if(!working)
		next_step = pre_start_list[length(step_list) + 1]
	else
		next_step = post_start_list[length(step_list) + 1]

	if(next_step != step_type)
		crush_user(user, 4 * max(1, (rotations_per_minute / 8)), \
			"You mess with [src]!", "[user] messes with [src]!")
		step_list = list()
		return

	if(!do_after(user, 1.2 SECONDS, src))
		return

	to_chat(user, span_notice("You [step_type]."))
	step_list |= step_type

	var/list/target_list = working ? post_start_list : pre_start_list
	if(length(step_list) == length(target_list))
		working = !working
		step_list = list()
		update_animation_effect()

/obj/structure/material_bin
	name = "auto anvil hopper"
	desc = "The storage can be opened and closed with RMB."

	icon = 'icons/obj/autosmithy.dmi'
	icon_state = "material"

	var/opened = FALSE
	var/obj/structure/orphan_smasher/parent

/obj/structure/material_bin/Initialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/anvil_bin)

/obj/structure/material_bin/Destroy()
	parent = null
	return ..()

/obj/structure/material_bin/update_icon_state()
	. = ..()
	if(opened)
		icon_state = "material1"
	else
		icon_state = initial(icon_state)

/obj/structure/material_bin/attack_hand_secondary(mob/user, list/modifiers)
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	user.visible_message(span_danger("[user] starts to [opened ? "close" : "open"] [src]."), span_danger("You start to [opened ? "close" : "open"] [src]."))
	if(!do_after(user, 2.5 SECONDS, src))
		return
	opened = !opened
	update_appearance(UPDATE_ICON_STATE)
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_HIDE_ALL)

#undef STEP_FIDDLE
#undef STEP_LEVER
#undef STEP_BUTTON
