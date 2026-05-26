/atom/movable/screen/gnome_panel
	icon = 'icons/hud/radial_pets.dmi'
	plane = ABOVE_HUD_PLANE
	no_over_text = FALSE
	var/datum/gnome_command_panel/panel

/atom/movable/screen/gnome_panel/Initialize(mapload, datum/hud/hud_owner, datum/gnome_command_panel/gcp, col, row)
	. = ..()
	panel = gcp
	screen_loc = GNOME_PANEL_LOC(col, row)
	var/mutable_appearance/bg = mutable_appearance('icons/hud/radial.dmi', "radial_thaum_focus")
	bg.appearance_flags = RESET_COLOR | RESET_ALPHA
	underlays += bg

/atom/movable/screen/gnome_panel/proc/is_pending(mode)
	return panel?.waypoint_pending == mode

/atom/movable/screen/gnome_panel/update_appearance()
	. = ..()
	// Dim everything while a placement is active; active button overrides below
	alpha = (panel?.waypoint_pending != GNOME_WP_NONE) ? 160 : 255

/atom/movable/screen/gnome_panel/transport
	name = "Toggle Transport"
	icon_state = "move-item"

/atom/movable/screen/gnome_panel/transport/Click()
	if(panel) panel.cmd_toggle_transport()

/atom/movable/screen/gnome_panel/transport/update_appearance()
	. = ..()
	var/on = panel?.gnome?.ai_controller?.blackboard[BB_GNOME_TRANSPORT_MODE]
	name = "Transport: [on ? "ON" : "OFF"]"
	color = on ? "#00FF88" : "#AAAAAA"

/atom/movable/screen/gnome_panel/farming
	name = "Toggle Farming"
	icon_state = "tend"

/atom/movable/screen/gnome_panel/farming/Click()
	if(panel) panel.cmd_toggle_farming()

/atom/movable/screen/gnome_panel/farming/update_appearance()
	. = ..()
	var/on = panel?.gnome?.ai_controller?.blackboard[BB_GNOME_CROP_MODE]
	name = "Farming: [on ? "ON" : "OFF"]"
	color = on ? "#55FF55" : "#AAAAAA"

/atom/movable/screen/gnome_panel/alchemy
	name = "Toggle Alchemy"
	icon_state = "alch"

/atom/movable/screen/gnome_panel/alchemy/Click()
	if(panel) panel.cmd_toggle_alchemy()

/atom/movable/screen/gnome_panel/alchemy/update_appearance()
	. = ..()
	var/on = panel?.gnome?.ai_controller?.blackboard[BB_GNOME_ALCHEMY_MODE]
	name = "Alchemy: [on ? "ON" : "OFF"]"
	color = on ? "#CC55FF" : "#AAAAAA"

/atom/movable/screen/gnome_panel/splitter
	name = "Toggle Splitting"
	icon_state = "split"

/atom/movable/screen/gnome_panel/splitter/Click()
	if(panel) panel.cmd_toggle_splitter()

/atom/movable/screen/gnome_panel/splitter/update_appearance()
	. = ..()
	var/datum/ai_controller/c = panel?.gnome?.ai_controller
	var/on = c && (c.blackboard[BB_GNOME_SPLITTER_MODE] || c.blackboard[BB_GNOME_EXTRACTOR_MODE])
	name = "Splitter: [on ? "ON" : "OFF"]"
	color = on ? "#FF55FF" : "#AAAAAA"

/atom/movable/screen/gnome_panel/priority
	name = "Task Priority"
	icon_state = "priority"
	color = "#FFDD55"

/atom/movable/screen/gnome_panel/priority/Click()
	if(panel) panel.cmd_set_priority()

/atom/movable/screen/gnome_panel/close_panel
	name = "Close Panel"
	icon_state = "close"
	color = "#FF5555"

/atom/movable/screen/gnome_panel/close_panel/Click()
	if(panel) panel.quit()

/atom/movable/screen/gnome_panel/transport_source
	name = "Transport Source"
	icon_state = "transport-source"

/atom/movable/screen/gnome_panel/transport_source/Click()
	if(!panel) return
	if(is_pending(GNOME_WP_TRANSPORT_SOURCE))
		panel.cancel_placement_pending()
	else
		panel.begin_placement_pending(GNOME_WP_TRANSPORT_SOURCE)

