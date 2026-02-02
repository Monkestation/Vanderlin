GLOBAL_VAR(lordprimary)
GLOBAL_VAR(lordsecondary)

// Both can be used on structures
/// Uses lordprimary as the main color
#define LORD_PRIMARY (1<<0)
/// Uses lordsecondary as the main color
#define LORD_SECONDARY (1<<2)
/// Clothing only, updates detail color and handles the rest by updating overlays
#define LORD_DETAIL_AND_COLOR (1<<3)

// I HATE THIS ALL AND I REWROTE IT

/obj/proc/lordcolor()
	SIGNAL_HANDLER

	if(uses_lord_coloring & LORD_PRIMARY)
		color = GLOB.lordprimary
	if(uses_lord_coloring & LORD_SECONDARY)
		color = GLOB.lordsecondary

	UnregisterSignal(SSdcs, COMSIG_LORD_COLORS_SET)

/obj/structure/lordcolor()
	var/used_layer = -(layer + 0.1)
	var/mutable_appearance/M
	if(uses_lord_coloring & LORD_PRIMARY)
		M = mutable_appearance(icon, "[icon_state]_primary", used_layer)
		M.color = GLOB.lordprimary
		add_overlay(M)
	if(uses_lord_coloring & LORD_SECONDARY)
		M = mutable_appearance(icon, "[icon_state]_secondary", used_layer)
		M.color = GLOB.lordsecondary
		add_overlay(M)
	UnregisterSignal(SSdcs, COMSIG_LORD_COLORS_SET)

/obj/structure/chair/bench/couch/lordcolor()
	if(uses_lord_coloring & LORD_PRIMARY)
		set_greyscale(list(GLOB.lordprimary))
	if(uses_lord_coloring & LORD_SECONDARY)
		set_greyscale(list(GLOB.lordsecondary))
	UnregisterSignal(SSdcs, COMSIG_LORD_COLORS_SET)

/obj/item/lordcolor()
	if(!get_detail_tag())
		return ..()

	if(uses_lord_coloring & LORD_PRIMARY)
		detail_color = GLOB.lordprimary
	if(uses_lord_coloring & LORD_SECONDARY)
		detail_color = GLOB.lordsecondary

	if(uses_lord_coloring & LORD_DETAIL_AND_COLOR)
		if(uses_lord_coloring & LORD_PRIMARY)
			color = GLOB.lordsecondary
		if(uses_lord_coloring & LORD_SECONDARY)
			color = GLOB.lordprimary

	update_appearance(UPDATE_OVERLAYS)

	if(ismob(loc) && isclothing(src))
		var/mob/M = loc
		M.update_clothing(slot_flags)

	UnregisterSignal(SSdcs, COMSIG_LORD_COLORS_SET)

/turf/open/floor/carpet/lord/proc/lordcolor()
	SIGNAL_HANDLER

	var/mutable_appearance/M = mutable_appearance(icon, "[icon_state]_primary", -(layer+0.1))
	M.color = GLOB.lordprimary
	add_overlay(M)

	UnregisterSignal(SSdcs, COMSIG_LORD_COLORS_SET)

/mob/living/carbon/human/proc/lord_color_choice()
	if(!client)
		addtimer(CALLBACK(src, PROC_REF(lord_color_choice)), 5 SECONDS)
		return
	var/list/lordcolors = list(
		"PURPLE"="#865c9c",
		"RED"="#8f3636",
		"BLACK"="#2f352f",
		"BROWN"="#685542",
		"GREEN"="#58793f",
		"BLUE"="#395480",
		"YELLOW"="#b5b004",
		"TEAL"="#249589",
		"WHITE"="#c7c0b5",
		"ORANGE"="#b47011",
		"MAJENTA"="#822b52",
	)
	var/choice = browser_input_list(src, "Choose a Primary Color", "VANDERLIN", lordcolors)
	if(!choice)
		if(!client)
			addtimer(CALLBACK(src, PROC_REF(lord_color_choice)), 5 SECONDS)
			return
		choice = pick(lordcolors)
		return
	GLOB.lordprimary = lordcolors[choice]
	lordcolors -= choice
	choice = browser_input_list(src, "Choose a Secondary Color", "VANDERLIN", lordcolors)
	if(!choice)
		choice = pick(lordcolors)
		return
	GLOB.lordsecondary = lordcolors[choice]

	SEND_GLOBAL_SIGNAL(COMSIG_LORD_COLORS_SET)
