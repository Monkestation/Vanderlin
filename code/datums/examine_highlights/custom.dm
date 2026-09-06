GLOBAL_LIST_EMPTY(examine_highlight_editors) // item ref -> /datum/examine_highlight_editor

/obj/item/proc/ui_interact_examine_highlight(mob/user)
	var/datum/examine_highlight_editor/editor = GLOB.examine_highlight_editors[src]
	if(!editor)
		editor = new(src)
	editor.ui_interact(user)

/datum/examine_highlight/custom

/datum/examine_highlight_editor
	var/obj/item/target
	var/pending_color

/datum/examine_highlight_editor/New(obj/item/I)
	. = ..()
	target = I
	GLOB.examine_highlight_editors[target] = src
	RegisterSignal(target, COMSIG_QDELETING, PROC_REF(on_target_deleted))

/datum/examine_highlight_editor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ExamineHighlightEditor")
		ui.open()

/datum/examine_highlight_editor/Destroy()
	if(target)
		UnregisterSignal(target, COMSIG_QDELETING)
		GLOB.examine_highlight_editors -= target
		target = null
	return ..()

/datum/examine_highlight_editor/proc/on_target_deleted()
	SIGNAL_HANDLER
	qdel(src)

/datum/examine_highlight_editor/ui_state(mob/user)
	return GLOB.always_state

/datum/examine_highlight_editor/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/examine_highlight_editor/ui_data(mob/user)
	if(!target)
		return list()
	var/list/data = list()
	var/datum/examine_highlight/custom/H = target.examine_highlight_type
	var/is_custom = istype(H)
	data["adjective"] = is_custom ? H.adjective : ""
	data["leader"] = is_custom ? H.leader : "It is "
	data["explanation"] = is_custom ? H.explanation : ""
	data["color"] = pending_color || (is_custom ? H.color : "#c43535")
	data["symbol"] = is_custom ? H.symbol : ""
	data["desc"] = target.examine_highlight_desc || ""
	data["is_custom"] = is_custom
	return data

/datum/examine_highlight_editor/ui_act(action, list/params, mob/user)
	. = ..()
	if(. || !target)
		return
	switch(action)
		if("set_highlight")
			var/adjective = trim(copytext(params["adjective"], 1, 33))
			var/leader = copytext(params["leader"], 1, 21)
			var/explanation = sanitize(params["explanation"], MAX_MESSAGE_LEN, FALSE)
			var/symbol = copytext(params["symbol"], 1, )
			var/desc = trim(copytext(params["desc"], 1, 2048))
			target.set_custom_examine_highlight(adjective, leader, explanation, pending_color || "#c43535", symbol, desc)
			. = TRUE
		if("pick_color")
			var/datum/examine_highlight/custom/H = target.examine_highlight_type
			var/current = istype(H) ? H.color : (pending_color || "#c43535")
			var/new_color = input(user, "Choose a highlight color") as color|null
			if(new_color)
				pending_color = new_color
			. = TRUE
		if("clear_highlight")
			target.clear_custom_examine_highlight()
			pending_color = null
			. = TRUE
