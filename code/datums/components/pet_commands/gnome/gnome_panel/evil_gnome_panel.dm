/datum/gnome_command_panel
	var/client/holder
	var/mob/living/simple_animal/hostile/gnome_homunculus/gnome
	var/list/buttons = list()
	var/li_cb
	var/waypoint_pending = GNOME_WP_NONE
	var/datum/hover_data/gnome_status/forced_hover = null

/datum/gnome_command_panel/New(mob/living/commander, mob/living/simple_animal/hostile/gnome_homunculus/target_gnome)
	holder = commander.client
	gnome = target_gnome
	li_cb = CALLBACK(src, PROC_REF(post_login))
	holder.player_details.post_login_callbacks += li_cb
	create_buttons()
	holder.screen += buttons
	RegisterSignal(gnome, COMSIG_QDELETING, PROC_REF(on_gnome_deleted))
	RegisterSignal(commander, COMSIG_MOB_LOGOUT, PROC_REF(on_logout))
	force_hover_on()

/datum/gnome_command_panel/Destroy()
	cancel_placement_pending()
	force_hover_off()
	if(holder)
		holder.screen -= buttons
		holder.player_details.post_login_callbacks -= li_cb
	if(gnome)
		UnregisterSignal(gnome, COMSIG_QDELETING)
	if(holder?.mob)
		UnregisterSignal(holder.mob, COMSIG_MOB_LOGOUT)
	gnome = null
	holder = null
	buttons.Cut()
	return ..()

/datum/gnome_command_panel/proc/quit()
	if(gnome && !QDELETED(gnome))
		gnome.command_panel = null
	qdel(src)

/datum/gnome_command_panel/proc/post_login()
	if(QDELETED(src) || !holder)
		return
	holder.screen += buttons
	force_hover_on()

/datum/gnome_command_panel/proc/on_logout()
	cancel_placement_pending()
	force_hover_off()

/datum/gnome_command_panel/proc/on_gnome_deleted()
	quit()

/datum/gnome_command_panel/proc/commander()
	return holder?.mob

/datum/gnome_command_panel/proc/force_hover_on()
	if(!gnome || QDELETED(gnome) || !holder?.mob)
		return
	force_hover_off()
	var/datum/component/hovering_information/data = gnome.GetComponent(/datum/component/hovering_information)
	forced_hover = data?.hover_information_data
	if(!forced_hover)
		return
	forced_hover.setup_data(gnome, holder.mob)

/datum/gnome_command_panel/proc/force_hover_refresh()
	if(!forced_hover || !gnome || QDELETED(gnome) || !holder?.mob)
		return
	forced_hover.clear_data(gnome, holder.mob)
	forced_hover.setup_data(gnome, holder.mob)

/datum/gnome_command_panel/proc/force_hover_off()
	if(!forced_hover || !holder?.mob)
		forced_hover = null
		return
	forced_hover.clear_data(gnome, holder.mob)
	forced_hover = null

/datum/gnome_command_panel/proc/refresh()
	for(var/atom/movable/screen/gnome_panel/btn in buttons)
		btn.update_appearance()
	force_hover_refresh()

/datum/gnome_command_panel/proc/begin_placement_pending(mode)
	waypoint_pending = mode
	if(holder)
		holder.click_intercept = src
	refresh()
	var/msg = "Click to set "
	switch(mode)
		if(GNOME_WP_TRANSPORT_SOURCE) msg += "the transport pickup location."
		if(GNOME_WP_TRANSPORT_DEST) msg += "the transport drop-off location."
		if(GNOME_WP_FILTER_TARGET) msg += "an item to add to the filter."
		if(GNOME_WP_CAULDRON) msg += "the target cauldron."
		if(GNOME_WP_WELL) msg += "the target well."
		if(GNOME_WP_BOTTLE) msg += "the bottle storage location."
		if(GNOME_WP_SPLITTER_SOURCE) msg += "the splitter item source location."
		if(GNOME_WP_SPLITTER_MACH) msg += "the splitter or extractor machine."
	to_chat(commander(), span_notice("[msg] Right-click to cancel."))

/datum/gnome_command_panel/proc/cancel_placement_pending()
	waypoint_pending = GNOME_WP_NONE
	if(holder && holder.click_intercept == src)
		holder.click_intercept = null
	refresh()

