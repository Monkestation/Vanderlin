/mob/camera/evolution_picker
	name = "evolution viewer"
	real_name = "evolution viewer"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x"
	invisibility = INVISIBILITY_ABSTRACT
	see_in_dark = 8
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/mob/living/simple_animal/hostile/retaliate/meatvine/evolving_mob
	var/obj/structure/meatvine/papameat/papa_meat
	var/list/obj/screen/evolution_choice/evolution_buttons = list()
	var/list/obj/screen/evolution_choice/future_preview_buttons = list()

/mob/camera/evolution_picker/Destroy()
	cleanup_evolution_screen()
	return ..()

/mob/camera/evolution_picker/proc/show_evolution_options()
	if(!evolving_mob || !evolving_mob.client)
		qdel(src)
		return

	var/client/C = evolving_mob.client
	var/list/available_evos = evolving_mob.possible_evolutions

	var/total_choices = length(available_evos)
	var/start_x = 8 - (total_choices * 2)

	for(var/i = 1 to total_choices)
		var/evolution_path = available_evos[i]

		var/obj/screen/evolution_choice/button = new()
		button.evolution_path = evolution_path
		button.available = TRUE
		button.picker = src
		var/button_x = start_x + (i * 3)
		button.screen_loc = "[button_x],7"
		button.button_x_position = button_x  // Store the x position

		button.update_appearance()

		evolution_buttons += button
		C.screen += button

	add_prerequisite_display(C)

/mob/camera/evolution_picker/proc/add_prerequisite_display(client/C)
	// Display the current mob below the evolution choices
	var/mob_type = evolving_mob.type
	if(mob_type && mob_type != /mob/living/simple_animal/hostile/retaliate/meatvine)
		var/obj/screen/evolution_choice/current_preview = new()
		current_preview.evolution_path = mob_type
		current_preview.available = FALSE
		current_preview.picker = src
		current_preview.screen_loc = "8,4"  // Centered below current choices
		current_preview.color = "#555555"
		current_preview.alpha = 200

		current_preview.update_appearance()

		evolution_buttons += current_preview
		C.screen += current_preview


/mob/camera/evolution_picker/proc/show_future_evolutions(evolution_path, hovered_button_x)
	if(!evolving_mob?.client)
		return

	hide_future_evolutions()

	var/client/C = evolving_mob.client

	// Build the entire evolution chain for this path
	var/list/evolution_tiers = list()
	var/list/current_tier = list(evolution_path)
	evolution_tiers += list(current_tier)

	// Keep going until we find no more evolutions
	while(length(current_tier))
		var/list/next_tier = list()

		for(var/mob/living/simple_animal/hostile/retaliate/meatvine/temp_mob as anything in current_tier)
			if(!(temp_mob in GLOB.putrid_evolutions))
				GLOB.putrid_evolutions |= temp_mob
				var/mob/living/simple_animal/hostile/retaliate/meatvine/real = new temp_mob(get_turf(src))
				GLOB.putrid_evolutions[temp_mob] = real.possible_evolutions.Copy()
				qdel(real)

			var/list/future_evos = GLOB.putrid_evolutions[temp_mob]
			if(length(future_evos))
				next_tier += future_evos

		if(length(next_tier))
			evolution_tiers += list(next_tier)
			current_tier = next_tier
		else
			break

	// Now display each tier above the previous one
	var/y_pos = 9
	var/previous_tier_center = hovered_button_x

	for(var/list/tier in evolution_tiers)
		var/total_in_tier = length(tier)
		var/tier_start_x

		if(total_in_tier == 1)
			tier_start_x = previous_tier_center
		else if(total_in_tier % 2 == 0)
			tier_start_x = previous_tier_center - (total_in_tier / 2.0 * 2.5) + 1.25
		else
			tier_start_x = previous_tier_center - (floor(total_in_tier / 2.0) * 2.5)

		for(var/i = 1 to total_in_tier)
			var/evo_path = tier[i]
			var/obj/screen/evolution_choice/preview = new()
			preview.evolution_path = evo_path
			preview.available = FALSE
			preview.picker = src
			preview.screen_loc = "[tier_start_x + ((i - 1) * 2.5)],[y_pos]"
			preview.color = "#555555"
			preview.alpha = 200

			preview.update_appearance()

			future_preview_buttons += preview
			C.screen += preview

		// Calculate center of this tier for the next tier to use
		if(total_in_tier == 1)
			previous_tier_center = tier_start_x
		else
			previous_tier_center = tier_start_x + ((total_in_tier - 1) * 2.5) / 2

		y_pos += 2  // Move up for next tier

