GLOBAL_LIST_EMPTY(armor_item_usage)

/**
 * Scans every /obj/item subtype and groups them by their initial armor_type var.
 * This walks every item type in the game, so it's deliberately opt-in and cached because I genuinely do not see it being worth the cost normally
 */
/proc/build_armor_item_usage_cache()
	if(length(GLOB.armor_item_usage))
		return
	var/list/usage = list()
	for(var/item_type in subtypesof(/obj/item))
		var/armor_path = initial(item_type:armor_type)
		if(!armor_path)
			continue
		var/key = "[armor_path]"
		if(!usage[key])
			usage[key] = list()
		usage[key] += "[item_type]"
	GLOB.armor_item_usage = usage

/datum/armor_compare_menu

/datum/armor_compare_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/armor_compare_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ArmorCompare", "Armor Comparison")
		ui.open()

/datum/armor_compare_menu/ui_data(mob/user)
	var/list/data = list()
	var/usage = FALSE
	if(length(GLOB.armor_item_usage))
		usage = TRUE
	data["usage_built"] = usage
	if(usage)
		data["item_usage"] = GLOB.armor_item_usage
	return data

/datum/armor_compare_menu/ui_static_data(mob/user)
	var/list/data = list()
	var/list/armor_list = list()

	for(var/type in GLOB.armor_by_type)
		var/datum/armor/armor = GLOB.armor_by_type[type]
		armor_list += list(list(
			"type" = "[type]",
			"armor_class" = ac2string(armor.armor_class),
			"blunt" = armor.get_rating(BLUNT),
			"slash" = armor.get_rating(SLASH),
			"stab" = armor.get_rating(STAB),
			"piercing" = armor.get_rating(PIERCE),
			"fire" = armor.get_rating(FIRE),
			"acid" = armor.get_rating(ACID),
			"magic" = armor.get_rating(MAGIC),
			"wound" = armor.get_rating(WOUND),
			"slash_ep" = armor.get_edge_protection(SLASH),
			"stab_ep" = armor.get_edge_protection(STAB),
			"piercing_ep" = armor.get_edge_protection(PIERCE),
		))

	data["armors"] = armor_list
	return data


/datum/armor_compare_menu/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("build_usage")
			if(length(GLOB.armor_item_usage))
				return
			build_armor_item_usage_cache()
			. = TRUE

/client/proc/view_armor_compare()
	set name = "View Armor Comparison"
	set category = "Debug"
	set desc = "Opens a tgui panel to browse and compare every armor datum in the game"

	var/datum/armor_compare_menu/menu = new
	menu.ui_interact(mob)