/datum/gnome_command_panel/proc/InterceptClickOn(mob/user, list/modifiers, atom/object)
	if(waypoint_pending == GNOME_WP_NONE)
		return FALSE
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		to_chat(commander(), span_notice("Cancelled."))
		cancel_placement_pending()
		return TRUE

	var/turf/target_turf = get_turf(object)
	var/datum/ai_controller/c = gnome?.ai_controller
	if(!c)
		cancel_placement_pending()
		return TRUE

	switch(waypoint_pending)
		if(GNOME_WP_TRANSPORT_SOURCE)
			c.set_blackboard_key(BB_GNOME_TRANSPORT_SOURCE, target_turf)
			gnome.visible_message(span_notice("[gnome] marks the pickup spot."))

		if(GNOME_WP_TRANSPORT_DEST)
			c.set_blackboard_key(BB_GNOME_TRANSPORT_DEST, target_turf)
			gnome.visible_message(span_notice("[gnome] marks the drop-off spot."))

		if(GNOME_WP_FILTER_TARGET)
			if(!istype(object, /obj/item))
				to_chat(commander(), span_warning("That's not an item!"))
				return TRUE
			gnome.item_filters += object.type
			gnome.visible_message(span_notice("[gnome] will now prioritize [object.name] items."))

		if(GNOME_WP_CAULDRON)
			if(!istype(object, /obj/machinery/light/fueled/cauldron))
				to_chat(commander(), span_warning("That's not a cauldron!"))
				return TRUE
			c.set_blackboard_key(BB_GNOME_TARGET_CAULDRON, object)
			gnome.visible_message(span_notice("[gnome] marks the cauldron."))

		if(GNOME_WP_WELL)
			if(!istype(object, /obj/structure/well))
				to_chat(commander(), span_warning("That's not a well!"))
				return TRUE
			c.set_blackboard_key(BB_GNOME_TARGET_WELL, object)
			gnome.visible_message(span_notice("[gnome] marks the well."))

		if(GNOME_WP_BOTTLE)
			c.set_blackboard_key(BB_GNOME_BOTTLE_STORAGE, target_turf)
			gnome.visible_message(span_notice("[gnome] marks the bottle storage spot."))

		if(GNOME_WP_SPLITTER_SOURCE)
			c.set_blackboard_key(BB_GNOME_SPLITTER_SOURCE, target_turf)
			gnome.visible_message(span_notice("[gnome] marks the splitter source."))

		if(GNOME_WP_SPLITTER_MACH)
			if(istype(object, /obj/machinery/essence/splitter))
				c.set_blackboard_key(BB_GNOME_SPLITTER_MODE, TRUE)
				c.set_blackboard_key(BB_GNOME_EXTRACTOR_MODE, FALSE)
				c.set_blackboard_key(BB_GNOME_TARGET_SPLITTER, object)
				c.clear_blackboard_key(BB_GNOME_TARGET_EXTRACTOR)
				gnome.visible_message(span_notice("[gnome] marks the splitter."))
			else if(istype(object, /obj/machinery/essence/extractor))
				c.set_blackboard_key(BB_GNOME_EXTRACTOR_MODE, TRUE)
				c.set_blackboard_key(BB_GNOME_SPLITTER_MODE, FALSE)
				c.set_blackboard_key(BB_GNOME_TARGET_EXTRACTOR, object)
				c.clear_blackboard_key(BB_GNOME_TARGET_SPLITTER)
				gnome.visible_message(span_notice("[gnome] marks the extractor."))
			else
				to_chat(commander(), span_warning("That's not a splitter or extractor!"))
				return TRUE

	cancel_placement_pending()
	return TRUE

/datum/gnome_command_panel/proc/cmd_toggle_transport()
	var/datum/ai_controller/c = gnome?.ai_controller
	if(!c) return
	if(c.blackboard[BB_GNOME_TRANSPORT_MODE])
		c.set_blackboard_key(BB_GNOME_TRANSPORT_MODE, FALSE)
		gnome.visible_message(span_notice("[gnome] stops moving items."))
	else
		if(!c.blackboard[BB_GNOME_TRANSPORT_SOURCE])
			to_chat(commander(), span_warning("Set a pickup location first!"))
			return
		if(!c.blackboard[BB_GNOME_TRANSPORT_DEST])
			to_chat(commander(), span_warning("Set a drop-off location first!"))
			return
		c.set_blackboard_key(BB_GNOME_TRANSPORT_MODE, TRUE)
		gnome.visible_message(span_notice("[gnome] begins transporting items."))
	refresh()

