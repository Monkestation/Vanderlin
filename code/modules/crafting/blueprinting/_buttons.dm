/atom/movable/screen/blueprint
	icon = 'icons/misc/buildmode.dmi'
	// If we don't do this, we get occluded by item action buttons
	plane = ABOVE_HUD_PLANE
	var/datum/blueprint_system/bd

/atom/movable/screen/blueprint/Initialize(mapload, datum/hud/hud_owner, datum/blueprint_system/blueprint_datum)
	. = ..()
	bd = blueprint_datum

/atom/movable/screen/blueprint/recipe
	name = "Recipes"
	icon_state = "buildmode_basic"
	screen_loc = "NORTH,WEST"

/atom/movable/screen/blueprint/recipe/Click()
	if(bd)
		bd.open_recipe_browser()

/atom/movable/screen/blueprint/recipe/update_name()
	. = ..()
	if(!bd || !bd.selected_recipe)
		name = "Recipes"
		return
	name = bd.selected_recipe.name

/atom/movable/screen/blueprint/direction
	name = "Direction: South"
	icon_state = "build"
	screen_loc = "NORTH,WEST+1"

/atom/movable/screen/blueprint/direction/Click()
	if(bd)
		bd.rotate_direction()

/atom/movable/screen/blueprint/direction/update_appearance()
	. = ..()
	if(!bd || !bd.selected_recipe)
		name = "Direction: None"
		color = "#666666"
		dir = SOUTH
		return

	dir = bd.build_dir
	if(!bd.selected_recipe.supports_directions)
		name = "Direction: Fixed"
		color = "#666666"
		return

	name = "Direction: [dir2text(bd.build_dir)]"
	color = "#FFFFFF"

/atom/movable/screen/blueprint/pixel_mode
	name = "Pixel Mode: OFF"
	icon_state = "template"
	screen_loc = "NORTH,WEST+2"

/atom/movable/screen/blueprint/pixel_mode/Click()
	if(bd)
		bd.toggle_pixel_positioning_mode()

/atom/movable/screen/blueprint/pixel_mode/update_appearance()
	. = ..()
	if(!bd)
		return

	if(bd.pixel_positioning_mode)
		name = "Pixel Mode: ON"
		color = "#00FFFF"
	else
		name = "Pixel Mode: OFF"
		color = "#FFFFFF"

/atom/movable/screen/blueprint/help
	name = "Help"
	icon_state = "buildhelp"
	screen_loc = "NORTH,WEST+3"

/atom/movable/screen/blueprint/help/Click()
	if(bd?.holder?.mob)
		to_chat(bd.holder.mob, {"<span class='info'>
		<b>Blueprint System Help:</b><br>
		• Left click to place blueprints<br>
		• Right click to clear selection<br>
		• Use direction button to rotate (if supported)<br>
		• Use pixel mode for precise positioning<br>
		</span>"})

/atom/movable/screen/blueprint/quit
	name = "Quit"
	icon_state = "buildquit"
	screen_loc = "NORTH,WEST+4"

/atom/movable/screen/blueprint/quit/Click()
	if(bd)
		REMOVE_TRAIT(usr, TRAIT_BLUEPRINT_VISION, TRAIT_GENERIC)
		bd.quit()

/atom/movable/blueprint_pixel_dummy
	name = "pixel positioning tracker"
	icon = 'icons/effects/alphacolors.dmi'
	icon_state = "white"
	alpha = 1
	glide_size = 1000
	plane = HUD_PLANE
	var/datum/blueprint_system/parent_blueprint
	var/skip = FALSE

/atom/movable/blueprint_pixel_dummy/Initialize(mapload, datum/blueprint_system/bs)
	. = ..()
	parent_blueprint = bs

/atom/movable/blueprint_pixel_dummy/Destroy()
	parent_blueprint = null
	return ..()

/atom/movable/blueprint_pixel_dummy/MouseMove(location, control, params)
	if(!parent_blueprint || !parent_blueprint.pixel_positioning_mode)
		return

	var/list/offsets = get_pixel_offsets_from_screenloc(params)
	if(offsets)
		parent_blueprint.pixel_x_offset = offsets["x"]
		parent_blueprint.pixel_y_offset = offsets["y"]
		parent_blueprint.update_preview_position()

/atom/movable/blueprint_pixel_dummy/MouseEntered(location, control, params)
	if(!parent_blueprint || !parent_blueprint.pixel_positioning_mode)
		return

	var/list/offsets = get_pixel_offsets_from_screenloc(params)
	if(offsets)
		parent_blueprint.pixel_x_offset = offsets["x"]
		parent_blueprint.pixel_y_offset = offsets["y"]
		parent_blueprint.update_preview_position()