/atom/movable/screen/gnome_panel/transport_source/update_appearance()
	. = ..()
	var/turf/t = panel?.gnome?.ai_controller?.blackboard[BB_GNOME_TRANSPORT_SOURCE]
	var/pending = is_pending(GNOME_WP_TRANSPORT_SOURCE)
	name = t ? "Pickup ([t.x],[t.y])" : "Set Pickup"
	color = pending ? "#FFFF00" : (t ? "#00CCFF" : "#888888")
	if(pending) alpha = 255

/atom/movable/screen/gnome_panel/transport_dest
	name = "Transport Destination"
	icon_state = "transport-drop"

/atom/movable/screen/gnome_panel/transport_dest/Click()
	if(!panel) return
	if(is_pending(GNOME_WP_TRANSPORT_DEST))
		panel.cancel_placement_pending()
	else
		panel.begin_placement_pending(GNOME_WP_TRANSPORT_DEST)

/atom/movable/screen/gnome_panel/transport_dest/update_appearance()
	. = ..()
	var/turf/t = panel?.gnome?.ai_controller?.blackboard[BB_GNOME_TRANSPORT_DEST]
	var/pending = is_pending(GNOME_WP_TRANSPORT_DEST)
	name = t ? "Drop-off ([t.x],[t.y])" : "Set Drop-off"
	color = pending ? "#FFFF00" : (t ? "#0066FF" : "#888888")
	if(pending) alpha = 255

/atom/movable/screen/gnome_panel/range_dec
	name = "Decrease Range"
	icon_state = "range-down"

/atom/movable/screen/gnome_panel/range_dec/Click()
	if(panel) panel.cmd_range_change(-1)

/atom/movable/screen/gnome_panel/range_dec/update_appearance()
	. = ..()
	var/cur = panel?.gnome?.ai_controller?.blackboard[BB_GNOME_SEARCH_RANGE] || 1
	name = "Range [cur] (-)"
	color = "#AAAAAA"

/atom/movable/screen/gnome_panel/range_inc
	name = "Increase Range"
	icon_state = "range-up"

/atom/movable/screen/gnome_panel/range_inc/Click()
	if(panel) panel.cmd_range_change(1)

/atom/movable/screen/gnome_panel/range_inc/update_appearance()
	. = ..()
	var/cur = panel?.gnome?.ai_controller?.blackboard[BB_GNOME_SEARCH_RANGE] || 1
	name = "Range [cur] (+)"
	color = "#AAAAAA"

/atom/movable/screen/gnome_panel/set_filter
	name = "Set Item Filter"
	icon_state = "filter"

/atom/movable/screen/gnome_panel/set_filter/Click()
	if(!panel) return
	if(is_pending(GNOME_WP_FILTER_TARGET))
		panel.cancel_placement_pending()
	else
		panel.begin_placement_pending(GNOME_WP_FILTER_TARGET)

/atom/movable/screen/gnome_panel/set_filter/update_appearance()
	. = ..()
	var/pending = is_pending(GNOME_WP_FILTER_TARGET)
	var/filter_count = panel?.gnome?.item_filters?.len || 0
	name = "Add Item Filter[filter_count ? " ([filter_count])" : ""]"
	color = pending ? "#FFFF00" : (filter_count ? "#FFAA00" : "#888888")
	if(pending) alpha = 255

/atom/movable/screen/gnome_panel/clear_filter
	name = "Clear Item Filter"
	icon_state = "filter-stop"

/atom/movable/screen/gnome_panel/clear_filter/Click()
	if(panel) panel.cmd_clear_filter()

/atom/movable/screen/gnome_panel/clear_filter/update_appearance()
	. = ..()
	name = "Clear Item Filters"
	color = (panel?.gnome?.item_filters?.len) ? "#FF5555" : "#555555"

/atom/movable/screen/gnome_panel/set_cauldron
	name = "Set Cauldron"
	icon_state = "cauldron"

/atom/movable/screen/gnome_panel/set_cauldron/Click()
	if(!panel) return
	if(is_pending(GNOME_WP_CAULDRON))
		panel.cancel_placement_pending()
	else
		panel.begin_placement_pending(GNOME_WP_CAULDRON)

/atom/movable/screen/gnome_panel/set_cauldron/update_appearance()
	. = ..()
	var/obj/c = panel?.gnome?.ai_controller?.blackboard[BB_GNOME_TARGET_CAULDRON]
	var/pending = is_pending(GNOME_WP_CAULDRON)
	name = c ? "Cauldron: set" : "Set Cauldron"
	color = pending ? "#FFFF00" : (c ? "#CC55FF" : "#888888")
	if(pending) alpha = 255