/datum/gnome_command_panel/proc/cmd_range_change(delta)
	var/datum/ai_controller/c = gnome?.ai_controller
	if(!c) return
	var/cur = c.blackboard[BB_GNOME_SEARCH_RANGE] || 1
	c.set_blackboard_key(BB_GNOME_SEARCH_RANGE, clamp(cur + delta, 1, 10))
	gnome.visible_message(span_notice("[gnome] nods."))
	refresh()

/datum/gnome_command_panel/proc/cmd_clear_filter()
	gnome.item_filters = list()
	gnome.visible_message(span_notice("[gnome] will now move any item."))
	refresh()

/datum/gnome_command_panel/proc/cmd_toggle_farming()
	var/datum/ai_controller/c = gnome?.ai_controller
	if(!c) return
	var/now = !c.blackboard[BB_GNOME_CROP_MODE]
	c.set_blackboard_key(BB_GNOME_CROP_MODE, now)
	gnome.visible_message(now ? span_notice("[gnome] begins tending crops!") : span_notice("[gnome] stops tending crops."))
	refresh()

/datum/gnome_command_panel/proc/cmd_choose_recipe()
	var/datum/ai_controller/c = gnome?.ai_controller
	if(!c) return
	var/list/recipe_names = list()
	var/list/recipe_paths = list()
	for(var/rpath in subtypesof(/datum/alch_cauldron_recipe))
		var/datum/alch_cauldron_recipe/r = new rpath
		recipe_names += r.recipe_name
		recipe_paths[r.recipe_name] = rpath
		qdel(r)
	var/chosen = input(commander(), "Select a recipe:", "Alchemy Recipe") as null|anything in recipe_names
	if(chosen)
		c.set_blackboard_key(BB_GNOME_CURRENT_RECIPE, recipe_paths[chosen])
		gnome.visible_message(span_notice("[gnome] commits the [chosen] recipe to memory."))
	refresh()

/datum/gnome_command_panel/proc/cmd_toggle_alchemy()
	var/datum/ai_controller/c = gnome?.ai_controller
	if(!c) return
	if(c.blackboard[BB_GNOME_ALCHEMY_MODE])
		c.set_blackboard_key(BB_GNOME_ALCHEMY_MODE, FALSE)
		gnome.visible_message(span_notice("[gnome] stops brewing."))
	else
		if(!c.blackboard[BB_GNOME_CURRENT_RECIPE])
			to_chat(commander(), span_warning("Select a recipe first!"))
			return
		if(!c.blackboard[BB_GNOME_TARGET_CAULDRON])
			to_chat(commander(), span_warning("Set a cauldron first!"))
			return
		if(!c.blackboard[BB_GNOME_TARGET_WELL])
			to_chat(commander(), span_warning("Set a well first!"))
			return
		c.set_blackboard_key(BB_GNOME_ALCHEMY_MODE, TRUE)
		gnome.visible_message(span_notice("[gnome] begins the alchemy process!"))
	refresh()

/datum/gnome_command_panel/proc/cmd_toggle_splitter()
	var/datum/ai_controller/c = gnome?.ai_controller
	if(!c) return
	var/is_on = c.blackboard[BB_GNOME_SPLITTER_MODE] || c.blackboard[BB_GNOME_EXTRACTOR_MODE]
	if(is_on)
		c.set_blackboard_key(BB_GNOME_SPLITTER_MODE, FALSE)
		c.set_blackboard_key(BB_GNOME_EXTRACTOR_MODE, FALSE)
		c.clear_blackboard_key(BB_GNOME_TARGET_SPLITTER)
		c.clear_blackboard_key(BB_GNOME_TARGET_EXTRACTOR)
		gnome.visible_message(span_notice("[gnome] stops focusing on the machine."))
	else
		if(!c.blackboard[BB_GNOME_SPLITTER_SOURCE])
			to_chat(commander(), span_warning("Set a source location first!"))
			return
		if(!c.blackboard[BB_GNOME_TARGET_SPLITTER] && !c.blackboard[BB_GNOME_TARGET_EXTRACTOR])
			to_chat(commander(), span_warning("Set a machine first!"))
			return
		gnome.visible_message(span_notice("[gnome] begins feeding the machine."))
	refresh()

