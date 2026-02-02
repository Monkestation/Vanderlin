
/atom/movable/screen/strategy_ui/controller_button/exit
	icon_state = "exit"

/atom/movable/screen/strategy_ui/controller_button/exit/Click(location, control, params)
	. = ..()
	var/mob/camera/strategy_controller/master = usr
	if(!master.linked_overlord)
		return
	var/mob/living/overlord_body = master.linked_overlord.overlord_body_ref.resolve()
	if(!overlord_body)
		return

	overlord_body.status_flags &= ~GODMODE
	overlord_body.alpha = 255
	overlord_body.visible_message(span_danger("[overlord_body] awakens from their trance, their form solidifying."))
	master.linked_overlord.owner.transfer_to(overlord_body)
	master.linked_overlord.controlling_rts = FALSE

	to_chat(master.linked_overlord.owner.current, span_notice("You return your focus to the physical realm."))


//Chunk 1
/atom/movable/screen/strategy_ui/controller_button/bottom
	icon_state = "button_4"


/atom/movable/screen/strategy_ui/controller_button/destroy
	icon_state = "break"
	highlight_color = "#ff6b6b"

/atom/movable/screen/strategy_ui/controller_button/destroy/Click(location, control, params)
	. = ..()
	var/mob/camera/strategy_controller/controller = usr
	if(!controller)
		return

	// Toggle break mode
	controller.break_turf_mode = !controller.break_turf_mode

	if(controller.break_turf_mode)
		controller.move_structure_mode = FALSE
		controller.selected_structure = null
		// Clear move button highlight
		var/atom/movable/screen/strategy_ui/controller_button/move/move_button = controller.displayed_base_ui.move
		if(move_button)
			move_button.color = null
			move_button.highlighted = FALSE

		color = highlight_color
		highlighted = TRUE
		to_chat(controller, span_notice("Break turf mode activated. Left click to break single turf, shift+left click to select area. Right click to cancel break orders."))
	else
		controller.break_start_turf = null
		color = null
		highlighted = FALSE
		to_chat(controller, span_notice("Break turf mode deactivated."))

/atom/movable/screen/strategy_ui/controller_button/move
	icon_state = "move"
	highlight_color = "#6b9eff"

/atom/movable/screen/strategy_ui/controller_button/move/Click(location, control, params)
	. = ..()
	var/mob/camera/strategy_controller/controller = usr
	if(!controller)
		return

	// Toggle move mode
	controller.move_structure_mode = !controller.move_structure_mode

	if(controller.move_structure_mode)
		controller.break_turf_mode = FALSE
		controller.break_start_turf = null
		controller.selected_structure = null
		// Clear break button highlight
		var/atom/movable/screen/strategy_ui/controller_button/destroy/break_button = controller.displayed_base_ui.destroy
		if(break_button)
			break_button.color = null
			break_button.highlighted = FALSE

		color = highlight_color
		highlighted = TRUE
		to_chat(controller, span_notice("Move structure mode activated. Left click a structure to select, then click destination. Right click to cancel."))
	else
		if(controller.selected_structure)
			controller.selected_structure.color = null
		controller.selected_structure = null
		color = null
		highlighted = FALSE
		to_chat(controller, span_notice("Move structure mode deactivated."))
//Chunk 2

/atom/movable/screen/strategy_ui/controller_button/decor
	icon_state = "decor"

	buildings = list(
		/datum/building_datum/simple/wall,
		/datum/building_datum/simple/floor,
		/datum/building_datum/simple/church_floor,
		/datum/building_datum/simple/wall_skull,
	)

/atom/movable/screen/strategy_ui/controller_button/builds
	icon_state = "builds"

	buildings = list(
		/datum/building_datum/overlord_phylactery,
		/datum/building_datum/farm,
		/datum/building_datum/bar,
		/datum/building_datum/kitchen,
		/datum/building_datum/stockpile,
		/datum/building_datum/lumber_yard,
		/datum/building_datum/blacksmith,
		/datum/building_datum/mines,
		/datum/building_datum/spawning_grounds,

	)

/atom/movable/screen/strategy_ui/controller_button/traps
	icon_state = "traps"

	buildings = list(
		/datum/building_datum/simple/flame,
		/datum/building_datum/simple/poison,
		/datum/building_datum/simple/chill,
		/datum/building_datum/simple/wall_fire,
		/datum/building_datum/simple/wall_arrow,
		/datum/building_datum/simple/saw,
		/datum/building_datum/simple/bomb,
		/datum/building_datum/simple/spike,
		/datum/building_datum/simple/spawner,
	)

/atom/movable/screen/strategy_ui/controller_button/Click(location, control, params)
	. = ..()
	if(length(buildings))
		var/mob/camera/strategy_controller/controller = usr
		controller.building_icon.open_ui(controller, buildings)