/mob/camera/evolution_picker/proc/hide_future_evolutions()
	if(!evolving_mob?.client)
		return

	var/client/C = evolving_mob.client
	for(var/obj/screen/evolution_choice/button in future_preview_buttons)
		C.screen -= button
		qdel(button)
	future_preview_buttons.Cut()

/mob/camera/evolution_picker/proc/cleanup_evolution_screen()
	hide_future_evolutions()

	if(evolving_mob?.client)
		for(var/obj/screen/evolution_choice/button in evolution_buttons)
			evolving_mob.client.screen -= button
			qdel(button)
	evolution_buttons.Cut()

/mob/camera/evolution_picker/proc/select_evolution(evolution_path)
	if(!evolving_mob || !papa_meat)
		qdel(src)
		return

	cleanup_evolution_screen()

	var/mob/new_mob = apply_evolution(evolution_path)

	if(new_mob && evolving_mob.client)
		evolving_mob.client.eye = null
		new_mob.client?.eye = new_mob

	qdel(src)

/mob/camera/evolution_picker/proc/apply_evolution(evolution_path)
	var/turf/spawn_loc = get_turf(papa_meat)
	var/mob/living/new_mob = new evolution_path(spawn_loc)

	if(evolving_mob.client)
		evolving_mob.mind.transfer_to(new_mob, TRUE)

	if(istype(new_mob, /mob/living/simple_animal/hostile/retaliate/meatvine))
		var/mob/living/simple_animal/hostile/retaliate/meatvine/new_vine = new_mob
		new_vine.evolution_progress = 0
		new_vine.master = evolving_mob.master

	if(istype(new_mob, /mob/living/simple_animal/hostile/retaliate/meatvine))
		var/mob/living/simple_animal/hostile/retaliate/meatvine/new_vine = new_mob
		new_vine.incorporeal_move = 0
	new_mob.density = TRUE
	new_mob.invisibility = 0

	papa_meat.visible_message(span_danger("[papa_meat] bulges and births a transformed creature!"))

	to_chat(new_mob, span_nicegreen("You have evolved into [new_mob.name]!"))

	qdel(evolving_mob)

	var/datum/hud/putrid/new_hud = new_mob.hud_used
	new_hud?.setup_mob()

	return new_mob

/obj/screen/evolution_choice
	name = "Evolution Choice"
	icon = 'icons/obj/cellular/putrid_abilities.dmi'
	icon_state = "button_bg"
	plane = HUD_PLANE

	var/evolution_path
	var/available = TRUE
	var/mob/camera/evolution_picker/picker
	var/button_x_position

/obj/screen/evolution_choice/Initialize()
	. = ..()
	update_appearance()

/obj/screen/evolution_choice/update_name()
	. = ..()
	if(evolution_path)
		var/mob/living/temp = evolution_path
		name = initial(temp.name)

/obj/screen/evolution_choice/update_desc()
	. = ..()
	if(evolution_path)
		var/mob/living/temp = evolution_path
		desc = initial(temp.desc)

	if(!available)
		desc += "\n<span class='warning'>This evolution is not yet available.</span>"

/obj/screen/evolution_choice/update_overlays()
	. = ..()
	if(evolution_path)
		var/mob/living/simple_animal/temp = evolution_path
		. += mutable_appearance(initial(temp.icon), initial(temp.icon_state))


/obj/screen/evolution_choice/Click()
	if(!available)
		to_chat(usr, span_warning("This evolution is not available!"))
		return

	if(!picker)
		return

	picker.select_evolution(evolution_path)

/obj/screen/evolution_choice/MouseEntered(location, control, params)
	. = ..()
	if(available)
		transform = matrix() * 1.1
		picker?.show_future_evolutions(evolution_path, button_x_position)

/obj/screen/evolution_choice/MouseExited()
	. = ..()
	if(available)
		transform = matrix()
		picker?.hide_future_evolutions()