/datum/gnome_command_panel/proc/cmd_set_priority()
	var/datum/ai_controller/c = gnome?.ai_controller
	if(!c) return
	var/datum/action_state_manager/manager = c.blackboard[BB_ACTION_STATE_MANAGER]
	if(!manager) return
	manager.notify_priority_change()
	var/list/active = manager.get_active_state_names(c)
	if(active.len <= 1)
		to_chat(commander(), span_notice("Nothing to reorder right now."))
		return
	var/list/labels = list(
		"transport" = "Move Items",
		"farming" = "Tend Crops",
		"alchemy" = "Brew Potions",
		"splitter" = "Feed Splitter",
	)
	var/list/display_names = list()
	var/list/display_to_state = list()
	for(var/state_name in active)
		var/label = labels[state_name] || state_name
		display_names += label
		display_to_state[label] = state_name
	var/list/ranked = list()
	var/list/remaining = display_names.Copy()
	while(remaining.len > 1)
		var/n = ranked.len + 1
		var/suffix = n == 1 ? "st" : (n == 2 ? "nd" : (n == 3 ? "rd" : "th"))
		var/chosen = input(commander(), "Pick the [n][suffix] most important task:", "Task Priority") as null|anything in remaining
		if(!chosen) break
		ranked += display_to_state[chosen]
		remaining -= chosen
	for(var/lbl in remaining)
		ranked += display_to_state[lbl]
	manager.apply_priority_ranking(c, ranked)
	gnome.visible_message(span_notice("[gnome] nods firmly."))
	to_chat(commander(), span_notice("Task priority updated."))
	refresh()

///disgusting
/datum/gnome_command_panel/proc/create_buttons()
	var/datum/hud/hud = holder?.mob?.hud_used

	// Row 0 — Transport parent
	buttons += new /atom/movable/screen/gnome_panel/transport(null, hud, src, 0, 0)
	// Row 1 — Transport children
	buttons += new /atom/movable/screen/gnome_panel/transport_source(null, hud, src, 1, 1)
	buttons += new /atom/movable/screen/gnome_panel/transport_dest(null, hud, src, 2, 1)
	buttons += new /atom/movable/screen/gnome_panel/range_dec(null, hud, src, 3, 1)
	buttons += new /atom/movable/screen/gnome_panel/range_inc(null, hud, src, 4, 1)
	buttons += new /atom/movable/screen/gnome_panel/set_filter(null, hud, src, 5, 1)
	buttons += new /atom/movable/screen/gnome_panel/clear_filter(null, hud, src, 6, 1)
	// Row 2 — Farming parent (no children needed)
	buttons += new /atom/movable/screen/gnome_panel/farming(null, hud, src, 0, 2)
	// Row 3 — Alchemy parent
	buttons += new /atom/movable/screen/gnome_panel/alchemy(null, hud, src, 0, 3)
	// Row 4 — Alchemy children
	buttons += new /atom/movable/screen/gnome_panel/set_cauldron(null, hud, src, 1, 4)
	buttons += new /atom/movable/screen/gnome_panel/set_well(null, hud, src, 2, 4)
	buttons += new /atom/movable/screen/gnome_panel/set_bottle(null, hud, src, 3, 4)
	buttons += new /atom/movable/screen/gnome_panel/recipe(null, hud, src, 4, 4)
	// Row 5 — Splitter parent
	buttons += new /atom/movable/screen/gnome_panel/splitter(null, hud, src, 0, 5)
	// Row 6 — Splitter children
	buttons += new /atom/movable/screen/gnome_panel/set_splitter_source(null, hud, src, 1, 6)
	buttons += new /atom/movable/screen/gnome_panel/set_splitter_mach(null, hud, src, 2, 6)
	// Row 7 — Priority
	buttons += new /atom/movable/screen/gnome_panel/priority(null, hud, src, 0, 7)
	// Row 8 — Close
	buttons += new /atom/movable/screen/gnome_panel/close_panel(null, hud, src, 0, 8)

/mob/living/simple_animal/hostile/gnome_homunculus
	var/datum/gnome_command_panel/command_panel = null

/mob/living/simple_animal/hostile/gnome_homunculus/proc/handle_panel(mob/living/attacker)
	if(!attacker.client)
		return
	if(command_panel)
		command_panel.quit()
	else
		command_panel = new /datum/gnome_command_panel(attacker, src)
	return

/mob/living/simple_animal/hostile/gnome_homunculus/AltClick(mob/user, list/modifiers)
	. = ..()
	var/friendship_check = SEND_SIGNAL(src, COMSIG_FRIENDSHIP_CHECK_LEVEL, user, "friend")
	if(!friendship_check)
		return
	handle_panel(user)
