/atom/movable/screen/controller_ui/controller_button/mob_exit
	icon_state = "exit"

/atom/movable/screen/controller_ui/controller_button/mob_exit/Click(location, control, params)
	var/mob/camera/strategy_controller/controller = usr
	if(!controller || !controller.client)
		return

	// Close the current mob UI
	if(controller.displayed_mob_ui)
		controller.displayed_mob_ui.remove_ui(controller.client)
		controller.close_inventory_ui()

	// Reopen the base UI
	if(controller.displayed_base_ui)
		controller.displayed_base_ui.add_ui(controller.client)
		controller.displayed_base_ui.add_ui_buttons(controller.client)

	return TRUE

/atom/movable/screen/controller_ui/controller_button/one
	icon_state = "partial_first"

/atom/movable/screen/controller_ui/controller_button/two
	icon_state = "blank_second"

/atom/movable/screen/controller_ui/controller_button/patrol
	icon_state = "patrol"
	highlight_color = "#4CAF50"
	var/patrol_mode = FALSE
	var/atom/movable/screen/controller_ui/controller_ui/parent_ui

/atom/movable/screen/controller_ui/controller_button/patrol/Initialize(mapload, datum/hud/hud_owner, /atom/movable/screen/controller_ui/controller_ui/parent_ui)
	src.parent_ui = parent_ui
	return ..()

/atom/movable/screen/controller_ui/controller_button/patrol/Destroy(force)
	parent_ui = null
	return ..()

/atom/movable/screen/controller_ui/controller_button/patrol/Click(location, control, params)
	. = ..()
	if(!parent_ui || !parent_ui.worker_mob)
		return

	var/mob/camera/strategy_controller/controller = usr
	if(!controller)
		return

	var/mob/living/target_mob = parent_ui.worker_mob

	patrol_mode = !patrol_mode

	if(patrol_mode)
		controller.break_turf_mode = FALSE
		controller.move_structure_mode = FALSE


		if(!target_mob.controller_mind.patrol_points)
			target_mob.controller_mind.patrol_points = list()
		target_mob.controller_mind.patrol_setup_active = TRUE

		color = highlight_color
		highlighted = TRUE
		to_chat(controller, span_notice("Patrol setup mode activated for [target_mob.name]. Left click to add patrol points, right click to finish patrol setup."))

		controller.update_mob_patrol_visuals(target_mob)
	else
		target_mob.controller_mind.patrol_setup_active = FALSE
		color = null
		highlighted = FALSE
		controller.clear_mob_patrol_visuals(target_mob)
		to_chat(controller, span_notice("Patrol setup mode deactivated for [target_mob.name]."))