/atom/movable/screen/gnome_panel/set_well
	name = "Set Well"
	icon_state = "point"

/atom/movable/screen/gnome_panel/set_well/Click()
	if(!panel) return
	if(is_pending(GNOME_WP_WELL))
		panel.cancel_placement_pending()
	else
		panel.begin_placement_pending(GNOME_WP_WELL)

/atom/movable/screen/gnome_panel/set_well/update_appearance()
	. = ..()
	var/obj/w = panel?.gnome?.ai_controller?.blackboard[BB_GNOME_TARGET_WELL]
	var/pending = is_pending(GNOME_WP_WELL)
	name = w ? "Well: set" : "Set Well"
	color = pending ? "#FFFF00" : (w ? "#4488FF" : "#888888")
	if(pending) alpha = 255

/atom/movable/screen/gnome_panel/set_bottle
	name = "Set Bottle Storage"
	icon_state = "bottle-source"

/atom/movable/screen/gnome_panel/set_bottle/Click()
	if(!panel) return
	if(is_pending(GNOME_WP_BOTTLE))
		panel.cancel_placement_pending()
	else
		panel.begin_placement_pending(GNOME_WP_BOTTLE)

/atom/movable/screen/gnome_panel/set_bottle/update_appearance()
	. = ..()
	var/turf/b = panel?.gnome?.ai_controller?.blackboard[BB_GNOME_BOTTLE_STORAGE]
	var/pending = is_pending(GNOME_WP_BOTTLE)
	name = b ? "Bottles ([b.x],[b.y])" : "Set Bottle Spot"
	color = pending ? "#FFFF00" : (b ? "#AAFFAA" : "#888888")
	if(pending) alpha = 255

/atom/movable/screen/gnome_panel/recipe
	name = "Set Alchemy Recipe"
	icon_state = "recipe"

/atom/movable/screen/gnome_panel/recipe/Click()
	if(panel) panel.cmd_choose_recipe()

/atom/movable/screen/gnome_panel/recipe/update_appearance()
	. = ..()
	var/recipe_path = panel?.gnome?.ai_controller?.blackboard[BB_GNOME_CURRENT_RECIPE]
	if(recipe_path)
		var/datum/alch_cauldron_recipe/tmp = new recipe_path
		name = tmp.recipe_name
		qdel(tmp)
		color = "#CC55FF"
	else
		name = "No Recipe"
		color = "#888888"

/atom/movable/screen/gnome_panel/set_splitter_source
	name = "Set Splitting Item Source"
	icon_state = "transport-source"

/atom/movable/screen/gnome_panel/set_splitter_source/Click()
	if(!panel) return
	if(is_pending(GNOME_WP_SPLITTER_SOURCE))
		panel.cancel_placement_pending()
	else
		panel.begin_placement_pending(GNOME_WP_SPLITTER_SOURCE)

/atom/movable/screen/gnome_panel/set_splitter_source/update_appearance()
	. = ..()
	var/turf/s = panel?.gnome?.ai_controller?.blackboard[BB_GNOME_SPLITTER_SOURCE]
	var/pending = is_pending(GNOME_WP_SPLITTER_SOURCE)
	name = s ? "Source ([s.x],[s.y])" : "Set Source"
	color = pending ? "#FFFF00" : (s ? "#FF55FF" : "#888888")
	if(pending) alpha = 255

/atom/movable/screen/gnome_panel/set_splitter_mach
	name = "Set Splitter/Extractor"
	icon_state = "split"

/atom/movable/screen/gnome_panel/set_splitter_mach/Click()
	if(!panel) return
	if(is_pending(GNOME_WP_SPLITTER_MACH))
		panel.cancel_placement_pending()
	else
		panel.begin_placement_pending(GNOME_WP_SPLITTER_MACH)

/atom/movable/screen/gnome_panel/set_splitter_mach/update_appearance()
	. = ..()
	var/datum/ai_controller/c = panel?.gnome?.ai_controller
	var/obj/mach = c ? (c.blackboard[BB_GNOME_TARGET_SPLITTER] || c.blackboard[BB_GNOME_TARGET_EXTRACTOR]) : null
	var/pending = is_pending(GNOME_WP_SPLITTER_MACH)
	name = mach ? mach.name : "Set Machine"
	color = pending ? "#FFFF00" : (mach ? "#FF55FF" : "#888888")
	if(pending) alpha = 255
